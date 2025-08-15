select top 50 * from TBS010

update TBS010 set TBS010.FORNOM=TBS006.FORNOM from TBS010 join TBS006 on TBS010.FORCOD=TBS006.FORCOD
 where TBS010.FORCOD > 0

update TBS010 set TBS010.MARNOM=TBS014.MARNOM from TBS010 join TBS014 on TBS010.MARCOD=TBS014.MARCOD
 where TBS010.MARCOD > 0

select * from TBS0551 (noLock) where PDVCST='060'

update TBS0551 set TESCOD=503 where TESCOD=500

update TBS0551 set PDVCFOP='5.102' where TESCOD=503

update TBS0551 set PDVTESDPL='S' where PDVTESDPL='N'

   select PROCOD,cod_interno,PROSTBA,PROSTBB,sit_tributaria from TBS010 join AL0601 on PROCOD=cod_interno
    where sit_tributaria Like('AF%')

   update TBS010 set PROSTBB=60 from TBS010 join AL0601 on PROCOD=cod_interno where sit_tributaria Like('AF%')

   select PROCOD,cod_interno,PROSTBA,PROSTBB,sit_tributaria from TBS010 join AL0601 on PROCOD=cod_interno
    where sit_tributaria='010'

   update TBS010 set PROSTBB=60 from TBS010 join AL0601 on PROCOD=cod_interno where sit_tributaria='010'

   select 

   update TBS0551 set PDVCST='0'+PROSTBB from TBS0551 (noLock) join TBS010 (noLock) on TBS0551.PROCOD=TBS010.PROCOD
