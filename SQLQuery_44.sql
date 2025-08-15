SELECT 
    p.name AS ProcedureName,
    s.name AS SchemaName,
    p.create_date,
    p.modify_date
FROM 
    sys.procedures p
JOIN 
    sys.schemas s ON p.schema_id = s.schema_id
ORDER BY 
    s.name, p.name;
