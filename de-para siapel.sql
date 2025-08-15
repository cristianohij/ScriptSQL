-- CLIENTES
   delete TBS002

   alter table TBS002 add codigo int default 0

   insert into TBS002 (
             CLICOD,									-- codigo do cliente
   	     CLIEMPCOD,									-- empresa
	     CLINOM,									-- nome/razao social
	     CLINOMFAN,									-- nome fantasia
	     CLIEND,									-- endereco
--	     CLICEP,									-- CEP
	     CLIBAI,									-- bairro
	     CLICID,									-- cidade
	     CLICONTAT,									-- contato
	     CLITEL,									-- telefone
	     CLIFAX,									-- fax
	     CLIEMAIL,									-- e-mail
	     UFESIG,									-- estado
	     CLIIES,									-- inscricao estadual
             CLITIPPES)									-- tipo de pessoa

      select codigo,
	     0,
             rTrim(nome),
	     rTrim(nome_fantasia),
	     rTrim(endereco),
--	     rTrim(A1_CEP),
	     rTrim(bairro),
	     rTrim(cidade),
	     rTrim(contato),
	     rTrim(subString(telefone,1,15)),
	     rTrim(subString(fax,1,15)),
	     rTrim(subString(email,1,40)),
	     estado,
	     rTrim(insc_estadual),
             tipo_pessoa

        from AL0103 (noLock)
       where cnpj_cpf<>''

-- correcoes
   select * from TBS002 A
    where (select count(*) from TBS002 B where B.CLICOD=A.CLICOD)>1
    order by CLICOD


   -- cnpj
   update TBS002 set CLICGC=cnpj_cpf from TBS002 join AL0103 on CLICOD=AL0103.codigo where tipo_pessoa='J'

   -- cpf
   update TBS002 set CLICPF=subString(cnpj_cpf,1,11)
      from TBS002 join AL0103 on CLICOD=AL0103.codigo where tipo_pessoa='F'

   -- data do cadastro
   update TBS002 set CLIDATCAD=getdate()

   update TBS002 set CLILICVEN='1/1/1753'

   -- gera codigos sequencias para os clientes
   update TBS002 set codigo=CLICOD

   update TBS002 set CLICOD=0

   -- gera codigos sequencias para os clientes
   declare @contador int
   declare @registro varchar(6)

   set @contador = 0
   set @registro = (select top 1 codigo from TBS002 where CLICOD=0 order by codigo)

   while((select count(*) from TBS002 where CLICOD=0) > 0)
      begin
         update TBS002 set CLICOD=@contador +1 where CLICOD=0 and codigo=@registro
         
	 set @contador = @contador +1
         set @registro = (select top 1 codigo from TBS002 where CLICOD=0 order by codigo)

         if((select count(*) from TBS002 where CLICOD=0) > 0)
            continue
         else 
            break
      end

   -- atualiza o codigo do ultimo cliente
   update TBS024 set TBSVALSEQ=(select max(CLICOD) from TBS002) where TBSNOM='TBS002'


-- OUTROS ENDERECOS
   -- COBRANCA
   update TBS002 set CLIENDCOB=endereco,CLIBAICOB=bairro,CLICIDCOB=cidade,CLICEPCOB=cep,CLIUFECOB=estado
     from TBS002 (noLock) join AL0105 (noLock) on TBS002.codigo=AL0105.codigo
    where tipo='C'

   -- ENTREGA
   update TBS002 set CLIENDENT=endereco,CLIBAIENT=bairro,CLICIDENT=cidade,CLICEPENT=cep,CLIUFEENT=estado
     from TBS002 (noLock) join AL0105 (noLock) on TBS002.codigo=AL0105.codigo
    where tipo='E'


