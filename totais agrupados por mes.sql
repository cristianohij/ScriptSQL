select convert(char(7),NFSDATEMI,111),str(sum((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD),10,2) as 'total',NFSCAN
  from TBS0671 join TBS067 on TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSCLICOD in(512,6710)
 group by convert(char(7),NFSDATEMI,111),NFSCAN
 order by convert(char(7),NFSDATEMI,111)

SELECT DATEPART(yy, HireDate) AS Year,
       COUNT(*) AS NumberOfHires
FROM Northwind.dbo.Employees
GROUP BY DATEPART(yy, HireDate)

select * from TBS002 (noLock) where CLINOM Like('TANBY%')


select convert(char(7),nfsdata,111),count(nfsnum) as 'qtde' from tab18
 group by convert(char(7),nfsdata,111)
 order by convert(char(7),nfsdata,111)