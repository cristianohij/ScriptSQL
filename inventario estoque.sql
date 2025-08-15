-- inventario
delete TBS013

-- itens movimentos internos
delete TBS0371

-- cabecalho movimentos internos
delete TBS037

-- manutencao saldos
delete TBS049

-- log movimentacoes estoque
delete TBS051

-- zera numeracao da tabela de log movimentacoes estoque
update TBS024 set TBSVALSEQ = 0 where TBSNOM = 'TBS051'

