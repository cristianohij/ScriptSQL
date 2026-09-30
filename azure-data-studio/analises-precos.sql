select pre.TDPPROCOD as codigo
       ,pro.PRODES
       ,(pre.TDPPRECOR1 - pre.TDPCUSBAS) / pre.TDPPRECOR1 * 100 as margem_lucro
       ,(pre.TDPPRECOR1 - pre.TDPCUSBAS) / pre.TDPCUSBAS * 100 as markup
       ,case
           when pre.TDPPRECOR1 < pre.TDPCUSBAS then 'prejuizo'
           when ((pre.TDPPRECOR1 - pre.TDPCUSBAS) / pre.TDPPRECOR1) * 100 < 10 then 'baixa'
           when ((pre.TDPPRECOR1 - pre.TDPCUSBAS) / pre.TDPPRECOR1) * 100 < 30 then 'media'
           else 'alta'
        end as classificacao_margem
       ,pre.TDPPRECOR1 as preco
       ,pre.TDPCUSBAS / (1 - 0.40) as preco_20
  from TBS031 pre with (nolock)
 inner join TBS010 pro with (nolock)
         on pro.PROCOD = pre.TDPPROCOD
 where --Left(pre.TDPPROCOD,3) = '117'
       --and 
       pre.TDPPRECOR1 > 0
       --and pro.PRODES Like '%CARTUCHO%'
       and pro.PROCOD = '18520001'

select *
  from TBS031 pre with (nolock)
 where pre.TDPPRECOR1 <> pre.TDPPRELOJ1

select *
  from TBS031 pre with (nolock)
 where pre.TDPPRECOR2 <> pre.TDPPRELOJ2



