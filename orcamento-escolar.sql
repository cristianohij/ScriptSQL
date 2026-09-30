select *
  from orca_escolar with (nolock)

select *
  from orca_escolar_item with (nolock)

select *
  from TBS018 with (nolock)
 where PRGCOD='WREL038'

select *
  from TBS025 with (nolock)
 where PARCHV in (1342,1520)

select *
  from TBS023 with (nolock)

update orca_escolar
   set oe_imp_bestbag = 'N'
       ,oe_imp_misaspel = 'N'
       ,oe_imp_papelyna = 'N'
       ,oe_imp_tanby = 'N'
       ,oe_imp_winpack = 'N'

update orca_escolar
   set oe_data_principal = oe_data_tanby

select *
  from TBS025 with (nolock)
 where PARCHV=1342

insert into orca_escolar (oe_nome_cliente) values ('teste')

select top 1 *
  from orca_esc with (nolock)

select top 1 *
  from orca_escolar with (nolock)

insert into orca_escolar
(
  oe_id
  ,oe_num_orca
  ,oe_nome_cliente
  ,oe_data_bestbag
  ,oe_data_misaspel
  ,oe_data_papelyna
  ,oe_data_tanby
  ,oe_data_winpack
  ,oe_data_principal
)
select id
       ,num_orca_origem
       ,nome_cliente
       ,data_bestbag
       ,data_misaspel
       ,data_papelyna
       ,data_tanby
       ,data_winpack
       ,data_tanby
  from orca_esc with (nolock)

delete orca_escolar

delete orca_escolar_item
 where oe_id = 60

dbcc checkident ('orca_escolar', reseed, 0)

select *
  from TBS023 with (nolock)

select *
  from tt.SIBD.dbo.TBS023 with (nolock)

select top 1 *
  from orca_esc_det with (nolock)

select top 1 *
  from orca_escolar_item with (nolock)

insert into orca_escolar_item
(
  oe_id
  ,oe_item
  ,oe_descricao
  ,oe_unidade
  ,oe_unidade_desc
  ,oe_quantidade
  ,oe_preco_bestbag
  ,oe_preco_misaspel
  ,oe_preco_papelyna
  ,oe_preco_tanby
  ,oe_preco_winpack
)
select id_orca
       ,item
       ,descricao
       ,unidade
       ,unidade_desc
       ,quantidade
       ,preco_bestbag
       ,preco_misaspel
       ,preco_papelyna
       ,preco_tanby
       ,preco_winpack
  from orca_esc_det with (nolock)
 where id_orca <> 60

exec sp_help 'orca_esc'
exec sp_help 'orca_esc_det'

exec sp_help 'orca_escolar'


select *
  from orca_esc_det with (nolock)

select *
  from orca_escolar_item with (nolock)

-- taubaté


select *
  from tt.SIBD.dbo.orca_esc with (nolock)

select *
  from orca_esc_det with (nolock)

-- reconstruir tabelas

drop table [orca_escolar_item]
GO

