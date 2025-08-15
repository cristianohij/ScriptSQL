select top 500
       right('000000' + Ltrim(str(row_number() over(order by CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD),6)),6) +  -- 1 sequencia
       --'0000001' +
       ',' +
       convert(char(8),CREDATEMI,112) +   -- 2 data do lançamento
       ',' +
       '00004561' +   -- 3 conta a débito (banco)
       ',' +
       '00000159' +   -- 4 conta a crédito (cliente)
       ',' +
       right('000000000000000' + (Ltrim(str(SIBD.dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD),15,2))),15) +   -- 5 valor contábil
       ',' +
       '000671' +   -- 6 código do histórico (recebimento)
       ',' +
       Left(rtrim(TBS002.CLINOM) + replicate(' ',200) ,200) +   -- 7 complemento do histórico (nome do cliente)
       ',' +
       right('DCTO00000000000' + cast(CRETIT as varchar(6)),6) +   -- 8 número do documento
       ',' +
       'LOTE' +   -- 9 lote
       ',' +
       case when CLITIPPES='J' then rtrim(CLICGC) else rtrim(CLICPF) end +   -- 10 CNPJ/CPF
       ',' +
       'A' +   -- 11 contabiliza IFRS
       ',' +
       'TR1' +   -- 12 transação SPED
       ',' +
       'CONC1'   -- 13 indicador de conciliação
  from TBS056 (nolock)
       inner join TBS002 (nolock) on TBS002.CLICOD=TBS056.CLICOD
 where CREDATEMI between '20161201' and '20161231' and
       dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD) > 0



declare @comando varchar(1000)
set @comando = 'bcp "select top 500 right(''000000'' + Ltrim(str(row_number() over(order by CREEMPCOD,PFXEMPCOD,TBS056.CLIEMPCOD,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD),6)),6) + '','' + convert(char(8),CREDATEMI,112) + '','' + ''00004561'' + '','' + ''00000159'' + '','' + right(''000000000000000'' + (Ltrim(str(SIBD.dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD),15,2))),15) + '','' + ''000671'' + '','' + Left(rtrim(TBS002.CLINOM) + replicate('' '',200) ,200) + '','' + subString(''DCTO00000000000'',1,15-Len(cast(CRETIT as varchar(6)))) + cast(CRETIT as varchar(6)) + '','' + ''LOTE'' + '','' + case when CLITIPPES=''J'' then rtrim(CLICGC) else rtrim(CLICPF) end + '','' + ''A'' + '','' + ''TR1'' + '','' + ''CONC1'' from SIBD.dbo.TBS056 TBS056 (nolock) inner join SIBD.dbo.TBS002 TBS002 (nolock) on TBS002.CLICOD=TBS056.CLICOD where CREDATEMI between ''20161201'' and ''20161231'' and SIBD.dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD) > 0" queryout c:\integros\temp\integra-contabil.txt -c -T -t","'

exec master..xp_cmdshell @comando


-- corrigido para rodar na tella
declare @comando varchar(1000)
set @comando = 'bcp "select right(''000000'' + Ltrim(str(1,6)),6) + '','' + convert(char(8),case when CREVALREC > 0 then CREDATBAI else CREDATEMI end,112) + '','' + ''00004561'' + '','' + ''00000159'' + '','' + right(''000000000000000'' + (Ltrim(str(case when CREVALREC > 0 then CREVALREC else SIBD.dbo.CREVALSDO(0,0,0,PFXCOD,CRETIT,CREPAR,TBS056.CLICOD) end  ,15,2))),15) + '','' + ''000671'' + '','' + Left(rtrim(TBS002.CLINOM) + replicate('' '',200) ,200) + '','' + subString(''DCTO00000000000'',1,15-Len(cast(CRETIT as varchar(6)))) + cast(CRETIT as varchar(6)) + '','' + ''LOTE'' + '','' + case when CLITIPPES=''J'' then rtrim(CLICGC) else rtrim(CLICPF) end + '','' + ''A'' + '','' + ''TR1'' + '','' + ''CONC1'' from SIBD.dbo.TBS056 TBS056 (nolock) inner join SIBD.dbo.TBS002 TBS002 (nolock) on TBS002.CLICOD=TBS056.CLICOD where CREDATEMI between ''20170301'' and ''20170331''" queryout c:\integros\temp\integra-contabil.txt -c -T -t","'

exec master..xp_cmdshell @comando


-- por data do recebimento - alterado 17/04/17

-- corrigido para rodar na tella
declare @comando varchar(1000)
set @comando = 'bcp "select right(''000000'' + Ltrim(str(1,6)),6) + '','' + convert(char(8),CREDATBAI,112) + '','' + ''00004561'' + '','' + ''00000159'' + '','' + right(''000000000000000'' + (Ltrim(str(CREVALREC,15,2))),15) + '','' + ''000671'' + '','' + Left(rtrim(TBS002.CLINOM) + replicate('' '',200) ,200) + '','' + subString(''DCTO00000000000'',1,15-Len(cast(CRETIT as varchar(6)))) + cast(CRETIT as varchar(6)) + '','' + ''LOTE'' + '','' + case when CLITIPPES=''J'' then rtrim(CLICGC) else rtrim(CLICPF) end + '','' + ''A'' + '','' + ''TR1'' + '','' + ''CONC1'' from SIBD.dbo.TBS056 TBS056 (nolock) inner join SIBD.dbo.TBS002 TBS002 (nolock) on TBS002.CLICOD=TBS056.CLICOD where CREDATBAI between ''20170301'' and ''20170331'' and CREVALREC > 0" queryout c:\integros\temp\integra-contabil.txt -c -T -t","'

exec master..xp_cmdshell @comando
