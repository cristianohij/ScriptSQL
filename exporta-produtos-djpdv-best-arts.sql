-- integração djpdv

-- linha 3178

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
        isnull((select GRUDES from TBS012 g with (nolock) where g.GRUCOD=T.GRUCOD),'') as GRUDES,
        T.PROSTBPIS,
        T.PROSTBCOFINS,
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
    where --T.PRODATCAD >= '20250910'
            T.PROCOD in ('03300132','03300151')

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
        isnull((select GRUDES from TBS012 g with (nolock) where g.GRUCOD=pro.GRUCOD),'') as GRUDES,
        pro.PROSTBPIS,
        pro.PROSTBCOFINS,
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

      --and pro.PRODATCAD >= '20250910'
      and pro.PROCOD in ('03300132','03300151')
      
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
       --+ '    49'                                                   -- 35 ID PIS

       -- 35 ID PIS
       + right(replicate('0',6) + Ltrim(str( iif(convert(smallint, PROSTBPIS) = 0, 1, convert(smallint, PROSTBPIS)) )),6)

       + '      '                                                   -- 36 ID PIS ST
       --+ '    49'                                                   -- 37 ID COFINS
       
       -- 37 ID COFINS
       + right(replicate('0',6) + Ltrim(str( iif(convert(smallint, PROSTBCOFINS) = 0, 1, convert(smallint, PROSTBCOFINS)) )),6)
       
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

select *
  from ##produtos

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
exec master.dbo.xp_cmdshell 'bcp "select texto from ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';
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

select * from PrecoLojaGeral(0)

-- otimização chatGPT

DECLARE @crt INT;

-- Obter CRT
SELECT @crt = EMPCRT
FROM TBS023 WITH (NOLOCK);

-- Remover tabela temporária antiga
IF OBJECT_ID('tempdb..##produtos') IS NOT NULL
    DROP TABLE ##produtos;

-- Remover tabela intermediária antiga
IF OBJECT_ID('tempdb..##produtos_intermediate') IS NOT NULL
    DROP TABLE ##produtos_intermediate;

-- Etapa 1: tabela intermediária com todos os valores calculados
SELECT
    P.PROCOD,
    dbo.RemoveInvalidChars(P.PRODES) AS PRODES,
    U.UnidadeMedida,
    CASE U.UnidadeMedida
        WHEN P.PROUM1 THEN 1
        WHEN P.PROUM2 THEN P.PROUM2QTD
        WHEN P.PROUM3 THEN P.PROUM3QTD
        ELSE P.PROUM4QTD
    END AS qtEmbalagem,
    CASE U.UnidadeMedida
        WHEN P.PROUM1 THEN ISNULL(PL.preco1,0)
        WHEN P.PROUM2 THEN ISNULL(P.PROUM2QTD * PL.preco2,0)
        WHEN P.PROUM3 THEN ISNULL(P.PROUM3QTD * PL.preco3,0)
        ELSE ISNULL(P.PROUM4QTD * PL.preco4,0)
    END AS preco,
    P.PROSTBA,
    P.PROSTBB,
    P.PROCSN,
    ISNULL(P.PROICMSINT,18) AS PROICMSINT,
    P.PROPESAVEL,
    P.PROCLAFIS,
    P.PROCEST,
    P.MARCOD,
    P.MARNOM,
    P.GRUCOD,
    ISNULL(G.GRUDES,'') AS GRUDES,  -- Aqui buscamos GRUDES de TBS012
    ISNULL(P.PROSTBPIS,1) AS PROSTBPIS,
    ISNULL(P.PROSTBCOFINS,1) AS PROSTBCOFINS
INTO ##produtos_intermediate
FROM TBS010 P WITH (NOLOCK)
CROSS APPLY (VALUES (P.PROUM1),(P.PROUM2),(P.PROUM3),(P.PROUM4)) U(UnidadeMedida)
CROSS APPLY (SELECT preco1, preco2, preco3, preco4 FROM PrecoLoja(0,P.PROCOD)) PL
LEFT JOIN TBS012 G WITH (NOLOCK) ON P.GRUCOD = G.GRUCOD
--WHERE P.PROCOD IN ('03300132','03300151');

-- Etapa 2: tabela final de exportação
SELECT
    LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
    + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
    + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
    + REPLICATE(' ',20)
    + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
    + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
    + '000000'
    + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
    + RIGHT(REPLICATE('0',4) + LTRIM(STR(PROICMSINT*100,4,0)),4)
    + REPLICATE(' ',65)
    + 'N'
    + IIF(PROPESAVEL='S','N','S')
    + 'N'
    + 'N'
    + 'N'
    + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
    + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
    + '      '
    + REPLICATE(' ',30)
    + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
    + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
    + '     0'
    + REPLICATE(' ',30)
    + '000000'
    + '000000'
    + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)
    + '000000'
    + REPLICATE(' ',20)
    + REPLICATE(' ',20)
    + REPLICATE(' ',20)
    + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))
    + '      '
    + '      '
    + '      '
    + RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6)
    + '      '
    + RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6)
    + '      '
    + 'N'
    + '000000000000'
    + '000'
    + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
    + 'S'
    + REPLICATE(' ',9)
    + 'N'
    + '00000'
    + ' '
    + REPLICATE(' ',20)
    + REPLICATE(' ',10)
    + '0000000'
    + '0000000'
    + '0000000'
    + '000000000000000'
    + 'P'
    + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
    + '000000000000000'
    + REPLICATE(' ',20)
    + '000000'
    + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
INTO ##produtos
FROM ##produtos_intermediate
WHERE preco > 0;

-- gera o arquivo texto dos produtos
exec master.dbo.xp_cmdshell 'bcp "select texto from ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';

-- stored procedure

-- =============================================
-- Author:        Cristiano
-- Create date:   2025-09-17
-- Description:   Exporta produtos para arquivo texto
-- Parameters:    @data_ini, @data_fim
-- =============================================

-- Remove a procedure caso já exista

IF OBJECT_ID('dbo.ExportarProdutos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ExportarProdutos;
GO

CREATE PROCEDURE dbo.ExportarProdutos
    @data_ini DATE,
    @data_fim DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @crt INT;

    -- Obter CRT
    SELECT @crt = EMPCRT
    FROM TBS023 WITH (NOLOCK);

    -- Remover tabela temporária final antiga
    IF OBJECT_ID('tempdb..##produtos') IS NOT NULL
        DROP TABLE ##produtos;

    -- Remover tabela intermediária antiga
    IF OBJECT_ID('tempdb..##produtos_intermediate') IS NOT NULL
        DROP TABLE ##produtos_intermediate;

    -- Etapa 1: tabela intermediária com todos os valores calculados
    ;WITH PrecosComIndice AS (
        -- Produtos principais
        SELECT
            RTRIM(T.PROCOD)
            + IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444', ''))
            ) AS PROCOD,
            T.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
            U.UnidadeMedida,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN 1
                WHEN T.PROUM2 THEN T.PROUM2QTD
                WHEN T.PROUM3 THEN T.PROUM3QTD
                ELSE T.PROUM4QTD
            END AS qtEmbalagem,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
                WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
                WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
                ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
            END AS preco,
            T.PROSTBA,
            T.PROSTBB,
            T.PROCSN,
            
            --ISNULL(T.PROICMSINT,18) AS PROICMSINT,
            CASE 
               WHEN T.PROICMSINT IS NULL OR T.PROICMSINT = 0 THEN 18
               ELSE T.PROICMSINT
            END AS PROICMSINT,

            T.PROPESAVEL,
            T.PROCLAFIS,
            T.PROCEST,
            T.MARCOD,
            T.MARNOM,
            T.GRUCOD,
            ISNULL(G.GRUDES,'') AS GRUDES,
            ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
            1 AS Fonte,
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS010 T WITH (NOLOCK)
        CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)
        --CROSS APPLY (SELECT preco1, preco2, preco3, preco4 FROM PrecoLoja(0,T.PROCOD)) PL
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) PL
    
        LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD
        WHERE T.PRODATCAD BETWEEN @data_ini AND @data_fim

        UNION ALL

        -- Produtos com códigos de barras / múltiplas embalagens
        SELECT
            bar.CBPCODBAR AS PROCOD,
            pro.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(pro.PRODES) AS PRODES,
            IIF(bar.CBPQTDEMB=1, pro.PROUM1, IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2, IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3, IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4, '')))) AS UnidadeMedida,
            bar.CBPQTDEMB AS qtEmbalagem,
            IIF(bar.CBPQTDEMB=1, preco.preco1, bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))) AS preco,
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
            ISNULL((SELECT GRUDES FROM TBS012 g WITH (NOLOCK) WHERE g.GRUCOD=pro.GRUCOD),'') AS GRUDES,
            pro.PROSTBPIS,
            pro.PROSTBCOFINS,
            2 AS Fonte,
            ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) AS preco
        WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB = pro.PROUM2QTD OR bar.CBPQTDEMB = pro.PROUM3QTD OR bar.CBPQTDEMB = pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
    )
    SELECT *
    INTO ##produtos_intermediate
    FROM PrecosComIndice;

    -- Etapa 2: tabela final de exportação
    SELECT
        LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
        + REPLICATE(' ',20)
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
        + '000000'
        + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
        + RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)
        + REPLICATE(' ',65)
        + 'N'
        + IIF(PROPESAVEL='S','N','S')
        + 'N'
        + 'N'
        + 'N'
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
        + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
        + '      '
        + REPLICATE(' ',30)
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
        + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
        + '     0'
        + REPLICATE(' ',30)
        + '000000'
        + '000000'
        + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)
        + '000000'
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))
        + '      '
        + '      '
        + '      '
        + RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6)
        + '      '
        + RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6)
        + '      '
        + 'N'
        + '000000000000'
        + '000'
        + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
        + 'S'
        + REPLICATE(' ',9)
        + 'N'
        + '00000'
        + ' '
        + REPLICATE(' ',20)
        + REPLICATE(' ',10)
        + '0000000'
        + '0000000'
        + '0000000'
        + '000000000000000'
        + 'P'
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + '000000000000000'
        + REPLICATE(' ',20)
        + '000000'
        + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
    INTO ##produtos
    FROM ##produtos_intermediate
    WHERE preco > 0;

    -- Gera o arquivo texto dos produtos
    EXEC master.dbo.xp_cmdshell 'bcp "SELECT texto FROM ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';

END
GO

-- teste

select *
  from ##produtos

EXEC dbo.ExportarProdutos '2000-01-01', '2025-12-01';


-- fim otimização chatGPT

select PROSTBCOFINS
       ,count(*)
  from TBS010 with (nolock)
 group by PROSTBCOFINS
 order by PROSTBCOFINS


-- novo código

IF OBJECT_ID('dbo.ExportarProdutos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ExportarProdutos;
GO

CREATE PROCEDURE dbo.ExportarProdutos
    @data_ini DATE,
    @data_fim DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @crt INT;

    -- Obter CRT
    SELECT @crt = EMPCRT
    FROM TBS023 WITH (NOLOCK);

    -- Remover tabelas temporárias antigas
    IF OBJECT_ID('tempdb..##produtos') IS NOT NULL DROP TABLE ##produtos;
    IF OBJECT_ID('tempdb..##produtos_intermediate') IS NOT NULL DROP TABLE ##produtos_intermediate;

    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    ;WITH ProdutosFiltrados AS (
        SELECT PROCOD
        FROM TBS010 WITH (NOLOCK)
        WHERE PRODATCAD BETWEEN @data_ini AND @data_fim
    )
    , PrecosComIndice AS (
        -- ============================================================
        -- Etapa 1A: Produtos principais
        -- ============================================================
        SELECT
            RTRIM(T.PROCOD)
            + IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444', ''))
            ) AS PROCOD,
            T.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
            U.UnidadeMedida,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN 1
                WHEN T.PROUM2 THEN T.PROUM2QTD
                WHEN T.PROUM3 THEN T.PROUM3QTD
                ELSE T.PROUM4QTD
            END AS qtEmbalagem,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
                WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
                WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
                ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
            END AS preco,
            T.PROSTBA,
            T.PROSTBB,
            T.PROCSN,
            CASE 
               WHEN T.PROICMSINT IS NULL OR T.PROICMSINT = 0 THEN 18
               ELSE T.PROICMSINT
            END AS PROICMSINT,
            T.PROPESAVEL,
            T.PROCLAFIS,
            T.PROCEST,
            T.MARCOD,
            T.MARNOM,
            T.GRUCOD,
            ISNULL(G.GRUDES,'') AS GRUDES,
            ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
            1 AS Fonte,
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) PL
        LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD

        UNION ALL

        -- ============================================================
        -- Etapa 1B: Produtos com códigos de barras / múltiplas embalagens
        -- ============================================================
        SELECT
            bar.CBPCODBAR AS PROCOD,
            pro.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(pro.PRODES) AS PRODES,
            IIF(bar.CBPQTDEMB=1, pro.PROUM1, 
                IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4, '')))) AS UnidadeMedida,
            bar.CBPQTDEMB AS qtEmbalagem,
            IIF(bar.CBPQTDEMB=1, preco.preco1, 
                bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))) AS preco,
            pro.PROSTBA,
            pro.PROSTBB,
            pro.PROCSN,
            CASE 
               WHEN pro.PROICMSINT IS NULL OR pro.PROICMSINT = 0 THEN 18
               ELSE pro.PROICMSINT
            END AS PROICMSINT,
            pro.PROPESAVEL,
            pro.PROCLAFIS,
            pro.PROCEST,
            pro.MARCOD,
            pro.MARNOM,
            pro.GRUCOD,
            ISNULL(GRUDES,'') AS GRUDES,
            ISNULL(pro.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(pro.PROSTBCOFINS,1) AS PROSTBCOFINS,
            2 AS Fonte,
            ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = pro.PROCOD
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) AS preco
        LEFT JOIN TBS012 g WITH (NOLOCK) ON g.GRUCOD = pro.GRUCOD
        WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB = pro.PROUM2QTD OR bar.CBPQTDEMB = pro.PROUM3QTD OR bar.CBPQTDEMB = pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
    )
    SELECT *
    INTO ##produtos_intermediate
    FROM PrecosComIndice;

    -- ============================================================
    -- Etapa 2: tabela final de exportação
    -- ============================================================
    SELECT
        LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
        + REPLICATE(' ',20)
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
        + '000000'
        + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
        + RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)
        + REPLICATE(' ',65)
        + 'N'
        + IIF(PROPESAVEL='S','N','S')
        + 'N'
        + 'N'
        + 'N'
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
        + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
        + '      '
        + REPLICATE(' ',30)
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
        + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
        + '     0'
        + REPLICATE(' ',30)
        + '000000'
        + '000000'
        + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)
        + '000000'
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))
        + '      '
        + '      '
        + '      '
        + RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6)
        + '      '
        + RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6)
        + '      '
        + 'N'
        + '000000000000'
        + '000'
        + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
        + 'S'
        + REPLICATE(' ',9)
        + 'N'
        + '00000'
        + ' '
        + REPLICATE(' ',20)
        + REPLICATE(' ',10)
        + '0000000'
        + '0000000'
        + '0000000'
        + '000000000000000'
        + 'P'
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + '000000000000000'
        + REPLICATE(' ',20)
        + '000000'
        + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
    INTO ##produtos
    FROM ##produtos_intermediate
    WHERE preco > 0;

    -- ============================================================
    -- Exportação via BCP
    -- ============================================================
    EXEC master.dbo.xp_cmdshell 'bcp "SELECT texto FROM ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';

END
GO



