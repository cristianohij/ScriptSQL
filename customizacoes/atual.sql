-- 22ago2012

-- TBS0431: itens do orcamento

 ORCNUMPEDCOM Character (15)  Null 
 
New   ORCNUMITECOM Numeric (6) 

-- TBS0551: itens do pedido de vendas

 PDVNUMPEDCOM Character (15)  Null 
 
New   PDVNUMITECOM Numeric (6) 

-- TBS0671: itens da nota fiscal de saida

NFSNUMPEDCOM Character (15)  Null 
 
New   NFSNUMITECOM Numeric (6) 


-- 13ago2012

-- TBS078: cheques

CHQCNPJEMI Character (14) 

-- 8ago2012

-- TBS022: usuarios logados no sistema

 CONATIVA Character (1) 


-- 30jul2012

-- TBS0451: itens do pedido de compras

 PDCPORST Numeric (8.4)  Null 
 
New   PDCIPI Numeric (8.4)  Null 
 
New   PDCPROIVA Numeric (8.4) 




-- 13jul2012

-- TBS023: empresa

New   EMPULTENDCOD Numeric (2) 

-- TBS045: pedidos 

PDCENDENT Numeric (2) 

-- TBS0231: outros endereços da empresa

nova

-- TBS0231: outros endereços da empresa

 EMPENDTEL Character (30)  Null 
 
New   EMPENDFAX Character (30) 


-- 12jul2012

-- TBS073: carta de correcao

 CACSEQELE Numeric (2)  Null 
 
New   CACENVEMAIL Character (1) 


-- TBS0732: log da carta de correcao

nova

-- 21jun2012

-- TBS0761: itens das solicitações de compras

ITBS07619 duplicate   SDCEMPCOD  
 LESCOD  
 PROCOD  
 
 

-- 5jun2012

-- TBS002: clientes

New   RDVEMPCOD Numeric (2)  Null 
 
New   RDVCOD Numeric (3)  Null 
 
New   CLIULTENDCOD Numeric (2)  Null 

-- TBS043: orcamentos

 ORCCLIENDCOD Numeric (2)  Null 
 
-- TBS055: pedidos de vendas 

 PDVCLIENDCOD Numeric (2)Not null  0

-- TBS0021: outros endereços do cliente


-- 23mai2012

-- TBS097: regiões de vendas

nova

-- 11mai2012

-- TMP004: pendencias por fornecedores

 T4_TOTCUSTO Numeric (12.2) 

-- 30mar2012

-- TBS010: produtos

New   ITBS01022 duplicate   PROCSN  
 
New   ITBS01023 duplicate   PROCSNENT  

Del   ITBS0109 duplicate   PROCSNA  
 PROCSN  
 
Del   ITBS01013 duplicate   PROCSNENTA  
 PROCSNENT 

Del   PROCSNA Character (1)   
 
Del   PROCSNENTA Character (1)  

-- TBS085: codigo da situacao da operacao do simples nacional

Del   CSNCRT Character (1)Not null 

New   ITBS085 primary key Clustered  CSNCOD  
 
Del   ITBS085 primary key Clustered  CSNCRT  
 CSNCOD  

-- TBS0672: itens da nota fiscal de saída

 NFSCST Character (4) Type = Character (3) 
 

-- 29mar2012

ORCCST Character (4) Type = Character (3) 
 TBS0431.ORCCST 

 PDVCST Character (4) Type = Character (3) 
 TBS0551.PDVCST 

-- TBS023: empresas

 EMPCRT Numeric (1) 

-- 16mar2012

CPATIT Numeric (10)Not null Type = Numeric (6) TBS057.CPATIT 
CPAFATURA Character (10) Type = Character (6) TBS057.CPAFATURA 

HCPTIT Numeric (10)Not null Type = Numeric (6) TBS062.HCPTIT 

-- 15mar2012

-- TBS002: clientes

 CLISINHAB Character (1)  Null 
 
New   CLIDATHORCONSIN Datetime   Null 
 
New   CLICRENFE Character (1)  Null 
 
New   CLIINIATI Date   Null 
 
New   CLIMODSITCAD Date   Null 
 
New   CLIDATBAICON Date  


-- 2fev2012

 FORFIL Character (1)  Null 
 
New   FORUTICODINT Character (1)  Null 
 
New   FORPORST Numeric (8.4) 


-- 30jan2012

-- TBS047: requisitantes

REQLIMORC Numeric (12.2)  Null 
 
New   REQORCABT Numeric (12.2)  Null 
 
New   REQDATLIMORC Date  


-- 27jan2012

-- TBS002: clientes

alter table [TBS002] add [CLIUTICODINT] char(1) default '' with values

-- 25jan2012

-- TBS015: politica de precos

alter table [TBS015] add [PDPPORST] decimal(7,4) default 0 with values


-- 5jan2012

-- TBS010: produtos

-- atributos

 PROCSNA Character (1)  Null 
 
New   PROCSNENTA Character (1) 

-- indices

ITBS0109 duplicate   PROCSNA  
 PROCSN  
 
  
 
New   ITBS01013 duplicate   PROCSNENTA  
 PROCSNENT  
 
 
-- TBS043: orçamentos

ORCTIPOPE Character (30)  Null 
 
New   ORCFINAQU Character (1) 


-- TBS0431: itens do orçamento

 ORCTIPOPEITE Character (30)  Null 
 
New   ORCFINAQUITE Character (1)  Null 
 
New   ORCOPSREG Numeric (4)  Null 
 
New   ORCMVA Numeric (8.4)  Null 
 
New   ORCPBIST Numeric (8.4)  Null 
 
New   ORCPERICMSST Numeric (5.2) 


-- TBS067: notas fiscais de saídas

 NFSTIPOPE Character (30)  Null 
 
New   NFSFINAQU Character (1) 


-- TBS0671: itens da nota fiscal de saída

NFSMVA Numeric (8.4)  Null 
 
New   NFSPBIST Numeric (8.4)  Null 
 
New   NFSTIPOPEITE Character (30)  Null 
 
New   NFSFINAQUITE Character (1)  Null 
 
New   NFSOPSREG Numeric (4)  Null 
 
New   NFSPERICMSST Numeric (5.2) 


-- 3jan2012

-- TBS004: vendedores

VENDATALT Date  

-- 2jan2012

PDVOPSREG Numeric (4) 

-- 29dez2011

New   CSNCRT Character (1)Not null  ' ' 
 
  CSNCOD Character (3)Not null  TBS085.CSNCOD 
 
  CSNDES Character (60)  TBS085.CSNDES 
 
  CSNICMS Character (1)  TBS085.CSNICMS 
 
  CSNMSG Character (254)  TBS085.CSNMSG 
 
  CSNDATCAD Date   TBS085.CSNDATCAD 
 
 

 
 
Indexes  

  Name Definition Composition  

New   ITBS085 primary key Clustered  CSNCRT  
 CSNCOD  
 
  
 
 

Del   ITBS085 primary key Clustered  CSNCOD  
 
  
 
Del   ITBS0851 duplicate   CSNDES  
 
 
 


-- 27dez2011

PDVMVA Numeric (8.4) 

-- 23dez2011

alter table [TBS001] add [UFEICMSST] smallmoney default 0 with values


-- 9dez2011

-- TBS0551: itens do pedido de vendas

 PDVPBIST Numeric (8.4)  Null 
 PDVPERICMSST Numeric (5.2)  Null 
 


-- 8dez2011

-- TBS055: pedidos de vendas

PDVTIPOPE Character (30)  Null 
PDVFINAQU Character (1)  Null 

-- TBS0551: itens do pedido de vendas
 
PDVTIPOPEITE Character (30)  Null 
PDVFINAQUITE Character (1) 

-- 1dez2011

-- TBS0591: itens da NF de entrada

NFEPRONCM Character (8)

-- 30nov2011

-- TBS010: produtos

 PROPIS Numeric (5.2)  Null 
New   PROCOFINS Numeric (5.2)  Null 
alter table [TBS010] add [PROIVA] smallmoney default 0 with values
New   PROPISST Numeric (5.2)  Null 
New   PROCOFINSST Numeric (5.2)  Null 
New   PROSTBIPI Character (2)  Null 
New   PROSTBIPIE Character (2)  Null 
New   PROSTBPIS Character (2)  Null 
New   PROSTBPISE Character (2)  Null 
New   PROSTBCOFINS Character (2)  Null 
New   PROSTBCOFINSE Character (2)  Null 
 
ITBS01016 duplicate   PROSTBCOFINS  
New   ITBS01017 duplicate   PROSTBCOFINSE  
New   ITBS01018 duplicate   PROSTBPIS  
New   ITBS01019 duplicate   PROSTBPISE  
New   ITBS01020 duplicate   PROSTBIPI  
New   ITBS01021 duplicate   PROSTBIPIE  
 
-- TBS016: usuarios

USULIBBLQ Character (1)

-- MSL002: cupons vendas gz

 M2_USULIBBLQ Character (45) 

IMSL0025 duplicate   M2_PROCOD  
 M2_DAT  
 
  
NOVAS

-- TBS092: classificacao fiscal

-- TBS093: situacao tributaria pelo IPI

-- TBS094: situacao tributaria pelo PIS

-- TBS095: situacao tributaria pelo Cofins
 

 


-- 29nov2011

-- TBS001: estados

alter table [TBS001] add [UFEICMPRO] smallmoney default 0 with values


-- TBS002: clientes


alter table [TBS002] add [CLIFINAQU]
alter table [TBS002] add [CLIPOR]

-- TBS096: tipos de operações NOVA

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- mre []  tropical feet []


-- 17nov2011

-- TBS006: fornecedores

alter table [TBS004] add [FORREGTRI] smallint default 0 with values
alter table [TBS0591] alter column [NFECST] char(4)

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- mre []  tropical feet []


-- 3nov2011

-- TBS059: notas fiscais de entradas

alter table [TBS059] alter column [NFENUM] decimal(10)
alter table [TBS0591] alter column [NFENUM] decimal(10)
alter table [TBS0592] alter column [NFENUM] decimal(10)
alter table [TBS0593] alter column [NFENUM] decimal(10)
alter table [TBS0594] alter column [NFENUM] decimal(10)

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- mre []  tropical feet []


-- 27out2011

-- TBS0371: carta de correcao

alter table [TBS0371] alter column [CACRET] char(80)

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- mre []  tropical feet []


-- 19out2011

-- TBS0101: produto x fornecedor

CREATE TABLE [dbo].[TBS0101] (
	[PROEMPCOD] [smallint] NOT NULL ,
	[PROCOD] [char] (15) COLLATE Latin1_General_BIN NOT NULL ,
	[PROFOREMP] [smallint] NOT NULL ,
	[PROFORCOD] [int] NOT NULL ,
	[PROFORPRO] [char] (15) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0101] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PROEMPCOD],
		[PROCOD],
		[PROFOREMP],
		[PROFORCOD]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS01015] ON [dbo].[TBS0101]([PROFOREMP], [PROFORCOD]) ON [PRIMARY]
GO

-- TBS091: grupo de vendedores

CREATE TABLE [dbo].[TBS091] (
	[GVEEMPCOD] [smallint] NOT NULL ,
	[GVECOD] [smallint] NOT NULL ,
	[GVEDES] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[GVEDATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS091] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[GVEEMPCOD],
		[GVECOD]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0911] ON [dbo].[TBS091]([GVEEMPCOD], [GVEDES]) ON [PRIMARY]
GO

-- TBS004: vendedores

alter table [TBS004] add [GVEEMPCOD] [smallint] default 0 with values
alter table [TBS004] add [GVECOD] [smallint] default 0 with values

CREATE  INDEX [ITBS0046] ON [dbo].[TBS004]([GVEEMPCOD],[GVECOD]) ON [PRIMARY]

-- TBS0451: itens do pedido de venda

alter table [TBS0451] ADD [PDCPROFOR] char(15) default '' with values

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- mre []  tropical feet []

-- 29set2011

-- TBS0591: itens da nota fiscal de entrada

alter table [TBS0591] add [NFEPROFOR] char(15) default '' with values

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- seventy-a []  mre []


-- 15set2011

-- TBS016: usuarios

alter table [TBS016] add [USUAUTPRE] char(1) default '' with values

-- TBS055: pedidos de vendas

alter table [TBS055] add [PDVTESEMP] smallint default 0 with values
alter table [TBS055] add [PDVTESCOD] smallint default 0 with values

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- seventy-a []  mre []


-- 6set2011

-- TBS006: fornecedores

alter table [TBS006] add [FORUSUALT] char(45) default '' with values

-- TBS043: orcamentos

alter table [TBS043] add [ORCSHELLBY] char(1) default '' with values
alter table [TBS043] add [ORCIMPROM]  char(1) default '' with values
alter table [TBS043] add [ORCTESEMP] smallint default 0 with values
alter table [TBS043] add [ORCTESCOD] smallint default 0 with values

-- TBS055: pedidos de vendas

alter table [TBS055] add [PDVIMPROM] char(1) default '' with values

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- seventy-a []  mre []


-- 25ago2011

-- TBS002: clientes

alter table [TBS002] add [CLIMENNFS] char(100) default '' with values

-- atualizados:
-- tanby sjc []  tanby tte []  papelyna []  misaspel [x]  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- seventy-a []  mre []


-- 19ago2011

-- TBS002: clientes

 CREATE  INDEX [ITBS002L] ON [dbo].[TBS002]([CATEMPCOD], [CATCOD], [CLIEMPCOD], [CLICOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS002M] ON [dbo].[TBS002]([RAMEMPCOD], [RAMCOD], [CLIEMPCOD], [CLICOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS002N] ON [dbo].[TBS002]([VENEMPCOD], [VENCOD], [CLIEMPCOD], [CLICOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS002O] ON [dbo].[TBS002]([CLICLA], [CLIEMPCOD], [CLICOD]) ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc []  tanby tte [x]  papelyna []  misaspel [x]  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- seventy-a []  mre [x]


-- 11ago2011

-- TBS090: servidores de banco de dados

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS090]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS090]
GO

CREATE TABLE [dbo].[TBS090] (
	[SBDSER] [char] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[SBDBANNOM] [char] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[SBDDRIACE] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[SBDUSUNOM] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[SBDUSUSEN] [char] (32) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS090] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[SBDSER],
		[SBDBANNOM]
	)  ON [PRIMARY] 
GO

-- TBS0165: servidores acessados pelo usuario

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0165]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0165]
GO

CREATE TABLE [dbo].[TBS0165] (
	[USUCOD] [char] (25) COLLATE Latin1_General_BIN NOT NULL ,
	[SBDSER] [char] (30) COLLATE Latin1_General_BIN NOT NULL ,
	[SBDBANNOM] [char] (30) COLLATE Latin1_General_BIN NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0165] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[USUCOD],
		[SBDSER],
		[SBDBANNOM]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS01652] ON [dbo].[TBS0165]([SBDSER], [SBDBANNOM]) ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc []  tanby tte [x]  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- seventy-a []  mre [x]


-- 9ago2011 -----------------------------------------------------------------------------------------------------------

-- TBS002: clientes

alter table [TBS002] add [CLIUSUALT] char(45) default '' with values
alter table [TBS002] add [CATEMPCOD] smallint default 0 with values
alter table [TBS002] add [CATCOD] smallint default 0 with values

-- TBS010: produtos

alter table [TBS010] add [PRODATALT] datetime default '17530101' with values
alter table [TBS010] add [PROUSUALT] char(25) default '' with values

-- TBS015: politica de precos

alter table [TBS015] add [PDPUSUALT] char(45) default '' with values

-- TBS089: categoria de clientes

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS089]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS089]
GO

CREATE TABLE [dbo].[TBS089] (
	[CATEMPCOD] [smallint] NOT NULL ,
	[CATCOD] [smallint] NOT NULL ,
	[CATDES] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[CATDATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS089] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CATEMPCOD],
		[CATCOD]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0891] ON [dbo].[TBS089]([CATEMPCOD], [CATDES]) ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc []  tanby tte [x]  papelyna []  misaspel [x]  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- seventy-a []  mre [x]


-- 19jul2011 -----------------------------------------------------------------------------------------------------------

-- TBS059: notas fiscais de entradas

alter table [TBS059] add [NFENUMCOL] int default 0 with values
alter table [TBS059] add [NFESHELLBY] char(1) default '' with values

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS086]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS086]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS087]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS087]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0871]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0871]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0872]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0872]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS088]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS088]
GO

