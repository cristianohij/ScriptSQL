declare _cursor cursor for select codigo,matricula from natura

open _cursor

declare @codigo int, @matricula char(15),@clicod int, @seq smallint

fetch next from _cursor into @codigo ,@matricula

while @@fetch_status = 0
   begin
      --print @codigo
      --print @matricula

      set @clicod = (select CLICOD from TBS047 (nolock) where CLICOD = @codigo and REQCDC = @matricula)

      --print @clicod

      if @clicod is null
         begin
            set @seq = (select CLIULTREQ from TBS002 (nolock) where CLICOD = @codigo)

            set @seq = @seq + 1

            update TBS002 set CLIULTREQ = @seq where CLICOD = @codigo

            --print @seq

            if @seq > 0
               insert into TBS047 (CLICOD,REQCOD,REQCDC) values(@codigo, @seq, @matricula)
         end

      fetch next from _cursor into @codigo ,@matricula
   end

close _cursor
deallocate _cursor

begin tran
update TBS047 set REQNOM = subString(colaborador,1,40) from natura where CLICOD = codigo and REQCDC = matricula
commit tran
rollback tran

begin tran
update TBS047 set REQDEP = subString(site,1,30) from natura where CLICOD = codigo and REQCDC = matricula
commit tran