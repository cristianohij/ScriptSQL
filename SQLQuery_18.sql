select convert(char(6),c.NFEDATEFE,112) as efetivada
       --,count(*) as contador
       ,c.NFEESTORI as uf
       ,count(c.NFEESTORI) over (partition by c.NFEESTORI) as conta
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on i.NFETIP=c.NFETIP
       and i.NFENUM=c.NFENUM
       and i.NFECOD=c.NFECOD
 where c.NFEDATEFE >= '20240101'
       and Left(i.NFECST,1)='4'
 group by convert(char(6),c.NFEDATEFE,112)
          ,c.NFEESTORI
 order by convert(char(6),c.NFEDATEFE,112)
          ,c.NFEESTORI

select convert(char(6),c.NFEDATEFE,112) as efetivada
       ,c.NFEESTORI as uf
       ,count(distinct c.NFEID) as conta
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on i.NFETIP=c.NFETIP
       and i.NFENUM=c.NFENUM
       and i.NFECOD=c.NFECOD
 where c.NFEDATEFE >= '20240101'
       and Left(i.NFECST,1)='4'
 group by C.NFEID
          ,convert(char(6),c.NFEDATEFE,112)
          ,c.NFEESTORI

 order by convert(char(6),c.NFEDATEFE,112)
          ,c.NFEESTORI

select convert(char(6),getdate(),112)

select convert(char(6),c.NFEDATEFE,112) as efetivada
       ,count(*) as contador
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on i.NFETIP=c.NFETIP
       and i.NFENUM=c.NFENUM
       and i.NFECOD=c.NFECOD
 where c.NFEDATEFE >= '20240101'
       and Left(i.NFECST,1)='4'
 group by convert(char(6),c.NFEDATEFE,112)

select convert(char(6),c.NFEDATEFE,112) as efetivada
       ,count(*) as contador
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on i.NFETIP=c.NFETIP
       and i.SERCOD=c.SERCOD
       and i.NFECOD=c.NFECOD
       and i.NFENUM=c.NFENUM
 where c.NFEDATEFE >= '20240101'
       and Left(i.NFECST,1)='4'
 group by convert(char(6),c.NFEDATEFE,112)

select convert(char(6),c.NFEDATEFE,112) as efetivada
       ,c.NFEESTORI
       ,count(*) as contador
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on i.NFETIP=c.NFETIP
       and i.SERCOD=c.SERCOD
       and i.NFECOD=c.NFECOD
       and i.NFENUM=c.NFENUM
 where c.NFEDATEFE >= '20240101'
       and Left(i.NFECST,1)='4'
 group by convert(char(6),c.NFEDATEFE,112)
          ,c.NFEESTORI

SELECT c.NFEESTORI,
       COUNT(*) AS contador
  FROM TBS059 c WITH (NOLOCK)
 INNER JOIN TBS0591 i WITH (NOLOCK)
    ON i.NFETIP = c.NFETIP
   AND i.SERCOD = c.SERCOD
   AND i.NFECOD = c.NFECOD
   AND i.NFENUM = c.NFENUM
 WHERE c.NFEDATEFE >= '20240101'
   AND LEFT(i.NFECST, 1) = '4'
 GROUP BY c.NFEESTORI;

WITH ContagemPorData AS (
  SELECT CONVERT(CHAR(6), c.NFEDATEFE, 112) AS efetivada,
         COUNT(*) AS contador
    FROM TBS059 c WITH (NOLOCK)
   INNER JOIN TBS0591 i WITH (NOLOCK)
      ON i.NFETIP = c.NFETIP
     AND i.SERCOD = c.SERCOD
     AND i.NFECOD = c.NFECOD
     AND i.NFENUM = c.NFENUM
   WHERE c.NFEDATEFE >= '20240101'
     AND LEFT(i.NFECST, 1) = '4'
   GROUP BY CONVERT(CHAR(6), c.NFEDATEFE, 112)
)
SELECT cp.efetivada,
       cp.contador,
       STUFF((
         SELECT DISTINCT ', ' + c.NFEESTORI
           FROM TBS059 c
          INNER JOIN TBS0591 i
             ON i.NFETIP = c.NFETIP
            AND i.SERCOD = c.SERCOD
            AND i.NFECOD = c.NFECOD
            AND i.NFENUM = c.NFENUM
          WHERE CONVERT(CHAR(6), c.NFEDATEFE, 112) = cp.efetivada
            AND LEFT(i.NFECST, 1) = '4'
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS estados
  FROM ContagemPorData cp;

select c.NFEESTORI
       ,count(*)
  from TBS059 c with (nolock)
 where c.NFEDATEFE between '20240101' and '20240531'
       and c.NFETIP='N'
       and c.NFECAN='N'
 group by c.NFEESTORI

select tab.efetiva
       ,tab.origem
       ,count(distinct id)
  from (
select c.NFEID as id
       ,c.NFEESTORI as origem
       ,convert(char(6), c.NFEDATEFE,112) as efetiva
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
       on i.NFETIP=c.NFETIP
          and i.SERCOD=c.SERCOD
          and i.NFENUM=c.NFENUM
          and i.NFECOD=c.NFECOD
 where c.NFEDATEFE between '20240101' and '20240531'
       and Left(i.NFECST,1)='4'
  ) as tab
 group by tab.efetiva
          ,tab.origem
 order by tab.efetiva
 
select *
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
       on i.NFETIP=c.NFETIP
          and i.SERCOD=c.SERCOD
          and i.NFENUM=c.NFENUM
          and i.NFECOD=c.NFECOD
 where c.NFEDATEFE between '20240101' and '20240531'
       and Left(i.NFECST,1)='4'
       and c.NFECAN='N'
       and i.NFEPERICMS=12
       --and c.NFEESTORI='SP'
