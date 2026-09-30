SELECT p.PROCOD
       ,p.PROUM1
       ,p.PROUM2
       ,p.PROUM3
       ,p.PROUM4
FROM TBS010 p WITH (NOLOCK)
WHERE p.PROPESAVEL <> 'S'
  AND EXISTS (
      SELECT 1
      FROM (VALUES
           (p.PROUM1),
           (p.PROUM2),
           (p.PROUM3),
           (p.PROUM4)
      ) v(UM)
      WHERE v.UM IN ('KG','MT')
  );

begin tran
update TBS010
   set PROPESAVEL = 'S'
FROM TBS010 p WITH (NOLOCK)
WHERE p.PROPESAVEL <> 'S'
  AND EXISTS (
      SELECT 1
      FROM (VALUES
           (p.PROUM1),
           (p.PROUM2),
           (p.PROUM3),
           (p.PROUM4)
      ) v(UM)
      WHERE v.UM IN ('KG','MT')
  );

rollback tran
commit tran




