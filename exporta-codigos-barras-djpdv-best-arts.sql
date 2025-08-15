-- remove/recria a tabela temporária de preços

if object_id('temp.dbo.##precos') is not null
   drop table temp.dbo.##precos
go

-- remove/recria a tabela temporária de códigos de barras

if object_id('tempdb.dbo.##barras') is not null
   drop table tempdb.dbo.##barras
go

if object_id('tempdb.dbo.##q2') is not null
   drop table tempdb.dbo.##q2
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no trabalho de exportação dos códigos de barras DJPDV'
set @mailto='cristiano@integros.com.br;suporte@papelyna.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where EMPCOD=1)
set @trabalho='<p>Nome do trabalho: Exportação geral dos códigos de barras DJPDV'

select * into ##precos from PrecoLojaGeral(0)

set @q=@@ROWCOUNT

if @q=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Não foi carregada a tabela ##precos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''', 
						@body_format = ''html'',
						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Não foi carregada a tabela ##precos'

      -- força um erro para parar o processo
      select * from parada_forcada
   end

print 'Quantidade de produtos com preços: ' + Ltrim(str(@q,9,0))


/*
select Left(Ltrim(rtrim(codigo))+replicate(' ',20),20)							-- 01 Cód. Barras Produto
       + Left(Ltrim(rtrim(barras))+replicate(' ',20),20)                        -- 02 Cód. Barras Adicional
	   --+ 'D'                                                                    -- 03 Desconto/Acréscimo
      + iif((select p.preco2
               from ##precos p
              where p.codigo=b.codigo
                    and (p.preco2 = 0 or b.embalagem = 1)) = 0, ' '
                        ,iif((select 1 from ##precos p where p.codigo=b.codigo and p.preco1 > p.preco2) = 1, 'D'
                        ,iif((select 1 from ##precos p where p.codigo=b.codigo and p.preco1 < p.preco2) = 1, 'A'
                        ,' ')))

	   --+ replicate('0',5)                                                       -- 04 Porcentagem

       + right(replicate('0',5) + Ltrim(str(isnull(iif((select p.preco2 from ##precos p where p.codigo=b.codigo and (p.preco2 = 0 or b.embalagem = 1)) = 0, 0, iif((select 1 from ##precos p where p.codigo=b.codigo and p.preco1 >= p.preco2) = 1, (select round(((p.preco1 - p.preco2) / p.preco1) * 100,2) from ##precos p where p.codigo=b.codigo), (select round(((p.preco2 - p.preco1) / p.preco1) * 100,2) from ##precos p where p.codigo=b.codigo))) ,0)*100,5,0)),5)

       -- 05 Quantidade_Embalagem
       + right(replicate('0',7) + Ltrim(str(round(embalagem,2)*100,7,0)),7)	as texto
  into ##barras
  from dbo.TabelaCodigosBarrasGZ(0) b
*/

/*
select Left(Ltrim(rtrim(codigo))+replicate(' ',20),20)				-- 01 Cód. Barras Produto
       + Left(Ltrim(rtrim(barras))+replicate(' ',20),20)          -- 02 Cód. Barras Adicional
	    --+ 'D'                                                      -- 03 Desconto/Acréscimo
      
      
      + iif((select p.preco2
               from ##precos p
              where p.codigo=b.codigo
                    and (p.preco2 = 0 or b.embalagem = 1)) = 0, ' '
                        ,iif((select 1 from ##precos p where p.codigo=b.codigo and p.preco1 > p.preco2) = 1, 'D'
                        ,iif((select 1 from ##precos p where p.codigo=b.codigo and p.preco1 < p.preco2) = 1, 'A'
                        ,' ')))
      

	    -- + replicate('0',5)                                                       -- 04 Porcentagem

       + right(replicate('0',5) + Ltrim(str(isnull(iif((select p.preco2 from ##precos p where p.codigo=b.codigo and (p.preco2 = 0 or b.embalagem = 1)) = 0, 0, iif((select 1 from ##precos p where p.codigo=b.codigo and p.preco1 >= p.preco2) = 1, (select round(((p.preco1 - p.preco2) / p.preco1) * 100,2) from ##precos p where p.codigo=b.codigo), (select round(((p.preco2 - p.preco1) / p.preco1) * 100,2) from ##precos p where p.codigo=b.codigo))) ,0)*100,5,0)),5)

       -- 05 Quantidade_Embalagem
       + right(replicate('0',7) + Ltrim(str(round(embalagem,2)*100,7,0)),7)	as texto
  into ##barras
  from dbo.TabelaCodigosBarrasDJ(0) b
*/