/****** Object:  Table [dbo].[orca_escolar_item]    Script Date: 29/07/2025 10:25:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[orca_escolar_item](
	[oe_id] [int] NOT NULL,
	[oe_item] [smallint] NOT NULL,
	[oe_descricao] [nchar](60) NULL,
	[oe_unidade] [nchar](2) NULL,
	[oe_quantidade] [smallmoney] NULL,
	[oe_preco_bestbag] [money] NULL,
	[oe_preco_misaspel] [money] NULL,
	[oe_preco_papelyna] [money] NULL,
	[oe_preco_tanby] [money] NULL,
	[oe_preco_winpack] [money] NULL,
	[oe_unidade_desc] [nchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[oe_id] ASC,
	[oe_item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[orca_escolar_item]  WITH CHECK ADD  CONSTRAINT [IORCAMENTOESCOLARORCAMENTOITE1] FOREIGN KEY([oe_id])
REFERENCES [dbo].[orca_escolar] ([oe_id])
GO

ALTER TABLE [dbo].[orca_escolar_item] CHECK CONSTRAINT [IORCAMENTOESCOLARORCAMENTOITE1]
GO


drop table [orca_escolar]
GO

/****** Object:  Table [dbo].[orca_escolar]    Script Date: 29/07/2025 10:25:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[orca_escolar](
	[oe_id] [int] NOT NULL,
	[oe_num_orca] [int] NULL,
	[oe_nome_cliente] [nchar](60) NULL,
	[oe_data_alteracao] [datetime] NULL,
	[oe_data_bestbag] [datetime] NULL,
	[oe_data_misaspel] [datetime] NULL,
	[oe_data_papelyna] [datetime] NULL,
	[oe_data_tanby] [datetime] NULL,
	[oe_data_winpack] [datetime] NULL,
	[oe_imp_bestbag] [nchar](1) NULL,
	[oe_imp_misaspel] [nchar](1) NULL,
	[oe_imp_papelyna] [nchar](1) NULL,
	[oe_imp_tanby] [nchar](1) NULL,
	[oe_imp_winpack] [nchar](1) NULL,
	[oe_data_principal] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[oe_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

select id_orca
       ,item
       ,count(*)
  from orca_esc_det with (nolock)
 group by id_orca
          ,item
having count(*) > 1

select *
  from orca_esc_det with (nolock)
 where not exists (select '' from orca_esc with (nolock) where orca_esc_det.id_orca=orca_esc.id)

select max(oe_id)
  from orca_escolar with (nolock)

select *
  from orca_escolar with (nolock)
 --where oe_id = 202

select *
  from orca_escolar_item with (nolock)
 --where oe_id = 202

select *
  from orca_esc with (nolock)

select *
  from orca_esc_det with (nolock)

-- functions

-- totais do orçcamento

drop function fnc_totais_orca_escolas
go

create function fnc_totais_orca_escolas(@oe_id int)
returns @dados table(oe_id int, oe_total_bestbag decimal(9,2), oe_total_misaspel decimal(9,2), oe_total_papelyna decimal(9,2), oe_total_tanby decimal(9,2), oe_total_winpack decimal(9,2)) as

begin
   insert into @dados
   select oe_id
          ,isnull(sum(oe_quantidade * oe_preco_bestbag), 0)
	        ,isnull(sum(oe_quantidade * oe_preco_misaspel), 0)
	        ,isnull(sum(oe_quantidade * oe_preco_papelyna), 0)
	        ,isnull(sum(oe_quantidade * oe_preco_tanby), 0)
	        ,isnull(sum(oe_quantidade * oe_preco_winpack), 0)

     from orca_escolar_item with (nolock)
    where oe_id =@oe_id
    group by oe_id
   return
end

select *
  from fnc_totais_orca_escolas(202)

-- totais de cada item

drop function fnc_total_item_orca_escolas
go

create function fnc_total_item_orca_escolas(@oe_id int, @oe_item smallint)
returns @dados table(oe_id int, oe_item int, oe_total_item_bestbag decimal(9,2), oe_total_item_misaspel decimal(9,2), oe_total_item_papelyna decimal(9,2), oe_total_item_tanby decimal(9,2), oe_total_item_winpack decimal(9,2)) as

begin
   insert into @dados
   select oe_id
          ,oe_item
          ,isnull(oe_quantidade * oe_preco_bestbag, 0)
	        ,isnull(oe_quantidade * oe_preco_misaspel, 0)
	        ,isnull(oe_quantidade * oe_preco_papelyna, 0)
	        ,isnull(oe_quantidade * oe_preco_tanby, 0)
	        ,isnull(oe_quantidade * oe_preco_winpack, 0)

     from orca_escolar_item with (nolock)
    where oe_id =@oe_id
          and oe_item = @oe_item

   return
end

select *
  from fnc_total_item_orca_escolas(202,1)

-- stored procedure

USE [SIBD]
GO
/****** Object:  StoredProcedure [dbo].[usp_RS_OrcamentoEscolar]    Script Date: 29/07/2025 16:20:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
===================================================================================================================================================================================
Orcamento escolar
===================================================================================================================================================================================
Historico de alteracoes
===================================================================================================================================================================================
30/07/2025 CRISTIANO
	- Alterado para ler a nova tabela de orçamentos escolares: orca_escolar e orca_escolar_item
	- Criação de duas funções para totalização dos itens e somatório do valores totais do orçametnos
08/04/2025 WILLIAM
	- Inclusao dos dados do vendedor, pois estava fixo nos layouts de TM e TT, que sera obtido do orçamento original;
	- Inclusao de campo no select final, para indicar qual empresa e vencedora, para que possamos imprimir os dados do vendedor;
26/03/2025 WILLIAM
	- Inclusao dos novos campos referentes a Winpack e Bestbag;
10/02/2025 WILLIAM
	- Inclusao do endereco de entrega do cliente, desde que esteja preenchido no orcamento;
09/10/2024 WILLIAM
	- Obter prazo de entrega, validade da proposta e descrição da condição de pagamento do orçamento original;
03/07/2024 WILLIAM
	- Listagem dos itens do orcamento escolar, utilizado para licitacoes para escolas;
===================================================================================================================================================================================
*/
--ALTER PROC [dbo].[usp_RS_OrcamentoEscolar_DEBUG]
--create proc [dbo].[usp_RS_OrcamentoEscolar_DEBUG]
ALTER proc [dbo].[usp_RS_OrcamentoEscolar]
--create proc [dbo].[usp_RS_OrcamentoEscolar]
	@nID int	
