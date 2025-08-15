select obj.name as 'tabela',col.name as 'atributo',typ.name as 'tipo',col.prec as 'precisao',col.scale as 'escala'
  from sysobjects obj (nolock) join syscolumns col (nolock) on col.id = obj.id
                               join systypes typ (nolock) on typ.xtype = col.xtype
 where obj.name Like('TBS%') or obj.name Like('MSL%') or obj.name Like('TMP%')
 order by obj.name,col.name


-- verifica se a tabela "comparativa" existe. se falso cria, senao deleta seus registros
-- usar este para criar ou deleta a tabela "comparativa" no servidor do cliente

if not exists(select name from sysobjects where name='TABCOMP' and type='U')
   begin
      create table TABCOMP(tabela varchar(128),atributo varchar(128),tipo varchar(128),precisao smallint,escala smallint)
   end
      else delete from TABCOMP


-- cria script para inserir os registros na tabela "comparativa"
-- rodar este na máquina onde existir a base de dados completa e atualizada do sistema
-- o resultado deste script deve ser "rodado" no servidor do cliente para alimenar a tabela "comparativa"

select 'insert into TABCOMP select ''' + rtrim(obj.name) + ''',''' + rtrim(col.name) + ''',''' + rtrim(typ.name) + ''',',col.prec,',',col.scale
  from sysobjects obj (nolock) join syscolumns col (nolock) on col.id = obj.id
                               join systypes typ (nolock) on typ.xtype = col.xtype
 where obj.name Like('TBS%') or obj.name Like('MSL%') or obj.name Like('TMP%')
 order by obj.name,col.name


-- lista tabelas que não existem na base de dados local
-- rodar este script no servidor do cliente
-- para a criação das tabelas que não existirem, gerar o script pelo "enterprise" ou "sql manager"

select distinct tabela from TABCOMP
 where not exists(select 'ne' from sysobjects obj (nolock)
                   where (obj.name Like('TBS%') or obj.name Like('MSL%') or obj.name Like('TMP%')) and
                         obj.name = TABCOMP.tabela)
 order by tabela


-- lista atributos que não existem na tabela local do sistema
-- se necessitar listar os atributos que não existem, rodar este script no servidor do cliente

select * from TABCOMP
 where not exists(select 'ne' from sysobjects obj (nolock) join syscolumns col (nolock) on col.id = obj.id
                                                           join systypes typ (nolock) on typ.xtype = col.xtype
                   where (obj.name Like('TBS%') or obj.name Like('MSL%') or obj.name Like('TMP%')) and
                         obj.name = TABCOMP.tabela and col.name = TABCOMP.atributo)
 order by tabela,atributo


-- cria o script para a criação dos atributos que não existirem na tabela do sistema
-- rodar este script no servidor do cliente
-- rodar o resultado deste script no servidor do cliente

select 'alter table [' + rtrim(tabela) + '] add [' + rtrim(atributo) + '] ' + rtrim(tipo) + --'(' + rtrim(precisao) +
       case tipo
          when 'datetime' then ''
          when 'smallint' then ''
          when 'money' then ''
          when 'smallmoney' then ''
          when 'int' then ''
          when 'text' then ''
          else
             '(' + rtrim(precisao) +
             case
                when escala is null then ''
                else ',' + rtrim(escala)
             end
             + ')'
       end
       + ' default ' +
       case tipo
          when 'char'       then ''''''
          when 'datetime'   then '''17530101'''
          when 'decimal'    then '0'
          when 'int'        then '0'
          when 'money'      then '0'
          when 'smallint'   then '0'
          when 'smallmoney' then '0'
          when 'varchar'    then ''''''
          when 'text'       then ''''''
       else ''
       end + ' with values'
  from TABCOMP
 where not exists(select 'ne' from sysobjects obj (nolock) join syscolumns col (nolock) on col.id = obj.id
                                                           join systypes typ (nolock) on typ.xtype = col.xtype
                   where (obj.name Like('TBS%') or obj.name Like('MSL%') or obj.name Like('TMP%')) and
                         obj.name = TABCOMP.tabela and col.name = TABCOMP.atributo)
 order by tabela,atributo


-- implementar
select TABCOMP.tabela,TABCOMP.atributo,TABCOMP.tipo,TABCOMP.precisao,TABCOMP.escala,obj.name,col.name,typ.name,col.prec,col.scale
  from TABCOMP (nolock) join sysobjects obj (nolock) on obj.name = TABCOMP.tabela
                        join syscolumns col (nolock) on col.id = obj.id and col.name = TABCOMP.atributo
                        join systypes typ (nolock) on typ.xtype = col.xtype
 where TABCOMP.tipo <> typ.name or TABCOMP.escala <> col.scale or TABCOMP.precisao <> col.prec
 order by tabela,atributo


select 'alter table [' + rtrim(tabela) + '] alter column [' + rtrim(atributo) + '] ' + rtrim(tipo) + 
       case tipo
          when 'datetime' then ''
          when 'smallint' then ''
          when 'money' then ''
          when 'smallmoney' then ''
          when 'int' then ''
          else
             '(' + rtrim(precisao) +
             case
                when escala is null then ''
                else ',' + rtrim(escala)
             end
             + ')'
       end
  from TABCOMP (nolock) join sysobjects obj (nolock) on obj.name = TABCOMP.tabela
                        join syscolumns col (nolock) on col.id = obj.id and col.name = TABCOMP.atributo
                        join systypes typ (nolock) on typ.xtype = col.xtype
 where TABCOMP.tipo <> typ.name or TABCOMP.escala <> col.scale or TABCOMP.precisao <> col.prec
 order by tabela,atributo

select * from TABCOMP where tipo = 'datetime'
select * from sysobjects
select * from systypes
select * from syscolumns
select distinct tipo from TABCOMP

sp_helpindex 'TBS043'


-- conta registros

select 'select '''+ rtrim(obj.name) +''',count(*) from ' + rtrim(obj.name) + char(13) + 'go'
  from sysobjects obj (nolock)
 where obj.name Like('TBS%') or obj.name Like('MSL%') or obj.name Like('TMP%')
 order by obj.name


-- atualização de parâmetros

select linha
   from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from parametros.txt')

-- chave

if object_id('tempdb..#CHAVE') is not null
   begin
      drop table #CHAVE
   end

select subString(linha,16,4) as 'PARCHV'
   into #CHAVE
   from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from parametros.txt')
 where subString(linha,1,4)='case'

select * from #CHAVE

-- descrição

if object_id('tempdb..#DESCRICAO') is not null
   begin
      drop table #DESCRICAO
   end

select subString(linha,14,60) as 'PARDES'
   into #DESCRICAO
   from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from parametros.txt')
 where subString(linha,1,6)='PARDES'

select * from #DESCRICAO

update #DESCRICAO set PARDES=replace(PARDES,'''','')