CREATE TABLE [dbo].[TBS086] (
	[ATSCOD] [smallint] NOT NULL ,
	[ATSDES] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[ATSBLQ] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[ATSDATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS087] (
	[UTSCOD] [smallint] NOT NULL ,
	[UTSNOM] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[UTSSEN] [char] (32) COLLATE Latin1_General_BIN NULL ,
	[UTSCHA] [char] (32) COLLATE Latin1_General_BIN NULL ,
	[UTSHAS] [char] (32) COLLATE Latin1_General_BIN NULL ,
	[UTSBLQ] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[UTSDATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0871] (
	[UTSCOD] [smallint] NOT NULL ,
	[EMPCOD] [smallint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0872] (
	[UTSCOD] [smallint] NOT NULL ,
	[ATSCOD] [smallint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS088] (
	[LEPEMPCOD] [smallint] NOT NULL ,
	[LEPREG] [int] NOT NULL ,
	[LEPDATHOR] [datetime] NULL ,
	[USUCOD] [char] (25) COLLATE Latin1_General_BIN NULL ,
	[LEPPROCOD] [char] (15) COLLATE Latin1_General_BIN NULL ,
	[LEPPRODES] [char] (60) COLLATE Latin1_General_BIN NULL ,
	[LEPMARNOM] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[LEPPRODATCAD] [datetime] NULL ,
	[LEPPROEMP] [smallint] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS086] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ATSCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS087] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[UTSCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0871] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[UTSCOD],
		[EMPCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0872] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[UTSCOD],
		[ATSCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS088] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[LEPEMPCOD],
		[LEPREG]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0861] ON [dbo].[TBS086]([ATSDES]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS08711] ON [dbo].[TBS0871]([EMPCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS08721] ON [dbo].[TBS0872]([ATSCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0881] ON [dbo].[TBS088]([USUCOD]) ON [PRIMARY]
GO


-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna []  misaspel []  best bag []  best office []  tanby CD []  hoffmann & gomes []  sharpel []  ellipsis []  
-- seventy-a []  mre [x]


-- 22jun2011 -----------------------------------------------------------------------------------------------------------

-- TBS010: produtos

alter table [TBS010] add [PROINTBAL] char(1) default 'N' with values
alter table [TBS010] add [PROCODBAL] int default 0 with values

create nonclustered index [ITBS010Q] on [dbo].[TBS010] ([PROEMPCOD], [PROCODBAL]) on [PRIMARY]

-- atualizados:
-- tanby sjc []  tanby tte [x]  papelyna []  misaspel []  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes []  sharpel [x]  ellipsis []  
-- seventy-a []  mre [x]


-- 13jun2011 -----------------------------------------------------------------------------------------------------------

-- TBS025: parametros do sistema

alter table [TBS025] alter column [PARDES] char(80)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis []  
-- seventy-a []  mre [x]


-- 3jun2011 ------------------------------------------------------------------------------------------------------------

-- TBS010: produtos

alter table [TBS010] add [PROCSN] char(3) default '' with values
alter table [TBS010] add [PROCSNENT] char(3) default '' with values

create nonclustered index [ITBS0109] on [dbo].[TBS010] ([PROCSN]) on [PRIMARY]
create nonclustered index [ITBS01013] on [dbo].[TBS010] ([PROCSNENT]) on [PRIMARY]

-- TBS006: fornecedores

alter table [TBS006] add [FORFATSEG] decimal default 0 with values

-- TBS032: saldos dos produtos

alter table [TBS032] add [ESTFATSEG] decimal default 0 with values
alter table [TBS032] add [ESTLOTCMP] money default 0 with values
alter table [TBS032] add [ESTMAXCMP] money default 0 with values

-- TBS085: codigo de situacao de Operacao - simples nacional

CREATE TABLE [dbo].[TBS085] (
	[CSNCOD] [char] (3) COLLATE Latin1_General_BIN NOT NULL ,
	[CSNDES] [char] (60) COLLATE Latin1_General_BIN NULL ,
	[CSNICMS] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[CSNMSG] [char] (254) COLLATE Latin1_General_BIN NULL ,
	[CSNDATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS085] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CSNCOD]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0851] ON [dbo].[TBS085]([CSNDES]) ON [PRIMARY]
GO

-- alimentar tabela

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis []  
-- seventy-a [x]  mre [x]


-- 1jun2011 ------------------------------------------------------------------------------------------------------------

-- TBS080: nota fiscal eletronica

alter table [TBS080] alter column [ENFARQ] char(40)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [X]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis []  
-- seventy-a [x]  mre [x]


-- 26mai2011 -----------------------------------------------------------------------------------------------------------

-- TBS0431: itens do orcamento

alter table [TBS0431] add [ORCPBIISE] decimal default 0 with values
alter table [TBS0431] add [ORCPERICMSISE] smallmoney default 0 with values

-- TBS0671: itens da nota fiscal

alter table [TBS0671] add [NFSPBIISE] decimal default 0 with values
alter table [TBS0671] add [NFSPERICMSISE] smallmoney default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis []  
-- seventy-a [x]  mre [x]


-- 25mai2011 -----------------------------------------------------------------------------------------------------------

-- TBS0551: itens pedido de vendas

alter table [TBS0551] add [PDVPBIISE] decimal default 0 with values
alter table [TBS0551] add [PDVPERICMSISE] smallmoney default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis []  
-- seventy-a [x]  mre [x]


-- 16mai2011 -----------------------------------------------------------------------------------------------------------

-- TBS058: itens pendentes / reservados de pedidos de vendas

alter table [TBS058] add [PRPPRE] decimal default 0 with values

-- ferramenta FER005 - atualiza dados

-- TBS069: produtos faturados

alter table [TBS069] add [PDFPRELIQ] decimal default 0 with values

-- TMP002: tabela temporaria para aglutinacao de pedidos de vendas para emissao de nf

alter table [TMP002] add [T2_PRPPRE] decimal default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 5mai2011 ------------------------------------------------------------------------------------------------------------

-- TBS0431: itens orcamentos

alter table [TBS0431] add [ORCFREITE] decimal default 0 with values
alter table [TBS0431] add [ORCSEGITE] decimal default 0 with values
alter table [TBS0431] add [ORCDESITE] decimal default 0 with values

-- TBS0671: itens notas fiscais

alter table [TBS0671] add [NFSFREITE] decimal default 0 with values
alter table [TBS0671] add [NFSSEGITE] decimal default 0 with values
alter table [TBS0671] add [NFSDESITE] decimal default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 26abr2011 -----------------------------------------------------------------------------------------------------------

-- TBS0551: itens pedidos de vendas

alter table [TBS0551] add [PDVFREITE] decimal default 0 with values
alter table [TBS0551] add [PDVSEGITE] decimal default 0 with values
alter table [TBS0551] add [PDVDESITE] decimal default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 13abr2011 -----------------------------------------------------------------------------------------------------------

-- TBS002: clientes

alter table [TBS002] add [CLISIT] char(1) default 'A' with values

create nonclustered index [ITBS002J] on [dbo].[TBS002] ([CLIEMPCOD], [CLISIT ] ,[CLIUCPDAT]) on [PRIMARY]

-- TBS006: fornecedores

alter table [TBS006] add [FORSIT] char(1) default 'A' with values

create nonclustered index [ITBS006B] on [dbo].[TBS006] ([FOREMPCOD], [FORSIT ] ,[FORUCPDAT]) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 12abr2011 -----------------------------------------------------------------------------------------------------------

-- TBS043: orcamentos

alter table [TBS043] add [ORCUSUGER] char(45) default '' with values

-- TBS055: pedidos de vendas

alter table [TBS055] add [PDVUSUGER] char(45) default '' with values

-- TBS0551: itens pedidos vendas

create nonclustered index [ITBS05518] on [dbo].[TBS0551] ([PDVEMPCOD], [PDVNUM] DESC) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]

-- 29mar2011 -----------------------------------------------------------------------------------------------------------

-- TBS0591: itens notas fiscais entradas

alter table [TBS0591] alter column [NFEDES] char(60)

-- TBS0761: itens solicitacoes compras

alter table [TBS0761] alter column [SDCPRODES] char(60)

-- TMP009: temporaria

alter table [TMP009] alter column [T9_PRODES] char(60)

-- TMP007: temporaria

alter table [TMP007] alter column [T7_PRODES] char(60)

-- TMP003: temporaria

alter table [TMP003] alter column [T3_PRODES] char(60)

-- TMP001: temporaria

alter table [TMP001] alter column [T1_DESCRICAO] char(60)

-- TBS069: itens faturados

alter table [TBS069] alter column [PDFPRODES] char(60)

-- TBS0671: itens notas fiscais saidas

alter table [TBS0671] alter column [NFSPRODES] char(60)

-- TBS058: pedidos pendentes/reservados

alter table [TBS058] alter column [PRPPRODES] char(60)

-- TBS0551: itens pedidos vendas

alter table [TBS0551] alter column [PDVDES] char(60)

-- TBS0521: tabela contrato

alter table [TBS0521] alter column [TDCPRODES] char(60)

-- TBS049: manutencao produtos

alter table [TBS049] alter column [MDSPRODES] char(60)

-- TBS0451: itens pedidos compras

alter table [TBS0451] alter column [PDCDES] char(60)

-- TBS0431: itens orcamentos

alter table [TBS0431] alter column [ORCDES] char(60)

-- TBS0371: itens movimentos internos

alter table [TBS0371] alter column [MVIPRODES] char(60)

-- TBS030: produtos associados

alter table [TBS030] alter column [CASDES] char(60)

-- TBS0261: tabela precos contrato

alter table [TBS0261] alter column [TPCPRODES] char(60)

-- TBS013: inventario

alter table [TBS013] alter column [INVPRODES] char(60)

-- TBS010: produtos

alter table [TBS010] alter column [PRODES] char(60)
alter table [TBS010] alter column [PRODESWEB] char(60)
alter table [TBS010] alter column [PRODESTMP] char(60)

-- TBS015: politica de precos

alter table [TBS015] alter column [PRODES] char(60)

-- TBS032: saldos produtos

alter table [TBS032] alter column [PRODES] char(60)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 23mar2011 -----------------------------------------------------------------------------------------------------------

-- TBS002: clientes

alter table [TBS002] alter column [CLIMAILNFE] char(300)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 16mar2011 -----------------------------------------------------------------------------------------------------------

-- TBS043: orcamentos

create nonclustered index [ITBS043B] on [dbo].[TBS043] ([ORCEMPCOD], [ORCDATCAD] DESC) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 15mar2011 -----------------------------------------------------------------------------------------------------------

-- TBS059: notas fiscais de entrada

alter table [TBS059] add [NFEEMPNFS] smallint default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 4mar2011 ------------------------------------------------------------------------------------------------------------

-- TBS0811: controle de atributos

alter table [TBS0811] add [CDACTRINS] char(1) default 'N' with values
alter table [TBS0811] add [CDACTRALT] char(1) default 'S' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [X]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 1mar2011 ------------------------------------------------------------------------------------------------------------

-- TBS002: clientes

alter table [TBS002] add [CLIMAILNFE] char(300) default '' with values

-- CLIMAIL, CLIMAILENT, CLIMAILCOB

-- TBS004: vendedores
-- VENEMAIL

-- TBS005: transportadoras
-- TRNEMAIL

-- TBS006: fornecedores
-- FOREMAIL

-- TBS007: bancos
-- BANEMAIL

-- TBS016: usuarios
-- USUEMAIL

-- TBS023: empresas
-- EMPEMAIL, EMPEMAILENT, EMPEMAILCOB

-- TBS038: prospect
-- PSTEMAIL

-- TBS047: requisitantes
-- REQEMAIL

-- TBS079: licenciamento
-- LICEMPEMAIL

-- todos char(60)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  
-- seventy-a [x]  mre [x]


-- 25fev2011 -----------------------------------------------------------------------------------------------------------

alter table [TBS0591] add [NFEPROLOT] char(1) default '' with values

-- TBS002: clientes

alter table [TBS002] alter column [CLINOM] char(60)
alter table [TBS002] alter column [CLIEND] char(60)

-- TBS023: empresas

alter table [TBS023] alter column [EMPEND] char(60)

-- TBS056: contas a receber

alter table [TBS056] alter column [CLINOM] char(60)

-- TBS078: cheques

alter table [TBS078] alter column [CLINOM] char(60)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]  mre [x]


-- 23fev2011 -----------------------------------------------------------------------------------------------------------

-- TBS042: tipos entradas/saidas

alter table [TBS042] add [TESCFONAOCTB] char(5) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]  mre [x]


-- 18fev2011 -----------------------------------------------------------------------------------------------------------

-- MSL002: movimento vendas GZ

create nonclustered index [IMSL0023] on [dbo].[MSL002] ([M2_NUMNFS]) on [PRIMARY]
create nonclustered index [IMSL0024] on [dbo].[MSL002] ([M2_DAT] ,[M2_TIPREG]) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]  mre [x]


-- TBS0431: itens dos orcamentos

create nonclustered index [ITBS04318] on [dbo].[TBS0431] ([ORCEMPCOD], [ORCNUM] ,[ORCORD]) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]  mre [x]


-- 31jan2011 -----------------------------------------------------------------------------------------------------------

-- TBS023: empresas

alter table [TBS023] alter column [EMPNOM] char(60)
alter table [TBS023] alter column [EMPEND] char(60)

-- TBS043: orcamentos

-- TBS0671: itens da nota fiscal de saida

alter table [TBS043] alter column [ORCPDDTOT] decimal(7,4)

-- TBS079: licenca de uso

CREATE TABLE [dbo].[TBS079] (
	[LICEMPINS] [char] (14) COLLATE Latin1_General_BIN NOT NULL ,
	[LICEMPNOM] [char] (50) COLLATE Latin1_General_BIN NULL ,
	[LICEMPCONT] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[LICEMPEMAIL] [char] (40) COLLATE Latin1_General_BIN NULL ,
	[LICEMPTEL] [char] (15) COLLATE Latin1_General_BIN NULL ,
	[LICDATINI] [datetime] NULL ,
	[LICDATFIN] [datetime] NULL ,
	[LICNUMCON] [smallint] NULL ,
	[LICCHA] [char] (64) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS079] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[LICEMPINS]
	)  ON [PRIMARY] 
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]  mre [x]


-- 26jan2011 -----------------------------------------------------------------------------------------------------------

-- TBS007: contas correntes

alter table [TBS007] add [BANNOMCED] char(40) default '' with values
alter table [TBS007] add [BANNOMSAC] char(40) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]  mre [x]


-- 25jan2011 -----------------------------------------------------------------------------------------------------------

-- TBS047: requisitantes

alter table [TBS047] add [REQDATADM] datetime default '17530101' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]  mre [x]


-- 20jan2011 -----------------------------------------------------------------------------------------------------------

-- TBS0431: itens do orcamento

alter table [TBS0431] add [ORCORD] int default 0 with values

-- TBS0551: itens do pedido

alter table [TBS0551] add [PDVORD] int default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]  mre [x]


-- 14dez2010 -----------------------------------------------------------------------------------------------------------

alter table [TBS015] alter column [PDPPREFOR] decimal(11,4)
alter table [TBS031] alter column [TDPPREFOR] decimal(11,4)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]


-- 13dez2010 -----------------------------------------------------------------------------------------------------------

alter table [TBS0371] add [MVIPROLOT] char(1) default 'N' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]


-- 2dez2010 ------------------------------------------------------------------------------------------------------------

-- TBS002: clientes

alter table [TBS002] add [CLIMAILCOB] char(40) default '' with values
alter table [TBS002] add [CLIMAILENT] char(40) default '' with values

alter table [TBS080] add [ENFDATHORPRO] datetime default '17530101' with values
alter table [TBS080] add [ENFPROCAN] decimal(15,0) default 0 with values
alter table [TBS080] add [ENFDEHPROCAN] datetime default '17530101' with values
alter table [TBS080] add [ENFPROINU] decimal(15,0) default 0 with values
alter table [TBS080] add [ENFDEHPROINU] datetime default '17530101' with values
alter table [TBS080] add [ENFJUSINU] char(255) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]


-- 22nov2010 ------------------------------------------------------------------------------------------------------------

-- TBS025: parametros

-- alter table [TBS025] alter column [PARVAL] char(150)
-- alterar manualmente, pois dah um erro de dependencia

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]


-- 19nov2010 ------------------------------------------------------------------------------------------------------------

-- MSL002/TBS080

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS080]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS080]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0801]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0801]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MSL002]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[MSL002]
GO

