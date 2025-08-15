select top 10 *
  from TBS0431 with (nolock)
 where PROCOD='3251929'
       and ORCITEM=21

select *
  from TBS025 with (nolock)
 where PARCHV=1053

begin tran
update TBS0431
   set ORCQTDEMB=1
 where ORCNUM=478540
       and ORCITEM=21
	   and ORCQTDEMB=0
commit tran

select *
  from TBS0431 with (nolock)
 where ORCNUM=478540
       and ORCITEM=21

begin tran
update TBS0431
   set ORCUNI='PT'
 where ORCNUM=478540
       and ORCITEM=21
commit tran

select *
  from TBS0521 with (nolock)
 where PROCOD='3251929'
 
select i.ORCNUM
       ,i.ORCITEM
	   ,i.PROCOD
	   ,i.ORCUNI
	   ,i.ORCQTDEMB
	   ,p.PROUM1
	   ,p.PROUM2
	   ,p.PROUM3
	   ,p.PROUM4
  into #itens
  from TBS0431 i with (nolock)
       inner join TBS043 c with (nolock)
	   on i.ORCNUM =c.ORCNUM
	   inner join TBS010 p with (nolock)
	   on p.PROCOD=i.PROCOD
 where c.ORCPARA='C'
       and i.ORCUNI not in(p.PROUM1,p.PROUM2,p.PROUM3,p.PROUM4)
       and i.ORCQTDEMB=1

select *
  from #itens
   
begin tran
update TBS0431
   set ORCUNI=#itens.PROUM1
  from #itens
 where TBS0431.ORCNUM=#itens.ORCNUM
       and TBS0431.ORCITEM=#itens.ORCITEM
	   and TBS0431.PROCOD=#itens.PROCOD

rollback tran
commit tran

-- pedidos de vendas

select i.PDVNUM
       ,i.PDVITEM
	   ,i.PROCOD
	   ,i.PDVUNI
	   ,i.PDVQTDEMB
	   ,p.PROUM1
	   ,p.PROUM2
	   ,p.PROUM3
	   ,p.PROUM4
  into #itens_pedido
  from TBS0551 i with (nolock)
       inner join TBS055 c with (nolock)
	   on i.PDVNUM=c.PDVNUM
	   inner join TBS010 p with (nolock)
	   on p.PROCOD=i.PROCOD
 where i.PDVUNI not in(p.PROUM1,p.PROUM2,p.PROUM3,p.PROUM4)
       and i.PDVQTDEMB=1
	   and i.PDVQTDFAT < i.PDVQTD

begin tran
update TBS0551
   set PDVUNI=ip.PROUM1
  from #itens_pedido ip
 where TBS0551.PDVNUM=ip.PDVNUM
       and TBS0551.PDVITEM=ip.PDVITEM
	   and TBS0551.PROCOD=ip.PROCOD

rollback tran
commit tran


