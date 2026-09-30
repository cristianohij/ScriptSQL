-- ETAPA 1 — Habilitar CLR

sp_configure 'clr enabled', 1;
RECONFIGURE;

-- ETAPA 2 — (Importante) TRUSTWORTHY

ALTER DATABASE [SIBD]
SET TRUSTWORTHY ON;

-- ETAPA 3 — Copiar a DLL

-- c:\integros\clr

-- 3. Registrar PRIMEIRO a dependência

CREATE ASSEMBLY zxing
FROM 'C:\integros\CLR\zxing.dll'
WITH PERMISSION_SET = UNSAFE;

-- ETAPA 4 — Criar o Assembly

CREATE ASSEMBLY DataMatrixSQL
FROM 'C:\integros\CLR\DataMatrixSQL.dll'
WITH PERMISSION_SET = SAFE;

-- 1. Remover a função

IF OBJECT_ID('dbo.GerarDataMatrix', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GerarDataMatrix;

-- 2. Remover assemblies

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'DataMatrixSQL')
    DROP ASSEMBLY DataMatrixSQL;

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'zxing')
    DROP ASSEMBLY zxing;

-- acima não funcionou devido incompantibilidade do zxing com sql server 2012

-- dados para a etiqueta

-- antigo

SELECT        d.PROCOD AS serial_no, d.NFSPRODES AS description_, d.NFSPROCLI AS customer_part_no, d.NFSQTD AS quantity, CASE WHEN d .NFSPROCLI IN ('546034889A', '546051960A', '615015500A') 
                         THEN 'EA' WHEN d .NFSPROCLI = '546073789A' THEN 'M' WHEN d .NFSPROCLI = '619507100A' THEN 'MM' ELSE '' END AS um, '395132' AS supplier_code, 'D' + FORMAT(c.NFSDATEMI, 'ddMMyy') 
                         AS field_date, 'A01' AS part_revision, d.NFSNUM AS batch_no
FROM            TBS0671 AS d WITH (NOLOCK) LEFT OUTER JOIN
                         TBS067 AS c WITH (NOLOCK) ON c.NFSEMPCOD = d.NFSEMPCOD AND c.SNEEMPCOD = d.SNEEMPCOD AND c.SNESER = d.SNESER AND c.NFSNUM = d.NFSNUM
WHERE        (d.NFSNUM = 299771)
ORDER BY d.NFSITE

-- novo

select d.PROCOD as serial_no
       ,d.NFSPRODES as description_
       ,d.NFSPROCLI as customer_part_no
       ,d.NFSQTD as quantity
       ,case
           when d.NFSPROCLI in ('546034889A', '546051960A', '615015500A') then 'EA'
           when d.NFSPROCLI = '546073789A' then 'M'
           when d.NFSPROCLI = '619507100A' then 'MM'
           else ''
        end as um
       ,'395132' as supplier_code
       ,'D' + format(c.NFSDATEMI, 'ddMMyy') as field_date
       ,'A01' as part_revision
       ,right('00' + Ltrim(cast(d.SNESER as varchar(2))),2) + right('000000' + Ltrim(cast(d.NFSNUM as varchar(6))),6) as batch_no
       ,'[)>{RS}06{GS}P' + Ltrim(rtrim(d.NFSPROCLI)) + '{GS}Q' + cast(cast(d.NFSQTD as int) as varchar(9)) + '{GS}395132{GS}' + cast(cast(d.NFSNUM as int) as varchar(9)) + '{GS}' + Ltrim(rtrim(d.PROCOD)) + '{RS}{EOT}' as data_matrix
  from TBS0671 as d with (nolock)
  Left outer join TBS067 c with (nolock)
               on c.NFSEMPCOD = d.NFSEMPCOD
                  and c.SNEEMPCOD = d.SNEEMPCOD
                  and c.SNESER = d.SNESER
                  and c.NFSNUM = d.NFSNUM
 where (d.NFSNUM = 299771)
 order by d.NFSITE

EXEC sp_help 'TBS0671'