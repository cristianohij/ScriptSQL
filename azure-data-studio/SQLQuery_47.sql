select *
  from TBS149 with (nolock)
 
select t.centro_custo
       ,sum(t.valor_requisitado) as 'valor_requisitado'
       ,sum(t.valor_aprovado) as 'valor_aprovado'
       ,sum(t.valor_atendido) as 'valor_atendido'
from (
select c.RMACECNOM as 'centro_custo'
       ,i.RMAPROPRE*i.RMAQTDREQ as 'valor_requisitado'
       ,i.RMAPROPRE*i.RMAQTDAPR as 'valor_aprovado'
       ,i.RMAPROPRE*i.RMAQTDATE as 'valor_atendido'
  from TBS149 c with (nolock)
  inner join TBS1491 i with (nolock)
  on i.RMAEMPCOD=c.RMAEMPCOD
     and i.RMADOC=c.RMADOC
  where c.RMADATCAD='20220729'
) t
group by rollup(t.centro_custo)

select t.centro_custo
       ,sum(t.valor_requisitado) as 'valor_requisitado'
       ,sum(t.valor_aprovado) as 'valor_aprovado'
       ,sum(t.valor_atendido) as 'valor_atendido'
from (
select c.RMACECNOM as 'centro_custo'
       ,i.RMAPROPRE*i.RMAQTDREQ as 'valor_requisitado'
       ,i.RMAPROPRE*i.RMAQTDAPR as 'valor_aprovado'
       ,i.RMAPROPRE*i.RMAQTDATE as 'valor_atendido'
  from TBS149 c with (nolock)
  inner join TBS1491 i with (nolock)
  on i.RMAEMPCOD=c.RMAEMPCOD
     and i.RMADOC=c.RMADOC
  where c.RMADATCAD between '20250101' and '20250331'
) t
group by rollup(t.centro_custo)

select t.anomes
       ,t.centro_custo
       ,sum(t.valor_requisitado) as 'valor_requisitado'
       ,sum(t.valor_aprovado) as 'valor_aprovado'
       ,sum(t.valor_atendido) as 'valor_atendido'
from (
select convert(char(6), c.RMADATCAD, 112) as 'anomes'
       ,c.RMACECNOM as 'centro_custo'
       ,i.RMAPROPRE*i.RMAQTDREQ as 'valor_requisitado'
       ,i.RMAPROPRE*i.RMAQTDAPR as 'valor_aprovado'
       ,i.RMAPROPRE*i.RMAQTDATE as 'valor_atendido'
  from TBS149 c with (nolock)
  inner join TBS1491 i with (nolock)
  on i.RMAEMPCOD=c.RMAEMPCOD
     and i.RMADOC=c.RMADOC
  where c.RMADATCAD between '20250101' and '20250331'
) t
group by rollup(t.anomes, t.centro_custo)

select c.RMACECNOM as 'centro_custo'
       ,c.RMAUSUCAD as 'requisitante'
       ,i.PROCOD as 'cod_produto'
       ,i.RMAPRODES as 'descricao'
       ,i.RMAPROUM1 as 'unidade'
       ,avg(i.RMAPROPRE) as 'media_preco'
       ,sum(i.RMAQTDREQ) as 'qtde_requisitada'
       ,sum(i.RMAQTDAPR) as 'qtde_aprovada'
       ,sum(i.RMAQTDATE) as 'qtade_atendida'
       ,sum(i.RMAQTDATE * i.RMAPROPRE) as 'valor_atendido'
       ,sum((i.RMAQTDREQ * i.RMAPROPRE) - (i.RMAQTDAPR * i.RMAPROPRE)) as 'valor_nao_aprovado'
       ,i.RMAITESIT as 'situacao'
  from TBS1491 i with (nolock)
  inner join TBS149 c with (nolock)
     on c.RMAEMPCOD=i.RMAEMPCOD
        and c.RMADOC=i.RMADOC
  --where i.RMAQTDATE > 0        
 group by c.RMACECNOM, c.RMAUSUCAD, i.RMAITESIT, i.PROCOD, i.RMAPRODES, i.RMAPROUM1


select *
  from TBS1491 with (nolock)
 where RMAQTDREQ <> RMAQTDAPR

select top(1)
       *
  from TBS1491 with (nolock)

