select p.PROCOD as 'codigo'
       ,p.PRODES as 'descricao'
       --,p.PROUM1 as 'unidade'
       --,p.MARNOM as 'marca'
       ,c.TDPPRECOR1 as 'preco'
       ,e.ESTQTDATU - e.ESTQTDRES as 'saldo'
  from TBS032 e with (nolock)
  inner join TBS010 p with (nolock)
     on p.PROCOD=e.PROCOD
  inner join TBS031 c with (nolock)
     on c.TDPPROCOD=e.PROCOD
 where e.ESTLOC=1
       and e.ESTQTDATU - e.ESTQTDRES > 0
       and e.MARCOD=47

union

select p.PROCOD collate database_default as 'codigo'
       ,p.PRODES collate database_default as 'descricao'
       ,c.TDPPRECOR1 as 'preco'
       ,e.ESTQTDATU - e.ESTQTDRES as 'saldo'
  from cd.SIBD.dbo.TBS032 e with (nolock)
  inner join cd.SIBD.dbo.TBS010 p with (nolock)
     on p.PROCOD=e.PROCOD
  inner join cd.SIBD.dbo.TBS031 c with (nolock)
     on c.TDPPROCOD=e.PROCOD collate database_default
 where e.ESTLOC=1
       and e.ESTQTDATU - e.ESTQTDRES > 0
       and e.MARCOD=47

oopp

select p.PROCOD as 'codigo'
       ,p.PRODES as 'descricao'
       ,p.PROUM1 as 'unidade'
       ,p.MARNOM as 'marca'
       ,c.TDPPRECOR1 as 'preco'
       --,e.ESTQTDATU - e.ESTQTDRES as 'saldo'
       ,(select sum(iif(x.ESTQTDATU - x.ESTQTDRES > 0, x.ESTQTDATU - x.ESTQTDRES, 0)) from SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC in (1,2) and x.PROCOD=e.PROCOD) as 'saldo_sjc'
       --,isnull((select x.ESTQTDATU - x.ESTQTDRES from cd.SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC=1 and x.PROCOD collate database_default=e.PROCOD),0) as 'saldo_cd'
       --,(select sum(iif(x.ESTQTDATU - x.ESTQTDRES > 0, x.ESTQTDATU - x.ESTQTDRES, 0)) from tt.SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC in (1,2) and x.PROCOD=e.PROCOD) as 'saldo_taubate'
       --,(select x.ESTQTDATU - x.ESTQTDRES from bb.SIBD2.dbo.TBS032 x with (nolock) where x.ESTLOC=2 and x.PROCOD=e.PROCOD) as 'saldo_best_bag'
       --,(select x.ESTQTDATU - x.ESTQTDRES from mi.SIBD3.dbo.TBS032 x with (nolock) where x.ESTLOC=1 and x.PROCOD=e.PROCOD) as 'saldo_misaspel'
       --,(select x.ESTQTDATU - x.ESTQTDRES from pp.SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC=1 and x.PROCOD=e.PROCOD) as 'saldo_papelyna'
  from SIBD.dbo.TBS032 e with (nolock)
  inner join SIBD.dbo.TBS010 p with (nolock)
     on p.PROCOD=e.PROCOD
  inner join SIBD.dbo.TBS031 c with (nolock)
     on c.TDPPROCOD=e.PROCOD
 where e.ESTLOC in (1,2)
       --and e.ESTQTDATU - e.ESTQTDRES > 0
       and e.MARCOD=47

select p.PROCOD as 'codigo'
       ,p.PRODES as 'descricao'
       ,p.PROUM1 as 'unidade'
       ,p.MARNOM as 'marca'
       ,c.TDPPRECOR1 as 'preco'
       ,(select sum(iif(x.ESTQTDATU - x.ESTQTDRES > 0, x.ESTQTDATU - x.ESTQTDRES, 0)) from SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC in (1,2) and x.PROCOD=p.PROCOD) as 'saldo_sjc'
       ,(select isnull(x.ESTQTDATU - x.ESTQTDRES, 0) from cd.SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC=1 and x.PROCOD collate database_default=p.PROCOD) as 'saldo_cd'
       --,(select sum(iif(x.ESTQTDATU - x.ESTQTDRES > 0, x.ESTQTDATU - x.ESTQTDRES, 0)) from tt.SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC in (1,2) and x.PROCOD=e.PROCOD) as 'saldo_taubate'
       --,(select x.ESTQTDATU - x.ESTQTDRES from bb.SIBD2.dbo.TBS032 x with (nolock) where x.ESTLOC=2 and x.PROCOD=e.PROCOD) as 'saldo_best_bag'
       --,(select x.ESTQTDATU - x.ESTQTDRES from mi.SIBD3.dbo.TBS032 x with (nolock) where x.ESTLOC=1 and x.PROCOD=e.PROCOD) as 'saldo_misaspel'
       --,(select x.ESTQTDATU - x.ESTQTDRES from pp.SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC=1 and x.PROCOD=e.PROCOD) as 'saldo_papelyna'
  from SIBD.dbo.TBS010 p with (nolock)
  inner join SIBD.dbo.TBS031 c with (nolock)
     on c.TDPPROCOD=p.PROCOD
 where p.MARCOD=47

