-- query para zerar o estoque da loja da best bag

-- abre o banco de dados
use SIBD2

-- elimina registros de movimentações
delete TBS0371
delete TBS037
delete TBS049

-- atualiza sequencial das tabelas eliminadas
update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS037'
update TBS024 set TBSVALSEQ=0 where TBSNOM='TBS049'

-- zera as quantidades do estoque atual, pendências e reservas

-- local de estoque 1
update TBS032 set ESTQTDATU=0,ESTQTDPEN=0,ESTQTDRES=0 where ESTLOC=1

-- local de estoque 2
update TBS032 set ESTQTDATU=0,ESTQTDPEN=0,ESTQTDRES=0 where ESTLOC=2
