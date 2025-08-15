select top(100) *
  from TBS1332 with (nolock)

-- Log

select convert(char(6),CFCLOGAPPDAT,112) as data
       ,count(*) as contador
       --,row_number() over(order by convert(char(6),CFCLOGAPPDAT,112))
  from TBS1332 with (nolock)
 group by convert(char(6),CFCLOGAPPDAT,112)
 order by convert(char(6),CFCLOGAPPDAT,112) desc

-- cabeçalho

select convert(char(6),CFCDATCAD,112) as data
       ,count(*) as contador
  from TBS133 with (nolock)
 where convert(char(6),CFCDATCAD,112) >= '202111'
 group by convert(char(6),CFCDATCAD,112)
 order by convert(char(6),CFCDATCAD,112) desc

-- 
select cab.[data]
       ,cab.contador as nr_notas
       ,log.contador as coletas
       ,round(convert(decimal,log.contador)/cab.contador*100,0) as porcent
  from (
select convert(char(6),CFCDATCAD,112) as data
       ,count(*) as contador
  from TBS133 with (nolock)
 where convert(char(6),CFCDATCAD,112) >= '202111'
 group by convert(char(6),CFCDATCAD,112)) cab,
(select convert(char(6),CFCLOGAPPDAT,112) as data
       ,count(*) as contador
  from TBS1332 with (nolock)
 where CFCLOGAPPITE=1
 group by convert(char(6),CFCLOGAPPDAT,112)) log
 where [cab].[data]=[log].[data]

select cab.[data]
       ,cab.contador as nr_notas
       ,log.contador as coletas
       ,round(convert(decimal,log.contador)/cab.contador*100,0) as porcent
  from (
select convert(char(6),CFCDATCAD,112) as data
       ,count(*) as contador
  from TBS133 with (nolock)
 where convert(char(6),CFCDATCAD,112) >= '202111'
 group by convert(char(6),CFCDATCAD,112)) cab,
(select convert(char(6),CFCLOGAPPDAT,112) as data
       ,count(*) as contador
  from TBS1332 with (nolock)
 where CFCLOGAPPITE=1
 group by convert(char(6),CFCLOGAPPDAT,112)) log
 where [cab].[data]=[log].[data]

select *
  from TBS133 with (nolock)
 where CFCFIN='S'
       and convert(char(6),CFCDATCAD,112) = '202206'

select *
  from TBS1331 with (nolock)
 where CFCINCVIA<>'INT'

select CFCNFENUM
       ,CFCNFECOD
  from TBS1332 with (nolock)
 where CFCLOGAPPDAT between '20221001' and '20221026'
 group by CFCNFENUM, CFCNFECOD       

select convert(char(6),CFCDATCAD,112) as data
       ,count(*) as nr_notas
       ,count(i.CFCITESEQ) as qtde_itens
       --,isnull((select count(*)
                  --from TBS1331 i with (nolock)
                 --where i.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                       --and i.CFCNFETIP=c.CFCNFETIP
                       --and i.CFCNFENUM=c.CFCNFENUM
                       --and i.CFCSERCOD=c.CFCSERCOD
                       --and i.CFCNFECOD=c.CFCNFECOD),0) as qtde_itens
  from TBS133 c with (nolock)
  Left join TBS1331 i with (nolock)
     on i.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                       and i.CFCNFETIP=c.CFCNFETIP
                       and i.CFCNFENUM=c.CFCNFENUM
                       and i.CFCSERCOD=c.CFCSERCOD
                       and i.CFCNFECOD=c.CFCNFECOD
 where convert(char(6),CFCDATCAD,112) >= '202111'
       and CFCFIN='S'
 group by convert(char(6),CFCDATCAD,112)

