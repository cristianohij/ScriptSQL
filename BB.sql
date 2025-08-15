select count(*)
  from TBS080 with (nolock)
 where ENFTIPDOC=1
       and ENFFINEMI=1
       and ENFSIT=6
       and ENFDATEMI between '20190601' and '20190622'

