/*
select *
  from TABCOMP with (nolock)
 where tabela not Like('TMP%')
       and (atributo Like('%PROCOD%') or atributo='PDPCOD')

select --Left(' ' + replace(PRODESDET,char(13)+char(10),'chr(13)+chr(10)'), 800)
       --,*
       --,
       PRODATALT
       ,iif(PRODATALT is null,'01/01/1753 00:00:00', convert(char(10),PRODATALT,103)+' '+convert(char(8),PRODATALT,108))
       ,GRUDES
       ,SUBGRUDES
  from TBS010 with (nolock)
       Left join TBS012 with (nolock)
       on TBS012.GRUCOD=TBS010.GRUCOD
       Left join TBS0121 with (nolock)
       on TBS0121.GRUCOD=TBS010.GRUCOD
       and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD
 where PROCOD='1640054'

select Left(rtrim(3)+'00000',5)

select *
  from TBS012 with (nolock)
       right join TBS0121 with (nolock)
       on TBS0121.GRUCOD=TBS012.GRUCOD

if object_id('tempdb..#exportapro') is not null
         drop table #exportapro

create table #exportapro (linha varchar(2000))

declare @linha varchar(2000)

--insert into #exportapro       
select @linha= 'P'
       +PROCOD            -- código interno
       +PRODES            -- descrição
       +'               ' -- códigos de barras 1
       +'               ' -- códigos de barras 2
       +'               ' -- códigos de barras 3
       +'              '  -- códigos de barras 4
       +PROSTATUS         -- status
       +str(PROPESLIQ,10,3) -- peso liquido
       +str(PROPESBRU,10,3) -- peso bruto
       +PROUM1              -- 1a. unidade de medida
       +str(PROUM1QTD,10,3) -- quantidade da embalagem 1a. unidade de medida
       +PROUM2              -- 2a. unidade de medida
       +str(PROUM2QTD,10,3) -- quantidade da embalagem 2a. unidade de medida
       +PROUM3              -- 3a. unidade de medida
       +str(PROUM3QTD,10,3) -- quantidade da embalagem 3a. unidade de medida
       +PROUM4              -- 4a. unidade de medida
       +str(PROUM4QTD,10,3) -- quantidade da embalagem 4a. unidade de medida
       +str(GRUCOD,3)       -- código grupo
       +str(FORCOD,5)       -- código do fornecedor
       +str(MARCOD,4)       -- codigo da marca
       +str(PROICMSINT,5,2) -- ICMS de saida
       +str(PROIPI,5,2)     -- percentual do IPI
       +convert(char(8),PRODATCAD,3) -- data do cadastro
       +str(FABCOD,4)                -- codigo do fabricante
       +PROREFFOR                    -- referencia do fornecedor
       +PROSTBA                      -- situacao tributaria - tabela de origem
       +PROSTBB                      -- situacao tributaria - tabela de tributacao
       +PROGERPEN                    -- se produto deve gerar pendencia
       +PROWEB                       -- se produto na web
       +MARNOM                       -- marca
       +FORNOM                       -- fornecedor
       +PROUMV                       -- menor unidade de venda
       +PROCLAFIS                    -- classificao fiscal
       +PROCSN                       -- CSOSN (simples nacional)
--       as linha

  into #exportapro

  from TBS010
 where MARCOD=164
 
select * from #exportapro
*/


declare @comandoSQL varchar(2500), @codigos varchar(1000)

-- produtos

-- cabeçalho

set @comandoSQL  = 'bcp "select ''EXPORTACAO::PRODUTOS::VERSAO=ABR2019''"'
set @comandoSQL += ' queryout "C:\integros\temp\cab-produtos.txt" -c -t "" -T'

exec master.dbo.xp_cmdshell @comandoSQL

print iif(@@error=0, 'cab-produtos.txt, gravado com sucesso', 'erro ao gravar cab-produtos.txt')

set @codigos='''0050229'',''6522999'',''18990212'',''7885946'',''1080067'''

