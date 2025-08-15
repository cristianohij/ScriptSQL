select *
  from TBS058 with (nolock)

select PRPSIT
       ,count(*)
  from TBS058 with (nolock)
 group by PRPSIT

select count(distinct PROCOD)
  from TBS058 with (nolock)

select count(distinct PRPNUM)
  from TBS058 with (nolock)
 where convert(date,PRPDATREG) = '20230912'

select PRPNUM
       ,(select convert(date,PDVDATCAD) from TBS055 with (nolock) where PDVNUM=PRPNUM) as 'data'
       ,sum(case when PRPSIT='P' then 1 else 0 end) as 'pendentes'
       ,sum(case when PRPSIT='R' then 1 else 0 end) as 'reservados'
  from TBS058 with (nolock)
 group by PRPNUM
 order by PRPNUM

select tab.PRPNUM as 'pedido'
       ,tab.pendentes
       ,tab.reservados
       ,convert(date,p.PDVDATCAD) as 'data_pedido'
       ,p.PDVCLICOD as 'codigo_cliente'
       ,p.PDVCLINOM as 'nome_cliente'
       ,p.VENCOD as 'codigo_vendedor'
       ,isnull((select VENNOM from TBS004 v with (nolock) where v.VENCOD=p.VENCOD),'') as 'nome_vendedor'
  from (
select PRPNUM
       ,sum(case when PRPSIT='P' then 1 else 0 end) as 'pendentes'
       ,sum(case when PRPSIT='R' then 1 else 0 end) as 'reservados'
  from TBS058 with (nolock)
 group by PRPNUM) as tab
 inner join TBS055 p with (nolock)
    on PDVNUM=PRPNUM
 where convert(date,p.PDVDATCAD) <= '20230531'
 order by tab.PRPNUM