select 
    LEFT(LTRIM(RTRIM(b.codigo)) + REPLICATE(' ', 20), 20) --AS Cod_Barras_Produto, -- 01 Cód. Barras Produto
    + LEFT(LTRIM(RTRIM(b.barras)) + REPLICATE(' ', 20), 20) --AS Cod_Barras_Adicional, -- 02 Cód. Barras Adicional
    
    -- 03 Desconto/Acréscimo
    + CASE 
        WHEN p.preco2 = 0 OR b.embalagem = 1 THEN 'D' 
        WHEN p.preco1 > p.preco2 THEN 'D'
        WHEN p.preco1 < p.preco2 THEN 'A'
        ELSE ' '
    END --AS Desconto_Acrescimento,

    -- 04 Porcentagem
    + RIGHT(REPLICATE('0', 5) + LTRIM(STR(ISNULL(
        CASE 
            WHEN p.preco2 = 0 OR b.embalagem = 1 THEN 0
            WHEN p.preco1 >= p.preco2 THEN ROUND(((p.preco1 - p.preco2) / p.preco1) * 100, 2)
            ELSE ROUND(((p.preco2 - p.preco1) / p.preco1) * 100, 2)
        END, 0) * 100, 5, 0)), 5) --AS Porcentagem,

    -- 05 Quantidade_Embalagem
    + RIGHT(REPLICATE('0', 7) + LTRIM(STR(ROUND(b.embalagem, 2) * 100, 7, 0)), 7) as texto

INTO ##barras
FROM 
    dbo.TabelaCodigosBarrasGZ(0) b
OUTER APPLY (
    SELECT p.preco1, p.preco2
    FROM ##precos p
    WHERE p.codigo = b.codigo
) AS p;

-- quantidade de registros processados
select convert(float,@@rowcount) as q into ##q2

if (select q from ##q2)=0
--if (select q from ##q2) < =100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha ao carregar a tabela ##barras'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha ao carregar a tabela ##barras'
      
	  -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos códigos de barras
exec master.dbo.xp_cmdshell 'bcp "select texto from ##barras order by texto" queryout "c:\integros\exporta\djpdv\bar.txt" -c -T';
go


-- daqui pra baixo perde a referência das variáveis criadas


-- valida a quantidade de códigos de barras exportados, diferença deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no trabalho de exportação dos códigos de barras DJPDV'
set @mailto='cristiano@integros.com.br;suporte@papelyna.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where EMPCOD=1)
set @trabalho='<p>Nome do trabalho: Exportação geral dos códigos de barras DJPDV'

select @q1=count(*)
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\exporta\djpdv;HDR=No;/r'
		,'select * from [bar.txt]'
	 )

set @q2=(select q from ##q2)

print 'Quantidade de códigos de barras exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de produtos no cadastro (TBS0103): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
--if ((1-@q1/@q2) * 100) <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exportação dos códigos de barras. Arquivo c:\integros\exporta\djpdv\bar.txt deletado'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exportação dos códigos de barras.'

      exec xp_cmdshell 'del c:\integros\expgz\bar.txt'

      -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go

-- testes

select *
  from ##barras
 

--select * from dbo.TabelaCodigosBarrasDJ(0)













