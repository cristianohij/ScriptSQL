-- Para SQL Server 2012: checa e remove se já existir
IF OBJECT_ID('tempdb..#tab_pis_cofins') IS NOT NULL
    DROP TABLE #tab_pis_cofins;

-- Cria a tabela temporária
CREATE TABLE #tab_pis_cofins (
    codigo INT,
    descricao VARCHAR(255),
    aliquota_pis decimal(4,2),
    aliquota_cofins decimal(4,2)
);

--select * from #tab_pis_cofins

declare @aliquota_pis decimal(4,2), @aliquota_cofins decimal(4,2)

select @aliquota_pis = 1.65, @aliquota_cofins = 7.6


-- Insere os registros
INSERT INTO #tab_pis_cofins (codigo, descricao, aliquota_pis, aliquota_cofins) VALUES
(1,  'Operação Tributável com Alíquota Básica', @aliquota_pis, @aliquota_cofins),
(2,  'Operação Tributável com Alíquota Diferenciada', @aliquota_pis, @aliquota_cofins),
(3,  'Operação Tributável com Alíquota por Unidade de Medida de Produto', @aliquota_pis, @aliquota_cofins),
(4,  'Operação Tributável Monofásica - Revenda a Alíquota Zero', 0, 0),
(5,  'Operação Tributável por Substituição Tributária', @aliquota_pis, @aliquota_cofins),
(6,  'Operação Tributável a Alíquota Zero', 0, 0),
(7,  'Operação Isenta da Contribuição',0 ,0),
(8,  'Operação sem Incidência da Contribuição', 0, 0),
(9,  'Operação com Suspensão da Contribuição', 0, 0),
(49, 'Outras Operações de Saída', @aliquota_pis, @aliquota_cofins),
(50, 'Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno', @aliquota_pis, @aliquota_cofins),
(51, 'Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno', @aliquota_pis, @aliquota_cofins),
(52, 'Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação', @aliquota_pis, @aliquota_cofins),
(53, 'Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno', @aliquota_pis, @aliquota_cofins),
(54, 'Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação', @aliquota_pis, @aliquota_cofins),
(55, 'Operação com Direito a Crédito - Vinculada a Receitas Não Tributadas no Mercado Interno e de Exportação', @aliquota_pis, @aliquota_cofins),
(56, 'Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno e de Exportação', @aliquota_pis, @aliquota_cofins),
(60, 'Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno', @aliquota_pis, @aliquota_cofins),
(61, 'Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno', @aliquota_pis, @aliquota_cofins),
(62, 'Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação', @aliquota_pis, @aliquota_cofins),
(63, 'Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno', @aliquota_pis, @aliquota_cofins),
(64, 'Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação', @aliquota_pis, @aliquota_cofins),
(65, 'Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação', @aliquota_pis, @aliquota_cofins),
(66, 'Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno e de Exportação', @aliquota_pis, @aliquota_cofins),
(67, 'Crédito Presumido - Outras Operações', @aliquota_pis, @aliquota_cofins),
--(70, 'Operação de Aquisição sem Direito a Crédito', 0, 0),
--(71, 'Operação de Aquisição com Isenção', 0, 0),
--(72, 'Operação de Aquisição com Suspensão', 0, 0),
--(73, 'Operação de Aquisição a Alíquota Zero', 0, 0),
--(74, 'Operação de Aquisição sem Incidência da Contribuição', 0, 0),
--(75, 'Operação de Aquisição por Substituição Tributária', 0, 0),
--(98, 'Outras Operações de Entrada', 0, 0),
(99, 'Outras Operações', @aliquota_pis, @aliquota_cofins);

-- Consulta os dados
SELECT * FROM #tab_pis_cofins;

-- tabela PIS

IF OBJECT_ID('tempdb..##tabela') IS NOT NULL
    DROP TABLE ##tabela_pis;

select right(replicate('0',6) + Ltrim(str(codigo)),6)                           -- ID PIS
       + Left(dbo.RemoveInvalidChars(descricao) + replicate(' ',60),60)         -- Descrição
       + right(replicate('0',2) + Ltrim(str(codigo)),2)                         -- CST
       + 'P'                                                                    -- Tipo de PIS
       -- Base de cálculo do COFINS. (Se calculado por percentual, senão informar 0). Com 2 casas decimais.
       + '10000'                                                                -- Base de Calculo
       --+ right(replicate('0',4) + Ltrim(str(aliquota_pis)),4)                 -- Alíquota
       + right(replicate('0',4) + Ltrim(str(isnull(aliquota_pis,0)*100,9,0)),4)
       + replicate('0', 10)                                                     -- Valor do PIS
       + 'S'                                                                    -- Excluir Valor de ICMS
       + 'N' as texto                                                           -- Excluir Valor de FCP
  into ##tabela_pis
  from #tab_pis_cofins

select *
  from ##tabela_pis

exec master.dbo.xp_cmdshell 'bcp "select texto from ##tabela" queryout "c:\integros\exporta\djpdv\pis.txt" -c -C 1252 -T';

-- tabela COFINS

IF OBJECT_ID('tempdb..##tabela') IS NOT NULL
    DROP TABLE ##tabela_cofins;

select right(replicate('0',6) + Ltrim(str(codigo)),6)                           -- ID PIS
       + Left(dbo.RemoveInvalidChars(descricao) + replicate(' ',60),60)         -- Descrição
       + right(replicate('0',2) + Ltrim(str(codigo)),2)                         -- CST
       + 'P'                                                                    -- Tipo de PIS
       -- Base de cálculo do PIS. Com 2 casas decimais. Se Tipo de PIS igual a V, informar 0.
       + '10000'                                                                -- Base de Calculo
       --+ right(replicate('0',4) + Ltrim(str(aliquota_pis)),4)                 -- Alíquota
       + right(replicate('0',4) + Ltrim(str(isnull(aliquota_pis,0)*100,9,0)),4)
       + replicate('0', 10)                                                     -- Valor do PIS
       + 'S'                                                                    -- Excluir Valor de ICMS
       + 'N' as texto                                                           -- Excluir Valor de FCP
  into ##tabela_cofins
  from #tab_pis_cofins

select *
  from ##tabela_cofins

exec master.dbo.xp_cmdshell 'bcp "select texto from ##tabela" queryout "c:\integros\exporta\djpdv\cofins.txt" -c -C 1252 -T';