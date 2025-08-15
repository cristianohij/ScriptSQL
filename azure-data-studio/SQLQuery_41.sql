select NFEDATEFE
       ,count(*)
  from TBS059 with (nolock)
 where NFEDATEFE between '20231101' and '20231130'
       and NFECAN='N'
       --and NFETIP='N'
 group by NFEDATEFE




