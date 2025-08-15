--use SIBD

select id,* from sysobjects where name Like('TBS%') order by name

select id,* from syscolumns where id=498816839

-- cria tabela para contendo os nomes das tabelas e quantidade
   if exists(select name from sysobjects where name='TEMP_NULL' and type='U')
      drop table TEMP_NULL
   else
      create table TEMP_NULL(IDENT int, TABELA sysname ,NULOS int)

-- insere os dados na tabela criada
   insert into TEMP_NULL (IDENT ,TABELA) select id ,name from sysobjects where name Like('TBS%') order by name

-- insere os registros contados na tabela criada
   declare _cursor scroll cursor for select id,name from sysobjects where name Like('TBS%') order by name
   open _cursor

   declare @id int,@name sysname,@conta int

   fetch next from _cursor into @id ,@name

   while @@fetch_status=0 begin
      -- conta registros
--         set @comando='update CONTAREG set QREGIS=(select isnull(count(*),0) from '+@tabela+') where NOME='''+@tabela+''''
--         execute(@comando)

--      set @conta = (select count(*) from )

      print @name

      fetch next from _cursor into @id ,@name
   end

   close _cursor
   deallocate _cursor


-- cria tabela para contendo os nomes das tabelas e quantidade
   if exists(select name from sysobjects where name='TEMP_NULL' and type='U')
      drop table TEMP_NULL
   else
      create table TEMP_NULL(IDENT int ,TABELA sysname ,ATRIBUTO char(20) ,NULOS int)

-- insere os dados na tabela criada
   insert into TEMP_NULL (IDENT ,TABELA) select id ,name from sysobjects where name Like('TBS%') order by name

-- insere os registros contados na tabela criada
   declare _cursor scroll cursor for select id,name from sysobjects where name Like('TBS%') order by name
   open _cursor

   declare @id int ,@name sysname ,@conta int ,@comando varchar(500)

   fetch next from _cursor into @id ,@name

   while @@fetch_status=0 begin
      set @comando = 'update TEMP_NULL set ATRIBUTO = '
      -- conta registros
--         set @comando='update CONTAREG set QREGIS=(select isnull(count(*),0) from '+@tabela+') where NOME='''+@tabela+''''
--         execute(@comando)

--      set @conta = (select count(*) from )

      print @name

      fetch next from _cursor into @id ,@name
   end

   close _cursor
   deallocate _cursor


select obj.id,obj.name,col.id,col.name,typ.name
  from sysobjects obj join syscolumns col on col.id = obj.id
                      join systypes typ on typ.xtype = col.xtype
 where obj.name Like('TBS%') order by obj.name


select id,name,xtype from syscolumns where id = 1977058079

select * from systypes where xtype = 122