--set @codigos='''0050042'',''0051470'',''0090882'',''0631245'',''10000039'',''10001112'',''10840045'',''10840060'',''11260029'',''1580019'',''1580021'',''16310001'',''16310036'',''16420005'',''16530046'',''16530146'',''18990080'',''25810002'',''25980001'',''7600259'',''7887817'',''8490171'',''8770065'',''8770107'',''8770109'',''8770111'',''8870227'',''9120001'''
--set @codigos='''1080067'''
--print @codigos

-- dados dos produtos

set @comandoSQL  = 'bcp "select ''P'''
set @comandoSQL +=               ',''99''+subString(PROCOD,1,13)' -- código interno
set @comandoSQL +=               ',PRODES' -- descrição
set @comandoSQL +=               ',replicate('' '',15)' -- códigos de barras 1
set @comandoSQL +=               ',replicate('' '',15)' -- códigos de barras 2
set @comandoSQL +=               ',replicate('' '',15)' -- códigos de barras 3
set @comandoSQL +=               ',replicate('' '',14)' -- códigos de barras 4
set @comandoSQL +=               ',PROSTATUS'           -- status
set @comandoSQL +=               ',str(PROPESLIQ,10,3)' -- peso liquido
set @comandoSQL +=               ',str(PROPESBRU,10,3)' -- peso bruto
set @comandoSQL +=               ',PROUM1'              -- 1a. unidade de medida
set @comandoSQL +=               ',str(PROUM1QTD,10,3)' -- quantidade da embalagem 1a. unidade de medida
set @comandoSQL +=               ',PROUM2'              -- 2a. unidade de medida
set @comandoSQL +=               ',str(PROUM2QTD,10,3)' -- quantidade da embalagem 2a. unidade de medida
set @comandoSQL +=               ',PROUM3'              -- 3a. unidade de medida
set @comandoSQL +=               ',str(PROUM3QTD,10,3)' -- quantidade da embalagem 3a. unidade de medida
set @comandoSQL +=               ',PROUM4'              -- 4a. unidade de medida
set @comandoSQL +=               ',str(PROUM4QTD,10,3)' -- quantidade da embalagem 4a. unidade de medida
set @comandoSQL +=               ',str(TBS010.GRUCOD,3)'       -- código grupo
set @comandoSQL +=               ',str(FORCOD,5)'       -- código do fornecedor

--set @comandoSQL +=               ',str(MARCOD,4)'       -- codigo da marca
set @comandoSQL +=               ',str(9999,4)'       -- codigo da marca

set @comandoSQL +=               ',str(PROICMSINT,5,2)' -- ICMS de saida
set @comandoSQL +=               ',str(PROIPI,5,2)'              -- percentual do IPI
set @comandoSQL +=               ',convert(char(8),PRODATCAD,3)' -- data do cadastro
set @comandoSQL +=               ',str(FABCOD,4)'                -- codigo do fabricante
set @comandoSQL +=               ',PROREFFOR'                    -- referencia do fornecedor
set @comandoSQL +=               ',PROSTBA'                      -- situacao tributaria - tabela de origem
set @comandoSQL +=               ',PROSTBB'                      -- situacao tributaria - tabela de tributacao
set @comandoSQL +=               ',PROGERPEN'                    -- se produto deve gerar pendencia
set @comandoSQL +=               ',PROWEB'                       -- se produto na web
set @comandoSQL +=               ',MARNOM'                       -- marca
set @comandoSQL +=               ',FORNOM'                       -- fornecedor
set @comandoSQL +=               ',PROUMV'                       -- menor unidade de venda
set @comandoSQL +=               ',PROCLAFIS'                    -- classificao fiscal
set @comandoSQL +=               ',PROCSN'                       -- CSOSN (simples nacional)
set @comandoSQL +=               ',str(TGZCOD,2)'                -- codigo tributacao GZ
set @comandoSQL +=               ',str(TBS010.SUBGRUCOD,3)'             -- codigo subgrupo
set @comandoSQL +=               ',PROPESAVEL'                   -- produto pesavel
set @comandoSQL +=               ',str(PROREDBASICMS,8,4)'       -- redução da base de cálculo do ICMS
set @comandoSQL +=               ',convert(char(800),replace(PRODESDET,char(13)+char(10),''chr(13)+chr(10)''))'
set @comandoSQL +=               ',iif(PRODATALT is null,''01/01/1753 00:00:00'', convert(char(10),PRODATALT,103)+'' ''+convert(char(8),PRODATALT,108))' -- data da alteração
set @comandoSQL +=               ',PROUSUALT'                    -- usuário que alterou a informação
set @comandoSQL +=               ',PROCEST'                      -- CEST
set @comandoSQL +=               ',GRUDES'                       -- nome do grupo
set @comandoSQL +=               ',SUBGRUDES'                    -- nome do subgrupo
set @comandoSQL +=               ',str(COMCOD,3)'                -- codigo do comprador

