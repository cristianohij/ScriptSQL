drop table #produto

select case when KESPROCOD is null then PROCOD else KESPROCOD end as codigo,
       row_number() over (order by case when KESPROCOD is null then PROCOD else KESPROCOD end) as n,
       ESTQTDATU as qtde,
       case when KESPROCOD is null then 'N' else 'S' end as mov
  into #produto
  from TBS125 (nolock) full outer join TBS032 (nolock) on TBS125.KESPROCOD=TBS032.PROCOD
 where ESTLOC in(1,2) and ESTQTDATU <> 0 or KESPROCOD<>''

select codigo, count(*) from #produto group by codigo having count(*) > 1 order by codigo

delete #produto where qtde=0 and mov='N'

delete #produto
 where codigo in(select codigo from #produto group by codigo having count(*) > 1) and
       not n in(select min(n) from #produto group by codigo having count(*) > 1)

select * from #produto where codigo in('15370004','12130381','12130099','2881671','2880127','2880440')

select * from TBS032 (nolock) where PROCOD='2860440'


insert into #produto select '2860440',0,0,'N'

select count(*) from #produto

delete produto

insert into produto
select 'bb' as usuarioNome,
       --convert(int,Left(PROLOCFIS,2)) as produtoLote,
       1 as produtoLote,
       TBS010.PROCOD as produtoCodigo,
       GETDATE() as produtoDataLote,
       TBS010.PROCODBAR1 as produtoCodigoBarras,
       replace(TBS010.PRODES,'''','') as produtoDescricao,
       0 as produtoQtde,
       isnull((select replace(MARNOM,'''','') from TBS014 (nolock) where TBS014.MARCOD=TBS010.MARCOD),'') as produtoMarca,
       TBS010.PROUM1 + case when PROUM1QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM1QTD,6)) + ' ' + TBS010.PROUMV else '' end as produtoEmbalagem,
       null as produtoDataHora,
       null as produtoZerado,
       0 as produtoColetas,
       TBS010.PROUM2 + case when TBS010.PROUM2QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM2QTD,6)) else '' end as produtoEmbalagem2,
       TBS010.PROUM3 + case when TBS010.PROUM3QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM3QTD,6)) else '' end as produtoEmbalagem3,
       TBS010.PROUM4 + case when TBS010.PROUM4QTD > 1 then ' C/' + LTRIM(str(TBS010.PROUM4QTD,6)) else '' end as produtoEmbalagem4,
       0 as produtoQtde2,
       0 as produtoQtde3,
       0 as produtoQtde4,
       TBS010.PROCODBAR2 as produtoCodigoBarras2,
       TBS010.PROCODBAR3 as produtoCodigoBarras3,
       TBS010.PROCODBAR4 as produtoCodigoBarras4,
       'S' as produtoContagemUnitaria
  from TBS010 (nolock) inner join #produto on PROCOD=codigo
 --where Left(PROLOCFIS,2) in('01','02')
 --where TBS010.PROLOCFIS<>''
 where TBS010.PROLOCFIS4='1'

select * from #produto where not exists(select '' from TBS010 (nolock) where PROCOD=codigo)

select * from TBS010 (nolock) where PROCOD='2880440'

select count(*) from produto


-- 06/05/17

-- rodar na best bag

select case when KESPROCOD is null then PROCOD else KESPROCOD end as codigo,
       row_number() over (order by case when KESPROCOD is null then PROCOD else KESPROCOD end) as n,
       ESTQTDATU as qtde,
       case when KESPROCOD is null then 'N' else 'S' end as mov
  into #produto
  from TBS125 as T125 (nolock) full outer join TBS032 as T32 (nolock) on T125.KESPROCOD=T32.PROCOD
 where LESCOD in(1,2) or (ESTLOC in(1,2) and ESTQTDATU > 0)

--

-- rodar na papelyna e misaspel 

select case when KESPROCOD is null then PROCOD else KESPROCOD end as codigo,
       row_number() over (order by case when KESPROCOD is null then PROCOD else KESPROCOD end) as n,
       ESTQTDATU as qtde,
       case when KESPROCOD is null then 'N' else 'S' end as mov
  into #produto
  from TBS125 as T125 (nolock) full outer join TBS032 as T32 (nolock) on T125.KESPROCOD=T32.PROCOD
 where LESCOD=1 or (ESTLOC=1 and ESTQTDATU > 0)

delete #produto where qtde=0 and mov='N'

delete #produto
 where codigo in(select codigo from #produto group by codigo having count(*) > 1) and
       not n in(select min(n) from #produto group by codigo having count(*) > 1)

select count(*) from #produto

select 'insert into #produto select ''' + rtrim(codigo) + '''' from #produto

--

drop table #produto

select replicate(' ',15) as codigo into #produto 

delete #produto where codigo=''

select count(*) from #produto

select * from #produto

select codigo, count(*) from #produto group by codigo having count(*) > 1 order by codigo

select codigo as codigo,
       row_number() over (order by codigo) as n
  into #produto2
  from #produto

drop table #produto

select * into #produto from #produto2
  
drop table #produto2