select p.PROCOD as 'codigo'
       ,p.PRODES as 'descricao'
       ,p.PROUM1 as 'unidade'
       ,p.MARNOM as 'marca'
       ,c.TDPPRECOR1 as 'preco'
  into #produtos
  from TBS010 p with (nolock)
  inner join TBS031 c with (nolock)
     on c.TDPPROCOD=p.PROCOD
 where p.MARCOD=47

select *
       ,isnull((select sum(iif(x.ESTQTDATU - x.ESTQTDRES > 0, x.ESTQTDATU - x.ESTQTDRES, 0)) from TBS032 x with (nolock) where x.ESTLOC in (1,2) and x.PROCOD=p.codigo),0) as 'saldo_sjc'
       ,isnull((select isnull(x.ESTQTDATU - x.ESTQTDRES, 0) from cd.SIBD.dbo.TBS032 x with (nolock) where x.ESTLOC=1 and x.PROCOD=p.codigo collate database_default),0) as 'saldo_cd'
  from #produtos p

drop table #saldos

select e.PROCOD collate database_default as 'codigo'
       ,sum(iif(e.ESTQTDATU - e.ESTQTDRES > 0, e.ESTQTDATU - e.ESTQTDRES, 0)) as 'saldo'
       ,'nd' as 'empresa'
  into #saldos
  from TBS032 e with (nolock)
 where e.ESTLOC in (1,2)
       and Left(PROCOD,3)='047'
	    and Len(PROCOD)=7
 group by e.PROCOD 

union

select e.PROCOD collate database_default
       ,sum(iif(e.ESTQTDATU - e.ESTQTDRES > 0, e.ESTQTDATU - e.ESTQTDRES, 0))
       ,'cd'
  from cd.SIBD.dbo.TBS032 e with (nolock)
 where e.ESTLOC=1
       and Left(PROCOD,3)='047'
	    and Len(PROCOD)=7
 group by e.PROCOD 

union

select e.PROCOD
       ,sum(iif(e.ESTQTDATU - e.ESTQTDRES > 0, e.ESTQTDATU - e.ESTQTDRES, 0))
       ,'tt'
  from tt.SIBD.dbo.TBS032 e with (nolock)
 where e.ESTLOC in (1,2)
       and Left(PROCOD,3)='047'
	    and Len(PROCOD)=7
 group by e.PROCOD 

union 

select e.PROCOD
       ,sum(iif(e.ESTQTDATU - e.ESTQTDRES > 0, e.ESTQTDATU - e.ESTQTDRES, 0))
       ,'bb'
  from bb.SIBD2.dbo.TBS032 e with (nolock)
 where e.ESTLOC in (1,2)
       and Left(PROCOD,3)='047'
	    and Len(PROCOD)=7
 group by e.PROCOD 

union 

select e.PROCOD
       ,sum(iif(e.ESTQTDATU - e.ESTQTDRES > 0, e.ESTQTDATU - e.ESTQTDRES, 0))
       ,'mi'
  from mi.SIBD3.dbo.TBS032 e with (nolock)
 where e.ESTLOC=1
       and Left(PROCOD,3)='047'
	    and Len(PROCOD)=7
 group by e.PROCOD 

union 

select e.PROCOD
       ,sum(iif(e.ESTQTDATU - e.ESTQTDRES > 0, e.ESTQTDATU - e.ESTQTDRES, 0))
       ,'pp'
  from pp.SIBD.dbo.TBS032 e with (nolock)
 where e.ESTLOC=1
       and Left(PROCOD,3)='047'
	    and Len(PROCOD)=7
 group by e.PROCOD 


select *
  from #saldos

  poipipi

drop table #saldos_empresas

select codigo
       ,[cd] as 'cd'
       ,[tt] as 'tt'
       ,[bb] as 'bb'
       ,[mi] as 'mi'
       ,[nd] as 'nd'
       ,[pp] as 'pp'
  into #saldos_empresas
  from #saldos
 pivot (sum(saldo)
   for empresa in ([cd],[bb],[mi],[nd],[pp],[tt])) p
 order by 1

select *
  from #saldos_empresas
  
select *
  from #produtos p
  Left join #saldos_empresas s
    on s.codigo=p.codigo
