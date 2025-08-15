sp_configure 'allow updates', '0'
RECONFIGURE WITH OVERRIDE

sp_configure 'show advanced options', 1
RECONFIGURE
go

sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
GO
