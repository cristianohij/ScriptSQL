declare @comando varchar(1000)

if object_id('tempdb.dbo.#Caixas') is not null
begin 
	drop table #Caixas
end

create table #Caixas (caixa int)

insert into #Caixas

select distinct caixa from movcaixagz

set @comando = 'EXECUTE(''
select 
distinct caixa

FROM movcaixa '') at MYSQLGZ'


insert into #Caixas
exec(@comando)

select distinct caixa from #Caixas