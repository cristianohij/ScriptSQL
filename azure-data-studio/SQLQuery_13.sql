select convert(char(6), NFEDATEFE, 112)
       ,count(*) as 'contador'
  from TBS059 with (nolock)
 where NFEDATEFE != '17530101'
       and NFETIP='N'
       and NFEESTORI != 'SP'
 group by convert(char(6), NFEDATEFE, 112)
 order by convert(char(6), NFEDATEFE, 112) desc

select top(10)
       convert(char(6), NFEDATEFE, 112)
       ,*
  from TBS059 with (nolock)