/****** Object:  UserDefinedFunction [dbo].[RemoveInvalidChars]    Script Date: 03/12/2025 10:31:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[RemoveInvalidChars] (@input NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    -- Substituição de caracteres
    SET @input = REPLACE(@input, 'Ç', 'C')
    SET @input = REPLACE(@input, 'Ã', 'A')
    SET @input = REPLACE(@input, 'Á', 'A')
    SET @input = REPLACE(@input, 'À', 'A')
    SET @input = REPLACE(@input, 'Â', 'A')
    SET @input = REPLACE(@input, 'Ä', 'A')
    SET @input = REPLACE(@input, 'Å', 'A')
    SET @input = REPLACE(@input, 'Õ', 'O')
    SET @input = REPLACE(@input, 'Ó', 'O')
    SET @input = REPLACE(@input, 'Ò', 'O')
    SET @input = REPLACE(@input, 'Ô', 'O')
    SET @input = REPLACE(@input, 'Ö', 'O')
    SET @input = REPLACE(@input, 'É', 'E')
    SET @input = REPLACE(@input, 'È', 'E')
    SET @input = REPLACE(@input, 'Ê', 'E')
    SET @input = REPLACE(@input, 'Ë', 'E')
    SET @input = REPLACE(@input, 'Í', 'I')
    SET @input = REPLACE(@input, 'Ì', 'I')
    SET @input = REPLACE(@input, 'Î', 'I')
    SET @input = REPLACE(@input, 'Ï', 'I')
    SET @input = REPLACE(@input, 'Ú', 'U')
    SET @input = REPLACE(@input, 'Ù', 'U')
    SET @input = REPLACE(@input, 'Û', 'U')
    SET @input = REPLACE(@input, 'Ü', 'U')
	SET @input = REPLACE(@input, 'Ÿ', 'Y')

    RETURN @input
END
GO


-- exportação rodando atualmente

IF OBJECT_ID('dbo.ExportarProdutos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.ExportarProdutos;
GO

CREATE PROCEDURE [dbo].[ExportarProdutos]
    @data_ini DATE,
    @data_fim DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @crt INT;

    -- Obter CRT
    SELECT @crt = EMPCRT
    FROM TBS023 WITH (NOLOCK);

    -- Remover tabelas temporárias antigas
    IF OBJECT_ID('tempdb..##produtos') IS NOT NULL DROP TABLE ##produtos;
    IF OBJECT_ID('tempdb..##produtos_intermediate') IS NOT NULL DROP TABLE ##produtos_intermediate;

    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    ;WITH ProdutosFiltrados AS (
        SELECT PROCOD
        FROM TBS010 WITH (NOLOCK)
        WHERE PRODATCAD BETWEEN @data_ini AND @data_fim
    )
    , PrecosComIndice AS (
        -- ============================================================
        -- Etapa 1A: Produtos principais
        -- ============================================================
        SELECT
            RTRIM(T.PROCOD)
            + IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444', ''))
            ) AS PROCOD,
            T.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
            U.UnidadeMedida,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN 1
                WHEN T.PROUM2 THEN T.PROUM2QTD
                WHEN T.PROUM3 THEN T.PROUM3QTD
                ELSE T.PROUM4QTD
            END AS qtEmbalagem,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
                WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
                WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
                ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
            END AS preco,
            T.PROSTBA,
            T.PROSTBB,
            T.PROCSN,
            CASE 
               WHEN T.PROICMSINT IS NULL OR T.PROICMSINT = 0 THEN 18
               ELSE T.PROICMSINT
            END AS PROICMSINT,
            T.PROPESAVEL,
            T.PROCLAFIS,
            T.PROCEST,
            T.MARCOD,
            T.MARNOM,
            T.GRUCOD,
            ISNULL(G.GRUDES,'') AS GRUDES,
            ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
            1 AS Fonte,
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) PL
        LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD

        UNION ALL

        -- ============================================================
        -- Etapa 1B: Produtos com códigos de barras / múltiplas embalagens
        -- ============================================================
        SELECT
            bar.CBPCODBAR AS PROCOD,
            pro.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(pro.PRODES) AS PRODES,
            IIF(bar.CBPQTDEMB=1, pro.PROUM1, 
                IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4, '')))) AS UnidadeMedida,
            bar.CBPQTDEMB AS qtEmbalagem,
            IIF(bar.CBPQTDEMB=1, preco.preco1, 
                bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))) AS preco,
            pro.PROSTBA,
            pro.PROSTBB,
            pro.PROCSN,
            CASE 
               WHEN pro.PROICMSINT IS NULL OR pro.PROICMSINT = 0 THEN 18
               ELSE pro.PROICMSINT
            END AS PROICMSINT,
            pro.PROPESAVEL,
            pro.PROCLAFIS,
            pro.PROCEST,
            pro.MARCOD,
            pro.MARNOM,
            pro.GRUCOD,
            ISNULL(GRUDES,'') AS GRUDES,
            ISNULL(pro.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(pro.PROSTBCOFINS,1) AS PROSTBCOFINS,
            2 AS Fonte,
            ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = pro.PROCOD
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=pro.PROCOD) AS preco
        LEFT JOIN TBS012 g WITH (NOLOCK) ON g.GRUCOD = pro.GRUCOD
        WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB = pro.PROUM2QTD OR bar.CBPQTDEMB = pro.PROUM3QTD OR bar.CBPQTDEMB = pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
    )
    SELECT *
    INTO ##produtos_intermediate
    FROM PrecosComIndice;

    -- ============================================================
    -- Etapa 2: tabela final de exportação
    -- ============================================================
    SELECT
        LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
        + REPLICATE(' ',20)
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
        + '000000'
        + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
        + RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)
        + REPLICATE(' ',65)
        + 'N'
        + IIF(PROPESAVEL='S','N','S')
        + 'N'
        + 'N'
        + 'N'
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
        + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
        + '      '
        + REPLICATE(' ',30)
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
        + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
        + '     0'
        + REPLICATE(' ',30)
        + '000000'
        + '000000'
        + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)
        + '000000'
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))
        + '      '
        + '      '
        + '      '
        + RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6)
        + '      '
        + RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6)
        + '      '
        + 'N'
        + '000000000000'
        + '000'
        + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
        + 'S'
        + REPLICATE(' ',9)
        + 'N'
        + '00000'
        + ' '
        + REPLICATE(' ',20)
        + REPLICATE(' ',10)
        + '0000000'
        + '0000000'
        + '0000000'
        + '000000000000000'
        + 'P'
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + '000000000000000'
        + REPLICATE(' ',20)
        + '000000'
        + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
    INTO ##produtos
    FROM ##produtos_intermediate
    WHERE preco > 0;

    -- ============================================================
    -- Exportação via BCP
    -- ============================================================
    EXEC master.dbo.xp_cmdshell 'bcp "SELECT texto FROM ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';

END
GO

EXEC dbo.ExportarProdutos '2026-01-23', '2026-01-26';

-- hobby
EXEC dbo.ExportarProdutos '2026-01-26', '2026-01-26';

-- produto alterados
EXEC dbo.ExportarProdutosAlterados '2026-01-20', '2026-01-23';

-- procedure exportar produtos 23/12/25

USE [SIBD]
GO
/****** Object:  StoredProcedure [dbo].[ExportarProdutos]    Script Date: 23/12/2025 11:55:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ExportarProdutos]
    @data_ini DATE,
    @data_fim DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @crt INT;

    -- Obter CRT
    SELECT @crt = EMPCRT
    FROM TBS023 WITH (NOLOCK);

    -- Remover tabelas temporárias antigas
    IF OBJECT_ID('tempdb..##produtos') IS NOT NULL DROP TABLE ##produtos;
    IF OBJECT_ID('tempdb..##produtos_intermediate') IS NOT NULL DROP TABLE ##produtos_intermediate;

    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    ;WITH ProdutosFiltrados AS (
        SELECT PROCOD
        FROM TBS010 WITH (NOLOCK)
        WHERE PRODATCAD BETWEEN @data_ini AND @data_fim
    )
    , PrecosComIndice AS (
        -- ============================================================
        -- Etapa 1A: Produtos principais
        -- ============================================================
        SELECT
            RTRIM(T.PROCOD)
            + IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444', ''))
            ) AS PROCOD,
            T.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
            U.UnidadeMedida,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN 1
                WHEN T.PROUM2 THEN T.PROUM2QTD
                WHEN T.PROUM3 THEN T.PROUM3QTD
                ELSE T.PROUM4QTD
            END AS qtEmbalagem,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
                WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
                WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
                ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
            END AS preco,
            T.PROSTBA,
            T.PROSTBB,
            T.PROCSN,
            CASE 
               WHEN T.PROICMSINT IS NULL OR T.PROICMSINT = 0 THEN 18
               ELSE T.PROICMSINT
            END AS PROICMSINT,
            T.PROPESAVEL,
            T.PROCLAFIS,
            T.PROCEST,
            T.MARCOD,
            T.MARNOM,
            T.GRUCOD,
            ISNULL(G.GRUDES,'') AS GRUDES,
            ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
            1 AS Fonte,
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) PL
        LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD

        UNION ALL

        -- ============================================================
        -- Etapa 1B: Produtos com códigos de barras / múltiplas embalagens
        -- ============================================================
        SELECT
            bar.CBPCODBAR AS PROCOD,
            pro.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(pro.PRODES) AS PRODES,
            IIF(bar.CBPQTDEMB=1, pro.PROUM1, 
                IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4, '')))) AS UnidadeMedida,
            bar.CBPQTDEMB AS qtEmbalagem,
            IIF(bar.CBPQTDEMB=1, preco.preco1, 
                bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))) AS preco,
            pro.PROSTBA,
            pro.PROSTBB,
            pro.PROCSN,
            CASE 
               WHEN pro.PROICMSINT IS NULL OR pro.PROICMSINT = 0 THEN 18
               ELSE pro.PROICMSINT
            END AS PROICMSINT,
            pro.PROPESAVEL,
            pro.PROCLAFIS,
            pro.PROCEST,
            pro.MARCOD,
            pro.MARNOM,
            pro.GRUCOD,
            ISNULL(GRUDES,'') AS GRUDES,
            ISNULL(pro.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(pro.PROSTBCOFINS,1) AS PROSTBCOFINS,
            2 AS Fonte,
            ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = pro.PROCOD
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=pro.PROCOD) AS preco
        LEFT JOIN TBS012 g WITH (NOLOCK) ON g.GRUCOD = pro.GRUCOD
        WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB = pro.PROUM2QTD OR bar.CBPQTDEMB = pro.PROUM3QTD OR bar.CBPQTDEMB = pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
    )
    SELECT *
    INTO ##produtos_intermediate
    FROM PrecosComIndice;

    -- ============================================================
    -- Etapa 2: tabela final de exportação
    -- ============================================================
    SELECT
        LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
        + REPLICATE(' ',20)
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
        + '000000'
        + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
        + RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)
        + REPLICATE(' ',65)
        + 'N'
        + IIF(PROPESAVEL='S','N','S')
        + 'N'
        + 'N'
        + 'N'
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
        + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
        + '      '
        + REPLICATE(' ',30)
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
        + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
        + '     0'
        + REPLICATE(' ',30)
        + '000000'
        + '000000'
        + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)
        + '000000'
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))
        + '      '
        + '      '
        + '      '
        + iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6))
        + '      '
        + iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6))
        + '      '
        + 'N'
        + '000000000000'
        + '000'
        + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
        + 'S'
        + REPLICATE(' ',9)
        + 'N'
        + '00000'
        + ' '
        + REPLICATE(' ',20)
        + REPLICATE(' ',10)
        + '0000000'
        + '0000000'
        + '0000000'
        + '000000000000000'
        + 'P'
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + '000000000000000'
        + REPLICATE(' ',20)
        + '000000'
        + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
    INTO ##produtos
    FROM ##produtos_intermediate
    WHERE preco > 0;

    -- ============================================================
    -- Exportação via BCP
    -- ============================================================
    EXEC master.dbo.xp_cmdshell 'bcp "SELECT texto FROM ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';

END


-- procedure exportar produtos alterados - 29/12/25

USE [SIBD]
GO
/****** Object:  StoredProcedure [dbo].[ExportarProdutos]    Script Date: 23/12/2025 11:55:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--alter PROCEDURE [dbo].[ExportarProdutosAlterados]
create PROCEDURE [dbo].[ExportarProdutosAlterados]
    @data_ini DATE,
    @data_fim DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @crt INT;

    -- Obter CRT
    SELECT @crt = EMPCRT
    FROM TBS023 WITH (NOLOCK);

    -- Remover tabelas temporárias antigas
    IF OBJECT_ID('tempdb..##produtos') IS NOT NULL DROP TABLE ##produtos;
    IF OBJECT_ID('tempdb..##produtos_intermediate') IS NOT NULL DROP TABLE ##produtos_intermediate;

    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    --;WITH ProdutosFiltrados AS (
        --SELECT PROCOD
        --FROM TBS010 WITH (NOLOCK)
        --WHERE PRODATCAD BETWEEN @data_ini AND @data_fim
    --)


    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    ;WITH ProdutosFiltrados AS (
        /*SELECT PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        Left join TBS0103 bar with (nolock)
               on pro.PROCOD = bar.CBPPROCOD
        WHERE cast(pro.PRODATALT as date) BETWEEN @data_ini AND @data_fim
              or bar.CBPDATALT BETWEEN @data_ini AND @data_fim*/

        SELECT pro.PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD
        WHERE (
        CAST(pro.PRODATALT AS date) BETWEEN @data_ini AND @data_fim
        OR bar.CBPDATALT BETWEEN @data_ini AND @data_fim
        )
    )
    , PrecosComIndice AS (
        -- ============================================================
        -- Etapa 1A: Produtos principais
        -- ============================================================
        SELECT
            RTRIM(T.PROCOD)
            + IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444', ''))
            ) AS PROCOD,
            T.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
            U.UnidadeMedida,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN 1
                WHEN T.PROUM2 THEN T.PROUM2QTD
                WHEN T.PROUM3 THEN T.PROUM3QTD
                ELSE T.PROUM4QTD
            END AS qtEmbalagem,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
                WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
                WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
                ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
            END AS preco,
            T.PROSTBA,
            T.PROSTBB,
            T.PROCSN,
            CASE 
               WHEN T.PROICMSINT IS NULL OR T.PROICMSINT = 0 THEN 18
               ELSE T.PROICMSINT
            END AS PROICMSINT,
            T.PROPESAVEL,
            T.PROCLAFIS,
            T.PROCEST,
            T.MARCOD,
            T.MARNOM,
            T.GRUCOD,
            ISNULL(G.GRUDES,'') AS GRUDES,
            ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
            1 AS Fonte,
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) PL
        LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD

        UNION ALL

        -- ============================================================
        -- Etapa 1B: Produtos com códigos de barras / múltiplas embalagens
        -- ============================================================
        SELECT
            bar.CBPCODBAR AS PROCOD,
            pro.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(pro.PRODES) AS PRODES,
            IIF(bar.CBPQTDEMB=1, pro.PROUM1, 
                IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4, '')))) AS UnidadeMedida,
            bar.CBPQTDEMB AS qtEmbalagem,
            IIF(bar.CBPQTDEMB=1, preco.preco1, 
                bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))) AS preco,
            pro.PROSTBA,
            pro.PROSTBB,
            pro.PROCSN,
            CASE 
               WHEN pro.PROICMSINT IS NULL OR pro.PROICMSINT = 0 THEN 18
               ELSE pro.PROICMSINT
            END AS PROICMSINT,
            pro.PROPESAVEL,
            pro.PROCLAFIS,
            pro.PROCEST,
            pro.MARCOD,
            pro.MARNOM,
            pro.GRUCOD,
            ISNULL(GRUDES,'') AS GRUDES,
            ISNULL(pro.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(pro.PROSTBCOFINS,1) AS PROSTBCOFINS,
            2 AS Fonte,
            ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = pro.PROCOD
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=pro.PROCOD) AS preco
        LEFT JOIN TBS012 g WITH (NOLOCK) ON g.GRUCOD = pro.GRUCOD
        WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB = pro.PROUM2QTD OR bar.CBPQTDEMB = pro.PROUM3QTD OR bar.CBPQTDEMB = pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
    )
    SELECT *
    INTO ##produtos_intermediate
    FROM PrecosComIndice;

    -- ============================================================
    -- Etapa 2: tabela final de exportação
    -- ============================================================
    SELECT
        LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
        + REPLICATE(' ',20)
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
        + '000000'
        + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
        + RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)
        + REPLICATE(' ',65)
        + 'N'
        + IIF(PROPESAVEL='S','N','S')
        + 'N'
        + 'N'
        + 'N'
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
        + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
        + '      '
        + REPLICATE(' ',30)
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
        + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
        + '     0'
        + REPLICATE(' ',30)
        + '000000'
        + '000000'
        + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)
        + '000000'
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))
        + '      '
        + '      '
        + '      '
        + iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6))
        + '      '
        + iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6))
        + '      '
        + 'N'
        + '000000000000'
        + '000'
        + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
        + 'S'
        + REPLICATE(' ',9)
        + 'N'
        + '00000'
        + ' '
        + REPLICATE(' ',20)
        + REPLICATE(' ',10)
        + '0000000'
        + '0000000'
        + '0000000'
        + '000000000000000'
        + 'P'
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + '000000000000000'
        + REPLICATE(' ',20)
        + '000000'
        + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
    INTO ##produtos
    FROM ##produtos_intermediate
    WHERE preco > 0;

    -- ============================================================
    -- Exportação via BCP
    -- ============================================================
    EXEC master.dbo.xp_cmdshell 'bcp "SELECT texto FROM ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';

END

        SELECT PROCOD, PRODATALT
        FROM TBS010 WITH (NOLOCK)
        WHERE PRODATALT BETWEEN '20251201' AND '20251229'


-- procedure exportar produtos alterados - 28/01/2026

-- exporta produtos novos e alterados; códigos de barras novos e alterados

drop procedure dbo.USP_EXPORTAR_PRODUTOS_DJPDV

drop procedure dbo.usp_Exportar_Produtos_DJPDV

