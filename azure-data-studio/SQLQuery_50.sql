if object_id('tempdb.dbo.#dir') is not null
begin
	drop table #dir
end;
go

create table #dir(arquivo varchar(300))

declare @diretorio as varchar(200)

-- /s inclui subdiretórios

set @diretorio='dir d:\documents\grm\xml\sat\tanby\taubate\2022\07-jul\*.xml /s /o:n /b'

insert into #dir exec master..xp_cmdshell @diretorio

delete #dir where arquivo is null


select * from #dir

if object_id('tempdb.dbo.#arquivo') is not null
begin
	drop table #arquivo
end;
go

-- numera as linhas da tabela

select arquivo,row_number() over(order by arquivo) as linha into #arquivo from #dir

select * from #arquivo order by linha

if object_id('tempdb.dbo.#cupons') is not null
begin
	drop table #cupons
end;
go

create table #cupons(valor numeric(10,2), doc varchar(25), extrato varchar(9), [data] date, caixa char(3))	--, chave varchar(47))
go

declare @n int, @linhas int, @arquivo varchar(300), @query varchar(5000)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas
   begin
      select @arquivo = arquivo
        from #arquivo
       where linha=@n

      set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''), X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''), X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)''), X.ide.query(''ide/dEmi'').value(''.'', ''date''), X.ide.query(''ide/numeroCaixa'').value(''.'', ''char(3)'')  FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFe/infCFe'') AS X(ide)'
      --set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'

      exec(@query)
--print @query

      set @n += 1
   end
go

select *
  from #cupons

-- cancelados

if object_id('tempdb.dbo.#cancelados') is not null
begin
	drop table #cancelados
end;
go

create table #cancelados(valor numeric(10,2), doc varchar(25), extrato varchar(9), [data] date, caixa char(3))
go

declare @n int, @linhas int, @arquivo varchar(300), @query varchar(500)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas
   begin
      select @arquivo = arquivo
        from #arquivo
       where linha=@n

      set @query = 'insert into #cancelados SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)''), X.ide.query(''ide/dEmi'').value(''.'', ''date''), X.ide.query(''ide/numeroCaixa'').value(''.'', ''char(3)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'
      exec(@query)

      set @n += 1
   end
go

select *
  from #cancelados

select caixa
       ,sum(valor)
  from #cancelados
 group by caixa
 order by caixa

-- vendas por caixa

select t.caixa
       ,t.valor
	   ,t.cancelado
       ,t.valor-t.cancelado as 'valor_liquido'
  from (	   
select caixa as 'caixa'
       ,sum(valor) as 'valor'
	   ,isnull((select sum(valor)
                  from #cancelados c
		         where c.caixa=v.caixa),0) as cancelado
  from #cupons v
 group by caixa
 ) t
order by t.caixa

-- vendas por caixa/dia

select t.[data]
       ,t.caixa
       ,t.valor
	   ,t.cancelado
       ,t.valor-t.cancelado as 'valor_liquido'
  from (	   
select [data] as 'data'
       ,caixa as 'caixa'
       ,sum(valor) as 'valor'
	   ,isnull((select sum(valor)
                  from #cancelados c
		         where c.[data]=v.[data]
				       and c.caixa=v.caixa),0) as cancelado
  from #cupons v
 group by v.[data], v.caixa
 ) t
order by t.[data], t.caixa

