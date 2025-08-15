
-- atualiza registros

--declare @data char(8)

-- data da atualizacao da politica de precos
--set @data = '04/12/08'

update TBS015 set
   PDPIPI     = ZZ_PYALIPI,			-- IPI
   PDPDIFICM  = ZZ_PYDICMS,			-- diferenca ICMS
   PDPFRE     = ZZ_PYFRETE,			-- frete
   PDPCUSADM  = ZZ_PYEF,			-- custo administrativo
   PDPMKPCOR1 = ZZ_PYPERC3,			-- margem lucro 1 corporativo
   PDPMKPCOR2 = ZZ_PYPERC4,			-- margem lucro 2 corporativo
   PDPMKPLOJ1 = ZZ_PYPERC1,			-- margem lucro 1 loja
   PDPMKPLOJ2 = ZZ_PYPERC2,			-- margem lucro 2 loja
   PDPPDD1    = ZZ_PYDESC1,			-- desconto 1
   PDPPDD2    = ZZ_PYDESC2,			-- desconto 2
   PDPPDD3    = ZZ_PYDESC3,			-- desconto 3
   PDPPDD4    = ZZ_PYDESC4,			-- desconto 4
   PDPPDD5    = ZZ_PYDESC5,			-- desconto 5
   PDPPREFOR  = ZZ_PYCUSTB,			-- preco fornecedor
   PDPUNI     = ZZ_PYUM,			-- unidade medida
   PDPPREUNI  = ZZ_PYCUSTB,			-- preco unitario
   PDPREDCOR2 = ZZ_PYPER07-ZZ_PYPER06,		-- reducao preco 2 corporativo
   PDPREDLOJ1 = ZZ_PYPER01,			-- reducao preco 1 loja
   PDPREDLOJ2 = ZZ_PYPER02,			-- reducao preco 2 loja
   PDPDATALT  = convert(char,getdate(),112),	-- data alteracao
   PRODES     = ZZ_PYDESCR			-- descricao
  from SERVIDORDADOS.DADOSADV_507.dbo.SZZ010
       where D_E_L_E_T_='' and ZZ_PYCOD collate database_default = PDPCOD collate database_default and
             ZZ_PYCUSTB > 0 --and subString(ZZ_PYFOCOD,1,8) = @data


-- insere registros novos
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
       0,
       ZZ_PYPER07-ZZ_PYPER06,
       0,
       0,
       ZZ_PYPER01,
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
       convert(char,getdate(),112),
       '17530101',
       '',
       convert(char,getdate(),112),
       0,
       0,
       ZZ_PYDESCR
  from SERVIDORDADOS.DADOSADV_507.dbo.SZZ010 C
       where D_E_L_E_T_='' and ZZ_PYCOD like('%[0-9]%') and ZZ_PYCUSTB > 0 and
             not exists(select 'ne' from TBS015 (noLock)
                         where PDPCOD collate database_default = ZZ_PYCOD collate database_default) and
             exists(select 'ex' from TBS010 (noLock)
                     where PROCOD collate database_default = Ltrim(ZZ_PYCOD) collate database_default) and
             not exists(select ZZ_PYCOD from SERVIDORDADOS.DADOSADV_507.dbo.SZZ010 A
                         where D_E_L_E_T_='' and
                               C.ZZ_PYCOD = ZZ_PYCOD and
                               (select count(*) from SERVIDORDADOS.DADOSADV_507.dbo.SZZ010 B
                                 where D_E_L_E_T_='' and B.ZZ_PYCOD = A.ZZ_PYCOD) > 1)
