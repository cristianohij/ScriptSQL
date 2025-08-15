select distinct NFETIP
  from TBS059 with (nolock)

select top(1) *
  from TBS059 with (nolock)
 
drop table #notas

select NFECOD as 'codigo'
       ,NFENOM as 'nome'
	   ,subString(NFECHAACE,7,14) as 'cnpj'
	   ,NFEID as 'id'
  into #notas
  from TBS059 c with (nolock)
 where NFETIP='N'
       and NFECAN='N'
	   and NFEDATEFE > '17530101'
	   and exists(select 'e'
	                from TBS0591 i with (nolock)
                   where i.NFEEMPCOD=c.NFEEMPCOD
				         and i.NFETIP=c.NFETIP
						 and i.NFENUM=c.NFENUM
						 and i.NFECOD=c.NFECOD
						 and i.SEREMPCOD=c.SEREMPCOD
						 and i.SERCOD=c.SERCOD
						 and i.LESCOD=10)


                    from TBS059 c with (nolock)
                         inner join TBS0591 i with (nolock)
                            on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD


select codigo
       ,nome
	   ,cnpj
  --into #notas2
  from #notas n
 group by codigo, nome, cnpj

select *
	   ,(select top 1 e.NFEDATEFE
	       from TBS059 e with (nolock)
          where e.NFEID=n.id
	      order by e.NFEDATEFE desc)
select *
  from #notas
