if object_id('TempDB.dbo.#notas') is not null
    begin 
       drop table #notas
    end

select c.SNESER as 'serie'
       ,c.NFSNUM as 'nota'
       ,convert(char(6), c.NFSDATEMI, 112) as 'periodo'
       ,subString(n.ENFCNPJCPF,1,2)+'.'+subString(n.ENFCNPJCPF,3,3)+'.'+subString(n.ENFCNPJCPF,6,3)+'/'+subString(n.ENFCNPJCPF,9,4)+'-'+subString(n.ENFCNPJCPF,13,2) as 'cnpj'
       ,d.PROCOD as 'codigo'
       ,sum(d.NFSQTD*d.NFSQTDEMB) as 'qtde'
  into #notas
  from TBS0671 d with (nolock)
  inner join TBS067 c with (nolock)
     on c.NFSEMPCOD=d.NFSEMPCOD
        and c.NFSNUM=d.NFSNUM
        and c.SNESER=d.SNESER
  inner join TBS080 n with (nolock)
    on n.ENFEMPCOD=c.NFSEMPCOD
       and n.ENFNUM=c.NFSNUM
       and n.SNESER=c.SNESER
 where c.NFSDATEMI between '20230101' and '20231231'
       and n.ENFSIT=6
       and n.ENFTIPDOC=1
       and n.ENFCNPJCPF in('05118717000156','52080207000117','44125185000136','65069593000350','65069593000279','65069593000198','41952080000162')
 group by convert(char(6), c.NFSDATEMI, 112), c.SNESER, c.NFSNUM, n.ENFCNPJCPF, d.PROCOD


declare @notas int, @pro_distintos int

-- quantidade de notas

select @notas=count(tab.qtde)
  from (
         select count(nota) as 'qtde'
           from #notas
          group by nota
       ) as tab

-- quantidade de produtos distintos

select @pro_distintos=count(tab.qtde)
  from (
         select count(*) as 'qtde'
           from #notas
          group by codigo
       ) as tab

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

if object_id('TempDB.dbo.#notas2') is not null
    begin 
       drop table #notas2
    end

