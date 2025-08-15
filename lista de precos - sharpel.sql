declare @codfor as int,
        @codmar as int

set @codfor = 0 -- informe o codigo de um fornecedor especifico (zero para todos)
set @codmar = 0 -- informe o codigo de uma marca especifica (zero para todas)

select isnull(TBS010.FORCOD,'') as 'cod_fornecedor',
       isnull(TBS006.FORNOM,'') as 'nome_fornecedor',
       isnull(TBS010.MARCOD,'') as 'cod_marca',
       isnull(TBS014.MARNOM,'') as 'nome_marca',
       isnull(TDPPROCOD,'') as 'cod_produto',
       PRODES as 'descricao',
       PROUM1 as 'UM1',
       cast(isnull(TDPPRECOR1,0) as char(12)) as 'pre_unitario_corp',
       PROUM2 as 'UM2',
       cast(isnull(PROUM2QTD,0) as char(9)) as 'qtde_embalagem',
       cast(isnull(TDPPRECOR2*PROUM2QTD,0) as char(12)) as 'pre_atacado_corp'
  from TBS031 (noLock) right join TBS010 (noLock) on TBS031.TDPPROCOD=TBS010.PROCOD
                       Left join TBS006 (noLock) on TBS010.FORCOD=TBS006.FORCOD
                       Left join TBS014 (noLock) on TBS010.MARCOD=TBS014.MARCOD
 where TBS010.FORCOD >= @codfor and
       TBS010.MARCOD >= @codmar