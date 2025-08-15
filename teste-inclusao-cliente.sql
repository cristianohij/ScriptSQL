insert into TBS002
   ( CLICOD
	 ,CLINOM
     ,CLIEND
     ,CLICPLEND
     ,CLIBAI
     ,UFESIG
     ,CLICEP
     ,CLITEL
     ,CLICPF
     ,CLIMCPDAT
     ,CLINOMFAN
     ,CLICONTAT
     ,MUNCOD
     ,CLIEMAIL
   )
select (select max(CLICOD)+1 from TBS002 with (nolock))
       ,'CRISTIANO'
	   ,'RUA VOTUPORANGA'
	   ,'CASA'
	   ,'BOSQUE'
	   ,'SP'
	   ,'12233-490'
	   ,'1234567890'
	   ,'12345678901'
	   ,'20191022'
	   ,'CRIS'
	   ,'CRISTIANO'
	   ,3549904
	   ,'meuemail@email.com'


select * from OPENQUERY(MYSQLGZ, select * from clientes)

insert into openquery(MYSQLGZ, 'select codigo
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
		                               ,situacao
		                               ,fiado
		                               ,preco
		                               ,nomfan
		                               ,contato
		                               ,ibge
		                               ,email;')
select campo1 AS alias, campo2 from otraTabla