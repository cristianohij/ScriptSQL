select obj.name as 'tabela',col.name as 'atributo',typ.name as 'tipo',col.length as 'tamanho'
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
where obj.name Like('TBS%') order by obj.name

--select * from syscolumns
select * from sysindexes


-- lista indices
select obj.name,ind.name,ind.status
  from sysobjects obj inner join sysindexes ind on ind.id = obj.id
where obj.name Like('TBS%') and ind.status=2097152 order by obj.name




ALTER TABLE [dbo].[TBS071] WITH NOCHECK ADD 
	CONSTRAINT [DF_TBS071_IMPEMPCOD] DEFAULT (0) FOR [IMPEMPCOD],
	CONSTRAINT [DF_TBS071_IMPNOM] DEFAULT ('') FOR [IMPNOM],
	CONSTRAINT [DF_TBS071_IMPTIP] DEFAULT ('') FOR [IMPTIP],
	CONSTRAINT [DF_TBS071_IMPDES] DEFAULT ('') FOR [IMPDES],
	CONSTRAINT [DF_TBS071_IMPDATCAD] DEFAULT ('17530101') FOR [IMPDATCAD]

alter table [dbo.].[TBS012] with nocheck add constraint [DF_TBS012_GRUCOD] default ('0') for [GRUCOD]

alter table #tbl add constraint data default getdate() for data
alter table [dbo.].[TBS012] with nocheck add constraint [DF_TBS012_GRUCOD] default '0'

select distinct typ.name as 'tipo'
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
where obj.name Like('TBS%') order by typ.name

select * from systypes

-- remove valores default
--select 'alter table [dbo].['+obj.name+'] drop constraint [DF_'+obj.name+'_'+col.name+']',obj.
--  from sysobjects obj join syscolumns col on col.id = obj.id
--                      join systypes typ on typ.xtype = col.xtype
--where obj.name Like('TBS%') and col.cdefault > 0 order by obj.name,col.name

select 'alter table [dbo].[' + (select rtrim(name) from sysobjects b where b.id = a.parent_obj) + '] drop constraint [' + name +']'
         from sysobjects a
 where a.name Like('DF_%') and a.type = 'D' order by name

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
where obj.name Like('TBS110%') and col.cdefault = 0 order by obj.name,col.name

drop default DF_TBS012_GRUCOD

EXEC sp_unbindefault 'TBS012.GRUCOD'
DROP DEFAULT DF_TBS012_GRUCOD

alter domain cpf drop default;

alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUCOD]

alter table [dbo].[TBS012] with nocheck add constraint [DF_TBS012_GRUCOD] default ('0') for [GRUCOD]
alter table [dbo].[TBS012] with nocheck add constraint [DF_TBS012_GRUDATCAD] default ('17530101') for [GRUDATCAD]
alter table [dbo].[TBS012] with nocheck add constraint [DF_TBS012_GRUDES] default ('') for [GRUDES]
alter table [dbo].[TBS012] with nocheck add constraint [DF_TBS012_GRUEMPCOD] default ('0') for [GRUEMPCOD]


-- permite update da tabela de sistema
sp_configure 'allow',1
reconfigure with override

update syscolumns set cdefault=0 from syscolumns col
 where cdefault > 0 and exists(select 'ex' from sysobjects obj where obj.id=col.id and obj.name Like('TBS012'))

-- tira a permissao da tabela de sistema
sp_configure 'allow',0
reconfigure with override


select cdefault,* from syscolumns col
where exists(select 'ex' from sysobjects obj where obj.id=col.id and obj.name Like('TBS%'))

select * from sysobjects where id in(437576597,501576825)

alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUCOD]
alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUDATCAD]
alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUDES]
alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUEMPCOD]

alter table [dbo].[TBS012] with nocheck add constraint [DF_TBS012_GRUCOD] default ('0') for [GRUCOD]
alter table [dbo].[TBS012] with nocheck add constraint [DF_TBS012_GRUDATCAD] default ('17530101') for [GRUDATCAD]
alter table [dbo].[TBS012] with nocheck add constraint [DF_TBS012_GRUDES] default ('') for [GRUDES]
alter table [dbo].[TBS012] with nocheck add constraint [DF_TBS012_GRUEMPCOD] default ('0') for [GRUEMPCOD]

alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUCOD]
alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUDATCAD]
alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUDES]
alter table [dbo].[TBS012] drop constraint [DF_TBS012_GRUEMPCOD]