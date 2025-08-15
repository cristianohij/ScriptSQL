-- atribui valores default
select 'alter table [dbo].['+obj.name+'] with nocheck add constraint [DF_'+obj.name+'_'+col.name+'] default '+'('+
       case typ.name
          when 'char'       then ''''''
          when 'datetime'   then '''17530101'''
          when 'decimal'    then '0'
          when 'int'        then '0'
          when 'money'      then '0'
          when 'smallint'   then '0'
          when 'smallmoney' then '0'
          when 'varchar'    then ''''''
      end+') for '+'['+col.name+']'
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
where obj.name Like('TBS%') and col.cdefault = 0 order by obj.name,col.name