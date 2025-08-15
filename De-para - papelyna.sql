-- LINK ---------------------------------------------------------------------------------------------------------------------

-- seta banco de dados
   use master

-- elimina o registro do servidor
   sp_dropserver 'SERVERSQL'

-- cria o link com o servidor
   exec sp_addlinkedserver
           @server     = 'SERVERSQL',		-- servidor corporativo
           @srvproduct = 'SQLOLEDB',
           @provider   = 'SQLOLEDB',
           @datasrc    = '192.168.0.3',
           @location   = '192.168.0.3',
           @provstr    = NULL,
           @catalog    = NULL

   exec sp_addlinkedserver
           @server     = 'SERVIDORLOJA',	-- servidor loja
           @srvproduct = 'SQLOLEDB',
           @provider   = 'SQLOLEDB',
           @datasrc    = '192.168.0.9',
           @location   = '192.168.0.9',
           @provstr    = NULL,
           @catalog    = NULL

   exec sp_addlinkedserver
           @server     = 'SERVIDORDADOS',	-- servidor loja
           @srvproduct = 'SQLOLEDB',
           @provider   = 'SQLOLEDB',
           @datasrc    = '192.168.0.6',
           @location   = '192.168.0.6',
           @provstr    = NULL,
           @catalog    = NULL

   exec sp_addlinkedserver
           @server     = 'SERVERSQL',	-- servidor loja
           @srvproduct = 'SQLOLEDB',
           @provider   = 'SQLOLEDB',
           @datasrc    = '192.168.0.7',
           @location   = '192.168.0.7',
           @provstr    = NULL,
           @catalog    = NULL

-- lista servidores registrados
   select * from sysservers


-- CARREGA DADOS ------------------------------------------------------------------------------------------------------------

-- seta banco de dados
   use PAPELYNA

   -- rodar o script "Cria as tabelas que serao importadas sem os indices e com valores default"

-- carrega tabela de CLIENTES -----------------------------------------------------------------------------------------------
   -- criar este atributo primeiro
   alter table TBS002 add codCliente varchar(6) default ''
   alter table TBS002 add Loja varchar(2) default ''

--   begin tran
      insert into TBS002 (
	     CLICOD,									-- codigo do cliente
   	     CLIEMPCOD,									-- empresa
	     CLINOM,									-- nome/razao social
	     CLINOMFAN,									-- nome fantasia
	     CLIEND,									-- endereco
	     CLICEP,									-- CEP
	     CLIBAI,									-- bairro
	     CLICID,									-- cidade
	     CLICONTAT,									-- contato
	     CLITEL,									-- telefone
	     CLIFAX,									-- fax
	     CLIEMAIL,									-- e-mail
	     CLIURL,									-- home page
	     CLICLA,									-- classe
	     CLILIC,									-- limite de credito
	     UFESIG,									-- estado
	     CLIOBS,									-- observacao
	     CLIIES,									-- inscricao estadual
	     CLIIMU,									-- inscricao municipal
	     CLILICVEN,
	     codCliente,								-- codigo do cliente (auxiliar)
             Loja)									-- loja do cliente
      select cast(A1_COD as int),
	     0,
             rTrim(A1_NOME),
	     rTrim(A1_NREDUZ),
	     rTrim(A1_END),
	     rTrim(A1_CEP),
	     rTrim(A1_BAIRRO),
	     rTrim(A1_MUN),
	     rTrim(A1_CONTATO),
	     rTrim(A1_TEL),
	     rTrim(A1_FAX),
	     rTrim(subString(A1_EMAIL,1,40)),
	     rTrim(A1_HPAGE),
	     A1_RISCO,
	     cast(A1_LC as money),
	     A1_EST,
	     rTrim(A1_OBSERV),
	     rTrim(A1_INSCR),
	     rTrim(A1_INSCRM),
	     cast(A1_VENCLC as datetime),
	     codCliente,
             A1_LOJA
        from SA1UNI
       where D_E_L_E_T_=''

   -- realizar as correcoes

-- lista registros da tabela de clientes
   select * from TBS002

-- deleta a tabela de clientes
   delete from TBS002


