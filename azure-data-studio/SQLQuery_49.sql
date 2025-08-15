           from TBS0591 i with (nolock)
                inner join TBS059 c with (nolock)
                   on i.NFEEMPCOD=c.NFEEMPCOD and i.NFETIP=c.NFETIP and i.NFENUM=c.NFENUM and i.NFECOD=c.NFECOD and i.SEREMPCOD=c.SEREMPCOD and i.SERCOD=c.SERCOD

select *
       ,dbo.NFDTOTNOTA(0, 0, NDFSNESER, NDFENFNUM)
  from TBS143 with (nolock)
 where NDFDATEMI between '20231201' and '20231231'
       and NDFENFSIT=6

select tab.cfop
       ,sum(tab.valor) as 'total'
  from (
select i.NDFCFOP as 'cfop'
       ,dbo.NDFTOTLIQITEST(c.NDFEMPCOD, c.NDFNUMDOC, i.NDFITE) as 'valor'
  from TBS1431 i with (nolock)
  inner join TBS143 c with (nolock)
     on c.NDFEMPCOD=i.NDFEMPCOD
        and c.NDFNUMDOC=i.NDFNUMDOC
 where c.NDFDATEMI between '20231201' and '20231231'
       and c.NDFENFSIT=6
  ) as tab
 group by tab.cfop


jljlj