USE [SIBD]
GO
/****** Object:  StoredProcedure [dbo].[ExportarProdutos]    Script Date: 23/12/2025 11:55:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--alter PROCEDURE [dbo].[ExportarProdutosAlterados]
--create PROCEDURE [dbo].[usp_Exportar_Produtos_DJPDV]
--create PROCEDURE [dbo].[USP_EXPORTAR_PRODUTOS_DJPDV]
alter procedure [dbo].[usp_Exportar_Produtos_DJPDV]
    @data_ini DATE out,
    @data_fim DATE out
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @crt INT;

    -- Obter CRT
    SELECT @crt = EMPCRT
    FROM TBS023 WITH (NOLOCK);

    declare @cst_pis char(2)
            ,@cst_cofins char(2);

    -- PIS/COFINS
    SELECT @cst_pis     = MAX(CASE WHEN par.PARCHV = 1113 THEN par.PARVAL END),
           @cst_cofins  = MAX(CASE WHEN par.PARCHV = 1114 THEN par.PARVAL END)
      FROM TBS025 par WITH (NOLOCK)
     WHERE par.PARCHV IN (1113, 1114);

    -- Remover tabelas temporárias antigas
    IF OBJECT_ID('tempdb..##produtos') IS NOT NULL DROP TABLE ##produtos;
    IF OBJECT_ID('tempdb..##produtos_intermediate') IS NOT NULL DROP TABLE ##produtos_intermediate;

    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    --;WITH ProdutosFiltrados AS (
        --SELECT PROCOD
        --FROM TBS010 WITH (NOLOCK)
        --WHERE PRODATCAD BETWEEN @data_ini AND @data_fim
    --)


    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    ;WITH ProdutosFiltrados AS (
        /*SELECT PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        Left join TBS0103 bar with (nolock)
               on pro.PROCOD = bar.CBPPROCOD
        WHERE cast(pro.PRODATALT as date) BETWEEN @data_ini AND @data_fim
              or bar.CBPDATALT BETWEEN @data_ini AND @data_fim*/

        SELECT pro.PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD
        WHERE (
        cast(PRODATCAD as date) between  @data_ini AND @data_fim
        or CAST(pro.PRODATALT AS date) BETWEEN @data_ini AND @data_fim
        OR bar.CBPDATALT BETWEEN @data_ini AND @data_fim
        )
    )
    , PrecosComIndice AS (
        -- ============================================================
        -- Etapa 1A: Produtos principais
        -- ============================================================
        SELECT
            RTRIM(T.PROCOD)
            + IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444', ''))
            ) AS PROCOD,
            T.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
            U.UnidadeMedida,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN 1
                WHEN T.PROUM2 THEN T.PROUM2QTD
                WHEN T.PROUM3 THEN T.PROUM3QTD
                ELSE T.PROUM4QTD
            END AS qtEmbalagem,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
                WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
                WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
                ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
            END AS preco,
            T.PROSTBA,
            T.PROSTBB,
            T.PROCSN,
            CASE 
               WHEN T.PROICMSINT IS NULL OR T.PROICMSINT = 0 THEN 18
               ELSE T.PROICMSINT
            END AS PROICMSINT,
            T.PROPESAVEL,
            T.PROCLAFIS,
            T.PROCEST,
            T.MARCOD,
            T.MARNOM,
            T.GRUCOD,
            ISNULL(G.GRUDES,'') AS GRUDES,
            ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
            1 AS Fonte,
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) PL
        LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD

        UNION ALL

        -- ============================================================
        -- Etapa 1B: Produtos com códigos de barras / múltiplas embalagens
        -- ============================================================
        SELECT
            bar.CBPCODBAR AS PROCOD,
            pro.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(pro.PRODES) AS PRODES,
            IIF(bar.CBPQTDEMB=1, pro.PROUM1, 
                IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4, '')))) AS UnidadeMedida,
            bar.CBPQTDEMB AS qtEmbalagem,
            IIF(bar.CBPQTDEMB=1, preco.preco1, 
                bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))) AS preco,
            pro.PROSTBA,
            pro.PROSTBB,
            pro.PROCSN,
            CASE 
               WHEN pro.PROICMSINT IS NULL OR pro.PROICMSINT = 0 THEN 18
               ELSE pro.PROICMSINT
            END AS PROICMSINT,
            pro.PROPESAVEL,
            pro.PROCLAFIS,
            pro.PROCEST,
            pro.MARCOD,
            pro.MARNOM,
            pro.GRUCOD,
            ISNULL(GRUDES,'') AS GRUDES,
            ISNULL(pro.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(pro.PROSTBCOFINS,1) AS PROSTBCOFINS,
            2 AS Fonte,
            ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = pro.PROCOD
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=pro.PROCOD) AS preco
        LEFT JOIN TBS012 g WITH (NOLOCK) ON g.GRUCOD = pro.GRUCOD
        WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB = pro.PROUM2QTD OR bar.CBPQTDEMB = pro.PROUM3QTD OR bar.CBPQTDEMB = pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
    )
    SELECT *
    INTO ##produtos_intermediate
    FROM PrecosComIndice;

    -- ============================================================
    -- Etapa 2: tabela final de exportação
    -- ============================================================
    SELECT
        LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
        + REPLICATE(' ',20)
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
        + '000000'
        + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
        + RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)
        + REPLICATE(' ',65)
        + 'N'
        + IIF(PROPESAVEL='S','N','S')
        + 'N'
        + 'N'
        + 'N'
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
        + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
        + '      '
        + REPLICATE(' ',30)
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
        + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
        + '     0'
        + REPLICATE(' ',30)
        + '000000'
        + '000000'
        + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20) -- 26 NCM
        + '000000'
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6)) -- 31 ID ICMS
        + '      '
        + '      '
        + '      '
        --+ iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6)) -- 35 ID PIS
        + RIGHT(REPLICATE('0',6) + IIF(@crt = 1, '49', IIF(PROSTBPIS = '', LTRIM(STR(@cst_pis)), LTRIM(STR(PROSTBPIS)))),6) -- 35 ID PIS
        + '      '
        --+ iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6))
        + RIGHT(REPLICATE('0',6) + IIF(@crt = 1, '49', IIF(PROSTBCOFINS = '', LTRIM(STR(@cst_cofins)), LTRIM(STR(PROSTBCOFINS)))),6) -- 37 ID COFINS
        + '      '
        + 'N'
        + '000000000000'
        + '000'
        + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
        + 'S'
        + REPLICATE(' ',9)
        + 'N'
        + '00000'
        + ' '
        + REPLICATE(' ',20)
        + REPLICATE(' ',10)
        + '0000000'
        + '0000000'
        + '0000000'
        + '000000000000000'
        + 'P'
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + '000000000000000'
        + REPLICATE(' ',20)
        + '000000'
        + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
    --INTO ##produtos
    FROM ##produtos_intermediate
    WHERE preco > 0;

    --select *
      --from ##produtos;

    -- ============================================================
    -- Exportação via BCP
    -- ============================================================
    --EXEC master.dbo.xp_cmdshell 'bcp "SELECT texto FROM ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';

END

        SELECT pro.PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD
        WHERE (
        cast(PRODATCAD as date) between '20260127' AND '20260128'
        or CAST(pro.PRODATALT AS date) BETWEEN '20260127' AND '20260128'
        OR bar.CBPDATALT BETWEEN '20260127' AND '20260128'
        )

-- produto alterados
EXEC dbo.usp_Exportar_Produtos_DJPDV '20260101', '20260318';

set nocount off
select *
  from TBS001 e with (nolock)


-- teste 

alter procedure [dbo].[usp_Exportar_Produtos_DJPDV]
    @data_ini DATE out,
    @data_fim DATE out
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @crt INT;

    -- Obter CRT
    SELECT @crt = EMPCRT
    FROM TBS023 WITH (NOLOCK);

    -- Remover tabelas temporárias antigas
    IF OBJECT_ID('tempdb..##produtos') IS NOT NULL DROP TABLE ##produtos;
    IF OBJECT_ID('tempdb..##produtos_intermediate') IS NOT NULL DROP TABLE ##produtos_intermediate;

    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    --;WITH ProdutosFiltrados AS (
        --SELECT PROCOD
        --FROM TBS010 WITH (NOLOCK)
        --WHERE PRODATCAD BETWEEN @data_ini AND @data_fim
    --)


    -- ============================================================
    -- Filtro único para produtos cadastrados dentro do período
    -- ============================================================
    ;WITH ProdutosFiltrados AS (
        /*SELECT PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        Left join TBS0103 bar with (nolock)
               on pro.PROCOD = bar.CBPPROCOD
        WHERE cast(pro.PRODATALT as date) BETWEEN @data_ini AND @data_fim
              or bar.CBPDATALT BETWEEN @data_ini AND @data_fim*/

        SELECT pro.PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD
        WHERE (
        cast(PRODATCAD as date) between  @data_ini AND @data_fim
        or CAST(pro.PRODATALT AS date) BETWEEN @data_ini AND @data_fim
        OR bar.CBPDATALT BETWEEN @data_ini AND @data_fim
        )
    )
    , PrecosComIndice AS (
        -- ============================================================
        -- Etapa 1A: Produtos principais
        -- ============================================================
        SELECT
            RTRIM(T.PROCOD)
            + IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',
                IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444', ''))
            ) AS PROCOD,
            T.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
            U.UnidadeMedida,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN 1
                WHEN T.PROUM2 THEN T.PROUM2QTD
                WHEN T.PROUM3 THEN T.PROUM3QTD
                ELSE T.PROUM4QTD
            END AS qtEmbalagem,
            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
                WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
                WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
                ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
            END AS preco,
            T.PROSTBA,
            T.PROSTBB,
            T.PROCSN,
            CASE 
               WHEN T.PROICMSINT IS NULL OR T.PROICMSINT = 0 THEN 18
               ELSE T.PROICMSINT
            END AS PROICMSINT,
            T.PROPESAVEL,
            T.PROCLAFIS,
            T.PROCEST,
            T.MARCOD,
            T.MARNOM,
            T.GRUCOD,
            ISNULL(G.GRUDES,'') AS GRUDES,
            ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
            1 AS Fonte,
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=T.PROCOD) PL
        LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD

        UNION ALL

        -- ============================================================
        -- Etapa 1B: Produtos com códigos de barras / múltiplas embalagens
        -- ============================================================
        SELECT
            bar.CBPCODBAR AS PROCOD,
            pro.PROCOD AS PROCOD_ORIGINAL,
            dbo.RemoveInvalidChars(pro.PRODES) AS PRODES,
            IIF(bar.CBPQTDEMB=1, pro.PROUM1, 
                IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4, '')))) AS UnidadeMedida,
            bar.CBPQTDEMB AS qtEmbalagem,
            IIF(bar.CBPQTDEMB=1, preco.preco1, 
                bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, 
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, 
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))) AS preco,
            pro.PROSTBA,
            pro.PROSTBB,
            pro.PROCSN,
            CASE 
               WHEN pro.PROICMSINT IS NULL OR pro.PROICMSINT = 0 THEN 18
               ELSE pro.PROICMSINT
            END AS PROICMSINT,
            pro.PROPESAVEL,
            pro.PROCLAFIS,
            pro.PROCEST,
            pro.MARCOD,
            pro.MARNOM,
            pro.GRUCOD,
            ISNULL(GRUDES,'') AS GRUDES,
            ISNULL(pro.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(pro.PROSTBCOFINS,1) AS PROSTBCOFINS,
            2 AS Fonte,
            ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = pro.PROCOD
        CROSS APPLY (select preco1, preco2, preco3, preco4 from dbo.vw_PrecoLojaGeral where codigo=pro.PROCOD) AS preco
        LEFT JOIN TBS012 g WITH (NOLOCK) ON g.GRUCOD = pro.GRUCOD
        WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB = pro.PROUM2QTD OR bar.CBPQTDEMB = pro.PROUM3QTD OR bar.CBPQTDEMB = pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
    )
    SELECT *
    INTO ##produtos_intermediate
    FROM PrecosComIndice;

    -- ============================================================
    -- Etapa 2: tabela final de exportação
    -- ============================================================
    SELECT
        LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
        + REPLICATE(' ',20)
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
        + '000000'
        + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
        + RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)
        + REPLICATE(' ',65)
        + 'N'
        + IIF(PROPESAVEL='S','N','S')
        + 'N'
        + 'N'
        + 'N'
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
        + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
        + '      '
        + REPLICATE(' ',30)
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
        + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
        + '     0'
        + REPLICATE(' ',30)
        + '000000'
        + '000000'
        + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)
        + '000000'
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))
        + '      '
        + '      '
        + '      '
        + iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6))
        + '      '
        + iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6))
        + '      '
        + 'N'
        + '000000000000'
        + '000'
        + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
        + 'S'
        + REPLICATE(' ',9)
        + 'N'
        + '00000'
        + ' '
        + REPLICATE(' ',20)
        + REPLICATE(' ',10)
        + '0000000'
        + '0000000'
        + '0000000'
        + '000000000000000'
        + 'P'
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + '000000000000000'
        + REPLICATE(' ',20)
        + '000000'
        + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
    INTO ##produtos
    FROM ##produtos_intermediate
    WHERE preco > 0;

    select *
      from ##produtos;
    -- ============================================================
    -- Exportação via BCP
    -- ============================================================
    --EXEC master.dbo.xp_cmdshell 'bcp "SELECT texto FROM ##produtos" queryout "c:\integros\exporta\djpdv\est.txt" -c -C 1252 -T';

END
go

-- novo

create PROCEDURE [dbo].[usp_Exportar_Produtos_DJPDV]
    @data_ini DATE,
    @data_fim DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @crt INT;

    -- CRT
    SELECT @crt = EMPCRT
    FROM TBS023 WITH (NOLOCK);

    ;WITH ProdutosFiltrados AS (
        SELECT pro.PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        LEFT JOIN TBS0103 bar WITH (NOLOCK)
            ON pro.PROCOD = bar.CBPPROCOD
        WHERE pro.PROCOD = '1640054' /*(
            pro.PRODATCAD BETWEEN @data_ini AND @data_fim
            OR pro.PRODATALT BETWEEN @data_ini AND @data_fim
            OR bar.CBPDATALT BETWEEN @data_ini AND @data_fim
        )*/
    ),
    PrecosComIndice AS (

        -- Produtos principais
        SELECT
            RTRIM(T.PROCOD)
            + IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',
              IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',
              IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444','')))
            AS PROCOD,

            dbo.RemoveInvalidChars(T.PRODES) AS PRODES,

            U.UnidadeMedida,

            CASE U.UnidadeMedida
                WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
                WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
                WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
                ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
            END AS preco,

            T.PROSTBA,
            T.PROSTBB,
            T.PROCSN,
            ISNULL(NULLIF(T.PROICMSINT,0),18) AS PROICMSINT,
            T.PROPESAVEL,
            T.PROCLAFIS,
            T.PROCEST,
            T.MARCOD,
            T.MARNOM,
            T.GRUCOD,
            ISNULL(G.GRUDES,'') AS GRUDES,
            ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
            ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS

        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)
        CROSS APPLY (
            SELECT preco1, preco2, preco3, preco4
            FROM dbo.vw_PrecoLojaGeral
            WHERE codigo=T.PROCOD
        ) PL
        LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD

        UNION ALL

        -- Códigos de barras
        SELECT
            bar.CBPCODBAR,
            dbo.RemoveInvalidChars(pro.PRODES),
            IIF(bar.CBPQTDEMB=1, pro.PROUM1,
                IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2,
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3,
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4,'')))),
            IIF(bar.CBPQTDEMB=1, preco.preco1,
                bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2,
                IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3,
                IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))),

            pro.PROSTBA,
            pro.PROSTBB,
            pro.PROCSN,
            ISNULL(NULLIF(pro.PROICMSINT,0),18),
            pro.PROPESAVEL,
            pro.PROCLAFIS,
            pro.PROCEST,
            pro.MARCOD,
            pro.MARNOM,
            pro.GRUCOD,
            ISNULL(g.GRUDES,''),
            ISNULL(pro.PROSTBPIS,1),
            ISNULL(pro.PROSTBCOFINS,1)

        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = pro.PROCOD
        CROSS APPLY (
            SELECT preco1, preco2, preco3, preco4
            FROM dbo.vw_PrecoLojaGeral
            WHERE codigo=pro.PROCOD
        ) preco
        LEFT JOIN TBS012 g WITH (NOLOCK) ON g.GRUCOD = pro.GRUCOD
        WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB IN (pro.PROUM2QTD,pro.PROUM3QTD,pro.PROUM4QTD))
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
    )

    SELECT
                LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)
        + LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)
        + REPLICATE(' ',20)
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)
        + '000000'
        + IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))
        + RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)
        + REPLICATE(' ',65)
        + 'N'
        + IIF(PROPESAVEL='S','N','S')
        + 'N'
        + 'N'
        + 'N'
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)
        + LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)
        + '      '
        + REPLICATE(' ',30)
        + RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)
        + LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)
        + '     0'
        + REPLICATE(' ',30)
        + '000000'
        + '000000'
        + LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)
        + '000000'
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + REPLICATE(' ',20)
        + IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))
        + '      '
        + '      '
        + '      '
        + iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBPIS)),6))
        + '      '
        + iif(@crt = 1, '000049', RIGHT(REPLICATE('0',6) + LTRIM(STR(PROSTBCOFINS)),6))
        + '      '
        + 'N'
        + '000000000000'
        + '000'
        + IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))
        + 'S'
        + REPLICATE(' ',9)
        + 'N'
        + '00000'
        + ' '
        + REPLICATE(' ',20)
        + REPLICATE(' ',10)
        + '0000000'
        + '0000000'
        + '0000000'
        + '000000000000000'
        + 'P'
        + LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)
        + '000000000000000'
        + REPLICATE(' ',20)
        + '000000'
        + LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) AS texto
    FROM PrecosComIndice
    WHERE preco > 0;

END

-- testes

SELECT pro.PROCOD
        FROM TBS010 pro WITH (NOLOCK)
        LEFT JOIN TBS0103 bar WITH (NOLOCK)
            ON pro.PROCOD = bar.CBPPROCOD
        WHERE (
            pro.PRODATCAD BETWEEN '17530101' AND '20260625'
            OR pro.PRODATALT BETWEEN '17530101' AND '20260625'
            OR bar.CBPDATALT BETWEEN '17530101' AND '20260625'
        )
go

-- código genexus

create PROCEDURE [dbo].[usp_Exportar_Produtos_DJPDV]
    @data_ini DATE,
    @data_fim DATE
AS
BEGIN
    SET NOCOUNT ON;