-- carrega tabela de OUTROS ENDERECOS (clientes) - endereco para cobrancas --------------------------------------------------
--   begin tran
--   COBRANCA
      insert into TBS003 (
	     ENDCOD,									-- codigo do cliente
	     ENDTIP,									-- tipo de endereco 1=cobranca
											--		    2=entrega
											--		    3=correspondecia
	     ENDEMPCOD,									-- empresa
             ENDEND,									-- endereco
	     ENDBAI,									-- bairro
	     ENDCID,									-- cidade
	     ENDCEP,									-- CEP
             UFESIG)									-- estado
      select CLICOD,
	     1,										
	     0,
	     rTrim(A1_ENDCOB),
	     rTrim(A1_BAIRROC),
	     rTrim(A1_MUNC),
	     rTrim(A1_CEPC),
             A1_ESTC
        from SA1UNI ,TBS002
       where D_E_L_E_T_='' and A1_ENDCOB not in('','.','O MESMO') and A1_COD=TBS002.codCliente and A1_LOJA=Loja

--   ENTREGA
      insert into TBS003 (
	     ENDCOD,									-- codigo do cliente
	     ENDTIP,									-- tipo de endereco 1=cobranca
											--		    2=entrega
											--		    3=correspondecia
	     ENDEMPCOD,									-- empresa
             ENDEND,									-- endereco
	     ENDBAI,									-- bairro
	     ENDCID,									-- cidade
	     ENDCEP,									-- CEP
             UFESIG)									-- estado
      select CLICOD,
	     2,										
	     0,
	     rTrim(A1_ENDENT),
	     rTrim(A1_BAIRROE),
	     rTrim(A1_MUNE),
	     rTrim(A1_CEPE),
             A1_ESTE
        from SA1UNI ,TBS002
       where D_E_L_E_T_='' and A1_ENDENT not in('','.','O MESMO') and A1_COD=TBS002.codCliente and A1_LOJA=Loja

   -- realizar as correcoes

-- lista registros da tabela de outros enderecos (clientes)
   select * from TBS003

-- deleta a tabela de outros enderecos (clientes)
   delete from TBS003


-- carrega tabela de VENDEDORES ---------------------------------------------------------------------------------------------
   -- primeiro criar este atributo
   alter table TBS004 add codVendedor varchar(6) default ''

--   begin tran
      insert into TBS004 (
	     VENCOD,									-- codigo do vendedor
	     VENEMPCOD,									-- empresa
             VENNOM,									-- nome do vendedor
	     VENNOMRED,									-- nome reduzido
	     VENEND,									-- endereco
	     VENBAI,									-- bairro
	     VENCID,									-- cidade
	     VENCEP,									-- CEP
	     VENTEL,									-- telefone
	     VENFAX,									-- fax
	     VENEMAIL,									-- e-mail
	     VENURL,									-- home page
	     VENUFESIG,									-- estado
	     codVendedor)								-- codigo do vendedor (auxiliar)
      select 0,
	     0,
	     rTrim(A3_NOME),
	     rTrim(A3_NREDUZ),
	     rTrim(A3_END),
	     rTrim(A3_BAIRRO),
	     rTrim(A3_MUN),
	     rTrim(A3_CEP),
	     rTrim(A3_TEL),
	     rTrim(A3_FAX),
	     rTrim(A3_EMAIL),
	     rTrim(A3_HPAGE),
	     rTrim(A3_EST),
	     A3_COD
        from PHANTOM.DADOSAP5.dbo.SA3010
       where D_E_L_E_T_=''

   -- realizar as correcoes

-- lista registros da tabela de vendedores
   select * from TBS004

-- deleta a tabela de vendedores
   delete from TBS004


-- carrega tabela de TRANSPORTADORAS ----------------------------------------------------------------------------------------
   -- primeiro criar este atributo
   alter table TBS005 add codTransporta varchar(6) default ''

--   begin tran
      insert into TBS005 (
	     TRNCOD,									-- codigo da transportadora
	     TRNEMPCOD,									-- empresa
             TRNNOM,									-- nome da transportadora
	     TRNNOMFAN,									-- nome fantasia
	     TRNEND,									-- endereco
	     TRNCID,									-- cidade
	     TRNCEP,									-- CEP
	     TRNIES,									-- inscricao estadual
	     TRNTEL,									-- telefone
	     TRNEMAIL,									-- e-mail
	     TRNURL,									-- home page
	     TRNCONTAT,									-- contato
	     TRNUFESIG,									-- estado
	     codTransporta)								-- codigo da transportadora (auxiliar)
      select 0,
	     0,
	     rTrim(A4_NOME),
	     rTrim(A4_NREDUZ),
	     rTrim(A4_END),
	     rTrim(A4_MUN),
	     rTrim(A4_CEP),
	     rTrim(A4_INSEST),
	     rTrim(A4_TEL),
	     rTrim(A4_EMAIL),
	     rTrim(A4_HPAGE),
	     rTrim(A4_CONTATO),
	     rTrim(A4_EST),
	     A4_COD
        from SERVERSQL.DADOSADV.dbo.SA4010
       where D_E_L_E_T_=''

   -- realizar as correcoes

