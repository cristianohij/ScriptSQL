-- quantidade pedida MENOR que a quantidade faturada
select PDVQTD,PDVQTDFAT,* from TBS0551 (noLock) where PDVQTD<PDVQTDFAT

-- corrige o erro acima
update TBS0551 set PDVQTD=PDVQTDFAT where PDVQTD<PDVQTDFAT

-- quantidade pedida NEGATIVA
select PDVQTD,PDVQTDFAT,* from TBS0551 (noLock) where PDVQTD<0

-- corrige o erro acima para produtos jah faturados
update TBS0551 set PDVQTD=PDVQTDFAT where PDVQTD<0

-- checa integridade referencial - pedidos de vendas
select * from TBS053 (noLock) where BCPTIPTRN='P' and not exists(select 'ne' from TBS055 (noLock) where PDVNUM=BCPNUM)

-- verifica pedido marcado com bloqueio de credito e sem registro na tabela de bloqueios
select * from TBS055 (noLock)
 where PDVBLQCRE='S' and not exists(select 'ne' from TBS053 (noLock)
                                     where BCPTIPTRN='P' and BCPNUM=PDVNUM and BCPBLQCRE='S')

-- corrige o problema acima para o pedido 54787
update TBS0551 set PDVBLQPRE='N' 
 where PDVBLQPRE='S' and not exists(select 'ne' from TBS053 (noLock)
                                     where BCPTIPTRN='P' and BCPNUM=PDVNUM and BCPBLQPRE='S')

-- verifica valores validos para o atributo
select PDVBLQCRE,* from TBS055 (noLock) where not PDVBLQCRE in('S','N')

-- corrige o erro acima
update TBS055 set PDVBLQCRE='N' where not PDVBLQCRE in('S','N')

-- verifica pedido marcado com bloqueio de preco e sem registro na tabela de bloqueios
select * from TBS0551 (noLock)
 where PDVBLQPRE='S' and not exists(select 'ne' from TBS053 (noLock)
                                     where BCPTIPTRN='P' and BCPNUM=PDVNUM and BCPBLQPRE='S')

-- verifica valores validos para o atributo
select PDVBLQPRE,* from TBS0551 (noLock) where not PDVBLQPRE in('S','N')


-- checa integridade referencial - orcamentos
select * from TBS053 (noLock) where BCPTIPTRN='O' and not exists(select 'ne' from TBS043 (noLock) where ORCNUM=BCPNUM)

-- deleta os registro nao encontrados acima
delete TBS053 where BCPTIPTRN='O' and not exists(select 'ne' from TBS043 (noLock) where ORCNUM=BCPNUM)

-- verifica orcametno marcado com bloqueio de credito e sem registro na tabela de bloqueios
select * from TBS043 (noLock)
 where ORCBLQCRE='S' and not exists(select 'ne' from TBS053 (noLock)
                                     where BCPTIPTRN='O' and BCPNUM=ORCNUM and BCPBLQCRE='S')

-- corrige o erro acima
update TBS043 set ORCBLQCRE='N'
 where ORCBLQCRE='S' and not exists(select 'ne' from TBS053 (noLock)
                                     where BCPTIPTRN='O' and BCPNUM=ORCNUM and BCPBLQCRE='S')

-- verifica valores validos para o atributo
select ORCBLQCRE,* from TBS043 (noLock) where not ORCBLQCRE in('S','N')

-- corrige o erro acima
update TBS043 set ORCBLQCRE='N' where not ORCBLQCRE in('S','N')

-- verifica pedido marcado com bloqueio de preco e sem registro na tabela de bloqueios
select * from TBS0551 (noLock)
 where PDVBLQPRE='S' and not exists(select 'ne' from TBS053 (noLock)
                                     where BCPTIPTRN='P' and BCPNUM=PDVNUM and BCPBLQPRE='S')

-- verifica valores validos para o atributo
select ORCBLQPRE,* from TBS0431 (noLock) where not ORCBLQPRE in('S','N')
