select convert(date,NEEDATEMI,112) as 'emissao'
       ,NEENUM as 'num_nota'
       ,NEECGCCPF as 'cnpj_cpf'
       ,NEENOM as 'nome'
       ,NEEVALTOT as 'valor'
       ,NEENATOPE as 'natureza'
       ,NEECHAACE as 'chave'
  from TBS099 with (nolock)
 where NEEDATEMI between '20230201' and '20230228 23:59'
       and (NEENFEENT='N' or NEENFEEFE='N')
       and NEESITNFE=1
       and NEETIPOPE=1
 order by NEEDATEMI

select top(1) *
  from TBS099 with (nolock)

-- códigos dos clientes do grupo

if object_id('tempdb.dbo.#empresas_grupo') is not null
   drop table tempdb.dbo.#empresas_grupo

create table #empresas_grupo (codigo int)

insert into #empresas_grupo
exec sp_ClientesGrupo

alter table ##CodigosClienteGrupo add nomeFantasia varchar(25)

update ##CodigosClienteGrupo
   set nomeFantasia=(select CLINOMFAN from TBS002 with (nolock) where CLICOD=codigo)

select codigo
       --,nomeFantasia
  from #empresas_grupo

-- empresas do grupo

if object_id('tempdb.dbo.#empresas_grupo') is not null
   drop table #empresas_grupo

select '05118717000156' as 'cnpj' -- best bag
  into #empresas_grupo
union
select '52080207000117' -- misaspel
union
select '44125185000136' -- papelyna
union
select '65069593000350' -- tanby cd
union
select '65069593000198' -- tanby matriz
union
select '65069593000279' -- tanby taubaté
union
select '41952080000162' -- winpack