set @comandoSQL +=         ' from SIBD.dbo.TBS010 as TBS010 with (nolock)'
set @comandoSQL +=              ' Left join SIBD.dbo.TBS012 as TBS012 with (nolock)'
set @comandoSQL +=              ' on TBS012.GRUCOD=TBS010.GRUCOD'
set @comandoSQL +=              ' Left join SIBD.dbo.TBS0121 as TBS0121 with (nolock)'
set @comandoSQL +=              ' on TBS0121.GRUCOD=TBS010.GRUCOD'
set @comandoSQL +=              ' and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD'

set @comandoSQL +=        ' where PROCOD in(' + @codigos  + ')"'

set @comandoSQL += ' queryout "C:\integros\temp\produtos.txt" -c -t "" -T'

--print @comandoSQL

exec master.dbo.xp_cmdshell @comandoSQL

print iif(@@error=0, 'produtos.txt, gravado com sucesso', 'erro ao gravar produtos.txt')


-- códigos de barras

--print 'Gravando códigos de barras'
/*
set @comandoSQL  = 'bcp "select ''B'''
set @comandoSQL +=               ',CBPPROCOD'                    -- codigo do produto
set @comandoSQL +=               ',CBPCODBAR'                    -- codigo de barras
set @comandoSQL +=               ',str(CBPQTDEMB,10,3)'          -- quantidade da embalagem
set @comandoSQL +=               ',convert(char(8),CBPDATCAD,3)' -- data do cadastro
set @comandoSQL +=               ',CBPHORCAD'                    -- hora do cadastro
set @comandoSQL +=               ',CBPUSUCAD'                    -- usuario do cadastro
set @comandoSQL +=               ',convert(char(8),CBPDATALT,3)' -- data do alteracao
set @comandoSQL +=               ',CBPHORALT'                    -- hora do alteracao
set @comandoSQL +=               ',CBPUSUALT'                    -- usuario do alteracao					

set @comandoSQL +=       ' from SIBD.dbo.TBS0103 with (nolock)'

set @comandoSQL +=      ' where CBPPROCOD in(' + @codigos  + ')"'

set @comandoSQL += ' queryout "C:\integros\temp\codigos-barras.txt" -c -t "" -T'

print iif(@@error=0, 'codigos-barras.txt, gravado com sucesso', 'erro ao gravar codigos-barras.txt')

--print @comandoSQL

exec master.dbo.xp_cmdshell @comandoSQL
*/

-- juntar arquivos

--exec xp_cmdshell 'copy /b c:\integros\temp\cab-produtos.txt + c:\integros\temp\produtos.txt + c:\integros\temp\codigos-barras.txt c:\integros\temp\produtos.cad'

exec xp_cmdshell 'copy /b c:\integros\temp\cab-produtos.txt + c:\integros\temp\produtos.txt c:\integros\temp\produtos.cad'

print iif(@@error=0, 'produtos.cad, gravado com sucesso', 'erro ao gravar produtos.cad')


-- política de preços

-- arquivo de cabeçalho

set @comandoSQL  = 'bcp "select ''EXPORTACAO::POLITICA DE PRECOS::COLUNAS=931''"'
set @comandoSQL += ' queryout "C:\integros\temp\cab-politica.txt" -c -t "" -T'

exec master.dbo.xp_cmdshell @comandoSQL

print iif(@@error=0, 'cab-politica.txt, gravado com sucesso', 'erro ao gravar cab-politica.txt')


-- **
--declare @comandoSQL varchar(2500), @codigos varchar(500)

