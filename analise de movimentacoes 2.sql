select LMEREG    as 'registro',
       LMEDATHOR as 'data/hora',
       LMEDOC    as 'documento',
       LMEROT    as 'nome da rotina',
       case LMEROT
          when 'PCOM009' then 'PED.COMPRAS/ENTRADA NF'
          when 'PCOM023' then 'GERA PED.COMPRA A PARTIR SUGESTACAO DE COMPRAS'
          when 'PEST005' then 'MOV.INTERNO/MANUTENCAO SALDOS'
          when 'PEST008' then 'MOV.INTERNO'
          when 'PEST022' then 'NF ENTRADA'
          when 'PEST029' then 'RESERVA AUTOMATICA PRODUTOS PENDENTES'
          when 'PEST030' then 'RESERVA PED.PENDENTE'
          when 'PEST053' then 'CADASTRO PRODUTO NOVO'
          when 'PVEN004' then 'INSERE ITEM PED.VENDA'
          when 'PVEN016' then 'ITEM EXCLUIDO DO PEDIDO'
          when 'PVEN031' then 'NF SAIDA C/AGLUTINACAO'
          when 'PVEN032' then 'ESTORNA RESERVA PEDIDO'
          when 'PVEN034' then 'CANCELA PEDIDO'
          when 'PVEN044' then 'NF SAIDA S/AGLUTINACAO'
          else 'NAO IDENTIFICADO'
       end as 'descricao da rotina',
       LMEDESROT as 'acao da rotina',
       LMEACA    as 'Entrada/Saida',
       LMEINFALT as 'informacao alterada',
       PROCOD    as 'codigo do produto',LMEUNI as 'unidade de medida',
       LMEQTDATU as 'qtde atual',
       LMEQTDRES as 'qtde reservada',
       LMEQTDDIS as 'qtde disponivel',
       LMEQTDMOV as 'qtde movimentada',
       LMEQTDSAL as 'saldo',
       LMEQTDPEN as 'qtde pendente',
       LMEQTDCMP as 'qtde comprada',
       LMEQTDSAL as 'saldo apos movimentacao',
       LMELOCEST as 'estoque',
       LMEUSU    as 'usuario',
       LMEMOD    as 'modulo'
  from TBS051 (noLock)
-- where LMEDOC=16400
-- where PROCOD in('10840075','10840076') and LMEDATHOR >= '2013-12-01'
where PROCOD='0050237' and
      LMELOCEST=2 and
      LMEDATHOR between '20151212' and '20151222'
order by LMEDATHOR
