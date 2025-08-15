-- clientes
update TBS024 set TBSVALSEQ=(select isnull(max(CLICOD),0) from TBS002 (noLock)) from TBS024 where TBSNOM='TBS002' and TBSSEQ='S'

-- vendedores
update TBS024 set TBSVALSEQ=(select isnull(max(VENCOD),0) from TBS004 (noLock)) from TBS024 where TBSNOM='TBS004' and TBSSEQ='S'

-- transportadoras
update TBS024 set TBSVALSEQ=(select isnull(max(TRNCOD),0) from TBS005 (noLock)) from TBS024 where TBSNOM='TBS005' and TBSSEQ='S'

-- fornecedores
update TBS024 set TBSVALSEQ=(select isnull(max(FORCOD),0) from TBS006 (noLock)) from TBS024 where TBSNOM='TBS006' and TBSSEQ='S'

-- condicoes de pagto
update TBS024 set TBSVALSEQ=(select isnull(max(CPGCOD),0) from TBS008 (noLock)) from TBS024 where TBSNOM='TBS008' and TBSSEQ='S'

-- ramo atividades
update TBS024 set TBSVALSEQ=(select isnull(max(RAMCOD),0) from TBS009 (noLock)) from TBS024 where TBSNOM='TBS009' and TBSSEQ='S'

-- grupos
update TBS024 set TBSVALSEQ=(select isnull(max(GRUCOD),0) from TBS012 (noLock)) from TBS024 where TBSNOM='TBS012' and TBSSEQ='S'

-- marcas
update TBS024 set TBSVALSEQ=(select isnull(max(MARCOD),0) from TBS014 (noLock)) from TBS024 where TBSNOM='TBS014' and TBSSEQ='S'

-- grupos de usuários
update TBS024 set TBSVALSEQ=(select isnull(max(MARCOD),0) from TBS014 (noLock)) from TBS024 where TBSNOM='TBS017' and TBSSEQ='S'

-- empresas
update TBS024 set TBSVALSEQ=(select isnull(max(MARCOD),0) from TBS014 (noLock)) from TBS024 where TBSNOM='TBS023' and TBSSEQ='S'

-- tabelas preços
update TBS024 set TBSVALSEQ=(select isnull(max(MARCOD),0) from TBS014 (noLock)) from TBS024 where TBSNOM='TBS026' and TBSSEQ='S'

-- fabricantes
update TBS024 set TBSVALSEQ=(select isnull(max(FABCOD),0) from TBS028 (noLock)) from TBS024 where TBSNOM='TBS028' and TBSSEQ='S'

-- locais estoque
update TBS024 set TBSVALSEQ=(select isnull(max(CCSCOD),0) from TBS036 (noLock)) from TBS024 where TBSNOM='TBS034' and TBSSEQ='S'

-- centro custo
update TBS024 set TBSVALSEQ=(select isnull(max(CCSCOD),0) from TBS036 (noLock)) from TBS024 where TBSNOM='TBS036' and TBSSEQ='S'

-- moedas
update TBS024 set TBSVALSEQ=(select isnull(max(MOECOD),0) from TBS044 (noLock)) from TBS024 where TBSNOM='TBS044' and TBSSEQ='S'

-- pedidos compras
update TBS024 set TBSVALSEQ=(select isnull(max(PDCNUM),0) from TBS045 (noLock)) from TBS024 where TBSNOM='TBS045' and TBSSEQ='S'

-- compradores
update TBS024 set TBSVALSEQ=(select isnull(max(COMCOD),0) from TBS046 (noLock)) from TBS024 where TBSNOM='TBS046' and TBSSEQ='S'

-- requisitantes
update TBS024 set TBSVALSEQ=(select isnull(max(REQCOD),0) from TBS047 (noLock)) from TBS024 where TBSNOM='TBS047' and TBSSEQ='S'

-- solicitacao compras
update TBS024 set TBSVALSEQ=(select isnull(max(SDCNUM),0) from TBS076 (noLock)) from TBS024 where TBSNOM='TBS076' and TBSSEQ='S'

-- movimentos internos
update TBS024 set TBSVALSEQ=(select isnull(max(MVIDOC),0) from TBS037 (noLock)) from TBS024 where TBSNOM='TBS037' and TBSSEQ='S'

-- manutencao saldos
update TBS024 set TBSVALSEQ=(select isnull(max(MDSREG),0) from TBS049 (noLock)) from TBS024 where TBSNOM='TBS049' and TBSSEQ='S'

-- fechamento comissoes
update TBS024 set TBSVALSEQ=(select isnull(max(CMSDOC),0) from TBS070 (noLock)) from TBS024 where TBSNOM='TBS070' and TBSSEQ='S'

-- cartao correcao
update TBS024 set TBSVALSEQ=(select isnull(max(CACDOC),0) from TBS073 (noLock)) from TBS024 where TBSNOM='TBS073' and TBSSEQ='S'

-- motivos baixas
update TBS024 set TBSVALSEQ=(select isnull(max(MOBCOD),0) from TBS074 (noLock)) from TBS024 where TBSNOM='TBS074' and TBSSEQ='S'

-- bancos
update TBS024 set TBSVALSEQ=(select isnull(max(BCONUM),0) from TBS077 (noLock)) from TBS024 where TBSNOM='TBS077' and TBSSEQ='S'

-- regiões vendas
update TBS024 set TBSVALSEQ=(select isnull(max(BCONUM),0) from TBS077 (noLock)) from TBS024 where TBSNOM='TBS097' and TBSSEQ='S'

-- prospect
update TBS024 set TBSVALSEQ=(select isnull(max(PSTCOD),0) from TBS038 (noLock)) from TBS024 where TBSNOM='TBS038' and TBSSEQ='S'

-- orcamentos
update TBS024 set TBSVALSEQ=(select isnull(max(ORCNUM),0) from TBS043 (noLock)) from TBS024 where TBSNOM='TBS043' and TBSSEQ='S'

-- pedidos de vendas
update TBS024 set TBSVALSEQ=(select isnull(max(PDVNUM),0) from TBS055 (noLock)) from TBS024 where TBSNOM='TBS055' and TBSSEQ='S'

-- regras de operações de saídas
update TBS024 set TBSVALSEQ=(select isnull(max(ROPREG),0) from TBS110 (noLock)) from TBS024 where TBSNOM='TBS110' and TBSSEQ='S'

-- categorias de contas
update TBS024 set TBSVALSEQ=(select isnull(max(CTCCOD),0) from TBS126 (noLock)) from TBS024 where TBSNOM='TBS126' and TBSSEQ='S'

-- categorias de fluxo de caixa
update TBS024 set TBSVALSEQ=(select isnull(max(CTFCOD),0) from TBS127 (noLock)) from TBS024 where TBSNOM='TBS127' and TBSSEQ='S'