CREATE TABLE [dbo].[TBS080] (
	[ENFEMPCOD] [smallint] NOT NULL ,
	[ENFNUM] [int] NOT NULL ,
	[ENFTIPDOC] [smallint] NULL ,
	[ENFMOD] [smallint] NULL ,
	[ENFSER] [smallint] NULL ,
	[ENFDATEMI] [datetime] NULL ,
	[ENFFORDAN] [smallint] NULL ,
	[ENFFORPAG] [smallint] NULL ,
	[ENFFOREMI] [smallint] NULL ,
	[ENFCNPJCPF] [char] (18) COLLATE Latin1_General_BIN NULL ,
	[ENFFINEMI] [smallint] NULL ,
	[ENFDESREM] [char] (60) COLLATE Latin1_General_BIN NULL ,
	[ENFVALTOT] [money] NULL ,
	[ENFCHAACE] [char] (44) COLLATE Latin1_General_BIN NULL ,
	[ENFDANIMP] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[ENFCODDES] [int] NULL ,
	[ENFSIT] [smallint] NULL ,
	[ENFARQ] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[ENFRECIBO] [decimal](15, 0) NULL ,
	[ENFPROTOC] [decimal](15, 0) NULL ,
	[ENFDIGVAL] [char] (28) COLLATE Latin1_General_BIN NULL ,
	[ENFJUSTIF] [char] (255) COLLATE Latin1_General_BIN NULL ,
	[ENFEMAIL] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[ENFTIPENT] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[ENFESTDES] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[ENFVENCOD] [smallint] NULL ,
	[ENFTIPAMB] [smallint] NULL ,
	[ENFDATHORPRO] [datetime] NULL ,
	[ENFPROCAN] [decimal](15, 0) NULL ,
	[ENFDEHPROCAN] [datetime] NULL ,
	[ENFPROINU] [decimal](15, 0) NULL ,
	[ENFDEHPROINU] [datetime] NULL ,
	[ENFJUSINU] [char] (255) COLLATE Latin1_General_BIN NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0801] (
	[ENFEMPCOD] [smallint] NOT NULL ,
	[ENFNUM] [int] NOT NULL ,
	[ENFDATHOR] [datetime] NOT NULL ,
	[ENFCODPRO] [smallint] NULL ,
	[ENFDESPRO] [char] (250) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[MSL002] (
	[M2_EMPCOD] [smallint] NOT NULL ,
	[M2_LOJ] [smallint] NOT NULL ,
	[M2_CXA] [smallint] NOT NULL ,
	[M2_NUMDOC] [int] NOT NULL ,
	[M2_NUMPED] [char] (8) COLLATE Latin1_General_BIN NOT NULL ,
	[M2_TIPDOC] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[M2_TIPREG] [char] (2) COLLATE Latin1_General_BIN NOT NULL ,
	[M2_PROCOD] [char] (15) COLLATE Latin1_General_BIN NOT NULL ,
	[M2_NUMORDITE] [int] NOT NULL ,
	[M2_TIPPRO] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[M2_QTD] [smallmoney] NULL ,
	[M2_VALUNI] [money] NULL ,
	[M2_VALTOT] [money] NULL ,
	[M2_CODVEN] [smallint] NULL ,
	[M2_CODEMP] [smallint] NULL ,
	[M2_CODCLI] [decimal](16, 0) NULL ,
	[M2_TIPCLI] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[M2_OPE] [smallint] NULL ,
	[M2_DAT] [datetime] NULL ,
	[M2_HOR] [char] (5) COLLATE Latin1_General_BIN NULL ,
	[M2_FINVEN] [char] (3) COLLATE Latin1_General_BIN NULL ,
	[M2_CGCCPFCHQ] [char] (19) COLLATE Latin1_General_BIN NULL ,
	[M2_BANNUM] [char] (3) COLLATE Latin1_General_BIN NULL ,
	[M2_BANAGE] [char] (7) COLLATE Latin1_General_BIN NULL ,
	[M2_CTAANT] [char] (9) COLLATE Latin1_General_BIN NULL ,
	[M2_NUMCHQ] [char] (6) COLLATE Latin1_General_BIN NULL ,
	[M2_VENCHQ] [datetime] NULL ,
	[M2_RES] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[M2_CODTIT] [int] NULL ,
	[M2_SEQ] [smallint] NULL ,
	[M2_VIA] [smallint] NULL ,
	[M2_NUMBOL] [int] NULL ,
	[M2_CODPAG] [smallint] NULL ,
	[M2_CONPAG] [char] (10) COLLATE Latin1_General_BIN NULL ,
	[M2_TEL] [char] (10) COLLATE Latin1_General_BIN NULL ,
	[M2_CTAATU] [char] (10) COLLATE Latin1_General_BIN NULL ,
	[M2_CMCSETDOC] [char] (70) COLLATE Latin1_General_BIN NULL ,
	[M2_REDDESTRN] [smallint] NULL ,
	[M2_TIPTRN] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[M2_NUMCART] [char] (40) COLLATE Latin1_General_BIN NULL ,
	[M2_TIPDOCPAG] [smallint] NULL ,
	[M2_STATRN] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[M2_VALTRO] [money] NULL ,
	[M2_TABPRE] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[M2_PONCED] [decimal](7, 4) NULL ,
	[M2_TRB] [char] (6) COLLATE Latin1_General_BIN NULL ,
	[M2_PRIDOCDIG] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[M2_COO] [int] NULL ,
	[M2_SEGDOCDIG] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[M2_TERDOCDIG] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[M2_QUADOCDIG] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[M2_NUMECF] [smallint] NULL ,
	[M2_SUP] [smallint] NULL ,
	[M2_DATMOV] [datetime] NULL ,
	[M2_CODBARDIG] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[M2_DESITE] [money] NULL ,
	[M2_ABT] [money] NULL ,
	[M2_ACR] [money] NULL ,
	[M2_TIPPAR] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[M2_CODTABPRE] [int] NULL ,
	[M2_BINCAR] [char] (6) COLLATE Latin1_General_BIN NULL ,
	[M2_NUMPAR] [smallint] NULL ,
	[M2_REGCAN] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[M2_FINVENANT] [char] (3) COLLATE Latin1_General_BIN NULL ,
	[M2_TIPREGFIN] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[M2_NUMTICTRO] [int] NULL ,
	[M2_TAN] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[M2_BIC] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[M2_NUMABA] [int] NULL ,
	[M2_NUMSEQABA] [int] NULL ,
	[M2_LOCCANREG] [smallint] NULL ,
	[M2_CODLISCAS] [decimal](10, 0) NULL ,
	[M2_C1] [smallint] NULL ,
	[M2_C2] [smallint] NULL ,
	[M2_C3] [smallint] NULL ,
	[M2_CONCUPFIS] [int] NULL ,
	[M2_CAMCOM] [smallint] NULL ,
	[M2_DESPROPREMUL] [money] NULL ,
	[M2_DESPROCAM] [money] NULL ,
	[M2_CONREDZ] [int] NULL ,
	[M2_NSUALTTEF] [char] (15) COLLATE Latin1_General_BIN NULL ,
	[M2_CODCARCLI] [smallint] NULL ,
	[M2_QTDREFPRO] [int] NULL ,
	[M2_QTDMAXREF] [int] NULL ,
	[M2_CONSEQFIS] [int] NULL ,
	[M2_CONSEQNAOFIS] [int] NULL ,
	[M2_ACRITE] [money] NULL ,
	[M2_NUMDAVPED] [decimal](10, 0) NULL ,
	[M2_TITDAVPED] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[M2_NUMNFS] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS080] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ENFEMPCOD],
		[ENFNUM]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0801] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ENFEMPCOD],
		[ENFNUM],
		[ENFDATHOR]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[MSL002] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[M2_EMPCOD],
		[M2_LOJ],
		[M2_CXA],
		[M2_NUMDOC],
		[M2_NUMPED],
		[M2_TIPDOC],
		[M2_TIPREG],
		[M2_PROCOD],
		[M2_NUMORDITE]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0801] ON [dbo].[TBS080]([ENFEMPCOD], [ENFNUM] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0802] ON [dbo].[TBS080]([ENFEMPCOD], [ENFCHAACE]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0803] ON [dbo].[TBS080]([ENFEMPCOD], [ENFDESREM]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0804] ON [dbo].[TBS080]([ENFEMPCOD], [ENFDATEMI]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS08013] ON [dbo].[TBS0801]([ENFEMPCOD], [ENFNUM], [ENFDATHOR] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [IMSL0021] ON [dbo].[MSL002]([M2_EMPCOD], [M2_LOJ], [M2_CXA], [M2_TIPREG], [M2_NUMORDITE]) ON [PRIMARY]
GO


-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]


-- 11nov2010 ------------------------------------------------------------------------------------------------------------

-- TBS023: empresas

alter table [TBS023] add [EMPIMU] char(15) default '' with values
alter table [TBS023] add [EMPCNAE] char(7) default '' with values

-- TBS025: parametros do sistema

delete TBS025 where PARCHV=1115

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]  sharpel [x]  ellipsis [x]  seventy-a [x]


-- decidir como proceder com tabela TBS059 / 1 / 2 / 3

-- se existem dados lancados

alter table [TBS023] add [NFEDATVEN] [datetime] NOT NULL ,
	[NFEVALPAR] [money] NULL 
alter table [TBS0591] add [NFEPROLOT] char(1) default '' with values

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS059]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS059]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0591]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0591]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0592]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0592]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0593]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0593]
GO

CREATE TABLE [dbo].[TBS059] (
	[NFEEMPCOD] [smallint] NOT NULL ,
	[NFETIP] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[NFENUM] [int] NOT NULL ,
	[NFECOD] [int] NOT NULL ,
	[NFENOSFOR] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[NFEEMPFC] [smallint] NULL ,
	[NFENOM] [char] (50) COLLATE Latin1_General_BIN NULL ,
	[NFEUSUEFE] [char] (45) COLLATE Latin1_General_BIN NULL ,
	[NFEDATEMI] [datetime] NULL ,
	[NFEULTITE] [smallint] NULL ,
	[NFEOBS] [char] (254) COLLATE Latin1_General_BIN NULL ,
	[SEREMPCOD] [smallint] NULL ,
	[SERCOD] [char] (3) COLLATE Latin1_General_BIN NULL ,
	[TPTEMPCOD] [smallint] NULL ,
	[TPTCOD] [char] (3) COLLATE Latin1_General_BIN NULL ,
	[NFEGERPDC] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[NFEDADVAL] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[NFEESTORI] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[NFEVALFRE] [money] NULL ,
	[NFEVALDES] [money] NULL ,
	[NFEVDDTOT] [money] NULL ,
	[NFETOTICMS] [money] NULL ,
	[NFETOTBAS] [money] NULL ,
	[NFETOTIPI] [money] NULL ,
	[NFEBASSUB] [money] NULL ,
	[NFEVALSUB] [money] NULL ,
	[NFEVALSEG] [money] NULL ,
	[NFECAN] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[NFEDATCAN] [datetime] NULL ,
	[NFEUSUCAN] [char] (25) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0591] (
	[NFEEMPCOD] [smallint] NOT NULL ,
	[NFETIP] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[NFENUM] [int] NOT NULL ,
	[NFECOD] [int] NOT NULL ,
	[NFEITE] [smallint] NOT NULL ,
	[PROCOD] [char] (15) COLLATE Latin1_General_BIN NULL ,
	[PROEMPCOD] [smallint] NULL ,
	[NFEDES] [char] (50) COLLATE Latin1_General_BIN NULL ,
	[NFEQTD] [money] NULL ,
	[NFEUNI] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[NFEQTDEMB] [money] NULL ,
	[NFEPRE] [decimal](13, 6) NULL ,
	[NFEPDDITE] [decimal](8, 5) NULL ,
	[LESCOD] [smallint] NULL ,
	[LESEMPCOD] [smallint] NULL ,
	[TESCOD] [smallint] NULL ,
	[TESEMPCOD] [smallint] NULL ,
	[NFEMOVEST] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[NFEPBI] [decimal](8, 5) NULL ,
	[NFEPERICMS] [smallmoney] NULL ,
	[NFECFOP] [char] (5) COLLATE Latin1_General_BIN NULL ,
	[NFECST] [char] (3) COLLATE Latin1_General_BIN NULL ,
	[NFEEFS] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[NFEPDCNUM] [int] NULL ,
	[NFEPDCITE] [smallint] NULL ,
	[NFEPDVNUM] [int] NULL ,
	[NFEPDVITE] [smallint] NULL ,
	[NFENFSNUM] [int] NULL ,
	[NFENFSITE] [smallint] NULL ,
	[NFEPERIPI] [smallmoney] NULL ,
	[NFEBASICMS] [money] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0592] (
	[NFEEMPCOD] [smallint] NOT NULL ,
	[NFETIP] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[NFENUM] [int] NOT NULL ,
	[NFECOD] [int] NOT NULL ,
	[NFEITE] [smallint] NOT NULL ,
	[NFETIPPED] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[NFEPEDEMP] [smallint] NOT NULL ,
	[NFEPEDNUM] [int] NOT NULL ,
	[NFEPEDITE] [smallint] NOT NULL ,
	[NFEPEDUNI] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[NFEPEDQTD] [money] NULL ,
	[NFEPEDEMB] [money] NULL ,
	[NFEATEQTD] [money] NULL ,
	[NFEATEDAT] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0593] (
	[NFEEMPCOD] [smallint] NOT NULL ,
	[NFETIP] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[NFENUM] [int] NOT NULL ,
	[NFECOD] [int] NOT NULL ,
	[NFEDATVEN] [datetime] NOT NULL ,
	[NFEVALPAR] [money] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS059] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[NFEEMPCOD],
		[NFETIP],
		[NFENUM],
		[NFECOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0591] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[NFEEMPCOD],
		[NFETIP],
		[NFENUM],
		[NFECOD],
		[NFEITE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0592] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[NFEEMPCOD],
		[NFETIP],
		[NFENUM],
		[NFECOD],
		[NFEITE],
		[NFETIPPED],
		[NFEPEDEMP],
		[NFEPEDNUM],
		[NFEPEDITE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0593] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[NFEEMPCOD],
		[NFETIP],
		[NFENUM],
		[NFECOD],
		[NFEDATVEN]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS059] ADD 
	CONSTRAINT [DF_TBS059_NFEEMPCOD] DEFAULT (0) FOR [NFEEMPCOD],
	CONSTRAINT [DF_TBS059_NFETIP] DEFAULT ('') FOR [NFETIP],
	CONSTRAINT [DF_TBS059_NFENUM] DEFAULT (0) FOR [NFENUM],
	CONSTRAINT [DF_TBS059_NFECOD] DEFAULT (0) FOR [NFECOD],
	CONSTRAINT [DF_TBS059_NFENOSFOR] DEFAULT ('') FOR [NFENOSFOR],
	CONSTRAINT [DF_TBS059_NFEEMPFC] DEFAULT (0) FOR [NFEEMPFC],
	CONSTRAINT [DF_TBS059_NFENOM] DEFAULT ('') FOR [NFENOM],
	CONSTRAINT [DF_TBS059_NFEUSUEFE] DEFAULT ('') FOR [NFEUSUEFE],
	CONSTRAINT [DF_TBS059_NFEDATEMI] DEFAULT ('17530101') FOR [NFEDATEMI],
	CONSTRAINT [DF_TBS059_NFEULTITE] DEFAULT (0) FOR [NFEULTITE],
	CONSTRAINT [DF_TBS059_NFEOBS] DEFAULT ('') FOR [NFEOBS],
	CONSTRAINT [DF_TBS059_SEREMPCOD] DEFAULT (0) FOR [SEREMPCOD],
	CONSTRAINT [DF_TBS059_SERCOD] DEFAULT ('') FOR [SERCOD],
	CONSTRAINT [DF_TBS059_TPTEMPCOD] DEFAULT (0) FOR [TPTEMPCOD],
	CONSTRAINT [DF_TBS059_TPTCOD] DEFAULT ('') FOR [TPTCOD],
	CONSTRAINT [DF_TBS059_NFEGERPDC] DEFAULT ('') FOR [NFEGERPDC],
	CONSTRAINT [DF_TBS059_NFEDADVAL] DEFAULT ('') FOR [NFEDADVAL],
	CONSTRAINT [DF_TBS059_NFEESTORI] DEFAULT ('') FOR [NFEESTORI],
	CONSTRAINT [DF_TBS059_NFEVALFRE] DEFAULT (0) FOR [NFEVALFRE],
	CONSTRAINT [DF_TBS059_NFEVALDES] DEFAULT (0) FOR [NFEVALDES],
	CONSTRAINT [DF__TBS059__NFEVDDTO__73E5190C] DEFAULT (0) FOR [NFEVDDTOT],
	CONSTRAINT [DF__TBS059__NFETOTIC__74D93D45] DEFAULT (0) FOR [NFETOTICMS],
	CONSTRAINT [DF__TBS059__NFETOTBA__75CD617E] DEFAULT (0) FOR [NFETOTBAS],
	CONSTRAINT [DF__TBS059__NFETOTIP__76C185B7] DEFAULT (0) FOR [NFETOTIPI],
	CONSTRAINT [DF__TBS059__NFEBASSU__77B5A9F0] DEFAULT (0) FOR [NFEBASSUB],
	CONSTRAINT [DF__TBS059__NFEVALSU__78A9CE29] DEFAULT (0) FOR [NFEVALSUB],
	CONSTRAINT [DF__TBS059__NFEVALSE__799DF262] DEFAULT (0) FOR [NFEVALSEG],
	CONSTRAINT [DF__TBS059__NFECAN__7A92169B] DEFAULT ('') FOR [NFECAN],
	CONSTRAINT [DF__TBS059__NFEDATCA__7B863AD4] DEFAULT ('17530101') FOR [NFEDATCAN],
	CONSTRAINT [DF__TBS059__NFEUSUCA__7C7A5F0D] DEFAULT ('') FOR [NFEUSUCAN]
