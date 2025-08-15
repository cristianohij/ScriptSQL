select '' as 'B1_FILIAL',PROCOD as 'B1_COD',PROCODBAR1 as 'B1_CODBAR',PRODES as 'B1_DESC','001' as 'B1_GRUPO',
       replicate('0',6-Len(rtrim(cast(MARCOD as varchar))))+rtrim(cast(MARCOD as varchar)) as 'B1_PROC',
       MARNOM as 'B1_PYNFORN','PA' as 'B1_TIPO','01' as 'B1_LOCPAD',MARNOM as 'B1_PYMARCA',PROUM1 as 'B1_UM',
       PROUM2 as 'B1_UM2',PROUM2QTD as 'B1_UM2TO1',PROUM3 as 'B1_UM3',PROUM3QTD as 'B1_UM3TO1',PROUM4 as 'B1_UM4',
       PROUM4QTD as 'B1_UM4TO1',PROSTATUS as 'B1_PYATIVO','01' as 'B1_LOJPROC',TDPDATATU as 'B1_UREV',
       PROSTBA+Ltrim(PROSTBB) as 'B1_GRTRIB'
 from TBS010 join TBS031 on PROCOD=TDPPROCOD
 where MARCOD = 164

select '' as 'B1_FILIAL',PROCOD as 'B1_COD',PROCODBAR1 as 'B1_CODBAR' from TBS010 where PROCODBAR1 <> '' and MARCOD=164
