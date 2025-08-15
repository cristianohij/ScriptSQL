-- listagens
select * from TBS067 (noLock) where NFSNUM in(131055)
select * from TBS0671 (noLock) where NFSNUM in(131055)
select * from TBS0672 (noLock) where NFSNUM in(131055)

select * from TBS069 (noLock) where PDFNFSNUM in(131055)

select * from TBS056 (noLock) where CRETIT in(131055)

select * from TBS060 (noLock) where HCRTIT in(131055)


-- eliminacoes
delete TBS067 where NFSNUM in(131055)
delete TBS0671 where NFSNUM in(131055)
delete TBS0672 where NFSNUM in(131055)

delete TBS069 where PDFNFSNUM in(131055)

delete TBS056 where CRETIT in(131055)

delete TBS060 where HCRTIT in(131055)