GO

 CREATE  INDEX [ITBS0598] ON [dbo].[TBS059]([TPTEMPCOD], [TPTCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0597] ON [dbo].[TBS059]([SEREMPCOD], [SERCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0592] ON [dbo].[TBS059]([NFEEMPCOD], [NFECOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0593] ON [dbo].[TBS059]([NFEEMPCOD], [NFEDATEMI]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0594] ON [dbo].[TBS059]([NFEEMPCOD], [NFEUSUEFE]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0595] ON [dbo].[TBS059]([NFEEMPCOD], [NFENOM]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0599] ON [dbo].[TBS059]([NFEEMPCOD], [NFENUM], [NFECOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS059A] ON [dbo].[TBS059]([NFEEMPCOD], [NFENUM], [NFEDATEMI]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0591] ADD 
	CONSTRAINT [DF_TBS0591_NFEEMPCOD] DEFAULT (0) FOR [NFEEMPCOD],
	CONSTRAINT [DF_TBS0591_NFETIP] DEFAULT ('') FOR [NFETIP],
	CONSTRAINT [DF_TBS0591_NFENUM] DEFAULT (0) FOR [NFENUM],
	CONSTRAINT [DF_TBS0591_NFECOD] DEFAULT (0) FOR [NFECOD],
	CONSTRAINT [DF_TBS0591_NFEITE] DEFAULT (0) FOR [NFEITE],
	CONSTRAINT [DF_TBS0591_PROCOD] DEFAULT ('') FOR [PROCOD],
	CONSTRAINT [DF_TBS0591_PROEMPCOD] DEFAULT (0) FOR [PROEMPCOD],
	CONSTRAINT [DF_TBS0591_NFEDES] DEFAULT ('') FOR [NFEDES],
	CONSTRAINT [DF_TBS0591_NFEQTD] DEFAULT (0) FOR [NFEQTD],
	CONSTRAINT [DF_TBS0591_NFEUNI] DEFAULT ('') FOR [NFEUNI],
	CONSTRAINT [DF_TBS0591_NFEQTDEMB] DEFAULT (0) FOR [NFEQTDEMB],
	CONSTRAINT [DF_TBS0591_NFEPRE] DEFAULT (0) FOR [NFEPRE],
	CONSTRAINT [DF_TBS0591_NFEPDDITE] DEFAULT (0) FOR [NFEPDDITE],
	CONSTRAINT [DF_TBS0591_LESCOD] DEFAULT (0) FOR [LESCOD],
	CONSTRAINT [DF_TBS0591_LESEMPCOD] DEFAULT (0) FOR [LESEMPCOD],
	CONSTRAINT [DF_TBS0591_TESCOD] DEFAULT (0) FOR [TESCOD],
	CONSTRAINT [DF_TBS0591_TESEMPCOD] DEFAULT (0) FOR [TESEMPCOD],
	CONSTRAINT [DF_TBS0591_NFEMOVEST] DEFAULT ('') FOR [NFEMOVEST],
	CONSTRAINT [DF_TBS0591_NFEPBI] DEFAULT (0) FOR [NFEPBI],
	CONSTRAINT [DF_TBS0591_NFEPERICMS] DEFAULT (0) FOR [NFEPERICMS],
	CONSTRAINT [DF_TBS0591_NFECFOP] DEFAULT ('') FOR [NFECFOP],
	CONSTRAINT [DF_TBS0591_NFECST] DEFAULT ('') FOR [NFECST],
	CONSTRAINT [DF_TBS0591_NFEEFS] DEFAULT ('') FOR [NFEEFS],
	CONSTRAINT [DF_TBS0591_NFEPDCNUM] DEFAULT (0) FOR [NFEPDCNUM],
	CONSTRAINT [DF_TBS0591_NFEPDCITE] DEFAULT (0) FOR [NFEPDCITE],
	CONSTRAINT [DF_TBS0591_NFEPDVNUM] DEFAULT (0) FOR [NFEPDVNUM],
	CONSTRAINT [DF_TBS0591_NFEPDVITE] DEFAULT (0) FOR [NFEPDVITE],
	CONSTRAINT [DF_TBS0591_NFENFSNUM] DEFAULT (0) FOR [NFENFSNUM],
	CONSTRAINT [DF_TBS0591_NFENFSITE] DEFAULT (0) FOR [NFENFSITE],
	CONSTRAINT [DF_TBS0591_NFEPERIPI] DEFAULT (0) FOR [NFEPERIPI],
	CONSTRAINT [DF__TBS0591__NFEBASI__7D6E8346] DEFAULT (0) FOR [NFEBASICMS]
GO

 CREATE  INDEX [ITBS05911] ON [dbo].[TBS0591]([TESEMPCOD], [TESCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS05912] ON [dbo].[TBS0591]([LESEMPCOD], [LESCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS05913] ON [dbo].[TBS0591]([PROEMPCOD], [PROCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS05917] ON [dbo].[TBS0591]([NFEEMPCOD], [NFETIP], [NFENUM], [NFECOD], [PROCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS05918] ON [dbo].[TBS0591]([NFEEMPCOD], [PROCOD], [NFENUM], [NFECOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0591A] ON [dbo].[TBS0591]([NFEEMPCOD], [NFENUM], [TESCOD]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0592] ADD 
	CONSTRAINT [DF_TBS0592_NFEEMPCOD] DEFAULT (0) FOR [NFEEMPCOD],
	CONSTRAINT [DF_TBS0592_NFETIP] DEFAULT ('') FOR [NFETIP],
	CONSTRAINT [DF_TBS0592_NFENUM] DEFAULT (0) FOR [NFENUM],
	CONSTRAINT [DF_TBS0592_NFECOD] DEFAULT (0) FOR [NFECOD],
	CONSTRAINT [DF_TBS0592_NFEITE] DEFAULT (0) FOR [NFEITE],
	CONSTRAINT [DF_TBS0592_NFETIPPED] DEFAULT ('') FOR [NFETIPPED],
	CONSTRAINT [DF_TBS0592_NFEPEDEMP] DEFAULT (0) FOR [NFEPEDEMP],
	CONSTRAINT [DF_TBS0592_NFEPEDNUM] DEFAULT (0) FOR [NFEPEDNUM],
	CONSTRAINT [DF_TBS0592_NFEPEDITE] DEFAULT (0) FOR [NFEPEDITE],
	CONSTRAINT [DF_TBS0592_NFEPEDUNI] DEFAULT ('') FOR [NFEPEDUNI],
	CONSTRAINT [DF_TBS0592_NFEPEDQTD] DEFAULT (0) FOR [NFEPEDQTD],
	CONSTRAINT [DF_TBS0592_NFEPEDEMB] DEFAULT (0) FOR [NFEPEDEMB],
	CONSTRAINT [DF_TBS0592_NFEATEQTD] DEFAULT (0) FOR [NFEATEQTD],
	CONSTRAINT [DF_TBS0592_NFEATEDAT] DEFAULT ('17530101') FOR [NFEATEDAT]
GO

 CREATE  INDEX [ITBS05923] ON [dbo].[TBS0592]([NFEEMPCOD], [NFETIP], [NFENUM], [NFECOD], [NFETIPPED], [NFEPEDEMP], [NFEPEDNUM], [NFEPEDITE]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0593] ADD 
	CONSTRAINT [DF_TBS0593_NFEEMPCOD] DEFAULT (0) FOR [NFEEMPCOD],
	CONSTRAINT [DF_TBS0593_NFETIP] DEFAULT ('') FOR [NFETIP],
	CONSTRAINT [DF_TBS0593_NFENUM] DEFAULT (0) FOR [NFENUM],
	CONSTRAINT [DF_TBS0593_NFECOD] DEFAULT (0) FOR [NFECOD],
	CONSTRAINT [DF_TBS0593_NFEDATVEN] DEFAULT ('17530101') FOR [NFEDATVEN],
	CONSTRAINT [DF_TBS0593_NFEVALPAR] DEFAULT (0) FOR [NFEVALPAR]
GO



-- 5out2010 -------------------------------------------------------------------------------------------------------------

-- TBS002: clientes

 CREATE  INDEX [ITBS002E] ON [dbo].[TBS002]([CLIEMPCOD], [CLICONTAT]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS002F] ON [dbo].[TBS002]([CLIEMPCOD], [CLIBAI]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS002G] ON [dbo].[TBS002]([CLIEMPCOD], [CLITEL]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS002H] ON [dbo].[TBS002]([CLIEMPCOD], [CLITEL2]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS002I] ON [dbo].[TBS002]([CLIEMPCOD], [CLITEL3]) ON [PRIMARY]
GO

-- TBS049: manutencao saldos produtos

alter table [TBS049] drop [OCOROT]

-- TBS0491: manutencao saldos produtos (por lote)

CREATE TABLE [dbo].[TBS0491] (
	[MDSEMPCOD] [smallint] NOT NULL ,
	[MDSREG] [int] NOT NULL ,
	[MDSDATVAL] [datetime] NOT NULL ,
	[MDSNUMLOT] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[MDSDATFAB] [datetime] NULL ,
	[MDSQTDLOT] [money] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0491] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[MDSEMPCOD],
		[MDSREG],
		[MDSDATVAL],
		[MDSNUMLOT]
	)  ON [PRIMARY] 
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 4out2010 -------------------------------------------------------------------------------------------------------------

-- TBS050: ocorrencias

-- listar dados para cadastrar manualmente
select * from TBS050

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS050]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS050]
GO

CREATE TABLE [dbo].[TBS050] (
	[OCOEMPCOD] [smallint] NOT NULL ,
	[OCOCOD] [smallint] NOT NULL ,
	[OCODES] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[OCODATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS050] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[OCOEMPCOD],
		[OCOCOD]
	)  ON [PRIMARY] 
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 27set2010 ------------------------------------------------------------------------------------------------------------

-- TBS0673: itens nota fiscal de saida por lote

CREATE TABLE [dbo].[TBS0673] (
	[NFSEMPCOD] [smallint] NOT NULL ,
	[NFSNUM] [int] NOT NULL ,
	[NFSITE] [smallint] NOT NULL ,
	[NFSDATVAL] [datetime] NOT NULL ,
	[NFSLOTNUM] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[NFSQTDLOT] [money] NULL ,
	[NFSDATFAB] [datetime] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0673] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[NFSEMPCOD],
		[NFSNUM],
		[NFSITE],
		[NFSDATVAL],
		[NFSLOTNUM]
	)  ON [PRIMARY] 
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 23set2010 ------------------------------------------------------------------------------------------------------------

-- TBS084: lote e validade dos produtos

CREATE TABLE [dbo].[TBS084] (
	[LEVEMPCOD] [smallint] NOT NULL ,
	[LESEMPCOD] [smallint] NOT NULL ,
	[LESCOD] [smallint] NOT NULL ,
	[PROEMPCOD] [smallint] NOT NULL ,
	[PROCOD] [char] (15) COLLATE Latin1_General_BIN NOT NULL ,
	[LEVDATVAL] [datetime] NOT NULL ,
	[LEVNUMLOT] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[LEVDATFAB] [datetime] NULL ,
	[LEVQTDATU] [money] NULL ,
	[LEVQTDRES] [money] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS084] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[LEVEMPCOD],
		[LESEMPCOD],
		[LESCOD],
		[PROEMPCOD],
		[PROCOD],
		[LEVDATVAL],
		[LEVNUMLOT]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0841] ON [dbo].[TBS084]([PROEMPCOD], [PROCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0842] ON [dbo].[TBS084]([LESEMPCOD], [LESCOD]) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TMP0021] (
	[T2_EMPRESA] [smallint] NOT NULL ,
	[T2_REGISTRO] [int] NOT NULL ,
	[T2_PROCOD] [char] (15) COLLATE Latin1_General_BIN NOT NULL ,
	[T2_PRPESTLOC] [smallint] NOT NULL ,
	[T2_TESCOD] [smallint] NOT NULL ,
	[T2_PRPDATVAL] [datetime] NOT NULL ,
	[T2_PRPLOTNUM] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[T2_PRPQTDLOT] [money] NOT NULL ,
	[T2_PRPDATFAB] [datetime] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TMP0021] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[T2_EMPRESA],
		[T2_REGISTRO],
		[T2_PROCOD],
		[T2_PRPESTLOC],
		[T2_TESCOD],
		[T2_PRPDATVAL],
		[T2_PRPLOTNUM]
	)  ON [PRIMARY] 
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 21set2010 ------------------------------------------------------------------------------------------------------------

-- TBS0551: itens do pedido de vendas

alter table [TBS0551] add [PDVLOTNUM] char(20) default '' with values
alter table [TBS0551] add [PDVDATFAB] datetime default '17530101' with values
alter table [TBS0551] add [PDVDATVAL] datetime default '17530101' with values 

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]
 

-- 20set2010 ------------------------------------------------------------------------------------------------------------

-- TBS010: produtos

alter table [TBS010] add [PROPCPFOR] int default 0 with values
alter table [TBS010] add [PROPCPSER] char(3) default '' with values
alter table [TBS010] add [PROUCPFOR] int default 0 with values
alter table [TBS010] add [PROUCPSER] char(3) default '' with values
alter table [TBS010] add [PROMCPFOR] int default 0 with values
alter table [TBS010] add [PROMCPSER] char(3) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- TBS058: pedidos pendentes/reservados

alter table [TBS058] add [PRPNFESER] char(3) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- TBS0581: itens reservados por lote

CREATE TABLE [dbo].[TBS0581] (
	[PRPEMP] [smallint] NOT NULL ,
	[PRPSIT] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[PRPNUM] [int] NOT NULL ,
	[PRPITEM] [smallint] NOT NULL ,
	[PRPDATVAL] [datetime] NOT NULL ,
	[PRPLOTNUM] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[PRPQTDLOT] [money] NULL ,
	[PRPDATFAB] [datetime] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0581] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PRPEMP],
		[PRPSIT],
		[PRPNUM],
		[PRPITEM],
		[PRPDATVAL],
		[PRPLOTNUM]
	)  ON [PRIMARY] 
GO

-- TBS076: cabecalho da soliticacao de compras

CREATE TABLE [dbo].[TBS076] (
	[SDCEMPCOD] [smallint] NOT NULL ,
	[SDCNUM] [int] NOT NULL ,
	[SDCDATCAD] [datetime] NULL ,
	[CCSEMPCOD] [smallint] NULL ,
	[CCSCOD] [smallint] NULL ,
	[CLIEMPCOD] [smallint] NULL ,
	[CLICOD] [int] NULL ,
	[SDCULTITE] [smallint] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS076] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[SDCEMPCOD],
		[SDCNUM]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0761] ON [dbo].[TBS076]([CLIEMPCOD], [CLICOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0762] ON [dbo].[TBS076]([CCSEMPCOD], [CCSCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0763] ON [dbo].[TBS076]([SDCEMPCOD], [CCSCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0764] ON [dbo].[TBS076]([SDCEMPCOD], [CLICOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0765] ON [dbo].[TBS076]([SDCEMPCOD], [SDCNUM] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0766] ON [dbo].[TBS076]([SDCEMPCOD], [SDCDATCAD]) ON [PRIMARY]
GO

-- TBS0761: itensa da solicitacao de compras

CREATE TABLE [dbo].[TBS0761] (
	[SDCEMPCOD] [smallint] NOT NULL ,
	[SDCNUM] [int] NOT NULL ,
	[SDCITE] [smallint] NOT NULL ,
	[PROEMPCOD] [smallint] NULL ,
	[PROCOD] [char] (15) COLLATE Latin1_General_BIN NULL ,
	[SDCUNI] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[LESEMPCOD] [smallint] NULL ,
	[LESCOD] [smallint] NULL ,
	[SDCQTDPED] [money] NULL ,
	[SDCQTDATD] [money] NULL ,
	[SDCQTDEMB] [money] NULL ,
	[SDCQTDRES] [money] NULL ,
	[SDCPRODES] [char] (50) COLLATE Latin1_General_BIN NULL ,
	[SDCQTDBAI] [money] NULL ,
	[SDCPEN] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[SDCNFEEMP] [smallint] NULL ,
	[SDCNFETIP] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[SDCNFENUM] [int] NULL ,
	[SDCNFECOD] [int] NULL ,
	[SDCNFEQTD] [money] NULL ,
	[SDCUSUEST] [char] (45) COLLATE Latin1_General_BIN NULL ,
	[SDCUSUCAN] [char] (45) COLLATE Latin1_General_BIN NULL ,
	[SDCFORCOD] [int] NULL ,
	[SDCMARCOD] [smallint] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0761] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[SDCEMPCOD],
		[SDCNUM],
		[SDCITE]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS07612] ON [dbo].[TBS0761]([LESEMPCOD], [LESCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS07613] ON [dbo].[TBS0761]([PROEMPCOD], [PROCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS07615] ON [dbo].[TBS0761]([SDCEMPCOD], [SDCPEN], [PROEMPCOD], [PROCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS07616] ON [dbo].[TBS0761]([SDCEMPCOD], [PROEMPCOD], [PROCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS07617] ON [dbo].[TBS0761]([SDCEMPCOD], [SDCPRODES]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS07618] ON [dbo].[TBS0761]([SDCEMPCOD], [SDCPEN], [SDCFORCOD], [SDCMARCOD], [PROCOD]) ON [PRIMARY]
GO

alter table [TBS0761] add [SDCNFESER] char(3) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 16set2010 ------------------------------------------------------------------------------------------------------------

-- TBS064: series de notas fiscais

create nonclustered index [ITBS0641] on [dbo].[TBS064] ([SEREMPCOD], [SERDES]) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 15set2010 ------------------------------------------------------------------------------------------------------------

-- TBS010: produtos

alter table [TBS010] add [PROCTRLOT] char(1) default 'N' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- TBS0591: itens da nota fiscal de entrada

alter table [TBS0591] add [NFELOTNUM] char(20) default '' with values
alter table [TBS0591] add [NFEDATFAB] datetime default '17530101' with values 
alter table [TBS0591] add [NFEDATVAL] datetime default '17530101' with values 

-- TBS0594: nota fiscal de entrada itens por lote

CREATE TABLE [dbo].[TBS0594] (
	[NFEEMPCOD] [smallint] NOT NULL ,
	[NFETIP] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[NFENUM] [int] NOT NULL ,
	[NFECOD] [int] NOT NULL ,
	[SEREMPCOD] [smallint] NOT NULL ,
	[SERCOD] [char] (3) COLLATE Latin1_General_BIN NOT NULL ,
	[NFEITE] [smallint] NOT NULL ,
	[NFEDATVAL] [datetime] NOT NULL ,
	[NFELOTNUM] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[NFEDATFAB] [datetime] NULL ,
	[NFEQTDLOT] [money] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0594] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[NFEEMPCOD],
		[NFETIP],
		[NFENUM],
		[NFECOD],
		[SEREMPCOD],
		[SERCOD],
		[NFEITE],
		[NFEDATVAL],
		[NFELOTNUM]
	)  ON [PRIMARY] 
GO


-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 1set2010 -------------------------------------------------------------------------------------------------------------

-- TBS081: controle de atributos

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS081]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS081]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0811]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0811]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS082]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS082]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS083]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS083]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0831]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0831]
GO

