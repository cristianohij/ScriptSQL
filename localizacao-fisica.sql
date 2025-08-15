select *
  from
(
select Left(PROLOCFIS,2) rua
       ,subString(PROLOCFIS,3,1) predio
       ,subString(PROLOCFIS,4,2) andar
       ,right(rtrim(PROLOCFIS),1) apartamento
       --,count(PROLOCFIS) conta
  from TBS010 with (nolock)
 where PROLOCFIS<>''
 group by Left(PROLOCFIS,2)
          ,subString(PROLOCFIS,3,1)
          ,subString(PROLOCFIS,4,2)
          ,right(rtrim(PROLOCFIS),1)
-- order by Left(PROLOCFIS,2)
--          ,subString(PROLOCFIS,3,1)
--          ,subString(PROLOCFIS,4,2)
--          ,right(rtrim(PROLOCFIS),1)
) em_linha
pivot (count(apartamento) for apartamento in ([A], [B], [C], [D] ,[E], [F], [G], [H], [I], [J], [K], [L], [M], [N], [O], [P], [Q], [R], [S], [T], [U], [V], [w], [X], [Y], [Z])) em_colunas
order by rua

select PROCOD,PRODES,PROLOCFIS from TBS010 with (nolock) where PROLOCFIS='01A01A'

select PROCOD,PRODES,PROLOCFIS from TBS010 with (nolock) where PROLOCFIS Like('%34%')

-- checagem

select PROCOD
       ,PRODES
       ,PROLOCFIS
  from TBS010 with (nolock)
 where Left(PROLOCFIS,5)='RUA'
 order by PROLOCFIS

select PROCOD
       ,PRODES
       ,PROLOCFIS
  from TBS010 with (nolock)
 where PROLOCFIS Like('01%')
 order by PROLOCFIS

select PROCOD
       ,PRODES
       ,PROLOCFIS
  from TBS010 with (nolock)
 where PROLOCFIS<>''
       and isnumeric(Left(PROLOCFIS,2))=0
 order by PROLOCFIS

select PROLOCFIS
       ,count(*)
  from TBS010 with (nolock)
 group by PROLOCFIS
having count(*) > 1

select PROLOCFIS
       ,PROCOD
       ,PRODES
  from TBS010 with (nolock)
 where PROLOCFIS='36B01A'
