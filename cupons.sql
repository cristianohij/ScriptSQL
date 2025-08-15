select * from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_NUMDOC in(52739,52743,52794,52818,52827,52835,52839) and M2_TIPREG='01' and M2_TRB='T12.00'

select M2_TIPREG from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_NUMDOC in(52739,52743,52794,52818,52827,52835,52839)
 group by M2_TIPREG

select * from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_NUMDOC in(52739,52743,52794,52818,52827,52835,52839) and M2_TIPREG='02'

select * from MSL002 (nolock) where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_NUMDOC = 52739


select * from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_NUMDOC in(52739,52743,52794,52818,52827,52835,52839) and M2_TIPREG='03'

select * from MSL002 (nolock)
 where M2_DAT between '20150113' and '20150113' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'

select * from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_TIPREG='03'

select M2_NUMDOC,M2_PROCOD,M2_NUMORDITE,M2_REGCAN from MSL002 (nolock)
 where M2_DAT between '20141201' and '20141201' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_TRB='T18.00'
 order by M2_PROCOD

select * from MSL002 (nolock) where M2_NUMECF=18 and M2_NUMDOC=49012

select sum(M2_VALTOT),sum(M2_ABT) from MSL002 (nolock)
 where M2_DAT between '20141201' and '20141201' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T18.00'

select sum(M2_VALTOT),round(sum(M2_ABT),2,1),sum(M2_VALTOT-round(M2_ABT,2,1)) from MSL002 (nolock)
 where M2_DAT between '20141201' and '20141201' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_TRB='T18.00'

select M2_NUMDOC,M2_PROCOD,M2_VALTOT,M2_ABT,M2_TRB from MSL002 (nolock)
 where M2_DAT between '20150113' and '20150113' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'
compute sum(M2_ABT)

select sum(M2_VALTOT-M2_ABT) from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_TRB='F00.00'

select M2_VALUNI,M2_QTD,M2_ABT from MSL002 (nolock)
 where M2_DAT between '20141201' and '20141231' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_TRB='T18.00'


select M2_DAT,sum(M2_VALTOT-M2_ABT)
  from MSL002 (nolock)
 where M2_DAT between '20141201' and '20141231' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_TRB='T18.00'
 group by M2_DAT

select count(*)
  from MSL002 (nolock)
 where M2_DAT='20150113' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_TRB='F00.00' and M2_REGCAN='F'

select sum(M2_VALTOT),sum(M2_ABT),sum(M2_VALTOTABT) from MSL002 (nolock)
 where M2_DAT='20150113' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'

select M2_NUMDOC,M2_PROCOD,M2_TRB,M2_VALTOT,M2_ABT,M2_VALTOTABT from MSL002 (nolock)
 where M2_DAT='20150113' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'

select count(*) -- M2_NUMDOC,M2_PROCOD,M2_TRB,M2_VALTOT,M2_ABT
  from MSL002 (nolock)
 where M2_DAT between '20150101' and '20150128' and M2_TIPREG='01' and M2_REGCAN='F' and M2_DESITE>0

-- cancelamento de cupom
select M2_REGCAN,* from MSL002 (nolock)
 where M2_DAT between '20141201' and '20141231' and M2_NUMECF = 18 and M2_TIPREG='04'

select sum(M2_VALTOT),sum(M2_ABT) from MSL002 where M2_DAT='2014-12-01' and M2_NUMECF=18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T07.00'
select sum(M2_VALTOT),sum(M2_ABT) from MSL002 where M2_DAT='2014-12-01' and M2_NUMECF=18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T12.00'
select sum(M2_VALTOT),sum(M2_ABT) from MSL002 where M2_DAT='2014-12-01' and M2_NUMECF=18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T18.00'
select sum(M2_VALTOT),sum(M2_ABT) from MSL002 where M2_DAT='2014-12-01' and M2_NUMECF=18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'

select M2_TRB,M2_PROCOD,M2_VALTOT,M2_ABT,M2_VALTOT-M2_ABT,round(M2_VALTOT-M2_ABT,2),DESCITEM,DESCONTOITEM from MSL002 (nolock)
 where M2_DAT='2014-12-01' and M2_NUMECF=18 and M2_TIPREG='01' and M2_REGCAN='F'
 order by M2_TRB,M2_PROCOD
compute sum(M2_VALTOT),sum(M2_ABT),sum(M2_VALTOT-M2_ABT),sum(DESCITEM) by M2_TRB


select M2_PROCOD,M2_VALTOT,M2_ABT from MSL002 (nolock)
 where M2_DAT='2014-12-01' and M2_NUMECF=18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'