select [t].[data]
       ,count(distinct [t].[nota]+[t].[fornecedor]) as 'nr_notas'
       ,count(distinct [t].[produto]) as 'qtde_itens'
       ,count(distinct [t].[nota]+[t].[fornecedor]) as 'nr_coletas'
  from (select convert(char(6),c.CFCDATCAD,112) as 'data'
               ,c.CFCNFEEMPCOD as empresa
               ,c.CFCNFETIP as tipo
               ,c.CFCNFENUM as nota
               ,c.CFCSERCOD as serie
               ,c.CFCNFECOD as fornecedor
               ,i.CFCPROCOD as 'produto'
               ,L.CFCLOGAPPITE
          from TBS133 c with (nolock)
          Left join TBS1331 i with (nolock)
               on i.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                  and i.CFCNFETIP=c.CFCNFETIP
                  and i.CFCNFENUM=c.CFCNFENUM
                  and i.CFCSERCOD=c.CFCSERCOD
                  and i.CFCNFECOD=c.CFCNFECOD
          Left join TBS1332 L with (nolock)
               on L.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                  and L.CFCNFETIP=c.CFCNFETIP
                  and L.CFCNFENUM=c.CFCNFENUM
                  and L.CFCSERCOD=c.CFCSERCOD
                  and L.CFCNFECOD=c.CFCNFECOD
         where convert(char(6),c.CFCDATCAD,112) = '202206'
       and c.CFCFIN='S'
       and L.CFCLOGAPPITE=1) t
 group by t.[data]

select *
  from TBS133 c with (nolock)
 where not exists(select '' from TBS1332 L with (nolock) where L.CFCNFEEMPCOD=c.CFCNFEEMPCOD and L.CFCNFETIP=c.CFCNFETIP and L.CFCSERCOD=c.CFCSERCOD and L.CFCNFECOD=c.CFCNFECOD and L.CFCNFENUM=c.CFCNFENUM)  
       and convert(char(6),c.CFCDATCAD,112) = '202206'
       and c.CFCFIN='S'

-- contador de uso independente da opação realizada

select convert(char(6),CFCLOGAPPDAT,112) as data
       ,CFCLOGAPPHOS as dispovitivo
       ,count(*) as contador
       --,row_number() over(order by convert(char(6),CFCLOGAPPDAT,112))
  from TBS1332 with (nolock)
 group by convert(char(6),CFCLOGAPPDAT,112), CFCLOGAPPHOS
 order by convert(char(6),CFCLOGAPPDAT,112) desc

-- uso do app mensal

select convert(char(6),CFCLOGAPPDAT,112) as data
       ,count(*) as contador
  from TBS1332 with (nolock)
 where CFCLOGAPPITE=1
 group by convert(char(6),CFCLOGAPPDAT,112)
 order by convert(char(6),CFCLOGAPPDAT,112) desc

-- uso do app mensal por dispositivo

select convert(char(6),CFCLOGAPPDAT,112) as data
       ,CFCLOGAPPHOS as dispovitivo
       --,count(*) as contador
       ,count(distinct CFCLOGAPPDES) as contador
  from TBS1332 with (nolock)
 where CFCLOGAPPITE=1
 group by convert(char(6),CFCLOGAPPDAT,112),CFCLOGAPPHOS
 order by convert(char(6),CFCLOGAPPDAT,112) desc

select convert(char(6),c.CFCDATCAD,112) as 'data'
               ,c.CFCNFEEMPCOD as empresa
               ,c.CFCNFETIP as tipo
               ,c.CFCNFENUM as nota
               ,c.CFCSERCOD as serie
               ,c.CFCNFECOD as fornecedor
               ,i.CFCPROCOD as 'produto'
          from TBS133 c with (nolock)
          Left join TBS1331 i with (nolock)
               on i.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                  and i.CFCNFETIP=c.CFCNFETIP
                  and i.CFCNFENUM=c.CFCNFENUM
                  and i.CFCSERCOD=c.CFCSERCOD
                  and i.CFCNFECOD=c.CFCNFECOD
          full outer join TBS1332 L with (nolock)
               on c.CFCNFEEMPCOD=L.CFCNFEEMPCOD
                  and c.CFCNFETIP=L.CFCNFETIP
                  and c.CFCNFENUM=L.CFCNFENUM
                  and c.CFCSERCOD=L.CFCSERCOD
                  and c.CFCNFECOD=L.CFCNFECOD
         where convert(char(6),c.CFCDATCAD,112) = '202206'
       and c.CFCFIN='S'
       and L.CFCLOGAPPITE=1

