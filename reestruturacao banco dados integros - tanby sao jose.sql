-- novos atributos

-- TBS007: bancos
alter table [TBS007] add [BANPORDIA] decimal default 0 with values
alter table [TBS007] add [BANSEQREM] int default 0 with values

-- TBS010: produtos
alter table [TBS010] add [PROSTBENTA] char(1) default '' with values
alter table [TBS010] add [PROSTBENTB] char(2) default '' with values

-- TBS043: orcamentos
alter table [TBS043] add [ORCVDDTOT] money default 0 with values

-- TBS045: pedidos compras
alter table [TBS045] add [PDCVDDTOT] money default 0 with values

-- TBS055: pedidos vendas
alter table [TBS055] add [PDVVDDTOT] money default 0 with values

-- TBS059: notas fiscais entrada
alter table [TBS059] add [NFEVDDTOT] money default 0 with values
alter table [TBS059] add [NFETOTICMS] money default 0 with values
alter table [TBS059] add [NFETOTBAS] money default 0 with values
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
alter table [TBS067] add [NFSCODFIS] char(5) default '' with values
alter table [TBS067] add [NFSMESAPU] smallint default 0 with values
alter table [TBS067] add [NFSANOAPU] smallint default 0 with values
alter table [TBS067] add [NFSVDDTOT] money default 0 with values


-- deleta atributos

-- TBS043: orcamentos
alter table [dbo].[TBS043] drop constraint [DF_TBS043_ORCPDDTOT]
alter table [TBS043] drop column [ORCPDDTOT]

-- TBS045: pedidos compras
alter table [dbo].[TBS045] drop constraint [DF_TBS045_PDCPDDTOT]
alter table [TBS045] drop column [PDCPDDTOT]

-- TBS055: pedidos vendas
alter table [dbo].[TBS055] drop constraint [DF_TBS055_PDVPDDTOT]
alter table [TBS055] drop column [PDVPDDTOT]

-- TBS059: notas fiscais entrada
alter table [dbo].[TBS059] drop constraint [DF_TBS059_NFEPDDTOT]
alter table [TBS059] drop column [NFEPDDTOT]

-- TBS0591: itens notas fiscais entrada
alter table [dbo].[TBS0591] drop constraint [DF_TBS0591_NFETESDPL]
alter table [TBS0591] drop column [NFETESDPL]

-- TBS067: notas fiscais saida
alter table [dbo].[TBS067] drop constraint [DF_TBS067_NFSPDDTOT]
alter table [TBS067] drop column [NFSPDDTOT]


-- novos indices

-- TBS067: notas fiscais saidas
create nonclustered index [ITBS067E] on [dbo].[TBS067]([NFSEMPCOD], [NFSNUM] desc)

-- TBS069: posicao faturamento
create nonclustered index [ITBS0694] on [dbo].[TBS069]([PDFNFSEMP], [PDFNFSNUM] desc, [PDFNFSITE])


-- nova tabela

-- TBS071: impressoras
CREATE TABLE [dbo].[TBS071] (
	[IMPEMPCOD] [smallint] not null ,
	[IMPNOM] [char] (30) not null ,
	[IMPTIP] [char] (1) ,
	[IMPDES] [char] (50) ,
	[IMPDATCAD] [datetime]
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


DROP TABLE TBS071

CREATE TABLE [TBS071] (
  [IMPEMPCOD] smallint CONSTRAINT [DF_TBS071_IMPEMPCOD] DEFAULT 0 NOT NULL,
  [IMPNOM] char(30) COLLATE Latin1_General_BIN CONSTRAINT [DF_TBS071_IMPNOM] DEFAULT '' NOT NULL,
  [IMPTIP] char(1) COLLATE Latin1_General_BIN CONSTRAINT [DF_TBS071_IMPTIP] DEFAULT '',
  [IMPDES] char(50) COLLATE Latin1_General_BIN CONSTRAINT [DF_TBS071_IMPDES] DEFAULT '',
  [IMPDATCAD] datetime CONSTRAINT [DF_TBS071_IMPDATCAD] DEFAULT '17530101'
)
ON [PRIMARY]
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'FX1170_VENDAS', 'T', 'EPSON FX-1170', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'FX2170_ESTOQUE', 'T', 'EPSON FX2170', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'HP1015_DELIVERY', 'G', 'HP 1015', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'HP1360_RH', 'G', 'HP D1360', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'HP690C_ADMINISTRATIVO', 'G', 'HP 690C', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'LX300_DELIVERY', 'T', 'EPSON LX-300+', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'LX300_VENDAS', 'T', 'EPSON LX-300', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'LX810L_ESTOQUE', 'T', 'EPSON LX-810L', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'SAM2010_ESTOQUE', 'G', 'SAMSUNG 2010', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'SAM4725FN_VENDAS', 'G', 'SAMSUNG 4725FN', '20081204')
GO

INSERT INTO [TBS071] ([IMPEMPCOD], [IMPNOM], [IMPTIP], [IMPDES], [IMPDATCAD])
VALUES 
  (0, 'SHA1645CS_ADMINISTRATIVO', 'G', 'SHARP AL 1645CS', '20081204')
GO

ALTER TABLE [TBS071]
ADD PRIMARY KEY CLUSTERED ([IMPEMPCOD], [IMPNOM])
ON [PRIMARY]
GO