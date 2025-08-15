select A.NEENUM -1 from TBS099 as A (nolock) where A.NEENUM <> 1 and not exists(select B.NEENUM from TBS099 as B where B.NEENUM = A.NEENUM-1)
 order by A.NEENUM
