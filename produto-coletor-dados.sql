USE [SIBD]
GO

/****** Object:  Table [dbo].[produto]    Script Date: 04/24/2017 10:04:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[produto](
	[usuarioNome] [nvarchar](20) NOT NULL,
	[produtoLote] [int] NOT NULL,
	[produtoCodigo] [nvarchar](8) NOT NULL,
	[produtoDataLote] [datetime] NULL,
	[produtoCodigoBarras] [nvarchar](15) NULL,
	[produtoDescricao] [nvarchar](60) NULL,
	[produtoQtde] [real] NULL,
	[produtoMarca] [nvarchar](30) NULL,
	[produtoEmbalagem] [nvarchar](15) NULL,
	[produtoDataHora] [datetime] NULL,
	[produtoZerado] [datetime] NULL,
	[produtoColetas] [int] NULL,
	[produtoEmbalagem2] [nvarchar](15) NULL,
	[produtoEmbalagem3] [nvarchar](15) NULL,
	[produtoEmbalagem4] [nvarchar](15) NULL,
	[produtoQtde2] [real] NULL,
	[produtoQtde3] [real] NULL,
	[produtoQtde4] [real] NULL,
	[produtoCodigoBarras2] [nvarchar](15) NULL,
	[produtoCodigoBarras3] [nvarchar](15) NULL,
	[produtoCodigoBarras4] [nvarchar](15) NULL,
	[produtoContagemUnitaria] [nchar](1) NULL,
 CONSTRAINT [PK_produto] PRIMARY KEY CLUSTERED 
(
	[usuarioNome] ASC,
	[produtoLote] ASC,
	[produtoCodigo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




select PROCOD,PRODES,PROLOCFIS from TBS010 (nolock) where Left(PROLOCFIS,2) in('01','02')

select * into produtoMisas from produto

select * from produto

delete produto

insert into produto
select 'ba' as usuarioNome,
       --convert(int,Left(PROLOCFIS,2)) as produtoLote,
       1 as produtoLote,
       TBS010.PROCOD as produtoCodigo,
       GETDATE() as produtoDataLote,
       TBS010.PROCODBAR1 as produtoCodigoBarras,
       replace(TBS010.PRODES,'''','') as produtoDescricao,
       0 as produtoQtde,
       isnull((select replace(MARNOM,'''','') from TBS014 (nolock) where TBS014.MARCOD=TBS010.MARCOD),'') as produtoMarca,
       TBS010.PROUM1 + case when PROUM1QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM1QTD,6)) + ' ' + TBS010.PROUMV else '' end as produtoEmbalagem,
       null as produtoDataHora,
       null as produtoZerado,
       0 as produtoColetas,
       TBS010.PROUM2 + case when TBS010.PROUM2QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM2QTD,6)) else '' end as produtoEmbalagem2,
       TBS010.PROUM3 + case when TBS010.PROUM3QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM3QTD,6)) else '' end as produtoEmbalagem3,
       TBS010.PROUM4 + case when TBS010.PROUM4QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM4QTD,6)) else '' end as produtoEmbalagem4,
       0 as produtoQtde2,
       0 as produtoQtde3,
       0 as produtoQtde4,
       TBS010.PROCODBAR2 as produtoCodigoBarras2,
       TBS010.PROCODBAR3 as produtoCodigoBarras3,
       TBS010.PROCODBAR4 as produtoCodigoBarras4,
       'S' as produtoContagemUnitaria
  from TBS010 (nolock)
 where MARCOD=880
 --where Left(PROLOCFIS,2) in('01','02')
 --where TBS010.PROLOCFIS<>''
 where TBS010.PROLOCFIS4='1'

union
select 'tanby' as usuarioNome,
       --convert(int,Left(PROLOCFIS,2)) as produtoLote,
       0 as produtoLote,
       TBS010.PROCOD as produtoCodigo,
       GETDATE() as produtoDataLote,
       TBS010.PROCODBAR1 as produtoCodigoBarras,
       TBS010.PRODES as produtoDescricao,
       0 as produtoQtde,
       isnull((select replace(MARNOM,'''','') from TBS014 (nolock) where TBS014.MARCOD=TBS010.MARCOD),'') as produtoMarca,
       TBS010.PROUM1 + case when PROUM1QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM1QTD,6)) + ' ' + TBS010.PROUMV else '' end as produtoEmbalagem,
       null as produtoDataHora,
       null as produtoZerado,
       0 as produtoColetas,
       TBS010.PROUM2 + case when TBS010.PROUM2QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM2QTD,6)) else '' end as produtoEmbalagem2,
       TBS010.PROUM3 + case when TBS010.PROUM3QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM3QTD,6)) else '' end as produtoEmbalagem3,
       TBS010.PROUM4 + case when TBS010.PROUM4QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM4QTD,6)) else '' end as produtoEmbalagem4,
       0 as produtoQtde2,
       0 as produtoQtde3,
       0 as produtoQtde4,
       TBS010.PROCODBAR2 as produtoCodigoBarras2,
       TBS010.PROCODBAR3 as produtoCodigoBarras3,
       TBS010.PROCODBAR4 as produtoCodigoBarras4,
       'S' as produtoContagemUnitaria
  from TBS010 (nolock) inner join TBS032 (nolock) on TBS032.PROCOD=TBS010.PROCOD
 --where Left(PROLOCFIS,2) in('01','02')
 --where TBS010.PROLOCFIS='' and TBS032.ESTLOC=1 and TBS032.ESTQTDATU > 0
 where TBS010.PROLOCFIS4='' and TBS032.ESTLOC=2 and TBS032.ESTQTDATU <> 0


select * from produto order by produtoCodigo

select PROCOD as produtoCodigo,
       PROCODBAR1 as produtoCodigoBarras,
       PRODES as produtoDescricao,
       PROUM1 + case when PROUM1QTD > 1 then ' C/' + LTRIM(str(PROUM1QTD,6)) + ' ' + PROUMV else '' end as produtoEmbalagem,
       PROUM2 + case when PROUM2QTD > 1 then ' C/' + LTRIM(str(PROUM2QTD,6)) else '' end as produtoEmbalagem2,
       PROUM3 + case when PROUM3QTD > 1 then ' C/' + LTRIM(str(PROUM3QTD,6)) else '' end as produtoEmbalagem3,
       PROUM4 + case when PROUM4QTD > 1 then ' C/' + LTRIM(str(PROUM4QTD,6)) else '' end as produtoEmbalagem4,
       PROCODBAR2 as produtoCodigoBarras2,
       PROCODBAR3 as produtoCodigoBarras3,
       PROCODBAR4 as produtoCodigoBarras4
  from TBS010 (nolock) where Left(PROLOCFIS,2) in('02')

alter table produto alter column produtoCodigoBarras4 nvarchar(15) NULL

  
update produto set produtoDataLote=null
  
drop table produto

select convert(char(10),getdate(),112)

declare @comando varchar(500)

set @comando = 'insert into produto (usuarioNome,produtoLote,produtoCodigo,produtoDataLote,produtoCodigoBarras,'+'produtoDescricao,produtoQtde,produtoMarca,produtoEmbalagem,produtoDataHora,produtoZerado,produtoColetas,produtoEmbalagem2,produtoEmbalagem3,produtoEmbalagem4,produtoQtde2,produtoQtde3,produtoQtde4) values'
print @comando

select '(''' + usuarioNome + ''',' + Ltrim(str(produtoLote,4)) + ',''' + rtrim(produtoCodigo) + ''',''' + rtrim(convert(char(10),produtoDataLote,112)) + ''',''' + rtrim(produtoCodigoBarras) + ''',''' + rtrim(produtoDescricao) + ''',' + Ltrim(str(produtoQtde,9)) + ',''' + rtrim(produtoMarca) + ''',''' + rtrim(produtoEmbalagem) + ''',' + case when produtoDataHora is NULL then 'NULL' else convert(char(10),produtoDataHora,112) end + ',' + case when produtoZerado is NULL then 'NULL' else convert(char(10),produtoZerado,112) end + ',' + Ltrim(str(produtoColetas,9)) + ',''' + rtrim(produtoEmbalagem2) + ''',''' + rtrim(produtoEmbalagem3) + ''',''' + rtrim(produtoEmbalagem4) + ''',' + Ltrim(str(produtoQtde2,9)) + ',' + Ltrim(str(produtoQtde3,9)) + ',' + Ltrim(str(produtoQtde4,9)) + '),'
  from produto

update produto set produtoLote=3

-- rodar no studio colocando go no final do bloco
select 'insert into produto select ''' + usuarioNome + ''',' + Ltrim(str(produtoLote,4)) + ',''' + rtrim(produtoCodigo) + ''',''' + rtrim(convert(char(10),produtoDataLote,112)) + ''',''' + rtrim(produtoCodigoBarras) + ''',''' + rtrim(produtoDescricao) + ''',' + Ltrim(str(produtoQtde,9)) + ',''' + rtrim(produtoMarca) + ''',''' + rtrim(produtoEmbalagem) + ''',' + case when produtoDataHora is NULL then 'NULL' else convert(char(10),produtoDataHora,112) end + ',' + case when produtoZerado is NULL then 'NULL' else convert(char(10),produtoZerado,112) end + ',' + Ltrim(str(produtoColetas,9)) + ',''' + rtrim(produtoEmbalagem2) + ''',''' + rtrim(produtoEmbalagem3) + ''',''' + rtrim(produtoEmbalagem4) + ''',' + Ltrim(str(produtoQtde2,9)) + ',' + Ltrim(str(produtoQtde3,9)) + ',' + Ltrim(str(produtoQtde4,9)) + ',''' + rtrim(produtoCodigoBarras2) + ''',''' + rtrim(produtoCodigoBarras3) + ''',''' + rtrim(produtoCodigoBarras4) + ''',''' + rtrim(produtoContagemUnitaria) + ''';'
  from produto


select 'insert into produto select '''+'tanby'+''' as usuarioNome,2 as produtoLote,PROCOD as produtoCodigo,GETDATE() as produtoDataLote,PROCODBAR1 as produtoCodigoBarras,PRODES as produtoDescricao,0 as produtoQtde,isnull((select MARNOM from TBS014 (nolock) where TBS014.MARCOD=TBS010.MARCOD),'''') as produtoMarca,PROUM1 + case when PROUM1QTD > 1 then '''' C/'''' + LTRIM(str(PROUM1QTD,6)) + '' '' + PROUMV else '''' end as produtoEmbalagem,null as produtoDataHora,null as produtoZerado,null as produtoColetas from TBS010 (nolock) where Left(PROLOCFIS,2)='''+'02'+''''

select * from produto where produtoDataHora is null


-- endereçamento do estoque

delete localizacao

insert into localizacao
select PROCOD as produtoCodigo,
       PRODES as produtoDescricao,
       case
          when Len(PROLOCFIS) <= 6 then PROLOCFIS 
          else ''
       end as produtoLocAtual,
       '' as produtoLocNovo,
       'N' as produtoZeraLocal,
       '' as usuarioNome,
       NULL as produtoDataHora,
       PROCODBAR1 as produtoCodigoBarras1,
       PROCODBAR2 as produtoCodigoBarras2,
       PROCODBAR3 as produtoCodigoBarras3,
       PROCODBAR4 as produtoCodigoBarras4
  from TBS010 (nolock)
 where PROSTATUS<>'E'

select * from localizacao

select PROCOD,PRODES,PROSTATUS from TBS010 (nolock) where Len(PROCOD) > 8

begin tran
delete TBS010 where Len(PROCOD) > 8
commit tran

select * from TBS014 (nolock) order by MARCOD desc

-- rodar no studio colocando go no final do bloco
select 'insert into produto select ''' + rtrim(produtoCodigo) + ''',''' + rtrim(replace(replace(produtoDescricao,'"',''),'''','')) + ''',''' + rtrim(produtoLocAtual) + ''',''' + ''',''N'',''' + ''',NULL,''' + rtrim(produtoCodigoBarras1) + ''',''' + rtrim(produtoCodigoBarras2) + ''',''' + rtrim(produtoCodigoBarras3) + ''',''' + rtrim(produtoCodigoBarras4) + ''';'
  from localizacao
