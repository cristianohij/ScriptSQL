select * from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU<0

select * from MSL002 (nolock) where M2_TIPREG='01' and M2_REGCAN='F' and M2_DATPROC = '2015-12-12' and M2_HORPROC >= '19:00'

select M2_DATPROC,* from MSL002 (nolock) where M2_NUMDOC in(77699,77700,75447)


select M2_NUMDOC,M2_TIPREG,M2_PROCOD,M2_NUMORDITE,M2_QTD,M2_CXA,M2_OPE,M2_DAT,M2_HOR,M2_COO,M2_NUMECF,M2_DATMOV,M2_REGCAN,M2_DATPROC,M2_HORPROC
  into GZ
  from MSL002 (nolock)
 where M2_TIPREG='01' and M2_DATPROC >= '2015-12-12' and M2_HORPROC >= '19:00'

select * from GZ (nolock)

select * from GZ (nolock) where not exists(select '' from TBS

select top 1 * from TBS037 (nolock)
select top 1 * from TBS0371 (nolock)

select TBS037.MVIDOC,TBS037.MVIDATLAN,TBS037.MVIDATEFE,TBS037.TMVCOD,TBS037.CCSCOD,TBS037.MVICCSCOD,TBS037.MVICCSNOM,TBS037.MVILOCORI,TBS037.MVILOCDES,TBS037.MVIULTITE,
       TBS0371.MVIITE,TBS0371.PROCOD,TBS0371.MVIPRODES,TBS0371.MVIPROUNI,TBS0371.MVIQTDPED,TBS0371.MVIQTDATD,TBS0371.MVIQTDEMB
  into MOVLOJA
  from TBS037 (nolock) join TBS0371 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where convert(char(8),MVIDATLAN,112)='20151212'


select * from MOVLOJA

select MVILOCORI,MVILOCDES,* from MOVLOJA (nolock) where MVILOCDES=1 or MVILOCORI=1

delete MOVLOJA where MVILOCDES=1 or MVILOCORI=1

select MVILOCORI,MVILOCDES,* from MOVLOJA (nolock) where MVILOCDES>0 and MVILOCORI>0

select TMVCOD,count(*) from MOVLOJA (nolock) group by TMVCOD

select PROCOD,case when TMVCOD=1 then sum(MVIQTDATD*MVIQTDEMB) else 0 end,case when TMVCOD=500 then sum(MVIQTDATD*MVIQTDEMB) else 0 end
  from MOVLOJA (nolock)
 group by PROCOD

select PROCOD,
       case when TMVCOD=1 then sum(MVIQTDATD*MVIQTDEMB) else 0 end,case when TMVCOD=500 then sum(MVIQTDATD*MVIQTDEMB) else 0 end OVER (PARTITION BY PROCOD)
  from MOVLOJA (nolock)


select PROCOD as produto,
       getdate() as lancamento,
       getdate() as efetivacao,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVLOJA where TMVCOD=1 and MOVLOJA.PROCOD=A.PROCOD),0) as entrada,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVLOJA where TMVCOD=500 and MOVLOJA.PROCOD=A.PROCOD),0) as saida,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVLOJA where TMVCOD=1 and MOVLOJA.PROCOD=A.PROCOD),0)-
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVLOJA where TMVCOD=500 and MOVLOJA.PROCOD=A.PROCOD),0) as saldo
  into SALDOLOJA
  from MOVLOJA A (nolock) 
 group by PROCOD


select *,(select PRODES from TBS010 (nolock) where PROCOD=produto) from SALDOLOJA

begin tran
alter table SALDOLOJA drop column efetivacao
commit tran

begin tran
alter table SALDOLOJA add estorno smallint
commit tran

update SALDOLOJA set estorno=0


select * from GZ (nolock) where M2_REGCAN='T'

select M2_PROCOD as codigo,sum(M2_QTD) as quantidade into ESTORNOGZ from GZ (nolock) group by M2_PROCOD

select * from ESTORNOGZ

update TBS032 set ESTQTDATU=ESTQTDATU+

select * from TBS032 where ESTLOC=2

update SALDOLOJA set estorno=isnull((select quantidade from ESTORNOGZ (nolock) where codigo=produto),0)

select * from SALDOLOJA (nolock) where estorno > 0 and saldo=0


