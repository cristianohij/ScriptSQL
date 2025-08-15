select PDPCOD from TBS015 (nolock)
 where PDPCOD between '174' and '174Z' and
       PDPUNI not in(select PROUM1
                         from TBS010 (nolock)
                        where PROCOD=PDPCOD 
                       union
                       select PROUM2
                         from TBS010 (nolock)
                        where PROCOD=PDPCOD
                       union
                       select PROUM3
                         from TBS010 (nolock)
                        where PROCOD=PDPCOD
                       union
                       select PROUM4
                         from TBS010 (nolock)
                        where PROCOD=PDPCOD)