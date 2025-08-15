-- parâmetros
select 
       'insert into TBS025 select ' + ltrim(str(ch,4)) + ', ''' + rtrim(descricao) + ''', ''' + rtrim(t) + ''', ''' + isnull(rtrim(valor),'') + ''', ' +
	   '''' + convert(char(8),getdate(),112) + '''' +
	   ' where not exists(select PARCHV from TBS025 (nolock) where PARCHV=' + ltrim(str(ch,4)) + ')' + char(13) + 'go'
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\Models\integros\docs\parametros.xlsx', 'select * from [Plan1$]')

-- tabelas
select 
       'insert into TBS024 select ''' + rtrim(tabela) + ''', ''' + rtrim(nome) + ''', ''' + rtrim(sequencia) + ''', ''' + isnull(ltrim(str(valor,16)),'0') +
	   ''', ''' + rtrim(controle) + ''', ''' + rtrim(zeros) + ''', ''' + rtrim(modo) + '''' +
	   ' where not exists(select TBSNOM from TBS024 (nolock) where TBSNOM=''' + rtrim(tabela) + ''')' + char(13) + 'go'
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\Models\integros\docs\tabelas.xlsx', 'select * from [Plan1$]')

-- CST-ICMS
select 'insert into TBS039 (CSTTAB,CSTCOD,CSTDES,CSTICMS,CSTMSG,CSTDATCAD,CSTBASRED,CSTICMSST,CSTBASREDST,CSTALIICMSINTER) select ''' + CSTTAB + ''', ''' + rtrim(CSTCOD) + ''', ''' + rtrim(CSTDES) + ''', ''' + CSTICMS + ''', '''', ' +
       '''' + convert(char(8),getdate(),112) + ''', ''' + rtrim(CSTBASRED) + ''', ''' + rtrim(CSTICMSST) + ''', ''' + rtrim(CSTBASREDST) + ''', 0'
  from TBS039 (nolock)

-- CSOSN
select 'insert into TBS085 (CSNCOD,CSNDES,CSNICMS,CSNMSG,CSNDATCAD,CSNCRT,CSNCOBST,CSNPERCRE,CSNTRIB) select ''' + CSNCOD + ''', ''' + rtrim(CSNDES) + ''', ''' + rtrim(CSNICMS) + ''', '''', ' +
       '''' + convert(char(8),getdate(),112) + ''', ''' + rtrim(CSNCRT) + ''', ''' + rtrim(CSNCOBST) + ''', ''' + rtrim(CSNPERCRE) + ''', ''' + rtrim(CSNTRIB) + ''''
  from TBS085 (nolock)


-- TES: tipos de entradas/saídas

-- CST-ICMS

select * from TBS042 (nolock)

create table TES (comando varchar(500))

insert into TES
select 'insert into TBS042 (TESCOD,TESTIP,TESEST,TESDPL,TESICMS,TESCOMVEN,COPCOD,COPTIP,TESCNTVEN,TESIGNEFS) select ' +
       ltrim(str(TESCOD,3)) + ', ''' + TESTIP + ''', ''' + TESEST + ''', ''' + TESDPL + ''', ''' +
       TESICMS + ''', ''' + TESCOMVEN + ''', ''' + COPCOD + ''', ''' + COPTIP + ''', ''' + TESCNTVEN + ''', ''' +
       TESIGNEFS + ''''
  from TBS042 (nolock)

select 'update TBS042 set TESDES=''' + rtrim(TESDES) + ''', TESTXT=''' + rtrim(TESTXT) + ''' from TBS042 where TESCOD=' + ltrim(str(TESCOD,3)) from TBS042 (nolock)

drop table TES

select * from TES

select 'update TBS024 set TBSSEQ=''' + TBSSEQ + ''' from TBS024 where TBSNOM=''' + rtrim(TBSNOM) + '''' from TBS024 (nolock)



--

select 'insert into TBS120 select 0,''' + rtrim(RFDTIP) + ''', ''' + rtrim(RFDENT) + ''',''' + rtrim(RFDSAI) + ''',''' + convert(char(8),getdate(),112) + ''', ''' + 'TELLA' + ''', ''' + '17530101'','''','''''
  from TBS120 (nolock)

-- 
