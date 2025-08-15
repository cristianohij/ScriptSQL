if exists(select name from sysobjects where name='SP_TESTE' and type='P')
   drop procedure SP_TESTE
go

create procedure SP_TESTE(@sigla varchar(2), @retorno int output) as
   set @retorno = (select isnull(count(*),0) from TBS001 with (noLock)
                    where UFESIG=@sigla)
go

declare @registros int
exec SP_TESTE 'SP', @registros output
select @registros
