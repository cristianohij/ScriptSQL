-- empresas

if object_id('TempDB.dbo.#empresas') is not null
    begin 
       drop table #empresas
    end

select '05.118.717/0001-56' as 'cnpj'
       ,'BEST BAG' as 'nome'
  into #empresas
union
select '52.080.207/0001-17'
       ,'MISASPEL'
union
select '44.125.185/0001-36'
       ,'PAPELYNA'
union
select '65.069.593/0003-50'
       ,'TANBY CD'
union
select '65.069.593/0001-98'
       ,'TANBY MATRIZ'
union
select '65.069.593/0002-79'
       ,'TANBY TAUBATE'
union
select '41.952.080/0001-62'
       ,'WINPACK'

if object_id('TempDB.dbo.#notas') is not null
    begin 
       drop table #notas
    end

select tab.mes
       ,(select nome from #empresas e where e.cnpj=tab.cnpj) as 'nome'
       ,tab.cnpj
       ,tab.custo
  into #notas
  from (
select --c.SNESER as 'serie'
       --,c.NFSNUM as 'nota'
       right(convert(char(6), c.NFSDATEMI, 112),2) as 'mes'
       ,subString(n.ENFCNPJCPF,1,2)+'.'+subString(n.ENFCNPJCPF,3,3)+'.'+subString(n.ENFCNPJCPF,6,3)+'/'+subString(n.ENFCNPJCPF,9,4)+'-'+subString(n.ENFCNPJCPF,13,2) as 'cnpj'
       --,d.PROCOD as 'codigo'
       ,sum(d.NFSQTD*d.NFSQTDEMB*NFSPRECUS) as 'custo'
  from TBS0671 d with (nolock)
  inner join TBS067 c with (nolock)
     on c.NFSEMPCOD=d.NFSEMPCOD
        and c.NFSNUM=d.NFSNUM
        and c.SNESER=d.SNESER
  inner join TBS080 n with (nolock)
    on n.ENFEMPCOD=c.NFSEMPCOD
       and n.ENFNUM=c.NFSNUM
       and n.SNESER=c.SNESER
 where c.NFSDATEMI between '20230101' and '20230329'
       and n.ENFSIT=6
       and n.ENFTIPDOC=1
       and n.ENFCNPJCPF in('05118717000156','52080207000117','44125185000136','65069593000350','65069593000279','65069593000198','41952080000162')
 group by right(convert(char(6), c.NFSDATEMI, 112),2), n.ENFCNPJCPF --, c.SNESER, c.NFSNUM,  --, d.PROCOD
  ) as tab

select *
  from #notas
order by mes, custo desc

select mes
       ,sum(custo)
  from #notas
 group by mes