AS
BEGIN
	SET NOCOUNT ON;
------------------------------------------------------------------------------------------------------------------------------------------------------
	declare	@ID int

	-- Atribuicoes para desabilitar o "Parameter Sniffing" do SQL
	SET @ID = @nID

------------------------------------------------------------------------------------------------------------------------------------------------------	
	-- Itens do orcamento(auxiliar)

	declare @oe_total_bestbag as decimal(9,2), @oe_total_misaspel as decimal(9,2), @oe_total_papelyna as decimal(9,2), @oe_total_tanby as decimal(9,2), @oe_total_winpack as decimal(9,2)

	select @oe_total_bestbag = oe_total_bestbag
	       ,@oe_total_misaspel = oe_total_misaspel
		   ,@oe_total_papelyna = oe_total_papelyna
		   ,@oe_total_tanby = oe_total_tanby
		   ,@oe_total_winpack = oe_total_winpack
	  from fnc_totais_orca_escolas(@ID)

	IF OBJECT_ID('tempdb.dbo.#ORCAMENTOAUX') IS NOT NULL
		DROP TABLE #ORCAMENTOAUX;

	SELECT 	
		B.oe_num_orca as num_orca_origem
		,isnull(B.oe_data_bestbag, '17530101') as data_bestbag
		--ISNULL(A.oe_quantidade * A.oe_preco_tanby, 0) AS total_tanby,
        ,(select oe_total_item_bestbag from fnc_total_item_orca_escolas(A.oe_id, A.oe_item)) as total_item_bestbag
		,@oe_total_bestbag as total_bestbag

		,ISNULL(B.oe_data_misaspel, '17530101') AS data_misaspel
    	,(select oe_total_item_misaspel from fnc_total_item_orca_escolas(A.oe_id, A.oe_item)) as total_item_misaspel
		,@oe_total_misaspel as total_misaspel

		,ISNULL(B.oe_data_papelyna, '17530101') AS data_papelyna
    	,(select oe_total_item_papelyna from fnc_total_item_orca_escolas(A.oe_id, A.oe_item)) as total_item_papelyna
		,@oe_total_papelyna as total_papelyna

		,ISNULL(B.oe_data_tanby, '17530101') AS data_tanby
    	,(select oe_total_item_tanby from fnc_total_item_orca_escolas(A.oe_id, A.oe_item)) as total_item_tanby
		,@oe_total_tanby as total_tanby

		,ISNULL(B.oe_data_winpack, '17530101') AS data_winpack
    	,(select oe_total_item_winpack from fnc_total_item_orca_escolas(A.oe_id, A.oe_item)) as total_item_winpack
		,@oe_total_winpack as total_winpack

		,ORCCLI AS CLICOD
		,ORCENDENTCOD
		,RTRIM(ISNULL(CPGDES, '')) AS CPGDES
		,ORCPRAENT
		,ORCVALPRO
		,VENCOD
		,A.oe_id as id_orca
		,A.oe_item as item
		,A.oe_descricao as descricao
		,A.oe_unidade as unidade
		,A.oe_unidade_desc as unidade_desc
		,A.oe_quantidade as quantidade
		,A.oe_preco_bestbag as preco_bestbag
		,A.oe_preco_misaspel as preco_misaspel
		,A.oe_preco_papelyna as preco_papelyna
		,A.oe_preco_tanby as preco_tanby
		,A.oe_preco_winpack as preco_winpack
	INTO #ORCAMENTOAUX 	
  FROM orca_escolar_item A (NOLOCK)	
		INNER JOIN orca_escolar B (NOLOCK) ON B.oe_id = A.oe_id
		INNER JOIN TBS043 C (NOLOCK)  ON C.ORCNUM = B.oe_num_orca
		LEFT JOIN TBS008 D (NOLOCK) ON C.CPGCOD = D.CPGCOD

	WHERE 
		A.oe_id = @ID

