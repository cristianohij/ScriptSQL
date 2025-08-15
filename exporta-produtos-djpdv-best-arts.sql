-- remove/recria a tabela temporária de preços

if object_id('tempdb.dbo.##precos') is not null
   drop table tempdb.dbo.##precos
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no trabalho de exportação dos produtos DJPDV'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where EMPCOD=1)
set @trabalho='<p>Nome do trabalho: Exportação geral de produtos para o DJPDV'

select * into ##precos from PrecoLojaGeral(0)

set @q=@@ROWCOUNT

if @q=0
--if @q <= 100000
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

-- gera o arquivo temporário para exportação dos produtos

-- remove/recria a tabela temporária de produtos

declare @crt int

select @crt=EMPCRT
  from TBS023 with (nolock)

if object_id('tempdb.dbo.##produtos') is not null
   drop table tempdb.dbo.##produtos;

-- lista de produtos exportados
WITH PrecosComIndice AS (
    SELECT 
        rtrim(T.PROCOD) +  IIF(ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))=2, '2222', IIF(ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))=3, '3333', IIF(ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))=4, '4444', ''))) as PROCOD,
        T.PRODES,
        UMs.UnidadeMedida,
        --ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice,
        --P.preco1,
        --P.preco2,
        --P.preco3,
        iif(T.PROUM1 = UMs.UnidadeMedida, 1 , iif(T.PROUM2 = UMs.UnidadeMedida, T.PROUM2QTD, iif(T.PROUM3 = UMs.UnidadeMedida, T.PROUM3QTD, T.PROUM4QTD))) as qtEmbalagem,
        iif(T.PROUM1 = UMs.UnidadeMedida, P.preco1 , iif(T.PROUM2 = UMs.UnidadeMedida, T.PROUM2QTD * P.preco2, iif(T.PROUM3 = UMs.UnidadeMedida, T.PROUM3QTD * P.preco3, T.PROUM4QTD * P.preco4))) as preco,

        --T.PROUM2,
        --T.PROUM2QTD AS qtEmbalagem,
        --EMBs.qtEmbalagem,
        --iif(T.PROUM1 = UMs.UnidadeMedida, 1 , iif(T.PROUM2 = UMs.UnidadeMedida, T.PROUM2QTD, T.PROUM3QTD)) as qtEmbalagem,
        --'' AS CBPCODBAR,
        1 AS Fonte,
        T.PROSTBA,
        T.PROSTBB,
        T.PROCSN,
        T.PROICMSINT,
        T.PROPESAVEL,
        T.PROCLAFIS,
        T.PROCEST,
        T.MARCOD,
        T.MARNOM,
        T.GRUCOD,
        (select GRUDES from TBS012 g with (nolock) where g.GRUCOD=T.GRUCOD) as GRUDES,
        ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
    FROM TBS010 T WITH (NOLOCK)
    CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2), (T.PROUM3), (T.PROUM4)) AS UMs (UnidadeMedida)
    --CROSS APPLY (VALUES (1), (T.PROUM2QTD), (T.PROUM3QTD)) AS EMBs (qtEmbalagem)
    CROSS APPLY (
        SELECT preco1, preco2, preco3, preco4
        FROM PrecoLoja(0, T.PROCOD)
        where --T.PROCOD='01730024' --'00560009' --'01560010'
        --and 
        UMs.UnidadeMedida <> '' -- (T.PROUM2 <> '' or T.PROUM3 <> '')
    ) AS P

    UNION ALL

    SELECT 
        --pro.PROCOD,
        bar.CBPCODBAR as PROCOD,
        pro.PRODES,
        IIF(bar.CBPQTDEMB=1, pro.PROUM1, IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2, IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3, iif(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4, '')))) AS UnidadeMedida,
        bar.CBPQTDEMB as qtEmbalagem,

        --3 AS LinhaIndice,
        --preco.preco1,
        --preco.preco2,
        --iif(bar.CBPQTDEMB = 1, preco.preco1, iif(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2 * bar.CBPQTDEMB, iif(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, iif(bar.CBPQTDEMB=pro.PROUM4QTD, )
        iif(bar.CBPQTDEMB = 1, preco.preco1, bar.CBPQTDEMB * iif(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, iif(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, iif(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4, 0)))) as preco,
        --iif(bar.CBPQTDEMB=1, pro.PROUM1, pro.PROUM2),
        --pro.PROUM2QTD AS qtEmbalagem,
        --bar.CBPCODBAR,
        2 AS Fonte,
        pro.PROSTBA,
        pro.PROSTBB,
        pro.PROCSN,
        pro.PROICMSINT,
        pro.PROPESAVEL,
        pro.PROCLAFIS,
        pro.PROCEST,
        pro.MARCOD,
        pro.MARNOM,
        pro.GRUCOD,
        (select GRUDES from TBS012 g with (nolock) where g.GRUCOD=pro.GRUCOD) as GRUDES,
        --3 AS LinhaIndice
        ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
    FROM TBS0103 bar WITH (NOLOCK)
    INNER JOIN TBS010 pro WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD
    CROSS APPLY (
        SELECT preco1, preco2 ,preco3, preco4
        FROM PrecoLoja(0, pro.PROCOD)
    ) AS preco
    WHERE --pro.PROUM2 <> ''
      --AND 
      (bar.CBPQTDEMB=1 or bar.CBPQTDEMB = pro.PROUM2QTD or bar.CBPQTDEMB = pro.PROUM3QTD or bar.CBPQTDEMB = pro.PROUM4QTD)
      AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
      and right(rtrim(bar.CBPCODBAR),4) not in ('2222','3333','4444')
      --and pro.PROCOD='01730024' --'00560009'
)

--select * from PrecosComIndice

select --Left(Ltrim(rtrim(COALESCE(CBPCODBAR, iif(Fonte=1 and LinhaIndice=2, rtrim(PROCOD) + '2222' ,PROCOD) )))+replicate(' ',20),20)          -- 01 Cód. Externo
       --+ Left(Ltrim(rtrim(COALESCE(CBPCODBAR, iif(Fonte=1 and LinhaIndice=2, rtrim(PROCOD) + '2222' ,PROCOD) )))+replicate(' ',20),20)          -- 02 Cód. Barras
       Left(Ltrim(rtrim(PROCOD)) + replicate(' ',20),20)          -- 01 Cód. Externo
       + Left(Ltrim(rtrim(PROCOD)) + replicate(' ',20),20)          -- 02 Cód. Barras       
       --+ Left(Ltrim(rtrim(COALESCE(CBPCODBAR, PROCOD)))+replicate(' ',20),20)          -- 02 Cód. Barras
       --+ Left(Ltrim(rtrim(PROCOD))+replicate(' ',20),20)        -- 02 Cód. Barras
       --+ replicate(' ',20) -- 02 Cód. Barras
       --+ Left(Ltrim(rtrim(T10.PRODES))+replicate(' ',40),40)        -- 03 Descrição
       + Left(Ltrim(rtrim(dbo.RemoveInvalidChars(PRODES)))+replicate(' ',40),40)  -- 03 Descrição
       + replicate(' ',20)                                          -- 04 Complemento
       + Left(Ltrim(rtrim(UnidadeMedida))+replicate(' ',4),4)          -- 05 Unidade
        -- 06 Preço Venda
       --+ right(replicate('0',12) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,12,0)),12)
       + right(replicate('0',12) + Ltrim(str(isnull(
        
        --IIF(Fonte = 1 AND LinhaIndice = 1, preco1, IIF(Fonte = 1 AND LinhaIndice = 2 AND PROUM2 <> '', preco2 * qtEmbalagem, IIF(Fonte = 2, preco2 * qtEmbalagem, NULL)))
        --IIF(Fonte = 1 AND LinhaIndice = 1, preco1, IIF(Fonte = 1 AND LinhaIndice = 2 AND PROUM2 <> '', preco2 * qtEmbalagem, IIF(Fonte = 2, preco2 * qtEmbalagem, NULL)))
        preco
        
        ,0)*1000,12,0)),12)
       + '000000'                                                   -- 07 Desconto
       
       /* 00 = T
          20 = T
          40 = I
          41 = N
          60 = F */
       
       --+ iif(T10.PROSTBB='40','I', iif(T10.PROSTBB='60','F','T'))   -- 08 Situação Tributaria
       -- 08 Situação Tributaria
       + iif(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB)) -- Situação Tributária
       --+ iif(PROSTBB in('30','40'),'I', iif(PROSTBB='41','N', iif(PROSTBB in('10','60','70'),'F', 'T')))
        -- 09 'ICMS'
       --+ iif(T10.PROICMSINT > 0, right(replicate('0',4) + Ltrim(str(round(right(replicate('0',4) + Ltrim(str(round(@n,2)*100,4,0)),4),2)*100,4,0)),4),'1800'
       + right(replicate('0',4) + Ltrim(str(isnull(iif(PROICMSINT=0,18,PROICMSINT),0)*100,4,0)),4)
       --+ right(replicate('0',4) + iif(PROICMSINT > 0, Ltrim(str(PROICMSINT*100)), '1800'),4)
       + replicate(' ',65)                                          -- 10 Obs PopUp
       + 'N'                                                        -- 11 Calcula Quantidade
       + iif(PROPESAVEL='S','N','S')                                -- 12 Bloqueia Quantidade Fracionaria
       + 'N'                                                        -- 13 Bloqueia Quantidade
       + 'N'                                                        -- 14 Arredonda
       + 'N'                                                        -- 15 Produção Própria
       + right(replicate(' ',6) + Ltrim(str(GRUCOD)),6)             -- 16 Cód. Grupo
       + Left(Ltrim(rtrim(GRUDES)) + replicate(' ',30),30)          -- 17 Descrição Grupo
       + '      '                                                   -- 18 Cód.Departamento
       + replicate(' ',30)                                          -- 19 Descrição Departamento
       + right(replicate(' ',6) + Ltrim(str(MARCOD)),6)             -- 20 Cód. Marca
       + Left(Ltrim(rtrim(MARNOM)) + replicate(' ',30),30)          -- 21 Descrição Marca
       + '     0'                                                   -- 22 Cód.Tipo_Vasilhame
       + replicate(' ',30)                                          -- 23 Descrição Tipo Vasilhame
       + '000000'                                                   -- 24 RESERVADO
       + '000000'                                                   -- 25 Flag
       -- 26 NCM
       + Left(iif(Len(PROCLAFIS)=8,PROCLAFIS,'')+replicate(' ',20),20)
       + '000000'                                                   -- 27 Cód. TipoDescrição Adicional
       + replicate(' ',20)                                          -- 28 Gtin Contábil
       + replicate(' ',20)                                          -- 29 EX TIPI
       + replicate(' ',20)                                          -- 30 Gtin Tributável
       --+ '      '                                                   -- 31 ID ICMS
       + iif(@crt=1, right(replicate(' ',6) + Ltrim(PROCSN),6), right(replicate(' ',6) + '9' + Ltrim(PROSTBA+PROSTBB),6)) -- ID_ICMS
       --+ right(replicate(' ',6) + Ltrim(PROSTBA) + Ltrim(PROCSN),6)
       + '      '                                                   -- 32 ID IPI
       + '      '                                                   -- 33 ID ISSQN
       + '      '                                                   -- 34 ID II
       + '    49'                                                   -- 35 ID PIS
       + '      '                                                   -- 36 ID PIS ST
       + '    49'                                                   -- 37 ID COFINS
       + '      '                                                   -- 38 ID COFINS ST
       + 'N'                                                        -- 39 KIT
       + '000000000000'                                             -- 40 Quantidade Estoque
       + '000'                                                      -- 41 Prazo Devolução
       + iif(Len(PROCEST)=7,PROCEST,replicate(' ',7))       -- 42 Cest
       + 'S'                                                        -- 43 Controla Estoque
       + replicate(' ',9)                                           -- 44 Código ANP
       + 'N'                                                        -- 45 Dupla Pesagem
       + '00000'                                                    -- 46 Margem Segurança
       + ' '                                                        -- 47 Indicador de Escala Relevante
       + replicate(' ',20)                                          -- 48 CNPJ do Fabricante da Mercadoria
       + replicate(' ',10)                                          -- 49 Código do Benefício Fiscal
       + '0000000'                                                  -- 50 Percentual do GLP derivado de petróleo do produto GLP (GLP)
       + '0000000'                                                  -- 51 Percentual de Gás Natural Nacional (GNn)
       + '0000000'                                                  -- 52 Percentual de Gás Natural Importado (GNi)
       + '000000000000000'                                          -- 53 Valor do quilograma sem ICMS
       + 'P'                                                        -- 54 Tipo Desconto
       + Left(Ltrim(rtrim(UnidadeMedida))+replicate(' ',4),4)          -- 55 Unidade Tributável
       + '000000000000000'                                          -- 56 Quantidade Tributável
       + replicate(' ',20)                                          -- 57 Cód Externo Grupo Impressão
       + '000000'                                                   -- 58 Desconto Máximo
       -- 59 Descrição Complementar
       + Left(Ltrim(rtrim(subString(PRODES,41,40)))+replicate(' ',80),80) as texto

   into ##produtos
  from PrecosComIndice
 where preco > 0; -- (Fonte = 1 AND ((LinhaIndice = 1 AND preco > 0) OR (LinhaIndice = 2 AND UnidadeMedida <> '' AND preco2 > 0)))
       --OR (Fonte = 2);

--select *
--  from ##produtos

/*
select Left(Ltrim(rtrim(T10.PROCOD))+replicate(' ',20),20)          -- 01 Cód. Externo
       + Left(Ltrim(rtrim(T10.PROCOD))+replicate(' ',20),20)        -- 02 Cód. Barras
       --+ Left(Ltrim(rtrim(T10.PRODES))+replicate(' ',40),40)        -- 03 Descrição
       + Left(Ltrim(rtrim(dbo.RemoveInvalidChars(T10.PRODES)))+replicate(' ',40),40)  -- 03 Descrição
       + replicate(' ',20)                                          -- 04 Complemento
       + Left(Ltrim(rtrim(T10.PROUM1))+replicate(' ',4),4)          -- 05 Unidade
        -- 06 Preço Venda
       + right(replicate('0',12) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,12,0)),12)
       + '000000'                                                   -- 07 Desconto
       
       /* 00 = T
          20 = T
          40 = I
          41 = N
          60 = F */
       
       --+ iif(T10.PROSTBB='40','I', iif(T10.PROSTBB='60','F','T'))   -- 08 Situação Tributaria
       -- 08 Situação Tributaria
       + iif(T10.PROSTBB in('30','40'),'I', iif(T10.PROSTBB='41','N', iif(T10.PROSTBB in('10','60','70'),'F', 'T')))
        -- 09 'ICMS'
       --+ iif(T10.PROICMSINT > 0, right(replicate('0',4) + Ltrim(str(round(right(replicate('0',4) + Ltrim(str(round(@n,2)*100,4,0)),4),2)*100,4,0)),4),'1800'
       + right(replicate('0',4) + iif(T10.PROICMSINT > 0, Ltrim(str(T10.PROICMSINT*100)), '1800'),4)
       + replicate(' ',65)                                          -- 10 Obs PopUp
       + 'N'                                                        -- 11 Calcula Quantidade
       + iif(PROPESAVEL='S','N','S')                                -- 12 Bloqueia Quantidade Fracionaria
       + 'N'                                                        -- 13 Bloqueia Quantidade
       + 'N'                                                        -- 14 Arredonda
       + 'N'                                                        -- 15 Produção Própria
       + '      '                                                   -- 16 Cód. Grupo
       + replicate(' ',30)                                          -- 17 Descrição Grupo
       + '      '                                                   -- 18 Cód.Departamento
       + replicate(' ',30)                                          -- 19 Descrição Departamento
       + '      '                                                   -- 20 Cód. Marca
       + replicate(' ',30)                                          -- 21 Descrição Marca
       + '     0'                                                   -- 22 Cód.Tipo_Vasilhame
       + replicate(' ',30)                                          -- 23 Descrição Tipo Vasilhame
       + '000000'                                                   -- 24 RESERVADO
       + '000000'                                                   -- 25 Flag
       -- 26 NCM
       + Left(iif(Len(T10.PROCLAFIS)=8,T10.PROCLAFIS,'')+replicate(' ',20),20)
       + '000000'                                                   -- 27 Cód. TipoDescrição Adicional
       + replicate(' ',20)                                          -- 28 Gtin Contábil
       + replicate(' ',20)                                          -- 29 EX TIPI
       + replicate(' ',20)                                          -- 30 Gtin Tributável
       --+ '      '                                                   -- 31 ID ICMS
       + right(replicate(' ',6) + Ltrim(PROSTBA) + Ltrim(PROCSN),6)
       + '      '                                                   -- 32 ID IPI
       + '      '                                                   -- 33 ID ISSQN
       + '      '                                                   -- 34 ID II
       + '    49'                                                   -- 35 ID PIS
       + '      '                                                   -- 36 ID PIS ST
       + '    49'                                                   -- 37 ID COFINS
       + '      '                                                   -- 38 ID COFINS ST
       + 'N'                                                        -- 39 KIT
       + '000000000000'                                             -- 40 Quantidade Estoque
       + '000'                                                      -- 41 Prazo Devolução
       + iif(Len(T10.PROCEST)=7,T10.PROCEST,replicate(' ',7))       -- 42 Cest
       + 'S'                                                        -- 43 Controla Estoque
       + replicate(' ',9)                                           -- 44 Código ANP
       + 'N'                                                        -- 45 Dupla Pesagem
       + '00000'                                                    -- 46 Margem Segurança
       + ' '                                                        -- 47 Indicador de Escala Relevante
       + replicate(' ',20)                                          -- 48 CNPJ do Fabricante da Mercadoria
       + replicate(' ',10)                                          -- 49 Código do Benefício Fiscal
       + '0000000'                                                  -- 50 Percentual do GLP derivado de petróleo do produto GLP (GLP)
       + '0000000'                                                  -- 51 Percentual de Gás Natural Nacional (GNn)
       + '0000000'                                                  -- 52 Percentual de Gás Natural Importado (GNi)
       + '000000000000000'                                          -- 53 Valor do quilograma sem ICMS
       + 'P'                                                        -- 54 Tipo Desconto
       + Left(Ltrim(rtrim(T10.PROUM1))+replicate(' ',4),4)          -- 55 Unidade Tributável
       + '000000000000000'                                          -- 56 Quantidade Tributável
       + replicate(' ',20)                                          -- 57 Cód Externo Grupo Impressão
       + '000000'                                                   -- 58 Desconto Máximo
       -- 59 Descrição Complementar
       + Left(Ltrim(rtrim(subString(T10.PRODES,41,40)))+replicate(' ',80),80) as texto

   into ##produtos
  from TBS010 T10 with (nolock)
 where T10.PROEMPCOD=0
	   and T10.TGZCOD > 0
	   and (select round(preco1,3) from ##precos where codigo=T10.PROCOD) > 0
 order by PROCOD

*/


-- elimina registro nulos
 
delete ##produtos
 where texto is null
 
-- select para o contador de registros abaixo

select count(*)
  from ##produtos

-- quantidade de produtos exportados

select convert(float,@@rowcount) as q into ##q2

if (select q from ##q2)=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha ao carregar a tabela ##produtos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha ao carregar a tabela ##produtos'
      
	  -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos produtos
exec master.dbo.xp_cmdshell 'bcp "select texto from ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -T';
go


-- daqui pra baixo perde a referência das variáveis criadas


-- valida a quantidade de proudtos exportados, diferença deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no trabalho de exportação dos produtos DJPDV'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where EMPCOD=1)
set @trabalho='<p>Nome do trabalho: Exportação geral de produtos para o DJPDV'

select @q1=count(*)
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\exporta\djpdv;HDR=No;/r'
		,'select * from [est.txt]'
	 )

set @q2=(select q from ##q2)

print 'Quantidade de produtos exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de produtos no cadastro (TBS010): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
   begin
   	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exportação dos Produtos. Arquivo c:\integros\exporta\djpdv\est.txt deletado.'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exportação dos Produtos. Arquivo c:\integros\exporta\djpdv\est.txt deletado.'
      exec xp_cmdshell 'del c:\integros\exporta\djpdv\est.txt'

      -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go

-- TESTES

--select *
--  from ##precos

select *
  from TBS0103 with (nolock)
 where CBPPROCOD='00560009'

select PROCOD
       ,PRODES
       ,PROUM1
       ,PROUM2
       ,PROUM2QTD
  from TBS010 with (nolock)
 where PROCOD='00010001'

SELECT PROCOD
       ,PRODES
       ,UnidadeMedida
FROM TBS010 with (nolock)
CROSS APPLY (VALUES (PROUM1), (PROUM2)) AS UMs (UnidadeMedida)
WHERE PROCOD = '00730137';

SELECT 
    PROCOD, 
    PRODES, 
    UnidadeMedida,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS LinhaIndice
FROM TBS010 WITH (NOLOCK)
CROSS APPLY (VALUES (PROUM1), (PROUM2)) AS UMs (UnidadeMedida)
WHERE PROCOD = '00730137';


select preco1, preco2 from PrecoLoja(0,'00010001')

SELECT 
    T.PROCOD,
    T.PRODES,
    UMs.UnidadeMedida,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS LinhaIndice,
    CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) = 1 THEN P.preco1
        WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) = 2 THEN P.preco2
    END AS Preco
FROM TBS010 T WITH (NOLOCK)
CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2)) AS UMs (UnidadeMedida)
CROSS APPLY (
    SELECT preco1, preco2 
    FROM PrecoLoja(0, T.PROCOD)
) AS P
WHERE T.PROCOD = '02640151'
      AND T.PROUM2 != ''

