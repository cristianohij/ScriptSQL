declare @n int,@seq int
set @n = 1

while (select count(*) from TBS014 (noLock)) >= @n
   begin
      set @seq = (select cast(max(right(rTrim(PROCOD),4)) as int) from TBS010 (noLock) where MARCOD = @n)
      if @seq > 0 update TBS014 set MARSEQPRO = @seq where MARCOD = @n
      set @n = @n + 1
   end