--set @codigos='''0050042'',''0051470'',''0090882'',''0631245'',''10000039'',''10001112'',''10840045'',''10840060'',''11260029'',''1580019'',''1580021'',''16310001'',''16310036'',''16420005'',''16530046'',''16530146'',''18990080'',''25810002'',''25980001'',''7600259'',''7887817'',''8490171'',''8770065'',''8770107'',''8770109'',''8770111'',''8870227'',''9120001'''

-- política de preços

--print 'Gravando política de preços'

--set @comandoSQL  = 'bcp "select ''P'''
set @comandoSQL  = 'bcp "select ''99''+subString(PDPCOD,1,13)'               -- código interno
set @comandoSQL +=               ',str(PDPIPI,9,5)'      -- percentual IPI
set @comandoSQL +=               ',str(PDPDIFICM,9,5)'   -- diferenca do ICMS
set @comandoSQL +=               ',str(PDPPIS,9,5)'      -- percentual PIS
set @comandoSQL +=               ',str(PDPCOF,9,5)'      -- percentual cofins
set @comandoSQL +=               ',str(PDPFRE,9,5)'      -- percentual frete
set @comandoSQL +=               ',str(PDPCUSADM,9,5)'   -- custo administrativo
set @comandoSQL +=               ',str(PDPCMS,9,5)'      -- percentual comissao
set @comandoSQL +=               ',str(PDPMKPCOR1,9,5)'  -- margem lucro 1 corporativo
set @comandoSQL +=               ',str(PDPMKPCOR2,9,5)'  -- margem lucro 2 corporativo
set @comandoSQL +=               ',str(PDPMKPLOJ1,9,5)'  -- margem lucro 1 loja
set @comandoSQL +=               ',str(PDPMKPLOJ2,9,5)'  -- margem lucro 2 loja
set @comandoSQL +=               ',str(PDPMKPREV1,9,5)'  -- margem lucro 1 revenda
set @comandoSQL +=               ',str(PDPMKPREV2,9,5)'  -- margem lucro 2 revenda
set @comandoSQL +=               ',str(PDPMKPWE11,9,5)'  -- margem lucro 1 web 1
set @comandoSQL +=               ',str(PDPMKPWE12,9,5)'  -- margem lucro 2 web 1
set @comandoSQL +=               ',str(PDPMKPWE21,9,5)'  -- margem lucro 1 web 2
set @comandoSQL +=               ',str(PDPMKPWE22,9,5)'  -- margem lucro 2 web 2
set @comandoSQL +=               ',str(PDPMKPPRO1,9,5)'  -- margem lucro 1 promocao
set @comandoSQL +=               ',str(PDPMKPPRO2,9,5)'  -- margem lucro 2 promocao
set @comandoSQL +=               ',convert(char(8),PDPVALPROI,3)' -- validade inicial da promocao
set @comandoSQL +=               ',convert(char(8),PDPVALPROF,3)' -- validade inicial da promocao
set @comandoSQL +=               ',PDPPROCOR'            -- promocao valida para o corporativo
set @comandoSQL +=               ',PDPPROLOJ'            -- promocao valida para a loja
set @comandoSQL +=               ',PDPPROWE1'            -- promocao valida para a web 1
set @comandoSQL +=               ',PDPPROWE2'            -- promocao valida para a web 2
set @comandoSQL +=               ',PDPPROREV'            -- promocao valida para a revenda
set @comandoSQL +=               ',str(PDPPDD1,9,5)'     -- percentual desconto 1
set @comandoSQL +=               ',str(PDPPDD2,9,5)'     -- percentual desconto 2
set @comandoSQL +=               ',str(PDPPDD3,9,5)'     -- percentual desconto 3
set @comandoSQL +=               ',str(PDPPDD4,9,5)'     -- percentual desconto 4
set @comandoSQL +=               ',str(PDPPDD5,9,5)'     -- percentual desconto 5
set @comandoSQL +=               ',str(PDPPREFOR,12,2)'  -- preco do fornecedor
set @comandoSQL +=               ',PDPUNI'               -- unidade de medida
set @comandoSQL +=               ',str(PDPQTDEMB,10,3)'  -- quantidade da embalagem
set @comandoSQL +=               ',str(PDPPREUNI,12,4)'  -- preco unitario
set @comandoSQL +=               ',PDPSEGFOR'            -- politica de precos por fornecedor
set @comandoSQL +=               ',str(PDPREDCOR1,9,5)'  -- reducao preco 1 corporativo
set @comandoSQL +=               ',str(PDPREDCOR2,9,5)'  -- reducao preco 2 corporativo
set @comandoSQL +=               ',str(PDPREDCOR3,9,5)'  -- reducao preco 3 corporativo
set @comandoSQL +=               ',str(PDPREDCOR4,9,5)'  -- reducao preco 4 corporativo
set @comandoSQL +=               ',str(PDPREDLOJ1,9,5)'  -- reducao preco 1 loja
set @comandoSQL +=               ',str(PDPREDLOJ2,9,5)'  -- reducao preco 2 loja
set @comandoSQL +=               ',str(PDPREDLOJ3,9,5)'  -- reducao preco 3 loja
set @comandoSQL +=               ',str(PDPREDLOJ4,9,5)'  -- reducao preco 4 loja
set @comandoSQL +=               ',str(PDPREDREV1,9,5)'  -- reducao preco 1 revenda
set @comandoSQL +=               ',str(PDPREDREV2,9,5)'  -- reducao preco 2 revenda
set @comandoSQL +=               ',str(PDPREDREV3,9,5)'  -- reducao preco 3 revenda
set @comandoSQL +=               ',str(PDPREDREV4,9,5)'  -- reducao preco 4 revenda
set @comandoSQL +=               ',str(PDPREDWE11,9,5)'  -- reducao preco 1 web 1
set @comandoSQL +=               ',str(PDPREDWE12,9,5)'  -- reducao preco 2 web 1
set @comandoSQL +=               ',str(PDPREDWE13,9,5)'  -- reducao preco 3 web 1
set @comandoSQL +=               ',str(PDPREDWE14,9,5)'  -- reducao preco 4 web 1
set @comandoSQL +=               ',str(PDPREDWE21,9,5)'  -- reducao preco 1 web 2
set @comandoSQL +=               ',str(PDPREDWE22,9,5)'  -- reducao preco 2 web 2
set @comandoSQL +=               ',str(PDPREDWE23,9,5)'  -- reducao preco 3 web 2
set @comandoSQL +=               ',str(PDPREDWE24,9,5)'  -- reducao preco 4 web 2
set @comandoSQL +=               ',str(PDPREDPRO1,9,5)'  -- reducao preco 1 promocao
set @comandoSQL +=               ',str(PDPREDPRO2,9,5)'  -- reducao preco 2 promocao
set @comandoSQL +=               ',str(PDPREDPRO3,9,5)'  -- reducao preco 3 promocao
set @comandoSQL +=               ',str(PDPREDPRO4,9,5)'  -- reducao preco 4 promocao

