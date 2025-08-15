select TBS067.NFSNUM,TBS067.NFSDATEMI
  from TBS067 (nolock) left join TBS0672 (nolock) on TBS067.SNESER=TBS0672.SNESER and TBS067.NFSNUM=TBS0672.NFSNUM
                       right join TBS055 (nolock) on TBS055.PDVNUM=TBS0672.NFSPDVNUM
 where TBS067.CPGCOD<>TBS055.CPGCOD
 group by TBS067.NFSNUM,TBS067.NFSDATEMI
 order by TBS067.NFSDATEMI desc

select * from TBS0672 (nolock)
select * from TBS0673 (nolock)


select TBS067.NFSNUM,TBS067.NFSDATEMI
  from TBS067 (nolock) left join TBS0672 (nolock) on TBS067.SNESER=TBS0672.SNESER and TBS067.NFSNUM=TBS0672.NFSNUM
                       right join TBS055 (nolock) on TBS055.PDVNUM=TBS0672.NFSPDVNUM
 where TBS067.CPGCOD<>TBS055.CPGCOD
 group by TBS067.NFSNUM,TBS067.NFSDATEMI
 order by TBS067.NFSDATEMI desc

select top 1 TBS067.NFSDATEMI,TBS0672.NFSNUM,TBS0672.SNESER,TBS067.VENCOD,(select VENNOM from TBS004 (nolock) where TBS004.VENCOD=TBS067.VENCOD)
  from TBS0672 (nolock) right join TBS067 (nolock) on TBS067.SNESER=TBS0672.SNESER and TBS067.NFSNUM=TBS0672.NFSNUM
 where NFSDATEMI >= '20140101'


select * from TBS067 (nolock)


select TBS067.NFSDATEMI as emissao,
       TBS067.NFSNUM as nf,
       TBS067.SNESER as serie,
       TBS067.NFSCLICOD as codCliente,
       TBS067.NFSCLINOM as nomeCliente,
       isnull((select CLIBLQTRN from TBS002 (nolock) where TBS002.CLICOD=TBS067.NFSCLICOD),'') as bloqueado,
       isnull((select convert(datetime,subString(CLIUSUALT,7,4)+subString(CLIUSUALT,4,2)+subString(CLIUSUALT,1,2),112) from TBS002 (nolock) where TBS002.CLICOD=TBS067.NFSCLICOD),'17530101') as alterado,
       TBS067.VENCOD as codVendedor,
       (select VENNOM from TBS004 (nolock) where TBS004.VENCOD=TBS067.VENCOD) as nomeVendedor,
       TBS067.NFSUSUALT as alteracao,
       TBS067.CPGCOD as condicaoNF,
       isnull((select CPGCOND from TBS008 (nolock) where TBS008.CPGCOD=TBS067.CPGCOD),'') as descricaoNF,
       isnull((select top 1 NFSPDVNUM from TBS0672 (nolock) where TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM),0) as pedido,
       isnull((select PDVDATCAD from TBS055 (nolock) where TBS055.PDVNUM=(select top 1 NFSPDVNUM from TBS0672 (nolock) where TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM)),0) as dataPV,
       isnull((select CPGCOD from TBS055 (nolock) where TBS055.PDVNUM=(select top 1 NFSPDVNUM from TBS0672 (nolock) where TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM)),0) as condicaoPV,
       isnull((select CPGCOND from TBS008 (nolock) where TBS008.CPGCOD=(select CPGCOD from TBS055 (nolock) where TBS055.PDVNUM=(select top 1 NFSPDVNUM from TBS0672 (nolock) where TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM))),'') as descricaoPV
  from TBS067 (nolock)
 where TBS067.NFSDATEMI >= '20140101' and TBS067.NFSCAN<>'S' and TBS067.NFSUSUALT<>'' and
       isnull((select CLIBLQTRN from TBS002 (nolock) where TBS002.CLICOD=TBS067.NFSCLICOD),'')='S' and
       isnull((select PDVDATCAD from TBS055 (nolock) where TBS055.PDVNUM=(select top 1 NFSPDVNUM from TBS0672 (nolock) where TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM)),0) >= isnull((select convert(datetime,subString(CLIUSUALT,7,4)+subString(CLIUSUALT,4,2)+subString(CLIUSUALT,1,2),112) from TBS002 (nolock) where TBS002.CLICOD=TBS067.NFSCLICOD),'17530101')
 order by emissao
      
select NFSNUM,SNESER,NFSUSUALT from TBS067 (nolock) where NFSDATEMI >= '20150101' order by NFSDATEMI desc


select convert(datetime,subString('22/09/2015 08:29:58 DANIELE',7,4)+subString('22/09/2015 08:29:58 DANIELE',4,2)+subString('22/09/2015 08:29:58 DANIELE',1,2),112)

select subString('22/09/2015 08:29:58 DANIELE',6,4)+subString('22/09/2015 08:29:58 DANIELE',4,2)+subString('22/09/2015 08:29:58 DANIELE',1,2)

select CLIUSUALT from TBS002 (nolock) where CLICOD=206