-- FORNECEDORES
   delete TBS006

   alter table TBS006 add codigo int default 0

      insert into TBS006 (
	     FOREMPCOD,									-- empresa
	     FORCOD,									-- codigo do fornecedor
             FORNOM,									-- nome do fornecedor
	     FORNOMFAN,									-- nome fantasia
	     FOREND,									-- endereco
	     FORBAI,									-- bairro
--	     FORCEP,									-- CEP
	     FORCID,									-- cidade
	     UFESIG,									-- estado
	     FORIES,									-- inscricao estadual
	     FORTEL,									-- telefone
	     FORFAX,									-- fax
	     FOREMAIL,									-- e-mail
	     FORCONTAT,									-- contato
	     FORTIPPES)									-- tipo de pessoa
             
      select 0,
	     codigo,
	     rTrim(nome),
	     rTrim(nome_fantasia),
	     rTrim(endereco),
	     rTrim(bairro),
--	     rTrim(A2_CEP),
	     rTrim(cidade),
	     rTrim(estado),
	     rTrim(insc_estadual),
	     rTrim(subString(telefone,1,15)),
	     rTrim(subString(fax,1,15)),
	     rTrim(subString(email,1,40)),
	     rTrim(contato),
             tipo_pessoa

        from AL0106 (noLock)
       where cnpj_cpf<>''

-- correcoes
   -- cnpj
   update TBS006 set FORCGC=cnpj_cpf from TBS006 join AL0106 on FORCOD=AL0106.codigo where tipo_pessoa='J'

   -- cpf
   update TBS006 set FORCPF=cnpj_cpf from TBS006 join AL0106 on FORCOD=AL0106.codigo where tipo_pessoa='F'

   -- data do cadastro
   update TBS006 set FORDATCAD=getdate()

   -- se habilitado no sintegra
   update TBS006 set FORSINHAB='N'

   -- se ativo na receita federal
   update TBS006 set FORRECATI='N'

   -- data da consulta do sintegra e receita federal
   update TBS006 set FORCONRES='17530101'

   -- gera codigos sequencias para os clientes
   update TBS006 set codigo=FORCOD

   update TBS006 set FORCOD=0

   -- gera codigos sequencias para os fornecedores
   declare @contador int
   declare @registro varchar(6)

   set @contador = 0
   set @registro = (select top 1 codigo from TBS006 where FORCOD=0 order by codigo)

   while((select count(*) from TBS006 where FORCOD=0) > 0)
      begin
         update TBS006 set FORCOD=@contador +1 where FORCOD=0 and codigo=@registro
         
	 set @contador = @contador +1
         set @registro = (select top 1 codigo from TBS006 where FORCOD=0 order by codigo)

         if((select count(*) from TBS006 where FORCOD=0) > 0)
            continue
         else 
            break
      end

   -- verifica registros duplicados
   select * from TBS006 A
    where (select count(*) from TBS006 B where B.FORCOD=A.FORCOD)>1
    order by FORCOD

   -- atualiza o codigo do ultimo fornecedor
   update TBS024 set TBSVALSEQ=(select max(FORCOD) from TBS006) where TBSNOM='TBS006'


-- PRODUTOS
   delete TBS010

      insert into TBS010 (
	     PROCOD,									-- codigo do produto
	     PROEMPCOD,									-- empresa
             PRODES,									-- descricao do produto
	     PROCODBAR1,								-- codigo de barras 1
	     PROUM1,									-- 1a unidade de medida
	     PROUM1QTD,									-- quantidade da 1a unidade
--	     PROUM2,									-- 2a unidade de medida
--	     PROUM2QTD,									-- quantidade da 2a unidade
--	     PROUM3,									-- 3a unidade de medida
--	     PROUM3QTD,									-- quantidade da 3a unidade
--	     PROUM4,									-- 4a unidade de medida
--	     PROUM4QTD,									-- quantidade da 4a unidade
	     FORCOD)									-- codigo do fornecedor
