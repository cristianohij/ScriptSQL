select * from TMP012   --where T12_REG=1
select top 1 * from TMP0121  --where T12_REG=1
select top 1 * from TMP0122  --where T12_REG=1
select top 1 * from TMP0123  --where T12_REG=1
select top 1 * from TMP0124  --where T12_REG=1
select top 1 * from TMP0125  --where T12_REG=1
select top 1 * from TMP01251 --where T12_REG=1

select * from TMP012 (nolock)

select T12_ide_nNF from TMP012 order by T12_ide_nNF

select * from TBS024 (nolock) where TBSNOM='TMP012'

insert into TBS024 (TBSNOM,TBSDES,TBSSEQ,TBSVALSEQ,TBSCTR,TBSZERESC,TBSMOD,TBSVALINI)
   select 'TMP012','TABELA DE REGISTROS TEMPORARIOS DE ARQUIVOS XML','S',0,'','N','C',null

/*
delete TMP012
delete TMP0121
delete TMP0122
delete TMP0123
delete TMP0124
delete TMP0125
delete TMP01251
*/

EXECUTE xp_cmdshell 'c:\temp\APMSL068.EXE 2017_10_31-35-1710-44283067000156-55-001-000002155-1-99481625-6.xml'

select (select NFEDATEFE from TBS059 (nolock) where NFECHAACE=T12_InfProt_chNFe) data,
       T12_ide_nNF nf,
       sum(T12_icms_vCredICMSSN) valor
  from TMP012 a (nolock) inner join TMP0124 b (nolock) on a.T12_REG=b.T12_REG
 where T12_icms_vCredICMSSN > 0
 group by T12_ide_nNF,T12_InfProt_chNFe

select *
from (
select (select NFEDATEFE from TBS059 (nolock) where NFECHAACE=T12_InfProt_chNFe and NFECAN='N') data,
       T12_ide_nNF nf,
       T12_prod_nItem,
       T12_prod_CFOP,
       T12_icms_pCredSN,
       T12_icms_vCredICMSSN
  from TMP012 a (nolock) inner join TMP0124 b (nolock) on a.T12_REG=b.T12_REG
 where T12_icms_vCredICMSSN > 0
) tab
where tab.data between '20181001' and '20181031'

select *
from (
select (select NFEDATEFE from TBS059 (nolock) where NFECHAACE=T12_InfProt_chNFe and NFECAN='N') data,
       T12_ide_nNF nf,
       T12_prod_nItem,
       T12_prod_CFOP,
       T12_icms_pCredSN,
       sum(T12_icms_vCredICMSSN)
  from TMP012 a (nolock) inner join TMP0124 b (nolock) on a.T12_REG=b.T12_REG
 where T12_icms_vCredICMSSN = 0
) tab
where tab.data between '20181001' and '20181031'

select
       subString(chave,7,14)
  from (
select (select NFEDATEFE from TBS059 (nolock) where NFECHAACE=T12_InfProt_chNFe and NFECAN='N') data
       ,T12_InfProt_chNFe chave
  from TMP012 a (nolock)
) tab
where tab.data between '20181001' and '20181031'
group by subString(chave,7,14)

select chave
  from
  (
      select (select NFEDATEFE
                from TBS059 (nolock)
               where NFECHAACE=T12_InfProt_chNFe and NFECAN='N') data
             ,T12_InfProt_chNFe chave
             ,sum(T12_icms_vCredICMSSN) valor
        from TMP012 a (nolock) inner join TMP0124 b (nolock) on a.T12_REG=b.T12_REG
       group by T12_InfProt_chNFe
  ) tab
 where tab.data between '20181201' and '20181231'
       and valor = 0
 group by chave

select * from TMP012 (nolock)

-- group by T12_ide_nNF,T12_InfProt_chNFe

--Exec master..xp_cmdshell 'dir C:\Users\cristiano.note-cris\Documents\GRM\nf-entrada\2016\best-bag\10-out /s /o:n /b'
/*
create table #arq(dir char(256),nivel smallint, tipo smallint)

delete #arq

declare @diretorio as varchar(200)

set @diretorio='c:\xml'

insert into #arq EXEC master.dbo.xp_dirtree @diretorio, 0, 1

select * from #arq

select count(*) from #arq where tipo=1

update #arq set dir=replace(dir,'-','') where tipo=1
*/

select Nome, Count(Nome) from Tabela
group by Nome
having Count(Nome)>1

select NFECHAACE from TBS059 (nolock) where NFEDATEFE between '20171101' and '20171130' group by NFECHAACE having count(*) > 1


-- ajustes

alter table TBS0591 add 
ALTER TABLE TBS0591 ADD NFEPCRESN DECIMAL(7,4) DEFAULT 0 WITH VALUES
ALTER TABLE TBS0591 ADD NFEVCRESN MONEY DEFAULT 0 WITH VALUES

