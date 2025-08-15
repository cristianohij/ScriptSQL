select NFSNUM,str(round(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),2),12,2) as 'VALOR',
       (select str(isnull(sum(CREVAL),0),12,2) from TBS056 (noLock) where CRETIT=NFSNUM and PFXCOD='NFF')
  from TBS0671 (noLock)
 where exists(select 'ex' from TBS056 (noLock) where PFXCOD='NFF' and CRETIT=NFSNUM)
group by NFSNUM
having round(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),2) <>
       (select round(sum(CREVAL),2) from TBS056 (noLock) where PFXCOD='NFF' and CRETIT=NFSNUM)


