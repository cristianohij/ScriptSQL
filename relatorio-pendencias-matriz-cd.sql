    select PED.PROCOD,PRO.PRODES,PRO.PROUM1,SUM(PED.PRPQTD*PED.PRPQTDEMB),EST.ESTQTDATU-EST.ESTQTDRES as 'est.local',CD.ESTQTDATU-CD.ESTQTDRES as 'est.CD'
        from SIBD.dbo.TBS058 PED (noLock)
             join SIBD.dbo.TBS010 PRO (noLock) on PRO.PROCOD=PED.PROCOD
             join SIBD.dbo.TBS032 EST (noLock) on EST.PROCOD=PED.PROCOD and EST.ESTLOC=1
             join SRVCD.SIBD.dbo.TBS032 CD on CD.PROCOD=PED.PROCOD and CD.ESTLOC=1
       where PED.PRPSIT='P' and PRPESTLOC=1 and (EST.ESTQTDATU-EST.ESTQTDRES > 0 or CD.ESTQTDATU-CD.ESTQTDRES > 0)
       group by PED.PROCOD,PRO.PROUM1,PRO.PRODES,EST.ESTQTDATU,EST.ESTQTDRES,CD.ESTQTDATU,CD.ESTQTDRES
    end

select * from TBS058 (nolock) where PRPSIT='P'


select top 1 * from TBS058 (nolock)

drop view PendenciasVersusEstoquesDisponiveis

create view PendenciasVersusEstoquesDisponiveis as
   select PROCOD as 'CodigoDoProduto',
          isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS058.PROCOD),'') as 'DescricaoDoProduto',
          isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS058.PROCOD),'') as 'UnidadeDeMedida',
          --case PRPQTDEMB when 1 then PRPUNI else isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS058.PROCOD),'') end as 'UnidadeDeMedida',
          isnull((select rtrim(MARNOM)+' ('+Ltrim(str(MARCOD,4))+')' from TBS010 (nolock) where TBS010.PROCOD=TBS058.PROCOD),'') as 'MarcaDoProduto',
          --PRPMARNOM+' ('+Ltrim(str(PRPMARCOD,4))+')' as 'MarcaDoProduto',
          sum(PRPQTD*PRPQTDEMB) as 'QuantidadePendente',
          isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock)
                   where TBS032.PROCOD=TBS058.PROCOD and ESTLOC=1 and ESTQTDATU-ESTQTDRES>0),0) as 'EstoqueTanbyMatriz',
          isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock)
                   where TBS032.PROCOD=TBS058.PROCOD and ESTLOC=2 and ESTQTDATU-ESTQTDRES>0),0) as 'EstTanbyMatrizLoja',
          isnull((select ESTQTDATU-ESTQTDRES from TANBYCD.SIBD.dbo.TBS032 as T32CD (nolock)
                   where T32CD.PROCOD=TBS058.PROCOD and ESTLOC=1 and ESTQTDATU-ESTQTDRES>0),0) as 'EstoqueTanbyCD'
     from TBS058 (nolock)
    where PRPSIT='P' and PRPESTLOC=1
    group by PROCOD

select * from PendenciasVersusEstoquesDisponiveis (nolock) where EstoqueTanbyMatriz>0 or EstTanbyMatrizLoja>0 or EstoqueTanbyCD>0

select * from PendenciasVersusEstoquesDisponiveis
 where MarcaDoProduto between @marca and case when @nomeDaMarca='' then 'Z' else @nomeDaMarca end and
       CodigoDoProduto between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       EstoqueTanbyMatriz>0 or EstTanbyMatrizLoja>0 or EstoqueTanbyCD>0
 order by MarcaDoProduto


create view PENDENCIAS2 as
   select PROCOD as 'CodigoDoProduto',
          isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS058.PROCOD),'') as 'DescricaoDoProduto',
          isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS058.PROCOD),'') as 'UnidadeDeMedida',
          sum(PRPQTD*PRPQTDEMB) as 'QuantidadePendente',
          isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock)
                   where TBS032.PROCOD=TBS058.PROCOD and ESTLOC=1),0) as 'EstoqueTanbyMatriz',
          isnull((select ESTQTDATU-ESTQTDRES from TANBYCD.SIBD.dbo.TBS032 as T32CD (nolock)
                   where T32CD.PROCOD=TBS058.PROCOD and ESTLOC=1),0) as 'EstoqueTanbyCD'
     from TBS058 (nolock) where PRPSIT='P' and PRPESTLOC=1
    group by PROCOD
   having isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock) where TBS032.PROCOD=TBS058.PROCOD and ESTLOC=1),0)>0,
          isnull((select ESTQTDATU-ESTQTDRES from TANBYCD.SIBD.dbo.TBS032 as T32CD (nolock) where T32CD.PROCOD=TBS058.PROCOD and ESTLOC=1),0)>0


create view PENDENCIAS3 as
   select TBS058.PROCOD as 'CodigoDoProduto',
          isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS058.PROCOD),'') as 'DescricaoDoProduto',
          isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS058.PROCOD),'') as 'UnidadeDeMedida',
          sum(PRPQTD*PRPQTDEMB) as 'QuantidadePendente',
          isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock)
                   where TBS032.PROCOD=TBS058.PROCOD and ESTLOC=1),0) as 'EstoqueTanbyMatriz',
          isnull((select ESTQTDATU-ESTQTDRES from TANBYCD.SIBD.dbo.TBS032 as T32CD (nolock)
                   where T32CD.PROCOD=TBS058.PROCOD and ESTLOC=1),0) as 'EstoqueTanbyCD'
     from TBS058 (nolock)
             left join TBS032 as T32LOC (nolock) on T32LOC.PROCOD=TBS058.PROCOD and T32LOC.ESTLOC=1 and T32LOC.ESTQTDATU-T32LOC.ESTQTDRES>0
             left join TANBYCD.SIBD.dbo.TBS032 as T32CD (nolock) on T32CD.PROCOD=TBS058.PROCOD and T32CD.ESTLOC=1 and T32CD.ESTQTDATU-T32CD.ESTQTDRES>0
    where PRPSIT='P' and PRPESTLOC=1
    group by TBS058.PROCOD