DECLARE @crt INT; 
					--DECLARE @data_ini DATE = ' + &cdata_de + ';  
					--DECLARE @data_fim DATE = ' + &cdata_ate + '; 
					
					SELECT @crt = EMPCRT FROM TBS023 WITH (NOLOCK); 
					
    				declare @cst_pis char(2), @cst_cofins char(2); 
    				SELECT @cst_pis = MAX(CASE WHEN par.PARCHV = 1113 THEN par.PARVAL END), @cst_cofins = MAX(CASE WHEN par.PARCHV = 1114 THEN par.PARVAL END) 
      				FROM TBS025 par WITH (NOLOCK) 
     				WHERE par.PARCHV IN (1113, 1114); 
					
					;WITH ProdutosFiltrados AS (  
					SELECT pro.PROCOD  
					FROM TBS010 pro WITH (NOLOCK)  
					LEFT JOIN TBS0103 bar WITH (NOLOCK)  
					ON pro.PROCOD = bar.CBPPROCOD  
					WHERE (  
					cast(pro.PRODATCAD as date) BETWEEN @data_ini AND @data_fim  
					OR cast(pro.PRODATALT as date) BETWEEN @data_ini AND @data_fim  
					OR cast(bar.CBPDATALT as date) BETWEEN @data_ini AND @data_fim)),  
					
					PrecosComIndice AS (  
					SELECT  
					RTRIM(T.PROCOD)  
					+ IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2, '2222',  
					IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3, '3333',  
					IIF(ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4, '4444',''))) AS PROCOD,  
					dbo.RemoveInvalidChars(T.PRODES) AS PRODES,  
					U.UnidadeMedida,  
					CASE U.UnidadeMedida  
					WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)  
					WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)  
					WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)  
					ELSE ISNULL(T.PROUM4QTD * PL.preco4,0) END AS preco,  
					T.PROSTBA, T.PROSTBB, T.PROCSN,  
					ISNULL(NULLIF(T.PROICMSINT,0),18) AS PROICMSINT,  
					T.PROPESAVEL, T.PROCLAFIS, T.PROCEST,  
					T.MARCOD, T.MARNOM, T.GRUCOD,  
					ISNULL(G.GRUDES,'') AS GRUDES,  
					ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,  
					ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS  
					FROM TBS010 T WITH (NOLOCK)  
					INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = T.PROCOD  
					CROSS APPLY (VALUES (T.PROUM1),(T.PROUM2),(T.PROUM3),(T.PROUM4)) U(UnidadeMedida)  
					CROSS APPLY (SELECT preco1,preco2,preco3,preco4 FROM dbo.vw_PrecoLojaGeral WHERE codigo=T.PROCOD) PL  
					LEFT JOIN TBS012 G WITH (NOLOCK) ON T.GRUCOD = G.GRUCOD  
	
					UNION ALL  
	
					SELECT  
					bar.CBPCODBAR,  
					dbo.RemoveInvalidChars(pro.PRODES),  
					IIF(bar.CBPQTDEMB=1, pro.PROUM1,  
					IIF(bar.CBPQTDEMB=pro.PROUM2QTD, pro.PROUM2,  
					IIF(bar.CBPQTDEMB=pro.PROUM3QTD, pro.PROUM3,  
					IIF(bar.CBPQTDEMB=pro.PROUM4QTD, pro.PROUM4,'')))),  
					IIF(bar.CBPQTDEMB=1, preco.preco1,  
					bar.CBPQTDEMB * IIF(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2,  
					IIF(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3,  
					IIF(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4,0)))),  
					pro.PROSTBA, pro.PROSTBB, pro.PROCSN,  
					ISNULL(NULLIF(pro.PROICMSINT,0),18),  
					pro.PROPESAVEL, pro.PROCLAFIS, pro.PROCEST,  
					pro.MARCOD, pro.MARNOM, pro.GRUCOD,  
					ISNULL(g.GRUDES,''),  
					ISNULL(pro.PROSTBPIS,1),  
					ISNULL(pro.PROSTBCOFINS,1)  
					FROM TBS0103 bar WITH (NOLOCK)  
					INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD  
					INNER JOIN ProdutosFiltrados PF ON PF.PROCOD = pro.PROCOD  
					CROSS APPLY (SELECT preco1,preco2,preco3,preco4 FROM dbo.vw_PrecoLojaGeral WHERE codigo=pro.PROCOD) preco  
					LEFT JOIN TBS012 g WITH (NOLOCK) ON g.GRUCOD = pro.GRUCOD  
					WHERE (bar.CBPQTDEMB=1 OR bar.CBPQTDEMB IN (pro.PROUM2QTD,pro.PROUM3QTD,pro.PROUM4QTD))  
					AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0  
					AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444'))  
	
					SELECT  
					LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)  
					+ LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20)  
					+ LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40)  
					+ REPLICATE(' ',20)  
					+ LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)  
					+ RIGHT(REPLICATE('0',12) + LTRIM(STR(preco*1000,12,0)),12)  
					+ '000000'  
					+ IIF(@crt=1, dbo.SituacaoTributaria(PROCSN), dbo.SituacaoTributaria(PROSTBB))  
					+ RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18)*100,4,0)),4)  
					+ REPLICATE(' ',65)  
					+ 'N'  
					+ IIF(PROPESAVEL='S','N','S')  
					+ 'N'+'N'+'N'  
					+ RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6)  
					+ LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30)  
					+ '      '  
					+ REPLICATE(' ',30)  
					+ RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6)  
					+ LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30)  
					+ '     0'  
					+ REPLICATE(' ',30)  
					+ '000000000000'  
					+ LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20)  
					+ '000000'  
					+ REPLICATE(' ',20)  
					+ REPLICATE(' ',20)  
					+ REPLICATE(' ',20)  
					+ IIF(@crt=1, RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6), RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6))  
					+ '      ' + '      ' + '      '  
					+ RIGHT(REPLICATE('0',6) + IIF(@crt = 1, '49', IIF(PROSTBPIS = '', LTRIM(STR(@cst_pis)), LTRIM(STR(PROSTBPIS)))),6)  
					+ '      '  
					+ RIGHT(REPLICATE('0',6) + IIF(@crt = 1, '49', IIF(PROSTBCOFINS = '', LTRIM(STR(@cst_cofins)), LTRIM(STR(PROSTBCOFINS)))),6)  
					+ '      '  
					+ 'N'  
					+ '000000000000'  
					+ '000'  
					+ IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7))  
					+ 'S'  
					+ REPLICATE(' ',9)  
					+ 'N'  
					+ '00000'  
					+ ' '  
					+ REPLICATE(' ',20)  
					+ REPLICATE(' ',10)  
					+ '0000000'  
					+ '0000000'  
					+ '0000000'  
					+ '000000000000000'  
					+ 'P'  
					+ LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4)  
					+ '000000000000000'  
					+ REPLICATE(' ',20)  
					+ '000000'  
					+ LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80)  
					AS dados  
					FROM PrecosComIndice  
					WHERE preco > 0;
end
go

-- produto alterados
EXEC dbo.usp_Exportar_Produtos_DJPDV '20000101', '20260514';
go

-- 23/06/26
-- código alteradao para uso da exportação de códigos de barras adicionais

DECLARE @crt INT;
DECLARE @data_ini DATE = '1753-01-01';
DECLARE @data_fim DATE = '2026-06-24';

SELECT @crt = EMPCRT
FROM TBS023 WITH (NOLOCK);

DECLARE @cst_pis CHAR(2),
        @cst_cofins CHAR(2);

SELECT
    @cst_pis = MAX(CASE WHEN par.PARCHV = 1113 THEN par.PARVAL END),
    @cst_cofins = MAX(CASE WHEN par.PARCHV = 1114 THEN par.PARVAL END)
FROM TBS025 par WITH (NOLOCK)
WHERE par.PARCHV IN (1113, 1114);

;WITH ProdutosFiltrados AS
(
    SELECT pro.PROCOD
    FROM TBS010 pro WITH (NOLOCK)
    LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD
    WHERE pro.PROCOD = '1640054'
        --CAST(pro.PRODATCAD AS DATE) BETWEEN @data_ini AND @data_fim
        --OR CAST(pro.PRODATALT AS DATE) BETWEEN @data_ini AND @data_fim
        --OR CAST(bar.CBPDATALT AS DATE) BETWEEN @data_ini AND @data_fim
),
PrecosComIndice AS
(
    SELECT
        RTRIM(T.PROCOD) +
        CASE
            WHEN ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2 THEN '2222'
            WHEN ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3 THEN '3333'
            WHEN ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4 THEN '4444'
            ELSE ''
        END AS PROCOD,

        dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
        U.UnidadeMedida,

        CASE U.UnidadeMedida
            WHEN T.PROUM1 THEN ISNULL(PL.preco1, 0)
            WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2, 0)
            WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3, 0)
            ELSE ISNULL(T.PROUM4QTD * PL.preco4, 0)
        END AS preco,

        T.PROSTBA,
        T.PROSTBB,
        T.PROCSN,
        ISNULL(NULLIF(T.PROICMSINT, 0), 18) AS PROICMSINT,
        T.PROPESAVEL,
        T.PROCLAFIS,
        T.PROCEST,
        T.MARCOD,
        T.MARNOM,
        T.GRUCOD,
        ISNULL(G.GRUDES, '') AS GRUDES,
        ISNULL(T.PROSTBPIS, 1) AS PROSTBPIS,
        ISNULL(T.PROSTBCOFINS, 1) AS PROSTBCOFINS
        ,trib.cClassTrib

    FROM TBS010 T WITH (NOLOCK)
    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = T.PROCOD

    CROSS APPLY
    (
        VALUES
            (T.PROUM1),
            (T.PROUM2),
            (T.PROUM3),
            (T.PROUM4)
    ) U(UnidadeMedida)

    CROSS APPLY
    (
        SELECT preco1, preco2, preco3, preco4
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = T.PROCOD
    ) PL

    LEFT JOIN TBS012 G WITH (NOLOCK)
        ON T.GRUCOD = G.GRUCOD

    OUTER APPLY dbo.fn_RetornaTributacaoProduto(0, T.PROCOD) trib

    UNION ALL

    SELECT
        bar.CBPCODBAR,

        dbo.RemoveInvalidChars(pro.PRODES),

        CASE
            WHEN bar.CBPQTDEMB = 1 THEN pro.PROUM1
            WHEN bar.CBPQTDEMB = pro.PROUM2QTD THEN pro.PROUM2
            WHEN bar.CBPQTDEMB = pro.PROUM3QTD THEN pro.PROUM3
            WHEN bar.CBPQTDEMB = pro.PROUM4QTD THEN pro.PROUM4
            ELSE ''
        END,

        CASE
            WHEN bar.CBPQTDEMB = 1 THEN preco.preco1
            ELSE bar.CBPQTDEMB *
                 CASE
                    WHEN bar.CBPQTDEMB = pro.PROUM2QTD THEN preco.preco2
                    WHEN bar.CBPQTDEMB = pro.PROUM3QTD THEN preco.preco3
                    WHEN bar.CBPQTDEMB = pro.PROUM4QTD THEN preco.preco4
                    ELSE 0
                 END
        END,

        pro.PROSTBA,
        pro.PROSTBB,
        pro.PROCSN,
        ISNULL(NULLIF(pro.PROICMSINT, 0), 18),
        pro.PROPESAVEL,
        pro.PROCLAFIS,
        pro.PROCEST,
        pro.MARCOD,
        pro.MARNOM,
        pro.GRUCOD,
        ISNULL(g.GRUDES, ''),
        ISNULL(pro.PROSTBPIS, 1),
        ISNULL(pro.PROSTBCOFINS, 1)
        ,trib.cClassTrib

    FROM TBS0103 bar WITH (NOLOCK)

    INNER JOIN TBS010 pro WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD

    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = pro.PROCOD

    CROSS APPLY
    (
        SELECT preco1, preco2, preco3, preco4
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = pro.PROCOD
    ) preco

    LEFT JOIN TBS012 g WITH (NOLOCK)
        ON g.GRUCOD = pro.GRUCOD

    OUTER APPLY dbo.fn_RetornaTributacaoProduto(0, pro.PROCOD) trib

    WHERE
        (bar.CBPQTDEMB = 1
         OR bar.CBPQTDEMB IN
            (
                pro.PROUM2QTD,
                pro.PROUM3QTD,
                pro.PROUM4QTD
            ))
        AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
        AND RIGHT(RTRIM(bar.CBPCODBAR), 4) NOT IN ('2222', '3333', '4444')
)

SELECT
    LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20) +  -- 1
    LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20) +  -- 2
    LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40) +  -- 3
    REPLICATE(' ',20) +  -- 4
    LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4) +  -- 5
    RIGHT(REPLICATE('0',12) + LTRIM(STR(preco * 1000,12,0)),12) +  -- 6
    '000000' +  -- 7
    IIF(@crt = 1,
        dbo.SituacaoTributaria(PROCSN),
        dbo.SituacaoTributaria(PROSTBB)) +  -- 8
    RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18) * 100,4,0)),4) +  -- 9
    REPLICATE(' ',65) +  -- 10
    'N' +  -- 11
    IIF(PROPESAVEL='S','N','S') +  -- 12
    'NNN' +  -- 13, 14, 15
    RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6) +  -- 16
    LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30) + -- 17
    '      ' + -- 18
    REPLICATE(' ',30) + -- 19
    RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6) + -- 20
    LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30) + -- 21
    '     0' +  -- 22
    REPLICATE(' ',30) + -- 23
    '000000000000' +  -- 24, 25
    LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20) + -- 26
    '000000' +  -- 27
    REPLICATE(' ',20) +  -- 28
    REPLICATE(' ',20) +  -- 29
    REPLICATE(' ',20) +  -- 30
    --IIF(@crt=1,
        --RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6),
        --RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6)
    --) +
    '000001' +  -- 31
    '      ' +  -- 32
    '      ' +  -- 33
    '      ' +  -- 34
    RIGHT(
        REPLICATE('0',6) +
        IIF(@crt = 1,
            '49',
            IIF(PROSTBPIS = '',
                LTRIM(STR(@cst_pis)),
                LTRIM(STR(PROSTBPIS))
            )
        ),
        6
    ) +  -- 35
    '      ' +  -- 36
    RIGHT(
        REPLICATE('0',6) +
        IIF(@crt = 1,
            '49',
            IIF(PROSTBCOFINS = '',
                LTRIM(STR(@cst_cofins)),
                LTRIM(STR(PROSTBCOFINS))
            )
        ),
        6
    ) +  -- 37
    '      ' +  -- 38
    'N' +  -- 39
    '000000000000' +  -- 40
    '000' +  -- 41
    IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7)) +  -- 42
    'S' +  -- 43
    REPLICATE(' ',9) +  -- 44
    'N' +  -- 45
    '00000' +  -- 46
    ' ' +  -- 47
    REPLICATE(' ',20) +  -- 48
    REPLICATE(' ',10) +  -- 49
    '0000000' +  -- 50
    '0000000' +  -- 51
    '0000000' +  -- 52
    '000000000000000' +  -- 53
    'P' +  -- 54
    LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4) +  -- 55
    '000000000000000' +  -- 56
    REPLICATE(' ',20) +  -- 57
    '000000' +  -- 58
    LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) +  -- 59
    replicate('0',4) +  -- 60
    replicate('0',7) +  -- 61
    cClassTrib
    AS dados
FROM PrecosComIndice
WHERE preco > 0;

RetornaTributacaoProduto

select * from dbo.fn_RetornaTributacaoProduto(0, '1640054')



-- exportar códigos de barras adicionais djpdv (23/06/26)

DECLARE @Metodo VARCHAR(10) = 'POST';
DECLARE @DataDe DATE = '2025-11-24';
DECLARE @DataAte DATE = '2025-11-24';

IF OBJECT_ID('tempdb..#Produtos') IS NOT NULL
    DROP TABLE #Produtos;

CREATE TABLE #Produtos
(
    PROCOD VARCHAR(20),
    PRODES VARCHAR(40)
);

INSERT INTO #Produtos
(
    PROCOD,
    PRODES
)
SELECT DISTINCT
    pro.PROCOD,
    LEFT(
        CASE
            WHEN ISNULL(pro.PRODESPDV, '') = ''
                THEN LTRIM(pro.PRODES)
            ELSE LTRIM(pro.PRODESPDV)
        END,
        40
    )
FROM TBS0103 bar WITH (NOLOCK)
INNER JOIN TBS010 pro WITH (NOLOCK)
    ON pro.PROCOD = bar.CBPPROCOD
INNER JOIN dbo.vw_PrecoLojaGeral pre
    ON pre.codigo = bar.CBPPROCOD
WHERE pro.TGZCOD > 0
  AND pre.custo > 0
  AND
  (
        @DataDe IS NULL

        OR
        (
            UPPER(@Metodo) = 'POST'
            AND
            (
                (
                    pro.PRODATCAD >= @DataDe
                    AND (@DataAte IS NULL OR pro.PRODATCAD <= @DataAte)
                )
                OR
                (
                    CAST(pro.PRODATIMP AS DATE) >= @DataDe
                    AND (@DataAte IS NULL OR CAST(pro.PRODATIMP AS DATE) <= @DataAte)
                )
                OR
                (
                    bar.CBPDATCAD >= @DataDe
                    AND (@DataAte IS NULL OR bar.CBPDATCAD <= @DataAte)
                )
            )
        )

        OR

        (
            UPPER(@Metodo) = 'PATCH'
            AND
            (
                (
                    CAST(pro.PRODATALT AS DATE) >= @DataDe
                    AND (@DataAte IS NULL OR CAST(pro.PRODATALT AS DATE) <= @DataAte)
                )
                OR
                (
                    CAST(pro.PRODATIMP AS DATE) >= @DataDe
                    AND (@DataAte IS NULL OR CAST(pro.PRODATIMP AS DATE) <= @DataAte)
                )
                OR
                (
                    pre.atualizado >= @DataDe
                    AND (@DataAte IS NULL OR pre.atualizado <= @DataAte)
                )
                OR
                (
                    bar.CBPDATALT >= @DataDe
                    AND (@DataAte IS NULL OR bar.CBPDATALT <= @DataAte)
                )
            )
        )
    );

