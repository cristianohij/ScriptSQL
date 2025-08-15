select PROCOD,PROCLAFIS,PRODES,PROSTATUS from TBS010 (nolock)
 where PROCLAFIS<>'' and PROSTATUS='A' and
       not exists(select * 
                         from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\TabelaIBPTaxSP18.2.B.xlsx', 'select * from [TabelaIBPTaxSP18.2.B$]')
                   where codigo=PROCLAFIS collate database_default)

select * from TBS092 (nolock)
 where not exists(select * 
                    from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\integros\temp\TabelaIBPTaxSP18.2.B.xlsx', 'select * from [TabelaIBPTaxSP18.2.B$]')
                   where codigo=NCMCOD collate database_default)


INSERT INTO OPENROWSET (�Microsoft.ACE.OLEDB.12.0�, �Excel 12.0;Database=D:\AdvWorks_Jobs.xlsx;�,
�Select LoginID, JobTitle From [Sheet1$]�)
Select LoginID, JobTitle From HumanResources.Employee
Go

-- leiaute completo:
/*
        COD_ITEM,
        DESCR_ITEM,
        COD_BARRA,
        COD_ANT_ITEM,
        UNID_INV,
        TIPO_ITEM,
        COD_NCM,
        EX_IPI,
        COD_LST,
        COD_SERV_BLOCO_P,
        ALIQ_ICMS,
        COD_GRUPO,
        DESC_GRUPO,
        COD_SEFAZ,
        CSOSN,
        CST_ICMS,
        PER_RED_BC_ICMS,
        BC_ICMS_ST,
        CST_IPI_ENTRADA,
        CST_IPI_SAIDA,
        ALIQ_IPI,
        CST_PIS_COFINS_SAIDA,
        CST_PIS_COFINS_ENTRADA,
        NAT_REC_PIS_COFINS,
        APURACAO_PIS_COFINS,
        ALIQ_PIS,
        ALIQ_COFINS,
        CC,
        DATA_INC_ALTERACAO,
        COD_NAT,
        IND_TIPO_CONTA,
        NIVEL,
        NOME_CONTA,
        COD_CENTRO_DE_CUSTOS,
        DATA_INC_ALTERACAO_CUSTOS,
        NOME_CENTRO_CUSTOS,
        COD_PLANO_CONTAS_REF,
        CNPJ_ESTABELECIMENTO,
        OBSERVACAO,
        COD_CEST
*/

