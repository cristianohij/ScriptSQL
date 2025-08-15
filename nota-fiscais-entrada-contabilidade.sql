-- cria a tabela tamporária

create table #arq(dir char(256),nivel smallint, tipo smallint)

-- variável diretório

declare @diretorio as varchar(200)

set @diretorio='c:\integros\temp\xml'
--set @diretorio='c:\Documents\GRM\xml\entrada\2023\tanby\cd\07-jul'
--set @diretorio='c:\Documents\GRM\xml\entrada\2023\tanby\taubate\07-jul'

--set @diretorio='c:\Documents\GRM\xml\entrada\2023\best-bag\07-jul'
--set @diretorio='c:\Documents\GRM\xml\entrada\2023\misaspel\07-jul'
--set @diretorio='c:\Documents\GRM\xml\entrada\2023\papelyna\07-jul'

--set @diretorio='c:\Documents\GRM\xml\entrada\2023\winpack\07-jul'

--set @diretorio='c:\integros\temp\xml\07-jul'

-- insere os registro na tabela temporária

insert into #arq EXEC master.dbo.xp_dirtree @diretorio, 0, 1

-- update na tabela temporária

update #arq set dir=replace(dir,'_','') where tipo=1

-- captura os dados das notas fiscais

drop table #nfe
go

declare @dataDe as datetime, @dataAte as datetime, @empresa as smallint

set @dataDe ='20250701'
set @dataAte='20250731'

set @empresa=1

select convert(char(8),NFEDATEFE,112) as data,
       NFENUM,
       NFESERDOC,
       case
          when NFETIP in('N','T') then isnull((select FORCGC from TBS006 where FORCOD=NFECOD),'')
          when NFETIP='D' and NFENOSFOR='N' then isnull((select CLICGC from TBS002 where CLICOD=NFECOD),'')
          when NFETIP='D' and NFENOSFOR='S' then isnull((select EMPCGC from TBS023 where EMPCOD=@empresa),'')
          else ''
       end as cnpj,
       NFECHAACE,
       case
          when NFETIP in('N','T') then isnull((select FORCGC from TBS006 where FORCOD=NFECOD),'')
          when NFETIP='D' and NFENOSFOR='N' then isnull((select CLICGC from TBS002 where CLICOD=NFECOD),'')
          when NFETIP='D' and NFENOSFOR='S' then isnull((select EMPCGC from TBS023 where EMPCOD=@empresa),'')
          else ''
       end + '55' + right('000000000' + Ltrim(str(NFENUM,10)),9) as comp
  into #nfe
  from TBS059 with (nolock)
 where NFEDATEFE between @dataDe and @dataAte
       and NFECAN='N'
	   and NFENOSFOR='N'
 order by NFEDATEFE,NFENUM

-- lista notas faltantes

select *
  from #nfe
 where not exists(select '' from #arq
                   where tipo=1 and subString(dir,1,8)=data collate database_default and
                         replace(subString(dir,18,14),'-','')=subString(comp,1,14) collate database_default and
                         subString(dir,40,9)=subString(comp,17,9) collate database_default)

-- lista notas fiscais para uso e consumo - rodar no servidor de cada empresa

declare @datade date, @dataate date

select @datade='20250701', @dataate='20250731'

select 'move ' + (select subString(dir,1,4)+'_'+subString(dir,5,2)+'_'+subString(dir,7,2)+subString(dir,9,57)
                    from #arq
                   where subString(replace(dir,'-',''),9,44)=NFECHAACE collate database_default)
               + ' uso-consumo\'
  from TBS0591 with (nolock)
       inner join TBS059 with (nolock)
       on TBS0591.NFETIP=TBS059.NFETIP collate database_default
          and TBS0591.SERCOD=TBS059.SERCOD collate database_default
          and TBS0591.NFECOD=TBS059.NFECOD
          and TBS0591.NFENUM=TBS059.NFENUM
 where NFEUSUEFE<>''
       and NFECAN<>'S'
       and NFEDATEFE between @datade and @dataate
       and right(NFECFOP,3) in('407','556','557')
 group by NFECHAACE








