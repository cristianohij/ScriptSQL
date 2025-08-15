select obj.name as 'tabela',col.name as 'atributo',typ.name as 'tipo',col.length as 'tamanho',col.xprec,col.xscale,col.prec,col.scale
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
where obj.name Like('TBS058') and col.name = 'PRPPRE' order by obj.name

-- corrige escala e precisao dos atributos do tipo decimal
select 'alter table [' + obj.name + '] alter column ' + col.name + ' decimal(' + Ltrim(str(col.prec,6)) + ',' + Ltrim(str(col.scale,11)) + ')'
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
where obj.name Like('TBS%') and typ.name = 'decimal' order by obj.name,col.name




--select * from syscolumns
select * from sysindexes

select * from syscolumns


-- lista indices
select obj.name,ind.name,ind.status
  from sysobjects obj inner join sysindexes ind on ind.id = obj.id
where obj.name Like('TBS%') and ind.status=2097152 order by obj.name

-- lista atributos de uma tabela
select col.name as 'atributo',typ.name as 'tipo',col.length as 'tamanho'
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
where obj.name = 'TBS002' order by obj.name

insert into TBS0242
select 'TBS010',col.name,'',col.length,'' from sysobjects obj join syscolumns col on col.id = obj.id join systypes typ on typ.xtype = col.xtype
 where obj.name = 'TBS010' order by obj.name

select * from TBS0242 (nolock)

begin tran
delete TBS0242
commit tran