CREATE TABLE [dbo].[TBS081] (
	[CDAEMPCOD] [smallint] NOT NULL ,
	[TBSNOM] [char] (10) COLLATE Latin1_General_BIN NOT NULL ,
	[TBSATRNOM] [char] (10) COLLATE Latin1_General_BIN NOT NULL ,
	[CDADATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0811] (
	[CDAEMPCOD] [smallint] NOT NULL ,
	[TBSNOM] [char] (10) COLLATE Latin1_General_BIN NOT NULL ,
	[TBSATRNOM] [char] (10) COLLATE Latin1_General_BIN NOT NULL ,
	[CDATIPUSU] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[CDAUSU] [char] (40) COLLATE Latin1_General_BIN NOT NULL ,
	[CDABLQEDI] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[CDAESCATR] [char] (1) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS082] (
	[PCOEMPCOD] [smallint] NOT NULL ,
	[PCOCOD] [smallint] NOT NULL ,
	[PCOTIP] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[PCODES] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[PCODATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS083] (
	[CXAEMPCOD] [smallint] NOT NULL ,
	[CXANUM] [smallint] NOT NULL ,
	[CXADES] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[CXAABERTO] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[CXAULTABT] [datetime] NULL ,
	[CXAULTFEC] [datetime] NULL ,
	[CXASDOINI] [money] NOT NULL ,
	[CXASDOOPE] [money] NOT NULL ,
	[CXADATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0831] (
	[CXAEMPCOD] [smallint] NOT NULL ,
	[CXANUM] [smallint] NOT NULL ,
	[CXASEQLAN] [smallint] NOT NULL ,
	[CXADATLAN] [datetime] NULL ,
	[CXAVALLAN] [money] NULL ,
	[CXADESLAN] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[PCOEMPCOD] [smallint] NOT NULL ,
	[PCOCOD] [smallint] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS081] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CDAEMPCOD],
		[TBSNOM],
		[TBSATRNOM]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0811] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CDAEMPCOD],
		[TBSNOM],
		[TBSATRNOM],
		[CDATIPUSU],
		[CDAUSU]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS082] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PCOEMPCOD],
		[PCOCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS083] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CXAEMPCOD],
		[CXANUM]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0831] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CXAEMPCOD],
		[CXANUM],
		[CXASEQLAN]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0811] ON [dbo].[TBS081]([TBSNOM], [TBSATRNOM]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0821] ON [dbo].[TBS082]([PCOEMPCOD], [PCODES]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0831] ON [dbo].[TBS083]([CXAEMPCOD], [CXADES]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS08313] ON [dbo].[TBS0831]([PCOEMPCOD], [PCOCOD]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS08314] ON [dbo].[TBS0831]([CXAEMPCOD], [CXANUM], [CXASEQLAN] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS08315] ON [dbo].[TBS0831]([CXAEMPCOD], [CXANUM], [CXADATLAN]) ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 30ago2010 ------------------------------------------------------------------------------------------------------------

-- TBS007: bancos

alter table [TBS007] add [BANIMPBOL] char(1) default 'S' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 25ago2010 ------------------------------------------------------------------------------------------------------------

-- TBS024: tabelas do sistema

-- remove restricoes

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TBS024_TBSTIP]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TBS024] DROP CONSTRAINT [DF_TBS024_TBSTIP]
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TBS024_TBSATRTAM]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TBS024] DROP CONSTRAINT [DF_TBS024_TBSATRTAM]
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TBS024_TBSATRNOM]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TBS024] DROP CONSTRAINT [DF_TBS024_TBSATRNOM]
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_TBS024_TBSATRDES]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TBS024] DROP CONSTRAINT [DF_TBS024_TBSATRDES]
END
GO

drop index TBS024.ITBS0241
drop index TBS024.ITBS0243

alter table [TBS024] drop [TBSATRNOM]
alter table [TBS024] drop [TBSATRDES]
alter table [TBS024] drop [TBSATRTAM]
alter table [TBS024] drop [TBSTIP]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- TBS0242: atributos da tabela do sistema

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0242]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0242]
GO

CREATE TABLE [dbo].[TBS0242] (
	[TBSNOM] [char] (10) COLLATE Latin1_General_BIN NOT NULL ,
	[TBSATRNOM] [char] (10) COLLATE Latin1_General_BIN NOT NULL ,
	[TBSATRDES] [char] (40) COLLATE Latin1_General_BIN NULL ,
	[TBSATRTAM] [smallint] NULL ,
	[TBSATRTIP] [char] (1) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0242] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[TBSNOM],
		[TBSATRNOM]
	)  ON [PRIMARY] 
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 11ago2010 ------------------------------------------------------------------------------------------------------------

-- TBS002: clientes

update TBS002 set CLIFIL='N' where CLIFIL=''

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 9ago2010 -------------------------------------------------------------------------------------------------------------

-- TBS056: contas a receber

CREATE NONCLUSTERED INDEX [ITBS056B] ON [TBS056]
  ([CREEMPCOD], [PFXEMPCOD], [CLIEMPCOD], [CRETIT] DESC)
ON [PRIMARY]
GO

-- TBS057: contas a pagar

CREATE NONCLUSTERED INDEX [ITBS057F] ON [TBS057]
  ([CPAEMPCOD], [PFXEMPCOD], [FOREMPCOD], [MOBCOD])
ON [PRIMARY]
GO
 
-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- Atualiza o Ultimo item conforme quantidade de itens de irregularidades
UPDATE TBS073 SET ESPULTITE = (SELECT COUNT(*) FROM TBS0731 WHERE TBS0731.CACEMPCOD = TBS073.CACEMPCOD AND TBS0731.CACDOC = TBS073.CACDOC)

-- Atualiza o valor do item das irregularidades da Carta de correção
DECLARE @DOC AS INT
-- Atualiza enquando conter itens com valor "0"
WHILE (SELECT COUNT(ESPITE) FROM TBS0731 WHERE ESPITE = 0 ) > 0
BEGIN
	-- Obtem apenas o primeiro registro onde o item esta com valor "0"
	SET @DOC = (SELECT TOP 1 CACDOC FROM TBS0731 WHERE ESPITE = 0 ORDER BY CACDOC)
		
	-- Atualiza o valor do item apenas com valor "0" e mesma Carta de correção
	SET ROWCOUNT 1	-- APENAS MODIFICA 1 LINHA POR VEZ
	UPDATE TBS0731 SET ESPITE = (SELECT MAX(ESPITE) + 1 FROM TBS0731 WHERE CACDOC = @DOC )	
	WHERE CACDOC = @DOC AND ESPITE = 0
END

--SET ROWCOUNT 0	
--select CACDOC, ESPITE from TBS0731	

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 6ago2010 -------------------------------------------------------------------------------------------------------------

-- TBS010: produtos

alter table [TBS010] add [SUBGRUCOD] smallint default 0 with values

-- [x] tanby sjc

drop index TBS010.ITBS0109

create nonclustered index [ITBS01012] on [dbo].[TBS010] ([GRUEMPCOD], [GRUCOD], [SUBGRUCOD]) on [PRIMARY]

-- TBS012: grupos de produtos

alter table [TBS012] add [SUBGRUUIT] smallint default 0 with values

-- TBS056: contas a receber

drop index TBS056.ITBS056B

create nonclustered index [ITBS056J] on [dbo].[TBS056] ([CREEMPCOD], [PFXEMPCOD], [CLIEMPCOD], [CRETIT]) on [PRIMARY]
create nonclustered index [ITBS056I] on [dbo].[TBS056] ([CREEMPCOD], [PFXEMPCOD], [CLIEMPCOD], [CRENOSNUM]) on [PRIMARY]
create nonclustered index [ITBS056K] on [dbo].[TBS056] ([CREEMPCOD], [PFXEMPCOD], [CLIEMPCOD], [MOBCOD]) on [PRIMARY]

-- TBS073: carta de correcao

alter table [TBS073] add [ESPULTITE] smallint default 0 with values

-- TBS0121: subgrupos

CREATE TABLE [dbo].[TBS0121] (
	[GRUEMPCOD] [smallint] NOT NULL ,
	[GRUCOD] [smallint] NOT NULL ,
	[SUBGRUCOD] [smallint] NOT NULL ,
	[SUBGRUDES] [char] (20) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS0121] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[GRUEMPCOD],
		[GRUCOD],
		[SUBGRUCOD]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS01213] ON [dbo].[TBS0121]([GRUEMPCOD], [GRUCOD], [SUBGRUDES]) ON [PRIMARY]
GO

-- [x] tanby sjc

-- TBS0731: itens da carta de correcao

alter table [TBS0731] add [ESPITE] smallint default 0 with values

drop index TBS0731.ITBS07311

create nonclustered index [ITBS07311] on [dbo].[TBS0731] ([CACEMPCOD], [CACDOC], [ESPITE], [ESPCOD]) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 2ago2010 -------------------------------------------------------------------------------------------------------------

-- TBS006: fornecedores

alter table [TBS006] add [FORTEMREP] smallint default 0 with values

-- TBS032: saldos produtos

alter table [TBS032] add [ESTQTDSEG] money default 0 with values
alter table [TBS032] add [ESTPONPED] money default 0 with values
alter table [TBS032] add [ESTDCMDE]  datetime default '17530101' with values 
alter table [TBS032] add [ESTDCMATE] datetime default '17530101' with values 

alter table [TBS032] drop [ESTQTDMIN]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 30jul2010 ------------------------------------------------------------------------------------------------------------

SET NOCOUNT ON
GO

CREATE TABLE [TMP010] (
  [TA_EMPRESA] smallint NOT NULL,
  [TA_REGISTRO] int NOT NULL,
  [TA_DATCAD] datetime NOT NULL,
  [TA_PDCNUM] int NOT NULL,
  [TA_DATVEN] datetime NOT NULL,
  [TA_VALTOT] money NULL
)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITMP0101] ON [TMP010]
  ([TA_EMPRESA], [TA_REGISTRO], [TA_DATCAD], [TA_DATVEN])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITMP0102] ON [TMP010]
  ([TA_EMPRESA], [TA_REGISTRO], [TA_DATVEN])
ON [PRIMARY]
GO

ALTER TABLE [TMP010]
ADD PRIMARY KEY CLUSTERED ([TA_EMPRESA], [TA_REGISTRO], [TA_DATCAD], [TA_PDCNUM], [TA_DATVEN])
ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 16jul2010 ------------------------------------------------------------------------------------------------------------

USE [SIBD]
GO

/****** Object:  Table [dbo].[TBS080]    Script Date: 11/23/2010 12:21:12 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[TBS080](
	[ENFEMPCOD] [smallint] NOT NULL,
	[ENFNUM] [int] NOT NULL,
	[ENFTIPDOC] [smallint] NULL,
	[ENFMOD] [smallint] NULL,
	[ENFSER] [smallint] NULL,
	[ENFDATEMI] [datetime] NULL,
	[ENFFORDAN] [smallint] NULL,
	[ENFFORPAG] [smallint] NULL,
	[ENFFOREMI] [smallint] NULL,
	[ENFCNPJCPF] [char](18) NULL,
	[ENFFINEMI] [smallint] NULL,
	[ENFDESREM] [char](60) NULL,
	[ENFVALTOT] [money] NULL,
	[ENFCHAACE] [char](44) NULL,
	[ENFDANIMP] [char](1) NULL,
	[ENFCODDES] [int] NULL,
	[ENFSIT] [smallint] NULL,
	[ENFARQ] [char](20) NULL,
	[ENFRECIBO] [decimal](15, 0) NULL,
	[ENFPROTOC] [decimal](15, 0) NULL,
	[ENFDIGVAL] [char](28) NULL,
	[ENFJUSTIF] [char](255) NULL,
	[ENFEMAIL] [char](1) NULL,
	[ENFTIPENT] [char](1) NULL,
	[ENFESTDES] [char](2) NULL,
	[ENFVENCOD] [smallint] NULL,
	[ENFTIPAMB] [smallint] NULL,
	[ENFDATHORPRO] [datetime] NULL,
	[ENFPROCAN] [decimal](15, 0) NULL,
	[ENFDEHPROCAN] [datetime] NULL,
	[ENFPROINU] [decimal](15, 0) NULL,
	[ENFDEHPROINU] [datetime] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[TBS080] ADD [ENFJUSINU] [char](255) NOT NULL
/****** Object:  Index [PK__TBS080__979D1F0E29F710FA]    Script Date: 11/23/2010 12:21:12 ******/
ALTER TABLE [dbo].[TBS080] ADD PRIMARY KEY CLUSTERED 
(
	[ENFEMPCOD] ASC,
	[ENFNUM] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 12jul2010 ------------------------------------------------------------------------------------------------------------

-- TBS056: contas a receber

alter table [TBS056] add [CRENOSNUM] char(20) default '' with values

update TBS056 set CRENUMBAN=replace(CRENUMBAN,'0','')
update TBS056 set CRENUMBAN='0' where CRENUMBAN='' or CRENUMBAN not Like('%[0-9]%')

drop index TBS056.ITBS056G

--alter table [TBS056] alter column CRENUMBAN decimal 
-- alterar o tipo na mao, apagar o valor default e depois colocar zero novamente

CREATE INDEX [ITBS056G] ON [dbo].[TBS056] ([CREEMPCOD], [CRENUMBAN]) ON [PRIMARY]

-- Atribui valor do atributo CRENUMBAN para o CRENOSNUM, para que boletos possom ser reimpressos
UPDATE TBS056 SET CRENOSNUM = CRENUMBAN

alter table [TBS056] alter column [CRENUNBAN] char(13)
-- default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 1jul2010 -------------------------------------------------------------------------------------------------------------

-- TBS010: produtos

create nonclustered index [ITBS010P] on [dbo].[TBS010] ([PROEMPCOD], [MAREMPCOD], [MARCOD], [PROCOD]) on [PRIMARY]

alter table [TBS010] add [PROCALPOP] char(1) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]  hoffmann & gomes [x]


-- 28jun2010 ------------------------------------------------------------------------------------------------------------

-- TBS067: notas fiscais

alter table [TBS067] alter column NFSPDDTOT decimal(7,4)

-- TBS006: fornecedores

alter table [TBS006] alter column FORREDCOR1 decimal(7,4)
alter table [TBS006] alter column FORREDCOR2 decimal(7,4)
alter table [TBS006] alter column FORREDCOR3 decimal(7,4)
alter table [TBS006] alter column FORREDCOR4 decimal(7,4)
alter table [TBS006] alter column FORREDLOJ1 decimal(7,4)
alter table [TBS006] alter column FORREDLOJ2 decimal(7,4)
alter table [TBS006] alter column FORREDLOJ3 decimal(7,4)
alter table [TBS006] alter column FORREDLOJ4 decimal(7,4)
alter table [TBS006] alter column FORREDREV1 decimal(7,4)
alter table [TBS006] alter column FORREDREV2 decimal(7,4)
alter table [TBS006] alter column FORREDREV3 decimal(7,4)
alter table [TBS006] alter column FORREDREV4 decimal(7,4)
alter table [TBS006] alter column FORREDWE11 decimal(7,4)
alter table [TBS006] alter column FORREDWE12 decimal(7,4)
alter table [TBS006] alter column FORREDWE13 decimal(7,4)
alter table [TBS006] alter column FORREDWE14 decimal(7,4)
alter table [TBS006] alter column FORREDWE21 decimal(7,4)
alter table [TBS006] alter column FORREDWE22 decimal(7,4)
alter table [TBS006] alter column FORREDWE23 decimal(7,4)
alter table [TBS006] alter column FORREDWE24 decimal(7,4)

-- TBS015: precos dos produtos

alter table [TBS015] alter column PDPREDCOR1 decimal(7,4)
alter table [TBS015] alter column PDPREDCOR2 decimal(7,4)
alter table [TBS015] alter column PDPREDCOR3 decimal(7,4)
alter table [TBS015] alter column PDPREDCOR4 decimal(7,4)
alter table [TBS015] alter column PDPREDLOJ1 decimal(7,4)
alter table [TBS015] alter column PDPREDLOJ2 decimal(7,4)
alter table [TBS015] alter column PDPREDLOJ3 decimal(7,4)
alter table [TBS015] alter column PDPREDLOJ4 decimal(7,4)
alter table [TBS015] alter column PDPREDREV1 decimal(7,4)
alter table [TBS015] alter column PDPREDREV2 decimal(7,4)
alter table [TBS015] alter column PDPREDREV3 decimal(7,4)
alter table [TBS015] alter column PDPREDREV4 decimal(7,4)
alter table [TBS015] alter column PDPREDWE11 decimal(7,4)
alter table [TBS015] alter column PDPREDWE12 decimal(7,4)
alter table [TBS015] alter column PDPREDWE13 decimal(7,4)
alter table [TBS015] alter column PDPREDWE14 decimal(7,4)
alter table [TBS015] alter column PDPREDWE21 decimal(7,4)
alter table [TBS015] alter column PDPREDWE22 decimal(7,4)
alter table [TBS015] alter column PDPREDWE23 decimal(7,4)
alter table [TBS015] alter column PDPREDWE24 decimal(7,4)
alter table [TBS015] alter column PDPREDPRO1 decimal(7,4)
alter table [TBS015] alter column PDPREDPRO2 decimal(7,4)
alter table [TBS015] alter column PDPREDPRO3 decimal(7,4)
alter table [TBS015] alter column PDPREDPRO4 decimal(7,4)

-- TBS0261: itens das tabelas de precos

alter table [TBS0261] alter column TPCPDDITE decimal(7,4)

-- TBS0431: itens dos orcamentos

alter table [TBS0431] alter column ORCPDDITE decimal(7,4)

-- TBS0551: itens dos pedidos

alter table [TBS0551] alter column PDVPDDITE decimal(7,4)

