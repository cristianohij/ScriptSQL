select * from TBS053 (nolock) where BCPTIPTRN='P' order by BCPNUM

--select PDVBLQPRE,* from TBS0551 (nolock) where PDVNUM=373283 order by PDVITEM

select PDVITEM,
       PDVQTD,
       PDVQTDFAT,
       PDVBLQPRE,
       dbo.PDVVALFAT(PDVEMPCOD, PDVNUM, PDVITEM),
       dbo.PDVVALLIB(PDVEMPCOD, PDVNUM, PDVITEM),
       dbo.PDVVALBLQ(PDVEMPCOD, PDVNUM, PDVITEM)
  from TBS0551 (nolock)
 where PDVNUM=373334
 order by PDVITEM


select PDVNUM,
       dbo.PDVTOTBLQ(PDVEMPCOD, PDVNUM),
       dbo.PDVTOTLIB(PDVEMPCOD, PDVNUM)
  from TBS055 (nolock)
 where PDVCLICOD=198

select PDVCLICOD,
       sum(dbo.PDVTOTBLQ(PDVEMPCOD, PDVNUM)),
       sum(dbo.PDVTOTLIB(PDVEMPCOD, PDVNUM))
  from TBS055 (nolock)
 where PDVCLICOD=198
 group by PDVCLICOD

select count(*) from TBS002 (nolock)

update TBS002
   set CLIPEDLIB=isnull((select sum(dbo.PDVTOTLIB(PDVEMPCOD, PDVNUM)) from TBS055 (nolock) where PDVCLICOD=CLICOD),0),
       CLIPEDBLQ=isnull((select sum(dbo.PDVTOTBLQ(PDVEMPCOD, PDVNUM)) from TBS055 (nolock) where PDVCLICOD=CLICOD),0)
-- where CLICOD > 19500 and CLICOD <= 20000
 where CLICOD in(15243,
13583,
11225,
11183,
10250,
9574 ,
9243 ,
8882 ,
8493 ,
8285 ,
7233 ,
6710 ,
6381 ,
6099 ,
2412 ,
1507 ,
1024 ,
824  ,
512  ,
39   ,
18983
)


PDVNUM=373334

select CLICOD,
       CLIPEDLIB,
       CLIPEDBLQ,
       isnull((select sum(dbo.PDVTOTLIB(PDVEMPCOD, PDVNUM)) from TBS055 (nolock) where PDVCLICOD=CLICOD),0),
       isnull((select sum(dbo.PDVTOTBLQ(PDVEMPCOD, PDVNUM)) from TBS055 (nolock) where PDVCLICOD=CLICOD),0)
  from TBS002 (nolock)
 where --(CLIPEDLIB <> isnull((select sum(dbo.PDVTOTLIB(PDVEMPCOD, PDVNUM)) from TBS055 (nolock) where PDVCLICOD=CLICOD),0) or
       --CLIPEDBLQ <> isnull((select sum(dbo.PDVTOTBLQ(PDVEMPCOD, PDVNUM)) from TBS055 (nolock) where PDVCLICOD=CLICOD),0))
       CLICOD=1537

select * from TBS055 (nolock) where PDVDATCAD='20160416' and PDVCLICOD in(13583,
5741 ,
2412 ,
1918 ,
512  ,
100  )

begin tran
update TBS002 set CLIPEDLIB=0,CLIPEDBLQ=0 where CLICOD=198
commit tran

-- zera os valores

update TBS002 set CLIPEDLIB=0,CLIPEDBLQ=0

-- atualiza os valores

update TBS002
   set CLIPEDLIB=isnull((select sum(dbo.PDVTOTLIB(0, PRPNUM)) from TBS058 (nolock) where PDVCLICOD=CLICOD),0),
       CLIPEDBLQ=isnull((select sum(dbo.PDVTOTBLQ(0, PRPNUM)) from TBS058 (nolock) where PDVCLICOD=CLICOD),0)



select PRPCLICOD,isnull((select dbo.PDVTOTLIB(PDVEMPCOD,PDVNUM) from TBS055 (nolock)
 where PDVNUM=PRPNUM),0)
  from TBS058 (nolock)
 where PRPNUM=375023
 group by PRPCLICOD,PRPNUM


select PRPCLICOD as codigo,
       isnull(dbo.PDVTOTLIB(0,PRPNUM),0) as liberado,
       isnull(dbo.PDVTOTBLQ(0,PRPNUM),0) as bloqueado
  into #pedido
  from TBS058 (nolock)
       inner join TBS055 (nolock) on TBS055.PDVNUM=TBS058.PRPNUM
where PRPCLICOD=1537
group by PRPCLICOD,PRPNUM
order by PRPCLICOD

select * from #pedido

