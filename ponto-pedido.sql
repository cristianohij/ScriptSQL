select PROCOD
       ,PRODES
       ,PROCALPOP       -- Calcula Ponto de Pedido S/N
       ,PRODATBAS       -- Data base para calculo do Ponto pedido
       ,PROUSUPOP       -- Usuario que realizou calculo o ponto pedido
       ,PRODEHPOP       -- Data e hora calculo do ponto de pedido
       ,PROLOTCMP       -- Lote de compra ponto de pedido
       ,PRODATFIN       -- Data final para calculo do Ponto pedido
       ,PROPESPOP       -- Pesos mensais para o calculo do ponto pedido
       ,PRODIAUTI       -- Quantidade de dias uteis do periodo de calculo do ponto
       ,PROUSUALTPOP    -- Usuario alterou dados do ponto de pedido
       ,PRODATALTPOP    -- Data alteracao dados do ponto de pedido
       ,PROHORALTPOP    -- Hora alteracao dados do ponto de pedido
  from TBS010 with (nolock)
 where PROCALPOP = 'S'
 order by PROCOD

select *
  from TBS014 with (nolock)
 where MARCOD in (31,154,201,625,704,798,806,813,1039,1628,1642,2034)
 order by MARNOM

select count(*)
  from TBS010 with (nolock)
 where MARCOD = 31



