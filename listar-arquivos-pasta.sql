-- XML de saídas não autorizados
select * from TBS080 (nolock) where ENFDATEMI between '20171001' and '20171031' and ENFSIT not in(6,7,8,11)

-- NF de devolução com geração de XML, não efetivadas
select * from TBS059 (nolock) where NFEDATENT between '20171001' and '20171031' and NFECAN<>'S' and NFENOSFOR='S' and NFEDATEFE='17530101'

-- NF de entradas não efetivadas
select * from TBS059 (nolock) where NFEDATENT between '20180201' and '20180228' and NFECAN<>'S' and NFEDATEFE='17530101'

-- quantidade de NF de entradas
select count(*) from TBS059 (nolock) where NFEDATENT between '20180301' and '20180331' and NFECAN<>'S' and NFEDATEFE<>'17530101'

select * from master..sysservers

--Exec master..xp_cmdshell 'dir C:\Users\cristiano.note-cris\Documents\GRM\nf-entrada\2016\best-bag\10-out /s /o:n /b'

-- cria a tabela tamporária

create table #arq(dir char(256),nivel smallint, tipo smallint)

--delete #arq

declare @diretorio as varchar(200)

--set @diretorio='D:\Documents\GRM\nf-entrada\2020\tanby\matriz\01-jan\21-a-31'
--set @diretorio='D:\Documents\GRM\nf-entrada\2020\papelyna\01-jan\21-a-31'

--set @diretorio='D:\Documents\GRM\xml\entrada\2020\tanby\taubate\10-out\5a-semana'
--set @diretorio='D:\Documents\GRM\xml\entrada\2020\papelyna\10-out\5a-semana'
--set @diretorio='D:\Documents\GRM\xml\entrada\2020\\08-ago'
--set @diretorio='C:\Integros\temp\xml\5a-semana'
--set @diretorio='C:\Integros\temp\xml\08-ago'

--set @diretorio='D:\Documents\GRM\xml\entrada\2023\tanby\taubate\06-jun'
--set @diretorio='D:\Documents\GRM\xml\entrada\2023\papelyna\06-jun'

--set @diretorio='D:\Documents\GRM\xml\entrada\2022\hobby-home\06-jun'
--set @diretorio='D:\Documents\GRM\xml\entrada\2023\winpack\03-mar'

set @diretorio='c:\integros\temp\nf-entrada'

--set @diretorio='c:\integros\temp\xml\06-jun'

insert into #arq EXEC master.dbo.xp_dirtree @diretorio, 0, 1

--select * from #arq

--select count(*) from #arq where tipo=1

update #arq set dir=replace(dir,'_','') where tipo=1

drop table #ent

declare @dataDe as datetime, @dataAte as datetime

set @dataDe ='20170801'
set @dataAte='20170831'

select convert(char(8),NFEDATEFE,112) as data,count(*) as regis into #ent
  from PAPELYNA.SIBD.dbo.TBS059
 where NFEDATEFE between @dataDe and @dataAte and NFECAN='N' and NFEUSUEFE<>''
group by NFEDATEFE

select * from #ent