insert into openrowset ('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos.xlsx;',
'select COD_ITEM,
        DESCR_ITEM,
        COD_BARRA,
        UNID_INV,
        TIPO_ITEM,
        COD_NCM,
        ALIQ_ICMS,
        CST_ICMS,
        PER_RED_BC_ICMS,
        CST_IPI_ENTRADA,
        CST_IPI_SAIDA,
        CST_PIS_COFINS_SAIDA,
        CST_PIS_COFINS_ENTRADA,
        ALIQ_PIS,
        ALIQ_COFINS,
        CNPJ_ESTABELECIMENTO,
        COD_CEST
   from [Produto$]')
select top 10 
       PROCOD,
       PRODES,
       PROCODBAR1,
       PROUM1,
       '00',
       PROCLAFIS,
       case when PROICMSINT=0 then 18 else PROICMSINT end,
       PROSTBA+PROSTBB,
       PROREDBASICMS,
       '',
       '',
       case when PROSTBPIS='' then '01' else PROSTBPIS end,
       '',
       case when PROSTBPIS='' then '1.65' else '0' end,
       case when PROSTBPIS='' then '7.60' else '0' end,
       (select EMPCGC from TBS023 with (nolock) where EMPCOD = (case when Left(EMPNOM,8)='BEST BAG' then 2 else 1 end)),
       PROCEST
  from TBS010 with (nolock)
 where PROSTATUS<>'E'
       and exists(select '' from SPED_ES with (nolock) where COD_ITEM=PROCOD)
Go


select 'COD_ITEM;DESCR_ITEM;COD_BARRA;UNID_INV;TIPO_ITEM;COD_NCM;ALIQ_ICMS;COD_GRUPO;DESC_GRUPO;CST_ICMS;PER_RED_BC_ICMS;CST_IPI_ENTRADA;CST_IPI_SAIDA;CST_PIS_COFINS_SAIDA;CST_PIS_COFINS_ENTRADA;ALIQ_PIS;ALIQ_COFINS;CNPJ_ESTABELECIMENTO;COD_CEST'

select 'COD_ITEM;DESCR_ITEM;COD_BARRA;COD_ANT_ITEM;UNID_INV;TIPO_ITEM;COD_NCM;EX_IPI;COD_LST;COD_SERV_BLOCO_P;ALIQ_ICMS;COD_GRUPO;DESC_GRUPO;COD_SEFAZ;CSOSN;CST_ICMS;PER_RED_BC_ICMS;BC_ICMS_ST;CST_IPI_ENTRADA;CST_IPI_SAIDA;ALIQ_IPI;CST_PIS_COFINS_SAIDA;CST_PIS_COFINS_ENTRADA;NAT_REC_PIS_COFINS;APURACAO_PIS_COFINS;ALIQ_PIS;ALIQ_COFINS;CC;DATA_INC_ALTERACAO;COD_NAT;IND_TIPO_CONTA;NIVEL;NOME_CONTA;COD_CENTRO_DE_CUSTOS;DATA_INC_ALTERACAO_CUSTOS;NOME_CENTRO_CUSTOS;COD_PLANO_CONTAS_REF;CNPJ_ESTABELECIMENTO;OBSERVACAO;COD_CEST;REV_STPISCOFINS'

-- COD_ITEM;DESCR_ITEM;COD_BARRA;UNID_INV;TIPO_ITEM;COD_NCM;ALIQ_ICMS;COD_GRUPO;DESC_GRUPO;CST_ICMS;PER_RED_BC_ICMS;CST_IPI_ENTRADA;CST_IPI_SAIDA;CST_PIS_COFINS_SAIDA;CST_PIS_COFINS_ENTRADA;ALIQ_PIS;ALIQ_COFINS;CNPJ_ESTABELECIMENTO;COD_CEST

-- Utilizando queryout, pode-se exportar o resultado de uma query
EXEC master.dbo.xp_cmdshell 'bcp "select ''C''+rtrim(PROCOD),rtrim(PRODES),''SEM GTIN'','''',PROUM1,''C00'',case Len(PROCLAFIS) when 8 then Left(PROCLAFIS,4)+''.''+subString(PROCLAFIS,5,2)+''.''+right(PROCLAFIS,2) else '''' end,'''','''','''',case when PROICMSINT=0 then 18 else Ltrim(str(PROICMSINT,2)) end,''1'',''Revenda'','''','''',''C''+PROSTBA+PROSTBB,Ltrim(str(PROREDBASICMS,9,2)),''0'','''',''0'','''',case when PROSTBPIS='''' then ''C01'' else ''C''+PROSTBPIS end,case when PROSTBPIS='''' then ''C01'' else ''C''+PROSTBPIS end,'''','''',case when PROSTBPIS='''' then ''1.65'' else ''0'' end,case when PROSTBPIS='''' then ''7.60'' else ''0'' end,''1.01.03.01.01.01'','''','''','''','''','''','''','''','''','''',(select ''C''+EMPCGC from SIBD.dbo.TBS023 with (nolock) where EMPCOD = (case when Left(EMPNOM,8)=''BEST BAG'' then 2 else 1 end)),'''',PROCEST,''NÃO'' from SIBD.dbo.TBS010 with (nolock) where PROSTATUS<>''E''" queryout "C:\integros\temp\produtos.csv" -c -t; -T'

-- nova
EXEC master.dbo.xp_cmdshell 'bcp "select ''C''+rtrim(PROCOD),rtrim(PRODES),''SEM GTIN'','''',PROUM1,''C00'',case Len(PROCLAFIS) when 8 then Left(PROCLAFIS,4)+''.''+subString(PROCLAFIS,5,2)+''.''+right(PROCLAFIS,2) else '''' end,'''','''','''',case when PROICMSINT=0 then 18 else Ltrim(str(PROICMSINT,2)) end,''1'',''Revenda'','''','''',''C''+PROSTBA+PROSTBB,Ltrim(str(PROREDBASICMS,9,2)),''0'','''','''',''0'','''','''','''','''',case when PROSTBPIS='''' then ''1.65'' else ''0'' end,case when PROSTBPIS='''' then ''7.60'' else ''0'' end,''1.01.03.01.01.01'','''','''','''','''','''','''','''','''','''',(select ''C''+EMPCGC from SIBD.dbo.TBS023 with (nolock) where EMPCOD = (case when Left(EMPNOM,8)=''BEST BAG'' then 2 else 1 end)),'''',PROCEST,''NÃO'' from SIBD.dbo.TBS010 with (nolock) where PROSTATUS<>''E''" queryout "C:\integros\temp\produtos.csv" -c -t; -T'

-- best bag
--EXEC master.dbo.xp_cmdshell 'bcp "select rtrim(PROCOD),rtrim(PRODES),rtrim(PROCODBAR1),PROUM1,''00'',rtrim(PROCLAFIS),case when PROICMSINT=0 then 18 else Ltrim(str(PROICMSINT,2)) end,''1'',''Revenda'',PROSTBA+PROSTBB,Ltrim(str(PROREDBASICMS,9,2)),''49'',''99'',case when PROSTBPIS='''' then ''01'' else PROSTBPIS end,case when PROSTBPIS='''' then ''01'' else PROSTBPIS end,case when PROSTBPIS='''' then ''1.65'' else ''0'' end,case when PROSTBPIS='''' then ''7.60'' else ''0'' end,(select EMPCGC from SIBD2.dbo.TBS023 with (nolock) where EMPCOD = (case when Left(EMPNOM,8)=''BEST BAG'' then 2 else 1 end)),PROCEST from SIBD2.dbo.TBS010 with (nolock) where PROSTATUS<>''E''" queryout "C:\integros\temp\produtos.csv" -c -t; -T'

EXEC master.dbo.xp_cmdshell 'bcp "select ''C''+rtrim(PROCOD),rtrim(PRODES),''SEM GTIN'','''',PROUM1,''C00'',case Len(PROCLAFIS) when 8 then Left(PROCLAFIS,4)+''.''+subString(PROCLAFIS,5,2)+''.''+right(PROCLAFIS,2) else '''' end,'''','''','''',case when PROICMSINT=0 then 18 else Ltrim(str(PROICMSINT,2)) end,''1'',''Revenda'','''','''',''C''+PROSTBA+PROSTBB,Ltrim(str(PROREDBASICMS,9,2)),''0'','''',''0'','''',case when PROSTBPIS='''' then ''C01'' else ''C''+PROSTBPIS end,case when PROSTBPIS='''' then ''C01'' else ''C''+PROSTBPIS end,'''','''',case when PROSTBPIS='''' then ''1.65'' else ''0'' end,case when PROSTBPIS='''' then ''7.60'' else ''0'' end,''1.01.03.01.01.01'','''','''','''','''','''','''','''','''','''',(select ''C''+EMPCGC from SIBD2.dbo.TBS023 with (nolock) where EMPCOD = (case when Left(EMPNOM,8)=''BEST BAG'' then 2 else 1 end)),'''',PROCEST,''NÃO'' from SIBD2.dbo.TBS010 with (nolock) where PROSTATUS<>''E''" queryout "C:\integros\temp\produtos.csv" -c -t; -T'

-- para o CD

select rtrim(PROCOD),
       rtrim(PRODES),
       rtrim(PROCODBAR1),
       PROUM1,
       '00',
       rtrim(PROCLAFIS),
       case
          when PROICMSINT=0 then 18
          else Ltrim(str(PROICMSINT,2))
       end,
       '1',
       'Revenda',
       PROSTBA+PROSTBB,
       Ltrim(str(PROREDBASICMS,9,2)),
       '49',
       '99',
       case
          when PROSTBPIS='' then '01'
          else PROSTBPIS
       end,
       case
          when PROSTBPIS='' then '01'
          else PROSTBPIS
       end,
       case
          when PROSTBPIS='' then '1.65'
          else '0'
       end,
       case
          when PROSTBPIS='' then '7.60'
          else '0'
       end,
       (select EMPCGC
          from SIBD.dbo.TBS023 with (nolock)
         where EMPCOD = (case
                            when Left(EMPNOM,8)='BEST BAG' then 2 else 1
                         end)
       ),
       PROCEST
  from SIBD.dbo.TBS010 with (nolock)
 where PROSTATUS<>'E'

EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO  

-- somente itens do SPED
EXEC master.dbo.xp_cmdshell 'bcp "select rtrim(PROCOD),rtrim(PRODES),rtrim(PROCODBAR1),PROUM1,''00'',rtrim(PROCLAFIS),case when PROICMSINT=0 then 18 else Ltrim(str(PROICMSINT,2)) end,''1'',''Revenda'',PROSTBA+PROSTBB,Ltrim(str(PROREDBASICMS,9,2)),''49'',''99'',case when PROSTBPIS='''' then ''01'' else PROSTBPIS end,case when PROSTBPIS='''' then ''01'' else PROSTBPIS end,case when PROSTBPIS='''' then ''1.65'' else ''0'' end,case when PROSTBPIS='''' then ''7.60'' else ''0'' end,(select EMPCGC from SIBD.dbo.TBS023 with (nolock) where EMPCOD = (case when Left(EMPNOM,8)=''BEST BAG'' then 2 else 1 end)),PROCEST from SIBD.dbo.TBS010 with (nolock) where PROSTATUS<>''E'' and exists(select '''' from SIBD.dbo.SPED_ES with (nolock) where COD_ITEM=PROCOD)" queryout "C:\integros\temp\produtos.csv" -c -t; -T'

-- somente itens do SPED: best bag
EXEC master.dbo.xp_cmdshell 'bcp "select rtrim(PROCOD),rtrim(PRODES),rtrim(PROCODBAR1),PROUM1,''00'',rtrim(PROCLAFIS),case when PROICMSINT=0 then 18 else Ltrim(str(PROICMSINT,2)) end,''1'',''Revenda'',PROSTBA+PROSTBB,Ltrim(str(PROREDBASICMS,9,2)),''49'',''99'',case when PROSTBPIS='''' then ''01'' else PROSTBPIS end,case when PROSTBPIS='''' then ''01'' else PROSTBPIS end,case when PROSTBPIS='''' then ''1.65'' else ''0'' end,case when PROSTBPIS='''' then ''7.60'' else ''0'' end,(select EMPCGC from SIBD2.dbo.TBS023 with (nolock) where EMPCOD = (case when Left(EMPNOM,8)=''BEST BAG'' then 2 else 1 end)),PROCEST from SIBD2.dbo.TBS010 with (nolock) where PROSTATUS<>''E'' and exists(select '''' from SIBD2.dbo.SPED_ES with (nolock) where COD_ITEM=PROCOD)" queryout "C:\integros\temp\produtos.csv" -c -t; -T'
