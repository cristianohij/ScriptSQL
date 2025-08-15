select M2_DAT,M2_CXA,sum(M2_VALTOT) from MSL002 (nolock) where M2_DAT between '20121121' and '20121121' group by M2_DAT,M2_CXA order by M2_CXA

select M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,
       (select sum(M2_VALTOT) from MSL002 b (nolock)
         where b.M2_TIPREG = '03' and b.M2_EMPCOD = a.M2_EMPCOD and b.M2_LOJ = a.M2_LOJ and b.M2_CXA = a.M2_CXA and b.M2_DAT = a.M2_DAT),
       (select sum(M2_VALTOT) from MSL002 b (nolock)
         where b.M2_TIPREG = '10' and b.M2_EMPCOD = a.M2_EMPCOD and b.M2_LOJ = a.M2_LOJ and b.M2_CXA = a.M2_CXA and b.M2_DAT = a.M2_DAT),
       (select sum(M2_VALTOT) from MSL002 b (nolock)
         where b.M2_TIPREG = '11' and b.M2_EMPCOD = a.M2_EMPCOD and b.M2_LOJ = a.M2_LOJ and b.M2_CXA = a.M2_CXA and b.M2_DAT = a.M2_DAT),
       (select sum(M2_VALTOT) from MSL002 b (nolock)
         where b.M2_TIPREG = '16' and b.M2_EMPCOD = a.M2_EMPCOD and b.M2_LOJ = a.M2_LOJ and b.M2_CXA = a.M2_CXA and b.M2_DAT = a.M2_DAT),
       (select sum(M2_VALTOT) from MSL002 b (nolock)
         where b.M2_TIPREG = '21' and b.M2_EMPCOD = a.M2_EMPCOD and b.M2_LOJ = a.M2_LOJ and b.M2_CXA = a.M2_CXA and b.M2_DAT = a.M2_DAT),
       (select sum(M2_VALTOT) from MSL002 b (nolock)
         where b.M2_TIPREG = '22' and b.M2_EMPCOD = a.M2_EMPCOD and b.M2_LOJ = a.M2_LOJ and b.M2_CXA = a.M2_CXA and b.M2_DAT = a.M2_DAT),
       (select sum(M2_VALTOT) from MSL002 b (nolock)
         where b.M2_TIPREG = '23' and b.M2_EMPCOD = a.M2_EMPCOD and b.M2_LOJ = a.M2_LOJ and b.M2_CXA = a.M2_CXA and b.M2_DAT = a.M2_DAT),
       (select sum(M2_VALTOT) from MSL002 b (nolock)
         where b.M2_TIPREG = '24' and b.M2_EMPCOD = a.M2_EMPCOD and b.M2_LOJ = a.M2_LOJ and b.M2_CXA = a.M2_CXA and b.M2_DAT = a.M2_DAT)
  from MSL002 a (nolock) where M2_DAT between '20121121' and '20121121'
 group by M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT
 order by M2_CXA

select M2_PROCOD,sum(M2_QTD),sum(M2_VALTOT),sum(M2_VALTOT)/sum(M2_QTD) from MSL002 (nolock)
 where M2_TIPREG = '01' and M2_DAT between '20121121' and '20121121' and M2_REGCAN = 'F' and M2_PROCOD = '1640054'
 group by M2_PROCOD

select M2_PROCOD,sum(M2_QTD),sum(M2_VALTOT),sum(M2_VALTOT)/sum(M2_QTD) from MSL002 (nolock)
 where M2_DAT between '20121121' and '20121121' and M2_PROCOD = '1640054'
 group by M2_PROCOD

select M2_PROCOD,
      (select sum(M2_QTD) from MSL002 (nolock) where M2_TIPREG = '01' and M2_DAT between '20121121' and '20121121' and M2_PROCOD = a.M2_PROCOD),
      (select sum(M2_VALTOT) from MSL002 (nolock) where M2_TIPREG = '01' and M2_DAT between '20121121' and '20121121' and M2_PROCOD = a.M2_PROCOD),
      (select sum(M2_QTD) from MSL002 (nolock) where M2_TIPREG = '10' and M2_DAT between '20121121' and '20121121' and M2_PROCOD = a.M2_PROCOD),
      (select sum(M2_VALTOT) from MSL002 (nolock) where M2_TIPREG = '10' and M2_DAT between '20121121' and '20121121' and M2_PROCOD = a.M2_PROCOD)
  from MSL002 a (nolock)
 where M2_DAT between '20121121' and '20121121' --and M2_PROCOD = '1640054'
 group by M2_PROCOD

Order M2_PROCOD M2_DAT
    Where   M2_EMPCOD   = &M2_EMPCOD
    Where   M2_TIPREG   = '01'      // vendas
    Where   M2_REGCAN   = 'F'       // cupom nao cancelado
    Where   M2_PROCOD   >= &proDe 
    Where   M2_PROCOD   <= &proAte  When not &proAte.IsEmpty()  
    Where   M2_DAT      >= &datDe
    Where   M2_DAT      <= &datAte  When not &datAte.IsEmpty()

select M2_DAT,M2_CXA,
       (select sum(M2_VALTOT) from MSL002 (nolock) where M2_DAT between '20121121' and '20121121' and M2_CXA = a.M2_CXA and M2_NUMNFS = 0),
       (select sum(M2_VALTOT) from MSL002 (nolock) where M2_DAT between '20121121' and '20121121' and M2_CXA = a.M2_CXA and M2_NUMNFS > 0)
  from MSL002 a (nolock) where M2_DAT between '20121121' and '20121121' group by M2_DAT,M2_CXA order by M2_CXA

select count(*),sum(dbo.PDVTOTLIQ(PDVEMPCOD,PDVNUM)),sum(dbo.PDVTOTFAT(PDVEMPCOD,PDVNUM)) from TBS055 (nolock) where PDVDATCAD between '20121122' and '20121122'