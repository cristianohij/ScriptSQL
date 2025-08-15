-- relatorio do inventario

select TBS0371.PROCOD as 'codigo-produto',
       (select TBS010.PRODES from TBS010 (nolock) where TBS010.PROEMPCOD = TBS0371.PROEMPCOD and TBS010.PROCOD = TBS0371.PROCOD) as 'descricao-produto',
       (select TBS010.PROUM1 from TBS010 (nolock) where TBS010.PROEMPCOD = TBS0371.PROEMPCOD and TBS010.PROCOD = TBS0371.PROCOD) as 'unidade',
       isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0) as 'quantidade',
       isnull((select TBS031.TDPCUSBAS from TBS031 (nolock) where TBS031.TDPEMPCOD = TBS0371.PROEMPCOD and TBS031.TDPPROCOD = TBS0371.PROCOD),0) as 'preco-custo',
       isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0) *
       isnull((select TBS031.TDPCUSBAS from TBS031 (nolock) where TBS031.TDPEMPCOD = TBS0371.PROEMPCOD and TBS031.TDPPROCOD = TBS0371.PROCOD),0) as 'valor-total'
  from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                        join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
 where convert(char(10),TBS037.MVIDATLAN,112) between '20130125' and '20130125' and TBS033.TMVTIP = 'S'
 group by TBS0371.PROEMPCOD,TBS0371.PROCOD

-- rodar este

select TBS032.PROCOD as 'produto',
       (select TBS010.PRODES from TBS010 (nolock) where TBS010.PROEMPCOD = TBS032.PROEMPCOD and TBS010.PROCOD = TBS032.PROCOD) as 'descricao-produto',
       (select TBS010.PROUM1 from TBS010 (nolock) where TBS010.PROEMPCOD = TBS032.PROEMPCOD and TBS010.PROCOD = TBS032.PROCOD) as 'unidade',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(10),TBS037.MVIDATEFE,112) between '20130216' and '20130218' and TBS033.TMVTIP = 'E' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCDES = TBS032.ESTLOC) as 'entrada',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(10),TBS037.MVIDATEFE,112) between '20130216' and '20130218' and TBS033.TMVTIP = 'S' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCORI = TBS032.ESTLOC) as 'saida',
       isnull((select TBS031.TDPCUSBAS from TBS031 (nolock) where TBS031.TDPEMPCOD = TBS032.PROEMPCOD and TBS031.TDPPROCOD = TBS032.PROCOD),0) as 'preco-custo'
  from TBS032 (nolock)
 where ESTLOC = 2
 group by TBS032.PROEMPCOD,TBS032.ESTLOC,TBS032.PROCOD
having (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(10),TBS037.MVIDATEFE,112) between '20130216' and '20130218' and TBS033.TMVTIP = 'E' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCDES = TBS032.ESTLOC) > 0 or
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(10),TBS037.MVIDATEFE,112) between '20130216' and '20130218' and TBS033.TMVTIP = 'S' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCORI = TBS032.ESTLOC) > 0


declare @datade char(8), @dataate char(8)
set @datade = '20130223'
set @dataate = '20130306'

