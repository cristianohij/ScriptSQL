select *
  from TBS010 with (nolock)
 where PROCOD='3252445'

select *
  from TBS023 with (nolock)
  
select PROCLAFIS
       ,*
  from TBS010 with (nolock)
 where PROCLAFIS='47032100'

select *
       ,(select convert(varchar(15),elemento)
          from fSplit(LOGATTDES,':')
         where id=2) as 'codigo'
  from TBS035 with (nolock)
 where LOGTAB='TBS045'
       and LOGDAT >= '20220101'
       and LOGROTDES='TRANSACAO'
	   and LOGATTDES Like('%QUANTIDADE')
	   and LOGVALANT < LOGVALATU

select *
  from TBS045 with (nolock)
 where PDCID=185938
 
select top(1) *
  from TBS0592 with (nolock)
 where NFETIPPED='C'
 order by NFEATEDAT desc



select LOGDAT
       ,LOGHOR
	   ,LOGUSU
	   ,LOGID
	   ,LOGVALANT
	   ,LOGVALATU
       ,(select convert(varchar(15),elemento)
          from fSplit(LOGATTDES,':')
         where id=2) as 'codigo'
  into #logped		 
  from TBS035 with (nolock)
 where LOGTAB='TBS045'
       and LOGDAT >= '20220101'
       and LOGROT='TTBS045'
	   and LOGATT='PDCQTD'
	   and LOGVALANT < LOGVALATU

drop table #pedidos

select pc.PDCID
       ,pc.PDCNUM
       ,pc.FORCOD
	   ,pc.PDCDATCAD
	   ,pd.PDCITE
	   ,pd.PROCOD
	   ,pd.PDCDES
       ,pd.PDCQTD
       ,pd.PDCQTDEMB
  into #pedidos
  from TBS045 pc with (nolock)
 inner join TBS0451 pd with (nolock)
    on pd.PDCNUM=pc.PDCNUM
 where pc.PDCDATCAD >= '20220101'
       and exists(
	                select 'ex'
					  from TBS0592 nf with (nolock)
					 where nf.NFETIP='N'
					       and nf.NFETIPPED='C'
						   and nf.NFEPEDNUM=pd.PDCNUM
						   and nf.NFEPEDITE=pd.PDCITE
	             )
       and exists(select 'ex' 
	                from #logped l
				   where l.LOGID=pc.PDCID
				         and l.codigo=pd.PROCOD
	             )
  
select top(1) *
  from TBS0451 with (nolock)

select *
  from TBS0592 with (nolock)
 where NFENUM=176098
       and NFECOD=36

drop table #notas

select c.NFETIP
       ,c.NFENUM
       ,c.NFECOD
       ,c.NFENOM
       ,c.NFEDATEFE
       ,c.NFEHOREFE
       ,i.NFEITE
       ,i.PROCOD
       ,i.NFEQTD
       ,i.NFEQTDEMB
       ,l.NFEPEDNUM
       ,l.NFEPEDITE
       ,l.NFEATEQTD
  into #notas
  from TBS059 c with (nolock) 
 inner join TBS0591 i with (nolock)
    on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
 inner join TBS0592 l with (nolock)    
    on l.NFEEMPCOD=c.NFEEMPCOD and l.NFETIP=c.NFETIP and l.NFENUM=c.NFENUM and l.NFECOD=c.NFECOD and l.SEREMPCOD=c.SEREMPCOD -- and l.SERCOD=c.SERCOD and l.NFETIP='N' and l.NFETIPPED='C'
 where c.NFECAN='N'
       and l.NFETIP='N'
       and l.NFETIPPED='C'
       and exists (
                     select 'e'
                       from #pedidos p
                      where l.NFETIPPED='C'
                           and p.PDCNUM=l.NFEPEDNUM
						   and p.PDCITE=l.NFEPEDITE
                           and c.NFEDATEFE >= p.PDCDATCAD
                  )

select top(1) *
  from #logped

select *
  from #pedidos
 where PROCOD='16580018'

