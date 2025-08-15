select *
  from SALDODIARIO with (nolock)
 where PROCOD='5300797'
 order by ESTDATSAL desc

select *
  from TBS110 with (nolock)

select GVECOD
       ,(select GVEDES from TBS091 with (nolock) where TBS091.GVECOD=TBS004.GVECOD)
	   ,VENCOD
	   ,VENNOM
  from TBS004 with (nolock)
 order by TBS004.GVECOD, TBS004.VENNOM

select *
  from DWVendas with (nolock)
 where data between '20220301' and '20220331'
       and caixa > 0
       --and numeroSerieDocumento=3
       --and cancelado='N'

select sum(valorProdutos)
  from DWVendas with (nolock)
 where data between '20230201' and '20230228'
       and caixa > 0
       and cancelado='N'

select sum(valorProdutos)
  from DWVendas with (nolock)
 where data between '20230201' and '20230228'
       and caixa > 0
       and cancelado='S'

select caixa
       ,sum(valorTotal)
  from DWVendas with (nolock)
 where data between '20220301' and '20220331'
       --and numeroSerieDocumento=3
       and caixa > 0
       and cancelado='N'
 group by caixa

select *
  from DWVendas with (nolock)
 where data between '20220301' and '20220331'
       and numeroSerieDocumento=3
       and cancelado='N'
       
select sum(valorProdutos)
  from DWVendas with (nolock)
 where data between '20230201' and '20230228'
       and numeroSerieDocumento=3
       and cancelado='N'

select sum(valorProdutos)
  from DWVendas with (nolock)
 where data between '20220301' and '20220331'
       and numeroSerieDocumento=3
       and cancelado='S'

select top(1)
       *
  from movcaixagz with (nolock)
 where data<>datamovto

select *
  from movcaixagz with (nolock)
 where data between '20220301' and '20220331'
       and [status]='03'
       and data<>datamovto

select *
  from movcaixagz with (nolock)
 where data between '20220301' and '20220331'
       and status='03'
       and caixa=1
       and cupom between 194780 and 194790
 order by cupom

-- valor por caixa

select caixa
       ,sum(valortot) as 'valor'
  into #valor_caixa
  from movcaixagz with (nolock)
 where data between '20230201' and '20230228'
       and status='03'
       and cancelado=''
 group by caixa

-- cancelamento por caixa

select caixa
       ,sum(valortot) as 'valor'
  into #cancelamento_caixa
  from movcaixagz with (nolock)
 where data between '20230201' and '20230228'
       and status='03'
       and cancelado='S'
 group by caixa

select *
       ,v.valor-c.valor as 'val_liquido'
  from #valor_caixa v
  inner join #cancelamento_caixa c
        on c.caixa=v.caixa
 order by v.caixa

select caixa
       ,sum(valortot)
       ,count(*)
  from movcaixagz with (nolock)
 where data between '20220401' and '20220406'
       and status='03'
       and cancelado=''
 group by caixa

select cupom
  from movcaixagz with (nolock)
 where data between '20220301' and '20220331'
       and caixa=6
       and status='03'
       and cancelado='S'
 group by cupom

select cupom
  from movcaixagz with (nolock)
 where data between '20220301' and '20220331'
       and caixa=6
       and status='03'
       and cancelado=''
 group by cupom

select cupom
  from movcaixagz with (nolock)
 where data between '20220301' and '20220331'
       and caixa=6
       and status='01'
       and cancelado='S'
 group by cupom

select cancelado
       ,*
  from movcaixagz with (nolock)
 where data between '20220301' and '20220331'
       and caixa=6
       and status='01'
       and cupom in(select cupom
                      from movcaixagz with (nolock)
                     where data between '20220301' and '20220331'
                           and caixa=6
                           and status='01'
                           and cancelado='S'
                    group by cupom)

select sum(valortot)
       ,count(*)
  from movcaixagz with (nolock)
 where data between '20220301' and '20220331'
       and caixa=1
       and status='03'
       and cancelado=''

USE [SIBD]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_movcaixagz]
		@dataDe = N'20220301',
		@dataAte = N'20220331',
		@status = N'01',
		@naoCancelado = N's'

SELECT	'Return Value' = @return_value

GO

select *
  from movcaixagz with (nolock)
 where cupom=208647
       and caixa=6
       and status='01'
 order by item

select *
  from movcaixagz with (nolock)
 where cupom=208647
       and caixa=6
       and status='03'
 order by item

