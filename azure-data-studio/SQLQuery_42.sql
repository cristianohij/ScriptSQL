-- relatório notas de entradas

select c.NFEDATEFE
       ,c.NFECOD
       ,c.NFENOM
       ,c.NFENUM
       ,r.CFCUSUFIN
  from TBS059 c with (nolock)
  Left join TBS0592 p with (nolock)
         on c.NFEEMPCOD=p.NFEEMPCOD
            and c.NFETIP=p.NFETIP
            and c.NFENUM=p.NFENUM
            and c.NFECOD=p.NFECOD
            and c.SEREMPCOD=p.SEREMPCOD
            and c.SERCOD=p.SERCOD
  Left join TBS133 r with (nolock)
         on r.CFCNFECHAACE=c.NFECHAACE
 where c.NFEDATEFE between '20230701' and '20230731'

select top(10) *
  from TBS133 with (nolock)



