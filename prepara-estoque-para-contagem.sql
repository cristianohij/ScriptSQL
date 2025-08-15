select * from TBS032 (nolock)
 where ESTLOC=1 and --ESTQTDATU > 0 or
       (ESTQTDPEN > 0 or ESTQTDRES > 0)

update TBS032 set ESTQTDATU=0,ESTQTDPEN=0,ESTQTDRES=0 where ESTLOC=1

delete TBS0371
delete TBS037
delete TBS049

update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS037'
update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS049'

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TBS051]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TBS051]
GO

CREATE TABLE [dbo].[TBS051] (
	[LMEEMPCOD] [smallint] NOT NULL ,
	[LMEREG] [int] NOT NULL ,
	[LMEDOC] [int] NULL ,
	[LMEROT] [char] (8) COLLATE Latin1_General_BIN NULL ,
	[LMEDESROT] [char] (60) COLLATE Latin1_General_BIN NULL ,
	[LMEACA] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[LMEDATHOR] [datetime] NULL ,
	[LMEUSU] [char] (25) COLLATE Latin1_General_BIN NULL ,
	[LMEMOD] [char] (20) COLLATE Latin1_General_BIN NULL ,
	[LMEINFALT] [char] (1) COLLATE Latin1_General_BIN NULL ,
	[PROCOD] [char] (15) COLLATE Latin1_General_BIN NULL ,
	[PROEMPCOD] [smallint] NULL ,
	[LMEQTDSAL] [money] NULL ,
	[LMEQTDMOV] [money] NULL ,
	[LMEQTDATU] [money] NULL ,
	[LMEQTDRES] [money] NULL ,
	[LMEQTDPEN] [money] NULL ,
	[LMEQTDCMP] [money] NULL ,
	[LMEUNI] [char] (2) COLLATE Latin1_General_BIN NULL ,
	[LMEQTDDIS] [money] NULL ,
	[LMELOCEST] [smallint] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TBS051] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[LMEEMPCOD],
		[LMEREG]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TBS051] ADD 
	CONSTRAINT [DF_TBS051_LMEEMPCOD] DEFAULT (0) FOR [LMEEMPCOD],
	CONSTRAINT [DF_TBS051_LMEREG] DEFAULT (0) FOR [LMEREG],
	CONSTRAINT [DF_TBS051_LMEDOC] DEFAULT (0) FOR [LMEDOC],
	CONSTRAINT [DF_TBS051_LMEROT] DEFAULT ('') FOR [LMEROT],
	CONSTRAINT [DF_TBS051_LMEDESROT] DEFAULT ('') FOR [LMEDESROT],
	CONSTRAINT [DF_TBS051_LMEACA] DEFAULT ('') FOR [LMEACA],
	CONSTRAINT [DF_TBS051_LMEDATHOR] DEFAULT ('17530101') FOR [LMEDATHOR],
	CONSTRAINT [DF_TBS051_LMEUSU] DEFAULT ('') FOR [LMEUSU],
	CONSTRAINT [DF_TBS051_LMEMOD] DEFAULT ('') FOR [LMEMOD],
	CONSTRAINT [DF_TBS051_LMEINFALT] DEFAULT ('') FOR [LMEINFALT],
	CONSTRAINT [DF_TBS051_PROCOD] DEFAULT ('') FOR [PROCOD],
	CONSTRAINT [DF_TBS051_PROEMPCOD] DEFAULT (0) FOR [PROEMPCOD],
	CONSTRAINT [DF_TBS051_LMEQTDSAL] DEFAULT (0) FOR [LMEQTDSAL],
	CONSTRAINT [DF_TBS051_LMEQTDMOV] DEFAULT (0) FOR [LMEQTDMOV],
	CONSTRAINT [DF_TBS051_LMEQTDATU] DEFAULT (0) FOR [LMEQTDATU],
	CONSTRAINT [DF_TBS051_LMEQTDRES] DEFAULT (0) FOR [LMEQTDRES],
	CONSTRAINT [DF_TBS051_LMEQTDPEN] DEFAULT (0) FOR [LMEQTDPEN],
	CONSTRAINT [DF_TBS051_LMEQTDCMP] DEFAULT (0) FOR [LMEQTDCMP],
	CONSTRAINT [DF_TBS051_LMEUNI] DEFAULT ('') FOR [LMEUNI],
	CONSTRAINT [DF_TBS051_LMEQTDDIS] DEFAULT (0) FOR [LMEQTDDIS],
	CONSTRAINT [DF_TBS051_LMELOCEST] DEFAULT (0) FOR [LMELOCEST]
