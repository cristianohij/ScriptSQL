update SALDOINICIAL
   set CUSTO=0
 where QTDENTRADA=0
 
update SALDOINICIAL
   set CUSTO = round(VALENTRADA/QTDENTRADA,6)
 where VALENTRADA > 0

select *
  from SALDOINICIAL with (nolock)
 where CUSTO is null

begin tran
update SALDOINICIAL
   set CUSTO=0
 where CUSTO is null
commit tran

select count(*)
  from SALDOINICIAL with (nolock)
 where CUSTO > 0

select count(*)
  from SALDOINICIAL with (nolock)
 where ANOMES='201701'
       CUSTO=0

select ANOMES
       ,count(*)
  from SALDOINICIAL with (nolock)
 group by ANOMES
 order by ANOMES


select ANOMES
       ,count(*)
  from SALDOINICIAL with (nolock)
 where ANOMES in('201701','201801','201901','202001')
       and E1 > 0
 group by ANOMES
 order by ANOMES

select ESTLOC
       ,count(*)
  from TBS032 with (nolock)
 group by ESTLOC
 order by ESTLOC

select convert(char(6),ESTDATSAL,112)
  from SALDODIARIO with (nolock)
 where ESTLOC=1
 group by convert(char(6),ESTDATSAL,112)
 order by convert(char(6),ESTDATSAL,112)
 
select *
  from SALDODIARIO with (nolock)
 where ESTLOC=1
       and convert(char(6),ESTDATSAL,112)='201901'
 order by convert(char(6),ESTDATSAL,112)

select
   (select count(*)
      from TBS032 with (nolock)
     where ESTLOC=1
	       and ESTQTDATU > 0) atual
   ,(select count(*)
       from SIBD1217.dbo.TBS032 with (nolock)
      where ESTLOC=1
	        and ESTQTDATU > 0) x2017
   ,(select count(*)
       from SIBD1218.dbo.TBS032 with (nolock)
      where ESTLOC=1
	        and ESTQTDATU > 0) x2018
 
select count(*) '18-01-2019'
  from SALDODIARIO with (nolock)
 where ESTLOC=1
       and ESTDATSAL='20190118'
	   
select count(*) '31-12-2019'
  from SALDODIARIO with (nolock)
 where ESTLOC=1
       and ESTDATSAL='20191231'

select count(*)
  from SALDOINICIAL with (nolock)
 where ANOMES='201701'
	   and CUSTO=0

select  sum(CUSTO * case when E1 > 0 then E1 else 0 end) S1
  from SALDOINICIAL with (nolock)
 where CUSTO > 0
       and ANOMES='202001'
	   and E1 > 0
