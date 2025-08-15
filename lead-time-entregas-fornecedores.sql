-- lead time de entregas de fornecedores

select top(100)
       pa.NFEATEDAT
       ,c.NFEDATEFE
       ,datediff(day, pc.PDCDATCAD, pa.NFEATEDAT)
       ,*
  from TBS0592 pa with (nolock)
  inner join TBS059 c with (nolock)
     on c.NFEEMPCOD=pa.NFEEMPCOD and c.NFECOD=pa.NFECOD and c.NFENUM=pa.NFENUM and c.NFETIP=pa.NFETIP and c.SERCOD=pa.SERCOD and c.SEREMPCOD=pa.SEREMPCOD
  inner join TBS045 pc with (nolock)
     on pc.PDCEMPCOD=pa.NFEPEDEMP and pc.PDCNUM=pa.NFEPEDNUM
 where pa.NFETIPPED='C'
       and pa.NFEATEDAT <> '17530101'
       --and convert(date, pa.NFEATEDAT) <> convert(date, c.NFEDATEFE)
       --and convert(date, c.NFEDATEFE,112) >= '20220101'

-- empresa do grupo cadastradas como fornecedores

if object_id('tempdb.dbo.#fornecedores_grupo') is not null
begin 
	drop table #fornecedores_grupo
end

select FORCOD
  into #fornecedores_grupo
  from TBS006 with (nolock)
 where FORCGC in('05118717000237','05118717000156','52080207000117','44125185000136','65069593000350','65069593000198','65069593000279','41952080000162')
 group by FORCOD

select *
  from #fornecedores_grupo

if object_id('tempdb.dbo.#notas') is not null
begin 
	drop table #notas
end

