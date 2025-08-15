-- novos atributos

-- TBS002: clientes
alter table [TBS002] add [CLIULTREQ] smallint default 0 with values

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

-- TBS05: pedidos vendas
alter table [TBS055] add [PDVVDDTOT] money default 0 with values

-- TBS056: contas a receber
alter table [TBS056] add [CRENUMBAN] char(12) default '' with values

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
alter table [TBS067] add [NFSVDDTOT] money default 0 with values
alter table [TBS067] add [NFSOBS] char(254) default '' with values
alter table [TBS067] add [NFSTIP] char(1) default '' with values
alter table [TBS067] add [NFSORINUM] int default 0 with values
alter table [TBS067] add [NFSORIEMI] datetime default '17530101' with values
alter table [TBS067] add [NFSTOTOUT] money default 0 with values
alter table [TBS067] add [NFSPESBRU] smallint default 0 with values
alter table [TBS067] add [NFSPESLIQ] smallint default 0 with values
alter table [TBS067] add [NFSVOLQTD] int default 0 with values
alter table [TBS067] add [NFSVOLESP] char(20) default 0 with values
alter table [TBS067] add [NFSVOLMAR] char(20) default 0 with values
alter table [TBS067] add [NFSVOLNUM] char(20) default 0 with values
alter table [TBS067] add [NFSCODFIS] char(5) default '' with values
alter table [TBS067] add [NFSMESAPU] smallint default 0 with values
alter table [TBS067] add [NFSANOAPU] smallint default 0 with values


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


-- nova tabela

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

