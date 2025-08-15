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
sp_helpindex 'MSL002'
sp_pkeys 'MSL002'

SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE where TABLE_NAME = 'TBS067'

-- remove indices primários
ALTER TABLE MSL001
DROP CONSTRAINT PK__MSL001__07F6335A
GO

select 'alter table [dbo].[' + (select rtrim(name) from sysobjects b where b.id = a.parent_obj) + '] drop constraint [' + name +']'
         from sysobjects a
 where a.name Like('DF_%') and a.type = 'D' order by name

select 'alter table [dbo].['+obj.name+'] drop constraint [DF_'+obj.name+'_'+col.name+']',obj.
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
where obj.name Like('TBS%') and col.cdefault > 0 order by obj.name,col.name

-- remove indices simples
DROP INDEX MSL001.IMSL0016


select * from sysindexes
select * from sysindexkeys
select * from sysindexkeys

select obj.id,obj.name,ind.name,ind.status,ind.used from sysobjects obj join sysindexes ind on obj.id = ind.id
 where (obj.name Like('MSL%') or obj.name Like('TBS%') or obj.name Like('TMP%')) and
       (ind.name Like('PK__MSL%') or ind.name Like('PK__TBS%') or ind.name Like('PK__TMP%') or ind.name Like('IMSL%') or ind.name Like('ITBS%') or
        ind.name Like('ITMP%'))
 order by obj.name ,ind.name desc

ALTER TABLE [dbo].[TBS0101] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[PROEMPCOD],
		[PROCOD],
		[PROFOREMP],
		[PROFORCOD]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [ITBS01015] ON [dbo].[TBS0101]([PROFOREMP], [PROFORCOD]) ON [PRIMARY]
GO


declare @tabela char(8),@cons char(7),@indice char(4)
set @tabela = 'TBS067'
--set @tabela = 'TBS0671'
--set @tabela = 'TBS0672'
--set @tabela = 'TBS0673'
--set @tabela = 'TBS069'
--set @tabela = 'TBS073'
--set @tabela = 'TBS080'
--set @tabela = 'TBS0801'

set @cons = 'PK__'+subString(@tabela,1,3)	-- constraint da chave primária
set @indice = 'I'+subString(@tabela,1,3)	-- indices da tabela

-- elimina a chave primária da tabela especificada
select 'alter table '+rtrim(@tabela)+' drop constraint '+rtrim(ind.name) from sysobjects obj join sysindexes ind on obj.id = ind.id
 where obj.name = @tabela and ind.name Like(@cons+'%')

-- elimina indices da tabela especificada
select 'drop index '+rtrim(@tabela)+'.'+ind.name from sysobjects obj join sysindexes ind on obj.id = ind.id
 where obj.name = @tabela and ind.name Like(@indice+'%')


-- update série

-- tanby nd
update TBS067 set SNESER = 1 where NFSDATEMI >= '20130701'
go

update TBS0671 set TBS0671.SNESER = 1 from TBS067 join TBS0671 on TBS0671.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0671.NFSNUM = TBS067.NFSNUM
 where TBS067.NFSDATEMI >= '20130701'
go

update TBS0672 set TBS0672.SNESER = 1 from TBS067 join TBS0672 on TBS0672.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0672.NFSNUM = TBS067.NFSNUM
 where TBS067.NFSDATEMI >= '20130701'
go

update TBS0673 set TBS0673.SNESER = 1 from TBS067 join TBS0673 on TBS0673.NFSEMPCOD = TBS067.NFSEMPCOD and TBS0673.NFSNUM = TBS067.NFSNUM
 where TBS067.NFSDATEMI >= '20130701'
go

update TBS069 set PDFSER = 1 where PDFNFSDAT >= '20130701'
go

update TBS073 set SNESER = 1 where CACDATEMI >= '20130701'
go

update TBS080 set SNESER = 1 where ENFDATEMI >= '20130701'
go

update TBS0801 set SNESER = 1 from TBS080 join TBS0801 on TBS0801.ENFEMPCOD = TBS080.ENFEMPCOD and TBS0801.ENFNUM = TBS080.ENFNUM
 where TBS080.ENFDATEMI >= '20130701'
go


-- ultima nf emitida tanby nd: 103915

-- ultima nf emitida misaspel: 49236


-- elimina todos os indices (exceto chave primária)

select 'drop index ' + obj.name + '.' + ind.name + char(13) + 'go' from sysobjects obj join sysindexes ind on obj.id = ind.id
 where ind.name Like('IMSL%') or ind.name Like('ITBS%') or ind.name Like('ITMP%')
 order by obj.name

-- para recriar os indices utilizar o enterprise para gerar os scritps