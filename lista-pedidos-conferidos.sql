select *
  from TBS058 with (nolock)
 where PRPSIT='R'
 order by convert(date,Left(PRPUSUCNF,10)) desc

declare @data date, @horai varchar(8), @horaf varchar(8)

select @data='20220406', @horai='10:39', @horaf='10:40'

--select PRPNUM as pedido
--  from TBS058 with (nolock)
-- where PRPSIT='R'
--       and PRPQTDCONF > 0
--       and convert(date,Left(PRPUSUCNF,10))=@data
--       and subString(PRPUSUCNF,12,8) between @horai and @horaf       
-- group by PRPNUM
-- order by PRPNUM

select pedido
       ,st_pendente
       ,st_reservado
       ,st_nf
       ,count(*) as itens
       --,subString(conferente,21,25) as conferente
       ,conferente
       ,vendedor
from (
select PRPNUM as pedido
       --,PRPUSUCNF as conferente
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
       --and r.PRPNUM in(@pedidos)
 group by r.PRPNUM, r.PRPUSUCNF, r.PRPITEM, p.VENCOD) tab
 group by pedido
          ,st_pendente
          ,st_reservado
          ,st_nf
          ,conferente
          ,subString(conferente,21,25)
          ,vendedor
 order by pedido

select pedido
       ,st_pendente
       ,st_reservado
       ,st_nf
       ,count(*) as itens
       ,subString(conferente,21,25)
from (
select PRPNUM as pedido
       ,PRPUSUCNF as conferente
       ,case when sum(PRPQTDREA+PRPQTDREM) > 0 then 'X' else '' end as st_pendente
       ,case when sum(PRPNFENUM+PRPQTDREA+PRPQTDREM) = 0 then 'X' else '' end as st_reservado
       ,case when sum(PRPNFEQTD) > 0 then 'X' else '' end as st_nf
       ,PRPITEM
       ,count(*) as itens
  from TBS058 with (nolock)
 where PRPSIT='R'
       and PRPQTDCONF > 0
       and convert(date,Left(PRPUSUCNF,10))=@data
       and subString(PRPUSUCNF,12,8) between @horai and @horaf       
 group by PRPNUM, PRPUSUCNF, PRPITEM) tab
 group by pedido
          ,st_pendente
          ,st_reservado
          ,st_nf
          ,conferente
          ,subString(conferente,21,25)

select pedido
       ,st_pendente
       ,st_reservado
       ,st_nf
       ,count(*)
       ,subString(conferente,21,25)
from (
select PRPNUM as pedido
       --,subString(PRPUSUCNF,21,25) as conferente
       ,PRPUSUCNF as conferente
       ,case when sum(PRPQTDREA+PRPQTDREM) > 0 then 'X' else '' end as st_pendente
       ,case when sum(PRPNFENUM+PRPQTDREA+PRPQTDREM) = 0 then 'X' else '' end as st_reservado
       ,case when sum(PRPNFENUM) > 0 then 'X' else '' end as st_nf
       ,count(*) as itens
  from TBS058 with (nolock)
 where PRPSIT='R'
       and PRPQTDCONF > 0
       and convert(date,Left(PRPUSUCNF,10))=@data
       and subString(PRPUSUCNF,12,8) between @horai and @horaf       
 group by PRPNUM, PRPUSUCNF) tab
 group by pedido
          ,st_pendente
          ,st_reservado
          ,st_nf
          ,subString(conferente,21,25)


select PRPNUM
       ,subString(PRPUSUCNF,21,25) as conferente
       ,count(*) as itens
       --,*
  from TBS058 with (nolock)
 where PRPSIT='R'
       and convert(date,Left(PRPUSUCNF,10))=@data
       and subString(PRPUSUCNF,12,8) between @horai and @horaf
 group by PRPNUM, subString(PRPUSUCNF,21,25)
 

select 
select PRPNUM
       ,subString(PRPUSUCNF,21,25) as conferente
       ,case when sum(PRPQTDREA+PRPQTDREM) > 0 then 'X' else '' end as st_pendente
       ,case when sum(PRPNFENUM+PRPQTDREA+PRPQTDREM) = 0 then 'X' else '' end as st_reservado
       ,case when sum(PRPNFENUM) > 0 then 'X' else '' end as st_nf
       ,count(*) as itens
  from TBS058 with (nolock)
 where PRPSIT='R'
       and PRPQTDCONF > 0
 group by PRPNUM, subString(PRPUSUCNF,21,25)
 order by PRPNUM

select *
  from TBS058 with (nolock)
 where PRPSIT='R'
       and PRPQTDCONF > 0
       and PRPNUM=582509

select (select VENNOM
          from TBS004 v with (nolock)
         where v.VENCOD=p.VENCOD)
       ,*
  from TBS058 r with (nolock)
  inner join TBS055 p with (nolock)
        on p.PDVEMPCOD=r.PRPEMP
           and p.PDVNUM=r.PRPNUM
 where PRPSIT='R'
       and PRPQTDCONF > 0
       and PRPNUM=582509

select PRPNFENUM
       ,PRPQTDREA
       ,PRPQTDREM
       ,*
  from TBS058 with (nolock)
 where PRPSIT='R'
       and PRPQTDCONF > 0
 order by PRPNUM

-- sem uso
select *
  from (
select PRPNUM
       ,subString(PRPUSUCNF,21,25) as conferente
--       ,subString(PRPUSUCNF,12,8) as hora
--       ,count(*)
       --,*
  from TBS058 with (nolock)
 where PRPSIT='R'
       and convert(date,Left(PRPUSUCNF,10))=@data
       and subString(PRPUSUCNF,12,8) between @horai and @horaf) tab
 group by tab.PRPNUM
--
