if exists(select name from sysobjects where name='sp_com001' and type='P')
   drop procedure sp_com001

go
create procedure sp_com001(@PDPFORCOD numeric(5) ,@PDPFOREMP numeric(2)) as
