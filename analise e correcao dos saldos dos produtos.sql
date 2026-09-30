-- verifica quantidade pendentes
select * from TBS032 e (noLock)
 where e.ESTLOC=1 and e.ESTQTDPEN <> (select isNull(sum(PRPQTD*PRPQTDEMB),0)
                                        from TBS058 p with (nolock)
                                       where p.PRPSIT='P'
                                             and p.PRPESTLOC=e.ESTLOC
                                             and p.PRPMOVEST='S'
                                             and p.PROCOD=e.PROCOD)
                                     +
                                     (select isnull(sum(((SDCQTDPED-(SDCQTDATD+SDCQTDRES))*s.SDCQTDEMB)),0)
                                        from TBS0761 s with (nolock)
                                       where s.LESCOD=e.ESTLOC
                                             and s.PROCOD=e.PROCOD
                                             and s.SDCPEN='S')
 order by e.PROCOD

-- otimizado

SELECT e.*
FROM TBS032 e WITH (NOLOCK)
LEFT JOIN (
    SELECT PRPESTLOC, PROCOD, 
           SUM(PRPQTD * PRPQTDEMB) AS TotalSaidas
    FROM TBS058 WITH (NOLOCK)
    WHERE PRPSIT = 'P' AND PRPMOVEST = 'S'
    GROUP BY PRPESTLOC, PROCOD
) p ON e.ESTLOC = p.PRPESTLOC AND e.PROCOD = p.PROCOD
LEFT JOIN (
    SELECT LESCOD, PROCOD, 
           SUM((SDCQTDPED - (SDCQTDATD + SDCQTDRES)) * SDCQTDEMB) AS TotalPedidos
    FROM TBS0761 WITH (NOLOCK)
    WHERE SDCPEN = 'S'
    GROUP BY LESCOD, PROCOD
) s ON e.ESTLOC = s.LESCOD AND e.PROCOD = s.PROCOD
WHERE e.ESTLOC = 2 
AND e.ESTQTDPEN <> COALESCE(p.TotalSaidas, 0) + COALESCE(s.TotalPedidos, 0);

-- update

begin tran
UPDATE e
SET e.ESTQTDPEN = COALESCE(p.TotalSaidas, 0) + COALESCE(s.TotalPedidos, 0)
FROM TBS032 e
LEFT JOIN (
    SELECT PRPESTLOC, PROCOD, 
           SUM(PRPQTD * PRPQTDEMB) AS TotalSaidas
    FROM TBS058 WITH (NOLOCK)
    WHERE PRPSIT = 'P' AND PRPMOVEST = 'S'
    GROUP BY PRPESTLOC, PROCOD
) p ON e.ESTLOC = p.PRPESTLOC AND e.PROCOD = p.PROCOD
LEFT JOIN (
    SELECT LESCOD, PROCOD, 
           SUM((SDCQTDPED - (SDCQTDATD + SDCQTDRES)) * SDCQTDEMB) AS TotalPedidos
    FROM TBS0761 WITH (NOLOCK)
    WHERE SDCPEN = 'S'
    GROUP BY LESCOD, PROCOD
) s ON e.ESTLOC = s.LESCOD AND e.PROCOD = s.PROCOD
WHERE e.ESTLOC = 2
AND e.ESTQTDPEN <> COALESCE(p.TotalSaidas, 0) + COALESCE(s.TotalPedidos, 0);

rollback tran
commit tran

--

