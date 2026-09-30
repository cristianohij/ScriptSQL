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

select @datai='20170101', @dataf='20250801' -- ate o mes fechado

while @datai <= @dataf
   begin
      set @comando='exec SP_RecalculoCusto ''' + convert(char(6),@datai,112) + ''''
      execute(@comando)

      set @datai=DateAdd(mm, DateDiff(mm,0,@datai) + 1, 0)
   end

select min([DATA])
  from SALDOINICIAL with (nolock)

select count(*)
  from SALDOINICIAL with (nolock)
 where CUSTO > 0

-- otimização chatGPT

-- O que podemos fazer é eliminar o loop e trabalhar de forma set-based (em lote), usando CROSS APPLY ou OUTER APPLY com uma subquery que busca o custo anterior.
-- Aqui está uma versão otimizada da sua procedure:

if exists(select name from sysobjects where name='SP_RecalculoCusto' and type='P')
   drop procedure [dbo].[SP_RecalculoCusto]
go

create procedure [dbo].[SP_RecalculoCusto] @periodo varchar(6) as
begin
    set nocount on;

    ;with CTE_SALDO as (
        select s.DATA,
               s.ANOMES,
               s.CODIGO,
               s.QTDENTRADA,
               s.VALENTRADA,
               s.E1, s.E2, s.E3, s.E4, s.E7, s.E9,
               s.CUSTO,
               -- pega o custo anterior (mês anterior válido)
               ca.CUSTO_ANTERIOR
        from SALDOINICIAL s with (nolock)
        outer apply (
            select top 1 si.CUSTO as CUSTO_ANTERIOR
            from SALDOINICIAL si with (nolock)
            where si.CODIGO = s.CODIGO
              and si.DATA < s.DATA
              and si.CUSTO > 0
            order by si.DATA desc
        ) ca
        where s.ANOMES = @periodo
    )
    update CTE_SALDO
       set CUSTO =
            case when QTDENTRADA = 0 then isnull(CUSTO_ANTERIOR, 0)
                 else round(
                        (
                          isnull(CUSTO_ANTERIOR,0) *
                          (isnull(E1,0)+isnull(E2,0)+isnull(E3,0)+isnull(E4,0)+isnull(E7,0)+isnull(E9,0))
                          + VALENTRADA
                        )
                        / (case when isnull(CUSTO_ANTERIOR,0) > 0
                                 then (isnull(E1,0)+isnull(E2,0)+isnull(E3,0)+isnull(E4,0)+isnull(E7,0)+isnull(E9,0))
                                 else 0
                           end + QTDENTRADA),
                        6)
            end
     where isnull(CUSTO,0) = 0; -- só atualiza os que estão zerados
     
    -- agora propaga para o próximo mês os custos zerados
    update s
       set CUSTO = si.CUSTO
    from SALDOINICIAL s
    inner join SALDOINICIAL si on si.CODIGO = s.CODIGO
                               and si.ANOMES = @periodo
                               and si.CUSTO > 0
    where s.DATA = dateadd(mm, datediff(mm,0,@periodo+'01')+1, 0)
      and s.QTDENTRADA = 0
      and isnull(s.CUSTO,0) = 0;
end
go

-- Garantir índices adequados
-- Para evitar bloqueios longos, crie índices que facilitem os acessos:

create index IX_SALDOINICIAL_CODIGO_DATA on SALDOINICIAL(CODIGO, DATA);
create index IX_SALDOINICIAL_ANOMES_CODIGO on SALDOINICIAL(ANOMES, CODIGO);

-- Versão otimizada (sem WHILE)

if exists(select name from sysobjects where name='SP_RecalculoCusto' and type='P')
   drop procedure [dbo].[SP_RecalculoCusto]
go

create procedure [dbo].[SP_RecalculoCusto]
   @datai date,
   @dataf date
as
begin
    set nocount on;

    ;with CTE_SALDO as (
        select s.DATA,
               s.ANOMES,
               s.CODIGO,
               s.QTDENTRADA,
               s.VALENTRADA,
               s.E1, s.E2, s.E3, s.E4, s.E7, s.E9,
               s.CUSTO,
               ca.CUSTO_ANTERIOR,
			   s.EMPRESA
        from SALDOINICIAL s with (nolock)
        outer apply (
            select top 1 si.CUSTO as CUSTO_ANTERIOR
            from SALDOINICIAL si with (nolock)
            where si.CODIGO = s.CODIGO
              and si.DATA <= s.DATA
              and si.CUSTO > 0
            order by si.DATA desc, si.EMPRESA
        ) ca
        where s.DATA between @datai and @dataf -- '20170101' and '20250801'
        --where s.DATA between '20170101' and '20250801'
		and s.CUSTO = 0
		--and s.CODIGO='0051063'
		
    )
    update CTE_SALDO
       set CUSTO =
            case when QTDENTRADA = 0 then isnull(CUSTO_ANTERIOR, 0)
                 else round(
                        (
                          isnull(CUSTO_ANTERIOR,0) *
                          (isnull(E1,0)+isnull(E2,0)+isnull(E3,0)+isnull(E4,0)+isnull(E7,0)+isnull(E9,0))
                          + VALENTRADA
                        )
                        / (case when isnull(CUSTO_ANTERIOR,0) > 0
                                 then (isnull(E1,0)+isnull(E2,0)+isnull(E3,0)+isnull(E4,0)+isnull(E7,0)+isnull(E9,0))
                                 else 0
                           end + QTDENTRADA),
                        6)
            end
     where isnull(CUSTO,0) = 0
     OPTION (MAXDOP 1); -- evita CXPACKET

    -- propaga custo para o mês seguinte (apenas os zerados e sem entrada)
    update s
       set CUSTO = si.CUSTO
    from SALDOINICIAL s
    inner join SALDOINICIAL si on si.CODIGO = s.CODIGO
                               and si.DATA between @datai and @dataf
                               and si.CUSTO > 0
    where s.DATA = dateadd(mm, datediff(mm,0,si.DATA)+1, 0)
      and s.QTDENTRADA = 0
      and isnull(s.CUSTO,0) = 0
      OPTION (MAXDOP 1);
end
go

exec SP_RecalculoCusto '20250801', '20250901';

select *
  from SALDOINICIAL with (nolock)
 where CODIGO = '0051063'
       and QTDENTRADA = 0