set @comandoSQL +=               ',convert(char(8),PDPDATALT,3)' -- data alteracao dados
set @comandoSQL +=               ',PDPHORALT'            -- Hora alteracao dados
set @comandoSQL +=               ',convert(char(8),PDPDATCAD,3)' -- data do cadastro

set @comandoSQL +=               ',str(TBS015.MOECOD,2,0)'      -- codigo da moeda
set @comandoSQL +=               ',MOENOM'               -- nome da moeda
set @comandoSQL +=               ',str(MOEVAL,12,4)'     -- valor da moeda
set @comandoSQL +=               ',convert(char(8),MOEDATATU,3)' -- data da atualizacao

/*
set @comandoSQL +=               ', 0'      -- codigo da moeda
set @comandoSQL +=               ',replicate('' '',20)'               -- nome da moeda
set @comandoSQL +=               ',str(0,12,4)'     -- valor da moeda
set @comandoSQL +=               ',''17530101''' -- data da atualizacao
*/

set @comandoSQL +=               ',PRODES'               -- descricao do produto
set @comandoSQL +=               ',str(PDPPORST,8,4)'    -- porcentagem da substituicao tributaria
set @comandoSQL +=               ',str(PDPPRECOR1,12,4)' -- preco para a 1a unidade do corporativo
set @comandoSQL +=               ',str(PDPPRECOR2,12,4)' -- preco para a 2a unidade do corporativo
set @comandoSQL +=               ',str(PDPPRECOR3,12,4)' -- preco para a 3a unidade do corporativo
set @comandoSQL +=               ',str(PDPPRECOR4,12,4)' -- preco para a 4a unidade do corporativo
set @comandoSQL +=               ',str(PDPPRELOJ1,12,4)' -- preco para a 1a unidade da loja
set @comandoSQL +=               ',str(PDPPRELOJ2,12,4)' -- preco para a 2a unidade da loja
set @comandoSQL +=               ',str(PDPPRELOJ3,12,4)' -- preco para a 3a unidade da loja
set @comandoSQL +=               ',str(PDPPRELOJ4,12,4)' -- preco para a 4a unidade da loja
set @comandoSQL +=               ',str(PDPPREREV1,12,4)' -- preco para a 1a unidade de revenda
set @comandoSQL +=	         ',str(PDPPREREV2,12,4)' -- preco para a 2a unidade de revenda
set @comandoSQL +=               ',str(PDPPREREV3,12,4)' -- preco para a 3a unidade de revenda
set @comandoSQL +=               ',str(PDPPREREV4,12,4)' -- preco para a 4a unidade de revenda
	
