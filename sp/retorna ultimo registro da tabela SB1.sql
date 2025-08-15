-- conta registros da SB1010
if exists(select name from sysobjects where name='SP_REGISSB1' and type='P')
   drop procedure SP_REGISSB1
go

create procedure SP_REGISSB1(@retorno numeric output) as
--   declare @comando varchar(50)

--   set @comando = 'select max(R_E_C_N_O_) from TBS010'
--   exec(@comando)

   set @retorno=(select max(R_E_C_N_O_) from HORNET.DADOSAP5.dbo.SB1010)
go

declare @registro numeric
exec SP_REGISSB1 @registro output
select @registro


-- conta registros da SB0010
if exists(select name from sysobjects where name='SP_REGISSB0' and type='P')
   drop procedure SP_REGISSB0
go

create procedure SP_REGISSB0(@retorno numeric output) as
   set @retorno=(select max(R_E_C_N_O_) from HORNET.DADOSAP5.dbo.SB0010)
go

declare @registro numeric
exec SP_REGISSB0 @registro output
select @registro
