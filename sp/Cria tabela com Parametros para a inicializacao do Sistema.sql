if exists(select name from sysobjects where name='sp_param' and type='P')
   drop procedure sp_param

go
create procedure sp_param with recompile as
   begin 
      if not exists(select name from sysobjects where name='TBC001' and type='U')
         begin
            create table TBC001(SRVIP char(40),SRVPTA int,SVRNUMCON smallint,SRVDAT char(8),SRVHOR char(8))
         end
      else delete TBC001
   end

execute sp_param

select * from TBP001
delete PENLOJA
drop table PENLOJA

update TBP001 set IP_SERVER='123'