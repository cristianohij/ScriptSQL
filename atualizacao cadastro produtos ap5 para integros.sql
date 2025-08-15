-- atualiza registros
update TBS010 set
   PDPIPI     = ZZ_PYALIPI,		-- IPI
   PDPDIFICM  = ZZ_PYDICMS,		-- diferenca ICMS
   PDPFRE     = ZZ_PYFRETE,		-- frete
   PDPCUSADM  = ZZ_PYEF,		-- custo administrativo
   PDPMKPCOR1 = ZZ_PYPERC3,		-- margem lucro 1 corporativo
   PDPMKPCOR2 = ZZ_PYPERC4,		-- margem lucro 2 corporativo
   PDPMKPLOJ1 = ZZ_PYPERC1,		-- margem lucro 1 loja
   PDPMKPLOJ2 = ZZ_PYPERC2,		-- margem lucro 2 loja
   PDPPDD1    = ZZ_PYDESC1,		-- desconto 1
   PDPPDD2    = ZZ_PYDESC2,		-- desconto 2
   PDPPDD3    = ZZ_PYDESC3,		-- desconto 3
   PDPPDD4    = ZZ_PYDESC4,		-- desconto 4
   PDPPDD5    = ZZ_PYDESC5,		-- desconto 5
   PDPPREFOR  = ZZ_PYCUSTB,		-- preco fornecedor
   PDPUNI     = ZZ_PYUM,		-- unidade medida
   PDPPREUNI  = ZZ_PYCUSTB,		-- preco unitario
   PDPREDCOR2 = ZZ_PYPER07-ZZ_PYPER06,	-- reducao preco 2 corporativo
   PDPREDLOJ1 = ZZ_PYPER01,		-- reducao preco 1 loja
   PDPREDLOJ2 = ZZ_PYPER02,		-- reducao preco 2 loja
   PRODES     = ZZ_PYDESCR		-- descricao
  from DADOSAP5.dbo.SZZ010
       where D_E_L_E_T_='' and ZZ_PYCOD collate database_default = PDPCOD collate database_default and
             ZZ_PYCUSTB > 0 and ZZ_PYCOD='1640054'