update TBS002
   set CLIPEDLIB=isnull((select sum(liberado) from #pedido where codigo=CLICOD group by codigo),0),
       CLIPEDBLQ=isnull((select sum(bloqueado) from #pedido where codigo=CLICOD group by codigo),0)

select CLIPEDLIB,CLIPEDBLQ from TBS002 (nolock) where CLICOD=66

select count(*) from TBS002 (nolock) where CLIPEDLIB > 0 or CLIPEDBLQ > 0

select isnull(dbo.PDVTOTLIB(0,PRPNUM),0)
  from TBS058 (nolock)
       inner join TBS055 (nolock) on TBS055.PDVNUM=TBS058.PRPNUM
group by PRPCLICOD,PRPNUM
 


update TBS002 set CLIPEDLIB=0,CLIPEDBLQ=0

drop table #pedido

select PRPCLICOD as codigo,
       isnull(dbo.PDVTOTLIB(0,PRPNUM),0) as liberado,
       isnull(dbo.PDVTOTBLQ(0,PRPNUM),0) as bloqueado
  into #pedido
  from TBS058 (nolock)
       inner join TBS055 (nolock) on TBS055.PDVNUM=TBS058.PRPNUM
group by PRPCLICOD,PRPNUM
order by PRPCLICOD

update TBS002
   set CLIPEDLIB=isnull((select sum(liberado) from #pedido where codigo=CLICOD group by codigo),0),
       CLIPEDBLQ=isnull((select sum(bloqueado) from #pedido where codigo=CLICOD group by codigo),0)

drop table #resultado

select CLICOD as codigo,
       CLIPEDLIB as libCli,
       CLIPEDBLQ as bloCli,
       isnull((select sum(liberado) from #pedido where codigo=CLICOD),0) as libPed,
       isnull((select sum(bloqueado) from #pedido where codigo=CLICOD),0) as bloPed
  into #resultado
  from TBS002 (nolock)

select * from #resultado where libCli+bloCli+libPed+bloPed > 0 and (libCli<>libPed or bloCli<>bloPed)

-- conta a receber

update TBS002 set CLITITABT = (select sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD))
                                 from TBS056 (nolock) where TBS056.CLIEMPCOD = TBS002.CLIEMPCOD and TBS056.CLICOD = TBS002.CLICOD)
-- where CLICOD > 19500 and CLICOD <= 19000
 where CLICOD in(492  ,
4963 ,
8415 ,
9255 ,
14793,
15506,
17252,
19073,
19106
)


select CLICOD,CLITITABT,
       isnull((select sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD))
                from TBS056 (nolock) where TBS056.CLIEMPCOD = TBS002.CLIEMPCOD and TBS056.CLICOD = TBS002.CLICOD),0)
  from TBS002 (nolock)
 where CLITITABT <> (select sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD))
                       from TBS056 (nolock) where TBS056.CLIEMPCOD = TBS002.CLIEMPCOD and TBS056.CLICOD = TBS002.CLICOD)

-- listagem de título em aberto

drop table #receber

select CLICOD as codigo,
       isnull(sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD)),0) as saldo
  into #receber
  from TBS056 (nolock)
 group by CLICOD
having isnull(sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD)),0) > 0
 order by CLICOD

select * from #receber

-- zera os títulos em aberto

update TBS002 set CLITITABT=0

-- atualiza os títulos em aberto

update TBS002 set CLITITABT=isnull((select sum(saldo) from #receber where codigo=CLICOD group by codigo),0)

drop table #resultado

select CLICOD as codigo,
       CLITITABT as cliSaldo,
       isnull((select sum(saldo) from #receber where codigo=CLICOD),0) as saldoCont
  into #resultado
  from TBS002 (nolock)

select * from #resultado where cliSaldo+saldoCont > 0 and cliSaldo <> saldoCont

select CLICOD,CLITITABT from TBS002 (nolock) where CLICOD=10

select count(*) from TBS002 (nolock) where CLITITABT > 0

select CLICOD,CLITITABT,saldo from TBS002 (nolock) inner join #receber on codigo=CLICOD
 where CLITITABT<>saldo


update TBS002 set CLITITABT=0

drop table #receber

select CLICOD as codigo,
       isnull(sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD)),0) as saldo
  into #receber
  from TBS056 (nolock)
 group by CLICOD
having isnull(sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD)),0) > 0
 order by CLICOD

update TBS002 set CLITITABT=isnull((select sum(saldo) from #receber where codigo=CLICOD group by codigo),0)



-- atualiza atributo bloqueio de crédito do pedido de vendas

select * from TBS053 (nolock) where BCPNUM=375023

begin tran
update TBS053 set BCPBLQCRE=PDVBLQCRE 
  from TBS053 (nolock)
       inner join TBS055 (nolock) on PDVNUM=BCPNUM
 where BCPTIPTRN='P'
rollback tran

-- análise dos bloqueios

select * from TBS053 (nolock) where BCPTIPTRN='P' and BCPBLQCRE='N' and BCPBLQPRE='N'

-- atualiza atributo bloqueio de preços do pedido de vendas

-- com bloqueio

begin tran
update TBS053 set BCPBLQPRE='S'
 where BCPTIPTRN='P' and BCPBLQPRE='N' and (select count(*) from TBS0551 (nolock) where PDVNUM=BCPNUM and PDVBLQPRE='S') > 0
rollback tran

begin tran
update TBS053 set BCPBLQCRE='S'
 where BCPTIPTRN='P' and BCPBLQCRE='N' and exists(select '' from TBS055 (nolock) where PDVNUM=BCPNUM and PDVBLQCRE='S')
rollback tran

-- sem bloqueio

-- preços

begin tran
--update TBS053 set BCPBLQPRE='N'
select * from TBS053 (nolock)
 where BCPTIPTRN='P' and BCPBLQPRE='S' and (select count(*) from TBS0551 (nolock) where PDVNUM=BCPNUM and PDVBLQPRE='S') = 0
commit tran

-- crédito

begin tran
--update TBS053 set BCPBLQPRE='N'
select * from TBS053 (nolock)
 where BCPTIPTRN='P' and BCPBLQCRE='S' and (select count(*) from TBS055 (nolock) where PDVNUM=BCPNUM and PDVBLQCRE='S') = 0
commit tran


select PDVBLQPRE,* from TBS0551 (nolock) where PDVNUM=375656

select * from TBS053 (nolock) where BCPTIPTRN='P' and BCPTOT=0

begin tran
delete TBS053 where BCPNUM=374177
commit tran

begin tran
update TBS055 set PDVBLQCRE='N' where PDVNUM=374177
commit tran

begin tran
--delete TBS053
select BCPNUM from TBS053 (nolock)
 where BCPTIPTRN='P' and not exists(select PDVNUM from TBS055 as A (nolock)
                                     where PDVNUM=BCPNUM and (PDVBLQCRE='S' or (select count(*) from TBS0551 (nolock) where PDVNUM=A.PDVNUM and PDVBLQPRE='S') > 0))
commit tran






-- 30/09/16 - ajustes pedidos liberados/bloqueados

if object_id('TempDB.dbo.#cliente') is not null
   begin
      drop table #cliente
   end

select PRPCLICOD into #cliente from TBS058 (nolock) group by PRPCLICOD

if object_id('TempDB.dbo.#pedido') is not null
   begin
      drop table #pedido
   end

select PRPCLICOD as cliente,
       isnull((select dbo.PDVTOTLIB(PDVEMPCOD, PDVNUM) from TBS055 (nolock) where PDVNUM=PRPNUM),0) as liberado,
       isnull((select dbo.PDVTOTBLQ(PDVEMPCOD, PDVNUM) from TBS055 (nolock) where PDVNUM=PRPNUM),0) as bloqueado
  into #pedido
  from TBS058 (nolock)
 group by PRPCLICOD,PRPNUM
 order by PRPCLICOD,PRPNUM

--select PRPCLICOD,
--       isnull((select sum(liberado) from #TBS058 where cliente=PRPCLICOD),0),
--       isnull((select sum(bloqueado) from #TBS058 where cliente=PRPCLICOD),0)
--  from TBS058 (nolock)
-- group by PRPCLICOD

update TBS002
       set CLIPEDLIB=isnull((select sum(liberado) from #pedido where cliente=CLICOD),0),
           CLIPEDBLQ=isnull((select sum(bloqueado) from #pedido where cliente=CLICOD),0)
  from TBS002 (nolock) inner join #cliente on PRPCLICOD=CLICOD

update TBS002 set CLIPEDLIB=0,CLIPEDBLQ=0 where not exists(select '' from TBS058 (nolock) where PRPCLICOD=CLICOD)



-- 30/09/16 - títulos em aberto

if object_id('TempDB.dbo.#titulo') is not null
   begin
      drop table #titulo
   end

select CLICOD as cliente,
       isnull(sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD)),0) as saldo
  into #titulo
  from TBS056 (nolock)
 group by CLICOD
having isnull(sum(dbo.CREVALSDO(CREEMPCOD,PFXEMPCOD,CLIEMPCOD,PFXCOD,CRETIT,CREPAR,CLICOD)),0) > 0

update TBS002 set CLITITABT=saldo
  from TBS002 (nolock) inner join #titulo on cliente=CLICOD

update TBS002 set CLITITABT=0 where not exists(select '' from #titulo (nolock) where cliente=CLICOD) 
