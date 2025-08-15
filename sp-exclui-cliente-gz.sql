--drop procedure SP_ExcluiClienteGZ

create procedure SP_ExcluiClienteGZ @tabCliente GZclientes READONLY as
	begin
		declare @querySQL varchar(1000), @update varchar(1000)

		declare @codigo bigint

		select @codigo=codigo from @tabCliente

		-- DELETE OPENQUERY (OracleSvr, 'SELECT name FROM joe.titles WHERE name = ''NewTitle'''); 

		set @querySQL = 'DELETE from clientes where codigo=' + Ltrim(rtrim(str(@codigo,9)))

		--print @querySQL

		EXECUTE(@querySQL) at MYSQLGZ

	end