SELECT
    Left(LTRIM(RTRIM(pro.PROCOD)) + replicate(' ',20),20) AS codigoProduto,
    --LTRIM(STR(CAST(pro.PROCOD AS BIGINT))) AS codigoProduto,
    Left(LTRIM(RTRIM(bar.barras)) + replicate(' ',20),20) AS codigoBarras,
    pro.PRODES AS descricao,
    '[3]' AS lojas,
    ROUND(bar.preco, 3) AS preco,
    ROUND(bar.embalagem, 3) AS quantidade
FROM dbo.vw_TabelaCodigosBarrasGZ bar
INNER JOIN #Produtos pro
    ON pro.PROCOD = bar.codigo COLLATE DATABASE_DEFAULT
ORDER BY bar.codigo;

DROP TABLE #Produtos;


-- atual rodando na hobby home - 25/06/26

drop table #produtos
go

DECLARE @crt INT;
DECLARE @data_ini DATE = '2026-08-28';
DECLARE @data_fim DATE = '2026-08-31';

SELECT @crt = EMPCRT
FROM TBS023 WITH (NOLOCK);

DECLARE @cst_pis CHAR(2),
        @cst_cofins CHAR(2);

SELECT
    @cst_pis = MAX(CASE WHEN par.PARCHV = 1113 THEN par.PARVAL END),
    @cst_cofins = MAX(CASE WHEN par.PARCHV = 1114 THEN par.PARVAL END)
FROM TBS025 par WITH (NOLOCK)
WHERE par.PARCHV IN (1113,1114);

;WITH ProdutosFiltrados AS
(
    SELECT distinct pro.PROCOD
    FROM TBS010 pro WITH (NOLOCK)
    LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON bar.CBPPROCOD = pro.PROCOD
    left join dbo.vw_PrecoLojaGeral pre on pre.codigo = pro.PROCOD
    WHERE --pro.PROCOD in ('16200133','0950106','0950112','0950121','')
          --pro.MARCOD = 117
          --pro.PROSTBB = '41'

    --pro.PROCOD = '77260002'
        (CAST(pro.PRODATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(pro.PRODATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(bar.CBPDATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(bar.CBPDATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        or (pre.atualizado between @data_ini AND @data_fim)
),
PrecosComIndice AS
(
    SELECT
        RTRIM(T.PROCOD)
        + IIF(
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2,'2222',
            IIF(
                ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3,'3333',
                IIF(
                    ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4,'4444',''
                )
            )
        ) AS PROCOD,
        dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
        U.UnidadeMedida,
        CASE U.UnidadeMedida
            WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
            WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
            WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
            ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
        END AS preco,
        T.PROSTBA,
        T.PROSTBB,
        T.PROCSN,
        ISNULL(NULLIF(T.PROICMSINT,0),18) AS PROICMSINT,
        T.PROPESAVEL,
        T.PROCLAFIS,
        T.PROCEST,
        T.MARCOD,
        T.MARNOM,
        T.GRUCOD,
        ISNULL(G.GRUDES,'') AS GRUDES,
        ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
        ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS
        ,trib.cClassTrib
        ,RTRIM(T.PROCOD) as codExterno

    FROM TBS010 T WITH (NOLOCK)
    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = T.PROCOD
    CROSS APPLY
    (
        VALUES
            (T.PROUM1),
            (T.PROUM2),
            (T.PROUM3),
            (T.PROUM4)
    ) U(UnidadeMedida)
    CROSS APPLY
    (
        SELECT preco1, preco2, preco3, preco4
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = T.PROCOD
    ) PL
    LEFT JOIN TBS012 G WITH (NOLOCK)
        ON T.GRUCOD = G.GRUCOD

    OUTER APPLY dbo.fn_RetornaTributacaoProduto(0, T.PROCOD) trib

    UNION ALL

    SELECT
        bar.CBPCODBAR,
        dbo.RemoveInvalidChars(pro.PRODES),
        IIF(
            bar.CBPQTDEMB = 1, pro.PROUM1,
            IIF(
                bar.CBPQTDEMB = pro.PROUM2QTD, pro.PROUM2,
                IIF(
                    bar.CBPQTDEMB = pro.PROUM3QTD, pro.PROUM3,
                    IIF(
                        bar.CBPQTDEMB = pro.PROUM4QTD, pro.PROUM4, ''
                    )
                )
            )
        ),
        IIF(
            bar.CBPQTDEMB = 1, preco.preco1,
            bar.CBPQTDEMB *
            IIF(
                bar.CBPQTDEMB = pro.PROUM2QTD, preco.preco2,
                IIF(
                    bar.CBPQTDEMB = pro.PROUM3QTD, preco.preco3,
                    IIF(
                        bar.CBPQTDEMB = pro.PROUM4QTD, preco.preco4, 0
                    )
                )
            )
        ),
        pro.PROSTBA,
        pro.PROSTBB,
        pro.PROCSN,
        ISNULL(NULLIF(pro.PROICMSINT,0),18),
        pro.PROPESAVEL,
        pro.PROCLAFIS,
        pro.PROCEST,
        pro.MARCOD,
        pro.MARNOM,
        pro.GRUCOD,
        ISNULL(g.GRUDES,''),
        ISNULL(pro.PROSTBPIS,1),
        ISNULL(pro.PROSTBCOFINS,1)
        ,trib.cClassTrib
        ,bar.CBPPROCOD

    FROM TBS0103 bar WITH (NOLOCK)
    INNER JOIN TBS010 pro WITH (NOLOCK)
     ON pro.PROCOD = bar.CBPPROCOD
    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = pro.PROCOD
    CROSS APPLY
    (
        SELECT preco1, preco2, preco3, preco4
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = pro.PROCOD
    ) preco
    LEFT JOIN TBS012 g WITH (NOLOCK)
        ON g.GRUCOD = pro.GRUCOD

    OUTER APPLY dbo.fn_RetornaTributacaoProduto(0, pro.PROCOD) trib
    
    WHERE
        (
            bar.CBPQTDEMB = 1
            OR bar.CBPQTDEMB IN
            (
                pro.PROUM2QTD,
                pro.PROUM3QTD,
                pro.PROUM4QTD
            )
        )
        AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
        AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
)

SELECT
    --LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20) +  -- 1
    LEFT(LTRIM(RTRIM(codExterno)) + REPLICATE(' ',20),20) +  -- 1
    LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20) +  -- 2
    LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40) +  -- 3
    --REPLICATE(' ',20) +  -- 4

    Left(isnull((select top 1 rtrim(TextoEmbalagem) from dbo.fn_ObterEmbalagensProduto(rtrim(codExterno)) as emb where emb.UnidadeMedida = PrecosComIndice.UnidadeMedida),'') + replicate(' ',20),20) +

    LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4) +  -- 5
    RIGHT(REPLICATE('0',12) + LTRIM(STR(preco * 1000,12,0)),12) +  -- 6
    '000000' +  -- 7
    IIF(@crt = 1,
        dbo.SituacaoTributaria(PROCSN),
        dbo.SituacaoTributaria(PROSTBB)) +  -- 8
    RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18) * 100,4,0)),4) +  -- 9
    REPLICATE(' ',65) +  -- 10
    'N' +  -- 11
    IIF(PROPESAVEL='S' or UnidadeMedida in('KG','MT'),'N','S') +  -- 12  iif(pro.PROUM1 in('KG','MT'),'N','S') as soInteiro 
    'NNN' +  -- 13, 14, 15
    RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6) +  -- 16
    LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30) + -- 17
    '      ' + -- 18
    REPLICATE(' ',30) + -- 19
    RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6) + -- 20
    LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30) + -- 21
    '     0' +  -- 22
    REPLICATE(' ',30) + -- 23
    '000000000000' +  -- 24, 25
    LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20) + -- 26
    '000000' +  -- 27
    REPLICATE(' ',20) +  -- 28
    REPLICATE(' ',20) +  -- 29
    REPLICATE(' ',20) +  -- 30
    --IIF(@crt=1,
        --RIGHT(REPLICATE(' ',6) + LTRIM(PROCSN),6),
        --RIGHT(REPLICATE(' ',6) + '9' + LTRIM(PROSTBA + PROSTBB),6)
    --) +
    '000001' +  -- 31
    '      ' +  -- 32
    '      ' +  -- 33
    '      ' +  -- 34
    RIGHT(
        REPLICATE('0',6) +
        IIF(@crt = 1,
            '49',
            IIF(PROSTBPIS = '',
                LTRIM(STR(@cst_pis)),
                LTRIM(STR(PROSTBPIS))
            )
        ),
        6
    ) +  -- 35
    '      ' +  -- 36
    RIGHT(
        REPLICATE('0',6) +
        IIF(@crt = 1,
            '49',
            IIF(PROSTBCOFINS = '',
                LTRIM(STR(@cst_cofins)),
                LTRIM(STR(PROSTBCOFINS))
            )
        ),
        6
    ) +  -- 37
    '      ' +  -- 38
    'N' +  -- 39
    '000000000000' +  -- 40
    '000' +  -- 41
    IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7)) +  -- 42
    'S' +  -- 43
    REPLICATE(' ',9) +  -- 44
    'N' +  -- 45
    '00000' +  -- 46
    ' ' +  -- 47
    REPLICATE(' ',20) +  -- 48
    --REPLICATE(' ',10) +  -- 49
    --IIF(PROSTBB = '20', 'SP020300  ', IIF(PROSTBB IN ('40','41'), 'SP099999  ', REPLICATE(' ',10))) +  -- 49
    IIF(PROSTBB IN ('40','41'), 'SP099999  ', REPLICATE(' ',10)) +  -- 49
    '0000000' +  -- 50
    '0000000' +  -- 51
    '0000000' +  -- 52
    '000000000000000' +  -- 53
    'P' +  -- 54
    LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4) +  -- 55
    '000000000000000' +  -- 56
    REPLICATE(' ',20) +  -- 57
    '000000' +  -- 58
    LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) +  -- 59
    replicate('0',4) +  -- 60
    replicate('0',7) +  -- 61
    cClassTrib
    AS dados
FROM PrecosComIndice
WHERE preco > 0;

and PROSTBB in ('40','41');

and (PROSTBB in ('20','40','41')
     or exists (select 1 from PRO_EXCLUIDOS_ST_01_JUL_2026 st with (nolock) where st.PROCOD = PrecosComIndice.PROCOD))
;

select *
  from #produtos
 where PROCOD Like ('1640054%') or PROCOD in ('1640054','7891191003733','7891191003740','7891191004129','7891191004136')

select dbo.SituacaoTributaria('500')

select '''' + rtrim(p.PROCOD) + ''','
  from TBS010 p with (nolock)
 where p.PROSTBB in ('40','41')

select *
  from TBS010 p with (nolock)
 where p.PRODATCAD = '20260707'

-- preços djpv

DECLARE @DataDe DATE = '2026-08-10'
DECLARE @DataAte DATE = '2026-08-10'

					;WITH ProdutosAtualizados AS (
					SELECT DISTINCT
					T.PROCOD
					FROM TBS010 T WITH (NOLOCK)
					cross apply (
					select cast(atualizado as date) as atualizado
					from dbo.vw_PrecoLojaGeral
					where codigo = T.PROCOD
					) as P
					WHERE P.atualizado BETWEEN @DataDe AND @DataAte
					),
					PrecosComIndice AS (
					SELECT  
					PROCOD = RTRIM(T.PROCOD) +  
					CASE ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) 
					WHEN 2 THEN '2222'
					WHEN 3 THEN '3333'
					WHEN 4 THEN '4444'
					ELSE ''
					END, 
					preco = CASE  
					WHEN T.PROUM1 = UMs.UnidadeMedida THEN P.preco1 
					WHEN T.PROUM2 = UMs.UnidadeMedida THEN T.PROUM2QTD * P.preco2 
					WHEN T.PROUM3 = UMs.UnidadeMedida THEN T.PROUM3QTD * P.preco3 
					WHEN T.PROUM4 = UMs.UnidadeMedida THEN T.PROUM4QTD * P.preco4 
					ELSE 0 
					END 
					FROM TBS010 T WITH (NOLOCK) 
					INNER JOIN ProdutosAtualizados A ON A.PROCOD = T.PROCOD 
					CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2), (T.PROUM3), (T.PROUM4)) AS UMs(UnidadeMedida) 
					cross apply ( 
					select preco1, preco2, preco3, preco4 
					from dbo.vw_PrecoLojaGeral 
					where codigo = T.PROCOD 
					) as P 
					WHERE UMs.UnidadeMedida <> '' 
					UNION ALL 
					SELECT  
					PROCOD = bar.CBPCODBAR,
					preco = CASE  
					WHEN bar.CBPQTDEMB = 1 THEN preco.preco1 
					WHEN bar.CBPQTDEMB = pro.PROUM2QTD THEN bar.CBPQTDEMB * preco.preco2 
					WHEN bar.CBPQTDEMB = pro.PROUM3QTD THEN bar.CBPQTDEMB * preco.preco3 
					WHEN bar.CBPQTDEMB = pro.PROUM4QTD THEN bar.CBPQTDEMB * preco.preco4 
					ELSE 0 
					END 
					FROM TBS0103 bar WITH (NOLOCK) 
					INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD 
					INNER JOIN ProdutosAtualizados A ON A.PROCOD = pro.PROCOD 
					cross apply ( 
					select preco1, preco2, preco3, preco4 
					from dbo.vw_PrecoLojaGeral 
					where codigo = pro.PROCOD 
					) as preco 
					WHERE bar.CBPQTDEMB IN (1, pro.PROUM2QTD, pro.PROUM3QTD, pro.PROUM4QTD) 
					AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0 
					AND RIGHT(RTRIM(bar.CBPCODBAR), 4) NOT IN ('2222','3333','4444') 
					) 
					SELECT  
					dados = LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ', 20), 20) + 
					RIGHT(REPLICATE('0', 12) + LTRIM(STR(ISNULL(preco, 0) * 1000, 12, 0)), 12) 
					FROM PrecosComIndice 
					WHERE preco > 0; 

-- lista de preços atualizados

select pre.TDPEMPCOD
       ,pre.TDPPROCOD
       ,cast(pre.TDPDATATU as date)
	   ,Left(convert(varchar(8), pre.TDPDATATU, 108), 5)
       ,pre.TDPPRELOJ1
	   ,pre.TDPPRELOJ2
	   ,case when pre.TDPPROLOJ = 'S' and cast(getdate() as date) between pre.TDPVALPROI and pre.TDPVALPROF
           then pre.TDPPREPRO1
           else pre.TDPPRELOJ1
		end
	   ,case when pre.TDPPROLOJ = 'S' and cast(getdate() as date) between pre.TDPVALPROI and pre.TDPVALPROF
           then pre.TDPPREPRO2
           else pre.TDPPRELOJ2
		end
  from TBS031 pre with (nolock)
 where cast(pre.TDPDATATU as date) = '20260714'

-- pesquisa preços

select *
  from dbo.vw_PrecoLojaGeral
 where codigo = '1170169'

go

IF OBJECT_ID('dbo.fn_ObterEmbalagensProduto', 'IF') IS NOT NULL
    DROP FUNCTION dbo.fn_ObterEmbalagensProduto;
GO

