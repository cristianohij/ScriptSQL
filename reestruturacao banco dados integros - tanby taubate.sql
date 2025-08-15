-- novos atributos

-- TBS002: clientes
alter table [TBS002] add [CLICONCOB] char(30) default '' with values
alter table [TBS002] add [CLICONENT] char(30) default '' with values
alter table [TBS002] add [CLIULTREQ] smallint default 0 with values

-- TBS007: bancos
alter table [TBS007] add [BANPORDIA] decimal default 0 with values
alter table [TBS007] add [BANSEQREM] int default 0 with values

-- TBS010: produtos
alter table [TBS010] add [PROSTBENTA] char(1) default '' with values
alter table [TBS010] add [PROSTBENTB] char(2) default '' with values

-- TBS043: orcamentos
alter table [TBS043] add [ORCVDDTOT] money default 0 with values
alter table [TBS043] add [ORCVALFRE] money default 0 with values
alter table [TBS043] add [ORCVALSEG] money default 0 with values
alter table [TBS043] add [ORCVALDES] money default 0 with values

-- TBS045: pedidos compras
alter table [TBS045] add [PDCVDDTOT] money default 0 with values

-- TBS055: pedidos vendas
alter table [TBS055] add [PDVVDDTOT] money default 0 with values

-- TBS056: contas receber
alter table [TBS056] add [CRENUMBAN] char(12) default '' with values

-- TBS059: notas fiscais entrada
alter table [TBS059] add [NFEVDDTOT] money default 0 with values
alter table [TBS059] add [NFETOTICMS] money default 0 with values
alter table [TBS059] add [NFETOTBAS] money default 0 with values
alter table [TBS059] add [NFEVALFRE] money default 0 with values
alter table [TBS059] add [NFEVALDES] money default 0 with values
alter table [TBS059] add [NFETOTIPI] money default 0 with values
alter table [TBS059] add [NFEBASSUB] money default 0 with values
alter table [TBS059] add [NFEVALSUB] money default 0 with values
alter table [TBS059] add [NFEVALSEG] money default 0 with values
alter table [TBS059] add [NFECAN] char(1) default '' with values
alter table [TBS059] add [NFEDATCAN] datetime default '17530101' with values
alter table [TBS059] add [NFEUSUCAN] char(25) default '' with values

-- TBS0591: itens notas fiscais entrada
alter table [TBS0591] add [NFEBASICMS] money default 0 with values

-- TBS067: notas fiscais saida
alter table [TBS067] add [NFSANOAPU] smallint default 0 with values
alter table [TBS067] add [NFSCODFIS] char(5) default '' with values
alter table [TBS067] add [NFSMESAPU] smallint default 0 with values
alter table [TBS067] add [NFSOBS] char(254) default '' with values
alter table [TBS067] add [NFSORIEMI] datetime default '17530101' with values
alter table [TBS067] add [NFSORINUM] int default 0 with values
alter table [TBS067] add [NFSPESBRU] smallmoney default 0 with values
alter table [TBS067] add [NFSPESLIQ] smallmoney default 0 with values
alter table [TBS067] add [NFSTIP] char(1) default '' with values
alter table [TBS067] add [NFSTOTOUT] money default 0 with values
alter table [TBS067] add [NFSVDDTOT] money default 0 with values
alter table [TBS067] add [NFSVOLESP] char(20) default '' with values
alter table [TBS067] add [NFSVOLMAR] char(20) default '' with values
alter table [TBS067] add [NFSVOLNUM] char(20) default '' with values
alter table [TBS067] add [NFSVOLQTD] int default 0 with values

-- deleta atributos

-- TBS043: orcamentos
alter table [TBS043] drop column [ORCPDDTOT]

-- TBS045: pedidos compras
alter table [TBS045] drop column [PDCPDDTOT]

-- TBS055: pedidos vendas
alter table [TBS055] drop column [PDVPDDTOT]

-- TBS059: notas fiscais entrada
alter table [TBS059] drop column [NFEPDDTOT]

-- TBS0591: itens notas fiscais entrada
alter table [TBS0591] drop column [NFETESDPL]

-- TBS067: notas fiscais saida
alter table [TBS067] drop column [NFSPDDTOT]


-- novos indices

-- TBS067: notas fiscais saidas
create nonclustered index [ITBS067E] on [dbo].[TBS067]([NFSEMPCOD], [NFSNUM] desc)

-- TBS069: posicao faturamento
create nonclustered index [ITBS0694] on [dbo].[TBS069]([PDFNFSEMP], [PDFNFSNUM] desc, [PDFNFSITE])


-- nova tabela

