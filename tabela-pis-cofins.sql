-- Para SQL Server 2012: checa e remove se já existir
IF OBJECT_ID('tempdb..#tab_icms') IS NOT NULL
    DROP TABLE #tab_icms;

-- Cria a tabela temporária
create table  #tab_icms (
   id_icms char(6)                                          -- 01
   ,descricao varchar(255)                                  -- 02
   ,cst char(3)                                             -- 03
   ,moda_bc_icms char(1)                                    -- 04
   ,bc_icms char(5) default '00000'                         -- 05
   ,aliq_icms smallint                                      -- 06
   ,moda_bc_icms_st char(1)                                 -- 07
   ,perc_iva char(5) default '00000'                        -- 08
   ,bc_icms_st char(5) default '00000'                      -- 09
   ,aliq_icms_st char(4) default '0000'                     -- 10
   ,reservado char(1) default ' '                           -- 11
   ,bc_ope_propria char(5) default '00000'                  -- 12
   ,csosn char(6) default '      '                          -- 13
   ,aliq_sn char(4) default '0000'                          -- 14
   ,bc_icms_retido char(5) default '00000'                  -- 15
   ,aliq_icms_retido char(4) default '0000'                 -- 16
   ,bc_icms_destino char(5) default '00000'                 -- 17
   ,aliq_icms_destino char(4) default '0000'                -- 18
   ,bc_icms_uf_destino char(5) default '00000'              -- 19
   ,aliq_fcp_destino char(4) default '0000'                 -- 20
   ,aliq_int_uf_destino char(4) default '0000'              -- 21
   ,cfop char(4)                                            -- 22
   ,mot_desoneracao_icms char(2) default '  '               -- 23
   ,bc_fcp char(5) default '00000'                          -- 24
   ,aliq_fcp char(4) default '0000'                         -- 25
   ,bc_fcp_st char(5) default '00000'                       -- 26
   ,alq_fcp_st char(4) default '0000'                       -- 27
   ,bc_fcp_uf_destino char(5) default '00000'               -- 28
   ,bc_icms_efetivo char(5) default '00000'                 -- 29
   ,aliq_icms_efetivo char(4) default '0000'                -- 30
   ,somar_out_desp_bc_icms char(1) default 'N'              -- 31
   ,suj_repasse_interestadual char(1) default '0'           -- 32
   ,aliq_cons_final_st char(5) default '00000'              -- 33
   ,bc_icms_substituto char(5) default '00000'              -- 34
   ,aliq_substituto char(5) default '00000'                 -- 35
   ,diferimento char(5) default '00000'                     -- 36
   ,substrair_icms_desone char(1) default 'N'               -- 37
   ,difal_base_dupla char(1) default '0'                    -- 38
   ,desc_entra_bc_calculo char(1) default 'N'               -- 39
   ,cod_cred_presumido char(10) default '          '        -- 40
   ,aliq_cred_presumido char(5) default '00000'             -- 41
   ,cod_benef_red_bc_calculo char(10) default '          '  -- 42
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