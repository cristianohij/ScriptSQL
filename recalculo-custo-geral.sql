--if exists(select name from sysobjects where name='SP_RecalculoCusto' and type='P')
--   drop procedure [dbo].[SP_RecalculoCusto]
--go

--create procedure [dbo].[SP_RecalculoCusto] @anomes char(6) as -- @dataDe as date, @dataAte as date as
--	begin
--		declare @proxData date

--		update SALDOINICIAL
--			set CUSTO = case
--							when round
--							(
--								(
--									-- valor em estoque + valor de compras
--									case
--										when
--										( 
--											case when E1 > 0 then E1 else 0 end +
--											case when E2 > 0 then E2 else 0 end +
--											case when E3 > 0 then E3 else 0 end +
--											case when E4 > 0 then E4 else 0 end +
--											case when E7 > 0 then E7 else 0 end +
--											case when E9 > 0 then E9 else 0 end
--										) > 0
--										then 
--										(
--										   case when E1 > 0 then E1 else 0 end +
--										   case when E2 > 0 then E2 else 0 end +
--										   case when E3 > 0 then E3 else 0 end +
--										   case when E4 > 0 then E4 else 0 end +
--										   case when E7 > 0 then E7 else 0 end +
--										   case when E9 > 0 then E9 else 0 end
--										) * isnull(CUSTO,0) --+ isnull(VALENTRADA,0)
--										else 0 --isnull(CUSTO,0)
--									end
--									+ isnull(VALENTRADA,0)
--								)
--								-- dividido pela quantidade em estoque + quantidade de compras
--								/	case
--										when
--										(
--										  case when E1 > 0 then E1 else 0 end +
--										  case when E2 > 0 then E2 else 0 end +
--										  case when E3 > 0 then E3 else 0 end +
--										  case when E4 > 0 then E4 else 0 end +
--										  case when E7 > 0 then E7 else 0 end +
--										  case when E9 > 0 then E9 else 0 end
--										  + isnull(QTDENTRADA,0)
--										) > 0
--										then
--										(
--										  case when E1 > 0 then E1 else 0 end +
--										  case when E2 > 0 then E2 else 0 end +
--										  case when E3 > 0 then E3 else 0 end +
--										  case when E4 > 0 then E4 else 0 end +
--										  case when E7 > 0 then E7 else 0 end +
--										  case when E9 > 0 then E9 else 0 end
--										  + isnull(QTDENTRADA,0)
--										)
--										else 1
--									end
--								,6
--							) > 0
--							then
--								round
--								(
--									(
--										-- valor em estoque + valor de compras
--										case
--											when
--											( 
--												case when E1 > 0 then E1 else 0 end +
--												case when E2 > 0 then E2 else 0 end +
--												case when E3 > 0 then E3 else 0 end +
--												case when E4 > 0 then E4 else 0 end +
--												case when E7 > 0 then E7 else 0 end +
--												case when E9 > 0 then E9 else 0 end
--											) > 0
--											then
--											(
--												case when E1 > 0 then E1 else 0 end +
--												case when E2 > 0 then E2 else 0 end +
--												case when E3 > 0 then E3 else 0 end +
--												case when E4 > 0 then E4 else 0 end +
--												case when E7 > 0 then E7 else 0 end +
--												case when E9 > 0 then E9 else 0 end
--											) * isnull(CUSTO,0) --+ isnull(VALENTRADA,0)
--											else 0 --isnull(CUSTO,0)
--										end
--										+ isnull(VALENTRADA,0)
--								)
--								-- dividido pela quantidade em estoque + quantidade de compras
--								/	case
--										when
--										(
--											case when E1 > 0 then E1 else 0 end +
--											case when E2 > 0 then E2 else 0 end +
--											case when E3 > 0 then E3 else 0 end +
--											case when E4 > 0 then E4 else 0 end +
--											case when E7 > 0 then E7 else 0 end +
--											case when E9 > 0 then E9 else 0 end
--											+ isnull(QTDENTRADA,0)
--										) > 0
--										then
--										(
--											case when E1 > 0 then E1 else 0 end +
--											case when E2 > 0 then E2 else 0 end +
--											case when E3 > 0 then E3 else 0 end +
--											case when E4 > 0 then E4 else 0 end +
--											case when E7 > 0 then E7 else 0 end +
--											case when E9 > 0 then E9 else 0 end
--											+ isnull(QTDENTRADA,0)
--										)
--										else 1
--									end
--								,6)

