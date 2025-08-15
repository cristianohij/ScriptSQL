select * from CODS

insert into CODS select PROCOD from TANBYND.SIBD.dbo.TBS010



select codigo from CODS union
select PROCOD from TANBYCD.SIBD.dbo.TBS010

insert into CODS
select PROCOD from BESTBAG.SIBD2.dbo.TBS010 union
select PROCOD from MISASPEL.SIBD.dbo.TBS010 union
select PROCOD from PAPELYNA.SIBD.dbo.TBS010 union
select PROCOD from TANBYCD.SIBD.dbo.TBS010 union
select PROCOD from TANBYND.SIBD.dbo.TBS010 union
select PROCOD from TANBYTTE.SIBD.dbo.TBS010

select codigo,
       isnull(A.PRODES,'') as 'best-bag',
       isnull(B.PRODES,'') 'misaspel',
       isnull(C.PRODES,'') as 'papelyna',
       isnull(D.PRODES,'') as 'tanby-cd',
       isnull(E.PRODES,'') as 'tanby-matriz',
       isnull(F.PRODES,'') as 'tanby-tte'
  from CODS left join BESTBAG.SIBD2.dbo.TBS010 A on A.PROCOD = codigo
            left join MISASPEL.SIBD.dbo.TBS010 B on B.PROCOD = codigo
            left join PAPELYNA.SIBD.dbo.TBS010 C on C.PROCOD = codigo
            left join TANBYCD.SIBD.dbo.TBS010 D  on D.PROCOD = codigo
            left join TANBYND.SIBD.dbo.TBS010 E  on E.PROCOD = codigo
            left join TANBYTTE.SIBD.dbo.TBS010 F on F.PROCOD = codigo
 where A.PRODES <> B.PRODES or B.PRODES <> C.PRODES or C.PRODES <> D.PRODES or D.PRODES <> E.PRODES or E.PRODES <> F.PRODES




