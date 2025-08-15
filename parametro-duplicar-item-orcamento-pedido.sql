select * from TBS025 (nolock) where PARCHV=1029

-- par 1029: PERMITE DUPLICAR O ITEM EM ORCAMENTOS/PEDIDOS DE VENDAS

begin tran
update TBS025 set PARVAL='N' where PARCHV=1029
commit tran
