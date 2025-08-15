select *
  from TBS032 with (nolock)
 where ESTLOC in(1,2)
       and convert(date,ESTDATALT)='20240221'
       and ESTQTDATU-ESTQTDRES = 0

select *
  from TBS032 with (nolock)
 where ESTLOC in(1,2)
       and convert(date,ESTDATALT)=convert(date,getdate())
       and ESTQTDATU-ESTQTDRES = 0

select top(100) *
  from TBS051 with (nolock)
 where convert(date,LMEDATHOR)=convert(date,getdate())
       and LMEACA='S'
       and LMEINFALT='E'
       and LMELOCEST in(1,2)
       and LMEQTDSAL=0
       and LMEQTDATU > 0





