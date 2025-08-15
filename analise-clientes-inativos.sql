select LOGID
  from TBS035 with (nolock)
 where LOGTAB='TBS002'
       and LOGATT='CLISIT'
       and LOGDAT <= '20211231'
       and LOGVALATU='I'
union
select CLILOGID
  from TBS002 with (nolock)
 where CLISTATUS='I'


 group by LOGID

select CLICOD
       ,CLINOM
  from TBS002 with (nolock)
 where CLILOGID in(select LOGID
  from TBS035 with (nolock)
 where LOGTAB='TBS002'
       and LOGATT='CLISIT'
       and LOGDAT <= '20211231'
       and LOGVALATU='I'
union
select CLILOGID
  from TBS002 with (nolock)
 where CLISTATUS='I'
)
and CLIUCPDAT >= '20220101'

SELECT a.LOGID, (SELECT max(b.LOGSEQ) 
FROM TBS035 b WHERE b.LOGID=a.LOGID) AS 'LOG'
FROM TBS035 a GROUP BY a.LOGID ORDER BY a.LOGID

select *
  from TBS035 with (nolock)
 where LOGID=32470
       and LOGTAB='TBS002'

select CLILOGID
  from TBS002 with (nolock)
 where CLICOD=32868

select a.LOGID
       ,( select max(b.LOGSEQ)
            from TBS035 b
           where b.LOGID=a.LOGID
                 and b.LOGTAB='TBS002'
                 and b.LOGATT='CLISIT'
                 and b.LOGDAT <= '20211231'
                 and b.LOGVALATU='I'
        ) as 'SEQ'
  from TBS035 a with (nolock)
 where LOGTAB='TBS002'
       and LOGATT='CLISIT'
       and LOGDAT <= '20211231'
       and LOGVALATU='I'
 group by a.LOGID
 order by a.LOGID

select LOGID
       ,max(LOGSEQ) as 'sequencia'
  from TBS035 a with (nolock)
 where LOGTAB='TBS002'
       and LOGATT='CLISIT'
       and LOGDAT <= '20211231'
       and LOGVALATU='I'
 group by LOGID
 order by LOGID

select a.LOGID
  from TBS035 a with (nolock)
 where LOGTAB='TBS002'
       and a.LOGATT='CLISIT'
       and a.LOGDAT <= '20211231'
       and a.LOGVALATU='I'
       and a.LOGVALATU = (select top(1) b.LOGVALATU
                            from TBS035 b with (nolock)
                           where b.LOGID=a.LOGID
                                 and b.LOGTAB='TBS002'
                                 and b.LOGATT='CLISIT'
                                 and b.LOGDAT <= '20211231'
                           order by b.LOGSEQ desc
                         )
 group by a.LOGID
 order by a.LOGID

select CLICOD
  from TBS002 with (nolock)
 where CLILOGID=1468

-- lista clientes inativos atualmente ou que estavam inativos antes da última compra

select c.CLICOD
       ,c.CLINOM
  from TBS002 c with (nolock)
 where c.CLILOGID in( select a.LOGID
                        from TBS035 a with (nolock)
                       where a.LOGTAB='TBS002'
                             and a.LOGATT='CLISIT'
                             --and a.LOGDAT <= '20211231'
                             and a.LOGDAT <= c.CLIUCPDAT
                             and a.LOGVALATU='I'
                             and a.LOGVALATU = ( select top(1) b.LOGVALATU
                                                   from TBS035 b with (nolock)
                                                  where b.LOGID=a.LOGID
                                                        and b.LOGTAB='TBS002'
                                                        and b.LOGATT='CLISIT'
                                                  --and b.LOGDAT <= '20211231'
                                                        and b.LOGDAT <= c.CLIUCPDAT
                                                  order by b.LOGSEQ desc
                                               )

                      union

                      select CLILOGID
                        from TBS002 with (nolock)
                       where CLISIT='I'
                             --and CLIUCPDAT >= '20220101'
                    )
and c.CLIUCPDAT >= '20220101'

select count(*)
  from TBS002 with (nolock)
 where CLISIT='I'
    and CLIUCPDAT >= '20220101'

select c.CLICOD
       ,c.CLINOM
       ,c.CLISIT
       ,c.CLIUCPDAT
  from TBS002 c with (nolock)
 where exists ( select ''
                        from TBS035 a with (nolock)
                       where a.LOGID=c.CLILOGID
                             and a.LOGTAB='TBS002'
                             and a.LOGATT='CLISIT'
                             --and a.LOGDAT <= '20211231'
                             and a.LOGDAT <= c.CLIUCPDAT
                             and a.LOGVALATU='I'
                             and a.LOGVALATU = ( select top(1) b.LOGVALATU
                                                   from TBS035 b with (nolock)
                                                  where b.LOGID=a.LOGID
                                                        and b.LOGTAB='TBS002'
                                                        and b.LOGATT='CLISIT'
                                                  --and b.LOGDAT <= '20211231'
                                                        and b.LOGDAT <= c.CLIUCPDAT
                                                  order by b.LOGSEQ desc
                                               )

                      union

                      select CLILOGID
                        from TBS002 c2 with (nolock)
                       where c2.CLILOGID=c.CLILOGID
                             and CLISIT='I'
                             --and CLIUCPDAT >= '20220101'
                    )
and c.CLIUCPDAT >= '20220101'

select CLICOD
       ,CLINOM
       ,CLIUCPDAT
  from TBS002 with (nolock)
 where CLIUCPDAT <= '20221031'
       and CLIUCPDAT > '17530101'

select CLICOD
       ,CLINOM
       ,CLIUCPDAT
       ,CLIUCPVAL
  from TBS002 with (nolock)
 where CLIUCPDAT not between  '20221031' and '20221231'
       and CLIUCPDAT > '17530101'
       and CLIUCPDAT >= '20230101'