-- tipo

if object_id('tempdb..#TIPO') is not null
   begin
      drop table #TIPO
   end

select subString(linha,14,1) as 'PARTIP'
   into #TIPO
   from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from parametros.txt')
 where subString(linha,1,6)='PARTIP'

select * from #TIPO

update #TIPO set PARTIP=replace(PARTIP,'''','')

-- valor

if object_id('tempdb..#VALOR') is not null
   begin
      drop table #VALOR
   end

select subString(linha,14,150) as 'PARVAL'
   into #VALOR
   from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from parametros.txt')
 where subString(linha,1,6)='PARVAL'

select * from #VALOR

update #VALOR set PARVAL=replace(PARVAL,'''','')



select PARCHV,subString(linha,14,60)
  from #PARAMETROS,
       openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from parametros.txt')
            where subString(linha,1,6)='PARDES'

select * from #PARAMETROS

-- gera codigos sequencias para os fabricantes
declare @contador int
declare @registro varchar(6)

set @contador = 0
set @registro = (select top 1 PARCHV from #PARAMETROS where PARCHV=0)

while((select count(*) from TBS028 where FABCOD=0) > 0)
   begin
      update TBS028 set FABCOD=@contador +1 where FABCOD=0 and codigo=@registro
         
      set @contador = @contador +1
      set @registro = (select top 1 codigo from TBS028 where FABCOD=0 order by codigo)

      if((select count(*) from TBS028 where FABCOD=0) > 0)
         continue
      else 
         break
   end

-- lista parâmetros que não existem na tabela TBS025

select subString(linha,1,4),*
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')
 where not exists(select '' from TBS025 (nolock)
                   where TBS025.PARCHV=convert(smallint,subString(linha,1,4)))

-- insere os parâmetros faltantes

select 'insert into TBS025 (PARCHV,PARDES,PARTIP,PARVAL,PARDATCAD) select '+subString(linha,1,4)+','''+
                                                                rtrim(subString(linha,5,60))+''','''+
                                                                subString(linha,65,1)+''','''+
                                                                rtrim(subString(linha,66,150))+''','''+
                                                                convert(char(8),getdate(),112)+''''
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')
 where not exists(select '' from TBS025 (nolock)
                   where TBS025.PARCHV=convert(smallint,subString(linha,1,4)))

select * from TBS025 (nolock) where PARCHV=1075
delete TBS025 where PARCHV=1012

print convert(char(8),getdate(),112)

-- lista parâmetros com descrições diferentes na tabela TBS025

select subString(linha,1,4),subString(linha,5,60),TBS025.PARDES
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')
       join TBS025 on TBS025.PARCHV=convert(smallint,subString(linha,1,4))
 where TBS025.PARDES collate database_default<>subString(linha,5,60) collate database_default

select 'update TBS025 set PARDES='''+rtrim(subString(linha,5,60))+''''+' where PARCHV='+subString(linha,1,4)
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')
       join TBS025 on TBS025.PARCHV=convert(smallint,subString(linha,1,4))
 where TBS025.PARDES collate database_default<>subString(linha,5,60) collate database_default

select replace(linha,'*',',') from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from parametros.txt')

select * from TBS025 (nolock)




-- valores default

select 'alter table [' + rtrim(tabela) + '] add'
       + ' default ' +
       case tipo
          when 'char'       then ''''''
          when 'datetime'   then '''17530101'''
          when 'decimal'    then '0'
          when 'int'        then '0'
          when 'money'      then '0'
          when 'smallint'   then '0'
          when 'smallmoney' then '0'
          when 'varchar'    then ''''''
          when 'text'       then ''''''
       else ''
       end
	   + ' for [' + atributo + '];'
	   --+ char(13) + ' go'
  from TABCOMP
 order by tabela,atributo