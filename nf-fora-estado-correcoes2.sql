select * from TBS0431 (nolock) where ORCNUM=565021

select PROCLAFIS from TBS010 (nolock) where PROCOD=(select PROCOD from TBS0431 (nolock) where ORCNUM=565021)

select * from TBS0921 (nolock) where NCMCOD=(select PROCLAFIS from TBS010 (nolock) where PROCOD=(select PROCOD from TBS0431 (nolock) where ORCNUM=565021))

--insert into TBS0921 select 96082000,'','SC',.01,0

select CLIINDIE from TBS002 (nolock) where CLICOD=(select ORCCLI from TBS043 (nolock) where ORCNUM=565021)
