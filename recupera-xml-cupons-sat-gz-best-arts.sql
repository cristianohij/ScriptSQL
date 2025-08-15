/*
   data da criação: jul/2022
   autor: cristiano
   função:
      - extrair os arquivos XML SAT do banco de dados do PDV
	  - gravar na pasta /home/xml_sat (deve ser criada no PDV)
   obs:
      eliminar manualmente os arquivos XML do PDV após o seu uso para evitar o acumulo de arquivos
*/

-- preencha as variáveis

declare @data_de char(8), @data_ate char(8), @msg varchar(1000), @hit datetime, @hft datetime 

select  @data_de  = '20250701'
       ,@data_ate = '20250731'

-- cria lista de conexões dos PDVs

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

set @empresa='BA'

insert into ##pdv (empresa,pdv,odbc,ativo)
values (@empresa,1,'MYSQLGZBAPDV1',1),
       (@empresa,2,'MYSQLGZBAPDV2',1)

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

			      insert into ##cupons (pdv,data,id,nota)
                  execute (@comando)
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

      -- loop do primeiro ao último cupom
	  while @i <= @n
         begin
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

            begin try
	           execute (@comando)
			end try
			begin catch
            end catch

            set @i += 1
         end
   end

set @hft = getdate()

set nocount off
set @msg = 'Fim do processo: ' + convert(NVARCHAR, @hft, 8)
raiserror (@msg, 0, 1) with nowait

set @msg = 'Tempo total decorrido: ' + convert(NVARCHAR, @hft - @hit, 8)
raiserror (@msg, 0, 1) with nowait

select pdv,count(*) as arquivos from ##cupons group by pdv having count(*) > 0