GO

 CREATE  INDEX [ITBS0511] ON [dbo].[TBS051]([PROEMPCOD], [PROCOD]) ON [PRIMARY]
GO

select * from TBS053 (nolock) where BCPTIPTRN='P'

delete TBS053 where BCPTIPTRN='P'

update TBS055 set PDVBLQCRE='N' where PDVBLQCRE='S'

update TBS0551 set PDVBLQPRE='N' where PDVBLQPRE='S'

update TBS002 set CLIPEDLIB=0 where CLIPEDLIB<>0

update TBS002 set CLIPEDBLQ=0 where CLIPEDBLQ<>0

select * from TBS032 (nolock) where ESTLOC=1 and (ESTQTDATU<>0 or ESTQTDPEN<>0 or ESTQTDRES<>0)

select * from TBS0551 (nolock) where PDVQTD<>PDVQTDFAT

update TBS0551 set PDVQTDFAT=PDVQTD where PDVQTD<>PDVQTDFAT

select * from TBS058 (nolock)

select * from TBS013 (nolock)

delete TBS013

update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS013'


-- 27/09/2014 - nelson davila

SELECT * FROM TBS032 (NOLOCK) WHERE ESTLOC=1 AND (ESTQTDATU>0 OR ESTQTDPEN>0 OR ESTQTDRES>0)

update TBS032 set ESTQTDATU=0,ESTQTDPEN=0,ESTQTDRES=0 where ESTLOC=1
commit tran
select * FROM TBS037 (NOLOCK) ORDER BY MVIDATLAN DESC

delete TBS0371
delete TBS037
delete TBS049

update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS037'
update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS049'

select * from TBS053 (nolock) where BCPTIPTRN='P'

DELETE TBS053 WHERE BCPTIPTRN='P' AND BCPNUM=305669
delete TBS053 where BCPTIPTRN='P'

update TBS055 set PDVBLQCRE='N' where PDVBLQCRE='S'

update TBS0551 set PDVBLQPRE='N' where PDVBLQPRE='S'

update TBS002 set CLIPEDLIB=0 where CLIPEDLIB<>0

update TBS002 set CLIPEDBLQ=0 where CLIPEDBLQ<>0

select * from TBS032 (nolock) where ESTLOC=1 and (ESTQTDATU<>0 or ESTQTDPEN<>0 or ESTQTDRES<>0)

select * from TBS0551 (nolock) where PDVQTD<>PDVQTDFAT AND NOT EXISTS(SELECT '' FROM TBS058 (NOLOCK) WHERE PRPNUM=PDVNUM)

BEGIN TRAN
update TBS0551 set PDVQTDFAT=PDVQTD where PDVQTD<>PDVQTDFAT AND NOT EXISTS(SELECT '' FROM TBS058 (NOLOCK) WHERE PRPNUM=PDVNUM)
COMMIT TRAN

select * from TBS058 (nolock)

select * from TBS013 (nolock)

delete TBS013

update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS013'

SELECT * FROM TBS076 (NOLOCK)

SELECT * FROM TBS0761 (NOLOCK) WHERE SDCQTDPED<>SDCQTDATD+SDCQTDRES AND SDCPEN='N'

SELECT * FROM TBS0761 (NOLOCK) WHERE SDCQTDPED>SDCQTDATD+SDCQTDRES AND SDCPEN='N'

BEGIN TRAN
UPDATE TBS0761 SET SDCQTDRES=SDCQTDPED-SDCQTDATD WHERE SDCQTDPED>SDCQTDATD+SDCQTDRES
COMMIT TRAN

