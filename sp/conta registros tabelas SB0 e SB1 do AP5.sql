-- conta registros da SB1010
if exists(select name from sysobjects where name='REGISSB1' and type='P')
   drop procedure REGISSB1
go

	Set ANSI_NULLS ON
	Set ANSI_WARNINGS ON
go

create procedure REGISSB1(@retorno numeric output) as
   set @retorno=(select isNull(max(R_E_C_N_O_),0) from TOMCAT.DADOSAP5.dbo.SB1010)
go

declare @registro numeric
exec REGISSB1 @registro output
select @registro


-- conta registros da SB0010
if exists(select name from sysobjects (noLock) where name='sp_regisSB0' and type='P')
   drop procedure sp_regisSB0
go

create procedure sp_regisSB0(@retorno numeric output) as
   set @retorno=(select isNull(max(R_E_C_N_O_),0) from TOMCAT.DADOSAP5.dbo.SB0010 (noLock))
go

declare @registro numeric
exec sp_regisSB0 @registro output
select @registro