-- lista registros da tabela de transportadoras
   select * from TBS005

-- deleta a tabela de transportadoras
   delete from TBS005


-- carrega tabela de FORNECEDORES -------------------------------------------------------------------------------------------
   -- primeiro criar este atributo
   alter table TBS006 add codFornecedor varchar(6) default ''

--   begin tran
      insert into TBS006 (
	     FOREMPCOD,									-- empresa
	     FORCOD,									-- codigo do fornecedor
             FORNOM,									-- nome do fornecedor
	     FORNOMFAN,									-- nome fantasia
	     FOREND,									-- endereco
	     FORBAI,									-- bairro
	     FORCEP,									-- CEP
	     FORCID,									-- cidade
	     UFESIG,									-- estado
	     FORIES,									-- inscricao estadual
	     FORIMU,									-- inscricao municipal
	     FORTEL,									-- telefone
	     FORFAX,									-- fax
	     FOREMAIL,									-- e-mail
	     FORURL,									-- home page
	     FORCONTAT,									-- contato
	     codFornecedor)								-- codigo do fornecedor (auxiliar)
      select 0,
	     0,
	     rTrim(subString(A2_NOME,1,50)),
	     rTrim(A2_NREDUZ),
	     rTrim(A2_END),
	     rTrim(A2_BAIRRO),
	     rTrim(A2_CEP),
	     rTrim(A2_MUN),
	     rTrim(A2_EST),
	     rTrim(A2_INSCR),
	     rTrim(A2_INSCRM),
	     rTrim(subString(A2_TEL,1,15)),
	     rTrim(A2_FAX),
	     rTrim(subString(A2_EMAIL,1,40)),
	     rTrim(A2_HPAGE),
	     rTrim(A2_CONTATO),
	     A2_COD
        from SERVERSQL.DADOSADV.dbo.SA2010
       where D_E_L_E_T_=''

   -- verifica se ha duplicidade
   select FORCOD from TBS006 A where (select count(*) from TBS006 B where B.FORCOD=A.FORCOD) > 1 order by FORCOD

   select max(FORCOD) from TBS006

   select codFornecedor,FORNOM from TBS006 A
    where (select count(*) from TBS006 B where B.codFornecedor=A.codFornecedor) > 1 order by FORCOD

   select * from TBS006 where FORCOD=0

   -- realizar as correcoes

-- lista registros da tabela de fornecedores
   select * from TBS006

-- deleta a tabela de fornecedores
   delete from TBS006


-- carrega tabela de PRODUTOS -----------------------------------------------------------------------------------------------
   -- primeiro criar este atributo
   alter table TBS010 add codProduto varchar(15) default ''

--   begin tran
      insert into TBS010 (
	     PROCOD,									-- codigo do produto
	     PROEMPCOD,									-- empresa
             PRODES,									-- descricao do produto
	     PROCODBAR1,								-- codigo de barras 1
	     PROUM1,									-- 1a unidade de medida
	     PROUM1QTD,									-- quantidade da 1a unidade
	     PROUM2,									-- 2a unidade de medida
	     PROUM2QTD,									-- quantidade da 2a unidade
	     PROUM3,									-- 3a unidade de medida
	     PROUM3QTD,									-- quantidade da 3a unidade
	     PROUM4,									-- 4a unidade de medida
	     PROUM4QTD,									-- quantidade da 4a unidade
	     FORCOD,									-- codigo do fornecedor
	     MARCOD,									-- codigo da marca
	     PROICMSSAI,								-- ICMS de saida
	     PROIPI,									-- IPI do produto
	     PROLOCFIS,									-- localizacao fisica
	     PROSTBA,									-- situacao tributaria, tabela A
	     PROSTBB,									-- situacao tributaria, tabela B
	     PROPBISAI,									-- percentual base calculo ICMS saida
	     PROPBIENT,									-- percentual base calculo ICMS entrada
	     PROGERPEN,									-- produto gera pendencias
	     codProduto)								-- codigo do produto (auxiliar)
      select rTrim(B1_COD),
	     0,
	     rTrim(B1_DESC),
	     rTrim(B1_CODBAR),
	     rTrim(B1_UM),
	     1,
	     rTrim(B1_UM2),
	     B1_UM2TO1,
	     rTrim(B1_UM3),
	     B1_UM3TO1,
	     rTrim(B1_UM4),
	     B1_UM4TO1,
	     cast(B1_PROC as int),
	     cast(subString(B1_COD,1,3) as smallint),
	     B1_PICM,
	     B1_IPI,
	     rTrim(B1_LOCFISI),
	     subString(B1_GRTRIB,1,1),
	     subString(B1_GRTRIB,2,2),
	     100,
	     100,
	     'S',
	     rTrim(B1_COD)
        from SERVIDORDADOS.DADOSADV.dbo.SB1010
       where D_E_L_E_T_='' and B1_COD like('%[0-9]%') and B1_PYATIVO <> 'E'

   -- realizar as correcoes

