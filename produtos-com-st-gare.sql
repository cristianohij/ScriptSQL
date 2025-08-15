select * from TBS0591 with (nolock) where NFETIP='N' and NFENUM=34916 order by NFEITE

select PROCOD,PRODES,PROCLAFIS,PROSTBB
  from TBS010 with (nolock)
 where PROCOD in(select PROCOD from TBS0591 with (nolock) where NFETIP='N' and NFENUM=34916)

select *
  from TBS0921 with (nolock)
 where NCMCOD in(select PROCLAFIS
                   from TBS010 with (nolock)
                  where PROCOD in(select PROCOD from TBS0591 with (nolock) where NFETIP='N' and NFENUM=34916)
                        and PROSTBB='60')