WITH PrecoComIndice AS (
    SELECT 
        T.PROEMPCOD,
        T.PROCOD,
        T.PRODES,
        T.PROUM2QTD,
        UMs.UnidadeMedida,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS LinhaIndiceProduto,
        CASE 
            WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) = 1 THEN P.preco1
            WHEN ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) = 2 THEN P.preco2
        END AS Preco
    FROM TBS010 T WITH (NOLOCK)
    CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2)) AS UMs (UnidadeMedida)
    CROSS APPLY (
        SELECT preco1, preco2 
        FROM PrecoLoja(0, '00010001')
    ) AS P
    WHERE T.PROCOD = '00010001'
)
SELECT 
    P.PROCOD,
    P.PRODES,
    P.UnidadeMedida,
    P.LinhaIndiceProduto,
    P.Preco,
    T3.CBPQTDEMB,
    ROW_NUMBER() OVER (PARTITION BY P.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndiceTBS0103
FROM PrecoComIndice P
INNER JOIN TBS0103 T3 WITH (NOLOCK)
    ON P.PROEMPCOD = T3.CBPEMP 
    AND P.PROCOD = T3.CBPPROCOD
    AND P.PROUM2QTD = T3.CBPQTDEMB
ORDER BY P.PROCOD, P.LinhaIndiceProduto, LinhaIndiceTBS0103;

select top(10) *
  from TBS010 with (nolock)
 where PROUM2=''

WITH PrecosComIndice AS (
    SELECT 
        T.PROCOD,
        T.PRODES,
        UMs.UnidadeMedida,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS LinhaIndice,
        P.preco1,
        P.preco2,
        T.PROUM2
    FROM TBS010 T WITH (NOLOCK)
    CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2)) AS UMs (UnidadeMedida)
    CROSS APPLY (
        SELECT preco1, preco2 
        FROM PrecoLoja(0, T.PROCOD)
    ) AS P
    --WHERE T.PROCOD = '00730137'
)
SELECT 
    PROCOD,
    PRODES,
    UnidadeMedida,
    LinhaIndice,
    CASE 
        WHEN LinhaIndice = 1 THEN preco1
        WHEN LinhaIndice = 2 AND PROUM2 <> '' THEN preco2
    END AS Preco