select c.RMACECNOM as 'centro_custo'
       ,c.RMAUSUCAD as 'requisitante'
       ,i.PROCOD as 'cod_produto'
       ,i.RMAPRODES as 'descricao'
       ,i.RMAPROUM1 as 'unidade'
       ,avg(i.RMAPROPRE) as 'media_preco'
       ,sum(i.RMAQTDREQ) as 'qtde_requisitada'
       ,sum(i.RMAQTDAPR) as 'qtde_aprovada'
       ,sum(i.RMAQTDATE) as 'qtade_atendida'
       ,sum(i.RMAQTDATE * i.RMAPROPRE) as 'valor_atendido'
       ,sum(i.RMAQTDAPR * i.RMAPROPRE) as 'valor_aprovado'
       ,i.RMAITESIT as 'situacao'
  from TBS1491 i with (nolock)
 inner join TBS149 c with (nolock)
    on c.RMAEMPCOD=i.RMAEMPCOD
       and c.RMADOC=i.RMADOC
 where i.RMADEHATE between '20220901' and '20220930'
 group by c.RMACECNOM, c.RMAUSUCAD, i.RMAITESIT, i.PROCOD, i.RMAPRODES, i.RMAPROUM1

select datediff(day, RMADEHREQ, RMADEHAPR) as 'aprovada'
       ,datediff(day, RMADEHREQ, RMADEHATE) as 'atendida'
       ,*
  from TBS1491 with (nolock)
 where RMAQTDATE > 0

select *
  from TBS1491 with (nolock)
 where PROCOD='6521894'

-- notas de entrada para uso consumo

select t.PROCOD
       ,sum(t.NFEQTD) as 'qtde'
  into #notas
  from (
          select d.*
            from TBS0591 d (nolock) 
           inner join TBS059 c (nolock)
              on d.NFEEMPCOD=c.NFEEMPCOD and d.NFETIP=c.NFETIP and d.NFENUM=c.NFENUM and d.NFECOD=c.NFECOD and d.SEREMPCOD=c.SEREMPCOD and d.SERCOD=c.SERCOD
           where c.NFECAN='N'
                 and c.NFEDATEFE between '20220801' and '20220831'
                 and d.NFECFOP in ('1.556','1.557')
       ) t
 group by t.PROCOD

drop table #requisicoes

select PROCOD
       ,sum(RMAQTDATE) as 'qtde'
  into #requisicoes
  from TBS1491 with (nolock)
 where RMADEHREQ <= '20220831'
       and RMADEHATE >= '20220801'
 group by PROCOD

select n.*
       ,r.*
  from #notas n
  full outer join #requisicoes r
    on n.PROCOD=r.PROCOD
 where n.qtde <> r.qtde

select c.NFECOD
       ,c.NFENOM
       ,count(*)
  from TBS0591 d (nolock) 
 inner join TBS059 c (nolock)
    on d.NFEEMPCOD=c.NFEEMPCOD and d.NFETIP=c.NFETIP and d.NFENUM=c.NFENUM and d.NFECOD=c.NFECOD and d.SEREMPCOD=c.SEREMPCOD and d.SERCOD=c.SERCOD
 where c.NFECAN='N'
       and c.NFEDATEFE between '20220801' and '20220831'
       and d.NFECFOP in ('1.556','1.557')
 group by c.NFECOD, c.NFENOM

select c.NFECOD
       ,c.NFENOM
       ,(select f.FORNOMFAN
           from TBS006 f with (nolock)
          where f.FORCOD=c.NFECOD
        )
       ,count(*) as 'qtde_nf'
       /*,sum((select count(*)
           from TBS0591 d with (nolock)
          where d.NFEEMPCOD=c.NFEEMPCOD
                          and d.NFETIP=c.NFETIP
                          and d.NFENUM=c.NFENUM
                          and d.NFECOD=c.NFECOD
                          and d.SEREMPCOD=c.SEREMPCOD
                          and d.SERCOD=c.SERCOD
                          and d.NFECFOP in ('1.556','1.557')
                          --group by d.NFEEMPCOD, d.NFETIP, d.NFENUM, d.NFECOD, d.SEREMPCOD, d.SERCOD
        )) as 'qtde_itens'*/
  from TBS059 c (nolock) 
 where c.NFECAN='N'
       and c.NFEDATEFE between '20220801' and '20220831'
       and exists (select 'ex'
                     from TBS0591 d with (nolock)
                    where d.NFEEMPCOD=c.NFEEMPCOD
                          and d.NFETIP=c.NFETIP
                          and d.NFENUM=c.NFENUM
                          and d.NFECOD=c.NFECOD
                          and d.SEREMPCOD=c.SEREMPCOD
                          and d.SERCOD=c.SERCOD
                          and d.NFECFOP in ('1.556','1.557')
                  )
 group by c.NFECOD, c.NFENOM

-- produtos atendidos

select *
  from TBS1491 i with (nolock)
  inner join TBS149 c with (nolock)
     on c.RMAEMPCOD=i.RMAEMPCOD
        and c.RMADOC=i.RMADOC
  where i.RMADEHATE between '20240101' and '20240229'
