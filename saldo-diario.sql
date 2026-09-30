select *
  from SALDODIARIO sd with (nolock)
 where sd.ESTDATSAL = CAST(GETDATE()-1 AS DATE) -- '20260519'
       and sd.ESTQTDATU = 0

 order by sd.ESTDATSAL desc
  CAST(GETDATE()-1 AS DATE)

SELECT 
       sd.ESTDATSAL,
       sd.PROEMPCOD,
       sd.ESTLOC,
       sd.PROCOD,
       sd.PRODES,
       sd.ESTQTDATU AS saldo_atual,
       ant.ESTDATSAL AS data_anterior,
       ant.ESTQTDATU AS saldo_anterior
FROM SALDODIARIO sd WITH (NOLOCK)

OUTER APPLY (
    SELECT TOP 1
           sda.ESTDATSAL,
           sda.ESTQTDATU
    FROM SALDODIARIO sda WITH (NOLOCK)
    WHERE sda.PROEMPCOD = sd.PROEMPCOD
      AND sda.ESTLOC     = sd.ESTLOC
      AND sda.PROCOD     = sd.PROCOD
      AND sda.ESTDATSAL  < sd.ESTDATSAL
    ORDER BY sda.ESTDATSAL DESC
) ant

WHERE sd.ESTDATSAL = CAST(GETDATE()-1 AS DATE)
  AND sd.ESTQTDATU = 0
  AND ant.ESTQTDATU > 0
  and sd.ESTLOC = 1

select top 100 *
  from TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) = cast(getdate()-8 AS DATE)
       and l.LMEACA = 'S'
       and l.LMEINFALT = 'E'
       and l.LMEQTDDIS = 0
       and l.LMELOCEST = 1




