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

select PROCOD
       ,PRODES
       ,MARNOM
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

begin tran
update TBS010
   set PROCALPOP = 'N'
 where PROCALPOP = 'S'

rollback tran
commit tran

-- configurar

update TBS010 set PROCALPOP = 'S' where PROCOD = '1640054'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2540001'
update TBS010 set PROCALPOP = 'S' where PROCOD = '18520001'
update TBS010 set PROCALPOP = 'S' where PROCOD = '18440002'
update TBS010 set PROCALPOP = 'S' where PROCOD = '25460001'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1070040'
update TBS010 set PROCALPOP = 'S' where PROCOD = '18620021'
update TBS010 set PROCALPOP = 'S' where PROCOD = '33030005'
update TBS010 set PROCALPOP = 'S' where PROCOD = '16310053'
update TBS010 set PROCALPOP = 'S' where PROCOD = '5867761'
update TBS010 set PROCALPOP = 'S' where PROCOD = '6660029'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2600048'
update TBS010 set PROCALPOP = 'S' where PROCOD = '76020001'
update TBS010 set PROCALPOP = 'S' where PROCOD = '33030003'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1907023'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1070029'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1080067'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1179986'
update TBS010 set PROCALPOP = 'S' where PROCOD = '16280026'
update TBS010 set PROCALPOP = 'S' where PROCOD = '8478633'
update TBS010 set PROCALPOP = 'S' where PROCOD = '18440001'
update TBS010 set PROCALPOP = 'S' where PROCOD = '6521894'
update TBS010 set PROCALPOP = 'S' where PROCOD = '32120001'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2600005'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2600072'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1400014'
update TBS010 set PROCALPOP = 'S' where PROCOD = '6590196'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1179950'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2130372'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2600056'
update TBS010 set PROCALPOP = 'S' where PROCOD = '0063258'
update TBS010 set PROCALPOP = 'S' where PROCOD = '7880292'
update TBS010 set PROCALPOP = 'S' where PROCOD = '23830001'
update TBS010 set PROCALPOP = 'S' where PROCOD = '0051314'
update TBS010 set PROCALPOP = 'S' where PROCOD = '7290580'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2814159'
update TBS010 set PROCALPOP = 'S' where PROCOD = '23740021'
update TBS010 set PROCALPOP = 'S' where PROCOD = '4170058'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1641619'
update TBS010 set PROCALPOP = 'S' where PROCOD = '7900802'
update TBS010 set PROCALPOP = 'S' where PROCOD = '0090902'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2600006'
update TBS010 set PROCALPOP = 'S' where PROCOD = '8429995'
update TBS010 set PROCALPOP = 'S' where PROCOD = '7290581'
update TBS010 set PROCALPOP = 'S' where PROCOD = '3940630'
update TBS010 set PROCALPOP = 'S' where PROCOD = '4960159'
update TBS010 set PROCALPOP = 'S' where PROCOD = '9650004'
update TBS010 set PROCALPOP = 'S' where PROCOD = '5510761'
update TBS010 set PROCALPOP = 'S' where PROCOD = '1640038'
update TBS010 set PROCALPOP = 'S' where PROCOD = '2810028'

-- lista fornecedores dos produtos

select p.PROCOD
       ,f.FORCOD
  from TBS010 p with (nolock)
  Left join TBS006 f with (nolock) 
         on f.FORCOD = p.FORCOD
            
  WHERE p.PROCALPOP = 'S'
            and p.PROCOD in (
'1640054',
'2540001',
'18520001',
'18440002',
'25460001',
'1070040',
'18620021',
'33030005',
'16310053',
'5867761',
'6660029',
'2600048',
'76020001',
'33030003',
'1907023',
'1070029',
'1080067',
'1179986',
'16280026',
'8478633',
'18440001',
'6521894',
'32120001',
'2600005',
'2600072',
'1400014',
'6590196',
'1179950',
'2130372',
'2600056',
'0063258',
'7880292',
'23830001',
'0051314',
'7290580',
'2814159',
'23740021',
'4170058',
'1641619',
'7900802',
'0090902',
'2600006',
'8429995',
'7290581',
'3940630',
'4960159',
'9650004',
'5510761',
'1640038',
'2810028')