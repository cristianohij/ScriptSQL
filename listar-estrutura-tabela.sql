select obj.name,col.name,typ.name,col.prec,col.scale
  from syscolumns col (nolock)
       join sysobjects obj (nolock) on obj.id = col.id
       join systypes typ (nolock) on typ.xtype = col.xtype
 where obj.name='SPED_ES'
 order by col.colorder