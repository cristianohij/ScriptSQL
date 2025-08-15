-- gera o arquivo temporário para exportação dos clientes


-- remove/recria a tabela temporária de clientes

if object_id('TempDB.dbo.##clientes') is not null
   drop table TempDB.dbo.##clientes

-- variáveis

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

-- lista de clientes exportados

select right(replicate('0',16) + Ltrim(rtrim(cli.CLICOD)),16)		                                          -- 01 código
       + Left(Ltrim(rtrim(cli.CLINOM))+replicate(' ',50),50)                                                -- 02 nome completo
       + Left(Ltrim(rtrim(cli.CLIEND))+replicate(' ',60),60)                                                -- 03 endereço
       + Left(Ltrim(rtrim(cli.CLIBAI))+replicate(' ',30),30)                                                -- 04 bairro
       + Left(Ltrim(rtrim(mun.MUNNOM))+replicate(' ',30),30)                                                -- 05 cidade
       + cli.UFESIG                                                                                         -- 06 uf
       + Left(replace(Ltrim(rtrim(cli.CLICEP)),'-','')+replicate(' ',8),8)                                  -- 07 cep
       + Left(Ltrim(rtrim(cli.CLITEL))+replicate(' ',15),15)                                                -- 08 telefone
       -- 09 cnpj/cpf
       + Left(Ltrim(rtrim( iif(cli.CLITIPPES='J' and Len(cli.CLICGC)=14, dbo.FormatarCnpj(cli.CLICGC), iif(cli.CLITIPPES='F' and Len(cli.CLICPF)=11, dbo.FormatarCpf(cli.CLICPF), ''))))+replicate(' ',19),19)
       + replicate('0',8)                                                                                   -- 10 data de nascimento
       + replicate('0',8)                                                                                   -- 11 data da última compra
       + 'L'                                                                                                -- 12 situação
       + replicate('0',12)                                                                                  -- 13 limite total de crédido para compra convênio (fiado)
       + replicate('0',12)                                                                                  -- 14 valor total das compras em aberto no convênio (fiado)
       + replicate('0',4)                                                                                   -- 15 percentual de desconto sobre o cupom
       + 'N'                                                                                                -- 16 desconto sobre produtos em promoção
       + 'N'                                                                                                -- 17 desconto geral
       + 'S'                                                                                                -- 18 permite compra no convênio (fiado)
       + replicate(' ',80)                                                                                  -- 19 mensagem
       + replicate('0',12)                                                                                  -- 20 limite total de crédito para compra com cheque (valor)
       + replicate('0',6)                                                                                   -- 21 limite total de crédito para compra com cheque (quantidade)
       + replicate('0',12)                                                                                  -- 22 valor total das compras em aberto com cheque (valor)
       + replicate('0',6)                                                                                   -- 23 valor total das compras em aberto com cheque (quantidade)
       + replicate(' ',80)                                                                                  -- 24 cartão/código de barras
       + replicate(' ',40)                                                                                  -- 25 reservado - espaço em branco
       -- 26 inscrição estadual/rg
       + Left(Ltrim(rtrim(iif(cli.CLITIPPES='J', cli.CLIIES, iif(cli.CLITIPPES='F', cli.CLIRG, ''))))+replicate(' ',25),25) 
       + replicate('0',9)                                                                                   -- 27 pontuação acumulada (fidelidade)
       + replicate(' ',2)                                                                                   -- 28 reservado - espaço em branco
       + replicate(' ',10)                                                                                  -- 29 reservado - espaço em branco
       + replicate('0',12)                                                                                  -- 30 valor da última compra
       + replicate('0',12)                                                                                  -- 31 saldo para recebimento em conta
       + replicate('0',6)                                                                                   -- 32 quantidade de documentos em aberto
       + replicate(' ',90)                                                                                  -- 33 finalizadores de venda bloqueados
       + 'P'                                                                                                -- 34 tabela de preço a utilizar
       + replicate('0',2)                                                                                   -- 35 nível de bloqueio
       + Left(Ltrim(rtrim(cli.CLINOMFAN))+replicate(' ',15),15)                                             -- 36 nome fantasia
       + replicate(' ',20)                                                                                  -- 37 senha do cliente
       + replicate('0',2)                                                                                   -- 38 dia para vencimento do convênio
       + replicate('0',3)                                                                                   -- 39 dias para cálculo do vencimento do convênio
       + replicate(' ',2)                                                                                   -- 40 condição para cálculo do vencimento
       + replicate('0',2)                                                                                   -- 41 melhor dia para compra
       + replicate(' ',40)                                                                                  -- 42 contato / 2a pessoa autorizada
       + replicate(' ',15)                                                                                  -- 43 tipo do endereço
       + replicate('0',6)                                                                                   -- 44 número do endereço
       + Left(Ltrim(rtrim(cli.CLICPLEND))+replicate(' ',20),20)                                             -- 45 complemento
       + replicate(' ',20)                                                                                  -- 46 país
       + replicate('0',4)                                                                                   -- 47 código do país
       + right(replicate('0', 7) + cast(cli.MUNCOD as varchar(7)),7)                                        -- 48 código do município (ibge)
       + replicate(' ',100)                                                                                 -- 49 e-mail
       + replicate(' ',1) as 'texto'                                                                        -- 50 inclusão de percentual de acréscimo em vendas a prazo

  into ##clientes
  from TBS002 cli with (nolock)
 inner join TBS003 mun with (nolock)
         on mun.MUNCOD=cli.MUNCOD
 where cli.CLIEMPCOD=0
 order by cli.CLICOD

--select *
--  from ##clientes

-- elimina registro nulos

delete ##clientes
 where texto is null

-- select para o contador de registros abaixo

select count(*)
  from ##clientes

-- quantidade de clientes exportados

select convert(float,@@rowcount) as q into ##q2

if (select q from ##q2)=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha ao carregar a tabela ##clientes'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha ao carregar a tabela ##clientes'
      
	  -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos produtos
exec master.dbo.xp_cmdshell 'bcp "select texto from ##clientes" queryout "c:\integros\expgz\cli.txt" -c -T';
go

-- daqui pra baixo perde a referência das variáveis criadas


-- valida a quantidade de proudtos exportados, diferença deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Geral de Clientes Para Sistema GZ'

select @q1=count(*)
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\expgz;HDR=No;/r'
		,'select * from [cli.txt]'
	 )

set @q2=(select q from ##q2)

print 'Quantidade de clientes exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de clientes no cadastro (TBS002): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
   begin
   	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exportação dos Clientes. Arquivo c:\integros\expgz\cli.txt deletado.'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exportação dos Clientes. Arquivo c:\integros\expgz\cli.txt deletado.'
      exec xp_cmdshell 'del c:\integros\expgz\cli.txt'

      -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go

-- fim da carga
