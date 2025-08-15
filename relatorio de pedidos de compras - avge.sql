print 'número-pedido;empresa;código-fornecedor;nome-fornecedor;comprador;código-produto;descrição-produto;unidade;quantidade;preço-fornecedor;valor-st;valor-desconto;valor-ipi;preço-compra;valor-total;preço-compra;valor-total;qtde-entregue;qtde-residual;qtde-pendente;previsão-entrega;condição-pagto;tipo-vencimento;gera-duplicata;emissão'
select 'número-pedido','empresa','código-fornecedor','nome-fornecedor','comprador','código-produto','descrição-produto','unidade','quantidade','preço-fornecedor','valor-st','valor-desconto','valor-ipi','preço-compra','valor-total','preço-compra','valor-total','qtde-entregue','qtde-residual','qtde-pendente','previsão-entrega','condição-pagto','tipo-vencimento','gera-duplicata','emissão'

select TBS045.PDCNUM as 'número-pedido',
       (select TBS023.EMPNOMFAN from TBS023 (nolock) where EMPCOD = 2) as 'empresa',
       TBS045.FORCOD as 'código-fornecedor',
       TBS006.FORNOM as 'nome-fornecedor',
       isnull(TBS046.COMNOM,'') as 'comprador',
       TBS0451.PROCOD as 'código-produto',
       TBS0451.PDCDES as 'descrição-produto',
       TBS0451.PDCUNI as 'unidade',
       TBS0451.PDCQTD as 'quantidade',
       TBS0451.PDCPRE as 'preço-fornecedor',
       TBS0451.PDCPRE * TBS0451.PDCPORST /100 as 'valor-ST',
       dbo.PDCVDDITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE) as 'valor-desconto',
       TBS0451.PDCPRE * TBS0451.PDCIPI /100 as 'valor-ipi',
       -- calculado por porcentagem sobre porcentagem
       dbo.PDCPRELIQ(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE) as 'preço-compra',
       dbo.PDCTOTITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE) as 'valor-total',
       -- calculado com valores separadamente
       (TBS0451.PDCPRE - dbo.PDCVDDITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)) + (TBS0451.PDCPRE * TBS0451.PDCIPI /100) + (TBS0451.PDCPRE * TBS0451.PDCPORST /100) as 'preço-compra',
       TBS0451.PDCQTD * ((TBS0451.PDCPRE - dbo.PDCVDDITE(TBS0451.PDCEMPCOD,TBS0451.PDCNUM,TBS0451.PDCITE)) + (TBS0451.PDCPRE * TBS0451.PDCIPI /100) + (TBS0451.PDCPRE * TBS0451.PDCPORST /100)) as 'valor-total',
       TBS0451.PDCQTDENT as 'qtde-entregue',
       TBS0451.PDCQTDRES as 'qtde-residual',
       TBS0451.PDCQTD - (TBS0451.PDCQTDENT + TBS0451.PDCQTDRES) as 'qtde-pendente',
       TBS0451.PDCDATPRE as 'previsão-entrega',
       isnull(TBS008.CPGCOND,'') as 'condição-pagto',
       case TBS008.CPGTIPVEN
          when 'DD' then 'DATA DO DIA' 
          when 'FD' then 'FORA O DIA'
          when 'FS' then 'FORA A SEMANA'
          when 'FZ' then 'FORA A DEZENA'
          when 'FQ' then 'FORA A QUINZENA'
          when 'FM' then 'FORA O MES'
          else ''
       end as 'tipo-vencimento',
       isnull(TBS008.CPGGERDUP,'') as 'gera-duplicata',
       TBS045.PDCDATCAD as 'emissão'
  from TBS045 (nolock) right join TBS0451 (nolock) on TBS045.PDCEMPCOD = TBS0451.PDCEMPCOD and TBS045.PDCNUM = TBS0451.PDCNUM
                       left  join TBS006 (nolock) on TBS006.FOREMPCOD = TBS045.FOREMPCOD and TBS006.FORCOD = TBS045.FORCOD
                       left  join TBS046 (nolock) on TBS046.COMEMPCOD = TBS046.COMEMPCOD and TBS046.COMCOD = TBS045.COMCOD
                       left  join TBS008 (nolock) on TBS008.CPGEMPCOD = TBS045.PDCCPGEMP and TBS008.CPGCOD = TBS045.PDCCPGCOD
 where TBS045.PDCDATCAD between '20121203' and '20121212'




-- notas fiscais de entradas

select 'empresa','nota-fiscal','emissão-nota-fiscal','série','código-fornecedor','nome-fornecedor','efetivada','código-produto','descrição-produto',
       'unidade-fornecedor','quantidade-nota','qtde-embalagem-fornecedor','valor-desconto','preço-produto','valor-total','valor-IPI','valor-ICMS',
       'número-pedido-compras','emissão-pedido-compras','unidade-pedido-compras','qtde-pendente-pedido-compras','qtde-embalagem-pedido-compras','qtde-atendida-pedido-compras'

