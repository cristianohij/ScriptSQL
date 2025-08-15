select * from TBS051 with (nolock)
 where convert(date,LMEDATHOR)='20180611' and LMEUSU='DESENV' and LMELOCEST=7

select convert(char(6),LMEDATHOR,112),LMELOCEST,count(*) from TBS051 with (nolock)
 where LMEROT='PEST010'
 group by convert(char(6),LMEDATHOR,112),LMELOCEST
 order by convert(char(6),LMEDATHOR,112) desc,LMELOCEST

select * from TBS051 with (nolock)
 where convert(date,LMEDATHOR)>='20181201' and LMELOCEST=6
       and LMEROT='PEST010'
       and LMEQTDATU > 0

