-- somatório

 select M2_DATMOV as 'data',
        M2_NUMDOC as 'cupom',
        M2_PROCOD as 'produto',
        isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD),'PRODUTO NAO ENCONTRADO'),
        sum(M2_QTD) as 'qtde',
        sum(M2_VALTOT) as 'bruto',
        sum(M2_ABT) as 'abatimento',
        sum(M2_VALTOT)-sum(M2_ABT) as 'liquido',
        sum(M2_PRECUS*M2_QTD) as 'custoTotal',
        avg(M2_VALUNI) as 'precoMedio',
        avg(M2_PRECUS) as 'custoMedio',
        case M2_TIPREG when '10' then 'S' else 'N' end as 'cancelado'
   from MSL002 (nolock)
  where M2_DATMOV between '20130902' and '20130902' and
        ((M2_TIPREG='01' and M2_REGCAN='F') or M2_TIPREG='10')
  group by M2_DATMOV,M2_NUMDOC,M2_TIPREG,M2_PROCOD
  order by M2_DATMOV,M2_NUMDOC,M2_TIPREG,M2_PROCOD
compute count(M2_DATMOV) by M2_DATMOV

-- venda item a item

 select M2_DATMOV as 'data',
        M2_NUMDOC as 'cupom',
        M2_PROCOD as 'produto',
        isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD),'PRODUTO NAO ENCONTRADO'),
        M2_QTD as 'qtde',
        M2_VALTOT as 'bruto',
        M2_ABT as 'abatimento',
        M2_VALTOT-M2_ABT as 'liquido',
        M2_PRECUS*M2_QTD as 'custoTotal',
        M2_VALUNI as 'preco',
        M2_PRECUS as 'custo',
        case M2_TIPREG when '10' then 'S' else 'N' end as 'cancelado'
   from MSL002 (nolock)
  where M2_DATMOV between '20130902' and '20130902' and
        ((M2_TIPREG='01' and M2_REGCAN='F') or M2_TIPREG='10')
  order by M2_PROCOD,M2_DATMOV,M2_NUMDOC,M2_TIPREG