--	     MARCOD,									-- codigo da marca
--	     PROICMSSAI,								-- ICMS de saida
--	     PROIPI,									-- IPI do produto
--	     PROLOCFIS,									-- localizacao fisica
--	     PROSTBA,									-- situacao tributaria, tabela A
--	     PROSTBB,									-- situacao tributaria, tabela B
--	     PROPBISAI,									-- percentual base calculo ICMS saida
--	     PROPBIENT,									-- percentual base calculo ICMS entrada
--	     PROGERPEN,									-- produto gera pendencias
--	     codProduto)								-- codigo do produto (auxiliar)
      select rTrim(cod_interno),
	     0,
	     rTrim(descricao),
	     rTrim(cod_barras),
	     rTrim(unidade1),
	     1,
--	     rTrim(B1_UM2),
--	     B1_UM2TO1,
--	     rTrim(B1_UM3),
--	     B1_UM3TO1,
--	     rTrim(B1_UM4),
--	     B1_UM4TO1,
	     fornecedor
        from AL0601

-- correcoes
   -- data do cadastro
   update TBS010 set PRODATCAD=getdate()

   -- codigo de barras1
   update TBS010 set PROCODBAR1='' where PROCODBAR1 is null

   -- status
   update TBS010 set PROSTATUS='A'

   -- se gera pendencia
   update TBS010 set PROGERPEN='S'

   -- situacao tributaria tabela A
   --update TBS010 set PROSTBA='0' 

   -- situacao tributaria tabela B
   --update TBS010 set PROSTBB='00' 

   select PROCOD,cod_interno,PROSTBA,PROSTBB,sit_tributaria from TBS010 join AL0601 on PROCOD=cod_interno
    where sit_tributaria Like('AF%')

   update TBS010 set PROSTBB=60 from TBS010 join AL0601 on PROCOD=cod_interno where sit_tributaria Like('AF%')

   select PROCOD,cod_interno,PROSTBA,PROSTBB,sit_tributaria from TBS010 join AL0601 on PROCOD=cod_interno
    where sit_tributaria='010'

   update TBS010 set PROSTBB=60 from TBS010 join AL0601 on PROCOD=cod_interno where sit_tributaria='010'


   select unidade1 from AL0601 (noLock) where not exists(select 'ne' from TBS011 (noLock) where UNICOD=unidade1)

   select distinct PROUM1 from TBS010 where not exists(select 'ne' from TBS011 (noLock) where UNICOD=PROUM1)

   update TBS010 set PROUM1='CX' where PROUM1='PR'

   update TBS010 set MARCOD=FORCOD

-- MARCAS
   select * from TBS014
   delete TBS014

   alter table TBS014 add codigo int default 0

   insert into TBS014 (
      MARCOD,		-- codigo da marca
      MAREMPCOD,	-- empresa
      MARNOM)		-- nome da marca
   select codigo,
	  0,
	  subString(nome_fantasia,1,30)
     from AL0106

-- correcoes
   -- data do cadastro
   update TBS014 set MARDATCAD=getdate()

   update TBS014 set codigo=MARCOD

   update TBS014 set MARCOD=0

   update TBS014 set MARCOD=FORCOD from TBS014 join TBS006 on TBS014.codigo=TBS006.codigo

   select * from TBS014 where MARCOD=0
   delete TBS014 where MARCOD=0
    
   -- atualiza o codigo do ultimo cliente
   update TBS024 set TBSVALSEQ=(select max(MARCOD) from TBS014) where TBSNOM='TBS014'


-- POLITICA PRECOS
   select * from TBS015
   delete TBS015

   update AL0601 set preco1=preco1/100

   insert into TBS015 (
      PDPEMPCOD,
      PDPCOD,
      PRODES,
      PDPSEGFOR,
      PDPUNI,
      PDPQTDEMB,
      PDPPREFOR,
      PDPPREUNI)
   select 0,
          cod_interno,
          descricao,
          'N',
          unidade1,
          1,
          preco1,
          preco1
     from AL0601
                
