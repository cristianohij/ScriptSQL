select distinct PDFNFSNUM from TBS069 (noLock)
 where exists(select 'ex' from TBS067 (noLock) where NFSNUM=PDFNFSNUM and NFSCAN<>PDFNFSCAN)

begin tran
update TBS069 set PDFNFSCAN=NFSCAN from TBS069 join TBS067 on NFSNUM=PDFNFSNUM 
 where NFSCAN<>PDFNFSCAN
commit tran

select distinct PDFNFSNUM from TBS069 (noLock)
 where exists(select 'ex' from TBS067 (noLock) where NFSNUM=PDFNFSNUM and NFSCAN<>PDFNFSCAN)

 