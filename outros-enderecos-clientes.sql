select * from TBS080 (nolock)
 where ENFDATEMI between '20180101' and '20180131' and ENFSIT=6
       and ENFCODDES in(select CLICOD from TBS0021 (nolock) where CLIENDCPL<>'')
order by ENFDATEMI desc

select * from TBS0021 (nolock) where CLIENDCPL<>'' and CLIENDPAD<>''

select top 1 * from TBS0021 (nolock)

select * from TBS002 (nolock)
 where CLIENDENT<>'' and not exists(select '' from TBS0021 (nolock) where CLIENDTIP='E' and TBS0021.CLICOD=TBS002.CLICOD)

select * from TBS080 (nolock)
 where ENFDATEMI between '20180101' and '20180131' and ENFSIT=6
       and ENFCODDES in(select CLICOD from TBS0021 (nolock) where CLIENDCPL<>'')
order by ENFDATEMI desc

select * from TBS080 (nolock)
 where ENFDATEMI between '20180101' and '20180131' and ENFSIT=6
       and ENFCODDES in(select CLICOD from TBS002 (nolock)
                         where CLIENDENT<>'' and not exists(select '' from TBS0021 (nolock) where CLIENDTIP='E' and TBS0021.CLICOD=TBS002.CLICOD))
       and exists(select '' from TBS067 (nolock) where TBS067.SNESER=TBS080.SNESER and NFSNUM=ENFNUM and NFSENTEND<>'')
order by ENFDATEMI desc

select * from TBS002 (nolock) where CLICOD=8283

select * from TBS067 (nolock) where NFSNUM=215847

select top 100 * from TBS067 (nolock) where NFSENDENTCOD > 0 and NFSENTCPL<>'' order by NFSDATEMI desc