select TBS032.PROCOD as 'produto',
       (select TBS010.PRODES from TBS010 (nolock) where TBS010.PROEMPCOD = TBS032.PROEMPCOD and TBS010.PROCOD = TBS032.PROCOD) as 'descricao-produto',
       (select TBS010.PROUM1 from TBS010 (nolock) where TBS010.PROEMPCOD = TBS032.PROEMPCOD and TBS010.PROCOD = TBS032.PROCOD) as 'unidade',
       TBS032.ESTLOC as 'local-estoque',
       TBS032.ESTQTDATU as 'qtde-estoque',
       TBS032.ESTQTDRES as 'qtde-reservada',
       TBS032.ESTQTDATU - TBS032.ESTQTDRES as 'qtde-disponivel',
       TBS032.ESTQTDPEN as 'qtde-pendente',
       TBS032.ESTQTDCMP as 'qtde-comprada',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(8),TBS037.MVIDATEFE,112) between @datade and @dataate and TBS033.TMVTIP = 'E' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCDES = TBS032.ESTLOC) as 'mov-entrada',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(10),TBS037.MVIDATEFE,112) between @datade and @dataate and TBS033.TMVTIP = 'S' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCORI = TBS032.ESTLOC) as 'mov-saida',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(8),TBS037.MVIDATEFE,112) between @datade and @dataate and TBS033.TMVINFTRA = 'S' and --TBS033.TMVTIP = 'E' and TBS033.TMVINFTRA = 'S' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCDES = TBS032.ESTLOC) as 'transf-entrada',
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(8),TBS037.MVIDATEFE,112) between @datade and @dataate and TBS033.TMVINFTRA = 'S' and --TBS033.TMVTIP = 'S' and TBS033.TMVINFTRA = 'S' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCORI = TBS032.ESTLOC) as 'transf-saida',
       (select isnull(sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB),0)
          from TBS0591 (nolock) join TBS059 (nolock) on TBS059.NFEEMPCOD = TBS0591.NFEEMPCOD and TBS059.NFETIP = TBS0591.NFETIP and
                                                        TBS059.NFENUM = TBS0591.NFENUM and TBS059.NFECOD = TBS0591.NFECOD and
                                                        TBS059.SEREMPCOD = TBS0591.SEREMPCOD and TBS059.SERCOD = TBS0591.SERCOD
         where subString(TBS059.NFEUSUEFE,7,4)+subString(TBS059.NFEUSUEFE,4,2)+subString(TBS059.NFEUSUEFE,1,2) between @datade and @dataate and
               TBS0591.NFEMOVEST = 'S' and TBS0591.PROCOD = TBS032.PROCOD and TBS0591.LESCOD = TBS032.ESTLOC) as 'nfe-entrada',
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between @datade and @dataate and TBS067.NFSCAN <> 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD and
               TBS0671.LESCOD = TBS032.ESTLOC) as 'nfs-saida',
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between @datade and @dataate and TBS067.NFSCAN = 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD and
               TBS0671.LESCOD = TBS032.ESTLOC) as 'nfs-saida-cancelada',
       case ESTLOC
          when 2 then (select isnull(sum(M2_QTD),0) from MSL002 (nolock)
                        where MSL002.M2_DAT between @datade and @dataate and MSL002.M2_TIPREG = '01' and M2_REGCAN <> 'T' and MSL002.M2_PROCOD = TBS032.PROCOD)
          else 0
       end
       as 'vendas-gz'
  from TBS032 (nolock)
 where ESTLOC <= 2 and PROCOD = '4250320'
 group by TBS032.PROEMPCOD,TBS032.ESTLOC,TBS032.PROCOD,TBS032.ESTQTDATU,TBS032.ESTQTDRES,TBS032.ESTQTDPEN,TBS032.ESTQTDCMP
having (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(8),TBS037.MVIDATEFE,112) between @datade and @dataate and TBS033.TMVTIP = 'E' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCDES = TBS032.ESTLOC) > 0 or
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(10),TBS037.MVIDATEFE,112) between @datade and @dataate and TBS033.TMVTIP = 'S' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCORI = TBS032.ESTLOC) > 0 or 
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(8),TBS037.MVIDATEFE,112) between @datade and @dataate and TBS033.TMVINFTRA = 'S' and --TBS033.TMVTIP = 'E' and TBS033.TMVINFTRA = 'S' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCORI = TBS032.ESTLOC) > 0 or
       (select isnull(sum(TBS0371.MVIQTDATD * TBS0371.MVIQTDEMB),0)
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(8),TBS037.MVIDATEFE,112) between @datade and @dataate and TBS033.TMVINFTRA = 'S' and --TBS033.TMVTIP = 'S' and TBS033.TMVINFTRA = 'S' and
               TBS0371.PROCOD = TBS032.PROCOD and TBS037.MVILOCDES = TBS032.ESTLOC) > 0 or
       (select isnull(sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB),0)
          from TBS0591 (nolock) join TBS059 (nolock) on TBS059.NFEEMPCOD = TBS0591.NFEEMPCOD and TBS059.NFETIP = TBS0591.NFETIP and
                                                        TBS059.NFENUM = TBS0591.NFENUM and TBS059.NFECOD = TBS0591.NFECOD and
                                                        TBS059.SEREMPCOD = TBS0591.SEREMPCOD and TBS059.SERCOD = TBS0591.SERCOD
         where subString(TBS059.NFEUSUEFE,7,4)+subString(TBS059.NFEUSUEFE,4,2)+subString(TBS059.NFEUSUEFE,1,2) between @datade and @dataate and
               TBS0591.NFEMOVEST = 'S' and TBS0591.PROCOD = TBS032.PROCOD and TBS0591.LESCOD = TBS032.ESTLOC) > 0 or
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between @datade and @dataate and TBS067.NFSCAN <> 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD and
               TBS0671.LESCOD = TBS032.ESTLOC) > 0 or
       (select isnull(sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between @datade and @dataate and TBS067.NFSCAN = 'S' and TBS0671.NFSMOVEST = 'S' and TBS0671.PROCOD = TBS032.PROCOD and
               TBS0671.LESCOD = TBS032.ESTLOC) > 0 or
       case ESTLOC
          when 2 then (select isnull(sum(M2_QTD),0) from MSL002 (nolock)
                        where MSL002.M2_DAT between @datade and @dataate and MSL002.M2_TIPREG = '01' and M2_REGCAN <> 'T' and MSL002.M2_PROCOD = TBS032.PROCOD)
          else 0
       end > 0


-- analises

1172824
nf 88358
cupom 158256

select * from TBS0671 (nolock) where NFSNUM = 88358 and PROCOD = '1172824'

SELECT * FROM TBS032 (NOLOCK) WHERE ESTLOC = 2 AND ESTQTDATU < 0

select * from TBS067 (nolock) where NFSDATEMI >= '20130225' and NFSTIP = 'L' and NFSCAN = 'S'

select * from TBS037 (nolock) where MVIDATEFE = '17530101' order by MVIDOC

select * from TBS0671 (nolock) where NFSNUM = 88358

select * from TBS0671 (nolock) where PROCOD = '0053937'

select * from TBS067 (nolock) where NFSNUM = 88347

select * from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
 where TBS067.NFSDATEMI >= '20130223' and TBS0671.PROCOD = '0053937'

select * from TBS032 (nolock) where PROCOD = '0040010'

select MVILOCORI,MVILOCDES,MVIQTDPED*MVIQTDEMB,TBS037.TMVCOD,TMVINFTRA,*
  from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                        join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(8),TBS037.MVIDATEFE,112) >= '20130223' and TBS0371.PROCOD = '4250320'
 order by MVILOCORI,MVILOCDES,TBS037.TMVCOD,TMVINFTRA,TBS0371.MVIDOC