-- TBS0591: itens das notas fiscais de entrada

alter table [TBS0591] alter column NFEPDDITE decimal(7,4)

-- TBS0671: itens das notas fiscais de saida

alter table [TBS0671] alter column NFSPDDITE decimal(7,4)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 17jun2010 ------------------------------------------------------------------------------------------------------------

-- TBS002: clientes

alter table [TBS002] alter column [CLINOM] char(60) -- feito manualmente
alter table [TBS002] alter column [CLIEND] char(50)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]

-- 12mai2010 ------------------------------------------------------------------------------------------------------------

-- TBS056: contas a receber
create nonclustered index [ITBS056H] on [dbo].[TBS056] ([CREEMPCOD], [CRETIT], [CLIEMPCOD], [CLICOD], [CRETITORI]) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]

-- TBS002: clientes

alter table [TBS002] add [CLIRAM1] smallint default 0 with values
alter table [TBS002] add [CLIRAM2] smallint default 0 with values
alter table [TBS002] add [CLIRAM3] smallint default 0 with values

alter table [TBS002] add [CLITEL2] char(15) default '' with values
alter table [TBS002] add [CLITEL3] char(15) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 22mar2009 ------------------------------------------------------------------------------------------------------------

-- elimina opcoes do menu
delete TBS0181 where PRGCOD='WYCOM023'

-- insere opcoes no menu
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WYCOM023', 1, 'ATUALIZAR CUSTO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WYCOM023', 2, 'DESMARCAR TODOS')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WYCOM023', 3, 'INVERTER MARCACAO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WYCOM023', 4, 'MARCAR TODOS')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WYCOM023', 5, 'REAJUSTAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 17mar2010 ------------------------------------------------------------------------------------------------------------

-- TBS010: produtos

alter table [TBS010] add [PROLOCFIS2] char(20) default '' with values
alter table [TBS010] add [PROLOCFIS3] char(20) default '' with values
alter table [TBS010] add [PROLOCFIS4] char(20) default '' with values

-- TBS002: clientes

alter table [TBS002] add [CLITABPAD] int default 0 with values
alter table [TBS002] add [CLIFIL] char(1) default 'N' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 25fev2010 ------------------------------------------------------------------------------------------------------------

-- TMP004: tabela temporaria de sugestao de compras

alter table [TMP004] add [T4_PENSC] char(1) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 22jan2010 ------------------------------------------------------------------------------------------------------------

-- TBS007: contas correntes

alter table [TBS007] add [BANPRGBOL] char(10) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 3dez2009 -------------------------------------------------------------------------------------------------------------

-- TBS010: produtos

alter table [TBS010] add [PROCODTMP] char(15) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 2dez2009 -------------------------------------------------------------------------------------------------------------

-- TBS078: cheques

SET NOCOUNT ON
GO

CREATE TABLE [TBS078] (
  [CHQEMPCOD] smallint NOT NULL,
  [BCOEMPCOD] smallint NOT NULL,
  [BCONUM] smallint NOT NULL,
  [BCOAGE] char(6) COLLATE Latin1_General_BIN NOT NULL,
  [CHQCONCOR] char(10) COLLATE Latin1_General_BIN NOT NULL,
  [CHQNUM] int NOT NULL,
  [CLIEMPCOD] smallint NULL,
  [CLICOD] int NULL,
  [CHQDATEMI] datetime NULL,
  [CHQVAL] money NULL,
  [CHQNOMEMI] char(50) COLLATE Latin1_General_BIN NULL,
  [CHQCPFEMI] char(11) COLLATE Latin1_General_BIN NULL,
  [CHQDATDEP] datetime NULL,
  [CHQDATDEV] datetime NULL,
  [CHQDATREA] datetime NULL,
  [POREMPCOD] smallint NULL,
  [PORCOD] smallint NULL,
  [MOBEMPCOD] smallint NULL,
  [MOBCOD] smallint NULL,
  [CHQVENEMP] smallint NULL,
  [CHQVENCOD] smallint NULL,
  [CHQDATCOMP] datetime NULL,
  [CHQDATCOME] datetime NULL,
  [CHQNUMBOR] int NULL,
  [CHQDATBOR] datetime NULL,
  [CHQOBS] char(254) COLLATE Latin1_General_BIN NULL,
  [CLINOM] char(50) COLLATE Latin1_General_BIN NULL
)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0781] ON [TBS078]
  ([CHQVENEMP], [CHQVENCOD])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0782] ON [TBS078]
  ([MOBEMPCOD], [MOBCOD])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0783] ON [TBS078]
  ([POREMPCOD], [PORCOD])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0784] ON [TBS078]
  ([CLIEMPCOD], [CLICOD])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0785] ON [TBS078]
  ([BCOEMPCOD], [BCONUM], [BCOAGE])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0786] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CHQNUM])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0787] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CHQVAL])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0788] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CHQDATDEP])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0789] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CHQDATEMI])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS078A] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CLIEMPCOD], [CLICOD])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS078B] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CLIEMPCOD], [CLINOM])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS078C] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CHQNUMBOR])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS078D] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CHQCPFEMI])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS078E] ON [TBS078]
  ([CHQEMPCOD], [BCOEMPCOD], [CHQDATCOME])
ON [PRIMARY]
GO

ALTER TABLE [TBS078]
ADD PRIMARY KEY CLUSTERED ([CHQEMPCOD], [BCOEMPCOD], [BCONUM], [BCOAGE], [CHQCONCOR], [CHQNUM])
ON [PRIMARY]
GO

-- TBS0771: agencias bancarias

SET NOCOUNT ON
GO

CREATE TABLE [TBS0771] (
  [BCOEMPCOD] smallint NOT NULL,
  [BCONUM] smallint NOT NULL,
  [BCOAGE] char(6) COLLATE Latin1_General_BIN NOT NULL,
  [BCONOMAGE] char(40) COLLATE Latin1_General_BIN NULL,
  [BCOEND] char(50) COLLATE Latin1_General_BIN NULL,
  [BCOBAI] char(30) COLLATE Latin1_General_BIN NULL,
  [BCOCEP] char(9) COLLATE Latin1_General_BIN NULL,
  [UFESIG] char(2) COLLATE Latin1_General_BIN NULL,
  [MUNCOD] int NOT NULL,
  [BCOTEL] char(15) COLLATE Latin1_General_BIN NULL
)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS07712] ON [TBS0771]
  ([UFESIG], [MUNCOD])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS07714] ON [TBS0771]
  ([BCOEMPCOD], [BCOAGE])
ON [PRIMARY]
GO

ALTER TABLE [TBS0771]
ADD PRIMARY KEY CLUSTERED ([BCOEMPCOD], [BCONUM], [BCOAGE])
ON [PRIMARY]
GO

-- TBS077: bancos

SET NOCOUNT ON
GO

CREATE TABLE [TBS077] (
  [BCOEMPCOD] smallint NOT NULL,
  [BCONUM] smallint NOT NULL,
  [BCONOM] char(40) COLLATE Latin1_General_BIN NULL,
  [BCODATCAD] datetime NULL
)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0771] ON [TBS077]
  ([BCOEMPCOD], [BCONUM] DESC)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0772] ON [TBS077]
  ([BCOEMPCOD], [BCONOM])
ON [PRIMARY]
GO

ALTER TABLE [TBS077]
ADD PRIMARY KEY CLUSTERED ([BCOEMPCOD], [BCONUM])
ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 17nov2009 ------------------------------------------------------------------------------------------------------------

-- TBS032: saldos em estoque

alter table [TBS032] add [ESTQTDMIN] money default 0 with values
alter table [TBS032] add [ESTCONMED] money default 0 with values
alter table [TBS032] add [ESTTEMREP] smallint default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 11nov2009 ------------------------------------------------------------------------------------------------------------

-- TBS049: manutencao saldos produtos

alter table [TBS049] alter column [MDSREG] int

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 26out2009 ------------------------------------------------------------------------------------------------------------

-- TBS010: produtos

alter table [TBS010] add [PROUMV] char(2) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 19out2009 ------------------------------------------------------------------------------------------------------------

-- TBS007: bancos

alter table [TBS007] alter column [BANCONTRA] char(20)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 16out2009 ------------------------------------------------------------------------------------------------------------

-- TBS006: fornecedores

alter table [TBS006] add [FORENDTMP] char(50) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 15out2009 ------------------------------------------------------------------------------------------------------------

alter table [TBS005] alter column [TRNCID] char(35)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 14out2009 ------------------------------------------------------------------------------------------------------------

-- TBS002: clientes

alter table [TBS002] add [MUNCOD] int default 0 with values
alter table [TBS002] add [CLISUFRAMA] int default 0 with values
alter table [TBS002] add [CLINUM] char(60) default '' with values
alter table [TBS002] add [CLIENDTMP] char(50) default '' with values

-- TBS023: empresa

alter table [TBS023] add [EMPMUNCOD] int default 0 with values
alter table [TBS023] add [EMPMUNNOM] char(35) default '' with values
alter table [TBS023] add [EMPNUM] char(60) default '' with values

-- TBS010: produtos

alter table [TBS010] add [PRODESTMP] char(50) default '' with values
alter table [TBS010] add [PROCODNCM] char(8) default '' with values
alter table [TBS010] add [PROGEN] smallint default 0 with values

-- TBS005: transportadoras

alter table [TBS005] add [TRNMUNCOD] int default 0 with values
alter table [TBS005] add [TRNMUNNOM] char(35) default '' with values

-- TBS006: fornecedores

alter table [TBS006] add [MUNCOD] int default 0 with values
alter table [TBS006] add [FORNUM] char(60) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 28set2009 ------------------------------------------------------------------------------------------------------------

-- TBS002: clientes

alter table [TBS002] add [CLIRG] char(12) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 11set2009 ------------------------------------------------------------------------------------------------------------

-- TBS042: tipos de entradas/saidas

alter table [TBS042] add [TESIGNEFS] char(1) default 'N' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 13ago2009 ------------------------------------------------------------------------------------------------------------

-- TBS057: contas a pagar

alter table [TBS057] add [MOBEMPCOD] smallint default 0 with values
alter table [TBS057] add [MOBCOD] smallint default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 23jul2009 ------------------------------------------------------------------------------------------------------------

-- TBS075: log CNAB

CREATE TABLE [dbo].[TBS075] (
  [LOGCNABEMP] smallint NOT NULL,
  [LOGCNABREG] int NOT NULL,
  [LOGCNABDAT] datetime NULL,
  [LOGCNABSTA] char(40) COLLATE Latin1_General_BIN NULL,
  [LOGCNABBOR] int NULL,
  [LOGCNABTIT] char(16) COLLATE Latin1_General_BIN NULL,
  [LOGCNABOCO] char(30) COLLATE Latin1_General_BIN NULL,
  PRIMARY KEY CLUSTERED ([LOGCNABEMP], [LOGCNABREG])
)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0751] ON [dbo].[TBS075]
  ([LOGCNABEMP], [LOGCNABBOR])
ON [PRIMARY]
GO

-- TMP009: temporaria para relatorio produtos comprados

CREATE TABLE [dbo].[TMP009] (
  [T9_EMPRESA] smallint NOT NULL,
  [T9_REGISTRO] int NOT NULL,
  [T9_PROCOD] char(15) COLLATE Latin1_General_BIN NOT NULL,
  [T9_PRODES] char(50) COLLATE Latin1_General_BIN NOT NULL,
  [T9_PROUM1] char(2) COLLATE Latin1_General_BIN NOT NULL,
  [T9_MARNOM] char(30) COLLATE Latin1_General_BIN NOT NULL,
  [T9_QTDCOM] money NOT NULL,
  [T9_VALCOM] money NOT NULL,
  [T9_PERTOTCOM] smallmoney NOT NULL,
  [T9_PERQTDCOM] smallmoney NOT NULL,
  [T9_PROSTATUS] char(1) COLLATE Latin1_General_BIN NOT NULL,
  PRIMARY KEY CLUSTERED ([T9_EMPRESA], [T9_REGISTRO], [T9_PROCOD])
)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITMP0092] ON [dbo].[TMP009]
  ([T9_EMPRESA], [T9_REGISTRO], [T9_PRODES])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITMP0093] ON [dbo].[TMP009]
  ([T9_EMPRESA], [T9_REGISTRO], [T9_QTDCOM] DESC)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITMP0094] ON [dbo].[TMP009]
  ([T9_EMPRESA], [T9_REGISTRO], [T9_VALCOM] DESC)
ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 16jul2009 ------------------------------------------------------------------------------------------------------------

-- TBS067: notas fiscais saidas

alter table [TBS067] add [NFSVALTRA] money default 0 with values
alter table [TBS067] add [NFSCOMBASICMS] money default 0 with values
alter table [TBS067] add [NFSCOMICMS] money default 0 with values
alter table [TBS067] add [NFSCOMPRO] money default 0 with values
alter table [TBS067] add [NFSCOMTOT] money default 0 with values

alter table [TBS067] alter column [NFSVALTRA] money
alter table [TBS067] alter column [NFSCOMBASICMS] money
alter table [TBS067] alter column [NFSCOMICMS] money
alter table [TBS067] alter column [NFSCOMPRO] money
alter table [TBS067] alter column [NFSCOMTOT] money

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 3jul2009 -------------------------------------------------------------------------------------------------------------

-- TBS007: bancos

alter table [TBS007] add [BANPOREMP] smallint default 0 with values
alter table [TBS007] add [BANPORCOD] smallint default 0 with values

CREATE NONCLUSTERED INDEX [ITBS0076] ON [dbo].[TBS007]
  ([BANPOREMP], [BANPORCOD])
ON [PRIMARY]
GO

-- TBS056: contas a receber

alter table [TBS056] add [MOBEMPCOD] smallint default 0 with values
alter table [TBS056] add [MOBCOD] smallint default 0 with values
alter table [TBS056] add [BANEMPCOD] smallint default 0 with values
alter table [TBS056] add [BANCOD] smallint default 0 with values
alter table [TBS056] add [BANNUMAGE] char(5) default '' with values
alter table [TBS056] add [BANNCC] char(10) default '' with values

CREATE NONCLUSTERED INDEX [ITBS05611] ON [dbo].[TBS056]
  ([BANEMPCOD], [BANCOD], [BANNUMAGE], [BANNCC])
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS05610] ON [dbo].[TBS056]
  ([MOBEMPCOD], [MOBCOD])
ON [PRIMARY]
GO

-- TBS074: motivos de baixa

CREATE TABLE [dbo].[TBS074] (
  [MOBEMPCOD] smallint NOT NULL,
  [MOBCOD] smallint NOT NULL,
  [MOBDES] char(20) COLLATE Latin1_General_BIN NULL,
  [MOBDATCAD] datetime NULL,
  PRIMARY KEY CLUSTERED ([MOBEMPCOD], [MOBCOD])
)
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [ITBS0741] ON [dbo].[TBS074]
  ([MOBEMPCOD], [MOBDES])
ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 30jun2009 ------------------------------------------------------------------------------------------------------------

-- TBS006: fornecedores

alter table [TBS006] alter column [FORIPI] decimal(7,4)
alter table [TBS006] alter column [FORDIFICM] decimal(7,4)
alter table [TBS006] alter column [FORPIS] decimal(7,4)
alter table [TBS006] alter column [FORCOF] decimal(7,4)
alter table [TBS006] alter column [FORFRE] decimal(7,4)
alter table [TBS006] alter column [FORCUSADM] decimal(7,4)
alter table [TBS006] alter column [FORMKPCOR1] decimal(7,4)
alter table [TBS006] alter column [FORMKPCOR2] decimal(7,4)
alter table [TBS006] alter column [FORMKPLOJ1] decimal(7,4)
alter table [TBS006] alter column [FORMKPLOJ2] decimal(7,4)
alter table [TBS006] alter column [FORMKPREV1] decimal(7,4)
alter table [TBS006] alter column [FORMKPREV2] decimal(7,4)
alter table [TBS006] alter column [FORMKPWE11] decimal(7,4)
alter table [TBS006] alter column [FORMKPWE12] decimal(7,4)
alter table [TBS006] alter column [FORMKPWE21] decimal(7,4)
alter table [TBS006] alter column [FORMKPWE22] decimal(7,4)
alter table [TBS006] alter column [FORCMS] decimal(7,4)
alter table [TBS006] alter column [FORPDD1] decimal(7,4)
alter table [TBS006] alter column [FORPDD2] decimal(7,4)
alter table [TBS006] alter column [FORPDD3] decimal(7,4)
alter table [TBS006] alter column [FORPDD4] decimal(7,4)
alter table [TBS006] alter column [FORPDD5] decimal(7,4)

-- TBS010: produtos

alter table [TBS010] alter column [PROPBISAI] decimal(7,4)
alter table [TBS010] alter column [PROPBIENT] decimal(7,4)

-- TBS015: politica de precos

