declare @database char(8)

set @database = '20130301'

select TBS032.PROCOD as 'produto',
       TBS032.ESTQTDATU as 'saldo-atual',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where TBS0371.PROCOD = TBS032.PROCOD and TBS033.TMVTIP = 'E') as 'mov-entrada',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where TBS0371.PROCOD = TBS032.PROCOD and TBS033.TMVTIP = 'S') as 'mov-saida',
       (select isnull(sum(TBS049.MDSQTD * TBS049.MDSQTDEMB),0)
          from TBS049 (nolock)
         where TBS049.PROCOD = TBS032.PROCOD and TBS049.MDSTIP = 'E') as 'manutencao-entrada',
       (select isnull(sum(TBS049.MDSQTD * TBS049.MDSQTDEMB),0)
          from TBS049 (nolock)
         where TBS049.PROCOD = TBS032.PROCOD and TBS049.MDSTIP = 'S') as 'manutencao-saida',
       (select isnull(sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB),0)
          from TBS0591 (nolock) join TBS059 (nolock) on TBS059.NFEEMPCOD = TBS0591.NFEEMPCOD and TBS059.NFETIP = TBS0591.NFETIP and
                                                        TBS059.NFENUM = TBS0591.NFENUM and TBS059.NFECOD = TBS0591.NFECOD and
                                                        TBS059.SEREMPCOD = TBS0591.SEREMPCOD and TBS059.SERCOD = TBS0591.SERCOD
         where subString(TBS059.NFEUSUEFE,7,4)+subString(TBS059.NFEUSUEFE,4,2)+subString(TBS059.NFEUSUEFE,1,2) >= @database and TBS0591.NFEMOVEST = 'S'
               and TBS0591.PROCOD = TBS032.PROCOD) as 'nfe-entrada',
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI >= @database and TBS067.NFSCAN <> 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) as 'nfs-saida',
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI >= @database and TBS067.NFSCAN = 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) as 'nfs-saida-cancelada',
       (select isnull(sum(M2_QTD),0) from MSL002 (nolock)
         where MSL002.M2_DAT >= @database and MSL002.M2_TIPREG = '01' and MSL002.M2_PROCOD = TBS032.PROCOD) as 'vendas-gz'
  from TBS032 (nolock) --where TBS032.PROCOD = '1320000'
 group by TBS032.PROCOD ,TBS032.ESTQTDATU
having (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where TBS0371.PROCOD = TBS032.PROCOD and TBS033.TMVTIP = 'E') > 0 or
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where TBS0371.PROCOD = TBS032.PROCOD and TBS033.TMVTIP = 'S') > 0 or
       (select isnull(sum(TBS049.MDSQTD * TBS049.MDSQTDEMB),0)
          from TBS049 (nolock)
         where TBS049.PROCOD = TBS032.PROCOD and TBS049.MDSTIP = 'E') > 0 or
       (select isnull(sum(TBS049.MDSQTD * TBS049.MDSQTDEMB),0)
          from TBS049 (nolock)
         where TBS049.PROCOD = TBS032.PROCOD and TBS049.MDSTIP = 'S') > 0 or
       (select isnull(sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB),0)
          from TBS0591 (nolock) join TBS059 (nolock) on TBS059.NFEEMPCOD = TBS0591.NFEEMPCOD and TBS059.NFETIP = TBS0591.NFETIP and
                                                        TBS059.NFENUM = TBS0591.NFENUM and TBS059.NFECOD = TBS0591.NFECOD and
                                                        TBS059.SEREMPCOD = TBS0591.SEREMPCOD and TBS059.SERCOD = TBS0591.SERCOD
         where subString(TBS059.NFEUSUEFE,7,4)+subString(TBS059.NFEUSUEFE,4,2)+subString(TBS059.NFEUSUEFE,1,2) >= @database and TBS0591.NFEMOVEST = 'S'
               and TBS0591.PROCOD = TBS032.PROCOD) > 0 or
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI >= @database and TBS067.NFSCAN <> 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) > 0 or
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI >= @database and TBS067.NFSCAN = 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) > 0 or
       (select isnull(sum(M2_QTD),0) from MSL002 (nolock)
         where MSL002.M2_DAT >= @database and MSL002.M2_TIPREG = '01' and MSL002.M2_PROCOD = TBS032.PROCOD) > 0



in('30350012','0320001','0050001','40040012','0080041','0031006','30350016','40480002','0030016','0320002','0051088','0050312','0040534','50320031','0050166',
'30130008','0040674','131317','0050511','30350013','131316','50040001','0040980','0050130','10270035','0051036','0050474','717223','131319','0020014',
'0050210','40480003','40020003','70450014','0030165','40260017','0080037','0040184','40480001','0240007','0220002','50010026','0040490','1640054',
'0040304','40340004','917','7981760','161529','50250005','30130009')

--select distinct ESTLOC from TBS032 (nolock)

--select * from TBS013 (nolock)

--select NFEUSUEFE from TBS059 (nolock)

--select NFEUSUEFE,subString(TBS059.NFEUSUEFE,7,4)+subString(TBS059.NFEUSUEFE,4,2)+subString(TBS059.NFEUSUEFE,1,2),* from TBS059 (nolock) where subString(TBS059.NFEUSUEFE,7,4)+subString(TBS059.NFEUSUEFE,4,2)+subString(TBS059.NFEUSUEFE,1,2) between '20121201' and '20121231'

