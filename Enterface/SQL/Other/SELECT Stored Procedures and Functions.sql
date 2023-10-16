SELECT ROUTINE_NAME AS 'Routine Name',
    ROUTINE_TYPE AS 'Type'
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE IN ('PROCEDURE', 'FUNCTION')
order by [Routine Name];