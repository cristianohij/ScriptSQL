select M2_PROCOD,M2_QTD,M2_VALUNI,M2_VALTOT,M2_ABT,NFSPDDITE,round(round(NFSQTD*NFSPRE,2) * NFSPDDITE / 100 ,4),round(NFSQTD*NFSPRE,2),M2_DESITE,NFSQTD,NFSPRE,M2_NUMORDITE,NFSITE
  from MSL002 (nolock) join TBS0671 (nolock) on PROCOD=M2_PROCOD and NFSQTD=M2_QTD
 where M2_TIPREG='01' and
       M2_REGCAN='F' and
       M2_NUMDOC=70231 and
       NFSNUM=23925
--       and M2_VALTOT<>round(NFSQTD*NFSPRE,4)
--       and M2_ABT=0
--       and M2_QTD=NFSQTD
 order by M2_NUMORDITE

update TBS0671 set NFSPDDITE=0 where NFSNUM=23925

update TBS0671 set NFSPDDITE=round(M2_ABT*100/M2_VALTOT,4)
  from MSL002 (nolock) join TBS0671 (nolock) on PROCOD=M2_PROCOD
 where M2_TIPREG='01' and
       M2_REGCAN='F' and
       M2_NUMDOC=70231 and
       NFSNUM=23925 and
       M2_QTD=NFSQTD

--       and M2_VALTOT<>round(NFSQTD*NFSPRE,4)
--       and M2_ABT=0

update TBS0671 set NFSPDDITE=(
select round(M2_ABT*100/M2_VALTOT,4)
  from MSL002 (nolock) join TBS0671 (nolock) on PROCOD=M2_PROCOD
 where M2_TIPREG='01' and
       M2_REGCAN='F' and
       M2_NUMDOC=70231 and
       NFSNUM=23925
       and M2_QTD=NFSQTD)

update TBS0671 set NFSITE=NFSITE*2 where NFSNUM=23925

select * from TBS0671 (nolock) where NFSNUM=23925 order by NFSITE
 
update TBS0671 set NFSITE=M2_NUMORDITE
  from MSL002 (nolock) join TBS0671 (nolock) on PROCOD=M2_PROCOD
 where M2_TIPREG='01' and
       M2_REGCAN='F' and
       M2_NUMDOC=70231 and
       NFSNUM=23925 and
       M2_QTD=NFSQTD

