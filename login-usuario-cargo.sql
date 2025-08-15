sp_addlogin 'intralab','integ@745'

sp_grantdbaccess 'intralab','intralab'

sp_addrole 'externo','intralab'

sp_addrolemember 'externo','intralab'

grant select on produtosWeb to intralab