select convert(char(6),c.CFCDATCAD,112)
       ,count(*)
       ,isnull((select 1 from TBS1331 i with (nolock) where i.CFCNFEEMPCOD=c.CFCNFEEMPCOD and i.CFCNFETIP=c.CFCNFETIP and i.CFCSERCOD=c.CFCSERCOD and i.CFCNFECOD=c.CFCNFECOD and i.CFCNFENUM=c.CFCNFENUM),0)
  from TBS133 c with (nolock)
 where convert(char(6),c.CFCDATCAD,112) = '202206'
       and c.CFCFIN='S'
 group by convert(char(6),c.CFCDATCAD,112)





select [t].[data]
       ,count(distinct [t].[nota]+[t].[fornecedor]) as 'nr_notas'
       ,count(distinct [t].[produto]) as 'qtde_itens'
       ,count(case when [t].[CFCLOGAPPITE]=1 then 1 else 0 end) as 'nr_coletas'
  from (select convert(char(6),c.CFCDATCAD,112) as 'data'
               ,c.CFCNFEEMPCOD as empresa
               ,c.CFCNFETIP as tipo
               ,c.CFCNFENUM as nota
               ,c.CFCSERCOD as serie
               ,c.CFCNFECOD as fornecedor
               ,i.CFCPROCOD as 'produto'
               ,L.CFCLOGAPPITE
          from TBS133 c with (nolock)
          Left join TBS1331 i with (nolock)
               on i.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                  and i.CFCNFETIP=c.CFCNFETIP
                  and i.CFCNFENUM=c.CFCNFENUM
                  and i.CFCSERCOD=c.CFCSERCOD
                  and i.CFCNFECOD=c.CFCNFECOD
          Left join TBS1332 L with (nolock)
               on L.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                  and L.CFCNFETIP=c.CFCNFETIP
                  and L.CFCNFENUM=c.CFCNFENUM
                  and L.CFCSERCOD=c.CFCSERCOD
                  and L.CFCNFECOD=c.CFCNFECOD
                  and L.CFCLOGAPPITE=1
         where convert(char(6),c.CFCDATCAD,112) = '202206'
       and c.CFCFIN='S') t
 group by t.[data]

-- relatório final

-- mês/ano

select Left(t.data,4)+'/'+right(t.data,2) as 'ano/mês'
       ,count(*) as 'número de notas'
       ,sum(t.coletado) as 'número de coletas'
       ,convert(smallint,convert(decimal,sum(t.coletado))/convert(decimal,count(*))*100) as 'porcentagem da coleta'
       ,sum(t.qtde_itens) as 'qtde de itens'
  from (select convert(char(6),c.CFCDATCAD,112) as 'data'
               ,c.CFCNFEEMPCOD as empresa
               ,c.CFCNFETIP as tipo
               ,c.CFCSERCOD as serie
               ,c.CFCNFECOD as fornecedor               
               ,c.CFCNFENUM as nota
               ,isnull((select count(distinct i.CFCPROCOD)
                          from TBS1331 i with (nolock)
                         where i.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                               and i.CFCNFETIP=c.CFCNFETIP
                               and i.CFCSERCOD=c.CFCSERCOD
                               and i.CFCNFECOD=c.CFCNFECOD
                               and i.CFCNFENUM=c.CFCNFENUM),0) as 'qtde_itens'
               ,isnull((select count(*)
                          from TBS1332 L with (nolock)
                         where L.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                               and L.CFCNFETIP=c.CFCNFETIP
                               and L.CFCSERCOD=c.CFCSERCOD
                               and L.CFCNFECOD=c.CFCNFECOD
                               and L.CFCNFENUM=c.CFCNFENUM
                               and L.CFCLOGAPPITE=1),0) as 'coletado'
          from TBS133 c with (nolock)
         where convert(char(6),c.CFCDATCAD,112) >= '202401'
               and c.CFCFIN='S') t
 group by t.data
 order by t.data desc

