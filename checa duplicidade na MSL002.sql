select M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,M2_HOR,M2_NUMDOC,M2_NUMPED,M2_TIPDOC,M2_TIPREG,M2_PROCOD,M2_NUMORDITE,M2_FINVEN,M2_CODTIT,M2_NUMNFS
  from MSL002 A
 where (select count(*) from MSL002 B
         where B.M2_EMPCOD = A.M2_EMPCOD and 
               B.M2_LOJ = A.M2_LOJ and 
               B.M2_CXA = A.M2_CXA and 
               B.M2_DAT = A.M2_DAT and
               B.M2_HOR = A.M2_HOR and
               B.M2_NUMDOC = A.M2_NUMDOC and
               B.M2_NUMPED = A.M2_NUMPED and
               B.M2_TIPDOC = A.M2_TIPDOC and
               B.M2_TIPREG = A.M2_TIPREG and 
               B.M2_PROCOD = A.M2_PROCOD and
               B.M2_NUMORDITE = A.M2_NUMORDITE and
               B.M2_FINVEN = A.M2_FINVEN and
               B.M2_CODTIT = A.M2_CODTIT) > 1
 order by M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,M2_HOR,M2_NUMDOC,M2_NUMPED,M2_TIPDOC,M2_TIPREG,M2_PROCOD,M2_NUMORDITE,M2_FINVEN,M2_CODTIT