-- lista registros da tabela de produtos
   select * from TBS010

-- deleta a tabela de produtos
   delete from TBS010


-- carrega tabela de UNIDADES DE MEDIDAS ------------------------------------------------------------------------------------
--   begin tran
      insert into TBS011 (
	     UNICOD,									-- codigo da unidade
	     UNIEMPCOD,									-- empresa
             UNIDES)									-- descricao da unidade
      select AH_UNIMED,
	     0,
	     AH_UMRES
        from SERVIDORDADOS.DADOSADV.dbo.SAH010
       where D_E_L_E_T_=''

   -- realizar as correcoes

-- lista registros da tabela de unidades de medidas
   select * from TBS011

-- deleta a tabela de unidades de medidas
   delete from TBS011


-- carrega tabela de MARCAS DE PRODUTOS -------------------------------------------------------------------------------------
   -- copiado da tabela da tanby



-- carrega tabela de POLITICA DE PRECOS -------------------------------------------------------------------------------------
   -- verifica se ha duplicidade
   select ZZ_PYCOD from SERVERSQL.DADOSADV.dbo.SZZ010 A
    where D_E_L_E_T_='' and
          (select count(*) from SERVERSQL.DADOSADV.dbo.SZZ010 B where D_E_L_E_T_='' and B.ZZ_PYCOD=A.ZZ_PYCOD) > 1
    order by ZZ_PYCOD
   
--   begin tran
      insert into TBS015 (
	     PDPCOD,									-- codigo do produto
	     PDPEMPCOD,									-- empresa
	     PDPIPI,									-- IPI (%)
	     PDPDIFICM,									-- diferenca do ICMS (%)
	     PDPFRE,									-- frete (%)
	     PDPCUSADM,									-- custo administrativo (%)
	     PDPMKPCOR1,								-- markup 1 do corporativo
	     PDPMKPLOJ1,								-- markup 1 da loja
	     PDPPDD1,									-- desconto 1 (%)
	     PDPPDD2,									-- desconto 2 (%)
	     PDPPDD3,									-- desconto 3 (%)
	     PDPPDD4,									-- desconto 4 (%)
	     PDPPDD5,									-- desconto 5 (%)
	     PDPPREFOR,									-- preco do fornecedor
	     PDPSEGFOR,									-- politica de precos segundo fornecedor
	     PDPMKPCOR2,								-- markup 2 do corporativo
	     PDPMKPLOJ2,								-- markup 2 da loja
             PDPREDCOR2,								-- percentual reducao preco 2 corporativo
             PDPREDLOJ2,								-- percentual reducao preco 2 loja
	     PDPPROCOR,									-- promocao valida p/corporativo
	     PDPPROLOJ,									-- promocao valida p/loja
	     PDPPROWE1,									-- promocao valida p/web1
	     PDPPROWE2,									-- promocao valida p/web2
	     PDPPROREV,									-- promocao valida p/revenda
             PDPUNI)									-- unidade de medida
      select rTrim(ZZ_PYCOD),
	     0,
	     ZZ_PYALIPI,
	     ZZ_PYDICMS,
	     ZZ_PYFRETE,
	     ZZ_PYEF,
	     ZZ_PYPERC3,
	     ZZ_PYPERC1,
	     ZZ_PYDESC1,
	     ZZ_PYDESC2,
	     ZZ_PYDESC3,
	     ZZ_PYDESC4,
	     ZZ_PYDESC5,
	     ZZ_PYCUSB2,
	     'N',
	     ZZ_PYPERC4,
	     ZZ_PYPERC2,
             ZZ_PYPER07-ZZ_PYPER06,
             ZZ_PYPER02,
	     'N',
	     'N',
	     'N',
	     'N',
	     'N',
             ZZ_PYUM2
        from SERVIDORDADOS.DADOSADV.dbo.SZZ010
       where D_E_L_E_T_='' and ZZ_PYCOD like('%[0-9]%') and ZZ_PYCUSTB > 0 and
             exists(select 'ex' from TBS010 where PROCOD=Ltrim(ZZ_PYCOD))

   -- realizar as correcoes