select * from TMP012
select * from TMP0121
select * from TMP0122
select * from TMP0123
select * from TMP0124

select sum(T12_icms_vCredICMSSN) from TMP0124 where T12_icms_vICMSST=0 and T12_prod_CFOP<>'5401'

select convert(char(6),data,112)
       ,sum(valor)
       ,count(*)
  from
  (
     select (select NFEDATEFE
               from TBS059 (nolock)
              where NFECHAACE=T12_InfProt_chNFe
                    and NFECAN='N') data
            ,T12_icms_vCredICMSSN valor
       from TMP012 a (nolock) inner join TMP0124 b (nolock) on a.T12_REG=b.T12_REG
 where T12_icms_vCredICMSSN > 0
) tab
where tab.data between '20181001' and '20181231'
group by convert(char(6),data,112)

select T12_icms_vCredICMSSN,T12_icms_vICMSST,* from TMP0124 where T12_prod_CFOP='5401'

select T12_InfProt_chNFe,T12_prod_nItem,T12_icms_pCredSN,T12_icms_vCredICMSSN
  from TMP012 (nolock)
       inner join TMP0124 (nolock) on TMP0124.T12_REG=TMP012.T12_REG
 where T12_icms_pCredSN > 0 and T12_icms_vICMSST=0 and T12_prod_CFOP<>'5401'

select top 1 * from TBS059 (nolock)

select * from TBS059 (nolock) where NFECOD=1379 and NFENUM=3284


select *
  from TBS059 (nolock)
       inner join TBS0591 (nolock) on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.SERCOD=TBS059.SERCOD and
                                      TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
       inner join TMP012 (nolock) on T12_InfProt_chNFe=TBS059.NFECHAACE
       inner join TMP0124 (nolock) on TMP0124.T12_REG=TMP012.T12_REG and T12_prod_nItem=TBS0591.NFEITEXML
 where TBS059.NFECAN='N' and T12_icms_pCredSN > 0 and T12_icms_vICMSST=0 and T12_prod_CFOP<>'5401' and subString(TBS0591.NFECFOP,3,3)<>'556' and NFEPCRESN=0
 order by TBS059.NFENUM

select top 500 NFECFOP from TBS0591 (nolock)

begin tran
update TBS0591 set NFEPCRESN=T12_icms_pCredSN
  from TBS059 (nolock)
       inner join TBS0591 (nolock) on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.SERCOD=TBS059.SERCOD and
                                      TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
       inner join TMP012 (nolock) on T12_InfProt_chNFe=TBS059.NFECHAACE
       inner join TMP0124 (nolock) on TMP0124.T12_REG=TMP012.T12_REG and T12_prod_nItem=TBS0591.NFEITEXML
 where TBS059.NFECAN='N' and T12_icms_pCredSN > 0 and T12_icms_vICMSST=0 and T12_prod_CFOP<>'5401' and subString(TBS0591.NFECFOP,3,3)<>'556' and NFEPCRESN=0
commit tran

select * from TBS0591 (nolock) where NFEPCRESN > 0

update TBS0591 set NFEPCRESN=0, NFEVCRESN=0 where NFEPCRESN > 0

begin tran
update TBS0591 set NFEVCRESN=NFETOTOPEITE*NFEPCRESN/100 where NFEPCRESN > 0 and NFEVCRESN=0
commit tran
rollback tran

select sum(NFEVCRESN)
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.NFEEMPCOD=TBS0591.NFEEMPCOD and TBS059.SEREMPCOD=TBS0591.SEREMPCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and
                                     TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
 where NFEDATEFE between '20180101' and '20180131' and NFEPCRESN > 0

select NFENUM,NFEITEXML,NFECFOP,NFECST,NFETOTOPEITE,NFEPCRESN,NFEVCRESN from TBS0591 (nolock) where NFEPCRESN > 0 order by NFENUM

-- quando não tem o valor especificado na TAG

select * from TMP012 (nolock)

select * from TBS059 (nolock) where NFECHAACE='35180107295059000101550010000051621900000076'

select count(*) from TBS0591 (nolock) where NFENUM=5162 and NFECOD=2018

begin tran
update TBS0591 set NFEPCRESN=2.84
  from TBS059 (nolock)
       inner join TBS0591 (nolock) on TBS0591.NFEEMPCOD=TBS059.NFEEMPCOD and TBS0591.SEREMPCOD=TBS059.SEREMPCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
       inner join TMP012 (nolock) on T12_InfProt_chNFe=TBS059.NFECHAACE and T12_InfProt_chNFe='35180107295059000101550010000051621900000076'
       inner join TMP0124 (nolock) on TMP0124.T12_REG=TMP012.T12_REG and T12_prod_nItem=TBS0591.NFEITEXML
commit tran
rollback tran

select * from TMP01251 (nolock)
