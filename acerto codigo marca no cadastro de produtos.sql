select PROCOD,MARCOD from TBS010 where cast(subString(PROCOD,1,3) as smallint)<>MARCOD and Len(rtrim(PROCOD))=7 -- 29762

begin tran
update TBS010 set MARCOD=cast(subString(PROCOD,1,3) as smallint)
 where cast(subString(PROCOD,1,3) as smallint)<>MARCOD and Len(rtrim(PROCOD))=7
commit tran


select PROCOD,MARCOD from TBS010 where cast(subString(PROCOD,1,4) as smallint)<>MARCOD and Len(rtrim(PROCOD))=8 -- 598

begin tran
update TBS010 set MARCOD=cast(subString(PROCOD,1,4) as smallint)
 where cast(subString(PROCOD,1,4) as smallint)<>MARCOD and Len(rtrim(PROCOD))=8
commit tran
rollback tran