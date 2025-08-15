select PROCOD as 'produto',
       NFSQTD as 'qtde',
       NFSPRE-(NFSPRE*NFSPDDITE/100) as 'preLiquido',
       NFSPRECUS as 'preCusto',
       (1 - (NFSPRECUS/(NFSPRE-(NFSPRE*NFSPDDITE/100)))) * 100 as 'margLucro',
       100-(1 - (NFSPRECUS/(NFSPRE-(NFSPRE*NFSPDDITE/100)))) * 100 as 'divisao'
  from TBS0671 (noLock) join TBS067 (noLock) on TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI='2009-10-27' and VENCOD=5