UPDATE TBS0761 SET SDCPEN='N' WHERE SDCPEN='S' 

BEGIN TRAN
UPDATE TBS032 SET ESTQTDATU=ESTQTDRES WHERE ESTLOC=1 AND ESTQTDRES>0
COMMIT TRAN

SELECT COUNT(*) FROM TBS058 (NOLOCK)

SELECT PROCOD FROM TBS032 (NOLOCK) WHERE ESTLOC=1 AND ESTQTDRES>0 AND NOT EXISTS(SELECT '' FROM TBS058 (NOLOCK) WHERE TBS058.PROCOD=TBS032.PROCOD)

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDRES>0
select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDPEN>0

select top 1 * from TBS051 (nolock)

select * from TBS051 (nolock) where LMEREG=744714

select * from TBS024 (nolock) where TBSNOM='TBS051'

select max(LMEREG) from TBS051 (nolock)

begin tran
update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock) where TBSNOM='TBS051') where TBSNOM='TBS051'
commit tran
rollback tran

begin tran
alter table ESTOQUE_D11M12A2015_10H26M add SEQ int

begin tran
insert into TBS051
   (LMEEMPCOD,LMEREG,LMEDOC,LMEROT,LMEDESROT,LMEACA,LMEDATHOR,LMEUSU,LMEMOD,LMEINFALT,PROCOD,PROEMPCOD,LMEQTDSAL,LMEQTDMOV,LMEQTDATU,LMEQTDRES,LMEQTDPEN,LMEQTDCMP,LMEUNI,LMEQTDDIS,LMELOCEST)
(select 0,sequencia,0,'SQL','ESTOQUE ZERADO PARA CONTAGEM','S',getdate(),'CRISTIANO','NENHUM','E',PROCOD,0,0,ESTQTDATU,ESTQTDATU,ESTQTDRES,ESTQTDPEN,ESTQTDCMP,'',ESTQTDATU-ESTQTDRES,1
   from ESTOQUE_D18M12A2015_16H25M A join #SEQ B on A.PROCOD=B.codigo)
rollback tran
commit tran

select * from TBS051 (nolock) where LMEUSU='CRISTIANO'

begin tran
update TBS051 set LMEDATHOR='2015-12-11 10:47:00' where LMEUSU='CRISTIANO'
commit tran

drop table #SEQ

select PROCOD as codigo,row_number() over(order by PROCOD)+1162114 as sequencia
  into #SEQ
  from TBS032 nolock

select * from #SEQ

select getdate()

select top 50 * from TBS051 (nolock) order by LMEDATHOR desc

select * from TBS037 (nolock)

select  * from TBS024 (nolock) where TBSNOM='TBS051'

-- tanby matriz

select * into ESTOQUE_D12M12A2015_12H53M from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU <> 0

select * from TBS032 (nolock) where ESTLOC=1 and (ESTQTDPEN<>0 or ESTQTDRES<>0)

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU<>0

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDRES<>0

select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDPEN<>0

select * into TBS076BKP from TBS076 (nolock)

select * into TBS0761BKP from TBS0761 (nolock)

select * from TBS0761BKP (nolock)

update TBS032 set ESTQTDATU=0 where ESTLOC=1 and ESTQTDATU <> 0

update TBS032 set ESTQTDATU=ESTQTDRES where ESTLOC=1 and ESTQTDRES > 0

delete TBS0371
delete TBS037
delete TBS049

update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS037'
update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS049'

select * from TBS024 (nolock) where TBSNOM='TBS051'

select max(LMEREG) from TBS051 (nolock)

select PROCOD as codigo,row_number() over(order by PROCOD)+3429847 as sequencia
  into #SEQ
  from ESTOQUE_D12M12A2015_12H53M nolock

select * from #SEQ

begin tran
insert into TBS051
   (LMEEMPCOD,LMEREG,LMEDOC,LMEROT,LMEDESROT,LMEACA,LMEDATHOR,LMEUSU,LMEMOD,LMEINFALT,PROCOD,PROEMPCOD,LMEQTDSAL,LMEQTDMOV,LMEQTDATU,LMEQTDRES,LMEQTDPEN,LMEQTDCMP,LMEUNI,LMEQTDDIS,LMELOCEST)
(select 0,sequencia,0,'SQL','ESTOQUE ZERADO PARA CONTAGEM','S',getdate(),'CRISTIANO','NENHUM','E',PROCOD,0,0,ESTQTDATU,ESTQTDATU,ESTQTDRES,ESTQTDPEN,ESTQTDCMP,'',ESTQTDATU-ESTQTDRES,1
   from TBS032 A join #SEQ B on A.ESTLOC=1 and A.ESTQTDATU=0 and A.PROCOD=B.codigo)
rollback tran
commit tran

begin tran
update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock) where TBSNOM='TBS051') where TBSNOM='TBS051'
commit tran
rollback tran



