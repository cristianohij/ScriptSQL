-- orçamento

-- contribuinte do ICMS

update TBS043
   set ORCCONICMS='S'
  from TBS043 with (nolock)
       inner join TBS002 with (nolock)
	   on TBS043.ORCCLI=TBS002.CLICOD
 where CLIINDIE=1
       and ORCCONICMS=''

-- não contribuinte do ICMS

update TBS043
   set ORCCONICMS='N'
  from TBS043 with (nolock)
       inner join TBS002 with (nolock)
	   on TBS043.ORCCLI=TBS002.CLICOD
 where CLIINDIE=9
       and ORCCONICMS=''
  
-- CST

update TBS0431
   set TBS0431.ORCPROCST=TBS010.PROSTBA+PROSTBB
  from TBS0431 with (nolock)
       inner join TBS010 with (nolock)
	   on TBS0431.PROCOD=TBS010.PROCOD
 where ORCPROCST=''

-- alíquota FCP

update TBS0431
   set TBS0431.ORCPERFCP=2
  from TBS0431 with (nolock)
       inner join TBS043 with (nolock)
	   on TBS0431.ORCNUM=TBS043.ORCNUM
  where TBS043.ORCESTDES='RJ'
        and right(rtrim(ORCPROCST),2) in('10','30','60','70')
		and TBS0431.ORCPERFCP=0

-- pedidos de vendas

-- contribuinte do ICMS

update TBS055
   set PDVCONICMS='S'
  from TBS055 with (nolock)
       inner join TBS002 with (nolock)
	   on TBS055.PDVCLICOD=TBS002.CLICOD
 where CLIINDIE=1
       and PDVCONICMS=''

-- não contribuinte do ICMS

update TBS055
   set PDVCONICMS='N'
  from TBS055 with (nolock)
       inner join TBS002 with (nolock)
	   on TBS055.PDVCLICOD=TBS002.CLICOD
 where CLIINDIE=9
       and PDVCONICMS=''

  
-- CST

update TBS0551
   set TBS0551.PDVPROCST=TBS010.PROSTBA+PROSTBB
  from TBS0551 with (nolock)
       inner join TBS010 with (nolock)
	   on TBS0551.PROCOD=TBS010.PROCOD
 where TBS0551.PDVPROCST=''

-- alíquota FCP

update TBS0551
   set TBS0551.PDVPERFCP=2
  from TBS0551 with (nolock)
       inner join TBS055 with (nolock)
	   on TBS0551.PDVNUM=TBS055.PDVNUM
  where TBS055.PDVESTDES='RJ'
        and right(rtrim(PDVPROCST),2) in('10','30','60','70')
		and TBS0551.PDVPERFCP=0


-- notas fiscais

-- contribuinte do ICMS

update TBS067
   set NFSCONICMS='S'
  from TBS067 with (nolock)
       inner join TBS002 with (nolock)
	   on TBS067.NFSCLICOD=TBS002.CLICOD
 where CLIINDIE=1
       and NFSCONICMS=''

-- não contribuinte do ICMS

update TBS067
   set NFSCONICMS='N'
  from TBS067 with (nolock)
       inner join TBS002 with (nolock)
	   on TBS067.NFSCLICOD=TBS002.CLICOD
 where CLIINDIE=9
       and NFSCONICMS=''

  
-- CST

update TBS0671
   set TBS0671.NFSPROCST=TBS010.PROSTBA+PROSTBB
  from TBS0671 with (nolock)
       inner join TBS010 with (nolock)
	   on TBS0671.PROCOD=TBS010.PROCOD
 where TBS0671.NFSPROCST=''

-- alíquota FCP

update TBS0671
   set TBS0671.NFSPERFCP=2
  from TBS0671 with (nolock)
       inner join TBS067 with (nolock)
	   on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
  where TBS067.UFESIG='RJ'
        and right(rtrim(NFSPROCST),2) in('10','30','60','70')
		and TBS0671.NFSPERFCP=0