select convert(date,NEEDATEMI,112) as 'emissao'
       ,rtrim(NEENOM) as 'emitente'
       ,NEEUFESIG as 'uf_origem'
       ,NEENUM as 'num_nota'
       ,rtrim(NEENATOPE) as 'natureza'
       ,iif(Len(NEECGCCPF)=14, dbo.FormatarCnpj(NEECGCCPF), dbo.FormatarCpf(NEECGCCPF)) as 'cnpj_cpf'
       ,NEEVALPRO as 'valor_produtos'
       ,NEEVALTOT as 'valor_nota'
       ,NEEVALFRE as 'valor_frete'
       ,NEEVALIPI as 'valor_ipi'
       ,NEEVALICMSST as 'valor_icms_st'
       ,NEEVALOUTDES as 'valor_outras_despesas'
       ,NEEVALSEG as 'valor_seguro'
       ,Left(NEECHAACE,4)+' '+subString(NEECHAACE,5,4)+' '+subString(NEECHAACE,9,4)+' '+subString(NEECHAACE,13,4)+' '+subString(NEECHAACE,17,4)+' '+subString(NEECHAACE,21,4)+' '+subString(NEECHAACE,25,4)+' '+subString(NEECHAACE,29,4)+' '+subString(NEECHAACE,33,4)+' '+subString(NEECHAACE,37,4)+' '+right(NEECHAACE,4) as 'chave'
  from TBS099 with (nolock)
 where convert(date,NEEDATEMI,112) = (select top 1 convert(date,NEEDATEMI,112)
                                        from TBS099 with (nolock)
                                       where convert(date,NEEDATEMI,112) >= '20080101' and convert(date,NEEDATEMI,112) <= convert(date,getdate()-1,112)
                                       order by NEEDATEMI desc)
       and NEECGCCPF collate database_default not in(select cnpj from #empresas_grupo)
 order by NEENOM


-- ******

if object_id('tempdb.dbo.#empresas_grupo') is not null
   drop table #empresas_grupo

select '05118717000156' as 'cnpj' -- best bag
  into #empresas_grupo
union
select '52080207000117' -- misaspel
union
select '44125185000136' -- papelyna
union
select '65069593000350' -- tanby cd
union
select '65069593000198' -- tanby matriz
union
select '65069593000279' -- tanby taubaté
union
select '41952080000162' -- winpack

--select getdate()+1

declare @datai date, @dataf date

select @dataf = convert(date,(getdate())-1,112)

set @datai = iif((select datepart(weekday,getdate()))=2, dateadd(day, -2, @dataf), @dataf)

--select @datai, @dataf

--declare @i smallint

--set @i = iif((select datepart(weekday,getdate()))=2,3,1)

--print @i

--TOP (SELECT @SomeNumber)

select convert(date,NEEDATEMI,112) as 'emissao'
       ,rtrim(NEENOM) as 'emitente'
       ,NEEUFESIG as 'uf_origem'
       ,NEENUM as 'num_nota'
       ,rtrim(NEENATOPE) as 'natureza'
       ,iif(Len(NEECGCCPF)=14, dbo.FormatarCnpj(NEECGCCPF), dbo.FormatarCpf(NEECGCCPF)) as 'cnpj_cpf'
       ,NEEVALPRO as 'valor_produtos'
       ,NEEVALTOT as 'valor_nota'
       ,NEEVALFRE as 'valor_frete'
       ,NEEVALIPI as 'valor_ipi'
       ,NEEVALICMSST as 'valor_icms_st'
       ,NEEVALOUTDES as 'valor_outras_despesas'
       ,NEEVALSEG as 'valor_seguro'
       ,Left(NEECHAACE,4)+' '+subString(NEECHAACE,5,4)+' '+subString(NEECHAACE,9,4)+' '+subString(NEECHAACE,13,4)+' '+subString(NEECHAACE,17,4)+' '+subString(NEECHAACE,21,4)+' '+subString(NEECHAACE,25,4)+' '+subString(NEECHAACE,29,4)+' '+subString(NEECHAACE,33,4)+' '+subString(NEECHAACE,37,4)+' '+right(NEECHAACE,4) as 'chave'
  from TBS099 with (nolock)
/* where convert(date,NEEDATEMI,112) in (select top (select @i) convert(date,NEEDATEMI,112)
                                        from TBS099 with (nolock)
                                       where convert(date,NEEDATEMI,112) >= '20080101' and convert(date,NEEDATEMI,112) <= convert(date,getdate()-@i,112)
                                       order by NEEDATEMI desc)
       and NEECGCCPF not in(select cnpj from #empresas_grupo) */

 where convert(date,NEEDATEMI,112) between @datai and @dataf
       and NEECGCCPF not in(select cnpj from #empresas_grupo)

 order by NEEDATEMI, NEENOM


-- versão final

if object_id('tempdb.dbo.#empresas_grupo') is not null
   drop table #empresas_grupo

select '05118717000156' as 'cnpj' -- best bag
  into #empresas_grupo
union
select '52080207000117' -- misaspel
union
select '44125185000136' -- papelyna
union
select '65069593000350' -- tanby cd
union
select '65069593000198' -- tanby matriz
union
select '65069593000279' -- tanby taubaté
union
select '41952080000162' -- winpack

--select getdate()+1

declare @datai date, @dataf date

select @dataf = convert(date,(getdate())-1,112)

set @datai = iif((select datepart(weekday,getdate()))=2, dateadd(day, -2, @dataf), @dataf)

select convert(date,NEEDATEMI,112) as 'emissao'
       ,rtrim(NEENOM) as 'emitente'
       ,NEEUFESIG as 'uf_origem'
       ,NEENUM as 'num_nota'
       ,rtrim(NEENATOPE) as 'natureza'
       ,iif(Len(NEECGCCPF)=14, dbo.FormatarCnpj(NEECGCCPF), dbo.FormatarCpf(NEECGCCPF)) as 'cnpj_cpf'
       ,NEEVALPRO as 'valor_produtos'
       ,NEEVALTOT as 'valor_nota'
       ,NEEVALFRE as 'valor_frete'
       ,NEEVALIPI as 'valor_ipi'
       ,NEEVALICMSST as 'valor_icms_st'
       ,NEEVALOUTDES as 'valor_outras_despesas'
       ,NEEVALSEG as 'valor_seguro'
       ,Left(NEECHAACE,4)+' '+subString(NEECHAACE,5,4)+' '+subString(NEECHAACE,9,4)+' '+subString(NEECHAACE,13,4)+' '+subString(NEECHAACE,17,4)+' '+subString(NEECHAACE,21,4)+' '+subString(NEECHAACE,25,4)+' '+subString(NEECHAACE,29,4)+' '+subString(NEECHAACE,33,4)+' '+subString(NEECHAACE,37,4)+' '+right(NEECHAACE,4) as 'chave'
  from TBS099 with (nolock)
 where convert(date,NEEDATEMI,112) between @datai and @dataf
       and NEECGCCPF not in(select cnpj from #empresas_grupo)
 order by NEEDATEMI, NEENOM


-- ******

select convert(date,getdate()-3,112) as '3_dias_atras', convert(date,getdate()-1,112) as 'dia_anterior'

select convert(datetime,getdate()-1,120)
select convert(datetime,getdate()-2)

select datepart(weekday,getdate())

-- contagem

select convert(char(6),NEEDATEMI,112) as 'emissao'
       ,count(*) as 'q_notas'
       ,count(*) / 30 as 'media_diaria'
  from TBS099 with (nolock)
 where convert(date,NEEDATEMI,112) between '20220601' and '20230531'
 
 /*(select top 1 convert(date,NEEDATEMI,112)
                                        from TBS099 with (nolock)
                                       where convert(date,NEEDATEMI,112) >= '20080101' and convert(date,NEEDATEMI,112) <= convert(date,getdate()-1,112)
                                       order by NEEDATEMI desc)*/
       and NEECGCCPF not in(select cnpj from #empresas_grupo)
 group by convert(char(6),NEEDATEMI,112)
 order by convert(char(6),NEEDATEMI,112)

select top(1) *
  from TBS117 with (nolock)

-- quantidade de devoluções por mês

select convert(char(6),NFDDATEMI,112) as 'emissao'
       --,NFDFORNOM as 'fornecedor'
       ,count(*) as 'q_notas'
  from TBS117 with (nolock)
 where NFDSTATUS='A'
       and NFDDATEMI between '20220601' and '20230531'
 group by convert(char(6),NFDDATEMI,112) --, NFDFORNOM
 order by convert(char(6),NFDDATEMI,112) --, NFDFORNOM

-- fornecedore com mais devolução por ano

select year(NFDDATEMI) as 'emissao'
       ,NFDFORNOM as 'fornecedor'
       ,count(*) as 'q_notas'
  from TBS117 with (nolock)
 where NFDSTATUS='A'
       and NFDDATEMI between '20220101' and '20230531'
 group by year(NFDDATEMI), NFDFORNOM
 order by year(NFDDATEMI), NFDFORNOM



declare @stringSQL nvarchar(3000)

--set @stringSQL= '
select convert(date,NEEDATEMI,112) as emissao
       ,rtrim(NEENOM) as emitente
       ,NEEUFESIG as uf_origem
       ,NEENUM as num_nota
       ,rtrim(NEENATOPE) as natureza
       ,iif(Len(NEECGCCPF)=14, dbo.FormatarCnpj(NEECGCCPF), dbo.FormatarCpf(NEECGCCPF)) as cnpj_cpf
       ,NEEVALPRO as valor_produtos
       ,NEEVALTOT as valor_nota
       ,NEEVALFRE as valor_frete
       ,NEEVALIPI as valor_ipi
       ,NEEVALICMSST as valor_icms_st
       ,NEEVALOUTDES as valor_outras_despesas
       ,NEEVALSEG as valor_seguro
       ,Left(NEECHAACE,4)+' '+subString(NEECHAACE,5,4)+' '+subString(NEECHAACE,9,4)+' '+subString(NEECHAACE,13,4)+' '+subString(NEECHAACE,17,4)+' '+subString(NEECHAACE,21,4)+' '+subString(NEECHAACE,25,4)+' '+subString(NEECHAACE,29,4)+' '+subString(NEECHAACE,33,4)+' '+subString(NEECHAACE,37,4)+' '+right(NEECHAACE,4) as chave
  into #notas_emitidas       
  from TBS099 with (nolock)
 where convert(date,NEEDATEMI,112) = (select top 1 convert(date,NEEDATEMI,112)
                                        from TBS099 with (nolock)
                                       where convert(date,NEEDATEMI,112) >= '20080101' and convert(date,NEEDATEMI,112) <= convert(date,getdate()-1,112)
                                       order by NEEDATEMI desc)
       and NEECGCCPF collate database_default not in(select cnpj from #empresas_grupo)
 order by NEENOM
 --'

set @stringSQL= 'select convert(date,NEEDATEMI,112) as ''emissao'', rtrim(NEENOM) as ''emitente'', NEEUFESIG as ''uf_origem'', NEENUM as ''num_nota'', rtrim(NEENATOPE) as ''natureza'', iif(Len(NEECGCCPF)=14, dbo.FormatarCnpj(NEECGCCPF), dbo.FormatarCpf(NEECGCCPF)) as ''cnpj_cpf'', NEEVALPRO as ''valor_produtos'', NEEVALTOT as ''valor_nota'', NEEVALFRE as ''valor_frete'', NEEVALIPI as ''valor_ipi'', NEEVALICMSST as ''valor_icms_st'',NEEVALOUTDES as ''valor_outras_despesas'', NEEVALSEG as ''valor_seguro'', Left(NEECHAACE,4)+'' ''+subString(NEECHAACE,5,4)+'' ''+subString(NEECHAACE,9,4)+'' ''+subString(NEECHAACE,13,4)+'' ''+subString(NEECHAACE,17,4)+'' ''+subString(NEECHAACE,21,4)+'' ''+subString(NEECHAACE,25,4)+'' ''+subString(NEECHAACE,29,4)+'' ''+subString(NEECHAACE,33,4)+'' ''+subString(NEECHAACE,37,4)+'' ''+right(NEECHAACE,4) as ''chave'' from TBS099 with (nolock) where convert(date,NEEDATEMI,112) = (select top 1 convert(date,NEEDATEMI,112) from TBS099 with (nolock) where convert(date,NEEDATEMI,112) >= ''20080101'' and convert(date,NEEDATEMI,112) <= convert(date,getdate()-1,112) order by NEEDATEMI desc)and NEECGCCPF collate database_default not in(select cnpj from #empresas_grupo) order by NEENOM'

--print @stringSQL


/*CREATE PROC dbo.usp_ConvertQuery2HTMLTable (@SQLQuery NVARCHAR(3000))
AS
BEGIN
   DECLARE @columnslist NVARCHAR (1000) = ''
   DECLARE @restOfQuery NVARCHAR (2000) = ''
   DECLARE @DynTSQL NVARCHAR (3000)
   DECLARE @FROMPOS INT

   SET NOCOUNT ON

   SELECT @columnslist += 'ISNULL (' + NAME + ',' + '''' + ' ' + '''' + ')' + ','
   FROM sys.dm_exec_describe_first_result_set(@SQLQuery, NULL, 0)

   SET @columnslist = left (@columnslist, Len (@columnslist) - 1)
   SET @FROMPOS = CHARINDEX ('FROM', @SQLQuery, 1)
   SET @restOfQuery = SUBSTRING(@SQLQuery, @FROMPOS, LEN(@SQLQuery) - @FROMPOS + 1)
   SET @columnslist = Replace (@columnslist, '),', ') as TD,')
   SET @columnslist += ' as TD'
   SET @DynTSQL = CONCAT (
         'SELECT (SELECT '
         , @columnslist
         ,' '
         , @restOfQuery
         ,' FOR XML RAW (''TR''), ELEMENTS, TYPE) AS ''TBODY'''
         ,' FOR XML PATH (''''), ROOT (''TABLE'')'
         )

   EXEC (@DynTSQL)
   SET NOCOUNT OFF
END
GO*/

select emissao,emitente,uf_origem,num_nota,natureza,cnpj_cpf,valor_produtos,valor_nota,valor_frete,valor_ipi,valor_icms_st,valor_outras_despesas,valor_seguro,chave from #notas_emitidas

usp_ConvertQuery2HTMLTable 'select emissao, emitente from notas_emitidas'

'select convert(date,NEEDATEMI,112) as ''emissao'', rtrim(NEENOM) as ''emitente'', NEEUFESIG as ''uf_origem'', NEENUM as ''num_nota'', rtrim(NEENATOPE) as ''natureza'', iif(Len(NEECGCCPF)=14, dbo.FormatarCnpj(NEECGCCPF), dbo.FormatarCpf(NEECGCCPF)) as ''cnpj_cpf'', NEEVALPRO as ''valor_produtos'', NEEVALTOT as ''valor_nota'', NEEVALFRE as ''valor_frete'', NEEVALIPI as ''valor_ipi'', NEEVALICMSST as ''valor_icms_st'',NEEVALOUTDES as ''valor_outras_despesas'', NEEVALSEG as ''valor_seguro'', Left(NEECHAACE,4)+'' ''+subString(NEECHAACE,5,4)+'' ''+subString(NEECHAACE,9,4)+'' ''+subString(NEECHAACE,13,4)+'' ''+subString(NEECHAACE,17,4)+'' ''+subString(NEECHAACE,21,4)+'' ''+subString(NEECHAACE,25,4)+'' ''+subString(NEECHAACE,29,4)+'' ''+subString(NEECHAACE,33,4)+'' ''+subString(NEECHAACE,37,4)+'' ''+right(NEECHAACE,4) as ''chave'' from TBS099 with (nolock) where convert(date,NEEDATEMI,112) = (select top 1 convert(date,NEEDATEMI,112) from TBS099 with (nolock) where convert(date,NEEDATEMI,112) >= ''20080101'' and convert(date,NEEDATEMI,112) <= convert(date,getdate()-1,112) order by NEEDATEMI desc)and NEECGCCPF collate database_default not in(select cnpj from #empresas_grupo) order by NEENOM' --@stringSQL --'SELECT UFESIG, UFENOM FROM TBS001 with (nolock)'


SELECT
    (SELECT 'Table I' FOR XML PATH(''),TYPE) AS 'caption',
    (SELECT 'emissao' as th, 'emitente' as th, 'uf_origem' as th, 'num_nota' as num_nota, 'natureza' as natureza, 'cnpj_cpf' as cnpj_cpf, 'valor_produtos' as valor_produtos, 'valor_nota' as valor_nota, 'valor_frete' as valor_frete, 'valor_ipi' as valor_ipi, 'valor_icms_st' as valor_icms_st, 'valor_outras_despesas' as valor_outras_despesas, 'valor_seguro' as valor_seguro, 'chave' as chave FOR XML raw('tr'),ELEMENTS, TYPE) AS 'thead',
    --(SELECT 'sum' AS th, 'twenty' AS th FOR XML raw('tr'),ELEMENTS, TYPE) AS 'tfoot',
    (SELECT F.unus AS td, F.duo AS td
       FROM
         (VALUES
            ('one', 'two'),
            ('three', 'four'),
            ('five', 'six'),
            ('seven', 'eight')
         ) F(unus, duo)
    FOR XML RAW('tr'), ELEMENTS, TYPE
    ) AS 'tbody'
  FOR XML PATH(''), ROOT('table')

SELECT
    (SELECT 'Table I' FOR XML PATH(''),TYPE) AS 'caption',
    (SELECT 'emissao' as th, 'emitente' as th, 'uf_origem' as th, 'num_nota' as th, 'natureza' as th, 'cnpj_cpf' as th, 'valor_produtos' as th, 'valor_nota' as th, 'valor_frete' as th, 'valor_ipi' as th, 'valor_icms_st' as th, 'valor_outras_despesas' as th, 'valor_seguro' as th, 'chave' as th FOR XML raw('tr'),ELEMENTS, TYPE) AS 'thead',
    --(SELECT 'sum' AS th, 'twenty' AS th FOR XML raw('tr'),ELEMENTS, TYPE) AS 'tfoot',
    (SELECT emissao as td, emitente as td, uf_origem as td, num_nota as td, natureza as td, cnpj_cpf as td, valor_produtos as td, valor_nota as td, valor_frete as td, valor_ipi as td, valor_icms_st as td, valor_outras_despesas as td, valor_seguro as td, chave as td --F.unus AS td, F.duo AS td
       FROM
         (select emissao,emitente,uf_origem,num_nota,natureza,cnpj_cpf,valor_produtos,valor_nota,valor_frete,valor_ipi,valor_icms_st,valor_outras_despesas,valor_seguro,chave from #notas_emitidas) F(emissao,emitente,uf_origem,num_nota,natureza,cnpj_cpf,valor_produtos,valor_nota,valor_frete,valor_ipi,valor_icms_st,valor_outras_despesas,valor_seguro,chave)
    FOR XML RAW('tr'), ELEMENTS, TYPE
    ) AS 'tbody'
  FOR XML PATH(''), ROOT('table')


	-- Declara as variaveis
	DECLARE	@Subject VARCHAR(500), @Fl_Tipo TINYINT, @Qtd_Segundos INT, @Consulta VARCHAR(8000), @Importance AS VARCHAR(6), @Dt_Atual DATETIME,
			@EmailBody VARCHAR(MAX), @AlertaLockHeader VARCHAR(MAX), @AlertaLockTable VARCHAR(MAX), @EmptyBodyEmail VARCHAR(MAX),
			@AlertaLockRaizHeader VARCHAR(MAX), @AlertaLockRaizTable VARCHAR(MAX), @Qt_Tempo_Lock INT, @Qt_Tempo_Raiz_Lock INT

			SELECT	@Importance =	'High',
					@Subject =		'Teste SQL Server',
					@EmailBody =	(SELECT
    (SELECT 'Table I' FOR XML PATH(''),TYPE) AS 'caption',
    (SELECT 'Emissão' as th, 'Emitente' as th, 'UF' as th, 'Num. nota' as th, 'Natureza da operação' as th, 'CNPJ-CPF' as th, 'Valor dos produtos' as th, 'Valor da nota' as th, 'Valor do frete' as th, 'Valor do IPI' as th, 'Valor do ICMS-ST' as th, 'Valor de outras despesas' as th, 'Valor do seguro' as th, 'Chave da NF-e' as th FOR XML raw('tr'),ELEMENTS, TYPE) AS 'thead',
    --(SELECT 'sum' AS th, 'twenty' AS th FOR XML raw('tr'),ELEMENTS, TYPE) AS 'tfoot',
    (SELECT emissao as td, emitente as td, uf_origem as td, num_nota as td, natureza as td, cnpj_cpf as td, valor_produtos as td, valor_nota as td, valor_frete as td, valor_ipi as td, valor_icms_st as td, valor_outras_despesas as td, valor_seguro as td, chave as td --F.unus AS td, F.duo AS td
       FROM
         (select emissao,emitente,uf_origem,num_nota,natureza,cnpj_cpf,valor_produtos,valor_nota,valor_frete,valor_ipi,valor_icms_st,valor_outras_despesas,valor_seguro,chave from #notas_emitidas) F(emissao,emitente,uf_origem,num_nota,natureza,cnpj_cpf,valor_produtos,valor_nota,valor_frete,valor_ipi,valor_icms_st,valor_outras_despesas,valor_seguro,chave)
    FOR XML RAW('tr'), ELEMENTS, TYPE
    ) AS 'tbody'
  FOR XML PATH(''), ROOT('table'))
							
			/*******************************************************************************************************************************
			--	ENVIA O EMAIL - ALERTA
			*******************************************************************************************************************************/	
			EXEC [msdb].[dbo].[sp_send_dbmail]
					@profile_name = 'cristiano@integros.com.br',
					@recipients =	'cristiano@integros.com.br',
					@subject =		@Subject,
					@body =			@EmailBody,
					@body_format =	'HTML',
					@importance =	@Importance


SELECT replace(FORMAT(1234, 'C'),'R$','') Result
SELECT FORMAT(1234, 'N') Result
SELECT FORMAT(convert(date,'20230518'), 'd', 'en-gb' )
select FORMAT(123456789,'###-##-####') AS 'Custom Number'
SELECT FORMAT(65069593000198, '##\.###\.###\/####-##')
select format(16267131890,'###\.###\.###-##')


-- versão final

if object_id('tempdb.dbo.#notas_emitidas') is not null 
	drop table tempdb.dbo.#notas_emitidas

select convert(date,NEEDATEMI,112) as emissao
       ,rtrim(NEENOM) as emitente
       ,NEEUFESIG as uf_origem
       ,NEENUM as num_nota
       ,rtrim(NEENATOPE) as natureza
       --,iif(Len(NEECGCCPF)=14, dbo.FormatarCnpj(NEECGCCPF), dbo.FormatarCpf(NEECGCCPF)) as cnpj_cpf
       ,NEECGCCPF as cnpj_cpf
       ,NEEVALPRO as valor_produtos
       ,NEEVALTOT as valor_nota
       ,NEEVALFRE as valor_frete
       ,NEEVALIPI as valor_ipi
       ,NEEVALICMSST as valor_icms_st
       ,NEEVALOUTDES as valor_outras_despesas
       ,NEEVALSEG as valor_seguro
       ,Left(NEECHAACE,4)+' '+subString(NEECHAACE,5,4)+' '+subString(NEECHAACE,9,4)+' '+subString(NEECHAACE,13,4)+' '+subString(NEECHAACE,17,4)+' '+subString(NEECHAACE,21,4)+' '+subString(NEECHAACE,25,4)+' '+subString(NEECHAACE,29,4)+' '+subString(NEECHAACE,33,4)+' '+subString(NEECHAACE,37,4)+' '+right(NEECHAACE,4) as chave
  into #notas_emitidas       
  from TBS099 with (nolock)
 where convert(date,NEEDATEMI,112) = (select top 1 convert(date,NEEDATEMI,112)
                                        from TBS099 with (nolock)
                                       where convert(date,NEEDATEMI,112) >= '20080101' and convert(date,NEEDATEMI,112) <= convert(date,getdate()-1,112)
                                       order by NEEDATEMI desc)
       and NEECGCCPF collate database_default not in(select cnpj from #empresas_grupo)
 order by NEENOM
 
select (
         select 'Emissão' as th
                ,'Emitente' as th
                ,'UF' as th
                ,'Num. nota' as th
                ,'Natureza da operação' as th
                ,'CNPJ-CPF' as th
                ,'Valor dos produtos' as th
                ,'Valor da nota' as th
                ,'Valor do frete' as th
                ,'Valor do IPI' as th
                ,'Valor do ICMS-ST' as th
                ,'Valor de outras despesas' as th
                ,'Valor do seguro' as th
                ,'Chave da NF-e' as th
            for XML raw('tr'), elements, type
       ) as 'thead'
       ,(
          select format(emissao, 'd', 'en-gb') as td
                 ,emitente as td
                 ,uf_origem as td
                 ,num_nota as td
                 ,natureza as td
                 ,iif(Len(cnpj_cpf)=14, format(convert(numeric,cnpj_cpf), '##\.###\.###\/####-##'), format(convert(numeric,cnpj_cpf), '###\.###\.###-##')) as cnpj_cpf
                 --,cnpj_cpf as td
                 ,format(valor_produtos, 'N') as td
                 ,format(valor_nota, 'N') as td
                 ,format(valor_frete, 'N') as td
                 ,format(valor_ipi, 'N') as td
                 ,format(valor_icms_st, 'N') as td
                 ,format(valor_outras_despesas, 'N') as td
                 ,format(valor_seguro, 'N') as td
                 ,chave as td
            from (
                   select emissao
                          ,emitente
                          ,uf_origem
                          ,num_nota
                          ,natureza
                          ,cnpj_cpf
                          ,valor_produtos
                          ,valor_nota
                          ,valor_frete
                          ,valor_ipi
                          ,valor_icms_st
                          ,valor_outras_despesas
                          ,valor_seguro
                          ,chave
                     from #notas_emitidas) f (emissao,emitente,uf_origem,num_nota,natureza,cnpj_cpf,valor_produtos,valor_nota,valor_frete,valor_ipi,valor_icms_st,valor_outras_despesas,valor_seguro,chave)
                      for XML raw('tr'), elements, type
        ) as 'tbody'
   for XML path(''), root('table')
  
-- variáveis para e-mail

declare @subject as varchar(500)
        ,@importance as varchar(6)
        ,@body as varchar(max)
        ,@body_format as varchar(4)

-- monta e-mail

select @importance = 'high'
       ,@subject = 'Notas Fiscais emitidas para a Empresa'
       ,@body_format = 'HTML'
       ,@body = '<style>
table {
  border-collapse: collapse;
  width: 100%;
}

tr {
  border-bottom: 1px solid #ddd;
}
tr:hover {background-color: #e1e6e3;}
thead {
background-color: #bfd6c7;
}
</style>'

select @body +=     
       	(
select (
         select 'Emissão' as th
                ,'Emitente' as th
                ,'UF' as th
                ,'Num. nota' as th
                ,'Natureza da operação' as th
                ,'CNPJ-CPF' as th
                ,'Valor dos produtos' as th
                ,'Valor da nota' as th
                ,'Valor do frete' as th
                ,'Valor do IPI' as th
                ,'Valor do ICMS-ST' as th
                ,'Valor de outras despesas' as th
                ,'Valor do seguro' as th
                ,'Chave da NF-e' as th
            for XML raw('tr'), elements, type
       ) as 'thead'
       ,(
          select format(emissao, 'd', 'en-gb') as td
                 ,emitente as td
                 ,uf_origem as td
                 ,num_nota as td
                 ,natureza as td
                 ,iif(Len(cnpj_cpf)=14, format(convert(numeric,cnpj_cpf), '##\.###\.###\/####-##'), format(convert(numeric,cnpj_cpf), '###\.###\.###-##')) as cnpj_cpf
                 --,cnpj_cpf as td
                 ,right(replicate(' ',12) + format(valor_produtos, 'N'),12) as td
                 ,format(valor_nota, 'N') as td
                 ,format(valor_frete, 'N') as td
                 ,format(valor_ipi, 'N') as td
                 ,format(valor_icms_st, 'N') as td
                 ,format(valor_outras_despesas, 'N') as td
                 ,format(valor_seguro, 'N') as td
                 ,chave as td
            from (
                   select emissao
                          ,emitente
                          ,uf_origem
                          ,num_nota
                          ,natureza
                          ,cnpj_cpf
                          ,valor_produtos
                          ,valor_nota
                          ,valor_frete
                          ,valor_ipi
                          ,valor_icms_st
                          ,valor_outras_despesas
                          ,valor_seguro
                          ,chave
                     from #notas_emitidas) f (emissao,emitente,uf_origem,num_nota,natureza,cnpj_cpf,valor_produtos,valor_nota,valor_frete,valor_ipi,valor_icms_st,valor_outras_despesas,valor_seguro,chave)
                      for XML raw('tr'), elements, type
        ) as 'tbody'
   for XML path(''), root('table')
                  
                )

-- envia o e-mail

exec [msdb].[dbo].[sp_send_dbmail]
     @profile_name = 'cristiano@integros.com.br'
     ,@recipients =	'cristiano@integros.com.br'
     ,@subject = @subject
     ,@body = @body
     ,@body_format = @body_format
     ,@importance =	@importance


select 