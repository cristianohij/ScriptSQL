drop table #mov

select convert(char(6),TBS037.MVIDATEFE,112) anomes
       ,MVILOCORI origem
       ,MVILOCDES destino
       ,MVIQTDATD*MVIQTDEMB qtde
       ,case
           when isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=TBS0371.PROCOD
                               and CUSTO > 0
                         order by DATA desc),0) > 0
           then isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=TBS0371.PROCOD
                               and CUSTO > 0
                         order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,TBS0371.PROCOD),0)
        end custo
  into #mov
  from TBS0371 with (nolock)
       inner join TBS037 with (nolock) on TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC
 where TBS037.MVIDATEFE between '20190101' and '20190105'
       and (MVILOCORI=0 or MVILOCDES=0)

select * from #mov

-- entradas
select Left(anomes,4)+'/'+right(anomes,2) periodo
       ,str(sum(qtde*custo),12,2) custo
       ,count(*) ajustes
       ,(select LESDES from TBS034 with (nolock) where LESCOD=origem)
  from #mov
 where destino > 0
 group by anomes,origem --with rollup
order by anomes desc, origem

-- saidas
select Left(anomes,4)+'/'+right(anomes,2) periodo
       ,str(sum(qtde*custo),12,2) custo
       ,count(*) ajustes
       ,(select LESDES from TBS034 with (nolock) where LESCOD=destino)
  from #mov
 where origem > 0
 group by anomes,destino --with rollup
order by anomes desc, destino

select * from #mov where destino > 0

select * from #mov where origem > 0

-- transf 21
-- entradas 24
-- saidas 4
-- total 49

select TBS0371.*
  from TBS037 with (nolock)
       inner join TBS0371 with (nolock)
       on TBS0371.MVIDOC=TBS037.MVIDOC
 where MVIDATEFE between '20190101' and '20190131'
       and MVILOCORI > 0
       and MVILOCDES = 0

select TBS0371.*
  from TBS037 with (nolock)
       inner join TBS0371 with (nolock)
       on TBS0371.MVIDOC=TBS037.MVIDOC
 where MVIDATEFE between '20190101' and '20190131'
       and (MVILOCORI=0 or MVILOCDES=0)
       and PROCOD in
('0051594',
'0060259',
'14000008',
'14000009',
'15100008',
'1070029',
'99988643',
'4520012',
'4520040',
'0060077',
'4520526',
'3250389',
'3251237',
'3252256',
'4520701',
'7881243',
'25310002',
'8060024',
'8060304',
'8060362',
'8060366',
'8061004',
'2130393',
'1440012',
'1440017',
'1440063',
'1440187',
'1440225',
'1440325',
'1440879',
'1448177',
'7653247',
'7653248',
'7653249',
'7653255',
'7653259',
'7653261',
'7653268',
'7653269',
'3794753',
'1083678',
'1083774',
'8490574')

