

--insert into TAB (atrib1,atrib2,...,atribn)
--select 


declare _cursor cursor for select name from sysobjects where name Like('TBS%')

open cursor

declare @name char(7)

fetch next from _cursor into @name

while @@fetch_status = 0
   begin
      print @name

      declare _cursor cursor for select name from sysobjects where name Like('TBS%')

open _cursor

declare @name char(7)

fetch next from _cursor into @name

while @@fetch_status = 0
   begin
      print @name

      print 'insert into [dbo].[' + rtrim(@name) + '] ('

      fetch next from _cursor into @name
   end

close _cursor
deallocate _cursor

      print 'insert into [dbo].[' + rtrim(@name) + '] ('

      fetch next from _cursor into @name
   end

close _cursor
deallocate _cursor
