--drop procedure SP_IncluiClienteGZ

create procedure SP_IncluiClienteGZ @tabCliente GZclientes READONLY as
   begin
      declare @querySQL varchar(1000), @campos varchar(1000), @select varchar(1000)

   --   INSERT OPENQUERY(MYSQLGZ, 'SELECT codigo,razsoc,ender,complemen,bairro,munic,estado,cep,telefone,cgc,ultcompra,situacao,promocao,descgeral,fiado,insest,preco,nomfan,contato,ibge,email FROM clientes')
	  --select codigo
   --          ,razsoc
   --          ,ender
   --          ,complemen
   --          ,bairro
   --          ,munic
   --          ,estado
   --          ,cep
   --          ,telefone
   --          ,cgc
   --          ,ultcompra
   --          ,situacao
   --          ,promocao
   --          ,descgeral
   --          ,fiado
   --          ,insest
   --          ,preco
   --          ,nomfan
   --          ,contato
   --          ,ibge
   --          ,email
   --     from @tabCliente;


   --select * from @tabCliente

set @select = (select rtrim(str(codigo,5)) + ',' +
                      '''' + rtrim(razsoc) + ''',' +
					  '''' + rtrim(ender) + ''',' +
					  '''' + rtrim(complemen) + ''',' +
					  '''' + rtrim(bairro) + ''',' +
					  '''' + rtrim(munic) + ''',' +
					  '''' + rtrim(estado) + ''',' +
					  '''' + rtrim(cep) + ''',' +
					  '''' + rtrim(telefone) + ''',' +
					  '''' + rtrim(cgc) + ''',' +
					  '''' + convert(char(10),ultcompra,120) + ''',' +
					  '''' + situacao + ''',' +
					  '''' + promocao + ''',' +
					  '''' + descgeral + ''',' +
					  '''' + fiado + ''',' +
					  '''' + insest + ''',' +
					  '''' + preco + ''',' +
					  '''' + rtrim(nomfan) + ''',' +
					  '''' + rtrim(contato) + ''',' +
					  Ltrim(rtrim(str(ibge,8))) + ',' +
					  '''' + rtrim(email) + ''''
                 from @tabCliente)

set @querySQL = 'insert into clientes (codigo,razsoc,ender,complemen,bairro,munic,estado,cep,telefone,cgc,ultcompra,situacao,promocao,descgeral,fiado,insest,preco,nomfan,contato,ibge,email) select ' + @select


execute(@querySQL) at MYSQLGZ

   end

--select * from MYSQLGZ...clientes