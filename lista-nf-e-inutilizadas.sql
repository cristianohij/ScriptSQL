select * from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU - ESTQTDRES < 0

select * from TBS032 (nolock) where ESTLOC=1 and PROCOD='0631925'

select * from produto

select * from TBS041 (nolock) where COPTIP='S'

select ENFSIT,
       case ENFSIT
          when  7 then 'Cancelada'
          when  8 then 'Denegada'
          when  9 then 'Processamento na SEFAZ'
          when 10 then 'Rejeitada'
          when 11 then 'Inutilizada'
          else 'Outros'
       end,
       *
  from TBS080 (nolock)
 where ENFDATEMI >= '20170101' and ENFSIT<>6 and
       ENFNUM in(199167,201860,202825,203401,203691,205191,210330)
 order by ENFNUM



select subString(PROCLAFIS,1,2) from TBS010 (nolock) where PROCLAFIS<>'' group by subString(PROCLAFIS,1,2) order by subString(PROCLAFIS,1,2)

select PROCOD,PRODES,PROCLAFIS,PROSTATUS from TBS010 (nolock) where substring(PROCLAFIS,1,2)='09'
