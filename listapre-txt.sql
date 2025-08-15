select case
          when Left(PRODES,1)='A' then 1
		  when Left(PRODES,1)='B' then 2
		  when Left(PRODES,1)='C' then 3
	   end as 'Código da Lista'
	   ,PROCOD as 'Código do Produto (PLU)'
	   ,row_number() over(PARTITION BY Left(PRODES,1) order by Left(PRODES,1)) as 'Sequência (Ordem de Classificação)'
  from TBS010 with (nolock)
 where Left(PRODES,1) in('A','B','C')
 order by Left(PRODES,1)
