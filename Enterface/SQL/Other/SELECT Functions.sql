SELECT [name] AS 'Function Name',
    [type_desc] AS 'Type'
FROM sys.objects
WHERE type_desc LIKE '%FUNCTION%'
order by [name];