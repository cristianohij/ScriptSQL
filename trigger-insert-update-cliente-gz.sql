-- Se a trigger for de INSERT, a INSERTED terá registros e a DELETED ficará vazia

-- Se a trigger for de DELETE, a INSERTED ficará vazia e a DELETED terá registros

-- Se a trigger for de UPDATE, a INSERTED e a DELETED terão registros

/*

codigo
	          ,razsoc
		      --,tipoender
		      ,ender
		      --,numero
		      ,complemen
		      ,bairro
		      ,munic
		      ,estado
		      ,cep
		      ,telefone
		      ,cgc
		      --,dtnasc
		      ,ultcompra
		      ,situacao -- "L"
		      --,limite
		      --,saldo
		      --,desconto
		      --,promocao
		      --,descgeral
		      ,fiado -- "N"
		      --,mensagem
		      --,limitechq
		      --,limiteqtch
		      --,saldochq
		      --,saldoqtchq
		      --,codbarra
		      --,filler1
		      --,insest
		      --,fidacum
		      --,filler2
		      --,filler3
		      --,ultcomval
		      --,saldoconta
		      --,qtdconta
		      --,bloqfin
		      ,preco -- "P"
		      --,nivelbloq
		      ,nomfan
		      --,senha
		      --,venctofia
		      --,livre
		      --,livrecond
		      --,melhordia
		      ,contato
		      --,ultatu
		      --,pais
		      --,codpais
		      ,ibge
		      ,email
		      --,indicadorinsest
		      --,saldobonus
		      --,acresprazo
		      --,identifica_placa
		      --,codigo_acordo

*/

drop trigger IncluirAlterarExcluirClienteGZ

create trigger IncluirAlterarExcluirClienteGZ
    on TBS002
   for insert, update, delete
    as

	declare @DTclientes AS GZclientes;

	-- para INSERT e UPDATE
	if (select count(*) from inserted) > 0
		insert into @DTclientes
			( codigo
				,razsoc
				,ender
				,complemen
				,bairro
				,munic
				,estado
				,cep
				,telefone
				,cgc
				,ultcompra
				,situacao -- "L"
				,promocao -- "N"
				,descgeral -- "N"
				,fiado -- "S"
				,insest
				,preco -- "P"
				,nomfan
				,contato
				,ibge
				,email
			)
		select inserted.CLICOD
				,Left(inserted.CLINOM,50)
				,inserted.CLIEND
				,Left(inserted.CLICPLEND,20)
				,Left(CLIBAI,30)
				,Left(isnull((select MUNNOM from TBS003 with (nolock) where MUNCOD=inserted.MUNCOD),''),30)
				,inserted.UFESIG
				,replace(inserted.CLICEP,'-','')
				,inserted.CLITEL
				,case CLITIPPES
					when 'J' then inserted.CLICGC
					else inserted.CLICPF
					end
				,inserted.CLIMCPDAT
				,'L'
				,'N'
				,'N'
				,'S'
				,inserted.CLIIES
				,'P'
				,Left(inserted.CLINOMFAN,15)
				,inserted.CLICONTAT
				,inserted.MUNCOD
				,inserted.CLIEMAIL
		from inserted;

	-- INSERT
	if (select count(*) from inserted) > 0 and (select count(*) from deleted) = 0
		EXEC SP_IncluiClienteGZ @DTclientes;

	-- DELETE
	if (select count(*) from inserted) = 0 and (select count(*) from deleted) > 0
		begin
			-- DELETE
			insert into @DTclientes (codigo)
			select deleted.CLICOD from deleted;

			EXEC SP_ExcluiClienteGZ @DTclientes;
		end

	-- UPDATE
	if (select count(*) from INSERTED) > 0 and (select count(*) from DELETED) > 0
		EXEC SP_AlteraClienteGZ @DTclientes;

go


-- INSERT

drop trigger IncluirClienteGZ

create trigger IncluirClienteGZ
    on TBS002
   for insert
    as
   
   declare @DTclientes AS GZclientes;

   insert into @DTclientes
      ( codigo
	    ,razsoc
		,ender
		,complemen
		,bairro
		,munic
		,estado
		,cep
		,telefone
		,cgc
		,ultcompra
		,situacao -- "L"
		,promocao -- "N"
		,descgeral -- "N"
		,fiado -- "S"
		,insest
		,preco -- "P"
		,nomfan
		,contato
		,ibge
		,email
     )
   select inserted.CLICOD
	      ,Left(inserted.CLINOM,50)
	      ,inserted.CLIEND
		  ,Left(inserted.CLICPLEND,20)
		  ,Left(CLIBAI,30)
		  ,Left(isnull((select MUNNOM from TBS003 with (nolock) where MUNCOD=inserted.MUNCOD),''),30)
		  ,inserted.UFESIG
		  ,replace(inserted.CLICEP,'-','')
		  ,inserted.CLITEL
		  ,case CLITIPPES
		      when 'J' then inserted.CLICGC
		      else inserted.CLICPF
		   end
		  ,inserted.CLIMCPDAT
  	      ,'L'
		  ,'N'
		  ,'N'
		  ,'S'
		  ,inserted.CLIIES
		  ,'P'
		  ,Left(inserted.CLINOMFAN,15)
		  ,inserted.CLICONTAT
		  ,inserted.MUNCOD
		  ,inserted.CLIEMAIL
     from inserted;

   EXEC SP_GravaClienteGZ @DTclientes;

go

-- UPDATE

drop trigger AlterarClienteGZ

create trigger AlterarClienteGZ
    on TBS002
   for update
    as
   
   declare @DTclientes AS GZclientes;

   insert into @DTclientes
      ( codigo
	    ,razsoc
		,ender
		,complemen
		,bairro
		,munic
		,estado
		,cep
		,telefone
		,cgc
		,ultcompra
		,situacao -- "L"
		,promocao -- "N"
		,descgeral -- "N"
		,fiado -- "S"
		,insest
		,preco -- "P"
		,nomfan
		,contato
		,ibge
		,email
     )
   select inserted.CLICOD
	      ,Left(inserted.CLINOM,50)
	      ,inserted.CLIEND
		  ,Left(inserted.CLICPLEND,20)
		  ,Left(CLIBAI,30)
		  ,Left(isnull((select MUNNOM from TBS003 with (nolock) where MUNCOD=inserted.MUNCOD),''),30)
		  ,inserted.UFESIG
		  ,replace(inserted.CLICEP,'-','')
		  ,inserted.CLITEL
		  ,case CLITIPPES
		      when 'J' then inserted.CLICGC
		      else inserted.CLICPF
		   end
		  ,inserted.CLIMCPDAT
  	      ,'L'
		  ,'N'
		  ,'N'
		  ,'S'
		  ,inserted.CLIIES
		  ,'P'
		  ,Left(inserted.CLINOMFAN,15)
		  ,inserted.CLICONTAT
		  ,inserted.MUNCOD
		  ,inserted.CLIEMAIL
     from inserted;

   EXEC SP_AlteraClienteGZ @DTclientes;

go