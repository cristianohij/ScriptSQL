select @c=concat('select arquivo from xmlnfce into outfile /tmp/xml/',convert(UNIX_TIMESTAMP(NOW()),char(50)));

execute('select ''select arquivo from xmlnfce into outfile /tmp/xml/+convert(UNIX_TIMESTAMP(NOW()),char(50))''
           from xmlnfce
          limit 50') at MYSQLGZ

execute('select concat(''select arquivo from xmlnfce into outfile'', '' /tmp/xml/'', convert(id,char(9)))
           from xmlnfce
          limit 50') at MYSQLGZ

execute('select concat(''select arquivo from xmlnfce into outfile'', '' /tmp/xml/'', convert(concat(convert(id,char(9)),convert(caixa,char(1))),char(9)))
           from xmlnfce
          limit 50') at MYSQLGZ

-- funciona
execute('select concat(''select arquivo from xmlnfce into outfile '', ''/temp/gz/bb/'', concat(convert(caixa,char(2)),convert(id,char(9))),''.xml'')
           from xmlnfce
          limit 50') at MYSQLGZ

execute('select concat(''select arquivo from xmlnfce into outfile '', ''/temp/gz/bb/'', concat(convert(caixa,char(2)),convert(id,char(9))), ''.xml;'')
           from xmlnfce') at MYSQLGZ

execute('select convert(UNIX_TIMESTAMP(NOW()),char(50))') at MYSQLGZ

execute('select concat(''select arquivo from xmlnfce into outfile'', '' /tmp/xml/'', convert(concat(convert(id,char(9)),convert(caixa,char(1))),char(9)))
           from xmlnfce
          limit 50') at MYSQLGZ


execute('set @n = (select min(id) from xmlnfce)') at MYSQLGZ;


select * from MYSQLGZ..xmlnfce

create table ##gz (id bigint)

--insert into ##gz execute('select id from xmlnfce') at MYSQLGZBBPDV1

drop table ##gz

select id
       ,nota
       ,row_number() over(order by id) seq
       into ##gz
  from openquery(MYSQLGZNDPDV1,'select id,nota from xmlnfce where data between ''20220501'' and ''20220531''')

select count(*) from ##gz

select * from ##gz

set nocount on

declare @n int, @f int, @comando varchar(1000), @id int, @nota int
set @n = 1

select @f = max(seq) from ##gz

while @n <= @f
  begin
     select @id = id, @nota = nota from ##gz where seq = @n

     set @comando = 'select arquivo from xmlnfce where data between ''20220501'' and ''20220531'' and id = ' + Ltrim(str(@id,9)) + ' into outfile ''/tmp/xml/' + Ltrim(str(@nota)) + '-' + Ltrim(str(@id,9)) + '.xml'';'
     select @comando

     set @n += 1
  end


drop table #dir

create table #dir(arquivo varchar(300))

declare @diretorio as varchar(200)

set @diretorio='dir D:\Documents\GRM\xml\sat\best-arts\2021\03-mar\pdv-2_ /s /o:n /b'

insert into #dir exec master..xp_cmdshell @diretorio

delete #dir where arquivo is null or arquivo='can'

drop table #arquivo

select arquivo,row_number() over(order by arquivo) as linha into #arquivo from #dir

drop table #cupons
go

create table #cupons(valor numeric(10,2), doc varchar(25), extrato varchar(9), data date)
go

declare @n int, @linhas int, @arquivo varchar(300), @query varchar(500)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas
   begin
      select @arquivo = arquivo
        from #arquivo
       where linha=@n


      --print @arquivo

      set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''), X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''), X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)''), X.ide.query(''ide/dEmi'').value(''.'', ''date'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFe/infCFe'') AS X(ide)'
      --set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'

      exec(@query)
--print @query

      set @n += 1
   end
go

select *
  from ##gz a
  Left join #cupons b
  on a.nota=subString(b.doc,15,5)
 where b.valor is null

select * from #cupons

select *
  into cuponsbbgz
       --id
       --,nota
       --,row_number() over(order by id) seq
       --into ##gz
  from openquery(MYSQLGZBBSERVER,'select * from movcaixa where data between ''20211001'' and ''20211031'' and status=''03''')


-- nova implementação

declare @datade char(8), @dataate char(8)

select @datade='20220501', @dataate='20220531'

select id
       ,nota
       ,row_number() over(order by id) seq
       into ##gz
  from openquery(MYSQLGZTTPDV5,'select id,nota from xmlnfce where data between ''' || @datade + ''' and ''20220531''')


declare @openQuery varchar(8000), @select varchar(8000), @datade char(8), @dataate char(8)

select @datade='20220501', @dataate='20220531'

--select @tSQL = 'SELECT * FROM OPENQUERY(MyLinkedServer,''SELECT * FROM pubs.dbo.authors WHERE state = ''''' + @VAR + ''''''')'

set @select = 'select arquivo from xmlnfce where data between ''' + @datade +''' and ''' + @dataate + ''' and id = Ltrim(str(id,9)) into outfile ''/tmp/xml/Ltrim(str(nota)) - Ltrim(str(@id,9)) + .xml'';'
--select @openQuery = 'select id,nota,row_number() over(order by id) seq from openquery(MYSQLGZTTPDV5,''select id,nota from xmlnfce where data between ''''' + @datade + ''''' and ''''' + @dataate + ''''''')'
select @openQuery = 'select ' + @select + ' from openquery(MYSQLGZTTPDV5,''select id,nota from xmlnfce where data between ''''' + @datade + ''''' and ''''' + @dataate + ''''''')'

print @openQuery

exec (@tSQL)



select id
       ,nota
       ,row_number() over(order by id) seq
       into ##gz
  from openquery(MYSQLGZNDPDV1,'select id,nota from xmlnfce where data between ''20220501'' and ''20220531''')

-- cria tabela de cupons

declare @openQuery varchar(8000), @select varchar(8000), @data_de char(8), @data_ate char(8), @empresa char(2), @pdv int

select @data_de='20220501', @data_ate='20220531', @empresa='ND', @pdv=1

if object_id('TempDB.dbo.##gz') is not null
begin
	drop table ##gz
end

-- 'select arquivo from xmlnfce where data between ''20220501'' and ''20220531'' and id = ' + Ltrim(str(@id,9)) + ' into outfile ''/tmp/xml/' + Ltrim(str(@nota)) + '-' + Ltrim(str(@id,9)) + '.xml'';'
--set @openQuery = 'select id,nota,row_number() over(order by id) seq,' + '''select arquivo from xmlnfce where data between ''''' + @data_de + ''''' and ''''' + @data_ate + ''''' and id='+Ltrim(str(id,9))+'  into outfile ''''/tmp/xml/.xml;'''''' as str_query' + ' into ##gz from openquery(' + (select odbc from ##pdv where empresa=@empresa and pdv=@pdv) + ',''select id,nota from xmlnfce where data between ''''' + @data_de + ''''' and ''''' + @data_ate + ''''''')'
set @openQuery = 'select convert(date,data) as data,id,nota,row_number() over(order by id) as seq,replicate('' '',500) as str_query into ##gz from openquery(' + (select odbc from ##pdv where empresa=@empresa and pdv=@pdv) + ',''select id,nota,data from xmlnfce where data between ''''' + @data_de + ''''' and ''''' + @data_ate + ''''''')'

print @openQuery

exec (@openQuery)

update ##gz
   set str_query='select arquivo from xmlnfce where data=''''' + convert(char(8),data,112) + ''''' and id=' + Ltrim(str(id,9)) + ' into outfile ' + '''''/home/xml_sat/' + Ltrim(str(nota)) + '-' + Ltrim(str(id,9)) + '.xml'''';'
    
--select *
  --from ##gz

declare @comando varchar(500), @n smallint, @linhas smallint

select @n=1, @linhas=(select max(seq) from ##gz)

while @n <= @linhas
   begin
      set @comando='select * from openquery(' + (select odbc from ##pdv where empresa=@empresa and pdv=@pdv) + ',''' + (select str_query from ##gz where seq=@n) + ''')'

	  --print @comando

      if @n = 1
	     begin
		    print @comando
	        execute (@comando)
		 end
      --exec(@query)

      set @n += 1
   end
go


select replicate(' ',500)





-- preencha as variáveis

declare @data_de char(8), @data_ate char(8), @msg varchar(1000), @hit datetime, @hft datetime 

select  @data_de  = '20220501'
       ,@data_ate = '20220531'

-- cria lista de conexões dos PDVs

--set nocount on

set @hit = getdate()

set nocount off
set @msg = 'Inicio do processo: ' + convert(NVARCHAR, @hit, 8)
raiserror (@msg, 0, 1) with nowait

set @msg = 'Criando tabela de PDV: ' + convert(NVARCHAR, getdate(), 8)
raiserror (@msg, 0, 1) with nowait

set nocount on

if object_id('tempdb.dbo.##pdv') is not null
	drop table ##pdv

create table ##pdv (empresa char(2), pdv int, odbc varchar(200), ativo smallint)

declare @empresa char(2)

set @empresa=case
                when (select EMPCGC from TBS023 with (nolock)) = '65069593000198' then 'ND'
                when (select EMPCGC from TBS023 with (nolock)) = '65069593000279' then 'TT'
                when Left((select EMPCGC from TBS023 with (nolock)),8) = '05118717' then 'BB'
             end

if @empresa='ND'
   -- tanby matriz
   insert into ##pdv (empresa,pdv,odbc,ativo)
   values (@empresa,1,'MYSQLGZNDPDV1',1),
          (@empresa,2,'MYSQLGZNDPDV2',0),
	      (@empresa,3,'MYSQLGZNDPDV3',0),
	      (@empresa,4,'MYSQLGZNDPDV4',1),
	      (@empresa,5,'MYSQLGZNDPDV5',0),
	      (@empresa,6,'MYSQLGZNDPDV6',0)

if @empresa='TT'
   -- tanby taubaté
   insert into ##pdv (empresa,pdv,odbc,ativo)
   values (@empresa,1,'MYSQLGZTTPDV1',1),
          (@empresa,2,'MYSQLGZTTPDV2',1),
	      (@empresa,3,'MYSQLGZTTPDV3',1),
	      (@empresa,4,'MYSQLGZTTPDV4',1),
	      (@empresa,5,'MYSQLGZTTPDV5',1),
	      (@empresa,6,'MYSQLGZTTPDV6',1)

if @empresa='BB'
   -- best bag
   insert into ##pdv (empresa,pdv,odbc,ativo)
   values (@empresa,1,'MYSQLGZBBPDV1',1),
          (@empresa,2,'MYSQLGZBBPDV2',1),
	      (@empresa,3,'MYSQLGZBBPDV3',1),
	      (@empresa,4,'MYSQLGZBBPDV4',1),
	      (@empresa,5,'MYSQLGZBBPDV5',1),
	      (@empresa,6,'MYSQLGZBBPDV6',1)

--set nocount off

--select *
--  from ##pdv

-- se tabela de PDVs estiver preenchida

if (select top(1) 1 from ##pdv where ativo=1) = 1
   begin
      -- cria tabela de cupons

	  set nocount off
	  set @msg = 'Criando tabela de Cupons: ' + convert(NVARCHAR, getdate(), 8)
	  raiserror (@msg, 0, 1) with nowait

      set nocount on

	  declare @comando varchar(8000), @pdv smallint, @i smallint, @n smallint, @pdv_atual smallint

	  select @i = 1, @n = (select count(*) from ##pdv), @pdv = 0, @pdv_atual = 0

      if object_id('tempdb.dbo.##cupons') is not null
         drop table ##cupons

	  create table ##cupons (pdv int, data date, id int, nota int, seq int identity(1,1), str_query varchar(500))

	  set nocount off
	  set @msg = 'Inserindo dados dos Cupons: ' + convert(NVARCHAR, getdate(), 8)
	  raiserror (@msg, 0, 1) with nowait

	  set nocount on

	  -- loop do primeiro ao último pdv
	  while @i <= @n
	     begin

            if (select 1 from ##pdv where pdv=@i and ativo=1) = 1
			   begin
				  set @pdv = @i

			   	  if @pdv_atual <> @pdv
				     begin
					    --if @pdv > 0
						   --begin
					          set nocount off
				              set @msg = 'PDV: ' + Ltrim(str(@pdv))
		                      raiserror (@msg, 0, 1) with nowait
						   --end
					    set @pdv_atual = @pdv
					 end

	              set nocount on

				  set @comando = 'select ' + Ltrim(str(@pdv)) + ',convert(date,data) as data,id,nota from openquery(' + (select odbc from ##pdv where empresa=@empresa and pdv=@pdv) + ',''select id,nota,data from xmlnfce where data between ''''' + @data_de + ''''' and ''''' + @data_ate + ''''''')'

				  --set @seq = @seq + 1

			      -- into ##gz 

                  --print @comando

			      insert into ##cupons (pdv,data,id,nota)
                  execute (@comando)

                  --select *
                    --from ##cupons

			   end
			      
			set @i = @i + 1
         end

      -- armazena query a ser rodada no mysql
	  
	  set nocount off
	  set @msg = 'Gerando query para rodar no MySQL: ' + convert(NVARCHAR, getdate(), 8)
	  raiserror (@msg, 0, 1) with nowait

	  set nocount on

	  update ##cupons
         set str_query='select arquivo from xmlnfce where data=''''' + convert(char(8),data,112) + ''''' and id=' + Ltrim(str(id,9)) + ' into outfile ' + '''''/home/xml_sat/' + Ltrim(str(nota)) + '-' + Ltrim(str(id)) + '-' + Ltrim(str(pdv)) + '.xml'''';'

      -- roda query armazenada no mysql do pdv

	  set nocount off
	  set @msg = 'Gravando arquivo XML na pasta "/home/xml_sat": ' + convert(NVARCHAR, getdate(), 8)
	  raiserror (@msg, 0, 1) with nowait

	  set nocount on

	  select @i = 1, @n = (select max(seq) from ##cupons), @pdv = 0, @pdv_atual = 0

	  --declare @contador smallint
	  --set @contador = 0

      -- loop do primeiro ao último cupom
	  while @i <= @n
         begin
		    --if @pdv <> @i
			   --begin
			      --if @pdv > 0
				     --begin
			            --set nocount off
						--set @msg = 'PDV: ' + Ltrim(str(@pdv))
		                --raiserror (@msg, 0, 1) with nowait
					 --end
			   --end

		    set nocount on

			set @pdv = (select pdv from ##cupons where seq=@i)

			   	  if @pdv_atual <> @pdv
				     begin
					    --if @pdv > 0
						   --begin
					          set nocount off
				              set @msg = 'PDV: ' + Ltrim(str(@pdv)) + convert(NVARCHAR, getdate(), 8)
		                      raiserror (@msg, 0, 1) with nowait
						   --end
					    set @pdv_atual = @pdv
					 end

	              set nocount on

            set @comando='select 1 from openquery(' + (select odbc from ##pdv where pdv=@pdv) + ',''' + (select str_query from ##cupons where seq=@i) + ''')'

	  --print @comando

            --if @i <= 10
	           --begin
		          --print @comando

				  begin try
	                 execute (@comando)
				  end try
				  begin catch
                  end catch
		       --end

			   --if @i >= 10
			      --break

      --exec(@query)

            set @i += 1
         end
      --go
   end

set @hft = getdate()

set nocount off
set @msg = 'Fim do processo: ' + convert(NVARCHAR, @hft, 8)
raiserror (@msg, 0, 1) with nowait

set @msg = 'Tempo total decorrido: ' + convert(NVARCHAR, @hft - @hit, 8)
raiserror (@msg, 0, 1) with nowait

select pdv,count(*) as arquivos from ##cupons group by pdv having count(*) > 0



select *
  from ##cupons

select *
  from ##pdv

begin try
   select 1 from openquery(MYSQLGZNDPDV1,'select arquivo from xmlnfce where data=''20220506'' and id=14374 into outfile ''/home/xml_sat/196798-14374-1.xml'';')
end try
begin catch
   THROW;
end catch

select null + 1

declare @hi datetime, @hf datetime

set @hi = getdate()

select @hi

WAITFOR DELAY '00:00:10';

set @hf = getdate()

select @hf

select convert(NVARCHAR, @hf - @hi, 8)