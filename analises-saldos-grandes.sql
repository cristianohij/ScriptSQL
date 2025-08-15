select M2_DAT,M2_TIPREG,M2_REGCAN,M2_QTD,* from MSL002 (nolock) where M2_PROCOD = '8800319' order by M2_DAT desc

select * from MSL002 (nolock) where M2_PROCOD = '8800319' and M2_REGCAN = 'T' order by M2_DAT desc

select * from MSL002 (nolock) where M2_TIPREG = '04' order by M2_DAT desc

select sum(M2_QTD) from MSL002 (nolock) where M2_PROCOD = '8800319'

select * from MSL002 (nolock)
 where --M2_EMPCOD = 0 and
       --M2_LOJ = 1 and
       M2_CXA = 1 and
       --M2_DAT = '20130716' and
       --M2_HOR = '15:10' and
       M2_NUMDOC in(21755,89403) and
       --M2_NUMPED = '' and
       --M2_TIPDOC = 'T' and
       M2_TIPREG = '01' and
       M2_PROCOD = '8800319'
--       M2_PROCOD = 
--       M2_NUMORDITE = 
       --M2_FINVEN = 
       --M2_CODTIT =

select M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,M2_HOR,M2_NUMDOC,M2_NUMPED,M2_TIPDOC,M2_TIPREG,M2_PROCOD,M2_NUMORDITE,M2_FINVEN,M2_CODTIT
 from MSL002 (nolock) where M2_TIPREG = '04' order by M2_DAT desc

select * from MSL002 (nolock) where M2_TIPREG = '04' and M2_NUMDOC in(21755,89403) order by M2_DAT desc

select * from TBS0371 (nolock) where MVIQTDPED = 44653 order by MVIDOC

select * from TBS0371 (nolock) where PROCOD = '8800319' order by MVIDOC

select * from TBS051 (nolock) where PROCOD = '8800319'

select min(MVIDATEFE) from TBS037 (nolock) where MVIDATEFE > '17530101'