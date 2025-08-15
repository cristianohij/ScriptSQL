select top 1 * from TBS037 with (nolock)

select top 1 * from TBS0371 with (nolock)

select * from TBS0371 with (nolock) where MVIQTDEMB > 1

select *,
       (select top 1 custo from CUSTOAQUISICAO with (nolock)
         where empresa in('TM','MT','MG') and
               str(ano,4)+right('00'+Ltrim(str(mes,2)),2) <= convert(char(6),TBS037.MVIDATEFE,112) and produto=TBS0371.PROCOD order by empresa, ano desc, mes desc, produto)
  from TBS0371 with (nolock)
       inner join TBS037 with (nolock) on TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC
 where TBS037.MVIDATEFE between '20180101' and '20180831'
       and (MVILOCORI=0 or MVILOCDES=0)

select top 1000 * from CUSTOAQUISICAO with (nolock)

select * from CUSTOAQUISICAO with (nolock) where produto in('18160097','18160097')

select top 100 str(ano,4)+right('00'+Ltrim(str(mes,2)),2) --<= str(year(@dataDe),4)+right('00'+Ltrim(str(month(@dataDe),2)),2)
  from CUSTOAQUISICAO with (nolock) where produto in('18160097','18160097')

select top 1 convert(char(6),MVIDATEFE,112),* from TBS037 with (nolock)

drop table #mov

select convert(char(6),TBS037.MVIDATEFE,112) anomes,
       MVILOCORI origem,
       MVILOCDES destino,
       MVIQTDATD*MVIQTDEMB qtde,
       (select top 1 custo from CUSTOAQUISICAO with (nolock)
         where empresa in('PP','MS','MG') and
               str(ano,4)+right('00'+Ltrim(str(mes,2)),2) <= convert(char(6),TBS037.MVIDATEFE,112) and produto=TBS0371.PROCOD order by empresa, ano desc, mes desc, produto) custo
  into #mov
  from TBS0371 with (nolock)
       inner join TBS037 with (nolock) on TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC
 where TBS037.MVIDATEFE between '20180901' and '20180930'
       and (MVILOCORI=0 or MVILOCDES=0)

select * from #mov

select anomes,origem,destino,sum(qtde*custo) from #mov group by anomes,origem,destino order by anomes,origem,destino

select * from TBS034 with (nolock)

-- entradas
select Left(anomes,4)+'/'+right(anomes,2) periodo,str(sum(qtde*custo),12,2) custo,count(*) ajustes, (select LESDES from TBS034 with (nolock) where LESCOD=origem)
  from #mov
 where origem > 0
 group by anomes,origem with rollup
order by anomes desc, origem

-- saidas
select Left(anomes,4)+'/'+right(anomes,2) periodo,str(sum(qtde*custo),12,2) custo,count(*) ajustes, (select LESDES from TBS034 with (nolock) where LESCOD=destino)
  from #mov
 where destino > 0
 group by anomes,destino with rollup
order by anomes desc, destino


select * from TBS037 with (nolock) where MVIOBS Like('%INVENTARIO%')


select MVIQTDATD,
       (select top 1 custo from CUSTOAQUISICAO with (nolock)
         where empresa in('TM','MT','MG') and
               str(ano,4)+right('00'+Ltrim(str(mes,2)),2) <= convert(char(6),TBS037.MVIDATEFE,112) and produto=TBS0371.PROCOD order by empresa, ano desc, mes desc, produto),
       MVIQTDATD*
       (select top 1 custo from CUSTOAQUISICAO with (nolock)
         where empresa in('TM','MT','MG') and
               str(ano,4)+right('00'+Ltrim(str(mes,2)),2) <= convert(char(6),TBS037.MVIDATEFE,112) and produto=TBS0371.PROCOD order by empresa, ano desc, mes desc, produto),
       *
  from TBS0371 with (nolock)
       inner join TBS037 with (nolock) on TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC
 where TBS037.MVIDATEFE between '20180601' and '20180630'
       and MVILOCORI > 0
 order by TBS0371.MVIQTDATD desc

select * from TBS049 with (nolock) where MDSLAN between '20180101' and '20180831'