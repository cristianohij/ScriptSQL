drop trigger alteradoPROWEB
go

create trigger alteradoPROWEB on TBS010 after update
as
--set nocount on

if update(PROWEB)
   declare @registro int
   set @registro = 0

   begin
      if (select PROWEB from inserted) = 'N'
         begin
         print 'PROWEB=N'
--      set @registro = (select 1 from deleted inner join inserted on inserted.PROCOD=deleted.PROCOD)
--print @registro

      set @registro = (select count(*) from ProdutosEliminadosWeb Left join inserted on inserted.PROCOD=ProdutosEliminadosWeb.codigo)
--print @@rowcount
--print @registro
      if @registro = 0
         begin
            insert into ProdutosEliminadosWeb select inserted.PROCOD,getdate() from inserted where inserted.PROWEB='N'
         end
      else
         update ProdutosEliminadosWeb set data=getdate() from inserted where inserted.PROCOD=ProdutosEliminadosWeb.codigo and inserted.PROWEB='N'
   end
go

update TBS010 set PROWEB='S' where PROCOD='1640054'

-- tabela de produtos retirados da web

create table ProdutosEliminadosWeb
   (codigo char(15) not null default '',
    data datetime default '17530101',
    constraint PK_codigo primary key (codigo)) 
go
-- teste

select * from ProdutosEliminadosWeb
print @@rowcount

delete ProdutosEliminadosWeb

-- trigger utilizada

create trigger alteradoPROWEB on TBS010 after update
as
set nocount on

if update(PROWEB)
   begin
      declare @registro int
      set @registro = 0

      begin
         if (select PROWEB from inserted) = 'S'
            delete ProdutosEliminadosWeb from inserted where inserted.PROCOD=ProdutosEliminadosWeb.codigo

         if (select PROWEB from inserted) = 'N'
            insert into ProdutosEliminadosWeb select inserted.PROCOD,getdate() from inserted
      end
   end
go

drop trigger eliminadoWeb
go

create trigger eliminadoWeb on TBS010 for delete 
as
set nocount on

begin
   if (select isnull(count(*),0) from ProdutosEliminadosWeb (nolock) join deleted on codigo=deleted.PROCOD) > 0
      update ProdutosEliminadosWeb set data=getdate() from deleted where codigo=deleted.PROCOD
   else
      insert into ProdutosEliminadosWeb select PROCOD,getdate() from deleted
end

select top 10 PROCOD from TBS010 (nolock) order by PROCOD

delete TBS010 where PROCOD='0020001'

set nocount on
if (select isnull(count(*),0) from ProdutosEliminadosWeb where codigo='0000001') > 0 print 'encontrado'
print @@rowcount

select * from deleted

select * from ProdutosEliminadosWeb