-- notas emitidas no venda rápida

select e.SNESER as serie
       ,e.ENFNUM as nota
       ,e.ENFDESREM as cliente
       ,e.ENFVALTOT as valor
       ,n.CPGCOD as cod_condicao
       ,pv.PDVNUM
       --,e.ENFFINEMI
       ,(select c.CPGDES from TBS008 c with (nolock) where c.CPGCOD = n.CPGCOD) as desc_condicao
  from TBS080 e with (nolock)
 inner join TBS067 n with (nolock)
         on n.SNESER = e.SNESER 
            and n.NFSNUM = e.ENFNUM
            and n.NFSTIP = 'R'
 inner join TBS055 pv with (nolock)
         on pv.PDVNFSSER = n.SNESER 
            and pv.PDVNFSNUM = n.NFSNUM            
 where e.ENFDATEMI = '20260127'
       and e.ENFSIT = 6
       and pv.PDVTRM = 'CAIXA-3'
 order by e.ENFNUM


-- notas sem envio de e-mail

if object_id('tempdb..#cli_grupo') is not null
   drop table #cli_grupo

create table #cli_grupo (codigo int)

insert into #cli_grupo
exec usp_ClientesGrupo 1

SELECT
    e.SNESER as serie
    ,e.ENFNUM as nota
    --,e.ENFTIPDOC 
    ,e.ENFCNPJCPF as cnpj_cpf
    ,e.ENFDESREM as cliente
    ,e.ENFVALTOT as valor
    ,(select n.NFSTIP from TBS067 n with (nolock) where n.NFSEMPCOD = e.ENFEMPCOD and n.NFSNUM = e.ENFNUM and n.SNEEMPCOD = e.SNEEMPCOD and n.SNESER = e.SNESER) as tipo
FROM TBS080 e WITH (NOLOCK)
WHERE e.ENFDATEMI = '20260127'      --between '20260123' and '20260124'
  AND e.ENFSIT = 6
  and e.ENFFINEMI = 1
  and e.ENFTIPDOC = 1
  and e.ENFCODDES not in (select codigo from #cli_grupo)
  AND NOT EXISTS (
        SELECT 1
        FROM TBS0803 l WITH (NOLOCK)
        WHERE l.ENFEMPCOD = e.ENFEMPCOD
          AND l.ENFNUM    = e.ENFNUM
          AND l.SNEEMPCOD = e.SNEEMPCOD
          AND l.SNESER    = e.SNESER
          AND l.ENFLOGCOD = 7100
  );


-- relatório de fechamento

select fp.PDVFIVCOD as codigo
       ,fp.PDVFIVDES as forma_pagto
       ,sum(fp.PDVFIVVAL - fp.PDVFIVVALTRO) as valor
       ,count(fp.PDVFIVCOD) as quantidade
       ,pv.PDVTRM
       --,fp.PDVFIVVAL
       --,fp.PDVFIVVALTRO
       --,nf.NFSNUM
  from TBS067 nf with (nolock)
 inner join TBS0672 nfi with (nolock)
         on nfi.NFSEMPCOD = nf.NFSEMPCOD
            and nfi.SNEEMPCOD = nf.SNEEMPCOD
            and nfi.SNESER = nf.SNESER
            and nfi.NFSNUM = nf.NFSNUM
  inner join TBS0554 fp with (nolock)
         on fp.PDVEMPCOD = nfi.NFSPDVEMP
            and fp.PDVNUM = nfi.NFSPDVNUM
  inner join TBS055 pv with (nolock)
          on pv.PDVEMPCOD = fp.PDVEMPCOD
             and pv.PDVNUM = fp.PDVNUM
 where nf.NFSDATEMI = '20260127'
       and nf.NFSENFSIT = 6
       and nf.NFSTIP = 'R'
       and pv.PDVTRM = 'CAIXA-1'
 group by pv.PDVTRM, fp.PDVFIVCOD, fp.PDVFIVDES
 order by fp.PDVFIVDES

-- troco

select 0 as codigo
       ,'TROCO' as forma_pagto
       ,sum(fp.PDVFIVVALTRO) as valor
       ,count(fp.PDVFIVCOD) as quantidade
  from TBS067 nf with (nolock)
 inner join TBS0672 nfi with (nolock)
         on nfi.NFSEMPCOD = nf.NFSEMPCOD
            and nfi.SNEEMPCOD = nf.SNEEMPCOD
            and nfi.SNESER = nf.SNESER
            and nfi.NFSNUM = nf.NFSNUM
  inner join TBS0554 fp with (nolock)
         on fp.PDVEMPCOD = nfi.NFSPDVEMP
            and fp.PDVNUM = nfi.NFSPDVNUM
  inner join TBS055 pv with (nolock)
          on pv.PDVEMPCOD = fp.PDVEMPCOD
             and pv.PDVNUM = fp.PDVNUM            
 where nf.NFSDATEMI = '20260127' --between '20260115' and '20260122'
       and nf.NFSENFSIT = 6
       and nf.NFSTIP = 'R'
       and fp.PDVFIVVALTRO > 0
       and pv.PDVTRM = 'CAIXA-2'
 group by pv.PDVTRM, fp.PDVFIVCOD, fp.PDVFIVDES
 order by pv.PDVTRM, fp.PDVFIVDES

select fp.*
  from TBS055 pv with (nolock)
  Left join TBS0554 fp with (nolock)
         on fp.PDVEMPCOD = pv.PDVEMPCOD
            and fp.PDVNUM = pv.PDVNUM
 where pv.PDVDATCAD = '20260126'
       and fp.PDVNUM is not null
 order by pv.PDVNUM

begin tran
update TBS0554
   set PDVFIVVALTRO = 0
 where PDVNUM = 727932
       and PDVFIVVALTRO < 0

rollback tran
commit tran

-- registros com mais de uma forma de pagamento

select fp.PDVNUM
  from TBS0554 fp with (nolock)
 group by fp.PDVNUM
having count(*) > 1

select nf.NFSNUM
       ,nf.NFSDATEMI
       ,pv.NFSPDVNUM
       ,pv.NFSPDVVAL
  from TBS0672 pv with (nolock)
  Left join TBS067 nf with (nolock)
         on nf.SNESER = pv.SNESER
            and nf.NFSNUM = pv.NFSNUM
 where nf.NFSTIP = 'R'
       and nf.NFSPDDTOT > 0
       and nf.NFSENFSIT = 6

SELECT NFSPDDTOT,
       SQL_VARIANT_PROPERTY(NFSPDDTOT, 'BaseType')
FROM TBS067
WHERE NFSPDDTOT = 0;

select nf.NFSPDDTOT
  from TBS067 nf with (nolock)
 where nf.NFSNUM = 108776

select *
  from TBS0554 fp with (nolock)
 where fp.PDVNUM = 728872

select fp.PDVFIVDES
       ,count(*)
  from TBS0554 fp with (nolock)
 group by fp.PDVFIVDES

begin tran
update TBS0554
   set PDVFIVVALTRO = 0
 where PDVNUM = 728258

rollback tran
commit tran

begin tran
update TBS0554
   set PDVFIVVAL = 469.63
 where PDVNUM = 728872

rollback tran
commit tran

begin tran
update TBS080
   set ENFVALTOT = 469.63
 where ENFNUM = 391373

rollback tran
commit tran



