-- retorna uma tabela de strings para inser��o dos c�digos de barras - nova vers�o

drop function TabelaCodigosBarrasDJ
go 

create function TabelaCodigosBarrasDJ(@empresa int)
returns @barras table (codigo varchar(15), barras varchar(20), embalagem smallmoney, preco smallmoney)
begin
	insert into @barras
	select rtrim(codigo) as codigo --+ ','  -- 1 C�digo do Produto Principal (PLU)
		   ,rtrim(barras) as barras --+ ','  -- 2 C�digo de Barras do Produto
		   ,Ltrim(str(embalagem,9,3)) as embalagem --+ ','  -- 4 M�ltiplos
		   ,Ltrim(str(preco,9,3)) as preco  -- 5 Pre�o de Venda
	  from
	  (
		-- unidade 1
		select CBPPROCOD codigo
			   ,CBPCODBAR barras
			   ,1 embalagem
			   ,(select preco1 from PrecoLoja(TBS0103.CBPEMP,TBS0103.CBPPROCOD)) preco
		  from TBS0103 with (nolock)
		 where CBPEMP=@empresa
			   and CBPQTDEMB=1
			   and isnull((select preco1 from PrecoLoja(TBS0103.CBPEMP,TBS0103.CBPPROCOD)),0) > 0
		union

		-- unidade 2
		select CBPPROCOD
			   ,CBPCODBAR
			   ,1
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
			   on TBS010.PROEMPCOD=TBS0103.CBPEMP 
			   and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPQTDEMB=TBS010.PROUM2QTD
			   and TBS010.PROUM2QTD not in(1,TBS010.PROUM3QTD,TBS010.PROUM4QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'2222'
			   ,1
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROUM2QTD > 1
		union

		-- unidade 3
		select CBPPROCOD
			   ,CBPCODBAR
			   ,1
			   ,(select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
				  on TBS010.PROEMPCOD=TBS0103.CBPEMP 
					 and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPQTDEMB=TBS010.PROUM3QTD
			   and TBS010.PROUM3QTD not in(1,TBS010.PROUM2QTD,TBS010.PROUM4QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'3333'
			   ,1
			   ,(select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROUM3QTD > 1
		union

		-- unidade 4
		select CBPPROCOD
			   ,CBPCODBAR
			   ,1
			   ,(select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
				  on TBS010.PROEMPCOD=TBS0103.CBPEMP 
					 and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPQTDEMB=TBS010.PROUM4QTD
			   and TBS010.PROUM4QTD not in(1,TBS010.PROUM2QTD,TBS010.PROUM3QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'4444'
			   ,PROUM4QTD
			   ,(select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROUM4QTD > 1
	  ) tab
	 where embalagem=1 or (embalagem > 1 and preco > 0)

	return
end
go

-- exemplo de uso
select *
  from dbo.TabelaCodigosBarrasDJ(0)

drop table barras

select distinct codigo
  into barras
  from dbo.TableCodigosBarrasGZ(0)


-- checagem

select *
  from PrecoLoja(0)