-- insere registro novos
insert into TBS015 (
   PDPEMPCOD,		-- empresa
   PDPCOD,		-- codigo produto
   PDPPROEMP,		-- empresa produto
   PDPIPI,		-- IPI
   PDPDIFICM,		-- diferenca ICMS
   PDPPIS,		-- PIS
   PDPCOF,		-- cofins
   PDPFRE,		-- frete
   PDPCUSADM,		-- custo administrativo
   PDPCMS,		-- comissao
   PDPMKPCOR1,		-- margem lucro 1 corporativo
   PDPMKPCOR2,		-- margem lucro 2 corporativo
   PDPMKPLOJ1,		-- margem lucro 1 loja
   PDPMKPLOJ2,		-- margem lucro 2 loja
   PDPMKPREV1,		-- margem lucro 1 revenda
   PDPMKPREV2,		-- margem lucro 2 revenda
   PDPMKPWE11,		-- margem lucro 1 web1
   PDPMKPWE12,		-- margem lucro 2 web1
   PDPMKPWE21,		-- margem lucro 1 web2
   PDPMKPWE22,		-- margem lucro 2 web2
   PDPMKPPRO1,		-- margem lucro 1 promocao
   PDPMKPPRO2,		-- margem lucro 2 promocao
   PDPVALPROI,		-- data validade inicial promocao
   PDPVALPROF,		-- data validade final promocao
   PDPPROCOR,		-- promocao valida corporativo
   PDPPROLOJ,		-- promocao valida loja
   PDPPROWE1,		-- promocao valida web1
   PDPPROWE2,		-- promocao valida web2
   PDPPROREV,		-- promocao valida revenda
   PDPPDD1,		-- desconto 1
   PDPPDD2,		-- desconto 2
   PDPPDD3,		-- desconto 3
   PDPPDD4,		-- desconto 4
   PDPPDD5,		-- desconto 5
   PDPPREFOR,		-- preco fornecedor
   PDPUNI,		-- unidade medida
   PDPQTDEMB,		-- quantidade embalagem
   PDPPREUNI,		-- preco unitario
   PDPSEGFOR,		-- politica precos do fornecedor
   PDPREDCOR1,		-- reducao preco 1 corporativo
   PDPREDCOR2,		-- reducao preco 2 corporativo
   PDPREDCOR3,		-- reducao preco 3 corporativo
   PDPREDCOR4,		-- reducao preco 4 corporativo
   PDPREDLOJ1,		-- reducao preco 1 loja
   PDPREDLOJ2,		-- reducao preco 2 loja
   PDPREDLOJ3,		-- reducao preco 3 loja
   PDPREDLOJ4,		-- reducao preco 4 loja
   PDPREDREV1,		-- reducao preco 1 revenda
   PDPREDREV2,		-- reducao preco 2 revenda
   PDPREDREV3,		-- reducao preco 3 revenda
   PDPREDREV4,		-- reducao preco 4 revenda
   PDPREDWE11,		-- reducao preco 1 web1
   PDPREDWE12,		-- reducao preco 2 web1
   PDPREDWE13,		-- reducao preco 3 web1
   PDPREDWE14,		-- reducao preco 4 web1
   PDPREDWE21,		-- reducao preco 1 web2
   PDPREDWE22,		-- reducao preco 2 web2
   PDPREDWE23,		-- reducao preco 3 web2
   PDPREDWE24,		-- reducao preco 4 web2
   PDPREDPRO1,		-- reducao preco 1 promocao
   PDPREDPRO2,		-- reducao preco 2 promocao
   PDPREDPRO3,		-- reducao preco 3 promocao
   PDPREDPRO4,		-- reducao preco 4 promocao
   PDPDATALT,		-- data alteracao
   PDPDATATU,		-- data atualizacao
   PDPSEL,		-- selecacao item
   PDPDATCAD,		-- data cadastro   
   MOEEMPCOD,		-- empresa moeda
   MOECOD,		-- moeda
   PRODES		-- descricao
)
select 0,
       ZZ_PYCOD,
       0,
       ZZ_PYALIPI,
       ZZ_PYDICMS,
       0,
       0,
       ZZ_PYFRETE,
       ZZ_PYEF,
       0,
       ZZ_PYPERC3,
       ZZ_PYPERC4,
       ZZ_PYPERC1,
       ZZ_PYPERC2,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       '17530101',
       '17530101',
       'N',
       'N',
       'N',
       'N',
       'N',
       ZZ_PYDESC1,
       ZZ_PYDESC2,
       ZZ_PYDESC3,
       ZZ_PYDESC4,
       ZZ_PYDESC5,
       ZZ_PYCUSTB,
       ZZ_PYUM,
       1,
       ZZ_PYCUSTB,
       'N',
       ZZ_PYPER01,
       ZZ_PYPER07-ZZ_PYPER06,
       0,
       0,
       0,
       ZZ_PYPER02,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       getdate(),
       '17530101',
       '',
       getdate(),
       0,
       0,
       ZZ_PYDESCR
  from DADOSAP5.dbo.SZZ010
       where D_E_L_E_T_='' and ZZ_PYCOD like('%[0-9]%') and ZZ_PYCUSTB > 0 and ZZ_PYCOD='1640054' and
             not exists(select 'ne' from TBS015
                         where PDPCOD collate database_default = ZZ_PYCOD collate database_default) and
             exists(select 'ex' from TBS010
                     where PROCOD collate database_default = Ltrim(ZZ_PYCOD) collate database_default)


-- atualiza registros
update TBS010 set
   PRODES = B1_DESC,
   PROCODBAR1 = B1_CODBAR,
   PROSTATUS = B1_PYATIVO,
   PROUM1 = B1_UM,
   PROUM2 = B1_UM2,
   PROUM2QTD = B1_UM2TO1,
   PROUM3 = B1_UM3,
   PROUM3QTD = B1_UM3TO1,
   PROUM4 = B1_UM4,
   PROUM4QTD = B1_UM4TO1,
   PROICMSSAI = B1_PICM,
   PROLOCFIS = B1_LOCFISI,
   PROSTBA = subString(B1_GRTRIB,1,1),
   PROSTBB = subString(B1_GRTRIB,2,2),


