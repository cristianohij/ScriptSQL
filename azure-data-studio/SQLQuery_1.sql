select PROCOD
       ,PRODES
       ,PROUM1
       ,MARNOM
       ,0
       ,0
  from TBS010 with (nolock)
 where PROSTATUS='A'

union

select p.PROCOD as 'codigo'
       ,p.PRODES as 'descricao'
       ,p.PROUM1 as 'unidade'
       ,p.MARNOM as 'marca'
       ,c.TDPPRECOR1 as 'preco'
       ,e.ESTQTDATU - e.ESTQTDRES as 'saldo'
  from TBS032 e with (nolock)
  inner join TBS010 p with (nolock)
     on p.PROCOD=e.PROCOD
  inner join TBS031 c with (nolock)
     on c.TDPPROCOD=e.PROCOD
 where ESTLOC=1
       and ESTQTDATU - ESTQTDRES > 0
