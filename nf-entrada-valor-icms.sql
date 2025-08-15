select NFEVALICMS,* from TBS0591 (nolock) where NFETIP='D' and NFENUM=499

select dbo.NFEVALICMS(0,NFETIP,NFENUM,NFECOD,0,SERCOD,NFEITE),*
  from TBS0591 (nolock) where NFETIP='D' and NFENUM=499

begin tran
update TBS0591 set NFEVALICMS=dbo.NFEVALICMS(0,NFETIP,NFENUM,NFECOD,0,SERCOD,NFEITE)
  from TBS0591 (nolock) where NFETIP='D' and NFENUM=499
commit tran

select count(*) from TBS0591 (nolock) where NFEVALICMS > 0

alter table TBS0591 drop column NFEVALICMS






