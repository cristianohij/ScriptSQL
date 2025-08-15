declare @datade date, @dataate date

select @datade='20201005'
       ,@dataate='20201007'

drop procedure [dbo].[SP_VendasGZ]

create procedure [dbo].[SP_VendasGZ] @datade date, @dataate date
as
begin


set nocount on

declare @comando varchar(max)

set @comando = 'execute(
''select data
,ifnull(sum(valortot),0) total_bruto
,ifnull(sum(case when status=2 then valortot end),0) desconto
,ifnull(sum(case when status=4 then valortot end),0) cancelamentos
,ifnull(sum(case when status=5 then valortot end),0) acrescimo
,ifnull(sum(case when status=3 then valortot end),0) total_liquido
 from movcaixa m
 where m.data between "'+convert(char(8),@datade,112)+'" and "'+convert(char(8),@dataate,112)+'" and m.status in (2,3,4,5)
 group by data'') at MYSQLGZ'

if object_id('tempdb.dbo.#movgz') is not null
   drop table #movgz

create table #movgz (data date, total_bruto decimal(12,2), desconto decimal(12,2), cancelamentos decimal(12,2), acrescimo decimal(12,2), total_liquido decimal(12,2))
    
insert into #movgz exec(@comando)

select *
  from #movgz

end

exec SP_VendasGZ '20201005', '20201007'


