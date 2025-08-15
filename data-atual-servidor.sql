if exists(select name from sysobjects where name='SP_DATAATUAL' and type='P')
   drop procedure SP_DATAATUAL
go

drop procedure SP_DATAATUAL

create procedure SP_DATAATUAL @data datetime output
as
begin
   --declare @data datetime
   set @data = getdate()
end

declare @data datetime

exec SP_DATAATUAL @data output

select @data

