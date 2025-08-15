if exists(select name from sysobjects where name='SP_CONTTBS010' and type='P')
   drop procedure SP_CONTTBS010
go

create procedure SP_CONTTBS010(@retorno int output) as
   set @retorno = (select isnull(count(*),0) from TBS010 (noLock))

go

declare @registros int
exec SP_CONTTBS010 @registros output
select @registros