select n.NFEEMPCOD
       ,n.NFETIP
       ,n.NFENUM
       ,n.NFECOD
       ,n.NFENOM
       ,n.SEREMPCOD
       ,n.SERCOD
       ,n.NFEESTORI
       ,n.NFEDATEFE
       ,(select count(*)
           from TBS0591 d with (nolock)
          where d.NFEEMPCOD=n.NFEEMPCOD and d.NFECOD=n.NFECOD and d.NFENUM=n.NFENUM and d.NFETIP=n.NFETIP and d.SERCOD=n.SERCOD and d.SEREMPCOD=n.SEREMPCOD
        ) as 'qtde_itens'
  into #notas
  from TBS059 n with (nolock)
 where n.NFEDATEFE between '20230101' and '20231231'
       and n.NFETIP='N'
       and n.NFECAN='N'
       and n.NFECOD not in(select g.FORCOD from #fornecedores_grupo g)
       and exists(select ''
                    from TBS0592 pa with (nolock)
                   where pa.NFEEMPCOD=n.NFEEMPCOD and pa.NFECOD=n.NFECOD and pa.NFENUM=n.NFENUM and pa.NFETIP=n.NFETIP and pa.SERCOD=n.SERCOD and pa.SEREMPCOD=n.SEREMPCOD
                 )

select *
  from #notas

if object_id('tempdb.dbo.#pc_atendidos') is not null
begin 
	drop table #pc_atendidos
end

select pa.NFEEMPCOD
       ,pa.NFETIP
       ,pa.NFENUM
       ,pa.NFECOD
       ,pa.SEREMPCOD
       ,pa.SERCOD
       ,pa.NFEPEDEMP
       ,pa.NFEPEDNUM
       ,pa.NFEPEDITE
       ,pa.NFEPEDUNI
       ,pa.NFEPEDQTD
       ,pa.NFEPEDEMB
       ,pa.NFEATEQTD
  into #pc_atendidos
  from TBS0592 pa with (nolock)
 where pa.NFETIPPED='C'
       and pa.NFEATEDAT <> '17530101'
       and exists(select ''
                    from #notas n
                   where n.NFEEMPCOD=pa.NFEEMPCOD and n.NFECOD=pa.NFECOD and n.NFENUM=pa.NFENUM and n.NFETIP=pa.NFETIP and n.SERCOD=pa.SERCOD and n.SEREMPCOD=pa.SEREMPCOD 
                 )

select *
  from #pc_atendidos

if object_id('tempdb.dbo.#pc_itens') is not null
begin 
	drop table #pc_itens
end

select pd.PDCEMPCOD
       ,pd.PDCNUM
       ,pd.PDCITE
       ,pd.PROEMPCOD
       ,pd.PROCOD
       ,pd.PDCDES
       ,pd.PDCDATPRE
       ,pd.PDCDATFAT
  into #pc_itens
  from TBS0451 pd with (nolock)
 where exists(select '' 
                from #pc_atendidos pa
               where pa.NFEPEDEMP=pd.PDCEMPCOD
                     and pa.NFEPEDNUM=pd.PDCNUM
                     and pa.NFEPEDITE=pd.PDCITE
             )

select *
  from #pc_itens

if object_id('tempdb.dbo.#compras') is not null
begin 
	drop table #compras
end

select n.NFEEMPCOD
       ,n.NFETIP
       ,n.NFENUM
       ,n.NFECOD
       ,n.NFENOM
       ,n.SEREMPCOD
       ,n.SERCOD
       ,n.NFEESTORI
       ,n.NFEDATEFE
       ,pa.NFEATEQTD
       ,pc.PDCEMPCOD
       ,pc.PDCNUM
       ,pc.PDCDATCAD
       ,pd.PDCITE
       ,pd.PROEMPCOD
       ,pd.PROCOD
       ,pd.PDCUNI
       ,pd.PDCQTD
       ,pd.PDCQTDEMB
       ,pd.PDCDES
       ,pd.PDCDATPRE
       ,pd.PDCDATFAT
  into #compras     
  from TBS059 n with (nolock)
 inner join TBS0592 pa with (nolock)
    on pa.NFEEMPCOD=n.NFEEMPCOD and pa.NFECOD=n.NFECOD and pa.NFENUM=n.NFENUM and pa.NFETIP=n.NFETIP and pa.SERCOD=n.SERCOD and pa.SEREMPCOD=n.SEREMPCOD
 inner join TBS045 pc with (nolock)
    on pc.PDCEMPCOD=pa.NFEPEDEMP and pc.PDCNUM=pa.NFEPEDNUM 
 inner join TBS0451 pd with (nolock)
    on pd.PDCEMPCOD=pa.NFEPEDEMP and pd.PDCNUM=pa.NFEPEDNUM and pd.PDCITE=pa.NFEPEDITE
 where n.NFEDATEFE between '20230101' and '20231231'
       and n.NFETIP='N'
       and n.NFECAN='N'
       and subString(n.NFECHAACE,7,14) not in('05118717000237','05118717000156','52080207000117','44125185000136','65069593000350','65069593000198','65069593000279','41952080000162')
       and pa.NFETIPPED='C'
       and pa.NFEATEDAT <> '17530101'

select *
  from #compras

if object_id('tempdb.dbo.#media_entregas') is not null
begin 
	drop table #media_entregas
end

select NFECOD
       ,NFENOM
       ,NFEESTORI
       ,avg(datediff(day, PDCDATCAD, NFEDATEFE)) as 'media'
  into #media_entregas
  from #compras
 group by NFECOD, NFENOM, NFEESTORI

select *
  from #media_entregas
 order by NFENOM

update TBS006
   set FORTEMREP=0

update TBS006
   set FORTEMREP=media
  from TBS006 f
  join #media_entregas m on f.FORCOD=m.NFECOD


select top(100) *
  from TBS045 with (nolock)

-- média geral

select avg(media) as 'media_geral'
  from #media_entregas

-- media por estado

select NFEESTORI as 'UF'
       ,avg(media) as 'media'
  from #media_entregas
 group by NFEESTORI
 order by NFEESTORI

-- moda

-- uma forma

with tmModa as (
   select media
          ,count(*) as 'freqAbs'
     from #media_entregas
    group by media
   having count(*) > 1
)
select top (1) with ties media as 'moda'
  from tmModa
 order by freqAbs desc

-- outra forma

select top(1) with ties media as 'moda'
       ,count(*)
  from #media_entregas
 group by media
having count(*) > 1
 order by count(*) desc
 
-- conta pedidos de compras

select convert(char(6),PDCDATCAD,112)
       ,count(*)
  from TBS045 with (nolock)
 where PDCDATCAD >= '20220101'
 group by convert(char(6),PDCDATCAD,112)

select count(distinct NFECOD)
  from TBS059 with (nolock)
 where NFEDATEFE between '20230101' and '20231231'
 
select NFECOD
  from TBS059 with (nolock)
 where NFEDATEFE between '20230101' and '20231231'
 group by NFECOD

select NFECOD
       ,max(NFEDATEFE) as 'UltimaDataEntrega'
  from TBS059 with (nolock)
 where NFECAN = 'N' and NFETIP = 'N'  
 group by NFECOD

select codigo
       ,nome
       ,ultima_entrega
  from (
select NFECOD as 'codigo'
       ,NFENOM as 'nome'
       ,max(NFEDATEFE) as 'ultima_entrega'
  from TBS059 with (nolock)
 where NFEDATEFE != '17530101'
       and NFECAN='N'
       and NFETIP='N'
 group by NFECOD, NFENOM
  ) as tab
 order by ultima_entrega desc