insert into TBS010 (
   PROEMPCOD,		-- empresa produto
   PROCOD,		-- codigo produto
   PRODES,		-- descricao produto
   PROCODBAR1,		-- codigo barras 1a unidade
--   PROCODBAR2,		-- codigo barras 2a unidade
--   PROCODBAR3,		-- codigo barras 3a unidade
--   PROCODBAR4,		-- codigo barras 4a unidade
   PROSTATUS,		-- status
--   PROPESLIQ,		-- peso liquido
--   PROPESBRU,		-- peso bruto
   PROEMPUM,		-- empresa unidades medidas
   PROUM1,		-- unidade medida 1
   PROUM1QTD,		-- quantidade embalagem 1
   PROUM2,		-- unidade medida 2
   PROUM2QTD,		-- quantidade embalagem 2
   PROUM3,		-- unidade medida 3
   PROUM3QTD,		-- quantidade embalagem 3
   PROUM4,		-- unidade medida 4
   PROUM4QTD,		-- quantidade embalagem 4
--   GRUCOD,		-- grupo produtos
--   GRUEMPCOD,		-- empresa grupo produtos
--   PRODATVAL,		-- data validade
--   FORCOD,		-- codigo fornecedor
--   FOREMPCOD,		-- empresa fornecedor
--   MARCOD,		-- codigo marca
--   MAREMPCOD,		-- empresa marca
   PROICMSSAI,		-- ICMS saida
--   PROICMSENT,		-- ICMS entrada
--   PROPBISAI,		-- percentual base calculo ICMS saida
--   PROPBIENT,		-- percentual base calculo ICMS entrada
--   PROIPI,		-- IPI
   PRODATCAD,		-- data cadastro
--   FABCOD,		-- codigo fabricante
--   FABEMPCOD,		-- empresa fabricante
   PROLOCFIS,		-- localizacao fisica
--   PROREFFOR,		-- referencia/codigo produto fornecedor
--   PROISS,		-- percentual ISS
   PROSTBA,		-- situacao tributaria - tabela A
   PROSTBB,		-- situacao tributaria - tabela B
--   PROPRIVEN,		-- data primeira venda
--   PROPVDVAL,		-- valor primeira venda
--   PROPVDNFS,		-- numero NF primeira venda
--   PROUVDDAT,		-- data ultima venda
--   PROUVDVAL,		-- valor ultima venda
--   PROUVDNFS,		-- numero NF ultima venda
--   PROMVDDAT,		-- data maior venda
--   PROMVDVAL,		-- valor maior venda
--   PROMVDNFS,		-- numero NF maior venda
--   PROPRICOM,		-- data primeira compra
--   PROPCPVAL,		-- valor primeira compra
--   PROPCPNFE,		-- numero NF primeira compra
--   PROUCPDAT,		-- data ultima compra
--   PROUCPVAL,		-- valor ultima compra
--   PROUCPNFE,		-- numero NF ultima compra
--   PROMCPDAT,		-- data maior compra
--   PROMCPVAL,		-- valor maior compra
--   PROMCPNFE,		-- numero NF maior compra
   PROGERPEN,		-- se produto deve gerar pendencia
--   PROSAIEMP,		-- empresa tipo saida padrao
--   PROSAICOD,		-- codigo tipo de saida padrao
--   PROENTEMP,		-- empresa tipo entrada padrao
--   PROENTCOD,		-- codigo tipo entrada padrao
--   PROWEB,		-- produto web
--   MARNOM,		-- nome marca
--   FORNOM,		-- nome fornecedor
--   PROSTBENTA,		-- situacao tributaria - tabela A (origem) - entrada
--   PROSTBENTB,		-- situacao tributaria - tabela B (ICMS) - entrada
)
select 
   0,
   B1_COD,
   B1_DESC,
   B1_CODBAR,
   B1_PYATIVO,
   0,
   B1_UM,
   1,
   B1_UM2,
   B1_UM2TO1,
   B1_UM3,
   B1_UM3TO1,
   B1_UM4,
   B1_UM4TO1,
   B1_PICM,
   convert(char,getdate(),112),
   B1_LOCFISI,
   subString(B1_GRTRIB,1,1),
   subString(B1_GRTRIB,2,2),
   'S'
  from DADOSAP5.dbo.SB1010
       where D_E_L_E_T_='' and B1_COD like('%[0-9]%') and
             not exists(select 'ne' from TBS010 where PROCOD = B1_COD)

insert into TBS032 (
   ESTLOC,		-- local estoque
   PROCOD,		-- codigo produto
   PRODES,		-- descricao do produto
   ESTDATCAD,		-- data cadastro
   FORCOD,		-- codigo fornecedor
   MARCOD,		-- codigo marca
   PROSTATUS,		-- status
)
select
   1,
   PROCOD,
   PRODES,
   convert(char,getdate(),112),
   FORCOD,
   MARCOD,
   PROSTATUS
 from TBS010
where not exists(select 'ne' from TBS032 where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD)

  from DADOSAP5.dbo.SZZ010
       where D_E_L_E_T_='' and ZZ_PYCOD like('%[0-9]%') and ZZ_PYCUSTB > 0 and ZZ_PYCOD='1640054' and
             not exists(select 'ne' from TBS015
                         where PDPCOD collate database_default = ZZ_PYCOD collate database_default) and
             exists(select 'ex' from TBS010
                     where PROCOD collate database_default = Ltrim(ZZ_PYCOD) collate database_default)