--	select * from #OrcamentoAux
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Obtem os enderecos de entrega do cliente

	IF object_id('tempdb.dbo.#ENDERECOS') IS NOT NULL
		DROP TABLE #ENDERECOS;

	SELECT 
		A.CLICOD, 
		A.CLIENDCOD,
		CLILOG,
		CLIENDNUM,		
		CLIENDBAI,
		RTRIM(LTRIM((SELECT MUNNOM FROM TBS003 C (NOLOCK) WHERE A.CLIENDMUNCOD = C.MUNCOD))) AS CLIENDMUNNOM,
		CLIENDUFE
	INTO #ENDERECOS FROM TBS0021 A (NOLOCK) 

	WHERE 
		CLIENDTIP = 'E' AND
		A.CLICOD = (SELECT TOP 1 CLICOD FROM #ORCAMENTOAUX)

--SELECT * FROM #ENDERECOS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Dados do cliente

	IF OBJECT_ID('tempdb.dbo.#CLIENTE') IS NOT NULL
		DROP TABLE #CLIENTE;

	select 
	A.CLICOD,
	CLINOM,
	IIF(RTRIM(CLICGC) = '', '', dbo.FormatarCnpj(CLICGC)) AS CLICGC,
	IIF(RTRIM(CLICPF) = '', '', dbo.FormatarCnpj(CLICPF)) AS CLICPF,
	CLIEND,
	CLINUM,
	CLIBAI,
	(SELECT MUNNOM FROM TBS003 B (NOLOCK) WHERE A.MUNCOD = B.MUNCOD) AS MUNNON,
	A.UFESIG

	INTO #CLIENTE FROM TBS002 A (NOLOCK) 

	WHERE
		A.CLICOD = (SELECT TOP 1 CLICOD FROM #ORCAMENTOAUX)

--	select * FROM #CLIENTE
------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Tabela final

	IF OBJECT_ID('tempdb.dbo.#ORCAMENTO') IS NOT NULL
		DROP TABLE #ORCAMENTO;

	SELECT
		A.*,
		CLINOM,
		CLICGC,
		CLICPF,
		RTRIM(VENNOM) AS VENNOM ,
		RTRIM(V.VENEMAIL) AS VENEMAIL ,
		RTRIM(V.VENRAM) AS VENRAM,
		RTRIM(V.VENTEL) AS VENTEL,
		RTRIM(V.VENTEL2) AS VENTEL2,
		RTRIM(V.VENRAM2) AS VENRAM2,
		ISNULL(CLILOG, CLIEND) AS CLIEND,
		ISNULL(CLIENDNUM, CLINUM) AS CLINUM,
		ISNULL(CLIENDBAI, CLIBAI) AS CLIBAI,
		ISNULL(CLIENDMUNNOM, MUNNON) AS MUNNON,
		ISNULL(CLIENDUFE, UFESIG) AS UFESIG
				
	INTO #ORCAMENTO	FROM #ORCAMENTOAUX AS A
		JOIN #CLIENTE AS B ON A.CLICOD = B.CLICOD
		LEFT JOIN #ENDERECOS ON CLIENDCOD = ORCENDENTCOD
		LEFT JOIN TBS004 V ON A.VENCOD = V.VENCOD

------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Faz o refinamento da tabela para definir qual empresa e a vencedora, pelo menor valor
	-- utilizamos a tecnica "UNPIVOT", que transforma colunas em linhas

	/*declare @oe_total_bestbag as decimal(9,2), @oe_total_misaspel as decimal(9,2), @oe_total_papelyna as decimal(9,2), @oe_total_tanby as decimal(9,2), @oe_total_winpack as decimal(9,2)

	select @oe_total_bestbag = oe_total_bestbag
	       ,@oe_total_misaspel = oe_total_misaspel
		   ,@oe_total_papelyna = oe_total_papelyna
		   ,@oe_total_tanby = oe_total_tanby
		   ,@oe_total_winpack = oe_total_winpack
	  from fnc_totais_orca_escolas(@ID)*/

	  --select @oe_total_bestbag as total_bestbag, @oe_total_misaspel

	;WITH
	totais_empresa AS (
		SELECT id, empresa, total
		FROM (
      /*SELECT oe_id
	         ,(select oe_total_bestbag from fnc_totais_orca_escolas(oe_id))
			 ,(select oe_total_misaspel from fnc_totais_orca_escolas(oe_id))
			 , oe_total_papelyna, oe_total_tanby, oe_total_winpack
			FROM orca_escolar
			where id = @ID*/
			select @ID as id
			       ,@oe_total_bestbag as total_bestbag
				   ,@oe_total_misaspel as total_misaspel
				   ,@oe_total_papelyna as total_papelyna
				   ,@oe_total_tanby as total_tanby
				   ,@oe_total_winpack as total_winpack
		) p
		UNPIVOT
		(
			total FOR empresa IN (total_bestbag, total_misaspel, total_papelyna, total_tanby, total_winpack)
		) AS unpvt
	),
	empresa_vencedora AS(
		SELECT TOP 1 
			empresa, 
			total
		FROM totais_empresa
		
		WHERE 
			total > 0

		ORDER BY
			total
	)
	SELECT 
		A.*,
		
		IIF(empresa = 'total_tanby', 'TM', 
		IIF(empresa = 'total_papelyna', 'PY',
		IIF(empresa = 'total_misaspel', 'MI',
		IIF(empresa = 'total_bestbag', 'BB',
		IIF(empresa = 'total_winpack', 'WP',''))))) AS vencedora
	FROM #ORCAMENTO A, empresa_vencedora B
	
	ORDER BY 
		item

------------------------------------------------------------------------------------------------------------------------------------------------------

End

-- teste

declare @return_value int

--exec @return_value = [dbo].[usp_RS_OrcamentoEscolar_DEBUG] @nID = 202
exec @return_value = [dbo].[usp_RS_OrcamentoEscolar] @nID = 203

select 'Return Value' = @return_value
go

select *
  from orca_escolar with (nolock)

select *
  from orca_escolar_item with (nolock)

exec sp_help 'orca_escolar_item'

select *
  from orca_escolar c with (nolock)
 where c.oe_id in (
SELECT 
    oe_id
    --oe_item,
    --oe_descricao,
    --oe_unidade,
    --oe_quantidade,
    --oe_unidade_desc,
    --oe_quantidade * oe_preco_bestbag   AS total_bestbag,
    --oe_quantidade * oe_preco_misaspel  AS total_misaspel,
    --oe_quantidade * oe_preco_papelyna  AS total_papelyna,
    --oe_quantidade * oe_preco_tanby     AS total_tanby,
    --oe_quantidade * oe_preco_winpack   AS total_winpack
FROM orca_escolar_item with (nolock)
WHERE 
    (oe_quantidade * oe_preco_bestbag  = oe_quantidade * oe_preco_tanby)
 OR (oe_quantidade * oe_preco_misaspel = oe_quantidade * oe_preco_tanby)
 OR (oe_quantidade * oe_preco_papelyna = oe_quantidade * oe_preco_tanby)
 OR (oe_quantidade * oe_preco_winpack  = oe_quantidade * oe_preco_tanby));

select c.oe_num_orca
	   ,c.oe_nome_cliente
       ,sum(d.oe_quantidade * d.oe_preco_bestbag) as total_best_bag
       ,sum(d.oe_quantidade * d.oe_preco_misaspel) as total_best_bag
       ,sum(d.oe_quantidade * d.oe_preco_papelyna) as total_best_bag
       ,sum(d.oe_quantidade * d.oe_preco_tanby) as total_best_bag
       ,sum(d.oe_quantidade * d.oe_preco_winpack) as total_best_bag
  from orca_escolar c with (nolock)
  Left join orca_escolar_item d with (nolock)
         on d.oe_id = c.oe_id
 group by c.oe_num_orca
	   ,c.oe_nome_cliente

SELECT 
    c.oe_id,
	c.oe_num_orca,
    c.oe_nome_cliente,
    SUM(d.oe_quantidade * d.oe_preco_bestbag)   AS total_bestbag,
    SUM(d.oe_quantidade * d.oe_preco_misaspel)  AS total_misaspel,
    SUM(d.oe_quantidade * d.oe_preco_papelyna)  AS total_papelyna,
    SUM(d.oe_quantidade * d.oe_preco_tanby)     AS total_tanby,
    SUM(d.oe_quantidade * d.oe_preco_winpack)   AS total_winpack
FROM orca_escolar c WITH (NOLOCK)
LEFT JOIN orca_escolar_item d WITH (NOLOCK)
       ON d.oe_id = c.oe_id
GROUP BY 
    c.oe_id,
    c.oe_num_orca,
    c.oe_nome_cliente
HAVING 
       SUM(d.oe_quantidade * d.oe_preco_bestbag)  = SUM(d.oe_quantidade * d.oe_preco_tanby)
    OR SUM(d.oe_quantidade * d.oe_preco_misaspel) = SUM(d.oe_quantidade * d.oe_preco_tanby)
    OR SUM(d.oe_quantidade * d.oe_preco_papelyna) = SUM(d.oe_quantidade * d.oe_preco_tanby)
    OR SUM(d.oe_quantidade * d.oe_preco_winpack)  = SUM(d.oe_quantidade * d.oe_preco_tanby);

