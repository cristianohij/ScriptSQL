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

create table #arq(dir char(256),nivel smallint, tipo smallint)

delete #arq

declare @diretorio as varchar(200)

set @diretorio='C:\Users\cristiano.note-cris\Documents\GRM\nf-entrada\2019\tanby\taubate\03-mar'

insert into #arq EXEC master.dbo.xp_dirtree @diretorio, 0, 1

select * from #arq

select count(*) from #arq where tipo=1

update #arq set dir=replace(dir,'_','') where tipo=1

drop table #ent

declare @dataDe as datetime, @dataAte as datetime

set @dataDe ='20170801'
set @dataAte='20170831'

select convert(char(8),NFEDATEFE,112) as data,count(*) as regis into #ent
  from TANBYT.SIBD.dbo.TBS059
 where NFEDATEFE between @dataDe and @dataAte and NFECAN='N' and NFEUSUEFE<>''
group by NFEDATEFE

select * from #ent

select (select count(*) from #arq where subString(dir,1,8)=data collate database_default and Len(dir) > 2),*
  from #ent
 where regis <> (select count(*) from #arq where subString(dir,1,8)=data collate database_default and Len(dir) > 2)



drop table #nfe

declare @dataDe as datetime, @dataAte as datetime, @empresa as smallint

set @dataDe ='20190301'
set @dataAte='20190331'

set @empresa=1

select convert(char(8),NFEDATEFE,112) as data,
       NFENUM,
       NFESERDOC,
       case
          when NFETIP in('N','T') then isnull((select FORCGC from TANBYT.SIBD.dbo.TBS006 where FORCOD=NFECOD),'')
          when NFETIP='D' and NFENOSFOR='N' then isnull((select CLICGC from TANBYT.SIBD.dbo.TBS002 where CLICOD=NFECOD),'')
          when NFETIP='D' and NFENOSFOR='S' then isnull((select EMPCGC from TANBYT.SIBD.dbo.TBS023 where EMPCOD=@empresa),'')
          else ''
       end as cnpj,
       NFECHAACE,
       case
          when NFETIP in('N','T') then isnull((select FORCGC from TANBYT.SIBD.dbo.TBS006 where FORCOD=NFECOD),'')
          when NFETIP='D' and NFENOSFOR='N' then isnull((select CLICGC from TANBYT.SIBD.dbo.TBS002 where CLICOD=NFECOD),'')
          when NFETIP='D' and NFENOSFOR='S' then isnull((select EMPCGC from TANBYT.SIBD.dbo.TBS023 where EMPCOD=@empresa),'')
          else ''
       end + '55' + right('000000000' + Ltrim(str(NFENUM,10)),9) as comp
  into #nfe
  from TANBYT.SIBD.dbo.TBS059
 where NFEDATEFE between @dataDe and @dataAte and NFECAN='N'
 order by NFEDATEFE,NFENUM

select * from #nfe

select data,count(*) from #nfe group by data

select *
  from #nfe
 where not exists(select '' from #arq
                   where tipo=1 and subString(dir,1,8)=data collate database_default and
                         replace(subString(dir,18,14),'-','')=subString(comp,1,14) collate database_default and
                         subString(dir,40,9)=subString(comp,17,9) collate database_default)

select *
  from #arq
 where not exists(select '' from #nfe
                   where tipo=1 and subString(dir,1,8)=data collate database_default and
                         replace(subString(dir,18,17),'-','')=subString(comp,1,16) collate database_default and
                         subString(dir,40,9)=subString(comp,17,9) collate database_default) and
       tipo=1

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

select --NFECFOP
       NFECHAACE
--       *
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
 where TBS059.NFEUSUEFE<>''
       and TBS059.NFECAN<>'S'
       and TBS059.NFEDATEFE between '20190301' and '20190331'
       and right(NFECFOP,3) in('407','556','557')
-- group by NFECFOP
 group by NFECHAACE