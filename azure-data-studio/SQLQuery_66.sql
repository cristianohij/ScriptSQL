-- lista pedidos conferidos

select pedido
       ,st_pendente
       ,st_reservado
       ,st_nf
       ,count(*) as itens
       ,conferente
       ,vendedor
from (
select PRPNUM as pedido
       ,subString(PRPUSUCNF,21,25) as conferente
       ,case when sum(PRPQTDREA+PRPQTDREM) > 0 then 'X' else '' end as st_pendente
       ,case when sum(PRPNFENUM+PRPQTDREA+PRPQTDREM) = 0 then 'X' else '' end as st_reservado
       ,case when sum(PRPNFEQTD) > 0 then 'X' else '' end as st_nf
       ,PRPITEM
       ,count(*) as itens
       ,(select VENNOM
           from TBS004 v with (nolock)
          where v.VENCOD=p.VENCOD) as vendedor
  from TBS058 r with (nolock)
  inner join TBS055 p with (nolock)
        on p.PDVEMPCOD=r.PRPEMP and p.PDVNUM=r.PRPNUM  
 where r.PRPSIT='R'
       and r.PRPQTDCONF > 0
       and convert(date,Left(r.PRPUSUCNF,10))=@data
       and subString(r.PRPUSUCNF,12,8) between @horai and @horaf
       and r.PRPNUM in(@pedidos)
 group by r.PRPNUM, r.PRPUSUCNF, r.PRPITEM, p.VENCOD) tab
 group by pedido
          ,st_pendente
          ,st_reservado
          ,st_nf
          ,conferente
          ,conferente
          ,vendedor
 order by pedido

-- teste 

declare @pedidos int, @data date, @horai varchar(8), @horaf varchar(8)

select @pedidos=611204, @data='20221229', @horai='08', @horaf='12'

--select *
--  from (
--select pedido
       --,st_pendente
       --,st_reservado
       --,st_nf
       --,count(*) as itens
       --,conferente
       --,vendedor
  --from (
          select PRPNUM as pedido
                 ,subString(PRPUSUCNF,21,25) as conferente
                 ,case when sum(PRPQTDREA+PRPQTDREM) > 0 then 'X' else '' end as st_pendente
                 ,case when sum(PRPNFENUM+PRPQTDREA+PRPQTDREM) = 0 then 'X' else '' end as st_reservado
                 ,case when sum(PRPNFEQTD) > 0 then 'X' else '' end as st_nf
                 ,PRPITEM
                 ,count(*) as itens
                 ,(select VENNOM
                     from TBS004 v with (nolock)
                    where v.VENCOD=p.VENCOD) as vendedor
            from TBS058 r with (nolock)
           inner join TBS055 p with (nolock)
                 on p.PDVEMPCOD=r.PRPEMP and p.PDVNUM=r.PRPNUM  
           where r.PRPSIT='R'
                 and r.PRPQTDCONF > 0
                 and convert(date,Left(r.PRPUSUCNF,10))=@data
                 and subString(r.PRPUSUCNF,12,8) between @horai and @horaf
                 and r.PRPNUM in(@pedidos)
           group by r.PRPNUM, r.PRPUSUCNF, r.PRPITEM, p.VENCOD
       --) as tab
 --group by pedido
          --,st_pendente
          --,st_reservado
          --,st_nf
          --,conferente
          --,vendedor
 --order by pedido
--  ) as tab2