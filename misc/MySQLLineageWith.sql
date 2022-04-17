CALL sp_lineage_rebuild_2('skatliste')
;

WITH RECURSIVE cte (_LEVEL, _SEED, _SUBJECT, _ACTION, _OBJECT, _TYPE) AS
(
  SELECT 1 As _LEVEL, _SUBJECT As _SEED, _SUBJECT, _ACTION, _OBJECT, _TYPE FROM lineage 
  WHERE _SUBJECT = 'vw_abrechnung'
  UNION ALL
  SELECT cte._LEVEL + 1, cte._SEED, cte._SUBJECT, cte._ACTION, cte._OBJECT, cte._TYPE 
  FROM cte 
  WHERE cte._SUBJECT = l._SUBJECT
)
SELECT * FROM CTE 
;
  SELECT 1 As _LEVEL, _SUBJECT As _SEED, _SUBJECT, _ACTION, _OBJECT, _TYPE FROM lineage 
  WHERE _SUBJECT = 'vw_abrechnung'
;

SELECT _SUBJECT, _ACTION, _OBJECT, _TYPE FROM lineage;

SELECT * FROM vw_lineage
WHERE _OBJECT='abrechnung'
AND _ACTION IN ('SELECT','JOIN')
;