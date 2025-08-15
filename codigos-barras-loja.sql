select M2_PROCOD,M2_CODBARDIG,count(*) from MSL002 nolock
 where M2_DAT >= '20150101' and M2_TIPREG='01' and M2_PROCOD=subString(Ltrim(M2_CODBARDIG),1,7) and Len(rtrim(M2_PROCOD))=7 and Len(Ltrim(M2_CODBARDIG))=8
 group by M2_PROCOD,M2_CODBARDIG

select M2_CODBARDIG,M2_PROCOD,PROCOD,PRODES from MSL002 (nolock) inner join TBS010 (nolock) on TBS010.PROCOD=MSL002.M2_CODBARDIG
 where MSL002.M2_PROCOD<>TBS010.PROCOD and M2_DAT >= '20150701' and M2_TIPREG='01'


--

select PROCOD,PRODES,PROCODBAR1,PROCODBAR2 from TBS010 nolock where PROCOD='8421846'

SELECT ROW_NUMBER() OVER(ORDER BY SalesYTD DESC) AS Row, 
    FirstName, LastName, ROUND(SalesYTD,2,1) AS "Sales YTD" 
FROM Sales.vSalesPerson
WHERE TerritoryName IS NOT NULL AND SalesYTD <> 0;


select top 50 PROCOD,PRODES,PROCODBAR1,PROCODBAR2,PROCODNUM,row_number() over(order by PROCOD) as SEQ
  into #PRO
  from TBS010 nolock where PROCODBAR1<>'' and PROCODBAR2<>'' and PROCOD not in('0472424','8800971')

select * from #PRO

begin tran
update TBS010 set PROCODNUM=SEQ
 from TBS010 right join #PRO on #PRO.PROCOD=TBS010.PROCOD
commit tran

select PROCOD,PRODES,PROCODBAR1,PROCODBAR2,PROCODNUM
  from TBS010 nolock where PROCODNUM > 0

select count(*)
  from TBS010 (nolock) join TBS032 (nolock) on TBS010.PROCOD=TBS032.PROCOD 
 where PROUM2<>'' and PROCODBAR2='' and TBS010.PROSTATUS='A' and ESTQTDATU>0 and ESTLOC=1

---

select PROCOD,PRODES,PROCODBAR1,PROCODBAR2 from TBS010 nolock where PROCOD='8421846'

SELECT ROW_NUMBER() OVER(ORDER BY SalesYTD DESC) AS Row, 
    FirstName, LastName, ROUND(SalesYTD,2,1) AS "Sales YTD" 
FROM Sales.vSalesPerson
WHERE TerritoryName IS NOT NULL AND SalesYTD <> 0;


select top 50 PROCOD,PRODES,PROCODBAR1,PROCODBAR2,PROCODNUM,row_number() over(order by PROCOD) as SEQ
  into #PRO
  from TBS010 nolock where PROCODBAR1<>'' and PROCODBAR2<>'' and PROCOD not in('0472424','8800971')

select * from #PRO

begin tran
update TBS010 set PROCODNUM=SEQ
 from TBS010 right join #PRO on #PRO.PROCOD=TBS010.PROCOD
commit tran

select PROCOD,PRODES,PROCODBAR1,PROCODBAR2,PROCODNUM
  from TBS010 nolock where PROCODNUM > 0