select *
  from #notas
 where PROCOD='16580018'

select count(*)
  from #notas

select *
  from #logped l
 inner join #pedidos p
    on p.PDCID=l.LOGID and p.PROCOD=l.codigo
 inner join #notas n
    on n.NFEITE=p.PDCITE and n.PROCOD=p.PROCOD
 where l.LOGDAT=n.NFEDATEFE
       and l.LOGVALATU=n.NFEQTD

select *
  from #pedidos p
 inner join #notas n
    on n.NFEPEDNUM=p.PDCNUM and n.NFEPEDITE=p.PDCITE and n.PROCOD=p.PROCOD
 where p.PDCQTD * p.PDCQTDEMB < n.NFEQTD
       --and p.PROCOD='16580018'

-- produtos recebidos e pedidos de compras atendidos

select c.NFETIP
       ,c.NFENUM
       ,c.NFECOD
       ,c.NFENOM
       ,c.NFEDATEFE
       ,c.NFEHOREFE
       ,i.NFEITE
       ,i.PROCOD
       ,i.NFEQTD
       ,i.NFEQTDEMB
       ,l.NFEPEDNUM
       ,l.NFEPEDITE
       ,l.NFEATEQTD
  from TBS059 c with (nolock) 
 inner join TBS0591 i with (nolock)
    on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
 inner join TBS0592 l with (nolock)    
    on l.NFEEMPCOD=c.NFEEMPCOD and l.NFETIP=c.NFETIP and l.NFENUM=c.NFENUM and l.NFECOD=c.NFECOD and l.SEREMPCOD=c.SEREMPCOD -- and l.SERCOD=c.SERCOD and l.NFETIP='N' and l.NFETIPPED='C'
 where c.NFEDATEFE >= '20220101'
       and c.NFECAN='N'
       and l.NFETIP='N'
       and l.NFETIPPED='C'

select c.NFETIP
       ,c.NFENUM
       ,c.NFECOD
       ,c.NFENOM
       ,c.NFEDATEFE
       ,c.NFEHOREFE
       ,i.NFEITE
       ,i.PROCOD
       ,i.NFEQTD
       ,i.NFEQTDEMB
       ,(select sum(p.NFEATEQTD) 
           from TBS0592 p with (nolock)
          where p.NFEEMPCOD=c.NFEEMPCOD
                and p.NFETIP=c.NFETIP
                and p.NFENUM=c.NFENUM
                and p.NFECOD=c.NFECOD
                and p.SEREMPCOD=c.SEREMPCOD
                and p.NFEITE=i.NFEITE
                --and p.NFETIP='N'
                and p.NFETIPPED='C'
          )
  from TBS059 c with (nolock) 
 inner join TBS0591 i with (nolock)
    on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
 where c.NFEDATEFE >= '20220101'
       and c.NFETIP='N'
       and c.NFECAN='N'

drop table #atendidos

select c.NFENUM
       ,c.NFECOD
       ,i.PROCOD
       ,sum(i.NFEQTD) as 'recebido'
       ,sum(l.NFEATEQTD * l.NFEPEDEMB) as 'atendido'
  into #atendidos
  from TBS059 c with (nolock) 
 inner join TBS0591 i with (nolock)
    on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
 inner join TBS0592 l with (nolock)    
    on l.NFEEMPCOD=c.NFEEMPCOD and l.NFETIP=c.NFETIP and l.NFENUM=c.NFENUM and l.NFECOD=c.NFECOD and l.SEREMPCOD=c.SEREMPCOD and l.SERCOD=c.SERCOD and l.NFEITE=i.NFEITE
 where c.NFEDATEFE >= '20220101'
       and c.NFETIP='N'
       and c.NFECAN='N'
       and l.NFETIPPED='C'
 group by c.NFENUM
       ,c.NFECOD
       ,i.PROCOD

select *
  from #atendidos
 where recebido > atendido

