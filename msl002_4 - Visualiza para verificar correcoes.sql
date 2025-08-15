--visualiza totais por tipos de registros
select M2_TIPREG as 'COD TIPO REGISTRO',
case M2_TIPREG
when 01 then 'Venda Item'
when 02 then 'Desconto Total'
when 03 then 'Finalizador Venda'
when 04 then 'Cancelamento Cupom'
when 05 then 'Acréscimo sobre Total do Cupom'
when 06 then 'Contra-Vale emitido'
when 07 then 'Cupom Vasilhame'
when 08 then 'Ticket de Troca Emitido'
when 09 then 'Correção de Finalizador'
when 10 then 'Cancelamento de Item'
when 11 then 'Cancelamento de Venda'
when 12 then 'Troco de Finalizador'
when 13 then 'Identificação do Cliente (CAT)'
when 14 then 'Promoção Campanha'
when 15 then 'Cartão Fidelidade'
when 16 then 'Sangria'
when 17 then 'Dados para geração de registro R06 - Ato Cotepe 06/08'
when 18 then 'Identificação do Cliente (Lei Anti-Álcool)'
when 21 then 'Entrada em Caixa (Reforço)'
when 22 then 'Saída no Caixa'
when 23 then 'Abertura de Caixa'
when 24 then 'Fechamento de Caixa'
when 25 then 'Encerramento de Dia ( Redução Z )'
when 30 then 'Emissão Cupom sobre Pedido'
when 35 then 'Iniciante ( Tanque/Bico )'
when 36 then 'Abastecimento'
when 37 then 'Encerrante ( Tanque/Bico )'
when 40 then 'Cancelamento Compra Cartão Próprio / Autorizadores'
when 41 then 'Cancelamento Compra Cartão Crédito Rotativo'
when 42 then 'Cancelamento Transação TEF DISCADO'
when 43 then 'Cancelamento Transação TEF'
when 44 then 'Cancelamento de Pagamento de Conta'
when 45 then 'Cancelamento de Recebimento de Conta de Cliente Loja'
when 50 then 'Cadastro de Senha de Cliente'
when 60 then 'Pagamento de Conta'
when 70 then 'Recebimento de Conta de Cliente Loja'
when 80 then 'Correspondente Bancário'
when 81 then 'Saque Cartão ( Compra&Saque e Troco-Fácil )'
when 82 then 'Correspondente Bancário ( Banco Completo )'
when 90 then 'Recarga de Celular'
end as 'TIPO REGISTRO', M2_TRB, M2_REGCAN,
sum(M2_VALTOT), sum(M2_ABT), sum(M2_VALTOT) - sum(M2_ABT)
from MSL002
where M2_DAT between '20130901' and '20130930' and M2_NUMECF = 11 --and M2_TIPREG = 3
group by M2_TIPREG, M2_TRB, M2_REGCAN
order by M2_TIPREG

--visualiza totais por tipos de registros
select M2_NUMECF, M2_TRB, M2_REGCAN, sum(M2_VALTOT)
from MSL002
where M2_DAT between '20130901' and '20130930' and M2_TIPREG in ('02', '01', '04', '10', '11')
group by M2_NUMECF, M2_TRB, M2_REGCAN
order by M2_NUMECF, M2_TRB, M2_REGCAN

--visualiza cupons com total reg 03 diferente dos itens reg '01'
select M2_NUMECF, M2_COO, M2_REGCAN, sum(A.M2_VALTOT), (select round(sum(M2_VALTOT - M2_ABT),2) from MSL002 B(nolock) where A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and M2_DAT between '20130701' and '20130731'), sum(A.M2_VALTOT) - (select round(sum(M2_VALTOT - M2_ABT),2) from MSL002 B(nolock) where A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and M2_DAT between '20130701' and '20130731')
from MSL002 A(nolock)
where M2_TIPREG = '03' and M2_DAT between '20130701' and '20130731'
group by M2_NUMECF, M2_COO, M2_TIPREG, M2_REGCAN
having sum(M2_VALTOT) != (select round(sum(M2_VALTOT - M2_ABT),2) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and M2_DAT between '20130701' and '20130731')
order by M2_COO


--visualiza determinado cupom para analise
declare @periodoDe datetime, @periodoAte datetime

set @periodoDe = '20130701'
set @periodoAte= '20130731'

select M2_NUMECF, M2_COO, M2_TIPREG, M2_REGCAN, M2_DAT, M2_VALTOT, M2_ABT, M2_VALTOT - M2_ABT,
        M2_VALTOT * ((select sum(cast(M2_VALTOT as decimal(20,8))) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and M2_DAT between @periodoDe and @periodoAte)/
					 (select sum(cast(M2_VALTOT as decimal(20,8))) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and M2_DAT between @periodoDe and @periodoAte)),
		 ((select sum(cast(M2_VALTOT as decimal(20,8))) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '02' and M2_DAT between @periodoDe and @periodoAte)/
		 (select sum(cast(M2_VALTOT as decimal(20,8))) from MSL002 B(nolock) where A.M2_NUMECF = B.M2_NUMECF and A.M2_COO = B.M2_COO and M2_REGCAN = 'F' and M2_TIPREG = '01' and M2_DAT between @periodoDe and @periodoAte))
from MSL002 A(nolock)
where M2_COO = 34625 and M2_DAT between '20130701' and '20130731'
--group by M2_NUMECF, M2_COO, M2_TIPREG, M2_REGCAN, M2_DAT
order by M2_TIPREG

--teste de precisao
print cast(6.58/131.65 as decimal(12,8))


--visualiza determinado cupom para analise(agrupa)
select M2_COO, M2_TIPREG, M2_REGCAN, M2_DAT, M2_VALTOT, M2_ABT--, sum(M2_VALTOT - M2_ABT)
from MSL002
where M2_COO = 34625 and M2_DAT between '20130701' and '20130731'
--group by M2_COO, M2_TIPREG, M2_REGCAN, M2_DAT
order by M2_TIPREG