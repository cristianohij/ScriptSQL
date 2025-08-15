declare @dataDe char(10),@dataAte char(10)

set @dataDe = '20120401'
set @dataAte = '20120430'

select PROEMPCOD,ESTLOC,PROCOD,PRODES,ESTQTDATU,ESTQTDRES,ESTQTDATU-ESTQTDRES,ESTQTDPEN,ESTQTDCMP,
       (select isNull(sum(NFSQTD*NFSQTDEMB),0) from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and
               TBS0671.NFSNUM = TBS067.NFSNUM
         where NFSDATEMI between @dataDe and @dataAte and NFSCAN = 'N' and NFSDEV = 'N' and TBS0671.PROEMPCOD = TBS032.PROEMPCOD and LESCOD = ESTLOC and
               NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD),
       (select isNull(sum(NFEQTD*NFEQTDEMB),0) from TBS0591 (nolock) join TBS059 (nolock) on TBS0591.NFEEMPCOD = TBS059.NFEEMPCOD and
               TBS0591.NFETIP = TBS059.NFETIP and TBS0591.NFENUM = TBS059.NFENUM and TBS0591.NFECOD = TBS059.NFECOD and TBS0591.SEREMPCOD = TBS059.SEREMPCOD and
               TBS0591.SERCOD = TBS059.SERCOD
         where subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2) between @dataDe and @dataAte and NFECAN = 'N' and
               TBS0591.PROEMPCOD = TBS032.PROEMPCOD and LESCOD = ESTLOC and NFEMOVEST = 'S' and TBS0591.PROCOD = TBS032.PROCOD),
       (select isNull(sum(MVIQTDATD*MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS0371.MVIEMPCOD = TBS037.MVIEMPCOD and TBS0371.MVIDOC = TBS037.MVIDOC
                                join TBS033 (nolock) on TBS037.TMVEMPCOD = TBS033.TMVEMPCOD and TBS037.TMVCOD = TBS033.TMVCOD
         where MVIDATEFE between @dataDe and @dataAte and TMVTIP = 'S' and
               TBS0371.PROEMPCOD = TBS032.PROEMPCOD and MVILOCORI = ESTLOC and TBS0371.PROCOD = TBS032.PROCOD)
  from TBS032 (nolock)
 where ESTLOC = 1 and (
       (select isNull(sum(NFSQTD*NFSQTDEMB),0) from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and
               TBS0671.NFSNUM = TBS067.NFSNUM
         where NFSDATEMI between @dataDe and @dataAte and NFSCAN = 'N' and NFSDEV = 'N' and TBS0671.PROEMPCOD = TBS032.PROEMPCOD and LESCOD = ESTLOC and
               NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) > 0 or
       (select isNull(sum(NFEQTD*NFEQTDEMB),0) from TBS0591 (nolock) join TBS059 (nolock) on TBS0591.NFEEMPCOD = TBS059.NFEEMPCOD and
               TBS0591.NFETIP = TBS059.NFETIP and TBS0591.NFENUM = TBS059.NFENUM and TBS0591.NFECOD = TBS059.NFECOD and TBS0591.SEREMPCOD = TBS059.SEREMPCOD and
               TBS0591.SERCOD = TBS059.SERCOD
         where subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2) between @dataDe and @dataAte and NFECAN = 'N' and
               TBS0591.PROEMPCOD = TBS032.PROEMPCOD and LESCOD = ESTLOC and NFEMOVEST = 'S' and TBS0591.PROCOD = TBS032.PROCOD) > 0 or
       (select isNull(sum(MVIQTDATD*MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS0371.MVIEMPCOD = TBS037.MVIEMPCOD and TBS0371.MVIDOC = TBS037.MVIDOC
                                join TBS033 (nolock) on TBS037.TMVEMPCOD = TBS033.TMVEMPCOD and TBS037.TMVCOD = TBS033.TMVCOD
         where MVIDATEFE between @dataDe and @dataAte and TMVTIP = 'S' and
               TBS0371.PROEMPCOD = TBS032.PROEMPCOD and MVILOCORI = ESTLOC and TBS0371.PROCOD = TBS032.PROCOD) > 0)



--select top 1 * from TBS037 (nolock)