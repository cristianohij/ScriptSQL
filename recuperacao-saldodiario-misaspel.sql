select top 1 *
  from SALDODIARIO with (nolock)
  
select top 1
       convert(char(6),ESTDATSAL,112)
	   ,*
  from SALDODIARIO with (nolock)

delete SALDODIARIO
 where ESTDATSAL <= '20161231'

select count(*)
  from SALDODIARIO with (nolock)

select year(ESTDATSAL)
       ,count(*)
  from SALDODIARIO with (nolock)
 group by year(ESTDATSAL)
 order by year(ESTDATSAL)

select *
  into SALDO2017
  from SALDODIARIO with (nolock)
 where year(ESTDATSAL) = 2017
 
select *
  into SALDO2018
  from SALDODIARIO with (nolock)
 where year(ESTDATSAL) = 2018

select *
  into SALDO2019
  from SALDODIARIO with (nolock)
 where year(ESTDATSAL) = 2019

select *
  into SALDODIARIOBKP
  from SALDODIARIO with (nolock)

delete SALDODIARIO
  where ESTDATSAL < '20191009'

select *
  from SALDODIARIO with (nolock)
 order by ESTDATSAL
   
select *
  from SALDODIARIOBKP with (nolock)
 where year(ESTDATSAL) = 2019
 order by ESTDATSAL
 
insert into SALDODIARIO
select *
  from SALDODIARIOBKP with (nolock)
 where ESTDATSAL >= '20191001'


   