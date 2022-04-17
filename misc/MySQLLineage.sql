SET @mySchema = 'skatliste';
SET @regex = '$QUAL$[^;,]*\\`?\\b$SEARCH$\\b\\`?\\.?';
SET @subject = 'sp_abrechnung_rebuild';
SET @depth = 0;

-- Create temporary lineage table
DROP TABLE IF EXISTS tmp_lineage;

CREATE TEMPORARY TABLE tmp_lineage(
	_DEPTH INT,
	_SUBJECT VARCHAR(255),
	_ACTION VARCHAR(10),
	_OBJECT VARCHAR(255),
	_TYPE VARCHAR(13),
	_DEF LONGTEXT
	);

-- Initialize lineage table with initial subject to get lineage from
INSERT INTO tmp_lineage(_DEPTH, _SUBJECT, _ACTION, _OBJECT, _TYPE)
SELECT 0 as _DEPTH, 'INIT' As _SUBJECT, 'CALL' As _ACTION, @subject As _OBJECT, 'ANY' As _TYPE
;


-- Read the next level of subjects that reference the latest objects in the lineage table
INSERT INTO tmp_lineage(_DEPTH,_SUBJECT,_ACTION,_OBJECT,_TYPE,_DEF)
WITH 
subjects As (
SELECT A._SUBJECT,	A._SCHEMA,	A._TYPE,
		REGEXP_REPLACE(REPLACE(REPLACE(A._DEF , '\r', ' '), '\n', ' '), '[[:space:]]+', ' ') As _DEF
FROM	(
		SELECT TABLE_SCHEMA As _SCHEMA, TABLE_NAME As _SUBJECT, 'VIEW' As _TYPE, VIEW_DEFINITION As _DEF
		FROM INFORMATION_SCHEMA.VIEWS	WHERE	TABLE_SCHEMA = @mySchema
		UNION
		SELECT routine_schema as _SCHEMA, routine_name as _SUBJECT,	routine_type as _TYPE, routine_definition as _DEF
		FROM information_schema.routines	WHERE	routine_schema = @mySchema
		) A
),
objects As (
SELECT TABLE_NAME As _OBJECT, 'TABLE' As _TYPE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = @mySchema UNION
SELECT TABLE_NAME As _OBJECT, 'VIEW' As _TYPE FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = @mySchema UNION
SELECT routine_name As _OBJECT, routine_type As _TYPE FROM INFORMATION_SCHEMA.ROUTINES WHERE routine_schema = @mySchema
),
actions As (
SELECT 'READ' as _ACTION, 'SELECT.*FROM' as _QUAL, 'SELECT' As _FIND, ';SELECT' As _REPLACE UNION
SELECT 'READ' as action, 'SELECT.*JOIN' as _QUAL, 'SELECT' As _FIND, ';SELECT' As _REPLACE UNION
SELECT 'CALL' as _ACTION, 'CALL' as _QUAL, '' As _FIND, '' As _REPLACE UNION
SELECT 'WRITE' as _ACTION, 'INSERT' as _QUAL, 'SELECT' As _FIND, ';SELECT' As _REPLACE UNION
SELECT 'DELETE' as _ACTION, 'TRUNCATE' as _QUAL, 'SELECT' As _FIND, ';SELECT' As _REPLACE UNION
SELECT 'DELETE' as _ACTION, 'DELETE' as _QUAL, 'SELECT' As _FIND, ';SELECT' As _REPLACE  
)
SELECT 
	@depth as _DEPTH,
	subjects._SUBJECT,
	actions._ACTION,
	objects._OBJECT,
	objects._TYPE,
	subjects._DEF
FROM subjects, objects, actions
WHERE 
	subjects._SUBJECT IN (SELECT _OBJECT FROM tmp_lineage WHERE _DEPTH = @depth -1  AND _TYPE <> 'TABLE') AND
	REPLACE(subjects._DEF, actions._FIND, actions._REPLACE) 
	REGEXP REPLACE(REPLACE(@regex, '$QUAL$', actions._QUAL),'$SEARCH$', objects._OBJECT) 

;

SELECT * FROM tmp_lineage;