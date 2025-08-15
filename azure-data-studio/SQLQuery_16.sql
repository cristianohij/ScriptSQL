select count(*)
  from TBS0103 with (nolock)
 where Len(CBPCODBAR) = 20

select *
  from TBS0103 with (nolock)
 where Len(Ltrim(rtrim(CBPCODBAR))) = 20

select Len(CBPCODBAR)
       ,count(*)
  from TBS0103 with (nolock)
  group by CBPCODBAR
  order by Len(CBPCODBAR) desc

select *
  from TBS0103 with (nolock)
 where Len(CBPCODBAR) = 1