FROM PrecosComIndice
WHERE LinhaIndice = 1 OR (LinhaIndice = 2 AND PROUM2 <> '')
--ORDER BY LinhaIndice
union all
select bar.CBPCODBAR
       ,pro.PRODES
       ,pro.PROUM2
       ,3
       ,(SELECT preco2 
        FROM PrecoLoja(0, pro.PROCOD))
  from TBS0103 bar with (nolock)
 inner join TBS010 pro with (nolock)
    on pro.PROCOD=bar.CBPPROCOD
 where pro.PROUM2 <> ''
       and bar.CBPQTDEMB=pro.PROUM2QTD
       and pro.PROCOD='00560009'

WITH PrecosComIndice AS (
    SELECT 
        T.PROCOD,
        T.PRODES,
        UMs.UnidadeMedida,
        ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice,
        P.preco1,
        P.preco2,
        T.PROUM2,
        T.PROUM2QTD AS qtEmbalagem
    FROM TBS010 T WITH (NOLOCK)
    CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2)) AS UMs (UnidadeMedida)
    CROSS APPLY (
        SELECT preco1, preco2 
        FROM PrecoLoja(0, T.PROCOD)
    ) AS P
)
SELECT 
    PROCOD,
    PRODES,
    UnidadeMedida,
    LinhaIndice,
    CASE 
        WHEN LinhaIndice = 1 THEN preco1
        WHEN LinhaIndice = 2 AND PROUM2 <> '' THEN preco2 * qtEmbalagem
    END AS Preco
