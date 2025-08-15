select top(1) *
  from SALDOINICIAL with (nolock)
 where QTDENTRADA+VALENTRADA = 0
       and CUSTO > 0

update SALDOINICIAL
   set CUSTO=0
 where QTDENTRADA+VALENTRADA = 0
       and CUSTO > 0

select *
  from SALDOINICIAL with (nolock)
 where CUSTO > 0

update SALDOINICIAL
   set EMPRESA=''
 where EMPRESA<>''

select count(*)
  from SALDOINICIAL with (nolock)

select max(DATA)
  from SALDOINICIAL with (nolock)



---

declare @datai date, @dataf date, @comando varchar(50)

select @datai='20170101', @dataf='20220301'

while @datai <= @dataf
   begin
      -- n�o foi poss�vel rodar passando a vari�vel @datai diretamente como par�metro

      set @comando='exec SP_CustoMensal ''' + convert(char(6),@datai,112) + ''''
      execute(@comando)
--print @datai
      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end

update SALDOINICIAL
   set CUSTO=0


select top(1) *
  from SALDOINICIAL with (nolock)

update SALDOINICIAL
   set CUSTO=0
 where QTDENTRADA+VALENTRADA = 0
       and CUSTO > 0

update SALDOINICIAL
   set EMPRESA=''
 where EMPRESA<>''

select ANOMES
       ,CODIGO
       ,count(*)
  from SALDOINICIAL with (nolock)
 --where ANOMES > '201901'
 group by ANOMES, CODIGO
having count(*) > 1

select *
  from SALDOINICIAL with (nolock)
 where CODIGO='0060009'
 order by ANOMES, CODIGO

select * from sys.all_objects where name = 'SALDOINICIAL_BKP'

select *
  from SALDOINICIAL with (nolock)
 where QTDENTRADA=0
 order by ANOMES, CODIGO

select *
  from SALDOINICIAL with (nolock)
 where EMPRESA<>''
 order by ANOMES, CODIGO

select *
  from SALDOINICIAL with (nolock)
 where QTDENTRADA=0
       and CUSTO > 0
 order by ANOMES, CODIGO

select *
  from sysservers with (nolock)

select count(*)
  from SALDOINICIAL with (nolock)
 where CUSTO = 0
 group by CODIGO

select count(distinct CODIGO)
  from SALDOINICIAL with (nolock)
 where CUSTO = 0

select count(distinct CODIGO)
  from SALDOINICIAL with (nolock)
 where CUSTO > 0

select *
  from TBS034 with (nolock)

select *
  from TBS032 with (nolock)
 where ESTLOC=10
       and ESTQTDATU > 0