select subString(periodo,1,4) as 'ano'
       ,subString(periodo,5,2) as 'mes'
       ,serie
       ,nota
       ,cnpj
       ,(select nome from #empresas e where e.cnpj=a.cnpj) as 'empresa'
       ,@notas as 'qtde_notas'
       ,codigo
       ,qtde
       ,(select PRODES from TBS010 with (nolock) where PROCOD=codigo) as 'descricao'
       ,(select MARCOD from TBS010 with (nolock) where PROCOD=codigo) as 'codi_marca'
       ,(select MARNOM from TBS010 with (nolock) where PROCOD=codigo) as 'nome_marca'
       ,(select PROUM1 from TBS010 with (nolock) where PROCOD=codigo) as 'unidade'
       ,@pro_distintos as 'nr_produtos'
       ,(select count(*) from #notas b where b.codigo=a.codigo) as 'ocor_produto'
       ,(select sum(b.qtde) from #notas b where b.codigo=a.codigo) as 'qtde_total'
       ,(select sum(b.qtde) from #notas b where b.cnpj=a.cnpj and b.codigo=a.codigo) as 'qtde_pro_empresa'
       ,(select sum(b.qtde) from #notas b where b.cnpj=a.cnpj and b.periodo=a.periodo and b.codigo=a.codigo) as 'qtde_empresa_periodo_produto'
       ,(select sum(b.qtde) from #notas b where b.periodo=a.periodo and b.codigo=a.codigo) as 'qtde_periodo_produto'
       ,(select count(*) from #notas b where b.cnpj=a.cnpj and b.codigo=a.codigo) as 'ocor_pro_empresa'
       ,(select count(distinct b.nota) from #notas b where b.cnpj=a.cnpj) as 'nr_notas_empresa'
       ,(select count(distinct b.nota) from #notas b where b.periodo=a.periodo) as 'nr_notas_mes'
       ,(select count(distinct b.nota) from #notas b where b.cnpj=a.cnpj and b.periodo=a.periodo) as 'nr_notas_empresa_mes'
       ,(select count(b.nota) from #notas b where b.cnpj=a.cnpj and b.periodo=a.periodo and b.codigo=a.codigo) as 'ocor_pro_empresa_mes'
  --into TRANSF_GRUPO
  into #notas2
  from #notas a

select *
  from #notas2

if object_id('SIBD.dbo.TRANSF_GRUPO') is not null
    begin 
       drop table TRANSF_GRUPO
    end

select *
       ,(select count(*) from #notas2 b where b.codi_marca=a.codi_marca) as 'ocor_pro_marca'
       ,(select sum(b.qtde) from #notas2 b where b.codi_marca=a.codi_marca) as 'qtde_pro_marca'
  into TRANSF_GRUPO       
  from #notas2 a

select *
  from TRANSF_GRUPO

select top(100) *
  from TRANSF_GRUPO

update TRANSF_GRUPO
   set descricao=replace(descricao,',','')

-- total de notas emitidas

select distinct 
       qtde_notas
       ,nr_produtos
  from TRANSF_GRUPO

-- número de notas emitidas no mês

select distinct 
       mes
       ,nr_notas_mes
  from TRANSF_GRUPO
 order by mes

-- total de notas emitidas por empresa

select distinct 
       empresa
       ,nr_notas_empresa
  from TRANSF_GRUPO
 order by nr_notas_empresa desc, empresa

-- número de notas emitidas por empresa no mês

select distinct 
       mes
       ,empresa
       ,nr_notas_empresa_mes
  from TRANSF_GRUPO
 order by mes, nr_notas_empresa_mes desc

-- produtos transferidos por empresa

select distinct 
       empresa
       ,codigo
       ,qtde_pro_empresa
       ,descricao
       ,codi_marca
       ,nome_marca
       ,unidade
  from TRANSF_GRUPO
 order by empresa, qtde_pro_empresa desc

-- transferências por mês/empresa

select mes
       ,empresa
       ,codigo
       ,descricao
       ,codi_marca
       ,nome_marca
       ,unidade
       ,sum(qtde)
  from TRANSF_GRUPO
 group by mes
          ,empresa
          ,codigo
          ,descricao
          ,codi_marca
          ,nome_marca
          ,unidade
 order by mes

-- produtos +transferidos

select distinct codigo
       ,descricao
       ,codi_marca
       ,nome_marca
       ,unidade
       ,qtde_total
  from TRANSF_GRUPO
 order by qtde_total desc

-- produtos transferidos no mês

select distinct
       mes
       ,codigo
       ,descricao
       ,codi_marca
       ,nome_marca
       ,unidade
       ,qtde_periodo_produto
  from TRANSF_GRUPO
 order by mes, qtde_periodo_produto desc

-- transferidos por marca

select distinct
       codi_marca
       ,nome_marca
       ,ocor_pro_marca
       ,qtde_pro_marca
  from TRANSF_GRUPO
 order by qtde_pro_marca desc



-- analises

select d.NFSQTD*d.NFSQTDEMB as 'qtde'
       ,d.NFSCFOP
       --,*
  from TBS0671 d with (nolock)
  inner join TBS067 c with (nolock)
     on c.NFSEMPCOD=d.NFSEMPCOD
        and c.NFSNUM=d.NFSNUM
        and c.SNESER=d.SNESER
  inner join TBS080 n with (nolock)
    on n.ENFEMPCOD=c.NFSEMPCOD
       and n.ENFNUM=c.NFSNUM
       and n.SNESER=c.SNESER
       and n.ENFSIT=6
       and n.ENFTIPDOC=1
       and n.ENFCNPJCPF='65069593000279'
 where c.NFSDATEMI between '20220101' and '20221231'
       --and n.ENFSIT=6
       --and n.ENFTIPDOC=1
       --and n.ENFCNPJCPF='65069593000279'
       and d.PROCOD='1721001'

select *
  into #produto
  from TBS0671 d with (nolock)
 where d.PROCOD='1721001'

select *
  into #nf
  from TBS080 e with (nolock)
 where e.ENFDATEMI between '20220101' and '20221231'
       and e.ENFSIT=6
       and e.ENFTIPDOC=1
       and e.ENFCNPJCPF='65069593000279'
  
select p.NFSQTD * p.NFSQTDEMB
       ,*
  from #produto p 
 inner join #nf n
    on n.ENFSER=p.SNESER
       and n.ENFNUM=p.NFSNUM