-- lista registros da tabela de politica de precos
   select * from TBS015

-- deleta a tabela de politica de precos
   delete from TBS015





-- CORRECOES ----------------------------------------------------------------------------------------------------------------

-- corrige a tabela de CLIENTES ---------------------------------------------------------------------------------------------
   -- lista tabela de clientes
   select * from TBS002 order by CLICOD

   select CLICOD from TBS002 A where (select count(*) from TBS002 B where B.CLICOD=A.CLICOD) > 1 order by CLICOD

   delete TBS002 from TBS002 A where (select count(*) from TBS002 B where B.CLICOD=A.CLICOD) > 1

   -- CEP
   update TBS002 set CLICEP=subString(CLICEP,1,5)+'-'+subString(CLICEP,6,3)

   -- data do cadastro
   update TBS002 set CLIDATCAD=getdate()

   -- CNPJ pessoa juridica
   -- corporativo
   update TBS002 set CLICGC=A1_CGC,CLITIPPES='J' from SERVERSQL.DADOSADV.dbo.SA1010
    where D_E_L_E_T_='' and cast(A1_CGC as float) > 0 and Len(A1_CGC) > 11 and A1_COD=codCliente and Loja='02'

   -- CPF pessoa fisica
   update TBS002 set CLICPF=A1_CGC,CLITIPPES='F' from SERVERSQL.DADOSADV.dbo.SA1010
    where D_E_L_E_T_='' and cast(A1_CGC as float) > 0 and Len(A1_CGC) = 11 and A1_COD=codCliente and Loja='02'

   -- loja
   update TBS002 set CLICGC=A1_CGC,CLITIPPES='J' from SERVIDORLOJA.AP5LOJA.dbo.SA1010
    where D_E_L_E_T_='' and cast(A1_CGC as float) > 0 and Len(A1_CGC) > 11 and A1_COD=codCliente and Loja='01'

   -- CPF pessoa fisica
   update TBS002 set CLICPF=A1_CGC,CLITIPPES='F' from SERVIDORLOJA.AP5LOJA.dbo.SA1010
    where D_E_L_E_T_='' and cast(A1_CGC as float) > 0 and Len(A1_CGC) = 11 and A1_COD=codCliente and Loja='01'

   -- informa se cliente tem isencao do ICMS (desconto) - orgao publico
   update TBS002 set CLIISEICMS='N'

   -- corporativo
   update TBS002 set CLIISEICMS='S' from SERVERSQL.DADOSADV.dbo.SA1010
    where D_E_L_E_T_='' and A1_ATIVIDA='00046' and A1_COD=codCliente and Loja='02'

   -- corporativo
   update TBS002 set CLIISEICMS='S' from SERVIDORLOJA.AP5LOJA.dbo.SA1010
    where D_E_L_E_T_='' and A1_ATIVIDA='00046' and A1_COD=codCliente and Loja='02'

   -- atualiza o codigo do ultimo cliente
   update TBS024 set TBSVALSEQ=(select max(CLICOD) from TBS002) where TBSNOM='TBS002'

   update TBS002 set CLILICVEN='1/1/1753' where CLILICVEN='1900/1/1'

   select distinct A1_COD,A1_VENCLC,cast(A1_VENCLC as datetime) from DADOSAP5.dbo.SA1010 where D_E_L_E_T_=''


-- corrige a tabela de OUTROS ENDERECOS (clientes) --------------------------------------------------------------------------
   -- CEP
   update TBS003 set ENDCEP=subString(ENDCEP,1,5)+'-'+subString(ENDCEP,6,3)

   -- data do cadastro
   update TBS003 set ENDDATCAD=getdate()

   select ENDCOD from TBS003 A where (select count(*) from TBS003 B where B.ENDCOD=A.ENDCOD and B.ENDTIP=A.ENDTIP) > 1
    order by ENDCOD

   -- bloqueio de transacoes
   update TBS002 set CLIBLQTRN='N'

