if exists (select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'teste')
   drop view teste
go
create view teste as
select convert(char(7),TBS067.NFSDATEMI,111) as 'periodo',
       TBS067.NFSCLINOM as 'cliente',
       TBS004.VENNOM as 'vendedor',
       sum(dbo.valTotalNFs(TBS067.NFSEMPCOD,TBS067.NFSNUM)) as 'valor',
       TBS067.UFESIG as 'estado',
       TBS003.MUNNOM as 'municipio'
  from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0671.NFSNUM = TBS067.NFSNUM
                        join TBS002 (nolock) on TBS067.NFSCLIEMP = TBS002.CLIEMPCOD and TBS067.NFSCLICOD = TBS002.CLICOD
                        join TBS003 (nolock) on TBS003.MUNCOD = TBS002.MUNCOD
                        join TBS004 (nolock) on TBS067.VENEMPCOD = TBS004.VENEMPCOD and TBS067.VENCOD = TBS004.VENCOD
 where TBS067.NFSDATEMI between '20110101' and '20121108'
 group by convert(char(7),TBS067.NFSDATEMI,111),TBS067.NFSCLINOM,TBS004.VENNOM,TBS067.UFESIG,TBS003.MUNNOM --TBS067.NFSCLICOD,TBS067.NFSCLINOM,TBS003.MUNNOM
go

select TBS067.NFSCLICOD,
       TBS067.NFSCLINOM,
       sum(dbo.valTotLiquidoProduto(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)),
       (select TBS003.MUNCOD from TBS003 (nolock) where TBS003.MUNCOD = (select TBS002.MUNCOD from TBS002 (nolock) where TBS067.NFSCLIEMP = TBS002.CLIEMPCOD and TBS067.NFSCLICOD = TBS002.CLICOD))
  from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0671.NFSNUM = TBS067.NFSNUM
 where TBS067.NFSDATEMI between '20110101' and '20111231'
 group by TBS067.NFSCLICOD,TBS067.NFSCLINOM,TBS067.NFSCLIEMP

select dbo.valTotalNFs(0,566)

select * from TBS067 (nolock) where TBS067.NFSDATEMI between '20110501' and '20121108'

update TBS067 set NFSENDENTCOD = 0 where NFSENDENTCOD is null and NFSDATEMI between '20110501' and '20121108'         

select * from teste where periodo between '2011/05' and '2012/11'