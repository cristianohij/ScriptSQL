select top(100) *
  from TBS037 with (nolock)
 order by MVIDATLAN desc


select c.MVIDATLAN
       ,c.MVIDATEFE
	   ,c.*
	   ,d.*
  from TBS037 d with (nolock)
       inner join TBS037 c with (nolock)
	      on c.MVIDOC=d.MVIDOC
 where c.MVIDATLAN='20230904'
       and c.MVITRM=2
	   and c.MVIPRIORI=0
 order by c.MVIDATLAN desc

select c.MVIDATLAN as 'lancamento'
       ,c.MVIDATEFE as 'efetivacao'
       ,datediff(d, c.MVIDATEFE,c.MVIDATLAN) as 'tempo_dia'
	   ,c.*
	   ,d.*
  from TBS037 d with (nolock)
       inner join TBS037 c with (nolock)
	      on c.MVIDOC=d.MVIDOC
 where c.MVIDATLAN='20230904'
       and c.MVITRM=2
	   and c.MVIPRIORI=0
 order by c.MVIDATLAN desc

select c.MVIDATLAN as 'lancamento'
       ,c.MVIDATEFE as 'efetivacao'
       ,datediff(d, c.MVIDATEFE,c.MVIDATLAN) as 'tempo_dia'
  from TBS037 d with (nolock)
       inner join TBS037 c with (nolock)
	      on c.MVIDOC=d.MVIDOC
 where c.MVIDATLAN between '20230801' and '20230830'
       and c.MVITRM=2
	   and c.MVIPRIORI=0
 group by c.MVIDATLAN
          ,c.MVIDATEFE
 order by c.MVIDATLAN desc
 
select c.MVIDATLAN as 'lancamento'
       ,c.MVIDATEFE as 'efetivacao'
       ,datediff(d, c.MVIDATEFE,c.MVIDATLAN) as 'tempo_dia'
  from TBS037 d with (nolock)
       inner join TBS037 c with (nolock)
	      on c.MVIDOC=d.MVIDOC
 where c.MVIDATLAN between '20230801' and '20230830'
       and c.MVITRM=2
	   and c.MVIPRIORI=0
 group by c.MVIDATLAN
          ,c.MVIDATEFE
 order by c.MVIDATLAN desc

select c.MVIDATEFE as 'efetivacao'
       ,count(*)
  from TBS037 c with (nolock)
 where c.MVIDATLAN between '20230801' and '20230830'
       and c.MVITRM=2
	   and c.MVIPRIORI=0
 group by c.MVIDATEFE
 order by c.MVIDATEFE

select UNICOD
       ,[TM] AS TM
       ,[BB] AS BB
       ,[MI] AS MI
       ,[PY] AS PY
FROM #unidades PIVOT (SUM(reg)
FOR empresa IN ([TM],[BB],[MI],[PY])) P
ORDER BY 1;

select p.MVIDATEFE as 'efetivacao'
	   ,[0] as 'urgente'
	   ,[1] as 'delivery'
	   ,[9] as 'normal'
  from TBS037 c with (nolock) pivot (sum(c.MVIPRIORI) for c.MVIPRIORI in ([0],[1],[9])) p
 where p.MVIDATEFE between '20230801' and '20230830'
       and p.MVITRM=2
  group by c.MVIDATEFE
  
 order by c.MVIDATEFE

SELECT Descricao, CodProduto,  [G ],[GG], [M ], [P ], [PP], [RN], [UN], [XG]
FROM 
     (SELECT P.Descricao, P.CodProduto, T.NomeTamanho,   SUM(IP.Quant) QTDETOTAL
        FROM Produtos P, GradeProdutos GP, Tamanhos T, ItensPedidos IP
       WHERE P.CodProduto = GP.CodProduto
             AND P.CodProduto = IP.CodProduto
             AND GP.CodTamanho = T.CodTamanho
             AND IP.CodTamanho = T.CodTamanho
             AND SUBSTRING(P.CodProduto, 1,2 ) = 'CL'
             AND SUBSTRING(P.CodProduto, 5,3 ) = '053'
             AND YEAR(P.DATA) >= 2012
       GROUP BY P.CodProduto, P.Descricao, T.NomeTamanho) sq
	   
PIVOT (SUM(QTDETOTAL) FOR NomeTamanho IN ([G ], [GG], [M ], [P ], [PP], [RN], [UN], [XG])) AS pt 
 
select c.MVIDATEFE as 'efetivacao'
       ,sum(case when c.MVIPRIORI=0 then 1 else 0 end) as 'urgente'
	   ,sum(case when c.MVIPRIORI=1 then 1 else 0 end) as 'delivery'
	   ,sum(case when c.MVIPRIORI=9 then 1 else 0 end) as 'normal'
  from TBS037 c with (nolock)
 where c.MVIDATEFE between '20230801' and '20230831'
       and c.MVITRM=2
 group by c.MVIDATEFE
 order by c.MVIDATEFE

select efetivacao
	   ,[0] as 'urgente'
	   ,[1] as 'delivery'
	   ,[9] as 'normal'
  from (select MVIDATEFE as 'efetivacao'
               ,MVIPRIORI as 'prioridade'
               ,count(*) as 'contador'
          from TBS037 with (nolock)
         where MVIDATEFE between '20230801' and '20230831'
               and MVITRM=2
         group by MVIPRIORI, MVIDATEFE) t
 pivot (sum(contador) for prioridade in ([0],[1],[9])) p