select * from TBS051 (nolock) where PROCOD = '1400355'

select M2_PROCOD,
       sum(M2_QTD),
       count(*)
  from MSL002 (nolock)
 where M2_DAT between '20130126' and '20130128' and M2_TIPREG = '01' and M2_PROCOD = '21380018'
 group by M2_PROCOD

select M2_TIPREG,M2_QTD,* from MSL002 (nolock) where M2_DAT between '20120701' and '20121231' and M2_PROCOD = '40040012'

select M2_PROCOD,
       sum(M2_QTD),
       count(*)
  from MSL002 (nolock)
 where M2_DAT between '20130126' and '20130128' and M2_PROCOD = '21380018'
 group by M2_PROCOD

select M2_TIPREG,M2_QTD,* from MSL002 (nolock) where M2_DAT between '20120701' and '20121231' and M2_PROCOD = '466001'

select * from TBS010 (nolock) where PROCODBAR4 = '466001'


declare @datai char(8),@dataf char(8)

set @datai = '20130101'
set @dataf = '20130630'

select TBS032.PROCOD as 'produto',
       TBS032.ESTQTDATU as 'saldo-atual',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where TBS0371.PROCOD = TBS032.PROCOD and TBS033.TMVTIP = 'E') as 'mov-entrada',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where TBS0371.PROCOD = TBS032.PROCOD and TBS033.TMVTIP = 'S') as 'mov-saida',
       (select isnull(sum(TBS049.MDSQTD * TBS049.MDSQTDEMB),0)
          from TBS049 (nolock)
         where TBS049.PROCOD = TBS032.PROCOD and TBS049.MDSTIP = 'E') as 'manutencao-entrada',
       (select isnull(sum(TBS049.MDSQTD * TBS049.MDSQTDEMB),0)
          from TBS049 (nolock)
         where TBS049.PROCOD = TBS032.PROCOD and TBS049.MDSTIP = 'S') as 'manutencao-saida',
       (select isnull(sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB),0)
          from TBS0591 (nolock) join TBS059 (nolock) on TBS059.NFEEMPCOD = TBS0591.NFEEMPCOD and TBS059.NFETIP = TBS0591.NFETIP and
                                                        TBS059.NFENUM = TBS0591.NFENUM and TBS059.NFECOD = TBS0591.NFECOD and
                                                        TBS059.SEREMPCOD = TBS0591.SEREMPCOD and TBS059.SERCOD = TBS0591.SERCOD
         where subString(TBS059.NFEUSUEFE,7,4)+subString(TBS059.NFEUSUEFE,4,2)+subString(TBS059.NFEUSUEFE,1,2) between @datai and @dataf and
               TBS0591.NFEMOVEST = 'S' and TBS0591.PROCOD = TBS032.PROCOD) as 'nfe-entrada',
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between @datai and @dataf and TBS067.NFSCAN <> 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) as 'nfs-saida',
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between @datai and @dataf and TBS067.NFSCAN = 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) as 'nfs-saida-cancelada',
       (select isnull(sum(M2_QTD),0) from MSL002 (nolock)
         where MSL002.M2_DAT between @datai and @dataf and MSL002.M2_TIPREG = '01' and MSL002.M2_PROCOD = TBS032.PROCOD) as 'vendas-gz'
  from TBS032 (nolock) where TBS032.PROCOD = '0053821'
 group by TBS032.PROCOD ,TBS032.ESTQTDATU
having (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where TBS0371.PROCOD = TBS032.PROCOD and TBS033.TMVTIP = 'E') > 0 or
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where TBS0371.PROCOD = TBS032.PROCOD and TBS033.TMVTIP = 'S') > 0 or
       (select isnull(sum(TBS049.MDSQTD * TBS049.MDSQTDEMB),0)
          from TBS049 (nolock)
         where TBS049.PROCOD = TBS032.PROCOD and TBS049.MDSTIP = 'E') > 0 or
       (select isnull(sum(TBS049.MDSQTD * TBS049.MDSQTDEMB),0)
          from TBS049 (nolock)
         where TBS049.PROCOD = TBS032.PROCOD and TBS049.MDSTIP = 'S') > 0 or
       (select isnull(sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB),0)
          from TBS0591 (nolock) join TBS059 (nolock) on TBS059.NFEEMPCOD = TBS0591.NFEEMPCOD and TBS059.NFETIP = TBS0591.NFETIP and
                                                        TBS059.NFENUM = TBS0591.NFENUM and TBS059.NFECOD = TBS0591.NFECOD and
                                                        TBS059.SEREMPCOD = TBS0591.SEREMPCOD and TBS059.SERCOD = TBS0591.SERCOD
         where subString(TBS059.NFEUSUEFE,7,4)+subString(TBS059.NFEUSUEFE,4,2)+subString(TBS059.NFEUSUEFE,1,2) between @datai and @dataf and TBS0591.NFEMOVEST = 'S'
               and TBS0591.PROCOD = TBS032.PROCOD) > 0 or
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between @datai and @dataf and TBS067.NFSCAN <> 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) > 0 or
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between @datai and @dataf and TBS067.NFSCAN = 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD) > 0 or
       (select isnull(sum(M2_QTD),0) from MSL002 (nolock)
         where MSL002.M2_DAT between @datai and @dataf and MSL002.M2_TIPREG = '01' and MSL002.M2_PROCOD = TBS032.PROCOD) > 0