select c.NFENUM
       ,c.NFECOD
       ,i.PROCOD
       ,sum(i.NFEQTD) as 'recebido'
       ,(select sum(p.NFEATEQTD) 
           from TBS0592 p with (nolock)
          where p.NFEEMPCOD=c.NFEEMPCOD
                and p.NFETIP=c.NFETIP
                and p.NFENUM=c.NFENUM
                and p.NFECOD=c.NFECOD
                and p.SEREMPCOD=c.SEREMPCOD
                and p.NFEITE=i.NFEITE
                and p.NFETIPPED='C'
          ) as 'atendido'
  from TBS059 c with (nolock) 
 inner join TBS0591 i with (nolock)
    on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
 where c.NFEDATEFE >= '20220101'
       and c.NFETIP='N'
       and c.NFECAN='N'
 group by c.NFENUM
       ,c.NFECOD
       ,i.PROCOD

-- tabela dos produtos recebidos

select c.NFETIP
       ,c.SERCOD
       ,c.NFENUM
       ,c.NFECOD
       ,c.NFENOM
       ,c.NFEDATEFE
       ,c.NFEHOREFE
       ,i.PROCOD
       ,i.NFEDES
       ,sum(i.NFEQTD * i.NFEQTDEMB) as 'qtde_recebida'
  into #nf_recedidas
  from TBS059 c with (nolock) 
 inner join TBS0591 i with (nolock)
    on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
 where c.NFEDATEFE >= '20220101'
       and c.NFETIP='N'
       and c.NFECAN='N'
 group by c.NFETIP
          ,c.SERCOD
          ,c.NFENUM
          ,c.NFECOD
          ,c.NFENOM
          ,c.NFEDATEFE
          ,c.NFEHOREFE
          ,i.PROCOD
          ,i.NFEDES

-- tabela dos itens dos pedidos atendidos

select c.NFETIP
       ,c.SERCOD
       ,c.NFENUM
       ,c.NFECOD
       ,i.PROCOD
       ,p.NFEITE
       ,p.NFEPEDNUM
       ,p.NFEPEDITE
       ,p.NFEATEQTD * p.NFEPEDEMB as 'qtde_atendida'
  into #pc_atendidos
  from TBS059 c with (nolock) 
 inner join TBS0591 i with (nolock)
    on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD
 inner join TBS0592 p with (nolock)    
    on p.NFEEMPCOD=c.NFEEMPCOD and p.NFETIP=c.NFETIP and p.NFENUM=c.NFENUM and p.NFECOD=c.NFECOD and p.SEREMPCOD=c.SEREMPCOD and p.SERCOD=c.SERCOD and p.NFEITE=i.NFEITE
 where c.NFEDATEFE >= '20220101'
       and c.NFETIP='N'
       and c.NFECAN='N'
       and p.NFETIPPED='C'
 
select *
  from #pc_atendidos

select top(1) *
  from #nf_recedidas

select *
       ,(select sum(qtde_atendida)
           from #pc_atendidos p
          where p.NFETIP=n.NFETIP
                and p.SERCOD=n.SERCOD
                and p.NFENUM=n.NFENUM
                and p.NFECOD=n.NFECOD
                and p.PROCOD=n.PROCOD
         ) as 'qtde_atendida'
  into #analise
  from #nf_recedidas n

select *
  from #analise
 where qtde_recebida > qtde_atendida

-- log das alterações dos pedidos de compras

select LOGDAT
       ,LOGHOR
	     ,LOGUSU
	     ,LOGID
	     ,LOGVALANT
	     ,LOGVALATU
       ,(select convert(varchar(15),elemento)
          from fSplit(LOGATTDES,':')
         where id=2) as 'codigo'
  into #pc_alterados
  from TBS035 with (nolock)
 where LOGTAB='TBS045'
       and LOGDAT >= '20220101'
       and LOGROT='TTBS045'
	     and LOGATT='PDCQTD'
	     and LOGVALANT <> LOGVALATU

select top(1) *
  from #pc_alterados

select top(1) *
  from #nf_recedidas