begin tran
update TBS032 set ESTQTDPEN = (select isNull(sum(PRPQTD*PRPQTDEMB),0) from TBS058
                                   where PRPSIT='P' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
  from TBS032 
 where ESTLOC=1 and ESTQTDPEN <> (select isNull(sum(PRPQTD*PRPQTDEMB),0) from TBS058
                                   where PRPSIT='P' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
commit tran
-- fim


-- verifica quantidade reservadas
select * from TBS032 (noLock)
 where ESTLOC=2 and ESTQTDRES <> (select isNull(sum(PRPQTD*PRPQTDEMB),0) from TBS058
                                   where PRPSIT='R' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
 order by PROCOD

begin tran
update TBS032 set ESTQTDRES = (select isNull(sum(PRPQTD*PRPQTDEMB),0) from TBS058 (noLock)
                                   where PRPSIT='R' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)
  from TBS032 
 where ESTLOC=2 and ESTQTDRES <> (select isnull(sum(PRPQTD*PRPQTDEMB),0) from TBS058 (noLock)
                                   where PRPSIT='R' and PRPESTLOC=ESTLOC and PRPMOVEST='S' and TBS058.PROCOD=TBS032.PROCOD)

rollback tran
commit tran
-- fim


-- verifica quantidade comprada
-- elimina tabela temporaria
drop view COMPRAS

-- cria tabela temporaria
create view COMPRAS as
select TBS0451.PROCOD,LESCOD,isNull(sum((PDCQTD-(PDCQTDENT+PDCQTDRES))*PDCQTDEMB),0) as 'PENDENTE',TBS032.ESTQTDCMP
  from TBS0451 (noLock) join TBS032 (noLock) on ESTLOC=LESCOD and TBS0451.PROCOD=TBS032.PROCOD
 group by TBS0451.PROCOD,LESCOD,TBS032.ESTQTDCMP
having isNull(sum((PDCQTD-(PDCQTDENT+PDCQTDRES))*PDCQTDEMB),0) <> ESTQTDCMP
-- order by TBS0451.PROCOD

select * from COMPRAS

-- atualiza quantidade compras
begin tran
update TBS032 set ESTQTDCMP=PENDENTE
  from COMPRAS join TBS032 (noLock) on COMPRAS.PROCOD=TBS032.PROCOD and LESCOD=ESTLOC

-- confirma
commit tran

-- fim


select * from TBS0451 where PDCQTD < PDCQTDENT + PDCQTDRES

select * from TBS0451 where not exists(select 'ne' from TBS032 where 


select sum((PDCQTD-PDCQTDENT)*PDCQTDEMB) from TBS0451 where LESCOD=1 and PROCOD='1440152'

select isNull(sum((PDCQTD-PDCQTDENT)*PDCQTDEMB),0) from TBS0451


select * from TBS032 (noLock) where ESTQTDATU < 0

begin tran
update TBS032 set ESTQTDATU=0 where ESTQTDATU < 0
commit tran

select *
  from TBS058 pr with (nolock)
 where not exists (select 'ne' from TBS0551 pd with (nolock) where pd.PDVNUM = pr.PRPNUM and pd.PROCOD = pr.PROCOD)

begin tran
delete TBS058
  from TBS058 pr with (nolock)
 where not exists (select 'ne' from TBS0551 pd with (nolock) where pd.PDVNUM = pr.PRPNUM and pd.PROCOD = pr.PROCOD)

rollback tran
commit tran

select *
  from TBS058 
 where PROCOD = '36320001'


 -- ajustes de pendências e reservas

 -- Sql - Ajuste de reserva (update + log + email)

--declare @estoque int 
--set @estoque = 1

-- Faz o ajuste na reserva, caso a quantidade reservada de:  pedido de venda + movimentos internos + solicitação de compras, seja diferente da gravada na TBS032. 
-- Grava log na TBS051 e manda e-mail dos produtos ajustados ou se houver algum erro no select. 
-- Só irá mandar e-mail se houve ajuste em algum produto.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Sql - Ajuste de reserva (update + log + email)

declare @sqlEmail varchar(8000), @registroInicial int

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Tabela temporaria para os itens reservados

begin tran 

begin try  

if object_id('tempdb.dbo.#Reservas') is not null 
begin 
	drop table #Reservas
end

create table #Reservas(
rank int identity(1,1), 
empresa tinyint not null default 0, 
localEstoque tinyint not null default 0, 
codigo char(15) not null default '',
unidade1 varchar(3),
quantidadeAtual money default 0,
quantidadeReserva money default 0,
quantidadePendente money default 0,
quantidadeCompra money default 0, 
quantidadePedidoVenda money default 0,
quantidadeSolicitacaoCompra money default 0,
quantidadeMovimentoInterno money default 0,

constraint i#Reservas primary key(rank, empresa, localEstoque, codigo))

-- SELECT * FROM #Reservas

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Pedido de vendas, pega os produtos da TBS058 que estão movimentando o estoque.

if object_id('tempdb.dbo.#PedidoVendas') is not null
begin
	drop table #PedidoVendas  
end

select 
PRPEMP as empresa,
PRPESTLOC as localEstoque,
PROCOD as codigo,
sum(PRPQTD * PRPQTDEMB) AS quantidade

into #PedidoVendas
from TBS058 (nolock)

where 
PRPSIT = 'R' and 
PRPMOVEST = 'S' 

group by  
PRPEMP,
PRPESTLOC,
PROCOD 

-- SELECT * FROM #PedidoVenda
-- SELECT * FROM TBS058 (NOLOCK) WHERE PROCOD = '8490244'

-------------------------------------------------------

-- SOLICITAÇÃO DE COMPRAS, PEGA OS PRODUTOS QUE ESTÃO RESERVADO

if object_id('tempdb.dbo.#SolicitacaoCompras') is not null
begin
	drop table #SolicitacaoCompras
end

select
SDCEMPCOD as empresa, 
LESCOD as localEstoque,
PROCOD as codigo,
sum((SDCQTDATD - SDCQTDBAI) * SDCQTDEMB) AS quantidade

into #SolicitacaoCompras
from TBS0761 (nolock)

where 
SDCQTDRES = 0 and -- Se estiver com residuo siginifica que não está reservado
SDCQTDATD - SDCQTDBAI > 0 -- quantidade atendida - quantidade baixada > 0, tem algo reservado.

group by  
SDCEMPCOD, 
LESCOD,
PROCOD

-- select * from #SolicitacaoCompras

---------------------------------------------------------------------------------------

-- Pegar primeiros somente os cabeçalhos que não foram efetivados 

if object_id('tempdb.dbo.#CabecalhoMovimentosInternos') is not null
begin
	drop table #CabecalhoMovimentosInternos 
end

select 
MVIEMPCOD,
MVIDOC,
MVILOCORI

into #CabecalhoMovimentosInternos
from TBS037 A (nolock)
inner join TBS033 B (nolock) on A.TMVEMPCOD=B.TMVEMPCOD and A.TMVCOD=B.TMVCOD and B.TMVMOVAUT='N' and B.TMVTIP='S' -- TMVMOVAUT='N' - GERA UMA RESERVA, TMVTIP='S' - SAIDA

where 
A.MVIDATEFE = '17530101'

---------------------------------------------------------------------------------------

-- Movimentos internos, todos os produtos que ainda não foram efetivados estão reservados

if object_id('tempdb.dbo.#MovimentosInternos') is not null
begin
	drop table #MovimentosInternos 
end

select 
A.MVIEMPCOD as empresa,
A.MVILOCORI as localEstoque, 
PROCOD as codigo,
sum(B.MVIQTDPED*B.MVIQTDEMB) as quantidade

into #MovimentosInternos
from #CabecalhoMovimentosInternos A (nolock) 
inner join TBS0371 B (nolock) on A.MVIEMPCOD=B.MVIEMPCOD and A.MVIDOC=B.MVIDOC 
 
group by  
A.MVIEMPCOD,
A.MVILOCORI, 
PROCOD 

-- Select * from #MovimentosInternos WHERE PROCOD IN ('8490244','8490252')
-- select * from  TBS033

-------------------------------------------------------------------------------------------------------------------

-- Informacões basicas dos proutos para poder realizar as movimentações corretamente (TBS010)

if object_id('tempdb.dbo.#Produtos') is not null
begin
	drop table #Produtos 
end

select 
PROEMPCOD as empresa,
PROCOD as codigo,
PROUM1 as unidade1,
PROPESAVEL as pesavel,
rtrim(PRODES) as descricao, 	
PROUM1QTD as quantidadeUnidade1,
rtrim(PROLOCFIS) as localizacao

into #Produtos
from TBS010 (nolock) 

where
PROCOD in (select codigo from #PedidoVendas union select codigo from #SolicitacaoCompras union select codigo from #MovimentosInternos)

-------------------------------------------------------------------------------------------------------------------

-- Informacões basicas dos saldos dos proutos para poder realizar as movimentações corretamente (TBS032)

if object_id('tempdb.dbo.#SaldoProdutos') is not null
begin
	drop table #SaldoProdutos 
end

select 
A.PROEMPCOD as empresa,
A.ESTLOC as localEstoque,
A.PROCOD as codigo,
A.ESTQTDATU as quantidadeAtual,
A.ESTQTDRES as quantidadeReserva,
A.ESTQTDPEN as quantidadePendente,
A.ESTQTDCMP as quantidadeCompra

into #SaldoProdutos
from TBS032 A (nolock) 

where
PROCOD in (select codigo from #PedidoVendas union select codigo from #SolicitacaoCompras union select codigo from #MovimentosInternos)

-------------------------------------------------------------------------------------------------------------------

-- INSERE NA TABELA #Reservas, OS ITENS DIVERGENTES 

insert into #Reservas 

select   
A.empresa,
A.localEstoque,
A.codigo,
E.unidade1,
A.quantidadeAtual,
A.quantidadeReserva,
A.quantidadePendente,
A.quantidadeCompra,

case when pesavel = 'N'
	then round( case when isnull(B.quantidade,0) < 0 then 0 else isnull(B.quantidade,0) end, 0)
	else case when isnull(B.quantidade,0) < 0 then 0 else isnull(B.quantidade,0) end
end as quantidadePedidoVenda,

case when pesavel = 'N'
	then round( case when isnull(C.quantidade,0) < 0 then 0 else isnull(C.quantidade,0) end, 0)
	else case when isnull(C.quantidade,0) < 0 then 0 else isnull(C.quantidade,0) end
end as 'quantidadeSolicitacaoCompra',

case when pesavel = 'N'
	then round( case when isnull(D.quantidade,0) < 0 then 0 else isnull(D.quantidade,0) end, 0)
	else case when isnull(D.quantidade,0) < 0 then 0 else isnull(D.quantidade,0) end
end as 'quantidadeMovimentoInterno'

from #SaldoProdutos A 
left join #PedidoVendas B 		on A.empresa = B.empresa and A.localEstoque = B.localEstoque and A.codigo = B.codigo
left join #SolicitacaoCompras C on A.empresa = C.empresa and A.localEstoque = C.localEstoque and A.codigo = C.codigo
left join #MovimentosInternos D on A.empresa = D.empresa and A.localEstoque = D.localEstoque and A.codigo = D.codigo
left join #Produtos E 			on A.empresa = E.empresa and A.codigo = E.codigo 

WHERE 
A.quantidadeReserva <> 

( case when pesavel = 'N'
	then round( case when isnull(B.quantidade,0) < 0 then 0 else isnull(B.quantidade,0) end, 0)
	else case when isnull(B.quantidade,0) < 0 then 0 else isnull(B.quantidade,0) end
end + 

case when pesavel = 'N'
	then round( case when isnull(C.quantidade,0) < 0 then 0 else isnull(C.quantidade,0) end, 0)
	else case when isnull(C.quantidade,0) < 0 then 0 else isnull(C.quantidade,0) end
end +

case when pesavel = 'N'
	then round( case when isnull(D.quantidade,0) < 0 then 0 else isnull(D.quantidade,0) end, 0)
	else case when isnull(D.quantidade,0) < 0 then 0 else isnull(D.quantidade,0) end
end )

-- SELECT * FROM #Reservas 

commit tran

--------------------------------------------------------------------------------------------------------------------------
	
/**************************************************************************************************/
	
--------------------------------------------------------------------------------------------------------------------------

-- Passo 1

if (select count(*) from #Reservas) > 0

begin

	--------------------------------------------------------------------------------------------------------------------------
	
	-- Reservar faixa de registros na TBS024 (sem nolock) para incluir na TBS051
	
	begin tran
	
	update TBS024 set
	@registroInicial = TBSVALSEQ,
	TBSVALSEQ = TBSVALSEQ + (select count(*) from #Reservas)
	
	where TBSNOM = 'TBS051'
	
	commit tran 
	
	-- select @registroInicial
	
	--------------------------------------------------------------------------------------------------------------------------
	
	-- Gravar regsitro na TBS051 para log do ajuste da reserva
	
	begin tran
	
	INSERT into 
	TBS051( LMEEMPCOD, -- 0
			LMEREG, --1
			LMEDOC, --2
			LMEROT, --3
			LMEDESROT, --4
			LMEACA, --5
			LMEDATHOR, --6
			LMEUSU, --7
			LMEMOD, --8
			LMEINFALT, --9
			PROCOD, --10
			PROEMPCOD, --11
			LMEQTDSAL, -- 12
			LMEQTDMOV, -- 13
			LMEQTDATU, -- 14
			LMEQTDRES, -- 15
			LMEQTDPEN, -- 16
			LMEQTDCMP,  -- 17
			LMEUNI, -- 18
			LMEQTDDIS, -- 19
			LMELOCEST) -- 20
	
	select 
	empresa, 					-- LMEEMPCOD 
	@registroInicial + rank as registro, -- LMEREG
	0, 							-- LMEDOC
	'SQL', 						-- LMEROT
	'AJUSTE DE RESERVA', 		-- LMEDESROT
	case when quantidadeReserva < (quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno)
		then 'E'
		else 'S'
	end acao,  					-- LMEACA
	GETDATE(), 					-- LMEDATHOR
	'SISTEMA',			 	-- LMEUSU
	'NENHUM', 					-- LMEMOD
	'R', 						-- LMEINFALT
	codigo, 					-- PROCOD
	0, 							-- PROEMPCOD
	quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno as saldo, 	-- LMEQTDSAL
	
	case when quantidadeReserva < ( quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno )
		then ( quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno ) - quantidadeReserva 
		else  quantidadeReserva - ( quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno )
	end mov , 					-- LMEQTDMOV
	
	quantidadeAtual, 					-- LMEQTDATU
	quantidadeReserva, 					-- LMEQTDRES
	quantidadePendente, 					-- LMEQTDPEN
	quantidadeCompra, 					-- LMEQTDCMP
	unidade1, 					-- LMEUNI
	quantidadeAtual - quantidadeReserva, 		-- LMEQTDDIS
	localEstoque 						-- LMELOCEST 
	
	FROM #Reservas A
	
	--------------------------------------------------------------------------------------------------------------------------
	
	-- Atualiza saldo reservado na TBS032
	
	-- begin TRAN 
	update TBS032 set 
	ESTQTDRES = quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno
	
	from TBS032 A 
	inner join #Reservas B on A.PROEMPCOD = B.empresa and A.ESTLOC = B.localEstoque and A.PROCOD collate database_default = B.codigo
	
	commit tran 
	
	--------------------------------------------------------------------------------------------------------------------------
	
	/**************************************************************************************************/
	
	--------------------------------------------------------------------------------------------------------------------------
	
	-- Gravar registro na TBS051 para ajustar o saldo atual de acordo com a reserva, caso o saldo atual seja menor que a reserva
	
	if ( select count(*) from #Reservas A where quantidadeAtual < quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno )  > 0
	
	begin
	
		-- Reservar faixa de registros na TBS024 (sem nolock) para incluir na TBS051
		
		begin tran
		
		update TBS024 set
		@registroInicial = TBSVALSEQ,
		TBSVALSEQ = TBSVALSEQ + ( select count(*) from #Reservas A where quantidadeAtual < quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno )
		
		where TBSNOM = 'TBS051'
		
		commit tran 
		
		--------------------------------------------------------------------------------------------------------------------------
		
		begin tran
		
		INSERT into 
		TBS051( LMEEMPCOD, -- 0
				LMEREG, --1
				LMEDOC, --2
				LMEROT, --3
				LMEDESROT, --4
				LMEACA, --5
				LMEDATHOR, --6
				LMEUSU, --7
				LMEMOD, --8
				LMEINFALT, --9
				PROCOD, --10
				PROEMPCOD, --11
				LMEQTDSAL, -- 12
				LMEQTDMOV, -- 13
				LMEQTDATU, -- 14
				LMEQTDRES, -- 15
				LMEQTDPEN, -- 16
				LMEQTDCMP,  -- 17
				LMEUNI, -- 18
				LMEQTDDIS, -- 19
				LMELOCEST) -- 20
		
		SELECT 
		empresa, 					-- LMEEMPCOD 
		@registroInicial + rank() OVER (ORDER BY A.rank) as registro, -- LMEREG
		0, 							-- LMEDOC
		'SQL', 						-- LMEROT
		'AJUSTE DE SALDO ATUAL', 		-- LMEDESROT
		--case when quantidadeAtual < (PDVQTD + SDCQTD + MVIQTD)
		--	then 'E'
		--	else 'S'
		--end acao,  					
		'E' as acao, 				-- LMEACA (sempre a quantidade atual vai ser menor que a reserva)
		GETDATE(), 					-- LMEDATHOR
		'SISTEMA',			 	-- LMEUSU
		'NENHUM', 					-- LMEMOD
		'E', 						-- LMEINFALT
		A.codigo, 					-- PROCOD
		0, 							-- PROEMPCOD
		quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno as saldo, 	-- LMEQTDSAL
		
		( quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno ) - quantidadeAtual as mov, -- LMEQTDMOV
		
		--case when ESTQTDATU < 0 
		--	then (ESTQTDATU*(-1)) + (PDVQTD + SDCQTD + MVIQTD)
		--	else (PDVQTD + SDCQTD + MVIQTD) - ESTQTDATU
		--end mov , 					-- LMEQTDMOV
		
		quantidadeAtual, 			-- LMEQTDATU
		quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno, 	-- LMEQTDRES
		quantidadePendente, 		-- LMEQTDPEN
		quantidadeCompra, 			-- LMEQTDCMP
		unidade1, 					-- LMEUNI
		quantidadeAtual - ( quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno ), 	-- LMEQTDDIS
		localEstoque 				-- LMELOCEST 
		
		from #Reservas A
		
		where 
		quantidadeAtual < quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno
		
		--------------------------------------------------------------------------------------------------------------------------
		
		-- Atualizar o saldo na TBS032 ATUALIZA SALDO ATUAL NA TBS032
		
		-- begin tran 
		
		update TBS032 set 
		ESTQTDATU = quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno
		
		from TBS032 A 
		inner join #Reservas B on A.PROEMPCOD = B.empresa and A.ESTLOC = B.localEstoque and A.PROCOD collate database_default = B.codigo
					
		where 
		quantidadeAtual < quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno
		
		----------------------------------------------------------------------------------------------------------------------------
		
		-- Reservar faixa de registros na TBS024 (sem nolock) para incluir na TBS049
		
		begin tran
		
		update TBS024 set
		@registroInicial = TBSVALSEQ,
		TBSVALSEQ = TBSVALSEQ + ( select count(*) from #Reservas A where quantidadeAtual < quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno )
		
		where TBSNOM = 'TBS049'
		
		commit tran 
		
		----------------------------------------------------------------------------------------------------------------------------
		
		-- Grava o ajuste de saldo na TBS049
		
		-- begin tran 
		
		INSERT into TBS049 (
		MDSEMPCOD,
		MDSREG,
		MDSTIP,
		MDSLAN,
		PROCOD,
		PROEMPCOD,
		MDSPRODES,
		MDSUNI,
		MDSQTDEMB,
		MDSQTD,
		MDSOBS,
		LESCOD,
		LESEMPCOD,
		MDSUSU,
		MDSEMPUSU,
		MDSMOD,
		MDSQTDANT,
		OCOCOD,
		OCOEMPCOD,
		CCSCOD,
		CCSEMPCOD,
		LESCODANT)
		
		SELECT 
		A.empresa, -- MDSEMPCOD
		@registroInicial + rank() OVER (ORDER BY A.rank) AS [RANK], -- MDSREG
		'E' as acao, 		-- MDSTIP (sempre a quantidade atual vai ser menor que a reserva)   
		GETDATE(), 			-- MDSLAN,
		A.codigo,			-- PROCOD
		B.empresa,		-- MDSPROEMPCOD,
		B.descricao, 			-- MDSPRODES,
		A.unidade1, 			-- MDSUNI,
		B.quantidadeUnidade1, 		-- MDSQTDEMB,
		( quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno ) - quantidadeAtual as mov, -- MDSQTD,
		'AJUSTE DE SALDO ATUAL', 	-- MDSOBS,
		localEstoque,
		0,
		'SISTEMA',		-- MDSUSU,
		0, 					-- MDSEMPUSU,
		'SQL', 				-- MDSMOD,
		quantidadeAtual, 	-- MDSQTDANT,
		0, 					-- OCOCOD,
		0,					-- OCOEMPCOD,
		162, 				-- CCSCOD,
		0, 					-- CCSEMPCOD,
		NULL  				-- LESCODANT
		
		from #Reservas A 
		inner join #Produtos B ON A.codigo collate database_default = B.codigo  
		
		WHERE 
		quantidadeAtual < quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno
		
		commit tran
	
	end
	
	--------------------------------------------------------------------------------------------------------------------------
	
	/**************************************************************************************************/
	
	--------------------------------------------------------------------------------------------------------------------------
	
end

-- commit tran 

end try 

begin catch 

	rollback tran 
	
	set @sqlEmail = 'execute msdb.dbo.sp_send_dbmail
						@profile_name = ''Email'',
						@recipients = ''cristiano@integros.com.br; william@integros.com.br'', 
						@subject = ''Ajuste de Reserva (teve falha) (Tanby Taubaté)'',
						@body = ''
O select que faz o ajuste de reserva teve uma falha e entrou no catch.
Passo1.

Ate, Suporte Integros. 
	
Esse e-mail é enviado automaticamente pelo trabalho Ajuste de Reserva.'' '
		
	exec(@sqlEmail)

end catch 

-- Fim Passo 1

--------------------------------------------------------------------------------------------------------------------------
	
/**************************************************************************************************/
	
--------------------------------------------------------------------------------------------------------------------------

-- Passo 2 -- Verificar as quantidades na TBS032 que não tem nas reservas

-- Informacões basicas dos saldos dos proutos para poder realizar as movimentações corretamente (TBS032)

begin tran 

begin try

if object_id('tempdb.dbo.#Reservas2') is not null 
begin 
	drop table #Reservas2
end

create table #Reservas2(
rank int identity(1,1), 
empresa tinyint not null default 0, 
localEstoque tinyint not null default 0, 
codigo char(15) not null default '',
unidade1 varchar(3),
quantidadeAtual money default 0,
quantidadeReserva money default 0,
quantidadePendente money default 0,
quantidadeCompra money default 0, 

constraint i#Reservas2 primary key(rank, empresa, localEstoque, codigo))

-------------------------------------------------------------------------------------------------------------------

if object_id('tempdb.dbo.#SaldoProdutos2') is not null
begin
	drop table #SaldoProdutos2 
end

select 
A.PROEMPCOD as empresa,
A.ESTLOC as localEstoque,
A.PROCOD as codigo,
A.ESTQTDATU as quantidadeAtual,
A.ESTQTDRES as quantidadeReserva,
A.ESTQTDPEN as quantidadePendente,
A.ESTQTDCMP as quantidadeCompra

into #SaldoProdutos2
from TBS032 A (nolock) 

where
ESTQTDRES <> 0

-------------------------------------------------------------------------------------------------------------------

-- Informacões basicas dos proutos para poder realizar as movimentações corretamente (TBS010)

if object_id('tempdb.dbo.#Produtos2') is not null
begin
	drop table #Produtos2 
end

select 
PROEMPCOD as empresa,
PROCOD as codigo,
PROUM1 as unidade1,
PROPESAVEL as pesavel,
rtrim(PRODES) as descricao, 	
PROUM1QTD as quantidadeUnidade1,
rtrim(PROLOCFIS) as localizacao

into #Produtos2
from TBS010 (nolock) 

where
PROCOD in (select codigo from #SaldoProdutos2)

-------------------------------------------------------------------------------------------------------------------

-- Unir todas as quantidades de saldo em reservas das outras tabelas

-- SELECT * FROM #SaldoProdutos2

if object_id('tempdb.dbo.#ReservasTotal1') is not null
begin
	drop table #ReservasTotal1 
end

select * into #ReservasTotal1 from #PedidoVendas
union all
select * from #SolicitacaoCompras
union all
select * from #MovimentosInternos

--select count(*) from #PedidoVendas
--union all
--select count(*) from #SolicitacaoCompras
--union all
--select count(*) from #MovimentosInternos

---------------------------------------------------------------------------------------------------------------------------------------------

-- Somar todas as quantidades reservadas

if object_id('tempdb.dbo.#ReservasTotal') is not null
begin
	drop table #ReservasTotal
end

select
empresa,
localEstoque,
codigo,
sum(quantidade) as quantidade

into #ReservasTotal 
from #ReservasTotal1

group by 
empresa,
localEstoque,
codigo


--select * 
--
--from #SaldoProdutos2 a 
--left join #ReservasTotal b on a.empresa = b.empresa and a.localEstoque = b.localEstoque and a.codigo = b.codigo 
--
--where
--a.quantidadeReserva <> isnull(b.quantidade,0)

---------------------------------------------------------------------------------------------------------------------------------------------

-- Somente os itens que estão na TBS032 e não tem reservar em nenhum lugar

insert into #Reservas2

select   

A.empresa,
A.localEstoque,
A.codigo,
E.unidade1,
A.quantidadeAtual,
A.quantidadeReserva,
A.quantidadePendente,
A.quantidadeCompra

-- into #Reservas2
from #SaldoProdutos2 A 
left join #ReservasTotal B 		on A.empresa = B.empresa and A.localEstoque = B.localEstoque and A.codigo = B.codigo
left join #Produtos2 E 			on A.empresa = E.empresa and A.codigo = E.codigo 

where
B.quantidade is null 

-- select * from #Reservas2

commit tran 

---------------------------------------------------------------------------------------------------------------------------------------------

if (select count(*) from #Reservas2) > 0

begin

	--------------------------------------------------------------------------------------------------------------------------
	
	-- Reservar faixa de registros na TBS024 (sem nolock) para incluir na TBS051
	
	begin tran
	
	update TBS024 set
	@registroInicial = TBSVALSEQ,
	TBSVALSEQ = TBSVALSEQ + (select count(*) from #Reservas2)
	
	where TBSNOM = 'TBS051'
	
	commit tran 
	
	-- select @registroInicial
	
	--------------------------------------------------------------------------------------------------------------------------
	
	-- Gravar regsitro na TBS051 para log do ajuste da reserva
	
	begin tran
	
	INSERT into 
	TBS051( LMEEMPCOD, -- 0
			LMEREG, --1
			LMEDOC, --2
			LMEROT, --3
			LMEDESROT, --4
			LMEACA, --5
			LMEDATHOR, --6
			LMEUSU, --7
			LMEMOD, --8
			LMEINFALT, --9
			PROCOD, --10
			PROEMPCOD, --11
			LMEQTDSAL, -- 12
			LMEQTDMOV, -- 13
			LMEQTDATU, -- 14
			LMEQTDRES, -- 15
			LMEQTDPEN, -- 16
			LMEQTDCMP,  -- 17
			LMEUNI, -- 18
			LMEQTDDIS, -- 19
			LMELOCEST) -- 20
	
	select 
	empresa, 					-- LMEEMPCOD 
	@registroInicial + rank as registro, -- LMEREG
	0, 							-- LMEDOC
	'SQL', 						-- LMEROT
	'AJUSTE DE RESERVA', 		-- LMEDESROT
	case when quantidadeReserva < 0 
		then 'E'
		else 'S' 
	end as acao,  				-- LMEACA
	GETDATE(), 					-- LMEDATHOR
	'SISTEMA',			 	-- LMEUSU
	'NENHUM', 					-- LMEMOD
	'R', 						-- LMEINFALT
	codigo, 					-- PROCOD
	0, 							-- PROEMPCOD
	0 as saldo, 	-- LMEQTDSAL
	
	case when quantidadeReserva < 0
		then quantidadeReserva * (-1) 
		else quantidadeReserva
	end as mov , 					-- LMEQTDMOV
	
	quantidadeAtual, 					-- LMEQTDATU
	quantidadeReserva, 					-- LMEQTDRES
	quantidadePendente, 					-- LMEQTDPEN
	quantidadeCompra, 					-- LMEQTDCMP
	unidade1, 					-- LMEUNI
	quantidadeAtual - quantidadeReserva, 		-- LMEQTDDIS
	localEstoque 						-- LMELOCEST 
	
	FROM #Reservas2 A
	
	--------------------------------------------------------------------------------------------------------------------------
	
	-- Atualiza saldo reservado na TBS032
	
	-- begin TRAN 
	update TBS032 set 
	ESTQTDRES = 0
	
	from TBS032 A 
	inner join #Reservas2 B on A.PROEMPCOD = B.empresa and A.ESTLOC = B.localEstoque and A.PROCOD collate database_default = B.codigo
	
	commit tran 
	
	--------------------------------------------------------------------------------------------------------------------------
	
	/**************************************************************************************************/
	
	--------------------------------------------------------------------------------------------------------------------------
	
end

-- commit tran 

end try 

begin catch 

	rollback tran 
	
	set @sqlEmail = 'execute msdb.dbo.sp_send_dbmail
						@profile_name = ''Email'',
						@recipients = ''cristiano@integros.com.br; william@integros.com.br'', 
						@subject = ''Ajuste de Reserva (teve falha) (Tanby Matriz)'',
						@body = ''
O select que faz o ajuste de reserva teve uma falha e entrou no catch.
Passo2.

Ate, Suporte Integros. 
	
Esse e-mail é enviado automaticamente pelo trabalho Ajuste de Reserva.'' '
		
	exec(@sqlEmail)

end catch 

-- Fim Passo 2

--------------------------------------------------------------------------------------------------------------------------
	
/**************************************************************************************************/
	
--------------------------------------------------------------------------------------------------------------------------


-- Mandar email

if(select count(*) from #Reservas) > 0 or (select count(*) from #Reservas2) > 0 

begin 

	-- primeiro copy o modelo da palnilha sem dados, para sobreescerver os dados antigos

	exec master..xp_cmdshell 'copy C:\integros\temp\AjusteReserva.xlsx C:\integros\temp\AjusteReserva\'  
	
	insert into openrowset ('Microsoft.ACE.OLEDB.12.0',
						   'Excel 8.0;Database=C:\integros\temp\AjusteReserva\AjusteReserva.xlsx;', 
						   'select * from [produtos$]')		
	
	select 
	A.localEstoque, 
	A.codigo, 
	B.descricao,
	A.unidade1,
	replace( quantidadeAtual, '.',',') as atualAntigo, 
	replace( quantidadeReserva, '.',',') as reservaAntiga,
	
	case when quantidadeAtual < quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno
		then replace( quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno, '.',',')
		else replace( quantidadeAtual, '.',',')
	end as atualNovo,
	
	replace(quantidadePedidoVenda + quantidadeSolicitacaoCompra + quantidadeMovimentoInterno, '.',',') as reservaNova,
	
	'' as obs
	
	from #Reservas A
	inner join #Produtos B ON A.codigo collate database_default = B.codigo 	
	
	union all
	
	select 
	A.localEstoque, 
	A.codigo collate database_default , 
	B.descricao collate database_default,
	A.unidade1 collate database_default,
	replace( quantidadeAtual, '.',',') as atualAntigo, 
	replace( quantidadeReserva, '.',',') as reservaAntiga,
	
	replace( quantidadeAtual, '.',',') as atualNovo,
	
	replace(0.0,'.',',') as reservaNova,
	
	'Tinha na TBS032, mas não tinha nas tabelas que fazem as reservas (TBS0371, TBS058 e TBS0761)'
	
	from #Reservas2 A
	inner join #Produtos2 B ON A.codigo collate database_default = B.codigo 	
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- mandar arquivo AjusteReserva.xlsx por e-mail
	
	-- cristiano@integros.net.br; william@integros.net.br
	
	set @sqlEmail = 'execute msdb.dbo.sp_send_dbmail
						@profile_name = ''Email'',
						@recipients = ''cristiano@integros.com.br; william@integros.com.br'', 
						@subject = ''Ajuste de Reserva (Tanby Taubaté)'',
						@body = ''
Segue em anexo relatório dos itens que tiveram ajuste de reserva e caso necessário ajuste no saldo atual.

Ate, Suporte Integros. 
	
Esse e-mail é enviado automaticamente pelo trabalho Ajuste de Reserva.'',
						@file_attachments = ''C:\integros\temp\AjusteReserva\AjusteReserva.xlsx'' '
		
	exec(@sqlEmail)
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- apagar arquivo AjusteReserva.xlsx 
	
	EXEC master..xp_cmdshell 'DEL /s /q /f C:\integros\temp\AjusteReserva\AjusteReserva.xlsx'

end