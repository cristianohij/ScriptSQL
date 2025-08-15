select top 10 * from TBS056 (nolock)
select top 10 * from TBS060 (nolock)

update TBS060 set HCREMPCOD=CREEMPCOD
  from TBS056 (nolock), TBS060 (nolock)
 where HCRPFXEMPCOD=PFXEMPCOD and
       HCRCLIEMPCOD=CLIEMPCOD and
       HCRPFXCOD=PFXCOD and
       HCRTIT=CRETIT and
       HCRPAR=CREPAR and
       HCRCLICOD=CLICOD

select * from TBS060 A (nolock)
 where (select count(*) from TBS060 (nolock) 
         where HCREMPCOD=A.HCREMPCOD and
               HCRPFXEMPCOD=A.HCRPFXEMPCOD and
               HCRCLIEMPCOD=A.HCRCLIEMPCOD and
               HCRPFXCOD=A.HCRPFXCOD and
               HCRTIT=A.HCRTIT and
               HCRPAR=A.HCRPAR and
               HCRCLICOD=A.HCRCLICOD and
               HCRSEQ=A.HCRSEQ) > 1
 order by HCRPFXEMPCOD,HCRCLIEMPCOD,HCRPFXCOD,HCRTIT,HCRPAR,HCRCLICOD,HCRSEQ

CREEMPCOD PFXEMPCOD CLIEMPCOD PFXCOD CRETIT      CREPAR CLICO

select * from TBS056 A (nolock)
 where (select count(*) from TBS056 (nolock)
         where CREEMPCOD=A.CREEMPCOD and
               PFXEMPCOD=A.PFXEMPCOD and
               CLIEMPCOD=A.CLIEMPCOD and
               PFXCOD=A.PFXCOD and
               CRETIT=A.CRETIT and
               CREPAR=A.CREPAR and
               CLICOD=A.CLICOD) > 1
 order by CREEMPCOD, PFXEMPCOD, CLIEMPCOD, PFXCOD, CRETIT, CREPAR, CLICOD