select * from TBS124 with (nolock) where SINEMPCOD=0 and LESCOD=1 and SINDAT='20180901'

select LMEDATHOR,LMELOCEST from TBS051 with (nolock) where LMELOCEST = 0 order by LMEDATHOR desc

delete TBS051 where LMELOCEST < 0 

delete TBS124 where LESCOD < 0

select * from TBS124 with (nolock) where SINEMPCOD=0 and SINDAT='20180901'

select top 1 *
  from TBS124 with (nolock)
       inner join CUSTOAQUISICAO on ano=year(SINDAT) and mes=month(SINDAT) and produto=SINPROCOD
 where SINDAT='20180901'

select top 100 * from CUSTOAQUISICAO with (nolock)

SINEMPCOD SINDAT                                                 LESEMPCOD LESCOD SINEMPPRO SINPROCOD       SINUNI SINQTDEMB             SINQTD                SINCUSAQU     

empresa ano    mes    produto         custo         valor         qtde    

select * from TBS124 with (nolock) where SINEMPCOD=0 and LESCOD=1 and SINDAT='20180901' and SINQTD > 0 and SINCUSAQU is null

select * from TBS124 with (nolock) where SINEMPCOD=0 and LESCOD=1 and SINDAT='20180901' and SINQTD > 0 and SINCUSAQU=0

update TBS124 set SINCUSAQU=0 where SINCUSAQU is null

select SINDAT,LESCOD,sum(SINQTD*SINCUSAQU),(select LESDES from TBS034 with (nolock) where TBS034.LESCOD=TBS124.LESCOD)
  from TBS124 with (nolock)
 where SINDAT='20180901' and SINQTD > 0 group by SINDAT,LESCOD order by SINDAT,LESCOD




