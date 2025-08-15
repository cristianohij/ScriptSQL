if exists(select name from sysobjects where name='SP_RecalculoCusto' and type='P')
   drop procedure [dbo].[SP_RecalculoCusto]
go

create procedure [dbo].[SP_RecalculoCusto] @periodo varchar(6) as
begin
	--set nocount on

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

	--declare @msg varchar(1000)
	--set @msg = 'Conta registros do período a ser processado - ' + convert(NVARCHAR, getdate(), 8)
	--raiserror (@msg, 0, 1) with nowait

	--set nocount off

	select DATA
			,ANOMES
			,CODIGO
			,row_number() over(order by ANOMES, CODIGO) seq
		into #SALDO
		from SALDOINICIAL with (nolock)
		where ANOMES=@periodo
		order by ANOMES, CODIGO

	--set @msg = 'Fim - ' + convert(NVARCHAR, getdate(), 8)
	--raiserror (@msg, 0, 1) with nowait
	
	select @n=1, @registros=@@rowcount

	--set nocount on

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
			--set @msg = 'Processa registro - ' + convert(NVARCHAR, getdate(), 8)
			--raiserror (@msg, 0, 1) with nowait

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

	--set @msg = 'Fim - ' + convert(NVARCHAR, getdate(), 8)
	--raiserror (@msg, 0, 1) with nowait
end

exec SP_RecalculoCusto '202003'

declare @datai date, @dataf date, @comando varchar(50)

select @datai='20240901', @dataf='20240901' -- ate o mes fechado

while @datai <= @dataf
   begin
      set @comando='exec SP_RecalculoCusto ''' + convert(char(6),@datai,112) + ''''
      execute(@comando)

      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end

select min([DATA])
  from SALDOINICIAL with (nolock)

