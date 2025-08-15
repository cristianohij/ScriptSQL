SELECT OBJECT_NAME(OBJECT_ID) TableName, st.row_count,*
 FROM sys.dm_db_partition_stats st
 WHERE index_id < 2
--       and OBJECT_NAME(OBJECT_ID) Like('%BKP')
       and (OBJECT_NAME(OBJECT_ID) Like('TBS%') or OBJECT_NAME(OBJECT_ID) Like('MSL%'))
 ORDER BY st.row_count DESC

SELECT OBJECT_NAME(OBJECT_ID),* FROM sys.dm_db_partition_stats st

drop table TBS124BKP