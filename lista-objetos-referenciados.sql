SELECT name, create_date, modify_date
FROM sys.procedures
WHERE OBJECT_DEFINITION(object_id) LIKE '%tt.SIBD%'