-- corrige a tabela de VENDEDORES -------------------------------------------------------------------------------------------
   -- gera codigos sequencias para os vendedores
   declare @contador int
   declare @registro varchar(6)

   set @contador = 0
   set @registro = (select top 1 codVendedor from TBS004 where VENCOD=0 order by codVendedor)

   while((select count(*) from TBS004 where VENCOD=0) > 0)
      begin
         update TBS004 set VENCOD=@contador +1 where VENCOD=0 and codVendedor=@registro
         
	 set @contador = @contador +1
         set @registro = (select top 1 codVendedor from TBS004 where VENCOD=0 order by codVendedor)

         if((select count(*) from TBS004 where VENCOD=0) > 0)
            continue
         else 
            break
      end

   -- lista tabela de vendedores
   select * from TBS004 order by VENCOD

   -- CEP
   update TBS004 set VENCEP=subString(VENCEP,1,5)+'-'+subString(VENCEP,6,3)

   -- data do cadastro
   update TBS004 set VENDATCAD=getdate()

   -- CPF
   update TBS004 set VENCPF=A3_CGC from PHANTOM.DADOSAP5.dbo.SA3010
    where D_E_L_E_T_='' and cast(A3_CGC as float) > 0 and Len(A3_CGC) = 11 and A3_COD=codVendedor

   -- atualizacao de cadastros - cliente/vendedor
   update TBS002 set VENCOD=TBS004.VENCOD from PHANTOM.DADOSAP5.dbo.SA1010 ,TBS004
    where D_E_L_E_T_='' and codCliente=A1_COD and A1_VEND=codVendedor

   -- atualiza o codigo do ultimo vendedor
   update TBS024 set TBSVALSEQ=(select max(VENCOD) from TBS004) where TBSNOM='TBS004'

   -- atualiza estado e comissao do vendedor
   update TBS004 set VENCALCOM='S' ,VENUFESIG='SP'

-- corrige a tabela de TRANSPORTADORAS --------------------------------------------------------------------------------------
   -- gera codigos sequencias para as transportadoras
   declare @contador int
   declare @registro varchar(6)

   set @contador = 0
   set @registro = (select top 1 codTransporta from TBS005 where TRNCOD=0 order by codTransporta)

   while((select count(*) from TBS005 where TRNCOD=0) > 0)
      begin
         update TBS005 set TRNCOD=@contador +1 where TRNCOD=0 and codTransporta=@registro
         
	 set @contador = @contador +1
         set @registro = (select top 1 codTransporta from TBS005 where TRNCOD=0 order by codTransporta)

         if((select count(*) from TBS005 where TRNCOD=0) > 0)
            continue
         else 
            break
      end

   -- lista tabela de transportadoras
   select * from TBS005 order by TRNCOD

   select TRNCOD from TBS005 A where (select count(*) from TBS005 B where B.TRNCOD=A.TRNCOD) > 1 order by TRNCOD

   select max(TRNCOD) from TBS005

   -- CEP
   update TBS005 set TRNCEP=subString(TRNCEP,1,5)+'-'+subString(TRNCEP,6,3)

   -- data do cadastro
   update TBS005 set TRNDATCAD=getdate()

   -- CNPJ
   update TBS005 set TRNCGC=A4_CGC from SERVERSQL.DADOSADV.dbo.SA4010
    where D_E_L_E_T_='' and cast(A4_CGC as float) > 0 and Len(A4_CGC) > 11 and A4_COD=codTransporta

   -- atualizacao de cadastros - cliente/transportadora
   update TBS002 set TRNCOD=TBS005.TRNCOD from SERVERSQL.DADOSADV.dbo.SA1010 ,TBS005
    where D_E_L_E_T_='' and codCliente=A1_COD and A1_TRANSP=codTransporta

   -- atualiza o codigo da ultima transportadora
   update TBS024 set TBSVALSEQ=(select max(TRNCOD) from TBS005) where TBSNOM='TBS005'


