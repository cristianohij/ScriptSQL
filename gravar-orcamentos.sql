select *
  from TBS0431 with (nolock)
 where ORCNUM=684619
 
insert into TBS0431
(
  ORCNUM
  ,ORCITEM
  ,PROCOD
  ,ORCDES
  ,ORCQTD
  ,ORCQTDEMB
  ,ORCPRE -- isnull((select TDPPRECOR1 from TBS031 with (nolock) where TBS031.TDPPROCOD=TBS0431.PROCOD),0)
  ,LESCOD
  ,ORCTESCOM -- 'N'
  ,ORCTESDPL -- 'N'
  ,ORCTABPRE
  ,ORCCST
  ,ORCEFS -- 'N'
  ,ORCCFOP
  ,ORCBLQPRE -- 'N'
  ,ORCPROPESAVEL
  ,ORCROPREG
  ,ORCPROGERPEN -- 'N'
)
select 