alter table [TBS015] alter column [PDPIPI] decimal(7,4)
alter table [TBS015] alter column [PDPDIFICM] decimal(7,4)
alter table [TBS015] alter column [PDPPIS] decimal(7,4)
alter table [TBS015] alter column [PDPCOF] decimal(7,4)
alter table [TBS015] alter column [PDPFRE] decimal(7,4)
alter table [TBS015] alter column [PDPCUSADM] decimal(7,4)
alter table [TBS015] alter column [PDPCMS] decimal(7,4)
alter table [TBS015] alter column [PDPMKPCOR1] decimal(7,4)
alter table [TBS015] alter column [PDPMKPCOR2] decimal(7,4)
alter table [TBS015] alter column [PDPMKPLOJ1] decimal(7,4)
alter table [TBS015] alter column [PDPMKPLOJ2] decimal(7,4)
alter table [TBS015] alter column [PDPMKPREV1] decimal(7,4)
alter table [TBS015] alter column [PDPMKPREV2] decimal(7,4)
alter table [TBS015] alter column [PDPMKPWE11] decimal(7,4)
alter table [TBS015] alter column [PDPMKPWE12] decimal(7,4)
alter table [TBS015] alter column [PDPMKPWE21] decimal(7,4)
alter table [TBS015] alter column [PDPMKPWE22] decimal(7,4)
alter table [TBS015] alter column [PDPMKPPRO1] decimal(7,4)
alter table [TBS015] alter column [PDPMKPPRO2] decimal(7,4)
alter table [TBS015] alter column [PDPPDD1] decimal(7,4)
alter table [TBS015] alter column [PDPPDD2] decimal(7,4)
alter table [TBS015] alter column [PDPPDD3] decimal(7,4)
alter table [TBS015] alter column [PDPPDD4] decimal(7,4)
alter table [TBS015] alter column [PDPPDD5] decimal(7,4)

-- TBS026: tabela de precos

alter table [TBS026] alter column [TPCMDLGER] decimal(7,4)

-- TBS0261: itens da tabela de precos

alter table [TBS0261] alter column [TPCMDLPRO] decimal(7,4)
alter table [TBS0261] alter column [TPCMDLITE] decimal(7,4)
alter table [TBS0261] alter column [TPCMDLCON] decimal(7,4)
alter table [TBS0261] alter column [TPCINDREA] decimal(7,4)

-- TBS031: precos dos produtos

alter table [TBS031] alter column [TDPMKPCOR2] decimal(7,4)
alter table [TBS031] alter column [TDPMKPLOJ2] decimal(7,4)
alter table [TBS031] alter column [TDPMKPWE12] decimal(7,4)
alter table [TBS031] alter column [TDPMKPWE22] decimal(7,4)
alter table [TBS031] alter column [TDPMKPREV2] decimal(7,4)

-- TBS0431: itens do orcamento

alter table [TBS0431] alter column [ORCPBI] decimal(7,4)

-- TBS0521: itens da tabela de contrato

alter table [TBS0521] alter column [TDCINDREA] decimal(7,4)

-- TBS054: excecoes fiscais

alter table [TBS054] alter column [EFSPBIENT] decimal(7,4)
alter table [TBS054] alter column [EFSPBIREV] decimal(7,4)
alter table [TBS054] alter column [EFSPBICON] decimal(7,4)

-- TBS0551: itens do pedido de vendas

alter table [TBS0551] alter column [PDVPBI] decimal(7,4)

-- TBS0591: itens da nota fiscal de entrada

alter table [TBS0591] alter column [NFEPBI] decimal(7,4)

-- TBS0671: itens da nota fiscal de saida

alter table [TBS0671] alter column [NFSPBI] decimal(7,4)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 29jun2009 ------------------------------------------------------------------------------------------------------------

-- TBS007: bancos
alter table [TBS007] alter column [BANPORDIA] decimal(8,4)

-- TBS007: bancos
alter table [TBS007] add [LEIBOLNOM] char(20) default '' with values
alter table [TBS007] add [LAYNOM] char(30) default '' with values
alter table [TBS007] add [LAYTIP] char(3) default '' with values

-- TBS065: leiaute CNAB a receber
alter table [TBS065] add [LAYBANEMP] smallint default 0 with values
alter table [TBS065] add [LAYBANCOD] smallint default 0 with values
alter table [TBS065] add [LAYBANNOM] char(40) default '' with values

-- TBS066: leiaute de boletos
alter table [TBS066] add [LEIBANEMP] smallint default 0 with values
alter table [TBS066] add [LEIBANCOD] smallint default 0 with values
alter table [TBS066] add [LEIBANNOM] char(40) default '' with values

-- TBS043: orcamentos
alter table [TBS043] alter column ORCPDDTOT decimal(8,4)

-- TBS055: pedidos de vendas
alter table [TBS055] alter column PDVPDDTOT decimal(8,4)

-- TBS045: pedidos de compras
alter table [TBS045] alter column PDCPDDTOT decimal(8,4)

--alter table [TBS0661] [LEIBOLLIN] 2 -> 3 smallint
--alter table [TBS0661] [LEIBOLCOL] 2 -> 3 smallint

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 5jun2009 -------------------------------------------------------------------------------------------------------------

-- novas tabelas
-- TBS072/73/731: carta de correcao

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS072]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS072]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS073]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS073]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0731]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0731]
GO

CREATE TABLE [dbo].[TBS072] (
	[ESPCOD] [smallint] NOT NULL ,
	[ESPDES] [char] (35) COLLATE Latin1_General_BIN NULL ,
	[ESPDATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS073] (
	[CACEMPCOD] [smallint] NOT NULL ,
	[CACDOC] [int] NOT NULL ,
	[CACDATEMI] [datetime] NULL ,
	[NFSEMPCOD] [smallint] NOT NULL ,
	[NFSNUM] [int] NULL ,
	[CACENDER] [char] (80) COLLATE Latin1_General_BIN NULL ,
	[CACIMPRE] [char] (80) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0731] (
	[CACEMPCOD] [smallint] NOT NULL ,
	[CACDOC] [int] NOT NULL ,
	[ESPCOD] [smallint] NOT NULL ,
	[CACRET] [char] (60) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS072] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ESPCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS073] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CACEMPCOD],
		[CACDOC]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0731] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CACEMPCOD],
		[CACDOC],
		[ESPCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS072] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBS072_ESPCOD] DEFAULT (0) FOR [ESPCOD],
	CONSTRAINT [DF_TBS072_ESPDES] DEFAULT ('') FOR [ESPDES],
	CONSTRAINT [DF_TBS072_ESPDATCAD] DEFAULT ('17530101') FOR [ESPDATCAD]
GO

ALTER TABLE [dbo].[TBS073] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBS073_CACEMPCOD] DEFAULT (0) FOR [CACEMPCOD],
	CONSTRAINT [DF_TBS073_CACDOC] DEFAULT (0) FOR [CACDOC],
	CONSTRAINT [DF_TBS073_CACDATEMI] DEFAULT ('17530101') FOR [CACDATEMI],
	CONSTRAINT [DF_TBS073_NFSEMPCOD] DEFAULT (0) FOR [NFSEMPCOD],
	CONSTRAINT [DF_TBS073_NFSNUM] DEFAULT (0) FOR [NFSNUM],
	CONSTRAINT [DF_TBS073_CACENDER] DEFAULT ('') FOR [CACENDER],
	CONSTRAINT [DF_TBS073_CACIMPRE] DEFAULT ('') FOR [CACIMPRE]
GO

ALTER TABLE [dbo].[TBS0731] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBS0731_CACEMPCOD] DEFAULT (0) FOR [CACEMPCOD],
	CONSTRAINT [DF_TBS0731_CACDOC] DEFAULT (0) FOR [CACDOC],
	CONSTRAINT [DF_TBS0731_ESPCOD] DEFAULT (0) FOR [ESPCOD],
	CONSTRAINT [DF_TBS0731_CACRET] DEFAULT ('') FOR [CACRET]
GO

 CREATE  INDEX [ITBS0731] ON [dbo].[TBS073]([NFSEMPCOD], [NFSNUM]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0732] ON [dbo].[TBS073]([CACEMPCOD], [NFSNUM]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0733] ON [dbo].[TBS073]([CACEMPCOD], [CACDATEMI]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0734] ON [dbo].[TBS073]([CACEMPCOD], [CACDOC] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS07312] ON [dbo].[TBS0731]([ESPCOD]) ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 1jun2009 -------------------------------------------------------------------------------------------------------------

-- insere atributos
-- TBS002: clientes
alter table [TBS002] add [CLITAXJUR] smallmoney default 0 with values

-- TBS056: contas a receber
alter table [TBS056] add [CRETAXJUR] smallmoney default 0 with values
alter table [TBS056] add [CRERESBAN] money default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 21mai2009 ------------------------------------------------------------------------------------------------------------

-- insere atributos
-- TBS0021: niveis
alter table [TBS021] add [NIVICO] char(40) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 7mai2009 -------------------------------------------------------------------------------------------------------------

-- insere atributos
-- TBS053: pedidos bloqueados por credito/preco
alter table [TBS053] add [BCPTOTLIB] money default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 7mai2009 -------------------------------------------------------------------------------------------------------------

-- recriar tabela
-- TBS003: municipios

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS003]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS003]
GO

CREATE TABLE [dbo].[TBS003] (
	[UFESIG] [char] (2) COLLATE Latin1_General_BIN NOT NULL ,
	[MUNCOD] [int] NOT NULL ,
	[MUNNOM] [char] (35) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS003] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[UFESIG],
		[MUNCOD]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0033] ON [dbo].[TBS003]([UFESIG], [MUNNOM]) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0034] ON [dbo].[TBS003]([MUNNOM]) ON [PRIMARY]
GO

-- recriar tabela
-- TBS071: paises

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS071]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS071]
GO

CREATE TABLE [dbo].[TBS071] (
	[PAICOD] [smallint] NOT NULL ,
	[PAINOM] [char] (35) COLLATE Latin1_General_BIN NOT NULL ,
	[PAIDATCAD] [datetime] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS071] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PAICOD],
		[PAINOM]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS0711] ON [dbo].[TBS071]([PAINOM]) ON [PRIMARY]
GO


-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 28abr2009 -------------------------------------------------------------------------------------------------------------

-- insere atributos
-- TBS001: estados
alter table [TBS001] add [UFECODIBGE] smallint default 0 with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 27abr2009 -------------------------------------------------------------------------------------------------------------

-- insere atributos
-- TBS047: requisitantes
alter table [TBS047] add [REQLOCENT] char(100) default '' with values
alter table [TBS047] add [REQLOCCOB] char(100) default '' with values

-- TBS043: orcamentos
alter table [TBS043] add [ORCLOCENT] char(100) default '' with values
alter table [TBS043] add [ORCLOCCOB] char(100) default '' with values

-- TBS055: pedidos de vendas
alter table [TBS055] add [PDVLOCENT] char(100) default '' with values
alter table [TBS055] add [PDVLOCCOB] char(100) default '' with values

-- TBS067: notas fiscais saidas
alter table [TBS067] add [NFSLOCENT] char(100) default '' with values
alter table [TBS067] add [NFSLOCCOB] char(100) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 8abr2009 -------------------------------------------------------------------------------------------------------------

-- insere atributos
-- TBS010: produtos
alter table [TBS010] add [PRODESDET] varchar(600) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [X]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 31mar2009 ------------------------------------------------------------------------------------------------------------

-- insere atributos
-- TBS010: produtos
alter table [TBS010] add [PRODESWEB] char(50) default '' with values
alter table [TBS010] add [PROCLAFIS] char(8) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 13mar2009 ------------------------------------------------------------------------------------------------------------

-- elimina opcoes do menu
delete TBS0181 where PRGCOD='WFIN056'
delete TBS0181 where PRGCOD='WYFIN021'

-- insere opcoes no menu
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WFIN056', 1, 'BAIXAR TITULO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WFIN056', 2, 'BOLETO PRE-IMPRESSO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WFIN056', 3, 'BOLETO FORMATADO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WFIN056', 4, 'EDITAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WFIN056', 5, 'ESTORNAR BAIXA')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WFIN056', 6, 'HISTORICO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WFIN056', 7, 'NOVO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WFIN056', 8, 'VISUALIZAR')

insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WYFIN021', 1, 'CONFIRMAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel corp [x]  misaspel loja [x]  best bag [x]  best office [x]
-- tanby CD [x]


-- 10mar2009 ------------------------------------------------------------------------------------------------------------

-- insere atributos

-- TBS043: orcamentos
alter table [TBS043] add [ORCPDDTOT] decimal default 0 with values

-- TBS045: pedidos compras
alter table [TBS045] add [PDCPDDTOT] decimal default 0 with values

-- TBS055: pedidos vendas
alter table [TBS055] add [PDVPDDTOT] decimal default 0 with values

-- TBS067: notas fiscais saidas
alter table [TBS067] add [NFSPDDTOT] decimal default 0 with values

-- orcamentos
update TBS043
   set ORCPDDTOT=ORCVDDTOT*100/(select sum(ORCQTD*(ORCPRE-ORCPRE*ORCPDDITE/100))
                                  from TBS043 join TBS0431 on TBS043.ORCNUM=TBS0431.ORCNUM
                                 where ORCVDDTOT > 0)
  from TBS043 join TBS0431 on TBS043.ORCNUM=TBS0431.ORCNUM where ORCVDDTOT > 0

-- pedidos vendas
update TBS055
   set PDVPDDTOT=PDVVDDTOT*100/(select sum(PDVQTD*(PDVPRE-PDVPRE*PDVPDDITE/100))
                                  from TBS055 join TBS0551 on TBS055.PDVNUM=TBS0551.PDVNUM
                                 where PDVVDDTOT > 0)
  from TBS055 join TBS0551 on TBS055.PDVNUM=TBS0551.PDVNUM where PDVVDDTOT > 0

-- notas fiscais saida
update TBS067
   set NFSPDDTOT=NFSVDDTOT*100/(select sum(NFSQTD*(NFSPRE-NFSPRE*NFSPDDITE/100))
                                  from TBS067 join TBS0671 on TBS067.NFSNUM=TBS0671.NFSNUM
                                 where NFSVDDTOT > 0)
  from TBS067 join TBS0671 on TBS067.NFSNUM=TBS0671.NFSNUM where NFSVDDTOT > 0

-- pedidos compras
update TBS045
   set PDCPDDTOT=PDCVDDTOT*100/(select sum(PDCQTD*(PDCPRE-PDCPRE*PDCPDDITE/100))
                                  from TBS045 join TBS0451 on TBS045.PDCNUM=TBS0451.PDCNUM
                                 where PDCVDDTOT > 0)
  from TBS045 join TBS0451 on TBS045.PDCNUM=TBS0451.PDCNUM where PDCVDDTOT > 0

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]


-- 5mar2009 -------------------------------------------------------------------------------------------------------------

-- nova tabela
-- TMP008: registros temporarios
CREATE TABLE [dbo].[TMP008] (
	[T8_EMPRESA] [smallint] NOT NULL ,
	[T8_REGISTRO] [int] NOT NULL ,
	[T8_VENCOD] [smallint] NOT NULL ,
	[T8_NFSNUM] [int] NOT NULL ,
	[T8_NFSITE] [smallint] NOT NULL ,
	[T8_PROCOD] [char] (15) COLLATE Latin1_General_BIN NULL ,
	[T8_PRODES] [char] (50) COLLATE Latin1_General_BIN NULL ,
	[T8_VALVEN] [money] NULL ,
	[T8_VALDEV] [money] NULL ,
	[T8_VALTOT] [money] NULL ,
	[T8_VALCUS] [money] NULL ,
	[T8_PERLUC] [smallmoney] NULL ,
	[T8_PERCOM] [smallmoney] NULL ,
	[T8_VALCOM] [money] NULL ,
	[T8_VENNOM] [char] (50) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TMP008] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[T8_EMPRESA],
		[T8_REGISTRO],
		[T8_VENCOD],
		[T8_NFSNUM],
		[T8_NFSITE]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TMP008] WITH NOCHECK ADD 
	CONSTRAINT [DF_TMP008_T8_EMPRESA] DEFAULT (0) FOR [T8_EMPRESA],
	CONSTRAINT [DF_TMP008_T8_VENCOD] DEFAULT (0) FOR [T8_VENCOD],
	CONSTRAINT [DF_TMP008_T8_NFSNUM] DEFAULT (0) FOR [T8_NFSNUM],
	CONSTRAINT [DF_TMP008_T8_NFSITE] DEFAULT (0) FOR [T8_NFSITE],
	CONSTRAINT [DF_TMP008_T8_PROCOD] DEFAULT ('') FOR [T8_PROCOD],
	CONSTRAINT [DF_TMP008_T8_PRODES] DEFAULT ('') FOR [T8_PRODES],
	CONSTRAINT [DF_TMP008_T8_VALVEN] DEFAULT (0) FOR [T8_VALVEN],
	CONSTRAINT [DF_TMP008_T8_VALDEV] DEFAULT (0) FOR [T8_VALDEV],
	CONSTRAINT [DF_TMP008_T8_VALTOT] DEFAULT (0) FOR [T8_VALTOT],
	CONSTRAINT [DF_TMP008_T8_VALCUS] DEFAULT (0) FOR [T8_VALCUS],
	CONSTRAINT [DF_TMP008_T8_PERLUC] DEFAULT (0) FOR [T8_PERLUC],
	CONSTRAINT [DF_TMP008_T8_PERCOM] DEFAULT (0) FOR [T8_PERCOM],
	CONSTRAINT [DF_TMP008_T8_VALCOM] DEFAULT (0) FOR [T8_VALCOM],
	CONSTRAINT [DF_TMP008_T8_VENNOM] DEFAULT ('') FOR [T8_VENNOM]
GO

 CREATE  INDEX [ITMP0081] ON [dbo].[TMP008]([T8_EMPRESA], [T8_REGISTRO], [T8_VENCOD], [T8_PERCOM], [T8_PRODES]) ON [PRIMARY]
GO

-- reestrutura as tabelas: TBS070 / TBS0701 -> comissoes
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS070]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS070]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS0701]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS0701]
GO