select (select TBS023.EMPNOMFAN from TBS023 (nolock) where EMPCOD = 2) as 'empresa',
       TBS059.NFENUM as 'nota-fiscal',
       TBS059.NFEDATEMI as 'emissão-nota-fiscal',
       TBS059.SERCOD as 'série',
       TBS059.NFECOD as 'código-fornecedor',
       TBS059.NFENOM as 'nome-fornecedor',
       TBS059.NFEUSUEFE as 'efetivada',
       TBS0591.PROCOD as 'código-produto',
       TBS0591.NFEDES as 'descrição-produto',
       TBS0591.NFEUNI as 'unidade-fornecedor',
       TBS0591.NFEQTD as 'quantidade-nota',
       TBS0591.NFEQTDEMB as 'qtde-embalagem-fornecedor',
       dbo.NFEVDDITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE) as 'valor-desconto',
       dbo.NFEPRELIQ(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE) as 'preço-produto',
       dbo.NFETOTITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE) as 'valor-total',
       dbo.NFEVALIPI(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE) as 'valor-IPI',
       dbo.NFEVALICMS(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE) as 'valor-ICMS',
       isnull(TBS0592.NFEPEDNUM,0) as 'número-pedido-compras',
       isnull((select PDCDATCAD from TBS045 (nolock) where TBS045.PDCEMPCOD = TBS0592.NFEPEDEMP and TBS045.PDCNUM = TBS0592.NFEPEDNUM),'') as 'emissão-pedido-compras',
       isnull(TBS0592.NFEPEDUNI,'') as 'unidade-pedido-compras',
       isnull(TBS0592.NFEPEDQTD,0) as 'qtde-pendente-pedido-compras',
       isnull(TBS0592.NFEPEDEMB,0) as 'qtde-embalagem-pedido-compras',
       isnull(TBS0592.NFEATEQTD,0) as 'qtde-atendida-pedido-compras'
  from TBS059 (nolock)      join TBS0591 (nolock) on TBS059.NFEEMPCOD = TBS0591.NFEEMPCOD and TBS059.NFETIP = TBS0591.NFETIP and TBS059.NFENUM = TBS0591.NFENUM and 
                                                     TBS059.SEREMPCOD = TBS0591.SEREMPCOD and TBS059.SERCOD = TBS0591.SERCOD
                       left join TBS0592 (nolock) on TBS0591.NFEEMPCOD = TBS0592.NFEEMPCOD and TBS0591.NFETIP = TBS0592.NFETIP and
                                                     TBS0591.NFENUM = TBS0592.NFENUM and TBS0591.SEREMPCOD = TBS0592.SEREMPCOD and
                                                     TBS0591.SERCOD = TBS0592.SERCOD and TBS0592.NFETIPPED = 'C' and TBS0591.NFEPDCNUM = TBS0592.NFEPEDNUM and
                                                     TBS0591.NFEPDCITE = TBS0592.NFEPEDITE
 where TBS059.NFETIP = 'N' and
       TBS059.NFEDATEMI between '20121203' and '20121212'

declare @datade char(8),@dataate char(8)

set @datade  = '20120701'
set @dataate = '20121231'

select TBS0591.PROCOD as 'código-produto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD = TBS0591.PROCOD) as 'descricao-produto',
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS0591.PROCOD) as 'unidade',
       (select TBS014.MARNOM from TBS010 (nolock) join TBS014 (nolock) on TBS010.MAREMPCOD = TBS014.MAREMPCOD and TBS010.MARCOD = TBS014.MARCOD
         where TBS010.PROCOD = TBS0591.PROCOD) as 'marca',
       sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB) as 'qtde-comprada',
       sum(dbo.NFETOTITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE)) as 'valor-total'
  from TBS0591 (nolock) join TBS059 (nolock) on TBS059.NFEEMPCOD = TBS0591.NFEEMPCOD and TBS059.NFETIP = TBS0591.NFETIP and TBS059.NFENUM = TBS0591.NFENUM and 
                                                TBS059.SEREMPCOD = TBS0591.SEREMPCOD and TBS059.SERCOD = TBS0591.SERCOD
 where TBS059.NFEDATEMI between @datade and @dataate and
       TBS059.NFEUSUEFE <> '' and
       TBS059.NFETIP = 'N' and
       TBS059.NFENOM not Like('%BEST BAG%') and TBS059.NFENOM not Like('%BEST OFFICE%') and TBS059.NFENOM not Like('%MISASPEL%') and
       TBS059.NFENOM not Like('%PAPELYNA%') and TBS059.NFENOM not Like('%TANBY%')
 group by TBS0591.PROCOD