-- correcoes
   update TBS015 set PDPDATCAD=getdate(),PDPDATALT=getdate()

   select * from TBS015 where PDPPREFOR=0
   delete TBS015 where PDPPREFOR=0

   update TBS015 set PDPUNI=PROUM1 from TBS015 join TBS010 on PDPCOD=PROCOD where PDPUNI<>PROUM1

   select * from TBS015 where PDPVALPROI='19000101'
   update TBS015 set PDPVALPROI='17530101'
   update TBS015 set PDPVALPROF='17530101'

-- CEP clientes
   select * from CEPCLI

   -- retira o sinal "."
   update CEPCLI set cgc_cpf=replace(cgc_cpf,'.','')

   -- retira o sinal "/"
   update CEPCLI set cgc_cpf=replace(cgc_cpf,'/','')

   update CEPCLI set cep=replace(cep,'/','')

   -- retira o sinal "-"
   update CEPCLI set cgc_cpf=replace(cgc_cpf,'-','')

   -- atualiza CEP cliente
   -- busca pelo CGC
   select cgc_cpf,CLICGC from TBS002 join CEPCLI on CLICGC=cgc_cpf
   update TBS002 set CLICEP=cep from TBS002 join CEPCLI on CLICGC=cgc_cpf

   -- busca pelo CPF
   select cgc_cpf,CLICPF from TBS002 join CEPCLI on CLICPF=cgc_cpf
   update TBS002 set CLICEP=cep from TBS002 join CEPCLI on CLICPF=cgc_cpf

   select count(*) from TBS002

-- CEP fornecedores
   select * from CEPFOR

   -- retira o sinal "."
   update CEPFOR set cgc_cpf=replace(cgc_cpf,'.','')

   -- retira o sinal "/"
   update CEPFOR set cgc_cpf=replace(cgc_cpf,'/','')

   update CEPFOR set cep=replace(cep,'/','')

   -- retira o sinal "-"
   update CEPFOR set cgc_cpf=replace(cgc_cpf,'-','')

   -- atualiza CEP fornecedor
   -- busca pelo CGC
   select cgc_cpf,FORCGC from TBS006 join CEPFOR on FORCGC=cgc_cpf
   update TBS006 set FORCEP=cep from TBS006 join CEPFOR on FORCGC=cgc_cpf

   -- busca pelo CPF
   select cgc_cpf,FORCPF from TBS006 join CEPFOR on FORCPF=cgc_cpf
   update TBS006 set FORCEP=cep from TBS006 join CEPFOR on FORCPF=cgc_cpf

   select count(*) from TBS006



  -- embalagens
  -- segunda unidade
  select PROCOD,PROUM1,PROUM2,PROUM3,PROUM4,pre.codigo,preco1,preco2,preco3,preco4,unidade,embalagem
    from TBS010 join PRECOS pre on PROCOD=codigo join EMB2 emb on emb.codigo=pre.codigo
   where preco2 > 0 and PROUM1<>unidade and embalagem > 1

  update TBS010 set PROUM2=unidade,PROUM2QTD=embalagem
    from TBS010 join PRECOS pre on PROCOD=codigo join EMB2 emb on emb.codigo=pre.codigo
   where preco2 > 0 and PROUM1<>unidade and embalagem > 1

  -- terceira unidade
  select PROCOD,PROUM1,PROUM2,PROUM3,PROUM4,pre.codigo,preco1,preco2,preco3,preco4,unidade,embalagem
    from TBS010 join PRECOS pre on PROCOD=codigo join EMB3 emb on emb.codigo=pre.codigo
   where preco3 > 0 and PROUM1<>unidade and PROUM2<>unidade and embalagem > 1

  update TBS010 set PROUM3=unidade,PROUM3QTD=embalagem
    from TBS010 join PRECOS pre on PROCOD=codigo join EMB3 emb on emb.codigo=pre.codigo
   where preco3 > 0 and PROUM1<>unidade and PROUM2<>unidade and embalagem > 1

  -- quarta unidade
  select PROCOD,PROUM1,PROUM2,PROUM3,PROUM4,pre.codigo,preco1,preco2,preco3,preco4,unidade,embalagem
    from TBS010 join PRECOS pre on PROCOD=codigo join EMB4 emb on emb.codigo=pre.codigo
   where preco4 > 0 and PROUM1<>unidade and PROUM2<>unidade and PROUM3<>unidade and embalagem > 1

  update TBS010 set PROUM4=unidade,PROUM4QTD=embalagem
    from TBS010 join PRECOS pre on PROCOD=codigo join EMB4 emb on emb.codigo=pre.codigo
   where preco4 > 0 and PROUM1<>unidade and PROUM2<>unidade and PROUM3<>unidade and embalagem > 1


  select * from TBS010 where MARCOD>0

  select FORCOD,FORNOM,FORNOMFAN,MARCOD,MARNOM from TBS006 join TBS014 on FORCOD=MARCOD


