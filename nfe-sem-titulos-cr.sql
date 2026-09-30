select *
  from TBS067 nfs with (nolock)
 inner join TBS080 nfe with (nolock)
         on nfe.SNESER = nfs.SNESER
            and nfe.ENFNUM = nfs.NFSNUM
 inner join TBS0675 dup with (nolock)
         on dup.SNESER = nfs.SNESER
            and dup.NFSNUM = nfs.NFSNUM
  Left join TBS056 cre with (nolock)
         on cre.CRECHANFE = nfe.ENFCHAACE
 where nfs.NFSDATEMI >= '20250901'
       and nfs.NFSCAN = 'N'
       and nfe.ENFSIT = 6
       and cre.CRETIT is null

-- otimizado chatGPT

SELECT nfs.*
FROM TBS067 nfs WITH (NOLOCK)
INNER JOIN TBS080 nfe WITH (NOLOCK)
        ON nfe.SNESER = nfs.SNESER
       AND nfe.ENFNUM = nfs.NFSNUM
WHERE nfs.NFSDATEMI between '20200101' and '20250922'
  AND nfs.NFSCAN = 'N'
  AND nfe.ENFSIT = 6
  AND EXISTS (
        SELECT 1
        FROM TBS0675 dup WITH (NOLOCK)
        WHERE dup.SNESER = nfs.SNESER
          AND dup.NFSNUM = nfs.NFSNUM
  )
  AND NOT EXISTS (
        SELECT 1
        FROM TBS056 cre WITH (NOLOCK)
        WHERE cre.CRECHANFE = nfe.ENFCHAACE
  );


select *
  from TBS0675 with (nolock)
 where NFSNUM = 76173

select *
  from TBS056 with (nolock)
 where CRETIT = 76173


