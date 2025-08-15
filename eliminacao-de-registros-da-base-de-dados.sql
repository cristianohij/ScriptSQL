select count(*) from TBS067 (nolock) where NFSDATEMI < '20090701' -- notas fiscais de saídas
select count(*) from TBS055 (nolock) where PDVDATCAD < '20090701' -- pedidos de vendas
select count(*) from TBS043 (nolock) where ORCDATCAD < '20090701' -- orçamentos
select count(*) from MSL001 (nolock) where M1_START_TIME_data < '20090701' -- 
select count(*) from TBS045 (nolock) where PDCDATCAD < '20090701' -- pedidos de compras
select count(*) from TBS037 (nolock) where MVIDATLAN < '20121231' -- movimentos internos
select count(*) from TBS049 (nolock) where MDSLAN < '20121231' -- manutenção dos saldo
select count(*) from TBS051 (nolock) where LMEDATHOR < '20130701' -- log de movimentações do estoque
select count(*) from TBS059 (nolock) where NFEDATEMI < '20090701' -- notas fiscais de entradas
select count(*) from TBS060 (nolock) where HCRDAT < '20090701' -- histórico de contas a receber
select count(*) from TBS062 (nolock) where HCPDAT < '20090701' -- histórico de contas a pagar
select count(*) from TBS069 (nolock) where PDFNFSDAT < '20090701' -- posição do faturamento
select count(*) from TBS073 (nolock) where CACDATEMI < '20090701' -- carta de correção
select count(*) from TBS075 (nolock) where LOGCNABDAT < '20090701' -- log de cnab
select count(*) from TBS076 (nolock) where SDCDATCAD < '20121231' -- solicitações de compras
select count(*) from TBS080 (nolock) where ENFDATEMI < '20090701' -- notas fiscais eletrônicas
select count(*) from TBS088 (nolock) where LEPDATHOR < '20111231' -- log de exclusão de produtos
--select count(*) from TBS098 (nolock) where SALREF <= '12/2008' -- notas fiscais eletrônicas
select count(*) from TBS102 (nolock) where LRNDAT <= '20121231' -- log de reserva de número de notas
select count(*) from TBS109 (nolock) where ITIDATEMI <= '20121231' -- itinerário
select count(*) from TBS113 (nolock) where CTEDATEMI <= '20090701' -- cte eletrônico

-- temporárias
select count(*) from TMP001 (nolock)
select count(*) from TMP002 (nolock)
select count(*) from TMP003 (nolock)
select count(*) from TMP004 (nolock)
select count(*) from TMP005 (nolock)
select count(*) from TMP006 (nolock)
select count(*) from TMP007 (nolock)
select count(*) from TMP008 (nolock)
select count(*) from TMP009 (nolock)
select count(*) from TMP010 (nolock)

-- últimos 5 anos --------------------------------------------------------------------------------------------------------------------------------------------------

declare @database char(8)

set @database = '20090701'

-- movimentos de vendas do GZ
delete MSL002 where M2_DAT < @database
go
-- registros eliminados =

-- cabeçalho de orçamentos
delete TBS043 where ORCDATCAD < @database
go
-- registros eliminados =

-- itens de orçamentos
delete TBS0431 where not exists(select '' from TBS043 (nolock) where TBS043.ORCEMPCOD=TBS0431.ORCEMPCOD and TBS043.ORCNUM=TBS0431.ORCNUM)
go
-- registros eliminados =

-- cabaçalho de pedidos de compras
delete TBS045 where PDCDATCAD < @database
go
-- registros eliminados =

-- itens de pedidos de compras
delete TBS0451 where not exists(select '' from TBS045 (nolock) where TBS045.PDCEMPCOD=TBS0451.PDCEMPCOD and TBS045.PDCNUM=TBS0451.PDCNUM)
go
-- registros eliminados =

-- cabeçalho de pedidos de vendas
delete TBS055 where PDVDATCAD < @database
go
-- registros eliminados =

-- itens de pedidos de vendas
delete TBS0551 where not exists(select '' from TBS055 (nolock) where TBS055.PDVEMPCOD=TBS0551.PDVEMPCOD and TBS055.PDVNUM=TBS0551.PDVNUM)
go
-- registros eliminados =

-- cabeçalho de notas fiscais de entradas
delete TBS059 where NFEDATEMI < @database
go
-- registros eliminados =

-- itens de notas fiscais de entradas
delete TBS0591
 where not exists(select '' from TBS059 (nolock)
                   where TBS059.NFEEMPCOD=TBS0591.NFEEMPCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFSNUM=TBS0591.NFENUM and TBS059.NFECOD=TBS0591.NFECOD and
                         TBS059.SEREMPCOD=TBS0591.SEREMPCOD and TBS059.SERCOD=TBS0591.SERCOD)
go
-- registros eliminados =

-- pedidos de compras/vendas atualizados por notas fiscais de entradas
delete TBS0592
 where not exists(select '' from TBS059 (nolock)
                   where TBS059.NFEEMPCOD=TBS0592.NFEEMPCOD and TBS059.NFETIP=TBS0592.NFETIP and TBS059.NFSNUM=TBS0592.NFENUM and TBS059.NFECOD=TBS0592.NFECOD and
                         TBS059.SEREMPCOD=TBS0592.SEREMPCOD and TBS059.SERCOD=TBS0592.SERCOD)
go
-- registros eliminados =