select *
  from TBS032
 where ESTLOC=2 and ESTQTDATU < 0 and
       exists(select '' from ESTORNOGZ (nolock) where codigo=PROCOD) and
       not exists(select '' from SALDOLOJA (nolock) where produto=PROCOD)


select PROCOD,ESTLOC,ESTQTDATU from TBS032 (nolock) where ESTLOC=2 and PROCOD in(select codigo from ESTORNOGZ (nolock))

begin tran
update TBS032 set ESTQTDATU=ESTQTDATU+quantidade
  from TBS032 join ESTORNOGZ on PROCOD=codigo
 where ESTLOC=2
rollback tran
commit tran


select produto,count(*) from SALDOLOJA (nolock) group by produto having count(*) > 1

select M2_PROCOD as codigo,sum(M2_QTD) as quantidade into VENDASGZ
  from MSL002 (nolock)
 where M2_TIPREG='01' and M2_DAT >= '20151214' and M2_REGCAN='F'
group by M2_PROCOD

select PROCOD,ESTQTDATU,(select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS032.PROCOD),isnull((select saldo from SALDOLOJA (nolock) where produto=PROCOD),0),
       (select quantidade from #VENDASGZ where codigo=PROCOD)
  from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU < 0


select * from MOVLOJA (nolock)
 where PROCOD in('0051411','9070168','0450854','14530009','0060674','4520649','7880140','0090638','1070037','10840078','16200110','4720034','4720047','8520216')

select * from MSL002 (nolock)
 where M2_TIPREG='01' and M2_REGCAN='F' and M2_DATPROC >= '20151214' and
       M2_PROCOD in('0051411','9070168','0450854','14530009','0060674','4520649','7880140','0090638','1070037','10840078','16200110','4720034','4720047','8520216')
                       x          x         x          x         x         x         x         x         x          x          x         x          x        x

select *
  into LOGBXALOJA
  from TBS051 (nolock)

begin tran
delete TBS051 
 where convert(char(8),LMEDATHOR,112) = '20151212' and convert(char(2),LMEDATHOR,8) >= '19' and LMEDESROT Like('%CUPONS%')
commit tran



select * from LOGBXALOJA


select * from TBS032 (nolock) where ESTLOC=2 and PROCOD='1641239'

select * from MSL002 (nolock)
 where M2_TIPREG='01' and M2_REGCAN='F' and M2_DATPROC >= '20151214' and M2_PROCOD in('1641239')


---

select M2_PROCOD as codigo,sum(M2_QTD) as quantidade into VENDASGZ
  from MSL002 (nolock)
 where M2_TIPREG='01' and M2_DAT >= '20151214' and M2_REGCAN='F'
group by M2_PROCOD

select * from VENDASGZ

-- movimentos internos da loja

drop table MOVINTERNOS

select TBS037.MVIDOC,TBS037.MVIDATLAN,TBS037.MVIDATEFE,TBS037.TMVCOD,TBS037.CCSCOD,TBS037.MVICCSCOD,TBS037.MVICCSNOM,TBS037.MVILOCORI,TBS037.MVILOCDES,TBS037.MVIULTITE,
       TBS0371.MVIITE,TBS0371.PROCOD,TBS0371.MVIPRODES,TBS0371.MVIPROUNI,TBS0371.MVIQTDPED,TBS0371.MVIQTDATD,TBS0371.MVIQTDEMB
  into MOVINTERNOS
  from TBS037 (nolock) join TBS0371 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where convert(char(8),MVIDATEFE,112) between '20151212' and '20151222' and
       (MVILOCDES=2 or MVILOCORI=2)
 
 select * into EST2212 from TBS032 (nolock) where ESTLOC in(1,2)

-- movimentos internos loja

drop table #SALDOLOJA

select PROCOD as produto,
       getdate() as lancamento,
       getdate() as efetivacao,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVINTERNOS where MVILOCDES=2 and MOVINTERNOS.PROCOD=A.PROCOD),0) as entrada,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVINTERNOS where MVILOCORI=2 and MOVINTERNOS.PROCOD=A.PROCOD),0) as saida,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVINTERNOS where MVILOCDES=2 and MOVINTERNOS.PROCOD=A.PROCOD),0)-
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVINTERNOS where MVILOCORI=2 and MOVINTERNOS.PROCOD=A.PROCOD),0) as saldo
  into #SALDOLOJA
  from MOVINTERNOS A (nolock) 
