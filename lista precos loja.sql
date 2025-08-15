declare @pro_ini as char(15),
        @pro_fin as char(15)

set @pro_ini = '164' -- codigo do produto inicial
set @pro_fin = '164Z' -- codigo do produto final

select isnull(TDPPROCOD,'') as 'cod_produto',
       PRODES as 'descricao',
       PROUM1 as 'UM1',
       cast(isnull(TDPPRELOJ1,0) as char(12)) as 'pre_unitario_loja',
       PROUM2 as 'UM2',
       cast(isnull(PROUM2QTD,0) as char(9)) as 'qtde_embalagem',
       cast(isnull(TDPPRELOJ2*PROUM2QTD,0) as char(12)) as 'pre_atacado_loja'
  from TBS031 (noLock) right join TBS010 (noLock) on TBS031.TDPPROCOD=TBS010.PROCOD
 where TBS010.PROCOD between @pro_ini and @pro_fin
 order by TBS010.PRODES