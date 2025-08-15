SELECT DMExQryStats.last_execution_time AS [Executed At], DMExSQLTxt.text AS [Query]
,DMExQryStats.*
,DMExSQLTxt.*
FROM sys.dm_exec_query_stats AS DMExQryStats CROSS APPLY sys.dm_exec_sql_text(DMExQryStats.sql_handle) AS DMExSQLTxt
WHERE LOWER(DMExSQLTxt.text) LIKE('%DELETE%') AND LOWER(DMExSQLTxt.text) LIKE('%TBS015%')
ORDER BY DMExQryStats.last_execution_time DESC 


SELECT DISTINCT
     T.Name        
    ,User_Seeks     
    ,User_Scans     
    ,User_Lookups       
    ,User_Updates       
    ,Last_User_Seek     
    ,Last_User_Scan     
    ,Last_User_Lookup   
    ,Last_User_Update   
FROM
    sys.dm_db_index_usage_stats I 
JOIN
    sys.tables T 
ON
    T.Object_ID = I.Object_ID
WHERE
    Database_ID = DB_ID()
    and T.Name Like('TBS015%')
ORDER BY
--    Last_User_Scan DESC
    Last_User_Update DESC