-- TBS070: comissoes
CREATE TABLE [dbo].[TBS070] (
	[CMSEMPCOD] [smallint] NOT NULL ,
	[CMSDOC] [int] NOT NULL ,
	[CMSDATPRO] [datetime] NULL ,
	[CMSDATPAG] [datetime] NULL ,
	[VENEMPCOD] [smallint] NULL ,
	[VENCOD] [smallint] NULL ,
	[CMSDATINI] [datetime] NULL ,
	[CMSDATFIN] [datetime] NULL ,
	[CMSOBS] [char] (254) COLLATE Latin1_General_BIN NULL ,
	[CMSVALVEN] [money] NULL ,
	[CMSVALABT] [money] NULL ,
	[CMSVALACR] [money] NULL ,
	[CMSPERCOM] [smallmoney] NULL ,
	[CMSBAI] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[CMSDATBAI] [datetime] NULL ,
	[CMSUSUBAI] [char] (25) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS070] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CMSEMPCOD],
		[CMSDOC]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS070] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBS070_CMSEMPCOD] DEFAULT (0) FOR [CMSEMPCOD],
	CONSTRAINT [DF_TBS070_CMSDOC] DEFAULT (0) FOR [CMSDOC],
	CONSTRAINT [DF_TBS070_CMSDATPRO] DEFAULT ('17530101') FOR [CMSDATPRO],
	CONSTRAINT [DF_TBS070_CMSDATPAG] DEFAULT ('17530101') FOR [CMSDATPAG],
	CONSTRAINT [DF_TBS070_VENEMPCOD] DEFAULT (0) FOR [VENEMPCOD],
	CONSTRAINT [DF_TBS070_VENCOD] DEFAULT (0) FOR [VENCOD],
	CONSTRAINT [DF_TBS070_CMSDATINI] DEFAULT ('17530101') FOR [CMSDATINI],
	CONSTRAINT [DF_TBS070_CMSDATFIN] DEFAULT ('17530101') FOR [CMSDATFIN],
	CONSTRAINT [DF_TBS070_CMSOBS] DEFAULT ('') FOR [CMSOBS],
	CONSTRAINT [DF_TBS070_CMSVALVEN] DEFAULT (0) FOR [CMSVALVEN],
	CONSTRAINT [DF_TBS070_CMSVALABT] DEFAULT (0) FOR [CMSVALABT],
	CONSTRAINT [DF_TBS070_CMSVALACR] DEFAULT (0) FOR [CMSVALACR],
	CONSTRAINT [DF_TBS070_CMSPERCOM] DEFAULT (0) FOR [CMSPERCOM],
	CONSTRAINT [DF_TBS070_CMSBAI] DEFAULT ('') FOR [CMSBAI],
	CONSTRAINT [DF_TBS070_CMSDATBAI] DEFAULT ('17530101') FOR [CMSDATBAI],
	CONSTRAINT [DF_TBS070_CMSUSUBAI] DEFAULT ('') FOR [CMSUSUBAI]
GO

 CREATE  INDEX [ITBS0701] ON [dbo].[TBS070]([VENEMPCOD], [VENCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0702] ON [dbo].[TBS070]([CMSEMPCOD], [CMSDOC] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0703] ON [dbo].[TBS070]([CMSEMPCOD], [VENCOD]) ON [PRIMARY]
GO

-- TBS071: impressoras
CREATE TABLE [dbo].[TBS071] (
	[IMPEMPCOD] [smallint] NOT NULL ,
	[IMPNOM] [char] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[IMPTIP] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[IMPDES] [char] (50) COLLATE Latin1_General_BIN NULL ,
	[IMPDATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS071] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[IMPEMPCOD],
		[IMPNOM]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS071] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBS071_IMPEMPCOD] DEFAULT (0) FOR [IMPEMPCOD],
	CONSTRAINT [DF_TBS071_IMPNOM] DEFAULT ('') FOR [IMPNOM],
	CONSTRAINT [DF_TBS071_IMPTIP] DEFAULT ('') FOR [IMPTIP],
	CONSTRAINT [DF_TBS071_IMPDES] DEFAULT ('') FOR [IMPDES],
	CONSTRAINT [DF_TBS071_IMPDATCAD] DEFAULT ('17530101') FOR [IMPDATCAD]
GO

-- TMP007: produtos +vendidos
CREATE TABLE [dbo].[TMP007] (
	[T7_EMPRESA] [smallint] NOT NULL ,
	[T7_REGISTRO] [int] NOT NULL ,
	[T7_PROCOD] [char] (15) COLLATE Latin1_General_BIN NOT NULL ,
	[T7_PRODES] [char] (50) COLLATE Latin1_General_BIN NULL ,
	[T7_PROUM1] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[T7_MARNOM] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[T7_QTDVEN] [money] NULL ,
	[T7_VALVEN] [money] NULL ,
	[T7_PERTOTVEN] [smallmoney] NULL ,
	[T7_PROSTATUS] [char] (1) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TMP007] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[T7_EMPRESA],
		[T7_REGISTRO],
		[T7_PROCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TMP007] WITH NOCHECK ADD 
	CONSTRAINT [DF_TMP007_T7_EMPRESA] DEFAULT (0) FOR [T7_EMPRESA],
	CONSTRAINT [DF_TMP007_T7_REGISTRO] DEFAULT (0) FOR [T7_REGISTRO],
	CONSTRAINT [DF_TMP007_T7_PROCOD] DEFAULT ('') FOR [T7_PROCOD],
	CONSTRAINT [DF_TMP007_T7_PRODES] DEFAULT ('') FOR [T7_PRODES],
	CONSTRAINT [DF_TMP007_T7_PROUM1] DEFAULT ('') FOR [T7_PROUM1],
	CONSTRAINT [DF_TMP007_T7_MARNOM] DEFAULT ('') FOR [T7_MARNOM],
	CONSTRAINT [DF_TMP007_T7_QTDVEN] DEFAULT (0) FOR [T7_QTDVEN],
	CONSTRAINT [DF_TMP007_T7_VALVEN] DEFAULT (0) FOR [T7_VALVEN],
	CONSTRAINT [DF_TMP007_T7_PERTOTVEN] DEFAULT (0) FOR [T7_PERTOTVEN],
	CONSTRAINT [DF_TMP007_T7_PROSTATUS] DEFAULT ('') FOR [T7_PROSTATUS]
GO

 CREATE  INDEX [ITMP0072] ON [dbo].[TMP007]([T7_EMPRESA], [T7_REGISTRO], [T7_PRODES]) ON [PRIMARY]
GO

 CREATE  INDEX [ITMP0073] ON [dbo].[TMP007]([T7_EMPRESA], [T7_REGISTRO], [T7_QTDVEN] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [ITMP0074] ON [dbo].[TMP007]([T7_EMPRESA], [T7_REGISTRO], [T7_VALVEN] DESC ) ON [PRIMARY]
GO