-- por dia

select convert(date,t.data) as 'data'
       ,count(*) as 'número de notas'
       ,sum(t.coletado) as 'número de coletas'
       ,convert(smallint,convert(decimal,sum(t.coletado))/convert(decimal,count(*))*100) as 'porcentagem da coleta'
       ,sum(t.qtde_itens) as 'qtde de itens'
  from (select c.CFCDATCAD as 'data'
               ,c.CFCNFEEMPCOD as empresa
               ,c.CFCNFETIP as tipo
               ,c.CFCSERCOD as serie
               ,c.CFCNFECOD as fornecedor               
               ,c.CFCNFENUM as nota
               ,isnull((select count(distinct i.CFCPROCOD)
                          from TBS1331 i with (nolock)
                         where i.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                               and i.CFCNFETIP=c.CFCNFETIP
                               and i.CFCSERCOD=c.CFCSERCOD
                               and i.CFCNFECOD=c.CFCNFECOD
                               and i.CFCNFENUM=c.CFCNFENUM),0) as 'qtde_itens'
               ,isnull((select count(*)
                          from TBS1332 L with (nolock)
                         where L.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                               and L.CFCNFETIP=c.CFCNFETIP
                               and L.CFCSERCOD=c.CFCSERCOD
                               and L.CFCNFECOD=c.CFCNFECOD
                               and L.CFCNFENUM=c.CFCNFENUM
                               and L.CFCLOGAPPITE=1),0) as 'coletado'
          from TBS133 c with (nolock)
         where c.CFCDATCAD between '20220802' and '20220804'
               and c.CFCFIN='S') t
 group by t.data
 order by t.data desc

-- por dispositivo

select Left(t.data,4)+'/'+right(t.data,2) as 'ano/mês'
       ,t.dispositivo
       ,count(*) as 'número de notas'
       ,sum(t.qtde_itens) as 'qtde de itens'
  from (select convert(char(6),c.CFCDATCAD,112) as 'data'
               ,c.CFCNFEEMPCOD as empresa
               ,c.CFCNFETIP as tipo
               ,c.CFCSERCOD as serie
               ,c.CFCNFECOD as fornecedor               
               ,c.CFCNFENUM as nota
               ,isnull((select count(distinct i.CFCPROCOD)
                          from TBS1331 i with (nolock)
                         where i.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                               and i.CFCNFETIP=c.CFCNFETIP
                               and i.CFCSERCOD=c.CFCSERCOD
                               and i.CFCNFECOD=c.CFCNFECOD
                               and i.CFCNFENUM=c.CFCNFENUM),0) as 'qtde_itens'
               ,isnull((select count(*)
                          from TBS1332 L with (nolock)
                         where L.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                               and L.CFCNFETIP=c.CFCNFETIP
                               and L.CFCSERCOD=c.CFCSERCOD
                               and L.CFCNFECOD=c.CFCNFECOD
                               and L.CFCNFENUM=c.CFCNFENUM
                               and L.CFCLOGAPPITE=1),0) as 'coletado'
               ,isnull((select CFCLOGAPPHOS
                          from TBS1332 L with (nolock)
                         where L.CFCNFEEMPCOD=c.CFCNFEEMPCOD
                               and L.CFCNFETIP=c.CFCNFETIP
                               and L.CFCSERCOD=c.CFCSERCOD
                               and L.CFCNFECOD=c.CFCNFECOD
                               and L.CFCNFENUM=c.CFCNFENUM
                               and L.CFCLOGAPPITE=1),0) as 'dispositivo'
          from TBS133 c with (nolock)
         where convert(char(6),c.CFCDATCAD,112) >= '202111'
               and c.CFCFIN='S') t
 group by t.data, t.dispositivo
 order by t.data desc

select *
  from ConferenciaMercadorias