select (select count(*) from #arq where subString(dir,1,8)=data collate database_default and Len(dir) > 2),*
  from #ent
 where regis <> (select count(*) from #arq where subString(dir,1,8)=data collate database_default and Len(dir) > 2)


select * from master..sysservers 

drop table #nfe
go

declare @dataDe as datetime, @dataAte as datetime, @empresa as smallint

set @dataDe ='20240201'
set @dataAte='20240229'

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
 where NFEDATEFE between @dataDe and @dataAte and NFECAN='N'
 order by NFEDATEFE,NFENUM

select *
       ,replace(subString(dir,18,14),'-','')
  from #arq
 where subString(dir,1,8)='20191219'
       --and replace(subString(dir,18,14),'-','')='01455222000161'
	   and dir Like('%221103%')

select * from #nfe where data='20191219' and NFENUM=221103

select data,count(*) from #nfe group by data

select *
  --into #notas
  from #nfe
 where not exists(select '' from #arq
                   where tipo=1 and subString(dir,1,8)=data collate database_default and
                         replace(subString(dir,18,14),'-','')=subString(comp,1,14) collate database_default and
                         subString(dir,40,9)=subString(comp,17,9) collate database_default)

-- copiar arquivos para pasta organizar
select *
       --,Left(data,4)+'_'+subString(data,5,2)+'_'+right(data,2)+'-'
	   --+Left(NFECHAACE,2) collate database_default
	   ,'copy '
	   +[dbo].[fx_FormatUsingMask](NFECHAACE, '##-####-##############-##-###-#########-#-########-#')+'.xml'
	   +' temp\'+[dbo].[fx_FormatUsingMask](data+NFECHAACE collate database_default, '####_##_##-##-####-##############-##-###-#########-#-########-#')+'.xml'
  from #notas

select *
  from #arq
 where not exists(select '' from #nfe
                   where tipo=1 and subString(dir,1,8)=data collate database_default and
                         replace(subString(dir,18,17),'-','')=subString(comp,1,16) collate database_default and
                         subString(dir,40,9)=subString(comp,17,9) collate database_default) and
       tipo=1


select subString(dir,1,8)
       ,subString(dir,18,17)
       ,subString(dir,40,9)
       ,*
  from #arq
 where dir=replace('2019_05_20-35-1905-65069593000198-55-004-000005475-1-12180100-5.xml','_','')
       or dir=replace('2019_05_20-31-1905-18272566000138-55-000-000034689-1-00611380-9.xml','_','')

select *
       ,subString(comp,1,16)
  from #nfe 
 where NFECHAACE='35190565069593000198550040000054751121801005'
       or NFECHAACE='31190518272566000138550000000346891006113809'


select --NFECFOP
       *
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
 where TBS059.NFEUSUEFE<>''
       and TBS059.NFECAN<>'S'
       and TBS059.NFEDATEFE between '20190301' and '20190331'
       and right(NFECFOP,3) in('556','557')

-- nf de uso/consumo


select *
  from #nfe
 where NFECHAACE in(
'35190305868574000523550010003238761665401643',
'35190365069593000279550020000073181652015299',
'35190365069593000279550020000073381165934674',
'35190365069593000279550020000073571436832894',
'35190365069593000279550020000073661987400698',
'35190365069593000279550020000073741862502489',
'35190365069593000279550020000073771936069084',
'35190365069593000279550020000073811245942127',
'35190365069593000279550020000073821652112554',
'35190365069593000279550020000073881963567085',
'35190365069593000279550020000073921574038750',
'35190365069593000279550020000074011715681426',
'35190365069593000279550020000074261742473072',
'35190365069593000279550020000074321094945794',
'35190365069593000279550020000074331932084675',
'35190365069593000279550020000074511964483646',
'35190365069593000279550020000074671468198629',
'35190365069593000279550020000074701006325196',
'35190365069593000279550020000074721034269046',
'35190365069593000350550020000385721725412689',
'35190365069593000350550020000386471729662178',
'35190365069593000350550020000387511187216344',
'35190365069593000350550020000387591562274087')

-- rodar no servidor para ver nf de uso/consumo

select * from master..sysservers with (nolock)

declare @datade date, @dataate date

select @datade='20240201', @dataate='20240229'

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

select * from #arq


-- função para mascarar campo
CREATE FUNCTION fx_FormatUsingMask 
(    
    @input nvarchar(1000),
    @mask nvarchar(1000)
)
RETURNS nvarchar(1000)
AS
BEGIN    
    DECLARE @result nvarchar(1000) = ''
    DECLARE @inputPos int = 1
    DECLARE @maskPos int = 1
    DECLARE @maskSign char(1) = ''

    WHILE @maskPos <= Len(@mask)
    BEGIN
        set @maskSign = substring(@mask, @maskPos, 1)

        IF @maskSign = '#'
        BEGIN
            set @result = @result + substring(@input, @inputPos, 1)
            set @inputPos += 1
            set @maskPos += 1
        END
        ELSE
        BEGIN
            set @result = @result + @maskSign
            set @maskPos += 1
        END
    END
    -- Return the result of the function
    RETURN @result

END;

SELECT [dbo].[fx_FormatUsingMask]('00000000', '####.##.##')
