declare @marca int
set @marca = 788

select PROCOD,PRODES,PROLOCFIS from TBS010 where MARCOD = @marca order by PRODES