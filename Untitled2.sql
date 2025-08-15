CREATE CLUSTERED INDEX au_id_ind
   ON authors2 (au_id,au_fname)
   WITH DROP_EXISTING

ALTER TABLE [dbo].[TBS067] WITH NOCHECK ADD 
	CONSTRAINT [PK__TBS067__2FCF1A8A] PRIMARY KEY  CLUSTERED 
	(
		[NFSEMPCOD],
		[NFSNUM]
	)  ON [PRIMARY] 
GO

CREATE CLUSTERED INDEX ITBS0674
   ON TBS067 (NFSEMPCOD,NFSNUM)
   WITH DROP_EXISTING

-- funciona
sp_helpindex 'TBS067'

-- funciona
ALTER TABLE TBS067
DROP CONSTRAINT ITBS0674
GO

select 'alter table [dbo].[' + (select rtrim(name) from sysobjects b where b.id = a.parent_obj) + '] drop constraint [' + name +']'
         from sysobjects a
 where a.name Like('DF_%') and a.type = 'D' order by name

select 'alter table [dbo].['+obj.name+'] drop constraint [DF_'+obj.name+'_'+col.name+']',obj.
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
where obj.name Like('TBS%') and col.cdefault > 0 order by obj.name,col.name

-- funciona
DROP INDEX TBS067.ITBS06741


select * from sysindexes
select * from sysindexkeys

select obj.name,ind.name,ind.status,ind.used from sysobjects obj join sysindexes ind on obj.id = ind.id
 where (obj.name Like('MSL%') or obj.name Like('TBS%') or obj.name Like('TMP%')) and
       (ind.name Like('PK__MSL%') or ind.name Like('PK__TBS%') or ind.name Like('PK__TMP%') or ind.name Like('IMSL%') or ind.name Like('ITBS%') or
        ind.name Like('ITMP%'))
 order by obj.name ,ind.name desc