-- where A.MVILOCDES=2 or A.MVILOCORI=2
 group by PROCOD

select *,(select PRODES from TBS010 (nolock) where PROCOD=produto) from #SALDOLOJA


select MVILOCORI,MVILOCDES,* from MOVLOJA (nolock) where MVILOCDES=1 or MVILOCORI=1

select PROCOD as codigo,
       ESTQTDATU as estoque,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=EST2212.PROCOD) as descricao,
       isnull((select entrada from #SALDOLOJA (nolock) where produto=PROCOD),0) as entradasMI,
       isnull((select saida from #SALDOLOJA (nolock) where produto=PROCOD),0) as saidasMI,
       isnull((select saldo from #SALDOLOJA (nolock) where produto=PROCOD),0) as saldoMI,
       isnull((select quantidade from #ENTRADAS (nolock) where codigo=PROCOD),0) as NFentrada,
       isnull((select quantidade from VENDASGZ where codigo=PROCOD),0) as ecf
  from EST2212 (nolock) where ESTLOC=2 and ESTQTDATU < 0

select TBS059.NFETIP,
       TBS059.NFENUM,
       TBS059.NFECOD,
       TBS059.NFENOSFOR,
       TBS059.NFENOM,
       TBS059.NFEUSUEFE,
       TBS059.NFEDATEMI,
       TBS059.NFEOBS,
       TBS059.SERCOD,
       TBS059.TPTCOD,
       TBS059.NFECHAACE,
       TBS059.NFEIMPXML,
       TBS059.NFEDATENT,
       TBS0591.NFEITE,
       TBS0591.PROCOD,
       TBS0591.NFEDES,
       TBS0591.NFEQTD,
       TBS0591.NFEQTDEMB,
       TBS0591.NFEUNI,
       TBS0591.LESCOD,
       TBS0591.NFEMOVEST
  into #NFENTRADA
  from TBS059 (nolock)
       join TBS0591 (nolock) on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFENUM=TBS059.NFENUM and TBS0591.NFECOD=TBS059.NFECOD and
            TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.SERCOD=TBS059.SERCOD
 where TBS059.NFEDATENT between '20151214' and '20151222' and
       TBS059.NFECAN='N' and
       TBS0591.LESCOD=2 and
       TBS0591.NFEMOVEST='S'

drop table #ENTRADAS

select PROCOD as codigo,sum(NFEQTD*NFEQTDEMB) as quantidade
  into #ENTRADAS
  from #NFENTRADA group by PROCOD


select * from TBS049 (nolock)

select top 1 * from TBS037 (nolock)

select top 1 * from TBS0371 (nolock)

select TMVCOD from TBS037 (nolock) group by TMVCOD

select * from TBS037 (nolock) join TBS0371 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC where PROCOD='1640054' order by TBS037.MVIDATEFE

select * from TBS033 (nolock)

select M2_HOR,*
  from MSL002 (nolock)
 where M2_TIPREG='01' and M2_DAT >= '20151214' and M2_REGCAN='F' and M2_PROCOD='0050237'
 order by M2_HOR,M2_NUMDOC,M2_NUMORDITE




-- misaspel

select * from TBS049 (nolock)

select * from TBS037 (nolock) where MVILOCORI = 5 or MVILOCDES = 5

select * from TBS034 (nolock)

select * from TBS033 (nolock)

-- não existem entradas via NF
select * from TBS0591 (nolock) where LESCOD=5

-- não existem saídas via NF
select * from TBS0671 (nolock) where LESCOD=5

-- movimentos internos

select TBS037.MVIDOC,TBS037.MVIDATLAN,TBS037.MVIDATEFE,TBS037.TMVCOD,TBS037.CCSCOD,TBS037.MVICCSCOD,TBS037.MVICCSNOM,TBS037.MVILOCORI,TBS037.MVILOCDES,TBS037.MVIULTITE,
       TBS0371.MVIITE,TBS0371.PROCOD,TBS0371.MVIPRODES,TBS0371.MVIPROUNI,TBS0371.MVIQTDPED,TBS0371.MVIQTDATD,TBS0371.MVIQTDEMB
  into MOVEST5
  from TBS037 (nolock) join TBS0371 (nolock) on TBS037.MVIDOC=TBS0371.MVIDOC
 where convert(char(8),TBS037.MVIDATLAN,112) >= '20160112' and TBS037.MVILOCORI = 5 or TBS037.MVILOCDES = 5

select * from MOVEST5

drop table MOVEST5

select PROCOD as produto,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVEST5 where TMVCOD in(1,2) and MOVEST5.PROCOD=A.PROCOD),0) as entrada,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVEST5 where TMVCOD in(500,501) and MOVEST5.PROCOD=A.PROCOD),0) as saida,
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVEST5 where TMVCOD in(1,2) and MOVEST5.PROCOD=A.PROCOD),0)-
       isnull((select sum(MVIQTDATD*MVIQTDEMB) from MOVEST5 where TMVCOD in(500,501) and MOVEST5.PROCOD=A.PROCOD),0) as saldo
  into SALDOEST5
  from MOVEST5 A (nolock) 
 group by PROCOD

drop table SALDOEST5

select *,(select PRODES from TBS010 (nolock) where PROCOD=produto) from SALDOEST5 where saldo > 0

select produto as codigo,row_number() over(order by produto)+1200995 as sequencia
  into #SEQ
  from SALDOEST5 nolock
 where saldo > 0

drop table #SEQ

begin tran
insert into TBS051
   (LMEEMPCOD,LMEREG,LMEDOC,LMEROT,LMEDESROT,LMEACA,LMEDATHOR,LMEUSU,LMEMOD,LMEINFALT,PROCOD,PROEMPCOD,LMEQTDSAL,LMEQTDMOV,LMEQTDATU,LMEQTDRES,LMEQTDPEN,LMEQTDCMP,LMEUNI,LMEQTDDIS,LMELOCEST)
(select 0,sequencia,0,'SQL','INVENTARIO ROTATIVO','E',getdate(),'CRISTIANO','NENHUM','E',produto,0,0,saldo,0,0,0,0,'',0,5
   from SALDOEST5 A join #SEQ B on A.produto=B.codigo
  where saldo > 0)
rollback tran
commit tran

select * from TBS024 (nolock) where TBSNOM='TBS051'

select max(LMEREG) from TBS051 (nolock)

select PROCOD as codigo,row_number() over(order by PROCOD)+1200615 as sequencia
  into #SEQ
  from TBS032 nolock
 where ESTLOC=5 and ESTQTDATU > 0

drop table #SEQ

begin tran
insert into TBS051
   (LMEEMPCOD,LMEREG,LMEDOC,LMEROT,LMEDESROT,LMEACA,LMEDATHOR,LMEUSU,LMEMOD,LMEINFALT,PROCOD,PROEMPCOD,LMEQTDSAL,LMEQTDMOV,LMEQTDATU,LMEQTDRES,LMEQTDPEN,LMEQTDCMP,LMEUNI,LMEQTDDIS,LMELOCEST)
(select 0,sequencia,0,'SQL','INVENTARIO ROTATIVO','S',getdate(),'CRISTIANO','NENHUM','E',PROCOD,0,0,ESTQTDATU,ESTQTDATU,ESTQTDRES,ESTQTDPEN,ESTQTDCMP,'',ESTQTDATU-ESTQTDRES,ESTLOC
   from TBS032 A join #SEQ B on A.PROCOD=B.codigo
  where ESTLOC=5 and ESTQTDATU > 0)
rollback tran
commit tran

select * from TBS051 (nolock) where LMEUSU='CRISTIANO'

begin tran
update TBS024 set TBSVALSEQ=(select max(LMEREG) from TBS051 (nolock) where TBSNOM='TBS051') where TBSNOM='TBS051'
commit tran
rollback tran

begin tran
update TBS032 set ESTQTDATU=0 where ESTLOC=5 and ESTQTDATU<>0
commit tran

select PROCOD,(select PRODES from TBS010 A (nolock) where A.PROCOD=B.PROCOD),ESTQTDATU,(select PROUM1 from TBS010 A (nolock) where A.PROCOD=B.PROCOD)
  from TBS032 B (nolock)
 where ESTLOC=5 and ESTQTDATU>0

begin tran
update TBS032 set ESTQTDATU=saldo
--select *
  from TBS032 (nolock) join SALDOEST5 on produto=PROCOD
 where ESTLOC=5 and saldo > 0
commit tran
rollback tran

