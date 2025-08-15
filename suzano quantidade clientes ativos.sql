select count(distinct(CLICGC)) from TBS067 (noLock)
              join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
              join TBS002 (noLock) on TBS067.NFSCLICOD=TBS002.CLICOD
              join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
              join TBS010 (noLock) on TBS0671.PROCOD=TBS010.PROCOD
 where NFSTIP='N' and NFSDATEMI between '2009-07-01' and '2009-07-31' and
       TBS0671.PROCOD Like('164%') and FORCOD=15 and
       TESCNTVEN='S' and CLITIPPES='J'