CREATE FUNCTION dbo.fn_ObterEmbalagensProduto
(
    @PROCOD VARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
    WITH DadosProduto AS (
        SELECT 
            PROCOD,
            PROUM1, ISNULL(PROUM1QTD, 0) AS PROUM1QTD,
            PROUM2, ISNULL(PROUM2QTD, 0) AS PROUM2QTD,
            PROUM3, ISNULL(PROUM3QTD, 0) AS PROUM3QTD,
            PROUM4, ISNULL(PROUM4QTD, 0) AS PROUM4QTD,
            ISNULL(PROUMV, '') AS PROUMV,

            -- Cálculos auxiliares de divisão de quantidades
            CASE WHEN ISNULL(PROUM2QTD, 0) > 0 THEN ISNULL(PROUM3QTD, 0) / PROUM2QTD ELSE 0 END AS QTD32,
            CASE WHEN ISNULL(PROUM3QTD, 0) > 0 THEN ISNULL(PROUM4QTD, 0) / PROUM3QTD ELSE 0 END AS QTD43
        FROM TBS010
        WHERE PROCOD = @PROCOD
    )
    SELECT 
        Nivel,
        UnidadeMedida,
        Quantidade,
        TextoEmbalagem
    FROM (
        ------------------------------------------------------------------
        -- NIVEL 1: PROUM1
        ------------------------------------------------------------------
        SELECT 
            1 AS Nivel,
            PROUM1 AS UnidadeMedida,
            CAST(1.0000 AS DECIMAL(18,4)) AS Quantidade,
            CASE 
                WHEN PROUM1 IS NULL OR PROUM1 = '' THEN NULL
                WHEN PROUM1QTD > 1 THEN --'(' + 
                    CASE 
                        WHEN PROUM1QTD - FLOOR(PROUM1QTD) > 0 THEN LTRIM(STR(PROUM1QTD, 18, 3))
                        ELSE LTRIM(STR(FLOOR(PROUM1QTD), 10, 0))
                    END + '-' + PROUMV --+ ')'
                ELSE '1' -- Alteração feita conforme sua solicitação
            END AS TextoEmbalagem
        FROM DadosProduto

        UNION ALL

        ------------------------------------------------------------------
        -- NIVEL 2: PROUM2
        ------------------------------------------------------------------
        SELECT 
            2 AS Nivel,
            PROUM2 AS UnidadeMedida,
            CAST(PROUM2QTD AS DECIMAL(18,4)) AS Quantidade,
            CASE 
                WHEN PROUM2 IS NULL OR PROUM2 = '' THEN NULL
                ELSE --'(' + 
                    CASE 
                        WHEN PROUM2QTD - FLOOR(PROUM2QTD) > 0 THEN LTRIM(STR(PROUM2QTD, 18, 3))
                        ELSE LTRIM(STR(FLOOR(PROUM2QTD), 10, 0))
                    END + '-' + PROUM1 +
                    CASE 
                        WHEN PROUM1QTD > 1 THEN ' ' + 
                            CASE 
                                WHEN PROUM1QTD - FLOOR(PROUM1QTD) > 0 THEN LTRIM(STR(PROUM1QTD, 18, 3))
                                ELSE LTRIM(STR(FLOOR(PROUM1QTD), 10, 0))
                            END + '-' + PROUMV
                        ELSE ''
                    END --+ ')'
            END AS TextoEmbalagem
        FROM DadosProduto

        UNION ALL

        ------------------------------------------------------------------
        -- NIVEL 3: PROUM3
        ------------------------------------------------------------------
        SELECT 
            3 AS Nivel,
            PROUM3 AS UnidadeMedida,
            CAST(PROUM3QTD AS DECIMAL(18,4)) AS Quantidade,
            CASE 
                WHEN PROUM3 IS NULL OR PROUM3 = '' THEN NULL
                ELSE --'(' + 
                    CASE 
                        WHEN PROUM3QTD - FLOOR(PROUM3QTD) > 0 THEN LTRIM(STR(PROUM3QTD, 6, 3))
                        ELSE LTRIM(STR(FLOOR(QTD32), 10, 0))
                    END + '-' + PROUM2 + ' ' +
                    CASE 
                        WHEN PROUM2QTD - FLOOR(PROUM2QTD) > 0 THEN LTRIM(STR(PROUM2QTD, 18, 3))
                        ELSE LTRIM(STR(FLOOR(PROUM2QTD), 10, 0))
                    END + '-' + PROUM1 +
                    CASE 
                        WHEN PROUM1QTD > 1 THEN --' ' + 
                            CASE 
                                WHEN PROUM1QTD - FLOOR(PROUM1QTD) > 0 THEN LTRIM(STR(PROUM1QTD, 18, 3))
                                ELSE LTRIM(STR(FLOOR(PROUM1QTD), 10, 0))
                            END + PROUMV
                        ELSE ''
                    END --+ ')'
            END AS TextoEmbalagem
        FROM DadosProduto

        UNION ALL

        ------------------------------------------------------------------
        -- NIVEL 4: PROUM4
        ------------------------------------------------------------------
        SELECT 
            4 AS Nivel,
            PROUM4 AS UnidadeMedida,
            CAST(PROUM4QTD AS DECIMAL(18,4)) AS Quantidade,
            CASE 
                WHEN PROUM4 IS NULL OR PROUM4 = '' THEN NULL
                ELSE --'(' + 
                    CASE 
                        WHEN PROUM3QTD - FLOOR(PROUM3QTD) > 0 THEN LTRIM(STR(PROUM3QTD, 6, 3))
                        ELSE LTRIM(STR(FLOOR(QTD43), 10, 0))
                    END + '-' + PROUM3 + ' ' +
                    CASE 
                        WHEN PROUM3QTD - FLOOR(PROUM3QTD) > 0 THEN LTRIM(STR(PROUM3QTD, 6, 3))
                        ELSE LTRIM(STR(FLOOR(QTD32), 10, 0))
                    END + '-' + PROUM2 + ' ' +
                    CASE 
                        WHEN PROUM2QTD - FLOOR(PROUM2QTD) > 0 THEN LTRIM(STR(PROUM2QTD, 18, 3))
                        ELSE LTRIM(STR(FLOOR(PROUM2QTD), 10, 0))
                    END + '-' + PROUM1 +
                    CASE 
                        WHEN PROUM1QTD > 1 THEN --' ' + 
                            CASE 
                                WHEN PROUM1QTD - FLOOR(PROUM1QTD) > 0 THEN LTRIM(STR(PROUM1QTD, 18, 3))
                                ELSE LTRIM(STR(FLOOR(PROUM1QTD), 10, 0))
                            END + PROUMV
                        ELSE ''
                    END --+ ')'
            END AS TextoEmbalagem
        FROM DadosProduto
    ) AS Embalagens
    WHERE UnidadeMedida IS NOT NULL AND UnidadeMedida <> ''
);
GO

SELECT Nivel, UnidadeMedida, Quantidade, TextoEmbalagem 
FROM dbo.fn_ObterEmbalagensProduto('1640054')
--where Quantidade = 10

select top 10
       p.PROCOD
       ,p.PRODES
       ,p.PROUM1
       ,p.PROUM1QTD
       ,p.PROUM2
       ,p.PROUM2QTD
       ,p.PROUM3
       ,p.PROUM3QTD
       ,p.PROUM4
       ,p.PROUM4QTD
  from TBS010 p with (nolock)
 where p.PROUM4QTD > 0





-- update complemento 

DECLARE @crt INT;
DECLARE @data_ini DATE = '1753-01-01';
DECLARE @data_fim DATE = '2026-08-04';

SELECT @crt = EMPCRT
FROM TBS023 WITH (NOLOCK);

DECLARE @cst_pis CHAR(2),
        @cst_cofins CHAR(2);

SELECT
    @cst_pis = MAX(CASE WHEN par.PARCHV = 1113 THEN par.PARVAL END),
    @cst_cofins = MAX(CASE WHEN par.PARCHV = 1114 THEN par.PARVAL END)
FROM TBS025 par WITH (NOLOCK)
WHERE par.PARCHV IN (1113,1114);