set @comandoSQL +=               ',str(PDPPREWE11,12,4)' -- preco para a 1a unidade da web1
set @comandoSQL +=               ',str(PDPPREWE12,12,4)' -- preco para a 2a unidade da web1
set @comandoSQL +=               ',str(PDPPREWE13,12,4)' -- preco para a 3a unidade da web1
set @comandoSQL +=               ',str(PDPPREWE14,12,4)' -- preco para a 4a unidade da web1
	
set @comandoSQL +=               ',str(PDPPREWE21,12,4)' -- preco para a 1a unidade da web2
set @comandoSQL +=               ',str(PDPPREWE22,12,4)' -- preco para a 2a unidade da web2
set @comandoSQL +=               ',str(PDPPREWE23,12,4)' -- preco para a 3a unidade da web2
set @comandoSQL +=               ',str(PDPPREWE24,12,4)' -- preco para a 4a unidade da web2
	
set @comandoSQL +=               ',str(PDPPREPRO1,12,4)' -- preco para a 1a unidade da promocao
set @comandoSQL +=               ',str(PDPPREPRO2,12,4)' -- preco para a 2a unidade da promocao
set @comandoSQL +=               ',str(PDPPREPRO3,12,4)' -- preco para a 3a unidade da promocao
set @comandoSQL +=               ',str(PDPPREPRO4,12,4)' -- preco para a 4a unidade da promocao
	
set @comandoSQL +=               ',str(MARCOD, 4, 0)'    -- preco para a 4a unidade da promocao
--set @comandoSQL +=               ',str(9999,4)'       -- codigo da marca

set @comandoSQL +=        ' from SIBD.dbo.TBS015 as TBS015 with (nolock)'
set @comandoSQL +=             ' Left join SIBD.dbo.TBS044 as TBS044 with (nolock)'
set @comandoSQL +=             ' on TBS044.MOECOD=TBS015.MOECOD'

set @comandoSQL +=       ' where PDPCOD in(' + @codigos  + ')"'

set @comandoSQL += ' queryout "c:\integros\temp\politica-precos.txt" -c -t "" -T'

print @comandoSQL

exec master.dbo.xp_cmdshell @comandoSQL

print iif(@@error=0, 'politica-precos.txt, gravado com sucesso', 'erro ao gravar politica-precos.txt')


--EXEC xp_cmdshell 'dir c:\integros\temp\*.txt'

--EXEC xp_cmdshell 'for %f in (c:\integros\temp\arquivo?.txt) do tipo "%f" >> arquivao.txt'

-- juntar arquivos

exec xp_cmdshell 'copy /b c:\integros\temp\cab-politica.txt + c:\integros\temp\politica-precos.txt c:\integros\temp\politica.pol'

print iif(@@error=0, 'politica.pol, gravado com sucesso', 'erro ao gravar politica.pol')

--GRANT exec ON xp_cmdshell TO si
--GO

--EXECUTE msdb..sp_set_sqlagent_properties @sysadmin_only = 0
--GO