select *
          from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
                                join TBS033 (nolock) on TBS033.TMVEMPCOD = TBS037.TMVEMPCOD and TBS033.TMVCOD = TBS037.TMVCOD
         where convert(char(8),TBS037.MVIDATEFE,112) >= '20130223' and TBS033.TMVTIP = 'E' and TBS033.TMVINFTRA = 'N' and
               TBS0371.PROCOD = '1640054' and MVILOCDES = 2

select isnull(sum(M2_QTD),0) from MSL002 (nolock)
 where MSL002.M2_DAT >= '20130223' and MSL002.M2_TIPREG = '01' and MSL002.M2_PROCOD = '6522903'

select * from TBS049 (nolock)

select * from TBS055 (nolock) join TBS0551 (nolock) on TBS055.PDVEMPCOD = TBS0551.PDVEMPCOD and TBS055.PDVNUM = TBS0551.PDVNUM
 where PDVDATCAD >= '20130223' and LESCOD > 1




select convert(char(10),M2_DAT,103),M2_HOR,* from MSL002 (nolock)
 where M2_TIPREG = '01' and M2_REGCAN <> 'T' and M2_PROCOD = '1640054' and
       M2_DAT between '20130225' and '20130225'
 order by M2_DAT,M2_HOR

select M2_HOR,* from MSL002 (nolock)
 where M2_TIPREG = '01' and M2_REGCAN = 'T' and M2_PROCOD = '1640054' and
       M2_DAT between '20130225' and '20130225'
 order by M2_DAT,M2_HOR

select M2_HOR,* from MSL002 (nolock)
 where M2_TIPREG = '04' and
       M2_DAT between '20130225' and '20130225'
 order by M2_DAT,M2_HOR


select M2_HOR,* from MSL002 (nolock)
 where M2_TIPREG = '01' and M2_REGCAN <> 'T' and M2_PROCOD = '1640054' and
       M2_DAT between '20130225' and '20130225'
 order by M2_DAT,M2_HOR

--select sum(M2_QTD) from MSL002 (nolock)
-- where M2_TIPREG = '01' and M2_REGCAN <> 'T' and M2_PROCOD = '1640054' and
--       M2_DAT between '20130225' and '20130225'

--select top 1 convert(char(8),LMEDATHOR,112),* from TBS051 (nolock)

select * from TBS051 (nolock)
 where convert(char(8),LMEDATHOR,112) between '20130223' and '20130228' and PROCOD = '8503281' and
       LMELOCEST = 1
 order by LMEDATHOR

select LMEUNI,LMEQTDSAL,LMEQTDMOV,* from TBS051 (nolock)
 where convert(char(8),LMEDATHOR,112) between '20130225' and '20130225' and LMELOCEST = 2
 order by LMEDATHOR



select * from TBS0371 (nolock) join TBS037 (nolock) on TBS037.MVIEMPCOD = TBS0371.MVIEMPCOD and TBS037.MVIDOC = TBS0371.MVIDOC
 where PROCOD = '8503281' and (MVILOCORI = 1 or MVILOCDES = 1)


select * from TBS098 (nolock) where PROCOD = '1640054'

select ESTQTDATU,* from TBS032 (nolock) where PROCOD = '1640054'

insert into TBS098
       (SALREF,
        PROCOD,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS)
select '201302',
       PROCOD,
       sum(ESTQTDATU),
       (select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD = TBS032.PROCOD),
       1,
       (select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = TBS032.PROCOD)
  from TBS032 (nolock)
 group by PROCOD

select * from TBS010 (nolock) where PROCODBAR1 = '7897424082124'