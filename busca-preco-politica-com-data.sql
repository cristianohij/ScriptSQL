if exists(select name from sysobjects where name='SP_BuscaPrecoPolitica' and type='P')
   drop procedure [dbo].[SP_BuscaPrecoPolitica]
go

create procedure [dbo].[SP_BuscaPrecoPolitica] @anomes char(6) as
begin
	-- produtos que não possuem preço de entrada
	select A.CODIGO
		   ,A.DATA
		   ,row_number() over(order by A.DATA desc, A.CODIGO) seq
	  into #codigos
	  from SALDOINICIAL A with (nolock)
	 where A.ANOMES <= @anomes
	       and A.CUSTO=0
		   and isnull((select top 1
							  1
						 from SALDOINICIAL B with (nolock)
						where B.CODIGO=A.CODIGO
							  and B.QTDENTRADA > 0
						order by B.ANOMES, B.CODIGO),0) = 0
		 group by A.DATA, A.CODIGO
--	 order by A.DATA desc, A.CODIGO

	update SALDOINICIAL
	   set CUSTO=dbo.CustoPolitica(base.DATA, base.CODIGO)
	  from SALDOINICIAL base with (nolock)
	  inner join #codigos cod on cod.DATA=base.DATA and cod.CODIGO=base.CODIGO
end

exec SP_BuscaPrecoPolitica '202011'