select *
  from TBS067 nf with (nolock)
  inner join TBS080 au with (nolock)
  on au.SNESER=nf.SNESER
     and au.ENFNUM=nf.NFSNUM
 where nf.NFSDATEMI between '20220301' and '20220331'
       and au.ENFSIT=6
       and nf.VENCOD in(135,95,152,22,154,155,162,156,169,101,99)
       and nf.SNESER=1

select nf.VENCOD
       ,sum(au.ENFVALTOT)
  from TBS067 nf with (nolock)
  inner join TBS080 au with (nolock)
  on au.SNESER=nf.SNESER
     and au.ENFNUM=nf.NFSNUM
 where nf.NFSDATEMI between '20220301' and '20220331'
       and au.ENFSIT=6
       and nf.VENCOD in(135,95,152,22,154,155,162,156,169,101,99)
       and nf.SNESER=1
 group by nf.VENCOD

select  CLICOD CLIENTE,VENCOD VENDEDOR, (SELECT VENNOM FROM TBS004 WHERE TBS004.VENCOD = TBS002.VENCOD), CLINOM NOMEC, (SELECT MUNNOM FROM TBS003 WHERE TBS003.MUNCOD = TBS002.MUNCOD ), CLITEL TELEFONE, CLICONTAT CONTATO FROM TBS002
WHERE VENCOD = 39

declare @UF varchar(500), @cod_cliente smallint, @nome_cliente varchar(60)

set @UF='''SP'',''RJ'',''MG'',''BA'''

set @cod_cliente=0

set @nome_cliente=''

print @UF

select UFESIG as UF
       ,(select rtrim(MUNNOM) from TBS003 m with (nolock) where m.MUNCOD=c.MUNCOD) as municipio
       ,VENCOD as cod_vendedor
       ,(select rtrim(VENNOM) from TBS004 v with (nolock) where v.VENCOD=c.VENCOD) as nome_vendedor
       ,CLICOD as cod_cliente
       ,rtrim(CLINOM) as nome_cliente
       ,rtrim(CLICONTAT) as contato
       ,rtrim(CLITEL) as fone1
       ,rtrim(CLITEL2) as fone2
       ,rtrim(CLITEL3) as fone3
  from TBS002 c with (nolock)
 where --UFESIG in(@UF)
       CLICOD between @cod_cliente and case when @cod_cliente > 0 then @cod_cliente else 99999 end
       and CLINOM Like (case when @nome_cliente='' then CLINOM else upper(rtrim(@nome_cliente)) end)

 order by CLINOM

select UFESIG as UF
       ,UFESIG + '-' + UFENOM as uf_nome
  from TBS001 with (nolock)
 order by UFESIG

select VENCOD as cod_vendedor
       ,str(VENCOD,6) + ' - ' + VENNOM as cod_nome_vendedor
  from TBS004 with (nolock)
 order by VENNOM

select cod_vendedor
       ,cod_nome_vendedor
  from (
select 0 as cod_vendedor
       ,'   0 -  SEM VENDEDOR' as cod_nome_vendedor
union       
select VENCOD as cod_vendedor
       ,str(VENCOD,4) + ' - ' + rtrim(VENNOM) as cod_nome_vendedor
  from TBS004 with (nolock)) tab
 order by subString(cod_nome_vendedor,8,50)

select count(*)
  from TBS002 with (nolock)

select *
  from TBS002 c with (nolock)
 where c.UFESIG not in(select UFESIG from TBS001 e with (nolock) where e.UFESIG=c.UFESIG)

select count(*)
  from TBS002 with (nolock)
 where VENCOD=0

select count(*)
  from TBS002 with (nolock)
 where VENCOD is NULL

select *
  from FERIADO with (nolock)
 where Nr_Ano=2022

	drop table #Split

      create table #Split (item varchar(100))

      declare @texto varchar(1000), @delimitador varchar(100), @s varchar (1000)
	
	set @texto = '1,7'
	set @delimitador = ','
	
	if len(@texto) > 0 
	begin 
		set @texto = @texto + @delimitador 
			
		while len(@texto) > 0
		begin
			set @s = ltrim(substring(@texto, 1, charindex(@delimitador, @texto) -1))
                  print @s
			insert into #Split (item) VALUES (@s)
			set @texto = substring(@texto, charindex(@delimitador, @texto) + 1, len(@texto))
                  print @texto
		end
	end

	declare @feriadosValidos int
	
	SET @feriados = (SELECT count(*) FROM #Datas /*WHERE datepart(DW, dia) not in (select item from #Split )*/) -- dessa forma contabilizo a qtd de feriados, mas não subtraio dos dias, pois o feriado caiu em um final de semana
	SET @feriadosValidos = (SELECT count(*) FROM #Datas WHERE datepart(DW, dia) not in (select item from #Split ))

select * from #Split

