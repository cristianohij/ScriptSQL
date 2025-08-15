-- lista produtos com preco bloqueado no pedido que nao aparece para liberacao
select * from TBS0551 (nolock)
 where PDVBLQPRE = 'S' and
       not exists(select 'ne' from TBS053 (noLock) where BCPTIPTRN = 'P' and BCPBLQPRE = 'S' and BCPNUM=PDVNUM)

-- corrige o erro acima
update TBS0551 set PDVBLQPRE = 'N'
 where PDVBLQPRE = 'S' and
       not exists(select 'ne' from TBS053 (nolock) where BCPTIPTRN = 'P' and BCPBLQPRE = 'S' and BCPNUM=PDVNUM)

-------------------------------------------------------------------------------------------------------------------------

-- lista pedidos com bloqueio de credito que nao aparece para liberacao
select * from TBS055 (nolock)
 where PDVBLQCRE = 'S' and
       not exists(select 'ne' from TBS053 (noLock) where BCPTIPTRN = 'P' and BCPBLQCRE='S' and BCPNUM=PDVNUM)

-- corrige o erro acima
update TBS055 set PDVBLQCRE = 'N'
 where PDVBLQCRE = 'S' and
       not exists(select 'ne' from TBS053 (nolock) where BCPTIPTRN = 'P' and BCPBLQCRE = 'S' and BCPNUM=PDVNUM)

-------------------------------------------------------------------------------------------------------------------------

-- lista pedidos para liberacao de precos que nao deveriam aparecer
select BCPTIPTRN,* from TBS053 (nolock)
 where BCPTIPTRN = 'P' and BCPBLQPRE = 'S' and
       not exists(select 'ne' from TBS0551 (noLock) where PDVNUM = BCPNUM and PDVBLQPRE = 'S')

-- corrige o erro acima
update TBS053 set BCPBLQPRE = 'N'
 where BCPTIPTRN = 'P' and BCPBLQPRE = 'S' and
       not exists(select 'ne' from TBS0551 (noLock) where PDVNUM = BCPNUM and PDVBLQPRE = 'S')

-------------------------------------------------------------------------------------------------------------------------

-- lista pedidos para liberacao de credito que nao deveriam aparecer
select BCPTIPTRN,* from TBS053 (nolock)
 where BCPTIPTRN = 'P' and BCPBLQCRE = 'S' and
       not exists(select 'ne' from TBS055 (noLock) where PDVNUM = BCPNUM and PDVBLQCRE = 'S')

-- corrige o erro acima
update TBS053 set BCPBLQCRE = 'N'
 where BCPTIPTRN = 'P' and BCPBLQCRE = 'S' and
       not exists(select 'ne' from TBS055 (noLock) where PDVNUM = BCPNUM and PDVBLQCRE = 'S')

-------------------------------------------------------------------------------------------------------------------------

-- verifica se ainda deve fazer mais alguma correcao nos dois erros anteriores
select * from TBS053 (noLock) where BCPTIPTRN = 'P' and BCPBLQCRE = 'N' and BCPBLQPRE = 'N'

-- corrige o erro acima
delete TBS053 where BCPTIPTRN = 'P' and BCPBLQCRE = 'N' and BCPBLQPRE = 'N'

-------------------------------------------------------------------------------------------------------------------------