--select * from TBS051 where PROCOD='0121037' order by LMEREG

select LMEREG    as 'registro',
       LMEDOC    as 'documento',
       LMEROT    as 'nome rotina',
       LMEDESROT as 'descricao rotina',
       case LMEACA
          when 'S' then 'Saida'
          else 'Entrada'
       end as 'acao',
       case LMEINFALT
          when 'C' then 'Compras'
          when 'E' then 'Estoque'
          when 'P' then 'Pendencia'
          else 'Reserva'
       end as 'informacao alterada',
       PROCOD    as 'produto',
       LMEUNI    as 'UM',
       LMEQTDATU as 'qtde atual',
       LMEQTDRES as 'qtde reservada',
       LMEQTDPEN as 'qtde pendente',
       LMEQTDCMP as 'qtde comprada',
       LMEQTDMOV as 'qtde movimentada',
       LMEQTDSAL as 'saldo',
       LMELOCEST as 'local do estoque',
       LMEDATHOR as 'data_hora',
       LMEUSU    as 'usuario',
       LMEMOD    as 'modulo'

 from TBS051
where PROCOD='4250354' and LMEINFALT='R' --and LMEROT='PVEN004'
order by LMEREG