-- acerta datas
   update TBS002 set CLIDATCAD='17530101' where CLIDATCAD='19000101'
   update TBS002 set CLIUCPDAT='17530101' where CLIUCPDAT='19000101'
   update TBS002 set CLILICVEN='17530101' where CLILICVEN='19000101'
   update TBS002 set CLIPRICOM='17530101' where CLIPRICOM='19000101'
   update TBS002 set CLIMCPDAT='17530101' where CLIMCPDAT='19000101'
   update TBS002 set CLIDATFUN='17530101' where CLIDATFUN='19000101'

   update TBS006 set FORDATCAD='17530101' where FORDATCAD='19000101'
   update TBS006 set FORLICVEN='17530101' where FORLICVEN='19000101'
   update TBS006 set FORPRICOM='17530101' where FORPRICOM='19000101'
   update TBS006 set FORMCPDAT='17530101' where FORMCPDAT='19000101'
   update TBS006 set FORUCPDAT='17530101' where FORUCPDAT='19000101'
   update TBS006 set FORDATFUN='17530101' where FORDATFUN='19000101'
   update TBS006 set FORCONRES='17530101' where FORCONRES='19000101'

   update TBS010 set PRODATVAL='17530101' where PRODATVAL='19000101'
   update TBS010 set PRODATCAD='17530101' where PRODATCAD='19000101'
   update TBS010 set PROPRIVEN='17530101' where PROPRIVEN='19000101'
   update TBS010 set PROMVDDAT='17530101' where PROMVDDAT='19000101'
   update TBS010 set PROUVDDAT='17530101' where PROUVDDAT='19000101'
   update TBS010 set PROPRICOM='17530101' where PROPRICOM='19000101'
   update TBS010 set PROMCPDAT='17530101' where PROMCPDAT='19000101'
   update TBS010 set PROUCPDAT='17530101' where PROUCPDAT='19000101'

   update TBS014 set MARDATCAD='17530101' where MARDATCAD='19000101'

   update TBS015 set PDPVALPROI='17530101' where PDPVALPROI='19000101'
   update TBS015 set PDPVALPROF='17530101' where PDPVALPROF='19000101'

   update TBS015 set PDPDATALT='17530101' where PDPDATALT='19000101'
   update TBS015 set PDPDATATU='17530101' where PDPDATATU='19000101'
   update TBS015 set PDPDATCAD='17530101' where PDPDATCAD='19000101'


