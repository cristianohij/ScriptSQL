select 'insert into '+rtrim(obj.name)+' select * from SIBD.dbo.' + rtrim(obj.name)+char(13)+'go'
  from sysobjects obj (nolock)
 where obj.name Like('TBS%') or obj.name Like('MSL%') or obj.name Like('TMP%')
 order by obj.name

