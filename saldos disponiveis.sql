select TBS032.PROCOD as 'Codigo',
       TBS010.PRODES as 'Descricao',
       TBS010.MARCOD as 'Cod.Marca',
       TBS014.MARNOM as 'Nome Maraca',
       TBS010.PROUM1 as 'UM',
       TBS032.ESTQTDATU as 'Qtde Atual',
       TBS032.ESTQTDRES as 'Qtde Reservada',
       TBS032.ESTQTDATU-TBS032.ESTQTDRES as 'Qtde Disponivel',
       TBS032.ESTQTDCMP as 'Compras',
       TBS032.ESTQTDPEN as 'Pendecias'
  from TBS032 (noLock) join TBS010 (noLock) on TBS032.PROCOD=TBS010.PROCOD
                       join TBS014 (noLock) on TBS010.MARCOD=TBS014.MARCOD
 where ESTLOC=1 and ESTQTDATU > 0