-- corrige a tabela de FORNECEDORES -----------------------------------------------------------------------------------------
   -- gera codigos sequencias para os fornecedores
   declare @contador int
   declare @registro varchar(6)

   set @contador = 0
   set @registro = (select top 1 codFornecedor from TBS006 where FORCOD=0 order by codFornecedor)

   while((select count(*) from TBS006 where FORCOD=0) > 0)
      begin
         update TBS006 set FORCOD=@contador +1 where FORCOD=0 and codFornecedor=@registro
         
	 set @contador = @contador +1
         set @registro = (select top 1 codFornecedor from TBS006 where FORCOD=0 order by codFornecedor)

         if((select count(*) from TBS006 where FORCOD=0) > 0)
            continue
         else 
            break
      end

   -- lista tabela de fornecedores
   select * from TBS006 order by FORCOD

   -- CEP
   update TBS006 set FORCEP=subString(FORCEP,1,5)+'-'+subString(FORCEP,6,3)

   -- data do cadastro
   update TBS006 set FORDATCAD=getdate()

   -- CNPJ pessoa juridica
   update TBS006 set FORCGC=A2_CGC,FORTIPPES='J' from SERVERSQL.DADOSADV.dbo.SA2010
    where D_E_L_E_T_='' and cast(A2_CGC as float) > 0 and Len(A2_CGC) > 11 and A2_COD=codFornecedor

   -- CPF pessoa fisica
   update TBS006 set FORCPF=A2_CGC,FORTIPPES='F' from SERVERSQL.DADOSADV.dbo.SA2010
    where D_E_L_E_T_='' and cast(A2_CGC as float) > 0 and Len(A2_CGC) = 11 and A2_COD=codFornecedor

   -- atualizacao de cadastros - fornecedor/transportadora
   update TBS006 set FORCOD=TBS005.TRNCOD from SERVERSQL.DADOSADV.dbo.SA2010 ,TBS005
    where D_E_L_E_T_='' and codFornecedor=A2_COD and A2_TRANSP=codTransporta

   -- atualiza o codigo do ultimo fornecedor
   update TBS024 set TBSVALSEQ=(select max(FORCOD) from TBS006) where TBSNOM='TBS006'

   -- se habilitado no sintegra
   update TBS006 set FORSINHAB='N'

   -- se ativo na receita federal
   update TBS006 set FORRECATI='N'

   -- data da consulta do sintegra e receita federal
   update TBS006 set FORCONRES='17530101'

-- corrige a tabela de PRODUTOS ---------------------------------------------------------------------------------------------
   -- status do produto - ATIVO
   update TBS010 set PROSTATUS='A' from SERVIDORDADOS.DADOSADV.dbo.SB1010
    where D_E_L_E_T_='' and B1_PYATIVO='S' and B1_COD=codProduto

   -- status do produto - INATIVO
   update TBS010 set PROSTATUS='I' from SERVIDORDADOS.DADOSADV.dbo.SB1010
    where D_E_L_E_T_='' and B1_PYATIVO='N' and B1_COD=codProduto

   -- status do produto - FORA DE LINHA
   update TBS010 set PROSTATUS='F' from SERVIDORDADOS.DADOSADV.dbo.SB1010
    where D_E_L_E_T_='' and B1_PYATIVO='F' and B1_COD=codProduto

   -- status do produto - EXCLUIR
   update TBS010 set PROSTATUS='E' from SERVIDORDADOS.DADOSADV.dbo.SB1010
    where D_E_L_E_T_='' and B1_PYATIVO='E' and B1_COD=codProduto

   -- data do cadastro
   update TBS010 set PRODATCAD=getdate()

   -- embalagens
   update TBS010 set PROUM2='',PROUM2QTD=0 where PROUM1=PROUM2

   update TBS010 set PROUM2QTD=0 where PROUM2='' and PROUM2QTD > 0
   update TBS010 set PROUM3QTD=0 where PROUM3='' and PROUM3QTD > 0
   update TBS010 set PROUM4QTD=0 where PROUM4='' and PROUM4QTD > 0

   -- atualizacao de cadastros - produtos/fornecedor
   update TBS010 set FORCOD=TBS006.FORCOD from TBS006 ,TBS010
    where cast(codFornecedor as int)=TBS010.FORCOD and codFornecedor <> 'INPS' and codFornecedor <> 'MUNIC'

   -- define todos os produtos como "gera pendencia"
   update TBS010 set PROGERPEN='S'

   -- situacao tributaria / ICMS	
   select PROCOD,PROSTBA+PROSTBB as 'ST' from TBS010 where PROSTBB='00' and PROICMSSAI > 0

   update TBS010 set PROICMSSAI=0 where PROSTBB='00' and PROICMSSAI > 0

   select PROCOD from TBS010 where PROICMSSAI > 0 and PROPBISAI = 0
   select PROCOD from TBS010 where PROICMSSAI = 0 and PROPBISAI > 0

   update TBS010 set PROPBISAI=0 where PROICMSSAI = 0 and PROPBISAI > 0
   
   select PROCOD from TBS010 where PROICMSENT > 0 and PROPBIENT = 0
   select PROCOD from TBS010 where PROICMSENT = 0 and PROPBIENT > 0

   update TBS010 set PROPBIENT=0 where PROICMSENT = 0 and PROPBIENT > 0

   select PROCOD from TBS010 where PROICMSSAI = 18
   update TBS010 set PROICMSSAI = 0 ,PROPBISAI = 0 where PROICMSSAI = 18

   -- atualiza o nome da marca no cadastro do produto - campo redundante
   update TBS010 set MARNOM=TBS014.MARNOM from TBS010,TBS014 where TBS010.MARCOD=TBS014.MARCOD

