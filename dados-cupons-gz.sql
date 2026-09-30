select *
  from movcaixa
 where status = '13'
       and cancelado = 'S' limit 100;

select distinct(cgc)
       ,count(*)
  from movcaixa
 where status = '13'
       and data between '20250901' and '20250930';

select cgc
  from movcaixa
 where status = '13'
       and data between '20250901' and '20250930'
 group by cgc;

SELECT COUNT(DISTINCT cgc) AS qtd_cgc_unicos
FROM movcaixa
WHERE status = '13'
  AND data BETWEEN '2025-09-01' AND '2025-09-30';

select count(distinct cupom, status) as qtde
  from movcaixa
 where data between '20250101' and '20250930'
       and status = '03';

-- quantidade de cupons emitidos por ano-mês

SELECT 
    DATE_FORMAT(data, '%Y-%m') AS ano_mes,
    COUNT(DISTINCT CONCAT(cupom, '-', status)) AS qtde
FROM movcaixa
WHERE data BETWEEN '2025-01-01' AND '2025-09-30'
  AND status = '03'
GROUP BY DATE_FORMAT(data, '%Y-%m')
ORDER BY ano_mes;

SELECT 
    DATE_FORMAT(data, '%Y-%m') AS ano_mes,
    COUNT(DISTINCT CASE WHEN status = '03' THEN CONCAT(cupom, '-', status) END) AS qtde,
    COUNT(DISTINCT CASE WHEN status = '13' THEN cgc END) AS qtd_cgc_unicos
FROM movcaixa
WHERE data BETWEEN '2025-01-01' AND '2025-09-30'
GROUP BY DATE_FORMAT(data, '%Y-%m')
ORDER BY ano_mes;

-- com porcentagem

SELECT 
    DATE_FORMAT(data, '%Y-%m') AS ano_mes,
    COUNT(DISTINCT CASE WHEN status = '03' THEN CONCAT(cupom, '-', status) END) AS qtde,
    COUNT(DISTINCT CASE WHEN status = '13' THEN cgc END) AS qtd_cgc_unicos,
    ROUND(
        (COUNT(DISTINCT CASE WHEN status = '13' THEN cgc END) / 
         NULLIF(COUNT(DISTINCT CASE WHEN status = '03' THEN CONCAT(cupom, '-', status) END), 0)) * 100,
        2
    ) AS perc_cgc_sobre_qtde
FROM movcaixa
WHERE data BETWEEN '2025-01-01' AND '2025-09-30'
GROUP BY DATE_FORMAT(data, '%Y-%m')
ORDER BY ano_mes;
