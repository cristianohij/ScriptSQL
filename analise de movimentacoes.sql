/*	LMEDOC      -> documento
        LMEROT      -> nome da rotina
        LMEDESROT   -> descricao da rotina
        LMEACA      -> acao da rotina E=entrada; S=saida
        LMEINFALT   -> informacao alterada
        PROCOD      -> codigo do produto
        PROEMPCOD   -> empresa do produto
        LMEUNI      -> unidade de medida
        LMEQTDATU   -> quantidade atual
        LMEQTDRES   -> quantidade reservada
        LMEQTDPEN   -> quantidade pendente
        LMEQTDCMP   -> quantidade comprada
        LMEQTDMOV   -> quantidade movimentada
        LMEQTDSAL   -> quantidade anterior
        LMELOCEST   -> local do estoque
*/
select LMEREG    as 'registro',
       LMEDATHOR as 'data/hora',
       LMEDOC    as 'documento',
       LMEROT    as 'nome da rotina',
       LMEDESROT as 'descricao da rotina',
       LMEACA    as 'acao da rotina E=entrada; S=saida',
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
 where PROCOD='1640054' and LMEDATHOR >= '2009-02-23'
 order by LMEREG