-- papelyna

-- estoque papelyna: ESTOQUE_D19M12A2015_00H29M

select * from TBS032 (nolock) where ESTLOC=3 and ESTQTDATU <> 0

-- resultado

PROEMPCOD ESTLOC PROCOD          ESTQTDATU             ESTQTDRES             ESTQTDPEN             ESTQTDCMP             ESTDATCAD                                              ESTUSUNOM                 ESTROTEXE  ESTROTDES                                                                                            ESTSEL PRODES                                                       FORCOD      MARCOD PROSTATUS ESTQTDMIN             ESTCONMED             ESTTEMREP ESTQTDSEG             ESTPONPED             ESTDCMDE                                               ESTDCMATE                                              ESTFATSEG ESTLOTCMP             ESTMAXCMP             ESTDATALT                                              
--------- ------ --------------- --------------------- --------------------- --------------------- --------------------- ------------------------------------------------------ ------------------------- ---------- ---------------------------------------------------------------------------------------------------- ------ ------------------------------------------------------------ ----------- ------ --------- --------------------- --------------------- --------- --------------------- --------------------- ------------------------------------------------------ ------------------------------------------------------ --------- --------------------- --------------------- ------------------------------------------------------ 
0         3      20200020        19.0000               .0000                 .0000                 .0000                 2015-07-30 00:00:00.000                                                                                                                                                                                 VANISH PODER O2 ALVEJANTE CRYSTAL WHITE 450G                 3106        2020   A         .0000                 .0000                 0         .0000                 .0000                 1753-01-01 00:00:00.000                                1753-01-01 00:00:00.000                                .0000     .0000                 .0000                 1753-01-01 00:00:00.000

(1 row(s) affected)

update TBS032 set ESTQTDATU=0 where ESTLOC=3 and PROCOD='20200020'

-- copia do estoque 1 para o estoque 3

select count(*) from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU > 0

begin tran
update TBS032 set ESTQTDATU=(select B.ESTQTDATU from TBS032 B (nolock) where B.ESTLOC=1 and B.PROCOD=A.PROCOD)
  from TBS032 A (nolock)
 where A.ESTLOC=3
commit tran
rollback tran

select count(*) from TBS032 (nolock) where ESTLOC=3 and ESTQTDATU > 0

select * into ESTOQUE_D19M12A2015_00H29M from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU <> 0

select top 50 * from TBS051 (nolock) where LMEDESROT='ESTOQUE ZERADO PARA CONTAGEM'

select top 1 * from ESTOQUE_D19M12A2015_00H29M

begin tran
update TBS051 set LMEQTDATU=ESTQTDATU,LMEQTDMOV=ESTQTDATU,LMEQTDCMP=ESTQTDCMP
  from ESTOQUE_D19M12A2015_00H29M EST (nolock)
 where TBS051.LMEDESROT='ESTOQUE ZERADO PARA CONTAGEM' and
       TBS051.LMEUSU='CRISTIANO' and 
       TBS051.LMELOCEST=EST.ESTLOC and
       TBS051.PROCOD=EST.PROCOD
commit tran
