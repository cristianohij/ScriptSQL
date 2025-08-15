set nocount on

declare @dataDe as date, @dataAte as date

select @dataDe='20160518', @dataAte='20221231'

if object_id('TempDB.dbo.#PERIODO') is not null
   begin
      drop table #PERIODO
   end

select @dataDe as dataDe,@dataAte as dataAte into #PERIODO
;

if object_id('TempDB.dbo.#GRUPOCLI') is not null
   begin
      drop table #GRUPOCLI
   end

select CLICOD into #GRUPOCLI from TBS002 (nolock)
 where CLICGC Like('65069593%') or CLICGC Like('09135487%') or CLICGC Like('05118717%') or CLICGC Like('52080207%') or CLICGC Like('44125185')
;

if object_id('TempDB.dbo.#GRUPOFOR') is not null
   begin
      drop table #GRUPOFOR
   end

select FORCOD into #GRUPOFOR from TBS006 (nolock)
 where FORCGC Like('65069593%') or FORCGC Like('09135487%') or FORCGC Like('05118717%') or FORCGC Like('52080207%') or FORCGC Like('44125185')
;

if object_id('TempDB.dbo.#RELATO') is not null
   begin
      drop table #RELATO
   end
;

-- receber

-- fora grupo

with tab1 as (
select CREDATVENREA as data,
       sum(dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)) as previsto,
       sum(CREVALREC) as efetivo,
       avg(dbo.CREDIAATR(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)) as atraso
  from TBS056 (nolock)
 where CREDATVENREA between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and CLICOD not in(select CLICOD from #GRUPOCLI)
 group by CREDATVENREA)
,

-- com grupo

tab4 as (
select CREDATVENREA as data,
       sum(dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)) as previsto,
       sum(CREVALREC) as efetivo,
       avg(dbo.CREDIAATR(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)) as atraso
  from TBS056 (nolock)
 where CREDATVENREA between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and CLICOD in(select CLICOD from #GRUPOCLI)
 group by CREDATVENREA)
,

-- pagar

-- fora grupo