-- parcelas das notas fiscais de entradas
delete TBS0593
 where not exists(select '' from TBS059 (nolock)
                   where TBS059.NFEEMPCOD=TBS0593.NFEEMPCOD and TBS059.NFETIP=TBS0593.NFETIP and TBS059.NFSNUM=TBS0593.NFENUM and TBS059.NFECOD=TBS0593.NFECOD and
                         TBS059.SEREMPCOD=TBS0593.SEREMPCOD and TBS059.SERCOD=TBS0593.SERCOD)
go
-- registros eliminados =

-- lote/validade dos itens das notas fiscais de entradas
delete TBS0594
 where not exists(select '' from TBS059 (nolock)
                   where TBS059.NFEEMPCOD=TBS0594.NFEEMPCOD and TBS059.NFETIP=TBS0594.NFETIP and TBS059.NFSNUM=TBS0594.NFENUM and TBS059.NFECOD=TBS0594.NFECOD and
                         TBS059.SEREMPCOD=TBS0594.SEREMPCOD and TBS059.SERCOD=TBS0594.SERCOD)
go
-- registros eliminados =

-- histórico de contas a receber
delete TBS060 where HCRDAT < @database
go
-- registros eliminados =

-- histórico de contas a pagar
delete TBS062 where HCPDAT < @database
go
-- registros eliminados =

-- notas fiscais de saídas
delete TBS067 where NFSDATEMI < @database
go
-- registros eliminados =

-- itens de notas fiscais de saídas
delete TBS0671
 where not exists(select '' from TBS067 (nolock)
                   where TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
                         TBS067.NFSNUM=TBS0671.NFSNUM)
go
-- registros eliminados =

-- pedidos de vendas faturados por notas fiscais de saídas
delete TBS0672
 where not exists(select '' from TBS067 (nolock)
                   where TBS067.NFSEMPCOD=TBS0672.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0672.SNEEMPCOD and TBS067.SNESER=TBS0672.SNESER and
                         TBS067.NFSNUM=TBS0672.NFSNUM)
go
-- registros eliminados =

-- lote/validade dos produtos das notas fiscais de saídas
delete TBS0673
 where not exists(select '' from TBS067 (nolock)
                   where TBS067.NFSEMPCOD=TBS0673.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0673.SNEEMPCOD and TBS067.SNESER=TBS0673.SNESER and
                         TBS067.NFSNUM=TBS0673.NFSNUM)
go
-- registros eliminados =

-- posição do faturamento
delete TBS069 where PDFNFSDAT < @database
go
-- registros eliminados =

-- carta de correção
delete TBS073 where CACDATEMI < @database
go
-- registros eliminados =

-- itens da carta de corração
delete TBS0731 where not exists(select '' from TBS073 (nolock) where TBS073.CACEMPCOD=TBS0731.CACEMPCOD and TBS073.CACDOC=TBS0731.CACDOC)
go
-- registros eliminados =

-- log da carta de corração
delete TBS0732 where not exists(select '' from TBS073 (nolock) where TBS073.CACEMPCOD=TBS0732.CACEMPCOD and TBS073.CACDOC=TBS0732.CACDOC)
go
-- registros eliminados =

-- log de cnab
delete TBS075 where LOGCNABDAT < @database
go
-- registros eliminados =

-- notas fiscais eletrônicas
delete TBS080 where ENFDATEMI < @database
go
-- registros eliminados =

-- log da nota fiscal eletrônica
delete TBS0801 where not exists(select '' from TBS080 (nolock)
                                 where TBS080.ENFEMPCOD=TBS0801.ENFEMPCOD and TBS080.SNEEMPCOD=TBS0801.SNEEMPCOD and TBS080.SNESER=TBS0801.SNESER and 
                                       TBS080.ENFNUM=TBS0801.ENFNUM)
go
-- registros eliminados =

-- ct-e
delete TBS113 where CTEDATEMI < @database
go
-- registros eliminados =

-- itens da ct-e
delete TBS1131 where not exists(select '' from TBS113 (nolock)
                                 where TBS113.CTEEMPCOD=TBS1131.CTEEMPCOD and TBS113.CTESER=TBS1131.CTESER and TBS113.CTENUM=TBS1131.CTENUM)
go
-- registros eliminados =


-- desde do inicio do ano anterior ---------------------------------------------------------------------------------------------------------------------------------

declare @database char(8)

set @database='20121231'

-- movimentos internos
delete TBS037 where MVIDATLAN < @database
-- registros eliminados =

-- itens de movimentos internos
delete TBS0371 where not exists(select '' from TBS037 (nolock) where TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC)
-- registros eliminados =

-- manutenção dos saldo
delete TBS049 where MDSLAN < @database
-- registros eliminados =

-- solicitações de compras
delete TBS076 where SDCDATCAD < @database
-- registros eliminados =

-- log de reserva de número de notas
delete TBS102 where LRNDAT <= @database
-- registros eliminados =

-- itinerário
delete TBS109 where ITIDATEMI <= @database
-- registros eliminados =


-- último ano ------------------------------------------------------------------------------------------------------------------------------------------------------

-- log de movimentações do estoque
delete TBS051 where LMEDATHOR < '20130701'
-- registros eliminados =


-- últimos 2 anos --------------------------------------------------------------------------------------------------------------------------------------------------

declare @database char(8)

set @database='20111231'

 -- log de exclusão de produtos
delete TBS088 where LEPDATHOR < @database
-- registros eliminados =


-- tabelas temporárias ---------------------------------------------------------------------------------------------------------------------------------------------
delete TMP001
delete TMP002
delete TMP003
delete TMP004
delete TMP005
delete TMP006
delete TMP007
delete TMP008
delete TMP009
delete TMP010