CREATE TABLE [dbo].[TBS070] (
	[CMSEMPCOD] [smallint] NOT NULL ,
	[CMSDOC] [int] NOT NULL ,
	[CMSDATPRO] [datetime] NULL ,
	[CMSDATPAG] [datetime] NULL ,
	[CMSDATINI] [datetime] NULL ,
	[CMSDATFIN] [datetime] NULL ,
	[CMSOBS] [char] (254) COLLATE Latin1_General_BIN NULL ,
	[CMSBAI] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[CMSDATBAI] [datetime] NULL ,
	[CMSUSUBAI] [char] (25) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TBS0701] (
	[CMSEMPCOD] [smallint] NOT NULL ,
	[CMSDOC] [int] NOT NULL ,
	[VENCOD] [smallint] NOT NULL ,
	[VENEMPCOD] [smallint] NOT NULL ,
	[CMSVALVEN] [money] NULL ,
	[CMSVALABT] [money] NULL ,
	[CMSVALACR] [money] NULL ,
	[CMSPERCOM] [smallmoney] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS070] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CMSEMPCOD],
		[CMSDOC]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS0701] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[CMSEMPCOD],
		[CMSDOC],
		[VENCOD]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS070] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBS070_CMSEMPCOD] DEFAULT (0) FOR [CMSEMPCOD],
	CONSTRAINT [DF_TBS070_CMSDOC] DEFAULT (0) FOR [CMSDOC],
	CONSTRAINT [DF_TBS070_CMSDATPRO] DEFAULT ('17530101') FOR [CMSDATPRO],
	CONSTRAINT [DF_TBS070_CMSDATPAG] DEFAULT ('17530101') FOR [CMSDATPAG],
	CONSTRAINT [DF_TBS070_CMSDATINI] DEFAULT ('17530101') FOR [CMSDATINI],
	CONSTRAINT [DF_TBS070_CMSDATFIN] DEFAULT ('17530101') FOR [CMSDATFIN],
	CONSTRAINT [DF_TBS070_CMSOBS] DEFAULT ('') FOR [CMSOBS],
	CONSTRAINT [DF_TBS070_CMSBAI] DEFAULT ('') FOR [CMSBAI],
	CONSTRAINT [DF_TBS070_CMSDATBAI] DEFAULT ('17530101') FOR [CMSDATBAI],
	CONSTRAINT [DF_TBS070_CMSUSUBAI] DEFAULT ('') FOR [CMSUSUBAI]
GO

ALTER TABLE [dbo].[TBS0701] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBS0701_CMSEMPCOD] DEFAULT (0) FOR [CMSEMPCOD],
	CONSTRAINT [DF_TBS0701_CMSDOC] DEFAULT (0) FOR [CMSDOC],
	CONSTRAINT [DF_TBS0701_VENCOD] DEFAULT (0) FOR [VENCOD],
	CONSTRAINT [DF_TBS0701_VENEMPCOD] DEFAULT (0) FOR [VENEMPCOD],
	CONSTRAINT [DF_TBS0701_CMSVALVEN] DEFAULT (0) FOR [CMSVALVEN],
	CONSTRAINT [DF_TBS0701_CMSVALABT] DEFAULT (0) FOR [CMSVALABT],
	CONSTRAINT [DF_TBS0701_CMSVALACR] DEFAULT (0) FOR [CMSVALACR],
	CONSTRAINT [DF_TBS0701_CMSPERCOM] DEFAULT (0) FOR [CMSPERCOM]
GO

 CREATE  INDEX [ITBS0702] ON [dbo].[TBS070]([CMSEMPCOD], [CMSDOC] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS0703] ON [dbo].[TBS070]([CMSEMPCOD], [CMSDATPRO] DESC , [CMSDOC] DESC ) ON [PRIMARY]
GO

 CREATE  INDEX [ITBS07012] ON [dbo].[TBS0701]([VENEMPCOD], [VENCOD]) ON [PRIMARY]
GO

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]  tanby CD [x]


-- 27fev2009 ------------------------------------------------------------------------------------------------------------

-- renomear as tabelas TBS065/1/2 para _OLD
exec sp_rename '[dbo].[TBS065]', 'TBS065_OLD', 'OBJECT'

exec sp_rename '[dbo].[TBS0651]', 'TBS0651_OLD', 'OBJECT'

exec sp_rename '[dbo].[TBS0652]', 'TBS0652_OLD', 'OBJECT'

-- recriar as tabelas TBS065/1/2

CREATE TABLE [dbo].[TBS065] (
	[LAYNOM] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[LAYTIP] [char] (3) COLLATE Latin1_General_BIN NOT NULL ,
	[LAYDATCAD] [datetime] NULL ,
	[LAYULTLIN] [smallint] NULL ,
	[LAYMENSEQ] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[OCNABULTLIN] [smallint] NULL 
) ON [PRIMARY]

CREATE TABLE [dbo].[TBS0651] (
	[LAYNOM] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[LAYTIP] [char] (3) COLLATE Latin1_General_BIN NOT NULL ,
	[LAYLIN] [smallint] NOT NULL ,
	[LAYTIPLIN] [char] (1) COLLATE Latin1_General_BIN NOT NULL ,
	[LAYCAMPO] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[LAYPOSINI] [smallint] NULL ,
	[LAYPOSFIN] [smallint] NULL ,
	[LAYDEC] [smallint] NULL ,
	[LAYCON] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[LAYDES] [char] (40) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]

CREATE TABLE [dbo].[TBS0652] (
	[LAYNOM] [char] (20) COLLATE Latin1_General_BIN NOT NULL ,
	[LAYTIP] [char] (3) COLLATE Latin1_General_BIN NOT NULL ,
	[OCNABLIN] [smallint] NOT NULL ,
	[OCNABCOD] [smallint] NOT NULL ,
	[OCNABDES] [char] (30) COLLATE Latin1_General_BIN NULL ,
	[OCNABPRO] [char] (1) COLLATE Latin1_General_BIN NULL 
) ON [PRIMARY]

ALTER TABLE [dbo].[TBS065] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[LAYNOM],
		[LAYTIP]
	)  ON [PRIMARY] 

ALTER TABLE [dbo].[TBS0651] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[LAYNOM],
		[LAYTIP],
		[LAYLIN],
		[LAYTIPLIN]
	)  ON [PRIMARY] 

ALTER TABLE [dbo].[TBS0652] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[LAYNOM],
		[LAYTIP],
		[OCNABLIN],
		[OCNABCOD]
	)  ON [PRIMARY] 

 CREATE  INDEX [ITBS0652] ON [dbo].[TBS065]([LAYTIP]) ON [PRIMARY]

 CREATE  INDEX [ITBS0653] ON [dbo].[TBS065]([LAYNOM] DESC , [LAYTIP] DESC ) ON [PRIMARY]

-- insere os registro

-- TBS065: leiaute CNAB a receber
insert into [TBS065] ([LAYNOM], [LAYTIP], [LAYDATCAD], [LAYULTLIN], [LAYMENSEQ], [OCNABULTLIN])
select subString([LAYNOM],1,20), [LAYTIP], [LAYDATCAD], [LAYULTLIN], [LAYMENSEQ], [OCNABULTLIN]
  from [dbo].[TBS065_OLD]

-- TBS0651: linhas leiaute CNAB a receber
insert into [TBS0651] ([LAYNOM], [LAYTIP], [LAYLIN], [LAYTIPLIN], [LAYCAMPO], [LAYPOSINI], [LAYPOSFIN], [LAYDEC], [LAYCON], [LAYDES])
select subString([LAYNOM],1,20), [LAYTIP], [LAYLIN], [LAYTIPLIN], [LAYCAMPO], [LAYPOSINI], [LAYPOSFIN], [LAYDEC], [LAYCON], [LAYDES]
  from [dbo].[TBS0651_OLD]

-- TBS0652: ocorrencias leiaute CNAB a receber
insert into [TBS0652] ([LAYNOM], [LAYTIP], [OCNABLIN], [OCNABCOD], [OCNABDES], [OCNABPRO])
select subString([LAYNOM],1,20), [LAYTIP], [OCNABLIN], [OCNABCOD], [OCNABDES], [OCNABPRO]
  from [dbo].[TBS0652_OLD]

-- atribui valores default
alter table [dbo].[TBS065] with nocheck add constraint [DF_TBS065_LAYDATCAD] default ('17530101') for [LAYDATCAD]
alter table [dbo].[TBS065] with nocheck add constraint [DF_TBS065_LAYMENSEQ] default ('') for [LAYMENSEQ]
alter table [dbo].[TBS065] with nocheck add constraint [DF_TBS065_LAYNOM] default ('') for [LAYNOM]
alter table [dbo].[TBS065] with nocheck add constraint [DF_TBS065_LAYTIP] default ('') for [LAYTIP]
alter table [dbo].[TBS065] with nocheck add constraint [DF_TBS065_LAYULTLIN] default (0) for [LAYULTLIN]
alter table [dbo].[TBS065] with nocheck add constraint [DF_TBS065_OCNABULTLIN] default (0) for [OCNABULTLIN]

alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYCAMPO] default ('') for [LAYCAMPO]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYCON] default ('') for [LAYCON]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYDEC] default (0) for [LAYDEC]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYDES] default ('') for [LAYDES]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYLIN] default (0) for [LAYLIN]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYNOM] default ('') for [LAYNOM]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYPOSFIN] default (0) for [LAYPOSFIN]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYPOSINI] default (0) for [LAYPOSINI]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYTIP] default ('') for [LAYTIP]
alter table [dbo].[TBS0651] with nocheck add constraint [DF_TBS0651_LAYTIPLIN] default ('') for [LAYTIPLIN]

alter table [dbo].[TBS0652] with nocheck add constraint [DF_TBS0652_LAYNOM] default ('') for [LAYNOM]
alter table [dbo].[TBS0652] with nocheck add constraint [DF_TBS0652_LAYTIP] default ('') for [LAYTIP]
alter table [dbo].[TBS0652] with nocheck add constraint [DF_TBS0652_OCNABCOD] default (0) for [OCNABCOD]
alter table [dbo].[TBS0652] with nocheck add constraint [DF_TBS0652_OCNABDES] default ('') for [OCNABDES]
alter table [dbo].[TBS0652] with nocheck add constraint [DF_TBS0652_OCNABLIN] default (0) for [OCNABLIN]
alter table [dbo].[TBS0652] with nocheck add constraint [DF_TBS0652_OCNABPRO] default ('') for [OCNABPRO]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 25fev2009 ------------------------------------------------------------------------------------------------------------

-- TBS0371: itens movimentos internos
create nonclustered index [ITBS03715] on [dbo].[TBS0371] ([MVIEMPCOD], [MVIDOC], [PROCOD]) on [PRIMARY]
create nonclustered index [ITBS03716] on [dbo].[TBS0371] ([MVIEMPCOD], [MVIDOC], [MVIPRODES]) on [PRIMARY]

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]


-- 20fev2009 ------------------------------------------------------------------------------------------------------------

-- programa novo
insert into [TBS018] ([PRGCOD], [PRGNOM], [PRGDES], [NIVNOM], [PRGBLOQ], [PRGDATCAD], [PRGULTITEM], [PRGBLOQMNU])
values ('WYCOM027', 'PREVISAO ENTREGAS', 'RELATORIO DE PREVISAO DE ENTREGAS DE MERCADORIAS', 'RELATORIOS', 'N', '20090220', 1, 'N')

insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM])
values ('WYCOM027', 1, 'CONFIRMAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]


-- 6fev2009 -------------------------------------------------------------------------------------------------------------

-- novos atributos

-- TBS007: bancos
alter table [TBS007] add [BANLOCPG1] char(80) default '' with values
alter table [TBS007] add [BANLOCPG2] char(80) default '' with values
alter table [TBS007] add [BANMSGBL1] char(80) default '' with values
alter table [TBS007] add [BANMSGBL2] char(80) default '' with values
alter table [TBS007] add [BANMSGBL3] char(80) default '' with values
alter table [TBS007] add [BANMSGBL4] char(80) default '' with values
alter table [TBS007] add [BANMSGBL5] char(80) default '' with values
alter table [TBS007] add [BANNOSNUM] decimal default 0 with values
alter table [TBS007] add [BANLOGO] char(30) default '' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]  best office [x]


-- 6fev2009 ------------------------------------------------------------------------------------------------------------

-- elimina opcoes do menu
delete TBS0181 where PRGCOD='WEST059'

-- insere opcoes no menu
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 1, 'CANCELAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 2, 'EDITAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 3, 'EFETIVAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 4, 'ESTORNAR CANCELAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 5, 'EXCLUIR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 6, 'IMPRIMIR N F DEVOLUCAO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 7, 'NOVO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 8, 'PEDIDOS ATENDIDOS')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WEST059', 9, 'VISUALIZAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 6fev2009 ------------------------------------------------------------------------------------------------------------

-- elimina opcoes do menu
delete TBS0181 where PRGCOD='WVEN067'

-- insere opcoes no menu
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN067', 1, 'CANCELAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN067', 2, 'IMAGEM N F')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN067', 3, 'IMPRIMIR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN067', 4, 'N F COMPLEMENTAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN067', 5, 'PEDIDOS FATURADOS')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN067', 6, 'VISUALIZAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 3fev2009 ------------------------------------------------------------------------------------------------------------

-- elimina opcoes do menu
delete TBS0181 where PRGCOD='WVEN052'

-- insere opcoes no menu
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN052', 1, 'EDITAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN052', 2, 'EXCLUIR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN052', 3, 'EXPORTAR EXCEL')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN052', 4, 'IMPORTAR ORCAMENTO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN052', 5, 'IMPRIMIR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN052', 6, 'NOVO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN052', 7, 'REAJUSTAR TABELA')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WVEN052', 8, 'VISUALIZAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 2fev2009 ------------------------------------------------------------------------------------------------------------

-- elimina opcoes do menu
delete TBS0181 where PRGCOD='WCOM026'

-- insere opcoes no menu
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 1, 'EDITAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 2, 'EXCLUIR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 3, 'EXPORTAR CONTRATO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 4, 'EXPORTAR EXCEL')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 5, 'IMPORTAR ORCAMENTO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 6, 'IMPRIMIR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 7, 'NOVO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 8, 'REAJUSTAR TABELA')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 9, 'VISUALIZAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 23jan2009 ------------------------------------------------------------------------------------------------------------

-- elimina opcoes do menu
delete TBS0181 where PRGCOD='WCOM026'

-- insere opcoes no menu
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 1, 'EDITAR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 2, 'EXCLUIR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 3, 'EXPORTAR EXCEL')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 4, 'IMPORTAR ORCAMENTO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 5, 'IMPRIMIR')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 6, 'NOVO')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 7, 'REAJUSTAR TABELA')
insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 8, 'VISUALIZAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 21jan2009 ------------------------------------------------------------------------------------------------------------

-- elimina opcoes do menu
--delete TBS0181 where PRGCOD='WCOM026'

-- insere opcoes no menu
--insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 1, 'EDITAR')
--insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 2, 'EXCLUIR')
--insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 3, 'EXPORTAR EXCEL')
--insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 4, 'IMPORTAR ORCAMENTO')
--insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 5, 'NOVO')
--insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 6, 'REAJUSTAR TABELA')
--insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM]) values('WCOM026', 7, 'VISUALIZAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 13jan2009 ------------------------------------------------------------------------------------------------------------

-- programa novo
insert into [TBS018] ([PRGCOD], [PRGNOM], [PRGDES], [NIVNOM], [PRGBLOQ], [PRGDATCAD], [PRGULTITEM], [PRGBLOQMNU])
values ('WYCOM024', 'ETIQUETAS PRODUTOS', 'IMPRIME ETIQUETAS DE PRODUTOS', 'RELATORIOS', 'N', '20090112', 1, 'N')

insert into [TBS0181] ([PRGCOD], [PRGEVEITEM], [PRGEVENOM])
values ('WYCOM024', 1, 'CONFIRMAR')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 13jan2009 ------------------------------------------------------------------------------------------------------------

-- insere uma nova opcao no menu
insert into [TBS0191] ([MNUNOM], [PRGCOD], [PRGEVE])
values ('LOJA', 'WYCOM024', ' 1')

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 6jan2009 -------------------------------------------------------------------------------------------------------------

-- novos atributos

-- TBS026: itens da tabela de precos
alter table [TBS026] add [TPCDATIMP] datetime default '17530101' with values
alter table [TBS026] add [TPCORCNUM] int default 0 with values

-- TBS0261: itens da tabela de precos
alter table [TBS0261] add [TPCPREANT] money default 0 with values
alter table [TBS0261] add [TPCINDREA] decimal default 0 with values
alter table [TBS0261] add [TPCTIPREA] char(1) default '' with values
alter table [TBS0261] add [TPCALTPREI] datetime default '17530101' with values
alter table [TBS0261] add [TPCALTITE] datetime default '17530101' with values

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 11dez2008 ------------------------------------------------------------------------------------------------------------

-- TBS0261: itens tabelas precos
create nonclustered index [ITBS02615] on [TBS0261] ([TPCEMPCOD] ,[PROCOD] desc)
create nonclustered index [ITBS02616] on [TBS0261] ([TPCEMPCOD] ,[TPCPRODES] desc)
create nonclustered index [ITBS02617] on [TBS0261] ([TPCEMPCOD] ,[TPCPROCLI] desc)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]


-- 5dez2008 -------------------------------------------------------------------------------------------------------------

-- TBS026: tabela precos
create nonclustered index [ITBS0267] on [TBS026] ([TPCEMPCOD] ,[TPCNUM] desc)

-- atualizados:
-- tanby sjc [x]  tanby tte [x]  papelyna [x]  misaspel [x]  best bag [x]