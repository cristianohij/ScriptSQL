select d.PROCOD as serial_no
       ,d.NFSPRODES as description_
       ,d.NFSPROCLI as customer_part_no
       ,d.NFSQTD as quantity
       ,iif(d.NFSPROCLI = '546034889A' or d.NFSPROCLI = '546051960A' or d.NFSPROCLI = '615015500A', 'EA', iif(d.NFSPROCLI = '546073789A', 'M', iif(d.NFSPROCLI = '619507100A', 'MM',''))) as um
       ,'90395132' as supplier_code
       --,c.NFSDATEMI as date_d
       ,'D' + replace(convert(char(8), c.NFSDATEMI, 3), '/', '') as field_date
       ,'A01' as part_revision
       ,d.NFSNUM as batch_no
  from TBS0671 d with (nolock)
 Left join TBS067 c with (nolock)
        on c.NFSEMPCOD = d.NFSEMPCOD
           and c.SNEEMPCOD = d.SNEEMPCOD
           and c.SNESER = d.SNESER
           and c.NFSNUM = d.NFSNUM
 where d.NFSNUM = 299771
 order by d.NFSITE

SELECT
    d.PROCOD AS serial_no,
    d.NFSPRODES AS description_,
    d.NFSPROCLI AS customer_part_no,
    d.NFSQTD AS quantity,
    CASE 
        WHEN d.NFSPROCLI IN ('546034889A','546051960A','615015500A') THEN 'EA'
        WHEN d.NFSPROCLI = '546073789A' THEN 'M'
        WHEN d.NFSPROCLI = '619507100A' THEN 'MM'
        ELSE ''
    END AS um,
    '90395132' AS supplier_code,
    --'D' + REPLACE(CONVERT(char(6), c.NFSDATEMI, 3), '/', '') AS field_date,
    'D' + FORMAT(c.NFSDATEMI, 'ddMMyy'),
    'A01' AS part_revision,
    d.NFSNUM AS batch_no
FROM TBS0671 d WITH (NOLOCK)
LEFT JOIN TBS067 c WITH (NOLOCK)
    ON c.NFSEMPCOD = d.NFSEMPCOD
   AND c.SNEEMPCOD = d.SNEEMPCOD
   AND c.SNESER = d.SNESER
   AND c.NFSNUM = d.NFSNUM
WHERE d.NFSNUM = 299771
ORDER BY d.NFSITE