FROM PrecosComIndice
WHERE (LinhaIndice = 1 and preco1 > 0) OR (LinhaIndice = 2 AND PROUM2 <> '' and preco2 > 0)
--ORDER BY PROCOD, LinhaIndice;

union all

SELECT 
    bar.CBPCODBAR,
    pro.PRODES,
    pro.PROUM2,
    3 AS Constante,
    preco.preco2 * pro.PROUM2QTD
FROM TBS0103 bar WITH (NOLOCK)
INNER JOIN TBS010 pro WITH (NOLOCK)
    ON pro.PROCOD = bar.CBPPROCOD
CROSS APPLY (
    SELECT preco2 
    FROM PrecoLoja(0, pro.PROCOD)
) AS preco
WHERE pro.PROUM2 <> ''
  AND bar.CBPQTDEMB = pro.PROUM2QTD
  AND preco.preco2 > 0;


WITH PrecosComIndice AS (
    SELECT 
        T.PROCOD,
        T.PRODES,
        UMs.UnidadeMedida,
        ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice,
        P.preco1,
        P.preco2,
        T.PROUM2,
        T.PROUM2QTD AS qtEmbalagem,
        NULL AS CBPCODBAR,
        1 AS Fonte,
        T.PROSTBA,
        T.PROSTBB,
        T.PROCSN,
        T.PROICMSINT,
        T.PROPESAVEL,
        T.PROCLAFIS,
        T.PROCEST
    FROM TBS010 T WITH (NOLOCK)
    CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2)) AS UMs (UnidadeMedida)
    CROSS APPLY (
        SELECT preco1, preco2 
        FROM PrecoLoja(0, T.PROCOD)
    ) AS P

    UNION ALL

    SELECT 
        pro.PROCOD,
        pro.PRODES,
        pro.PROUM2 AS UnidadeMedida,
        3 AS LinhaIndice,
        NULL AS preco1,
        preco.preco2,
        pro.PROUM2,
        pro.PROUM2QTD AS qtEmbalagem,
        bar.CBPCODBAR,
        2 AS Fonte,
        pro.PROSTBA,
        pro.PROSTBB,
        pro.PROCSN,
        pro.PROICMSINT,
        pro.PROPESAVEL,
        pro.PROCLAFIS,
        pro.PROCEST
    FROM TBS0103 bar WITH (NOLOCK)
    INNER JOIN TBS010 pro WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD
    CROSS APPLY (
        SELECT preco2 
        FROM PrecoLoja(0, pro.PROCOD)
    ) AS preco
    WHERE pro.PROUM2 <> ''
      AND bar.CBPQTDEMB = pro.PROUM2QTD
      AND preco.preco2 > 0
)

