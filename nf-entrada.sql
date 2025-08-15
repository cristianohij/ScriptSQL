--select NFEDATENT,NFENUM from TBS059 (nolock) where NFEDATEFE between '20170301' and '20170331' and NFETIP='D' order by NFEDATEFE,NFENUM

declare @data date

set @data = '20161010'

select NFETIP,NFENOSFOR,NFEDATEFE,NFENUM,NFECHAACE,NFEDATENT
  from TBS059 (nolock)
 where NFEDATEFE = @data and NFECAN='N' and NFEUSUEFE<>''
 order by NFEDATEFE,NFENUM

--select NFEDATEFE,count(*) from TBS059 (nolock) where NFEDATEFE between '20170301' and '20170331' and NFECAN='N' and NFEUSUEFE<>'' group by NFEDATEFE

--EXEC master.dbo.xp_dirtree N'c:\', 1, 1