;WITH ProdutosFiltrados AS
(
    SELECT distinct pro.PROCOD
    FROM TBS010 pro WITH (NOLOCK)
    LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON bar.CBPPROCOD = pro.PROCOD
    left join dbo.vw_PrecoLojaGeral pre on pre.codigo = pro.PROCOD
    WHERE --pro.PROCOD in ('25930041')
          --pro.PROSTBB = '41'

    --pro.PROCOD = '1640054'
    pro.MARCOD = 1
        --(CAST(pro.PRODATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        --OR (CAST(pro.PRODATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        --OR (CAST(bar.CBPDATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        --OR (CAST(bar.CBPDATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        --or (pre.atualizado between @data_ini AND @data_fim)
),
PrecosComIndice AS
(
    SELECT
        RTRIM(T.PROCOD)
        + IIF(
            ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 2,'2222',
            IIF(
                ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 3,'3333',
                IIF(
                    ROW_NUMBER() OVER(PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) = 4,'4444',''
                )
            )
        ) AS PROCOD,
        dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
        U.UnidadeMedida,
        CASE U.UnidadeMedida
            WHEN T.PROUM1 THEN ISNULL(PL.preco1,0)
            WHEN T.PROUM2 THEN ISNULL(T.PROUM2QTD * PL.preco2,0)
            WHEN T.PROUM3 THEN ISNULL(T.PROUM3QTD * PL.preco3,0)
            ELSE ISNULL(T.PROUM4QTD * PL.preco4,0)
        END AS preco,
        T.PROSTBA,
        T.PROSTBB,
        T.PROCSN,
        ISNULL(NULLIF(T.PROICMSINT,0),18) AS PROICMSINT,
        T.PROPESAVEL,
        T.PROCLAFIS,
        T.PROCEST,
        T.MARCOD,
        T.MARNOM,
        T.GRUCOD,
        ISNULL(G.GRUDES,'') AS GRUDES,
        ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
        ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS
        ,trib.cClassTrib
        ,RTRIM(T.PROCOD) as codExterno

    FROM TBS010 T WITH (NOLOCK)
    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = T.PROCOD
    CROSS APPLY
    (
        VALUES
            (T.PROUM1),
            (T.PROUM2),
            (T.PROUM3),
            (T.PROUM4)
    ) U(UnidadeMedida)
    CROSS APPLY
    (
        SELECT preco1, preco2, preco3, preco4
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = T.PROCOD
    ) PL
    LEFT JOIN TBS012 G WITH (NOLOCK)
        ON T.GRUCOD = G.GRUCOD

    OUTER APPLY dbo.fn_RetornaTributacaoProduto(0, T.PROCOD) trib

    UNION ALL

    SELECT
        bar.CBPCODBAR,
        dbo.RemoveInvalidChars(pro.PRODES),
        IIF(
            bar.CBPQTDEMB = 1, pro.PROUM1,
            IIF(
                bar.CBPQTDEMB = pro.PROUM2QTD, pro.PROUM2,
                IIF(
                    bar.CBPQTDEMB = pro.PROUM3QTD, pro.PROUM3,
                    IIF(
                        bar.CBPQTDEMB = pro.PROUM4QTD, pro.PROUM4, ''
                    )
                )
            )
        ),
        IIF(
            bar.CBPQTDEMB = 1, preco.preco1,
            bar.CBPQTDEMB *
            IIF(
                bar.CBPQTDEMB = pro.PROUM2QTD, preco.preco2,
                IIF(
                    bar.CBPQTDEMB = pro.PROUM3QTD, preco.preco3,
                    IIF(
                        bar.CBPQTDEMB = pro.PROUM4QTD, preco.preco4, 0
                    )
                )
            )
        ),
        pro.PROSTBA,
        pro.PROSTBB,
        pro.PROCSN,
        ISNULL(NULLIF(pro.PROICMSINT,0),18),
        pro.PROPESAVEL,
        pro.PROCLAFIS,
        pro.PROCEST,
        pro.MARCOD,
        pro.MARNOM,
        pro.GRUCOD,
        ISNULL(g.GRUDES,''),
        ISNULL(pro.PROSTBPIS,1),
        ISNULL(pro.PROSTBCOFINS,1)
        ,trib.cClassTrib
        ,bar.CBPPROCOD

    FROM TBS0103 bar WITH (NOLOCK)
    INNER JOIN TBS010 pro WITH (NOLOCK)
     ON pro.PROCOD = bar.CBPPROCOD
    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = pro.PROCOD
    CROSS APPLY
    (
        SELECT preco1, preco2, preco3, preco4
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = pro.PROCOD
    ) preco
    LEFT JOIN TBS012 g WITH (NOLOCK)
        ON g.GRUCOD = pro.GRUCOD

    OUTER APPLY dbo.fn_RetornaTributacaoProduto(0, pro.PROCOD) trib
    
    WHERE
        (
            bar.CBPQTDEMB = 1
            OR bar.CBPQTDEMB IN
            (
                pro.PROUM2QTD,
                pro.PROUM3QTD,
                pro.PROUM4QTD
            )
        )
        AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
        AND RIGHT(RTRIM(bar.CBPCODBAR),4) NOT IN ('2222','3333','4444')
)

SELECT
    'UPDATE PRODUTO SET COMPLEMENTO = ''' +
    isnull((select top 1 rtrim(TextoEmbalagem) from dbo.fn_ObterEmbalagensProduto(rtrim(codExterno)) as emb where emb.UnidadeMedida = PrecosComIndice.UnidadeMedida),'') + ''' ' +
    'WHERE CODBARRAS = ''' +
    LTRIM(RTRIM(PROCOD)) + ''';' -- 2
    AS dados
FROM PrecosComIndice
WHERE preco > 0;

-- com código 2222

select *
  from dbo.DWCodigosBarrasGZ
 where codigo = '1640054'
 order by barras

-- sem código 2222

select *
  from dbo.DWCodigosBarrasGZ_2
 where codigo = '1640054'

select *
  from dbo.vw_TabelaCodigosBarrasGZ
 where codigo = '1640054'
 order by barras

-- vw_TabelaCodigosBarras Otimizada

-- sem o preço 1

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[vw_TabelaCodigosBarras]
AS
WITH base AS (
    SELECT 
        p.PROEMPCOD AS empresa,
        p.PROCOD,
        p.PROUM2QTD,
        p.PROUM3QTD,
        p.PROUM4QTD,
        ISNULL(pl.preco1, 0) AS preco1,
        ISNULL(pl.preco2, 0) AS preco2,
        ISNULL(pl.preco3, 0) AS preco3,
        ISNULL(pl.preco4, 0) AS preco4
    FROM dbo.TBS010 p WITH (NOLOCK)
    INNER JOIN dbo.vw_PrecoLojaGeral pl WITH (NOLOCK)
        ON pl.codigo = p.PROCOD
),
unificada AS (
    ----------------------------------------------------------------
    -- 1. Unidade Básica (Embalagem = 1)
    ----------------------------------------------------------------
    SELECT 
        b.empresa,
        RTRIM(c.CBPPROCOD) AS codigo,
        RTRIM(c.CBPCODBAR) AS barras,
        c.CBPQTDEMB AS embalagem,
        0 AS preco
    FROM dbo.TBS0103 c WITH (NOLOCK)
    INNER JOIN base b
        ON b.empresa = c.CBPEMP
       AND b.PROCOD = c.CBPPROCOD
    WHERE c.CBPQTDEMB = 1

    UNION ALL

    ----------------------------------------------------------------
    -- 2. Unidades Múltiplas com Código de Barras Específico (2, 3 e 4)
    ----------------------------------------------------------------
    SELECT 
        b.empresa,
        RTRIM(c.CBPPROCOD) AS codigo,
        RTRIM(c.CBPCODBAR) AS barras,
        c.CBPQTDEMB AS embalagem,
        u.preco
    FROM dbo.TBS0103 c WITH (NOLOCK)
    INNER JOIN base b
        ON b.empresa = c.CBPEMP
       AND b.PROCOD = c.CBPPROCOD
    CROSS APPLY (
        SELECT b.preco2 AS preco, b.PROUM2QTD AS qtd WHERE c.CBPQTDEMB = b.PROUM2QTD AND b.PROUM2QTD NOT IN (1, b.PROUM3QTD, b.PROUM4QTD)
        UNION ALL
        SELECT b.preco3 AS preco, b.PROUM3QTD AS qtd WHERE c.CBPQTDEMB = b.PROUM3QTD AND b.PROUM3QTD NOT IN (1, b.PROUM2QTD, b.PROUM4QTD)
        UNION ALL
        SELECT b.preco4 AS preco, b.PROUM4QTD AS qtd WHERE c.CBPQTDEMB = b.PROUM4QTD AND b.PROUM4QTD NOT IN (1, b.PROUM2QTD, b.PROUM3QTD)
    ) u

    UNION ALL

    ----------------------------------------------------------------
    -- 3. Unidades Múltiplas sem Código de Barras (Gerando código sufixado)
    ----------------------------------------------------------------
    SELECT 
        b.empresa,
        RTRIM(b.PROCOD) AS codigo,
        RTRIM(b.PROCOD) + u.sufixo AS barras,
        u.qtd AS embalagem,
        u.preco
    FROM base b
    CROSS APPLY (
        SELECT '2222' AS sufixo, b.PROUM2QTD AS qtd, b.preco2 AS preco WHERE b.PROUM2QTD > 1
        UNION ALL
        SELECT '3333' AS sufixo, b.PROUM3QTD AS qtd, b.preco3 AS preco WHERE b.PROUM3QTD > 1
        UNION ALL
        SELECT '4444' AS sufixo, b.PROUM4QTD AS qtd, b.preco4 AS preco WHERE b.PROUM4QTD > 1
    ) u
)
SELECT 
    empresa,
    codigo,
    barras,
    embalagem,
    preco
FROM unificada
WHERE embalagem = 1 
   OR (embalagem > 1 AND preco > 0);
GO

-- com o preço 1

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[vw_TabelaCodigosBarras]
AS
WITH base AS (
    SELECT 
        p.PROEMPCOD AS empresa,
        p.PROCOD,
        p.PROUM2QTD,
        p.PROUM3QTD,
        p.PROUM4QTD,
        ISNULL(pl.preco1, 0) AS preco1,
        ISNULL(pl.preco2, 0) AS preco2,
        ISNULL(pl.preco3, 0) AS preco3,
        ISNULL(pl.preco4, 0) AS preco4
    FROM dbo.TBS010 p WITH (NOLOCK)
    INNER JOIN dbo.vw_PrecoLojaGeral pl WITH (NOLOCK)
        ON pl.codigo = p.PROCOD
),
unificada AS (
    ----------------------------------------------------------------
    -- 1. Unidade Básica (Embalagem = 1)
    ----------------------------------------------------------------
    SELECT 
        b.empresa,
        RTRIM(c.CBPPROCOD) AS codigo,
        RTRIM(c.CBPCODBAR) AS barras,
        c.CBPQTDEMB AS embalagem,
        b.preco1 AS preco
    FROM dbo.TBS0103 c WITH (NOLOCK)
    INNER JOIN base b
        ON b.empresa = c.CBPEMP
       AND b.PROCOD = c.CBPPROCOD
    WHERE c.CBPQTDEMB = 1

    UNION ALL

    ----------------------------------------------------------------
    -- 2. Unidades Múltiplas com Código de Barras Específico (2, 3 e 4)
    ----------------------------------------------------------------
    SELECT 
        b.empresa,
        RTRIM(c.CBPPROCOD) AS codigo,
        RTRIM(c.CBPCODBAR) AS barras,
        c.CBPQTDEMB AS embalagem,
        u.preco
    FROM dbo.TBS0103 c WITH (NOLOCK)
    INNER JOIN base b
        ON b.empresa = c.CBPEMP
       AND b.PROCOD = c.CBPPROCOD
    CROSS APPLY (
        SELECT b.preco2 AS preco, b.PROUM2QTD AS qtd WHERE c.CBPQTDEMB = b.PROUM2QTD AND b.PROUM2QTD NOT IN (1, b.PROUM3QTD, b.PROUM4QTD)
        UNION ALL
        SELECT b.preco3 AS preco, b.PROUM3QTD AS qtd WHERE c.CBPQTDEMB = b.PROUM3QTD AND b.PROUM3QTD NOT IN (1, b.PROUM2QTD, b.PROUM4QTD)
        UNION ALL
        SELECT b.preco4 AS preco, b.PROUM4QTD AS qtd WHERE c.CBPQTDEMB = b.PROUM4QTD AND b.PROUM4QTD NOT IN (1, b.PROUM2QTD, b.PROUM3QTD)
    ) u

    UNION ALL

    ----------------------------------------------------------------
    -- 3. Unidades Múltiplas sem Código de Barras (Gerando código sufixado)
    ----------------------------------------------------------------
    SELECT 
        b.empresa,
        RTRIM(b.PROCOD) AS codigo,
        RTRIM(b.PROCOD) + u.sufixo AS barras,
        u.qtd AS embalagem,
        u.preco
    FROM base b
    CROSS APPLY (
        SELECT '2222' AS sufixo, b.PROUM2QTD AS qtd, b.preco2 AS preco WHERE b.PROUM2QTD > 1
        UNION ALL
        SELECT '3333' AS sufixo, b.PROUM3QTD AS qtd, b.preco3 AS preco WHERE b.PROUM3QTD > 1
        UNION ALL
        SELECT '4444' AS sufixo, b.PROUM4QTD AS qtd, b.preco4 AS preco WHERE b.PROUM4QTD > 1
    ) u
)
SELECT 
    empresa,
    codigo,
    barras,
    embalagem,
    preco
FROM unificada
WHERE embalagem = 1 
   OR (embalagem > 1 AND preco > 0);
GO

select *
  from vw_TabelaCodigosBarras
 where codigo = '1640054'
 order by barras

drop view vw_TabelaCodigosBarras_Otimizada

select *
  from dbo.vw_PrecoLojaGeral
 where codigo = '1640054'

-- otimizada

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter VIEW [dbo].[vw_PrecoLojaGeral]
AS
WITH Base AS (
    SELECT
        t.TDPPROCOD AS codigo,
        t.TDPPREPRO1, t.TDPPREPRO2, t.TDPPREPRO3, t.TDPPREPRO4,
        t.TDPPRELOJ1, t.TDPPRELOJ2, t.TDPPRELOJ3, t.TDPPRELOJ4,
        t.TDPCUSBAS  AS custo,
        CAST(t.TDPDATATU AS DATE) AS atualizado,
        CASE 
            WHEN d.agora BETWEEN t.TDPVALPROI AND t.TDPVALPROF 
                 AND t.TDPPROLOJ = 'S' 
            THEN 1 
            ELSE 0 
        END AS tem_promocao
    FROM SIBD.dbo.TBS031 t WITH (NOLOCK)
    CROSS APPLY (SELECT GETDATE() AS agora) d
    WHERE 
        t.TDPPREPRO1 > 0 OR t.TDPPREPRO2 > 0 OR 
        t.TDPPREPRO3 > 0 OR t.TDPPREPRO4 > 0 OR 
        t.TDPCUSBAS  > 0
)
SELECT
    codigo,
    CASE WHEN tem_promocao = 1 THEN TDPPREPRO1 ELSE TDPPRELOJ1 END AS preco1,
    CASE WHEN tem_promocao = 1 THEN TDPPREPRO2 ELSE TDPPRELOJ2 END AS preco2,
    CASE WHEN tem_promocao = 1 THEN TDPPREPRO3 ELSE TDPPRELOJ3 END AS preco3,
    CASE WHEN tem_promocao = 1 THEN TDPPREPRO4 ELSE TDPPRELOJ4 END AS preco4,
    custo,
    atualizado
FROM Base;
GO

select *
     , round(((preco1 - preco2) / preco1) * 100,2) as por_preco2
     , round(((preco1 - preco3) / preco1) * 100,2) as por_preco3
  from dbo.vw_PrecoLojaGeral
 where codigo = '2130372'

drop view dbo.vw_PrecoLojaGeral_otimizada

select p.PROCOD
       ,p.PRODES
       ,p.PROUM1
       ,p.PROUM1QTD
       ,p.PROUM2
       ,p.PROUM2QTD
       ,p.PROUM3
       ,p.PROUM3QTD
       ,p.PROUM4
       ,p.PROUM4QTD
  from TBS010 p with (nolock)
 where p.PROSTATUS = 'A'
       and p.PROUM3 <> ''
 order by p.PROCOD

go


-- 19/08/2026
-- versão exportar produtos únicos
-- códigos internos referenciando códigos de barras

DECLARE @crt INT;
DECLARE @data_ini DATE = '2026-09-30';
DECLARE @data_fim DATE = '2026-09-30';

SELECT @crt = EMPCRT
FROM TBS023 WITH (NOLOCK);

DECLARE @cst_pis CHAR(2),
        @cst_cofins CHAR(2);

SELECT
    @cst_pis = MAX(CASE WHEN par.PARCHV = 1113 THEN par.PARVAL END),
    @cst_cofins = MAX(CASE WHEN par.PARCHV = 1114 THEN par.PARVAL END)
FROM TBS025 par WITH (NOLOCK)
WHERE par.PARCHV IN (1113,1114);

;WITH ProdutosFiltrados AS
(
    SELECT DISTINCT pro.PROCOD
    FROM TBS010 pro WITH (NOLOCK)
    LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON bar.CBPPROCOD = pro.PROCOD
    LEFT JOIN dbo.vw_PrecoLojaGeral pre 
        ON pre.codigo = pro.PROCOD
    WHERE --pro.PROCOD in ('13930069','13930079')
          --pro.MARCOD = 1393
          --pro.PROCOD = '1900013'
          --pro.PROSTBB in('20','41')
        (CAST(pro.PRODATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(pro.PRODATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(bar.CBPDATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(bar.CBPDATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (pre.atualizado BETWEEN @data_ini AND @data_fim)
),
PrecosComIndice AS
(
    SELECT
        RTRIM(T.PROCOD) AS PROCOD,
        dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
        
        -- FIXADO NA UNIDADE PRINCIPAL E NO PREÇO 1 (Sem duplicar linhas)
        T.PROUM1 AS UnidadeMedida,
        ISNULL(PL.preco1, 0) AS preco,
        
        T.PROSTBA,
        T.PROSTBB,
        T.PROCSN,
        --ISNULL(NULLIF(T.PROICMSINT,0),18) AS PROICMSINT,
        efe.AliquotaEfetiva AS PROICMSINT,
        T.PROPESAVEL,
        T.PROCLAFIS,
        T.PROCEST,
        T.MARCOD,
        T.MARNOM,
        T.GRUCOD,
        ISNULL(G.GRUDES,'') AS GRUDES,
        ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
        ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
        trib.cClassTrib,
        RTRIM(T.PROCOD) AS codExterno,
        fn.PROCBENEF AS PROCBENEF,
        IIF(@crt = 1, dbo.SituacaoTributaria(T.PROCSN), dbo.SituacaoTributaria(T.PROSTBB)) AS SituacaoTributaria,
        v.id_icms
        --efe.AliquotaEfetiva

        --T.PROCBENEF AS PROCBENEF,
        /*case
           when T.PROCBENEF = '' then ''
           else
              (select )

        end,*/
        --iif(T.PROCBENEF <> '' and (select 1 from TBS161 b where b.CBFCOD = T.PROCBENEF and b.CBFCST Like('%'+T.PROSTBB+'%')) = 1, T.PROCBENEF, ''),
        /*CASE 
                WHEN T.PROCBENEF <> '' 
                AND EXISTS (
                    SELECT 1 
                    FROM TBS161 b 
                    WHERE b.CBFCOD = T.PROCBENEF 
                    AND b.CBFCST LIKE '%' + T.PROSTBB + '%'
                ) THEN T.PROCBENEF 
                ELSE '' 
            END AS PROCBENEF*/

    FROM TBS010 T WITH (NOLOCK)
    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = T.PROCOD
    
    -- MANTIDO CROSS APPLY: Melhor performance do que múltiplos sub-selects
    CROSS APPLY
    (
        SELECT preco1
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = T.PROCOD
    ) PL
    
    CROSS APPLY dbo.fn_ObterBeneficioECstSugerido(T.PROCBENEF, T.PROSTBB) fn

    LEFT JOIN TBS012 G WITH (NOLOCK)
        ON T.GRUCOD = G.GRUCOD

    LEFT JOIN vw_Produtos_ICMS_DJPDV v WITH (NOLOCK)
        ON v.codigo = T.PROCOD

    OUTER APPLY dbo.fn_RetornaTributacaoProduto(0, T.PROCOD) trib

    CROSS APPLY dbo.fn_ObterAliquotaEfetivaIcmsTable(ISNULL(NULLIF(T.PROICMSINT,0),18), T.PROREDBASICMS) efe
)

SELECT --SituacaoTributaria +
    LEFT(LTRIM(RTRIM(codExterno)) + REPLICATE(' ',20),20) +  -- 1
    LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20) +  -- 2
    LEFT(LTRIM(RTRIM(PRODES)) + REPLICATE(' ',40),40) +  -- 3
    --LEFT(ISNULL((SELECT TOP 1 RTRIM(TextoEmbalagem) FROM dbo.fn_ObterEmbalagensProduto(RTRIM(codExterno)) AS emb WHERE emb.UnidadeMedida = PrecosComIndice.UnidadeMedida),'') + REPLICATE(' ',20),20) +
    REPLICATE(' ',20) +
    LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4) +  -- 5
    RIGHT(REPLICATE('0',12) + LTRIM(STR(preco * 1000,12,0)),12) +  -- 6
    '000000' +  -- 7
    /*IIF(@crt = 1,
        dbo.SituacaoTributaria(PROCSN),
        dbo.SituacaoTributaria(PROSTBB)) +  -- 8*/
    SituacaoTributaria + -- 8
    --RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18) * 100,4,0)),4) +  -- 9

    case
       when SituacaoTributaria = 'T' then RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18) * 100,4,0)),4)
       else REPLICATE('0',4)
    end +

    REPLICATE(' ',65) +  -- 10
    'N' +  -- 11
    IIF(PROPESAVEL='S' OR UnidadeMedida IN('KG','MT'),'N','S') +  -- 12
    'NNN' +  -- 13, 14, 15
    RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6) +  -- 16
    LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30) + -- 17
    '      ' + -- 18
    REPLICATE(' ',30) + -- 19
    RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6) + -- 20
    LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30) + -- 21
    '     0' +  -- 22
    REPLICATE(' ',30) + -- 23
    '000000000000' +  -- 24, 25
    LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20) + -- 26
    '000000' +  -- 27
    REPLICATE(' ',20) +  -- 28
    REPLICATE(' ',20) +  -- 29
    REPLICATE(' ',20) +  -- 30
    --'000001' +  -- 31

    RIGHT(REPLICATE('0',6) + LTRIM(STR(id_icms)),6) + -- 31

    '      ' +  -- 32
    '      ' +  -- 33
    '      ' +  -- 34
    RIGHT(
        REPLICATE('0',6) +
        IIF(@crt = 1,
            '49',
            IIF(PROSTBPIS = '',
                LTRIM(STR(@cst_pis)),
                LTRIM(STR(PROSTBPIS))
            )
        ),
        6
    ) +  -- 35
    '      ' +  -- 36
    RIGHT(
        REPLICATE('0',6) +
        IIF(@crt = 1,
            '49',
            IIF(PROSTBCOFINS = '',
                LTRIM(STR(@cst_cofins)),
                LTRIM(STR(PROSTBCOFINS))
            )
        ),
        6
    ) +  -- 37
    '      ' +  -- 38
    'N' +  -- 39
    '000000000000' +  -- 40
    '000' +  -- 41
    IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7)) +  -- 42
    'N' +  -- 43
    REPLICATE(' ',9) +  -- 44
    'N' +  -- 45
    '00000' +  -- 46
    ' ' +  -- 47
    REPLICATE(' ',20) +  -- 48
    --IIF(PROSTBB IN ('40','41'), 'SP099999  ', REPLICATE(' ',10)) +  -- 49
    LEFT(LTRIM(RTRIM(PROCBENEF)) + REPLICATE(' ',10),10) +  -- cBenef formatado
    '0000000' +  -- 50
    '0000000' +  -- 51
    '0000000' +  -- 52
    '000000000000000' +  -- 53
    'P' +  -- 54
    LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4) +  -- 55
    '000000000000000' +  -- 56
    REPLICATE(' ',20) +  -- 57
    '000000' +  -- 58
    LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) +  -- 59
    REPLICATE('0',4) +  -- 60
    REPLICATE('0',7) +  -- 61
    cClassTrib
    AS dados
FROM PrecosComIndice
WHERE preco > 0;

go

-- exportar códigos de barras

DECLARE @crt INT;
DECLARE @data_ini DATE = '2026-09-30';
DECLARE @data_fim DATE = '2026-09-30';

SELECT @crt = EMPCRT
FROM TBS023 WITH (NOLOCK);

DECLARE @cst_pis CHAR(2),
        @cst_cofins CHAR(2);

SELECT
    @cst_pis = MAX(CASE WHEN par.PARCHV = 1113 THEN par.PARVAL END),
    @cst_cofins = MAX(CASE WHEN par.PARCHV = 1114 THEN par.PARVAL END)
FROM TBS025 par WITH (NOLOCK)
WHERE par.PARCHV IN (1113,1114);

;WITH ProdutosFiltrados AS
(
    SELECT DISTINCT pro.PROCOD
    FROM TBS010 pro WITH (NOLOCK)
    LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON bar.CBPPROCOD = pro.PROCOD
    LEFT JOIN dbo.vw_PrecoLojaGeral pre 
        ON pre.codigo = pro.PROCOD
    WHERE --pro.PROCOD in ('13930069','13930079')
          --pro.MARCOD = 1393
          --pro.PROCOD = '26340001'
        (CAST(pro.PRODATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(pro.PRODATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(bar.CBPDATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(bar.CBPDATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (pre.atualizado BETWEEN @data_ini AND @data_fim)
),
PrecosComIndice AS
(
    SELECT 
        pg.*,
        PL.preco1
    FROM dbo.vw_TabelaCodigosBarras pg
    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = pg.codigo
    
    OUTER APPLY
    (
        SELECT TOP 1 ISNULL(preco1, 0) AS preco1
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = pg.codigo
    ) PL
)
SELECT
    LEFT(LTRIM(RTRIM(codigo)) + REPLICATE(' ', 20), 20)
    + LEFT(LTRIM(RTRIM(barras)) + REPLICATE(' ', 20), 20)
    
    -- 03 Desconto/Acréscimo
    + CASE
        WHEN preco1 >= preco THEN 'D'
        ELSE 'A'
      END

-- 04 Porcentagem tratada contra Divisão por Zero
+ RIGHT(REPLICATE('0', 5) + LTRIM(STR(
    ISNULL(
        CASE 
            WHEN embalagem = 1 THEN 0
            WHEN preco1 >= preco THEN ROUND(((preco1 - preco) / NULLIF(preco1, 0)) * 100, 2)
            ELSE ROUND(((preco - preco1) / NULLIF(preco1, 0)) * 100, 2)
        END
    , 0) * 100, 5, 0)), 5)
    -- 05 Quantidade Embalagem
    + RIGHT(REPLICATE('0', 7) + LTRIM(STR(ROUND(embalagem, 2) * 100, 7, 0)), 7) AS texto
FROM PrecosComIndice;

-- benefícios fiscais

select *
  from TBS161 with (nolock)
 where CBFCST Like('%51%')

select distinct p.PROSTBB
  from TBS010 p with (nolock)

select p.*
  from TBS010 p with (nolock)
 where p.PROCSN = '400'

select distinct p.PROCSN, p.PROSTBB
  from TBS010 p with (nolock)

select distinct p.PROCBENEF
  from TBS010 p with (nolock)

select distinct
       p.PROSTBB
       ,p.PROCBENEF
  from TBS010 p with (nolock)

begin tran
update TBS010
   set PROCBENEF = ''
 where PROCBENEF is null

rollback tran
commit tran

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCBENEF
  from TBS010 p with (nolock)
 where p.PROSTBB = '41'
       and p.PROSTATUS = 'A'

begin tran
update TBS010
   set PROCBENEF = 'SP070130'
 where PROSTBB = '41'

rollback tran
commit tran

-- função para validar e retorna cBenef
go

CREATE FUNCTION dbo.fn_ObterBeneficioECstSugerido (
    @pPROCBENEF VARCHAR(100),
    @pPROSTBB   VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    WITH Validação AS (
        -- Step 1: Valida se o benefício atual existe na TBS161 para o CST informado
        SELECT 
            CASE 
                WHEN ISNULL(@pPROCBENEF, '') <> '' 
                 AND EXISTS (
                     SELECT 1 
                     FROM TBS161 b 
                     WHERE b.CBFCOD = @pPROCBENEF 
                       AND b.CBFCST LIKE '%' + @pPROSTBB + '%'
                 ) THEN @pPROCBENEF
                
                -- Step 2: Fallback por regra de CST (caso não validou na TBS161)
                WHEN @pPROSTBB = '20' THEN 'SP020030'
                WHEN @pPROSTBB = '41' THEN 'SP070130'
                
                -- Step 3: Em último caso, cBenef fica vazio
                ELSE ''
            END AS cBenefCalculado
    )
    SELECT 
        cBenefCalculado AS PROCBENEF,
        
        -- Define o CST Sugerido:
        -- Mantém o CST atual caso tenha encontrado cBenef válido/fallback.
        -- Em último caso (cBenef zerado/vazio), sugere o CST '00'.
        CASE 
            WHEN cBenefCalculado <> '' THEN @pPROSTBB
            ELSE '00' 
        END AS PROSTBB_SUGERIDO
    FROM Validação
);
GO

select * from dbo.fn_ObterBeneficioECstSugerido('teste', '90') 

select *
  from(
SELECT 
    T.PROCBENEF AS PROCBENEF_ORIGINAL,
    T.PROSTBB   AS PROSTBB_ORIGINAL,
    
    -- Colunas retornadas pela função:
    fn.PROCBENEF AS PROCBENEF_VALIDADO,
    fn.PROSTBB_SUGERIDO
FROM TBS010 T with (nolock)
CROSS APPLY dbo.fn_ObterBeneficioECstSugerido(T.PROCBENEF, T.PROSTBB) fn
where T.PROSTBB in('20','41')) t
where t.PROSTBB_ORIGINAL <> t.PROSTBB_SUGERIDO

-- tabela de reduções da bc do icms

select *
  from TBS157 r with (nolock)

exec sp_help 'TBS157'

UPDATE TBS157
SET RBCPERRED = ROUND(
    (1.0 - (CAST(RBCALIEFE AS DECIMAL(18, 6)) / CAST(RBCALIPAD AS DECIMAL(18, 6)))) * 100.0, 
    4
)
WHERE RBCALIPAD > 0;

go

CREATE FUNCTION dbo.fn_ObterAliquotaEfetivaIcms (
    @pAliquotaPadrao  DECIMAL(18,4),
    @pPercentualReducao DECIMAL(18,4)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @AliquotaEfetiva DECIMAL(18,2) = 0.00;

    SELECT TOP 1 
        @AliquotaEfetiva = RBCALIEFE
    FROM TBS157 WITH (NOLOCK)
    WHERE RBCALIPAD = @pAliquotaPadrao
      AND ROUND(RBCPERRED, 2) = ROUND(@pPercentualReducao, 2);

    RETURN ISNULL(@AliquotaEfetiva, 0.00);
END;
GO

drop function fn_ObterAliquotaEfetivaIcms
go

/*CREATE FUNCTION dbo.fn_ObterAliquotaEfetivaIcmsTable (
    @pAliquotaPadrao    DECIMAL(18,4),
    @pPercentualReducao DECIMAL(18,4)
)
RETURNS TABLE
AS
RETURN
(
    SELECT ISNULL(
        (
            SELECT TOP 1 RBCALIEFE
            FROM TBS157 WITH (NOLOCK)
            WHERE RBCALIPAD = @pAliquotaPadrao
              AND ROUND(RBCPERRED, 2) = ROUND(@pPercentualReducao, 2)
        ), 0.00
    ) AS AliquotaEfetiva
);
GO*/

drop function fn_ObterAliquotaEfetivaIcmsTable
go

CREATE FUNCTION dbo.fn_ObterAliquotaEfetivaIcmsTable (
    @pAliquotaPadrao    DECIMAL(18,4),
    @pPercentualReducao DECIMAL(18,4)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        CAST(
            CASE 
                -- Se não houver redução (0.00), retorna a alíquota padrão
                WHEN ISNULL(@pPercentualReducao, 0) = 0 THEN ISNULL(@pAliquotaPadrao, 0.00)
                
                -- Caso contrário, busca na tabela de reduções (TBS157)
                ELSE ISNULL(
                    (
                        SELECT TOP 1 RBCALIEFE
                        FROM TBS157 WITH (NOLOCK)
                        WHERE RBCALIPAD = @pAliquotaPadrao
                          AND ROUND(RBCPERRED, 2) = ROUND(@pPercentualReducao, 2)
                    ), 0.00
                )
            END 
        AS DECIMAL(18,2)) AS AliquotaEfetiva
);
GO

select dbo.fn_ObterAliquotaEfetivaIcms(18.00, 48.89) 

-- Exemplo de consulta direta
SELECT dbo.fn_ObterAliquotaEfetivaIcms(18.00, 22.2222) AS AliquotaEfetiva;
-- Retorna: 4.00

SELECT dbo.fn_ObterAliquotaEfetivaIcms(18.00, 38.8888) AS AliquotaEfetiva;
-- Retorna: 7.00

select dbo.SituacaoTributaria('20')

select * from dbo.fn_ObterAliquotaEfetivaIcmsTable(18, 0)

select distinct
       iif(p.PROICMSINT = 0, 18 ,p.PROICMSINT) as ICMS
       ,p.PROREDBASICMS as reducao
  from TBS010 p with (nolock)
 where p.PROREDBASICMS > 0

SELECT DISTINCT
    IIF(p.PROICMSINT = 0, 18.0, p.PROICMSINT) AS ICMS,
    p.PROREDBASICMS AS reducao,
    ROUND(
        IIF(p.PROICMSINT = 0, 18.0, p.PROICMSINT) * (1.0 - (CAST(p.PROREDBASICMS AS DECIMAL(18, 6)) / 100.0)),
        2
    ) AS aliquota_efetiva
FROM TBS010 p WITH (NOLOCK)
WHERE p.PROREDBASICMS > 0;

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROICMSINT
       ,p.PROREDBASICMS
       ,p.PROCLAFIS
       ,p.PROCBENEF
  from TBS010 p with (nolock)
 where p.PROREDBASICMS = 26.67

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROICMSINT
       ,p.PROREDBASICMS
       ,p.PROCLAFIS
       ,p.PROCBENEF
  from TBS010 p with (nolock)
 where p.PROICMSINT = 25

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBA
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST
       ,p.PROICMSINT
       ,p.PROREDBASICMS
       ,p.PROCBENEF
       ,p.PROSTATUS
  from TBS010 p with (nolock)
 where p.PROCOD in('10000007','1030221','1030230','23560013','3530191','3530299','3530370','3530388','3530868','3531198','3531201','3531210','3531252','3531350','3531352','3531362','3531363','3531370','9981996','9982611','9986853')

go

-- simples nacional

-- 15/09/2026
-- versão exportar produtos únicos simples nacional
-- códigos internos referenciando códigos de barras

DECLARE @crt INT;
DECLARE @data_ini DATE = '2026-09-30';
DECLARE @data_fim DATE = '2026-09-30';

SELECT @crt = EMPCRT
FROM TBS023 WITH (NOLOCK);

DECLARE @cst_pis CHAR(2),
        @cst_cofins CHAR(2);

SELECT
    @cst_pis = MAX(CASE WHEN par.PARCHV = 1113 THEN par.PARVAL END),
    @cst_cofins = MAX(CASE WHEN par.PARCHV = 1114 THEN par.PARVAL END)
FROM TBS025 par WITH (NOLOCK)
WHERE par.PARCHV IN (1113,1114);

;WITH ProdutosFiltrados AS
(
    SELECT DISTINCT pro.PROCOD
    FROM TBS010 pro WITH (NOLOCK)
    LEFT JOIN TBS0103 bar WITH (NOLOCK)
        ON bar.CBPPROCOD = pro.PROCOD
    LEFT JOIN dbo.vw_PrecoLojaGeral pre 
        ON pre.codigo = pro.PROCOD
    WHERE --pro.PROCOD in ('33910001','1640054')
          --pro.MARCOD = 1393
          --pro.PROCOD = '26340001'
          --pro.PROSTBB in('20','41')
        (CAST(pro.PRODATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(pro.PRODATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(bar.CBPDATCAD AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (CAST(bar.CBPDATALT AS DATE) BETWEEN @data_ini AND @data_fim)
        OR (pre.atualizado BETWEEN @data_ini AND @data_fim)
),
PrecosComIndice AS
(
    SELECT
        RTRIM(T.PROCOD) AS PROCOD,
        dbo.RemoveInvalidChars(T.PRODES) AS PRODES,
        
        -- FIXADO NA UNIDADE PRINCIPAL E NO PREÇO 1 (Sem duplicar linhas)
        T.PROUM1 AS UnidadeMedida,
        ISNULL(PL.preco1, 0) AS preco,
        
        T.PROSTBA,
        T.PROSTBB,
        T.PROCSN,
        ISNULL(NULLIF(T.PROICMSINT,0),18) AS PROICMSINT, -- grava 18 se for nulo ou zero
        --efe.AliquotaEfetiva AS PROICMSINT,
        T.PROPESAVEL,
        T.PROCLAFIS,
        T.PROCEST,
        T.MARCOD,
        T.MARNOM,
        T.GRUCOD,
        ISNULL(G.GRUDES,'') AS GRUDES,
        ISNULL(T.PROSTBPIS,1) AS PROSTBPIS,
        ISNULL(T.PROSTBCOFINS,1) AS PROSTBCOFINS,
        --trib.cClassTrib,
        RTRIM(T.PROCOD) AS codExterno,
        T.PROCBENEF,
        --T.PROCSN
        -- Dentro do SELECT da CTE PrecosComIndice:
        dbo.SituacaoTributaria(T.PROCSN) AS SituacaoTributaria
        --fn.PROCBENEF AS PROCBENEF
        --IIF(@crt = 1, dbo.SituacaoTributaria(T.PROCSN), dbo.SituacaoTributaria(T.PROSTBB)) AS SituacaoTributaria,
        --v.id_icms
        --efe.AliquotaEfetiva

        --T.PROCBENEF AS PROCBENEF,
        /*case
           when T.PROCBENEF = '' then ''
           else
              (select )

        end,*/
        --iif(T.PROCBENEF <> '' and (select 1 from TBS161 b where b.CBFCOD = T.PROCBENEF and b.CBFCST Like('%'+T.PROSTBB+'%')) = 1, T.PROCBENEF, ''),
        /*CASE 
                WHEN T.PROCBENEF <> '' 
                AND EXISTS (
                    SELECT 1 
                    FROM TBS161 b 
                    WHERE b.CBFCOD = T.PROCBENEF 
                    AND b.CBFCST LIKE '%' + T.PROSTBB + '%'
                ) THEN T.PROCBENEF 
                ELSE '' 
            END AS PROCBENEF*/

    FROM TBS010 T WITH (NOLOCK)
    INNER JOIN ProdutosFiltrados PF
        ON PF.PROCOD = T.PROCOD
    
    -- MANTIDO CROSS APPLY: Melhor performance do que múltiplos sub-selects
    CROSS APPLY
    (
        SELECT preco1
        FROM dbo.vw_PrecoLojaGeral
        WHERE codigo = T.PROCOD
    ) PL
    
    --CROSS APPLY dbo.fn_ObterBeneficioECstSugerido(T.PROCBENEF, T.PROSTBB) fn

    LEFT JOIN TBS012 G WITH (NOLOCK)
        ON T.GRUCOD = G.GRUCOD

    --LEFT JOIN vw_Produtos_ICMS_DJPDV v WITH (NOLOCK)
        --ON v.codigo = T.PROCOD

    --OUTER APPLY dbo.fn_RetornaTributacaoProduto(0, T.PROCOD) trib
    
    --OUTER APPLY select dbo.SituacaoTributaria(T.PROCSN) trib

    --CROSS APPLY dbo.fn_ObterAliquotaEfetivaIcmsTable(ISNULL(NULLIF(T.PROICMSINT,0),18), T.PROREDBASICMS) efe
)

SELECT --SituacaoTributaria +
    LEFT(LTRIM(RTRIM(codExterno)) + REPLICATE(' ',20),20) +  -- 1
    LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ',20),20) +  -- 2
    LEFT(LTRIM(RTRIM(PRODES COLLATE Latin1_General_CI_AS)) + REPLICATE(' ',40),40) +  -- 3
    --LEFT(ISNULL((SELECT TOP 1 RTRIM(TextoEmbalagem) FROM dbo.fn_ObterEmbalagensProduto(RTRIM(codExterno)) AS emb WHERE emb.UnidadeMedida = PrecosComIndice.UnidadeMedida),'') + REPLICATE(' ',20),20) +
    REPLICATE(' ',20) +
    LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4) +  -- 5
    RIGHT(REPLICATE('0',12) + LTRIM(STR(preco * 1000,12,0)),12) +  -- 6
    '000000' +  -- 7
    
    /*IIF(@crt = 1,
        dbo.SituacaoTributaria(PROCSN),
        dbo.SituacaoTributaria(PROSTBB)) +  -- 8*/
    --SituacaoTributaria + -- 8
    --'N' + -- 8
    SituacaoTributaria +

    --RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18) * 100,4,0)),4) +  -- 9
    case
       when SituacaoTributaria = 'T' then RIGHT(REPLICATE('0',4) + LTRIM(STR(PROICMSINT * 100,4,0)),4)
       else REPLICATE('0',4)
    end + -- 9

    --case
       --when SituacaoTributaria = 'T' then RIGHT(REPLICATE('0',4) + LTRIM(STR(ISNULL(PROICMSINT,18) * 100,4,0)),4)
       --else REPLICATE('0',4)
    --end + -- 9
    --REPLICATE('0',4) +  -- 9
    
    REPLICATE(' ',65) +  -- 10
    'N' +  -- 11
    IIF(PROPESAVEL='S' OR UnidadeMedida IN('KG','MT'),'N','S') +  -- 12
    'NNN' +  -- 13, 14, 15
    RIGHT(REPLICATE(' ',6) + LTRIM(STR(GRUCOD)),6) +  -- 16
    LEFT(LTRIM(RTRIM(GRUDES)) + REPLICATE(' ',30),30) + -- 17
    '      ' + -- 18
    REPLICATE(' ',30) + -- 19
    RIGHT(REPLICATE(' ',6) + LTRIM(STR(MARCOD)),6) + -- 20
    LEFT(LTRIM(RTRIM(MARNOM)) + REPLICATE(' ',30),30) + -- 21
    '     0' +  -- 22
    REPLICATE(' ',30) + -- 23
    '000000000000' +  -- 24, 25
    LEFT(IIF(LEN(PROCLAFIS)=8,PROCLAFIS,'') + REPLICATE(' ',20),20) + -- 26
    '000000' +  -- 27
    REPLICATE(' ',20) +  -- 28
    REPLICATE(' ',20) +  -- 29
    REPLICATE(' ',20) +  -- 30
    --'000001' +  -- 31

    --RIGHT(REPLICATE('0',6) + LTRIM(STR(id_icms)),6) + -- 31

    RIGHT(REPLICATE('0',6) + PROSTBA + LTRIM(iif(PROCSN='101','102',PROCSN)),6) + -- 31

    '      ' +  -- 32
    '      ' +  -- 33
    '      ' +  -- 34
    /*RIGHT(
        REPLICATE('0',6) +
        IIF(@crt = 1,
            '49',
            IIF(PROSTBPIS = '',
                LTRIM(STR(@cst_pis)),
                LTRIM(STR(PROSTBPIS))
            )
        ),
        6
    ) +  -- 35*/

    RIGHT(REPLICATE('0',6) + '49',6) + -- 35


    '      ' +  -- 36
    /*RIGHT(
        REPLICATE('0',6) +
        IIF(@crt = 1,
            '49',
            IIF(PROSTBCOFINS = '',
                LTRIM(STR(@cst_cofins)),
                LTRIM(STR(PROSTBCOFINS))
            )
        ),
        6
    ) +  -- 37*/

    RIGHT(REPLICATE('0',6) + '49',6) + -- 37

    '      ' +  -- 38
    'N' +  -- 39
    '000000000000' +  -- 40
    '000' +  -- 41
    --IIF(LEN(PROCEST)=7,PROCEST,REPLICATE(' ',7)) +  -- 42

    case
       when PROCSN in('201','202','203','500') and Len(PROCEST) = 7
          then PROCEST
          else replicate(' ',7)
    end + -- 42

    'S' +  -- 43
    REPLICATE(' ',9) +  -- 44
    'N' +  -- 45
    '00000' +  -- 46
    ' ' +  -- 47
    REPLICATE(' ',20) +  -- 48
    --IIF(PROSTBB IN ('40','41'), 'SP099999  ', REPLICATE(' ',10)) +  -- 49
    --LEFT(LTRIM(RTRIM(PROCBENEF)) + REPLICATE(' ',10),10) +  -- cBenef formatado -- 49

    case
       when PROCSN in('103','203','300','400','900') and Len(PROCBENEF) = 8
          then LEFT(LTRIM(RTRIM(PROCBENEF)) + REPLICATE(' ',10),10)
       when PROCSN in('103','203','300','400','900') and Len(PROCBENEF) < 8
          then 'SP099999  '
       else replicate(' ',10)
    end + -- 49

    '0000000' +  -- 50
    '0000000' +  -- 51
    '0000000' +  -- 52
    '000000000000000' +  -- 53
    'P' +  -- 54
    LEFT(LTRIM(RTRIM(UnidadeMedida)) + REPLICATE(' ',4),4) +  -- 55
    '000000000000000' +  -- 56
    REPLICATE(' ',20) +  -- 57
    '000000' +  -- 58
    LEFT(LTRIM(RTRIM(SUBSTRING(PRODES,41,40))) + REPLICATE(' ',80),80) +  -- 59
    REPLICATE('0',4) +  -- 60
    REPLICATE('0',7) +  -- 61
    --cClassTrib
    replicate(' ',7) -- 62
    AS dados
FROM PrecosComIndice
WHERE preco > 0;

select Len(p.PROCBENEF)
       ,p.*
  from TBS010 p with (nolock)
 where p.PROCOD = '17760001'

begin tran
update TBS010
   set PROCBENEF = ''
 where PROCBENEF is null

rollback tran
commit tran