-- precos
   update PRECOS set emb2=PROUM2QTD,emb3=PROUM3QTD,emb4=PROUM4QTD from PRECOS join TBS010 on codigo=PROCOD 

   select PDPCOD,codigo,preco2/emb2,100-preco2/emb2*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb2 > 0

   -- reducao preco2
   -- corporativo
   update TBS015 set PDPREDCOR2=100-preco2/emb2*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb2 > 0

   -- loja
   update TBS015 set PDPREDLOJ2=100-preco2/emb2*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb2 > 0

   -- revenda
   update TBS015 set PDPREDREV2=100-preco2/emb2*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb2 > 0

   -- web1
   update TBS015 set PDPREDWE12=100-preco2/emb2*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb2 > 0

   -- web2
   update TBS015 set PDPREDWE22=100-preco2/emb2*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb2 > 0

   -- promocao
   update TBS015 set PDPREDPRO2=100-preco2/emb2*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb2 > 0

   -- atualiza preco custos
   update TBS015 set PDPPREFOR=custo,PDPPREUNI=custo
     from TBS015 join CUSTOS on PDPCOD=produto
   -- where PDPCOD='0010001'

   -- grava margem lucro
   -- corporativo
   update TBS015 set PDPMKPCOR1=custo/venda*100 from TBS015 join CUSTOS on PDPCOD=produto where custo/venda*100 <= 999
   -- where PDPCOD='0010001'

   -- promocao
   update TBS015 set PDPMKPPRO1=custo/venda*100 from TBS015 join CUSTOS on PDPCOD=produto where custo/venda*100 <= 999
   -- where PDPCOD='0010001'

   -- loja
   update TBS015 set PDPMKPLOJ1=custo/venda*100 from TBS015 join CUSTOS on PDPCOD=produto where custo/venda*100 <= 999
   -- where PDPCOD='0010001'

   -- web1
   update TBS015 set PDPMKPWE11=custo/venda*100 from TBS015 join CUSTOS on PDPCOD=produto where custo/venda*100 <= 999
   -- where PDPCOD='0010001'

   -- web2
   update TBS015 set PDPMKPWE21=custo/venda*100 from TBS015 join CUSTOS on PDPCOD=produto where custo/venda*100 <= 999
    -- where PDPCOD='0010001'

   -- revenda
   update TBS015 set PDPMKPREV1=custo/venda*100 from TBS015 join CUSTOS on PDPCOD=produto where custo/venda*100 <= 999
   -- where PDPCOD='0010001'


declare _cursor cursor for select produto from CUSTOS order by produto

open _cursor

declare @produto char(8)

fetch next from _cursor into @produto

while @@fetch_status = 0
   begin
      print @produto

      select custo/venda*100 from CUSTOS where produto = @produto

      fetch next from _cursor into @produto
   end

close _cursor
deallocate _cursor

select * from CUSTOS where custo/venda*100 > 999



   select * from TBS010 where PROUM3QTD > 0
   select * from TBS010 where PROUM4QTD > 0

   update TBS010 set PROUM3='',PROUM4='',PROUM3QTD=0,PROUM4QTD=0

   update TBS015 set PDPPREFOR=custo,PDPPREUNI=custo from TBS015 join CUSTOS on PDPCOD=produto
    where PDPCOD='0090010'


   select PDPCOD,codigo,preco3/emb3,100-(preco3/emb3*100/preco1)
     from TBS015 join PRECOS on PDPCOD=codigo where emb3 > 0

   update TBS015 set PDPREDCOR3=100-preco3/emb3*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb3 > 0

   select PDPCOD,codigo,preco4/emb4,100-(preco4/emb4*100/preco1)
     from TBS015 join PRECOS on PDPCOD=codigo where emb4 > 0

   update TBS015 set PDPREDCOR4=100-preco4/emb4*100/preco1 from TBS015 join PRECOS on PDPCOD=codigo where emb4 > 0


select * from TBS010 where PROUM2QTD=1 or PROUM3QTD=1 or PROUM4QTD=1



select * from AL0106 (noLock)

select * from AL0601 (noLock) where subString(sit_tributaria,1,1)='A'

select distinct(subString(sit_tributaria,1,1)) from AL0601 (noLock) where subString(sit_tributaria,1,1)='A'

select count(*) from AL0601 (noLock) where subString(sit_tributaria,1,1)<>'A'

select distinct(subString(sit_tributaria,2,2)) from AL0601 (noLock)

select count(*) from AL0601 (noLock) where subString(sit_tributaria,2,2)<>'00'

select distinct(unidade1) from AL0601 (noLock)