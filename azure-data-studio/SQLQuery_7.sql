	select CODIGO
	  into #CODIGOS
	  from
	  (
		select CODIGO
		  from SALDOINICIAL with (nolock)
		 where QTDENTRADA = 0
	  ) tab
	 group by CODIGO

	-- tabela com os precos dos produtos acima, em todas as empresas
	select empresa
			,periodo
			,codigo
			,custo
			,qentrada
			,ventrada
			,unidade
			,embalagem
			,row_number() over(order by empresa, periodo desc, codigo) seq
		into #PRECOS
		from
		(
		select 'BB' empresa
			   ,ANOMES collate database_default periodo
			   ,CODIGO collate database_default codigo
			   ,CUSTO custo
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI collate database_default unidade
			   ,QEMBALAGEM embalagem
		  from bb.SIBD2.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

		union

		select 'MI'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from mi.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

			union

		select 'PY'
			   ,ANOMES 
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from py.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

			union

		select 'TC'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from cd.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

			union

		select 'TM'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from nd.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

			union

		select 'TT'
			   ,ANOMES
			   ,CODIGO
			   ,CUSTO
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
			   ,UNI unidade
			   ,QEMBALAGEM embalagem
		  from tt.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate database_default from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

	    ) tab

select *
  from #CODIGOS

select *
  from #PRECOS
 where codigo='26340001'
 order by periodo desc

select periodo
       ,codigo
       ,sum(ventrada)/sum(qentrada)
  from #PRECOS
 where codigo='26340001'
 group by periodo, codigo
 order by periodo desc