--							else CUSTO

--						end

--			where ANOMES=@anomes -- and CODIGO='7881412'

--		set @proxData=(select top 1 DateAdd(mm, DateDiff(mm,0,DATA) + 1, 0) from SALDOINICIAL with (nolock) where ANOMES=@anomes) -- and CODIGO='7881412')

--		update SALDOINICIAL
--			set CUSTO=(select top 1 CUSTO from SALDOINICIAL b with (nolock) where b.DATA < @proxData and b.CODIGO=a.CODIGO and b.CUSTO > 0 order by b.ANOMES desc, b.CODIGO)
--			from SALDOINICIAL a
--			where DATA=@proxData -- and CODIGO='7881412'
--	end


--exec SP_RecalculoCusto '201903'

--declare @datai date, @dataf date, @comando varchar(50)

--select @datai='20190101', @dataf='20190901' -- at� o m�s fechado

--while @datai <= @dataf
--   begin
--      set @comando='exec SP_RecalculoCusto ''' + convert(char(6),@datai,112) + ''''
--      execute(@comando)

--      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
--   end



-- novo procedimento

--update SALDOINICIAL
--   set CUSTO=valor

--  from
--  (
--    select ANOMES periodo
--           ,CODIGO produto
--	       ,CUSTO valor
--      from cd.SIBD.dbo.SALDOINICIAL
--     where rtrim(ANOMES) + rtrim(CODIGO) collate sql_latin1_general_cp1_ci_as in(select rtrim(ANOMES) + rtrim(CODIGO)
--                                                                       from SALDOINICIAL with (nolock)
--                                                                      where CUSTO=0
--                                                                            and (E1 > 0 or E2 > 0 or E3 > 0 or E4 > 0 or E5 > 0 or E6 > 0 or E7 > 0 or E8 > 0 or E9 > 0)
--                                                                      group by ANOMES, CODIGO)
--           and CUSTO > 0
--   ) tab

-- where ANOMES=periodo collate sql_latin1_general_cp1_ci_as
--       and CODIGO=produto collate sql_latin1_general_cp1_ci_as


select DateAdd(mm, DateDiff(mm,0,'20191201') + 1, 0)
select DateAdd(mm, DateDiff(mm,0,'20191201') - 1, 0)

--select iif(A.E1 > 0, A.E1, 0) +
--	   iif(A.E2 > 0, A.E2, 0) +
--	   iif(A.E3 > 0, A.E3, 0) +
--	   iif(A.E4 > 0, A.E4, 0) +
--	   iif(A.E7 > 0, A.E7, 0) +
--	   iif(A.E9 > 0, A.E9, 0) estoque
--	   ,A.QTDENTRADA entrada
--	   ,(isnull(B.CUSTO,0)*(iif(A.E1>0,A.E1,0)+iif(A.E2>0,A.E2,0)+iif(A.E3>0,A.E3,0)+iif(A.E4>0,A.E4,0)+iif(A.E7>0,A.E7,0)+iif(A.E9>0,A.E9,0))+A.VALENTRADA) val_entradas
--	   ,iif(isnull(B.CUSTO,0)>0,iif(A.E1>0,A.E1,0)+iif(A.E2>0,A.E2,0)+iif(A.E3>0,A.E3,0)+iif(A.E4>0,A.E4,0)+iif(A.E7>0,A.E7,0)+iif(A.E9>0,A.E9,0),0)+A.QTDENTRADA est_compras
--	   ,iif(A.QTDENTRADA=0
--	           ,isnull(B.CUSTO,0)
--			   ,(isnull(B.CUSTO,0)*(iif(A.E1>0,A.E1,0)+iif(A.E2>0,A.E2,0)+iif(A.E3>0,A.E3,0)+iif(A.E4>0,A.E4,0)+iif(A.E7>0,A.E7,0)+iif(A.E9>0,A.E9,0))+A.VALENTRADA)
--			   / ((iif(isnull(B.CUSTO,0)>0,iif(A.E1>0,A.E1,0)+iif(A.E2>0,A.E2,0)+iif(A.E3>0,A.E3,0)+iif(A.E4>0,A.E4,0)+iif(A.E7>0,A.E7,0)+iif(A.E9>0,A.E9,0),0))+A.QTDENTRADA))
--	   ,A.*
--	   ,B.*
--  from SALDOINICIAL A with (nolock)
--  full outer join SALDOINICIAL B with (nolock)
--    on B.DATA=dateAdd(mm, dateDiff(mm,0,A.DATA) - 1, 0)
--	   and B.CODIGO=A.CODIGO
-- where --A.QTDENTRADA > 0
--       --and 
--	   A.CODIGO='5380879'
--	   --and A.ANOMES='201804'
-- order by A.ANOMES, A.CODIGO

--drop table #SALDOINICIAL

--select *
--  into #SALDOINICIAL
--  from SALDOINICIAL with (nolock)
-- where CODIGO in('5380879','5380893')

--begin tran
--update #SALDOINICIAL
--   set CUSTO=--novo_custo
--  --from
--  (
--  select top 1
--         --A.ANOMES periodo
--		 --,A.CODIGO produto
--		 iif(A.QTDENTRADA=0
--	           ,isnull(B.CUSTO,0)
--			   ,(isnull(B.CUSTO,0)*(iif(A.E1>0,A.E1,0)+iif(A.E2>0,A.E2,0)+iif(A.E3>0,A.E3,0)+iif(A.E4>0,A.E4,0)+iif(A.E7>0,A.E7,0)+iif(A.E9>0,A.E9,0))+A.VALENTRADA)
--			   / ((iif(isnull(B.CUSTO,0)>0,iif(A.E1>0,A.E1,0)+iif(A.E2>0,A.E2,0)+iif(A.E3>0,A.E3,0)+iif(A.E4>0,A.E4,0)+iif(A.E7>0,A.E7,0)+iif(A.E9>0,A.E9,0),0))+A.QTDENTRADA)) novo_custo
--  from #SALDOINICIAL A with (nolock)
--  full outer join #SALDOINICIAL B with (nolock)
--    on B.DATA=dateAdd(mm, dateDiff(mm,0,A.DATA) - 1, 0)
--	   and B.CODIGO=A.CODIGO
-- where --A.QTDENTRADA > 0
--	   A.ANOMES=base.ANOMES
--	   and A.CODIGO=base.CODIGO
-- order by A.ANOMES, A.CODIGO
-- ) --tab

-- from #SALDOINICIAL base
--where ANOMES='201710'

--  where ANOMES=periodo
--        and CODIGO=produto


--rollback tran

--select *
--  from #SALDOINICIAL
-- order by ANOMES

--update #SALDOINICIAL
--   set E9=0
-- from #SALDOINICIAL
--order by ANOMES, CODIGO


--SELECT 
--  ROW_NUMBER() OVER(ORDER BY name ASC) AS Row#,
--  name, recovery_model_desc
--FROM sys.databases 
--WHERE database_id < 5;


--select *
--  into SALDOINICIAL2
--  from SALDOINICIAL with (nolock)
-- where CODIGO='5380879'

--select *
--  from SALDOINICIAL2
-- order by ANOMES, CODIGO

--if exists(select name from sysobjects where name='SP_RecalculoCusto' and type='P')
--   drop procedure [dbo].[SP_RecalculoCusto]
--go

--create procedure [dbo].[SP_RecalculoCusto] @anomes char(6) as -- @dataDe as date, @dataAte as date as
--	begin
--		declare @proxData date, @codigo varchar(15);

--		update SALDOINICIAL
--		   set @codigo=CODIGO
--				,CUSTO =
--					round(
--					(
--						select top 1
--								iif
--								(	A.QTDENTRADA=0
--									,isnull(B.CUSTO,0)
--									,(isnull(B.CUSTO,0)*(iif(A.E1>0,A.E1,0)+iif(A.E2>0,A.E2,0)+iif(A.E3>0,A.E3,0)+iif(A.E4>0,A.E4,0)+iif(A.E7>0,A.E7,0)+iif(A.E9>0,A.E9,0))+A.VALENTRADA)
--									/ ((iif(isnull(B.CUSTO,0)>0,iif(A.E1>0,A.E1,0)+iif(A.E2>0,A.E2,0)+iif(A.E3>0,A.E3,0)+iif(A.E4>0,A.E4,0)+iif(A.E7>0,A.E7,0)+iif(A.E9>0,A.E9,0),0))+A.QTDENTRADA)
--								)
--						from SALDOINICIAL A with (nolock)
--							full outer join SALDOINICIAL B with (nolock)
--								on B.DATA=dateAdd(mm, dateDiff(mm,0,A.DATA) - 1, 0)
--									and B.CODIGO=A.CODIGO

--						where A.ANOMES=base.ANOMES
--								and A.CODIGO=base.CODIGO
--						order by A.ANOMES, A.CODIGO
--					)
--					,6)

--		from SALDOINICIAL base
--		where base.ANOMES=@anomes;

--		set @proxData=(select DateAdd(mm, DateDiff(mm,0,@anomes+'01') + 1, 0));

--		--print @proxData
--		print @codigo

--		update SALDOINICIAL
--			set CUSTO=round((select top 1 CUSTO from SALDOINICIAL b with (nolock) where b.DATA < @proxData and b.CODIGO=a.CODIGO and b.CUSTO > 0 order by b.ANOMES desc, b.CODIGO),6)
--			from SALDOINICIAL a
--			where a.DATA=@proxData
--					and a.CODIGO=@codigo
--					and a.QTDENTRADA=0;
--	end

--exec SP_RecalculoCusto '201707'

exec SP_RecalculoCusto '202002'

declare @datai date, @dataf date, @comando varchar(50)

select @datai='20240101', @dataf='20250201' -- at� o m�s fechado

while @datai <= @dataf
   begin
      set @comando='exec SP_RecalculoCusto ''' + convert(char(6),@datai,112) + ''''
      execute(@comando)

      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end

if exists(select name from sysobjects where name='SP_RecalculoCusto' and type='P')
   drop procedure [dbo].[SP_RecalculoCusto]
go

create procedure [dbo].[SP_RecalculoCusto] @periodo varchar(6) as
begin
	if object_id('tempdb.dbo.#SALDO') is not null
		drop table tempdb.dbo.#SALDO

	declare @registros int
			,@n int
			,@codigo varchar(15)
			,@custo_anterior decimal(12,6)
			,@data_anterior date
			,@proxima_data date
			,@custo_atual decimal(12,6)
			,@atualizado char(1)

	-- tabela tempor�ria do per�odo a ser processado

	select DATA
			,ANOMES
			,CODIGO
			,row_number() over(order by ANOMES, CODIGO) seq
		into #SALDO
		from SALDOINICIAL with (nolock)
		where ANOMES=@periodo
		order by ANOMES, CODIGO

	select @n=1, @registros=@@rowcount

	while @n <= @registros
	begin
		-- registro a ser processado
		select @codigo=CODIGO
				,@data_anterior=dateAdd(mm, dateDiff(mm,0,DATA) - 1, 0)
			from #SALDO
			where seq=@n

		-- custo anterior do registro processado
		set @custo_anterior=0

		select top 1
				@custo_anterior=isnull(CUSTO,0)
			from SALDOINICIAL with (nolock)
			where DATA <= @data_anterior
				and CODIGO=@codigo
			order by ANOMES desc, CODIGO

		-- se houver o custo anterior
		if @custo_anterior > 0
		begin
			-- atualiza o pre�o de custo do registro atual
			update SALDOINICIAL
				set CUSTO =
						round
						(
							(
								--iif
								--(	QTDENTRADA=0
								--	,isnull(@custo_anterior,0)
								--	,(isnull(@custo_anterior,0)*(iif(E1>0,E1,0)+iif(E2>0,E2,0)+iif(E3>0,E3,0)+iif(E4>0,E4,0)+iif(E7>0,E7,0)+iif(E9>0,E9,0))+VALENTRADA)
								--	/ ((iif(isnull(@custo_anterior,0)>0,iif(E1>0,E1,0)+iif(E2>0,E2,0)+iif(E3>0,E3,0)+iif(E4>0,E4,0)+iif(E7>0,E7,0)+iif(E9>0,E9,0),0))+QTDENTRADA)
								--)

								case when QTDENTRADA=0
									then isnull(@custo_anterior,0)
									else (isnull(@custo_anterior,0)
											* (case when E1 > 0 then E1 else 0 end		-- estoque
											+  case when E2 > 0 then E2 else 0 end		-- loja
											+  case when E3 > 0 then E3 else 0 end		-- kit escolar
											+  case when E4 > 0 then E4 else 0 end		-- defeito
											--+  case when E5 > 0 then E5 else 0 end		-- perdas #
											--+  case when E6 > 0 then E6 else 0 end		-- almoxarifado #
											+  case when E7 > 0 then E7 else 0 end		-- ocorr�ncia
											--+  case when E8 > 0 then E8 else 0 end		-- dep�sito ou cd #
											+  case when E9 > 0 then E9 else 0 end)		-- web
											+  VALENTRADA)
									/ (( case when isnull(@custo_anterior,0) > 0
											  then    case when E1 > 0 then E1 else 0 end
													+ case when E2 > 0 then E2 else 0 end
													+ case when E3 > 0 then E3 else 0 end
													+ case when E4 > 0 then E4 else 0 end
													--+ case when E5 > 0 then E5 else 0 end
													--+ case when E6 > 0 then E6 else 0 end
													+ case when E7 > 0 then E7 else 0 end
													--+ case when E8 > 0 then E8 else 0 end
													+ case when E9 > 0 then E9 else 0 end
											  else 0
										 end
									   )
									   + QTDENTRADA
									  )
								end
							)
						,6)
				from SALDOINICIAL
				where ANOMES=@periodo
				  	and CODIGO=@codigo;

			-- custo do produto que acabou de ser atualizado
			set @custo_atual=0

			select top 1
				   @custo_atual=CUSTO
			  from SALDOINICIAL with (nolock)
			 where ANOMES=@periodo
				   and CODIGO=@codigo
				   and CUSTO > 0
			 order by ANOMES, CODIGO

			if @custo_atual > 0
			begin
				-- se registro atualizado
				set @atualizado='N'

				-- pr�xima data a ser processada
				set @proxima_data=(select DateAdd(mm, DateDiff(mm,0,@periodo+'01') + 1, 0))

				update SALDOINICIAL
				   set CUSTO=@custo_atual
					   ,@atualizado='S'
				  from SALDOINICIAL
				 where DATA=@proxima_data
					   and CODIGO=@codigo
					   and QTDENTRADA=0;
			end
		end

		set @n += 1
	end
end



--select *
--  from #SALDO

--drop table #saldo

--select @@rowcount, *
--  from saldo

--print @registros

--select object_id('tempdb.dbo.#SALDO')

--select *
--  from SALDOINICIAL with (nolock)
-- where CODIGO='5380879'
-- order by ANOMES

-- zera os custos dos produtos sem compras

update SALDOINICIAL
   set CUSTO=0, QTDENTRADA=0, VALENTRADA=0, EMPRESA=''
 where EMPRESA<>''

update SALDOINICIAL
   set CUSTO=0
 where QTDENTRADA=0
       and CUSTO > 0


-- recalcula custo de acordo com a compra

update SALDOINICIAL
   set CUSTO=round(VALENTRADA/QTDENTRADA,6)
 where --CODIGO='0040150'
       --and
	   QTDENTRADA > 0

--select *
--  from SALDOINICIAL with (nolock)
-- where  CODIGO='0040150'
-- order by ANOMES


--select *
--  from sysservers

-- -- busca pre�os de compras em outra unidades

--begin tran
--update SALDOINICIAL
--   set CUSTO=valor

--  from
--  (
--    select ANOMES periodo
--           ,CODIGO produto
--	       ,CUSTO valor
--      from py.SIBD.dbo.SALDOINICIAL remoto
--     where rtrim(remoto.ANOMES) + rtrim(remoto.CODIGO) collate sql_latin1_general_cp1_ci_as in(select rtrim(base.ANOMES) + rtrim(base.CODIGO)
--                                                                       from SALDOINICIAL base with (nolock)
--                                                                      where base.CUSTO=0
--                                                                            and (base.E1 > 0 or base.E2 > 0 or base.E3 > 0 or base.E4 > 0 or base.E5 > 0 or base.E6 > 0 or base.E7 > 0 or base.E8 > 0 or base.E9 > 0)
--                                                                      group by base.ANOMES, base.CODIGO)
--           and remoto.CUSTO > 0
--   ) tab

-- where ANOMES=tab.periodo collate sql_latin1_general_cp1_ci_as
--       and CODIGO=tab.produto collate sql_latin1_general_cp1_ci_as

--commit tran
--rollback tran


-- SQL 2019 output INSERTED.* into @tab


--;WITH pessoaAux AS(
--  SELECT Id, Nome, Idade, ROW_NUMBER() over(order by nome asc) rowNumber
--  FROM pessoa 
--)
--UPDATE pessoa SET Ordem = rowNumber
--FROM pessoa p
--INNER JOIN pessoaAux pAux on p.Id = pAux.Id



-- busca custo m�dio em outras unidades

alter table SALDOINICIAL add EMPRESA char(2) default '' with values



if exists(select name from sysobjects where name='SP_BuscaCustoMedio' and type='P')
   drop procedure [dbo].[SP_BuscaCustoMedio]
go

create procedure [dbo].[SP_BuscaCustoMedio] as
begin
	if object_id('tempdb.dbo.#CODIGOS') is not null
		drop table tempdb.dbo.#CODIGOS

	if object_id('tempdb.dbo.#PRECOS') is not null
		drop table tempdb.dbo.#PRECOS

	declare @emp char(2)
			,@registros int
			,@n int
			,@ri int
			,@rf int
			,@codigo varchar(15)
			,@periodo varchar(6)
			,@custo decimal(12,6)
			,@i int
			,@aux int
			,@qent decimal(12,4)
			,@vent decimal(12,6)

	-- verifica qual a empresa processada
	set @emp = (select top 1
					   case right(EMPCGC,2) 
							when '56' then 'BB'
							when '37' then 'BB'
							when '50' then 'TC'
							when '17' then 'MI'
							when '36' then 'PY'
							when '98' then 'TM'
							when '79' then 'TT'
					   end
				  from TBS023 with (nolock))

	-- produtos que n�o possuem pre�o de entrada na empresa processada
	select A.CODIGO
	  into #CODIGOS
	  from SALDOINICIAL A with (nolock)
	 where isnull((select top 1
				  		  1
					 from SALDOINICIAL B with (nolock)
				    where B.CODIGO=A.CODIGO
						  and B.QTDENTRADA > 0
				    order by B.ANOMES, B.CODIGO),0) = 0
		   --and A.CODIGO='0061030'
	 group by CODIGO

	-- tabela com os pre�os dos produtos acima, em todas as empresas
	select empresa
			,periodo
			,codigo
			,custo
			,qentrada
			,ventrada
			,row_number() over(order by empresa, periodo desc, codigo) seq
		into #PRECOS
		from
		(
		select 'BB' empresa
			   ,ANOMES collate sql_latin1_general_cp1_ci_as periodo
			   ,CODIGO collate sql_latin1_general_cp1_ci_as codigo
			   ,CUSTO custo
			   ,QTDENTRADA qentrada
			   ,VALENTRADA ventrada
		  from bb2.SIBD2.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate sql_latin1_general_cp1_ci_as from #CODIGOS)
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
		  from mi.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate sql_latin1_general_cp1_ci_as from #CODIGOS)
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
		  from py.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate sql_latin1_general_cp1_ci_as from #CODIGOS)
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
		  from cd.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate sql_latin1_general_cp1_ci_as from #CODIGOS)
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
		  from nd.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate sql_latin1_general_cp1_ci_as from #CODIGOS)
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
		  from tt.SIBD.dbo.SALDOINICIAL
		 where CODIGO in(select CODIGO collate sql_latin1_general_cp1_ci_as from #CODIGOS)
			   and QTDENTRADA > 0
			   and CUSTO > 0
			   and EMPRESA=''

	    ) tab

	-- TANBY matriz

	if @emp = 'TM'
	begin
		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo			--collate sql_latin1_general_cp1_ci_as
					   and CODIGO=@codigo		--collate sql_latin1_general_cp1_ci_as
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY TAUBATE
		select @ri = min(seq)
			   ,@rf = max(seq)
		  from #PRECOS
		 where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo collate sql_latin1_general_cp1_ci_as
					   and CODIGO=@codigo collate sql_latin1_general_cp1_ci_as
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

--------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

--------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim TANBY MATRIZ

	-- MISASPEL

	if @emp = 'MI'
	begin
		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY taubate
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim MISASPEL

	-- BEST BAG

	if @emp = 'BB'
	begin
		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY taubate
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim BEST BAG

	-- PAPELYNA

	if @emp = 'PY'
	begin
		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY taubate
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim PAPELYNA

	-- TANBY CD

	if @emp = 'TC'
	begin
		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY taubate
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TT'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TT'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim TANBY CD

	-- TANBY taubate

	if @emp = 'TT'
	begin
		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY matriz
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TM'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TM'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- TANBY CD
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='TC'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='TC'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- BEST BAG
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='BB'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='BB'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- MISASPEL
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='MI'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='MI'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

		-- zera as vari�veis
		select @ri=0
				, @rf=0

		-- PAPELYNA
		select @ri = min(seq)
				,@rf = max(seq)
			from #PRECOS
			where empresa='PY'

		while @ri <= @rf
		begin
			-- zera as vari�veis
			select @periodo=''
				   ,@codigo=''
				   ,@custo=0
				   ,@qent=0
				   ,@vent=0

			-- registro a ser processado da tabela SALDOINICIAL
			select top 1
				   @periodo=sal.ANOMES
				   ,@codigo=pre.codigo
				   ,@custo=pre.custo
				   ,@qent=pre.qentrada
				   ,@vent=pre.ventrada
			  from SALDOINICIAL sal with (nolock)
			 inner join #PRECOS pre
				on sal.ANOMES >= pre.periodo collate sql_latin1_general_cp1_ci_as		-- ano/m�s maior/igual per�odo procurado
				   and sal.CODIGO = pre.codigo collate sql_latin1_general_cp1_ci_as
			 where sal.QTDENTRADA=0	-- sem entrada
				   and sal.CUSTO=0		-- sem custo
				   and pre.seq=@ri		-- registro atual
				   and isnull((select top 1
										  1
								from SALDOINICIAL busca with (nolock)
							   where busca.ANOMES < sal.ANOMES
									 and busca.CODIGO=sal.CODIGO
									 and busca.CUSTO > 0
							   order by busca.ANOMES desc),0) = 0
			 order by sal.ANOMES, sal.CODIGO

			if @@rowcount > 0
			begin
				update SALDOINICIAL
				   set CUSTO=@custo
					   ,QTDENTRADA=@qent
					   ,VALENTRADA=@vent
					   ,EMPRESA='PY'
				 where ANOMES=@periodo
					   and CODIGO=@codigo
			end

			-- pr�ximo registro
			set @ri += 1
		end

------

	end		-- fim TANBY taubate

end

exec SP_BuscaCustoMedio

-- analise

--update SALDOINICIAL
--   set CUSTO=0, QTDENTRADA=0, VALENTRADA=0, EMPRESA=''
-- where EMPRESA<>''
--
--update SALDOINICIAL
--   set CUSTO=0
-- where QTDENTRADA=0
--       and CUSTO > 0
	   
select *
  from SALDOINICIAL with (nolock)
 where CODIGO='1640054'
 order by ANOMES desc

-- tabela tempor�ria de pre�os

select *
  from SALDOINICIAL with (nolock)
 where CODIGO='0061030'
       and QTDENTRADA > 0
	   and CUSTO > 0
 order by ANOMES
 
-- fim


drop table #codigos
drop table #precos

	select A.CODIGO
	  into #codigos
	  from SALDOINICIAL A with (nolock)
	 where isnull((select top 1
							1
					from SALDOINICIAL B with (nolock)
					where --B.ANOMES=A.ANOMES
							B.CODIGO=A.CODIGO
							and B.QTDENTRADA > 0
					order by B.ANOMES, B.CODIGO),0) = 0
     group by CODIGO


select empresa
       ,periodo
	   ,codigo
	   ,custo
	   ,row_number() over(order by empresa, periodo desc, codigo) seq
  into #precos
  from
  (
select 'BB' empresa
       ,ANOMES collate sql_latin1_general_cp1_ci_as periodo
       ,CODIGO collate sql_latin1_general_cp1_ci_as codigo
	   ,CUSTO custo
  --into #precos
  from bb2.SIBD2.dbo.SALDOINICIAL
 where CODIGO in(select CODIGO from #codigos)
       and QTDENTRADA > 0
	   and CUSTO > 0

union

select 'MI'
       ,ANOMES
       ,CODIGO
	   ,CUSTO
  from mi.SIBD.dbo.SALDOINICIAL
 where CODIGO in(select CODIGO from #codigos)
       and QTDENTRADA > 0
	   and CUSTO > 0

 union

select 'PY'
       ,ANOMES 
       ,CODIGO
	   ,CUSTO
  from py.SIBD.dbo.SALDOINICIAL
 where CODIGO in(select CODIGO from #codigos)
       and QTDENTRADA > 0
	   and CUSTO > 0

 union

select 'TC'
       ,ANOMES
       ,CODIGO
       ,CUSTO
  from cd.SIBD.dbo.SALDOINICIAL
 where CODIGO in(select CODIGO collate sql_latin1_general_cp1_ci_as from #codigos)
       and QTDENTRADA > 0
	   and CUSTO > 0

 union

select 'TM'
       ,ANOMES
       ,CODIGO
       ,CUSTO
  from nd.SIBD.dbo.SALDOINICIAL
 where CODIGO in(select CODIGO from #codigos)
       and QTDENTRADA > 0
	   and CUSTO > 0

 union

select 'TT'
       ,ANOMES
       ,CODIGO
	   ,CUSTO
  from tt.SIBD.dbo.SALDOINICIAL
 where CODIGO in(select CODIGO from #codigos)
       and QTDENTRADA > 0
	   and CUSTO > 0
	   ) tab
  --order by empresa, periodo desc, codigo

--select @@ROWCOUNT

select @n=1, @registros=@@rowcount

while @n <= @registros
	begin

	end

select *
  from #precos
 where codigo='1640054'
       and empresa='TC'
 order by periodo desc

select min(seq)
       ,max(seq)
  from #precos
 where empresa='TC'

select *
  from SALDOINICIAL with (nolock)
 where CODIGO='1640054'
 order by ANOMES

declare @periodo char(6), @codigo varchar(15)

select @periodo=periodo
       ,@codigo=codigo
  from #precos
 where empresa in('TC') --,'TT')
       and seq=17121

select *
  from SALDOINICIAL with (nolock)
 where ANOMES <= @periodo
       and CODIGO=@codigo
       and QTDENTRADA=0
 order by ANOMES, CODIGO

select top 1
        *
  from SALDOINICIAL sal with (nolock)
 inner join #precos pre
    on sal.ANOMES >= pre.periodo
	   and sal.CODIGO = pre.codigo
 where sal.QTDENTRADA=0
       and sal.CUSTO=0
	and pre.seq=17121
  order by sal.ANOMES desc, sal.CODIGO

drop table #codigos

if exists(select name from sysobjects where name='SP_BuscaPrecoPolitica' and type='P')
   drop procedure [dbo].[SP_BuscaPrecoPolitica]
go

create procedure [dbo].[SP_BuscaPrecoPolitica] as
begin
	-- produtos que n�o possuem pre�o de entrada
	select A.CODIGO
		   ,A.DATA
		   ,row_number() over(order by A.DATA desc, A.CODIGO) seq
	  into #codigos
	  from SALDOINICIAL A with (nolock)
	 where A.CUSTO=0
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

exec SP_BuscaPrecoPolitica

select *
  from SALDOINICIAL base with (nolock)
  inner join #codigos cod on cod.DATA=base.DATA and cod.CODIGO=base.CODIGO

select * from #codigos

drop function CustoPolitica
go

create function CustoPolitica(@data date ,@produto varchar(15)) returns smallmoney as
   begin
		declare @retorno smallmoney
		set @retorno =
		(
			select round
			(
				PRECO
				-- descontos
				* case DESC1
					when 0 then 1
					else (100-DESC1)/100
					end
				* case DESC2
					when 0 then 1
					else (100-DESC2)/100
					end
				* case DESC3
					when 0 then 1
					else (100-DESC3)/100	
					end
				* case DESC4
					when 0 then 1
					else (100-DESC4)/100
					end
				* case DESC5
					when 0 then 1
					else (100-DESC5)/100
					end
			
				-- IPI
				* case IPI
					when 0 then 1
					else 1+IPI/100
					end
			
				-- ST
				* case ST
					when 0 then 1
					else 1+ST/100
					end

				-- frete
				* case FRETE
					when 0 then 1
					else 1+FRETE/100
					end
				/ EMB
			,6) CUSTO
			from
			(
				select PDPDATATU DATA
						,PDPCOD CODIGO
						,(select top 1 PDPPREFOR from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) PRECO
						,(select top 1 PDPPDD1 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC1
						,(select top 1 PDPPDD2 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC2
						,(select top 1 PDPPDD3 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC3
						,(select top 1 PDPPDD4 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC4
						,(select top 1 PDPPDD5 from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) DESC5
						,(select top 1 PDPIPI from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) IPI
						,(select top 1 PDPPORST from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) ST
						,(select top 1 PDPFRE from TBS015 busca with (nolock) where busca.PDPCOD=base.PDPCOD and busca.PDPDATATU<=base.PDPDATATU order by PDPDATATU desc, PDPCOD) FRETE
						,PDPQTDEMB EMB
					from TBS015 base with (nolock)
					where PDPDATATU <= @data
						and PDPCOD=@produto
					group by PDPDATATU, PDPCOD, PDPQTDEMB
			) tab
		)
                             
		return @retorno
	end
go

select dbo.CustoPolitica('20200630', '16530164')