select * from TBS126 (nolock)

exec sp_rename 'TBS126.[CTFALICOFINS]', 'CTCALICOFINS'

 
 

exec sp_rename '[TBS126].CTFALIPIS', 'CTCALIPIS'

 
 

exec sp_rename '[TBS126].CTFALIICMS', 'CTCALIICMS'

 
 

exec sp_rename '[TBS126].CTFCFOPEXT', 'CTCCFOPEXT'

 
 

exec sp_rename '[TBS126].CTFCFOPINT', 'CTCCFOPINT'

 
