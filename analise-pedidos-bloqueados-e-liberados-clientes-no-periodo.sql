select *
  from TBS0552 with (nolock)
 where PDVLBLDAT >= '20230101'
       and PDVLBLACA='B'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'

select PDVLBLDAT
       ,max(PDVLBLHOR)
       ,count(*)
  from TBS0552 with (nolock)
 where PDVLBLDAT >= '20230101'
       and PDVLBLACA='B'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'
 group by PDVLBLDAT
       --and PDVLBLHOR >= '10:00:00'

select P.* from
(
    select Categora, MAX(quantidade) as quantidade from @tabela
    group by Categora
) D
join @tabela P
on P.Categora = D.Categora
and P.quantidade = D.quantidade

select *
  from TBS0552 with (nolock)
 where PDVLBLDAT > ='20230101'
       and PDVLBLACA='B'
       and PDVLBLHOR >= '18:00:00'

select *
  from TBS0552 with (nolock)
 where PDVLBLDAT > ='20230101'
       and PDVLBLACA='L'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'

select PDVNUM
  from TBS0552 with (nolock)
 where PDVLBLDAT > ='20230101'
       and PDVLBLACA='B'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'
 group by PDVNUM

select PDVLBLDAT
       ,PDVNUM
       ,count(*)
  from TBS0552 with (nolock)
 where PDVLBLDAT > ='20230101'
       and PDVLBLACA='B'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'
 group by PDVLBLDAT, PDVNUM

-- pedidos por dia, bloqueados por crédito após as 18:00h

select convert(date,PDVLBLDAT,112) as 'data'
       ,count(distinct PDVNUM) as 'qtde'
  from TBS0552 with (nolock)
 where PDVLBLDAT > ='20230101'
       and PDVLBLACA='B'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'
 group by PDVLBLDAT

-- pedidos por dia, liberados por crédito após as 18:00h

select convert(date,PDVLBLDAT,112) as 'data'
       ,count(distinct PDVNUM) as 'qtde'
  from TBS0552 with (nolock)
 where PDVLBLDAT > ='20230101'
       and PDVLBLACA='L'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'
 group by PDVLBLDAT

select convert(date,PDVLBLDAT,112) as 'data'
       ,PDVNUM
       ,min(PDVLBLHOR)
       ,max(PDVLBLHOR)
       ,count(*)
  from TBS0552 with (nolock)
 where PDVLBLDAT >= '20230101'
       and PDVLBLACA='B'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'
 group by PDVLBLDAT, PDVNUM


select PDVLBLDAT
       ,PDVLBLHOR
       ,PDVNUM
       ,(select top(1) PDVLBLDAT, PDVLBLHOR from TBS0552 min with (nolock) where min.PDVNUM=b.PDVNUM order by PDVLBLDAT)
       ,(select top(1) PDVLBLDAT, PDVLBLHOR from TBS0552 min with (nolock) where min.PDVNUM=b.PDVNUM order by PDVLBLDAT desc)
  from TBS0552 b with (nolock)
 where PDVLBLDAT >= '20230101'
       --and PDVLBLACA='B'
       and PDVLBLTIP='C'
       --and PDVLBLHOR >= '18:00:00'
 group by PDVLBLDAT, PDVNUM

select convert(date,PDVLBLDAT,112) as 'data'
       ,PDVNUM as 'pedido'
       ,max(PDVLBLHOR) as 'hora'
  from TBS0552 with (nolock)
 where PDVLBLDAT >= '20230101'
       and PDVLBLACA='B'
       and PDVLBLTIP='C'
       and PDVLBLHOR >= '18:00:00'
 group by PDVLBLDAT, PDVNUM



