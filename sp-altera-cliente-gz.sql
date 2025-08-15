--drop procedure SP_AlteraClienteGZ

create procedure SP_AlteraClienteGZ @tabCliente GZclientes READONLY as
	begin
		declare @querySQL varchar(1000), @update varchar(1000)

		declare  @codigo bigint
				,@razsoc char(50)
				,@ender varchar(60)
				,@complemen varchar(20)
				,@bairro varchar(30)
				,@munic varchar(30)
				,@estado char(2)
				,@cep char(8)
				,@telefone varchar(15)
				,@cgc varchar(19)
				,@ultcompra date
				,@insest varchar(25)
				,@nomfan char(15)
				,@contato varchar(40)
				,@ibge int
				,@email varchar(200)

		select   @codigo=codigo
				,@razsoc=razsoc
				,@ender=ender
				,@complemen=complemen
				,@bairro=bairro
				,@munic=munic
				,@estado=estado
				,@cep=cep
				,@telefone=telefone
				,@cgc=cgc
				,@ultcompra=ultcompra
				,@insest=insest
				,@nomfan=nomfan
				,@contato=contato
				,@ibge=ibge
				,@email=email
		from @tabCliente

   --   UPDATE OPENQUERY(MYSQLGZ, 'SELECT codigo,razsoc FROM clientes where codigo = 20')
	  --SET razsoc = @razsoc;

		set @querySQL = 'update clientes set razsoc=''' + rtrim(@razsoc) + ''',ender=''' + rtrim(@ender) + ''',complemen=''' + rtrim(@complemen) + ''',bairro=''' + rtrim(@bairro) + ''',munic=''' + rtrim(@munic) + ''',estado=''' + rtrim(@estado) + ''',cep=''' + rtrim(@cep) + ''',telefone=''' + rtrim(@telefone) + ''',cgc=''' + rtrim(@cgc) + ''',ultcompra=''' + convert(char(10),@ultcompra,120) + ''',insest=''' + rtrim(@insest) + ''',nomfan=''' + rtrim(@nomfan) + ''',contato=''' + rtrim(@contato) + ''',ibge=' + Ltrim(rtrim(str(@ibge,8))) + ',email=''' + rtrim(@email) + '''' --+ ' where id=' + Ltrim(rtrim(str(@id,9)))
		set @querySQL = @querySQL + ' where codigo=' + Ltrim(rtrim(str(@codigo,9)))

		EXECUTE(@querySQL) at MYSQLGZ

	end