SELECT 
    COALESCE(CBPCODBAR, PROCOD) AS Codigo,
    PRODES,
    UnidadeMedida,
    LinhaIndice,
    CASE 
        WHEN Fonte = 1 AND LinhaIndice = 1 THEN preco1
        WHEN Fonte = 1 AND LinhaIndice = 2 AND PROUM2 <> '' THEN preco2 * qtEmbalagem
        WHEN Fonte = 2 THEN preco2 * qtEmbalagem
    END AS Preco
FROM PrecosComIndice
WHERE (Fonte = 1 AND ((LinhaIndice = 1 AND preco1 > 0) OR (LinhaIndice = 2 AND PROUM2 <> '' AND preco2 > 0)))
   OR (Fonte = 2);


select *
  from TBS0103 with (nolock)
 where --Len(CBPCODBAR)=12
       --and 
       right(rtrim(CBPCODBAR),4) in ('2222','3333','4444')

select *
  from TBS0103 with (nolock)
 where CBPPROCOD=CBPCODBAR

select *
  from TBS010 with (nolock)
 where PROUM4 <> ''

UPDATE TBS010
SET 
    TBS010.MARNOM = TBS014.MARNOM
FROM 
    TBS010 with (nolock)
INNER JOIN 
    TBS014 with (nolock) ON TBS010.MARCOD = TBS014.MARCOD
WHERE 
    TBS010.MARNOM <> TBS014.MARNOM;




