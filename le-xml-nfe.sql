-- lista arquivos do diretório

exec master..xp_cmdshell 'dir D:\Documents\GRM\xml\entrada\2021\tanby\matriz\01-jan /s /o:n /b'

if object_id('tempdb.dbo.#dir') is not null
begin 
	drop table #dir
end 

create table #dir(arquivo varchar(300))

declare @diretorio as varchar(200)

-- /s inclui subdiretórios
--set @diretorio='dir C:\temp\gz\bb\1907\02\can /s /o:n /b'
--set @diretorio='dir d:\temp\gz\bb\1912\06 /s /o:n /b'
--set @diretorio='dir D:\Documents\GRM\xml\sat\tanby\taubate\2020\04-abr /s /o:n /b'
--set @diretorio='dir c:\temp\sat\08-ago\pdv-1 /s /o:n /b'

--set @diretorio='dir D:\Documents\GRM\xml\sat\best-arts\10-out\0001\10-out-pdv-1 /s /o:n /b'

--set @diretorio='dir d:\temp\gz\nd\todos /s /o:n /b'

--set @diretorio='dir d:\temp\gz\nd\0001\006 /s /o:n /b'

-- set @diretorio='dir c:\temp\gz\bb\11 /s /o:n /b'
-- set @diretorio='dir c:\integros\xml\nfe\tanby_nd-65069593000198\autorizado /s /o:n /b' -- tanby matriz
-- set @diretorio='dir c:\integros\xml\nfe\tanby_taubate-65069593000279\Autorizado /s /o:n /b' -- tanby taubate 
-- set @diretorio='dir c:\integros\XML\nfe\Tanby_CD-65069593000350\autorizado /s /o:n /b' -- tanby cd 
-- set @diretorio='dir c:\integros\xml\nfe\papelyna-44125185000136\autorizado /s /o:n /b' -- papelyna
-- set @diretorio='dir c:\integros\xml\nfe\best_bag_-_matriz-05118717000156\autorizado /s /o:n /b' -- Best bag
-- set @diretorio='dir c:\integros\xml\nfe\misaspel-52080207000117\autorizado /s /o:n /b' -- Misaspel
set @diretorio='dir D:\Documents\GRM\xml\entrada\2021\tanby\matriz\01-jan /s /o:n /b' -- Hobby home

insert into #dir exec master..xp_cmdshell @diretorio

--select * from #dir
--select * from #dir where arquivo not like('%.xml')

-- delete #dir where arquivo is null or arquivo='can'
delete #dir where arquivo is null or arquivo not like('%.xml')

drop table #arquivo

select arquivo,row_number() over(order by arquivo) as linha into #arquivo from #dir

select * from #arquivo where linha = 59470 order by linha
select * from #arquivo order by linha

/*
SELECT
    X.ide.query('vCFe').value('.', 'float')
FROM
( 	
    SELECT CAST(X AS XML)
    FROM OPENROWSET(
        BULK 'C:\temp\gz\AD35190565069593000198590005243920142364375513.xml',
        SINGLE_BLOB) AS T(X)
) AS T(X)
CROSS APPLY X.nodes('CFe/infCFe/total') AS X(ide)

SELECT X.ide.query('total/vCFe').value('.', 'float'),X.ide.query('infAdic/infCpl').value('.', 'varchar(25)') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK 'c:\temp\gz\AD35190565069593000198590005243920142364375513.xml',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes('CFe/inf'

SELECT
    --X.ide.query('@chCanc').value('.', 'varchar(44)'),
    X.ide.query('total/vCFe').value('.', 'float'),
    X.ide.query('infAdic/infCpl').value('.', 'varchar(25)'),
    X.ide.query('ide/nCFe').value('.', 'varchar(25)')
FROM
( 	
    SELECT CAST(X AS XML)
    FROM OPENROWSET(
        BULK 'C:\temp\gz\bb\1907\02\AD35190705118717000156590005882450125037077944.xml',
        SINGLE_BLOB) AS T(X)
) AS T(X)
CROSS APPLY X.nodes('CFe/infCFe') AS X(ide)
*/

--drop table #cupons
--go
--
--create table #cupons(valor numeric(10,2), doc varchar(25), extrato varchar(9), data date)
--go

select * from #arquivo where linha > 657 187699

if object_id('tempdb.dbo.#Notas') is not null
begin 
	drop table #Notas
end 

create table #Notas (serie int, numero int, valor decimal(10,2))


declare @n int, @linhas int, @arquivo varchar(300), @query varchar(2000)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas

begin
	select 
	@arquivo = arquivo
	
	from #arquivo
	
	where linha=@n


     -- print @arquivo
	  
	set @query = '
	    
		if object_id(''tempdb.dbo.#ArquivoXml'') is not null
		begin 
			drop table #ArquivoXml
		end 

		DECLARE @XML XML
		
		SET @XML = (
		SELECT CAST(BulkColumn AS XML)
		FROM OPENROWSET(BULK ''' + @arquivo + ''' , SINGLE_BLOB) --  Informe onde se encontra o arquivo XML
		AS Arquivo)
	  
		;WITH XMLNAMESPACES(DEFAULT ''http://www.portalfiscal.inf.br/nfe'') -- Este ponto deve ser informado o NAMESPACE (xmlns), senão informar esta linha ele não retorna.
		SELECT
		NFe.value(''ide[1]/serie[1]'',''int'') as serie,
		NFe.value(''ide[1]/nNF[1]'', ''int'') as nNF,
		--NFe.value(''dest[1]/enderDest[1]/xMun[1]'', ''varchar(60)'') as xMun
		NFe.value(''total[1]/ICMSTot[1]/vNF[1]'', ''varchar(60)'') as xMun
		
		into #ArquivoXml
		FROM @XML.nodes(''//infNFe'') AS NFes(NFe) -- Caminho que ira iniciar a varredura
		
		insert into #Notas 
		select * from #ArquivoXml '

      -- set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''), X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''), X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)''), X.ide.query(''ide/dEmi'').value(''.'', ''date'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''nfeProc/NFe/infNFe'') AS X(ide)'
      -- set @query = 'insert into #Notas SELECT X.ide.query(''ide/serie'').value(''.'', ''int''), X.ide.query(''ide/nNF'').value(''.'', ''int''), X.ide.query(''dest/enderDest/xMun'').value(''.'', ''varchar(60)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''NFe/infNFe'') AS X(ide)'
	  
	  -- print @query
      --set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'

	exec(@query)
--print @query

    set @n += 1
end
go

select *
  from #Notas a
  full outer join nd.SIBD.dbo.NFJAN b
  on a.serie=b.serie
     and a.numero=b.numero


--select * 
--
--from #Notas B (nolock) 
--left join TBS067 A (nolock) on A.NFSNUM = B.numero and A.SNESER = B.serie
--
--where 
--A.NFSNUM is null 

-- c:\integros\xml\nfe\tanby_taubate-65069593000279\Autorizado\2020\06-JUN"
-- c:\integros\xml\nfe\tanby_taubate-65069593000279\Autorizado\2020\06-JUN\005001-0-004-ProcNFe.xml


begin tran 
update TBS067 set 
NFSMUNNOM = B.nomeMunicipio

from TBS067 A (nolock) 
inner join #Notas B on A.NFSNUM = B.numero and A.SNESER = B.serie

where 
A.NFSNUM in (select distinct numero from #Notas)




-- select * from TBS117 --Verificar posteriormente a inclusão do campo de municipio nas tabelas TBS117 e TBS059 (nas devoluções de entrada deverá gravar da nota de saida ou do cupom)


select NFSCLICOD, NFSDATEMI, NFSNUM, UFESIG, NFSMUNNOM, NFSENFSIT from TBS067 (nolock) where NFSMUNNOM <> ''


begin tran 
update movcaixagz set 
municipio = B.NFSMUNNOM

from movcaixagz A (nolock)
inner join TBS067 B (nolock) on A.serienf = B.SNESER and A.numeronf = B.NFSNUM 

where
A.numeronf > 0


select distinct numeronf, sitnf, serienf from movcaixagz (nolock) where numeronf > 0 and municipio is null

select NFSCLICOD, NFSDATEMI, NFSNUM, SNESER, UFESIG, NFSMUNNOM, NFSENFSIT from TBS067 (nolock) where NFSNUM = 41098

drop table #cupons
go

--create table #cupons(valor nvarchar, doc varchar(25), extrato varchar(9), data date, cfop char(4))
create table #cupons(valor numeric(10,2), doc varchar(25), extrato varchar(9), data date, cfop char(4))
go

declare @n int, @linhas int, @arquivo varchar(300), @query varchar(5000)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas
   begin
      select @arquivo = arquivo
        from #arquivo
       where linha=@n


      --print @arquivo

      set @query = 'insert into #cupons SELECT X.ide.query(''det/prod/vProd'').value(''.'', ''float''), X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''), X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)''), X.ide.query(''ide/dEmi'').value(''.'', ''date''), X.ide.query(''det/prod/CFOP'').value(''.'', ''varchar(4)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFe/infCFe'') AS X(ide)'
      --set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'

      exec(@query)
--print @query

      set @n += 1
   end

select *
  from #cupons

select convert(float,valor),*
  from #cupons
  
select sum(valor),count(*)
  from #cupons

select data
       ,sum(valor)
	   ,count(*)
  from #cupons
 group by data
 order by data

select cfop
       ,sum(valor)
  from #cupons
 where data='20200711'
 group by cfop
	   
select *
       ,right(doc,6)
  from #cupons


select extrato
       ,count(*)
  from #cupons
group by extrato
having count(*) > 1

-- cancelados

drop table #cancelados
go

create table #cancelados(valor numeric(10,2), doc varchar(25), extrato varchar(9))
go

declare @n int, @linhas int, @arquivo varchar(300), @query varchar(500)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas
   begin
      select @arquivo = arquivo
        from #arquivo
       where linha=@n

      set @query = 'insert into #cancelados SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'
      exec(@query)

      set @n += 1
   end
go

select sum(valor),count(*)
  from #cancelados


select *
       ,right(doc,6)
  from #cancelados