tab2 as (
select CPADATVENREA as data,
       sum(dbo.CPAVALSDO(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD))*-1 as previsto,
       sum(CPAVALPAG)*-1 as efetivo,
       avg(dbo.CPADIAATR(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD)) as atraso
  from TBS057 (nolock)
 where CPADATVENREA between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and FORCOD not in(select FORCOD from #GRUPOFOR)
 group by CPADATVENREA)
,

-- com grupo

tab5 as (
select CPADATVENREA as data,
       sum(dbo.CPAVALSDO(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD))*-1 as previsto,
       sum(CPAVALPAG)*-1 as efetivo,
       avg(dbo.CPADIAATR(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD)) as atraso
  from TBS057 (nolock)
 where CPADATVENREA between (select dataDe from #PERIODO) and (select dataAte from #PERIODO) and FORCOD in(select FORCOD from #GRUPOFOR)
 group by CPADATVENREA)
,

tab3 as (
select grupo='N',
       case when A.data is not null then A.data else B.data end as data,
       isnull(B.efetivo,0) as contasPagas,
       isnull(A.efetivo,0) as contasRecebidas,
       isnull(B.previsto,0) as contasAPagar,
       isnull(B.atraso,0) as atrasoPagar,
       isnull(A.previsto,0) as contasAReceber,
       isnull(A.atraso,0) as atrasoReceber,
       isnull(A.efetivo+B.efetivo,0) as saldoEfetivo,
       isnull(A.efetivo+A.previsto+B.efetivo+B.previsto,0) as saldoPrevisto
  from tab1 as A
       full join tab2 as B on B.data=A.data)
,

tab6 as (
select grupo='S',
       case when A.data is not null then A.data else B.data end as data,
       isnull(B.efetivo,0) as contasPagas,
       isnull(A.efetivo,0) as contasRecebidas,
       isnull(B.previsto,0) as contasAPagar,
       isnull(B.atraso,0) as atrasoPagar,
       isnull(A.previsto,0) as contasAReceber,
       isnull(A.atraso,0) as atrasoReceber,
       isnull(A.efetivo+B.efetivo,0) as saldoEfetivo,
       isnull(A.efetivo+A.previsto+B.efetivo+B.previsto,0) as saldoPrevisto
  from tab4 as A
       full join tab5 as B on B.data=A.data)

select * into #RELATO from tab3 union select * from tab6

select * from #RELATO


-- contas a pagar

-- valor títulos contas a pagar com vencimento neste dia

-- fora grupo

select isnull(sum(dbo.CPAVALSDO(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD))*-1,0) as aPagar,
       count(*) as titulos
  from TBS057 (nolock) where CPADATVENREA=convert(date,getdate()) and FORCOD not in(select FORCOD from #GRUPOFOR)

-- do grupo

select isnull(sum(dbo.CPAVALSDO(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD))*-1,0) as aPagar,
       count(*) as titulos
  from TBS057 (nolock) where CPADATVENREA=convert(date,getdate()) and FORCOD in(select FORCOD from #GRUPOFOR)

-- valor títulos contas a pagar que foram pagos neste dia

-- fora grupo

select isnull(sum(CPAVALPAG)*-1,0) as pago,
       count(*) as titulos
  from TBS057 (nolock) where CPADATBAI=convert(date,getdate()) and CPAVALPAG > 0 and FORCOD not in(select FORCOD from #GRUPOFOR)

-- do grupo

select isnull(sum(CPAVALPAG)*-1,0) as pago,
       count(*) as titulos
  from TBS057 (nolock) where CPADATBAI=convert(date,getdate()) and CPAVALPAG > 0 and FORCOD in(select FORCOD from #GRUPOFOR)

-- atrasadas

-- fora grupo

select isnull(sum(dbo.CPAVALSDO(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD))*-1,0) as aPagar,
       count(*) as titulos
  from TBS057 (nolock)
 where CPADATBAI='17530101' and dbo.CPADIAATR(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD) > 0 and FORCOD not in(select FORCOD from #GRUPOFOR)

-- do grupo

select isnull(sum(dbo.CPAVALSDO(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD))*-1,0) as aPagar,
       count(*) as titulos
  from TBS057 (nolock)
 where CPADATBAI='17530101' and dbo.CPADIAATR(0,0,0,PFXCOD,CPATIT,CPAPAR,FORCOD) > 0 and FORCOD in(select FORCOD from #GRUPOFOR)




-- contas a receber

-- valor títulos contas a receber com vencimento neste dia

-- fora grupo

select isnull(sum(dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)),0) as aReceber,
       count(*) as titulos
  from TBS056 (nolock) where CREDATVENREA=convert(date,getdate()) and CLICOD not in(select CLICOD from #GRUPOCLI)

-- do grupo

select isnull(sum(dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)),0) as aReceber,
       count(*) as titulos
  from TBS056 (nolock) where CREDATVENREA=convert(date,getdate()) and CLICOD in(select CLICOD from #GRUPOCLI)

-- valor títulos contas a receber que foram recebidos neste dia

-- fora grupo

select isnull(sum(CREVALREC),0) as recebido,
       count(*) as titulos
  from TBS056 (nolock) where CREDATBAI=convert(date,getdate()) and CREVALREC > 0 and CLICOD not in(select CLICOD from #GRUPOCLI)

-- do grupo

select isnull(sum(CREVALREC),0) as recebido,
       count(*) as titulos
  from TBS056 (nolock) where CREDATBAI=convert(date,getdate()) and CREVALREC > 0 and CLICOD in(select CLICOD from #GRUPOCLI)

-- atrasadas

-- fora grupo

select isnull(sum(dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)),0) as aReceber,
       count(*) as titulos
  from TBS056 (nolock)
 where CREDATBAI='17530101' and dbo.CREDIAATR(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD) > 0 and CLICOD not in(select CLICOD from #GRUPOCLI)

-- do grupo

select isnull(sum(dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD)),0) as aReceber,
       count(*) as titulos
  from TBS056 (nolock)
 where CREDATBAI='17530101' and dbo.CREDIAATR(0,0,0,PFXCOD,CRETIT,CREPAR,CLICOD) > 0 and CLICOD in(select CLICOD from #GRUPOCLI)




--select year(data),month(data),day(data),* from #RELATO

-- pedidos de vendas em aberto

if object_id('TempDB.dbo.#GRUPOCLI') is not null
   begin
      drop table #GRUPOCLI
   end

select CLICOD into #GRUPOCLI from TBS002 (nolock)
 where CLICGC Like('65069593%') or CLICGC Like('09135487%') or CLICGC Like('05118717%') or CLICGC Like('52080207%') or CLICGC Like('44125185')
;

select 'fora grupo',sum(PRPQTD*PRPPRELIQ) from TBS058 (nolock) where PRPCLICOD not in(select CLICOD from #GRUPOCLI)


select 'do grupo',sum(PRPQTD*PRPPRELIQ) from TBS058 (nolock) where PRPCLICOD in(select CLICOD from #GRUPOCLI)

with tab1 as (
select grupo='N',
       (select sum(dbo.PDVTOTLIQ(PDVEMPCOD,PDVNUM)-dbo.PDVTOTFAT(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVEMPCOD=PRPEMP and PDVNUM=PRPNUM group by PDVNUM) as total
  from TBS058 (nolock)
 where PRPCLICOD not in(select CLICOD from #GRUPOCLI)
 group by PRPEMP,PRPNUM)
,

tab2 as (
select grupo='S',
       sum(dbo.PDVTOTLIQ(PRPEMP,PRPNUM)-dbo.PDVTOTFAT(PRPEMP,PRPNUM)) as total
  from TBS058 (nolock) 
       inner join TBS055 (nolock) on PRPEMP=PDVEMPCOD and PRPNUM=PDVNUM
 where PDVCLICOD in(select CLICOD from #GRUPOCLI)
 group by PRPNUM)

select * from tab1

select sum(total) from tab1

select top 1 * from TBS058 (nolock)

select sum(PRPQTD*PRPPRELIQ) from TBS058 (nolock)


/*select grupo='N',
       sum(dbo.PDVTOTLIQ(PRPEMP,PRPNUM)-dbo.PDVTOTFAT(PRPEMP,PRPNUM)) as total
  from TBS058 (nolock), 
       left join TBS055 (nolock) on PRPEMP=PDVEMPCOD and PRPNUM=PDVNUM
 where PDVCLICOD not in(select CLICOD from #GRUPOCLI)
 group by PRPNUM)
*/


select count(*) from TBS058 (nolock)


select PRPEMP,PRPNUM,grupo='N'
--       (select sum(dbo.PDVTOTLIQ(PDVEMPCOD,PDVNUM)-dbo.PDVTOTFAT(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVEMPCOD=PRPEMP and PDVNUM=PRPNUM group by PDVNUM) as total
  from TBS058 (nolock)
       inner join TBS055 (nolock) on PRPEMP=PDVEMPCOD and PRPNUM=PDVNUM
 group by PRPEMP,PRPNUM
 order by PRPNUM


select sum(dbo.PDVTOTLIQ(PDVEMPCOD,PDVNUM)-dbo.PDVTOTFAT(PDVEMPCOD,PDVNUM)) as total
  from TBS055 (nolock)
 where exists(select top 1 '' from TBS058 (nolock) where PRPEMP=PDVEMPCOD and PRPNUM=PDVNUM)

select PDVPRE,dbo.PDVPRELIQ(0,PDVNUM,PDVITEM),PRPPRE,PRPPRELIQ
  from TBS0551 (nolock) inner join TBS058 (nolock) on PDVNUM=PRPNUM and PDVITEM=PRPITEM
 where PDVPRE<>PRPPRE or dbo.PDVPRELIQ(0,PDVNUM,PDVITEM) <> PRPPRELIQ




-- pedidos de vendas em aberto

-- fora o grupo

select sum(PRPQTD*PRPPRELIQ) from TBS058 (nolock) where PRPCLICOD not in(select CLICOD from #GRUPOCLI)

-- do grupo

select sum(PRPQTD*PRPPRELIQ) from TBS058 (nolock) where PRPCLICOD in(select CLICOD from #GRUPOCLI)



-- pedidos de compras em aberto

declare @data date

set @data=getdate()-180

select sum(dbo.PDCTOTBRU(PDCEMPCOD,PDCNUM) - (dbo.PDCTOTENT(PDCEMPCOD,PDCNUM) + dbo.PDCTOTRES(PDCEMPCOD,PDCNUM)))
  from TBS045 (nolock)
 where PDCDATCAD > @data and dbo.PDCTOTBRU(PDCEMPCOD,PDCNUM) - (dbo.PDCTOTENT(PDCEMPCOD,PDCNUM) + dbo.PDCTOTRES(PDCEMPCOD,PDCNUM)) > 0