-- corrige a tabela de UNIDADES DE MEDIDAS ----------------------------------------------------------------------------------
   -- data do cadastro
   update TBS011 set UNIDATCAD=getdate()



-- corrige a tabela de POLITICA DE PRECOS -----------------------------------------------------------------------------------
   -- verifica duplicidade
   select PDPCOD from TBS015 A where (select count(*) from TBS015 B where B.PDPCOD=A.PDPCOD) > 1 order by PDPCOD

   -- elimina registros duplicados
   delete TBS015 from TBS015 A where (select count(*) from TBS015 B where B.PDPCOD=A.PDPCOD) > 1

   -- data do cadastro
   update TBS015 set PDPDATCAD=getdate()

   update TBS015 set PDPVALPROI='1/1/1753'
   update TBS015 set PDPVALPROF='1/1/1753'

   update TBS015 set PDPDATALT='1/1/1753'
   update TBS015 set PDPDATATU='1/1/1753'

   -- marcacao
   update TBS015 set PDPSEL=''

   -- atualiza preco do fornecedor
   update TBS015 set PDPUNI=B1_UM from SERVIDORDADOS.DADOSADV_507.dbo.SB1010 
    where D_E_L_E_T_='' and B1_COD collate database_default=PDPCOD collate database_default and PDPUNI=''

   update TBS015 set PDPQTDEMB=1 from SERVIDORDADOS.DADOSADV_507.dbo.SB1010
    where D_E_L_E_T_='' and B1_COD collate database_default=PDPCOD collate database_default and
          PDPUNI collate database_default=B1_UM collate database_default

   update TBS015 set PDPQTDEMB=B1_UM2TO1 from SERVIDORDADOS.DADOSADV_507.dbo.SB1010
    where D_E_L_E_T_='' and B1_COD collate database_default=PDPCOD collate database_default and PDPUNI<>'' and
          PDPUNI collate database_default=B1_UM2 collate database_default

   update TBS015 set PDPQTDEMB=B1_UM3TO1 from SERVIDORDADOS.DADOSADV_507.dbo.SB1010
    where D_E_L_E_T_='' and B1_COD collate database_default=PDPCOD collate database_default and PDPUNI<>'' and
          PDPUNI collate database_default=B1_UM3 collate database_default

   update TBS015 set PDPQTDEMB=B1_UM4TO1 from SERVIDORDADOS.DADOSADV_507.dbo.SB1010
    where D_E_L_E_T_='' and B1_COD collate database_default=PDPCOD collate database_default and PDPUNI<>'' and
          PDPUNI collate database_default=B1_UM4 collate database_default

   update TBS015 set PDPQTDEMB=1 where PDPQTDEMB=0

   -- preco na menor unidade
   update TBS015 set PDPPREFOR=ZZ_PYCUSTB from SERVIDORDADOS.DADOSADV_507.dbo.SZZ010
    where D_E_L_E_T_='' and ZZ_PYCOD collate database_default=PDPCOD collate database_default and ZZ_PYCUSB2=0

   -- preco na segunda unidade de medida
   update TBS015 set PDPPREFOR=ZZ_PYCUSB2 from SERVIDORDADOS.DADOSADV_507.dbo.SZZ010
    where D_E_L_E_T_='' and ZZ_PYCOD collate database_default=PDPCOD collate database_default and ZZ_PYCUSB2>0

-- analisar ERRO
   update TBS015 set PDPPREUNI=PDPPREFOR /PDPQTDEMB

-- descricao do produto
   update TBS015 set PRODES=TBS010.PRODES from TBS015 join TBS010 on PDPCOD=PROCOD

-- quando terminar importacoes de clientes/vendedores deletar os atributos:
   alter table TBS002 drop codCliente
   alter table TBS004 drop codVendedor
   alter table TBS005 drop codTransporta
   alter table TBS006 drop codFornecedor
   alter table TBS010 drop codProduto


   -- rodar o script "Recria indices das tabelas importadas"

