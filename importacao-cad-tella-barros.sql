select rdlcod,clidesfin,clidesfinabt,*
  from tab02 (nolock)
 where rdlcod <> '' or clidesfin > 0 or clidesfinabt = 'S'

select count(*) from tab02 (nolock)

select count(*) from tab02 (nolock) where rdlcod <> ''
select count(*) from tab02 (nolock) where clidesfin > 0
select count(*) from tab02 (nolock) where clidesfinabt = 'S'
select count(*) from tab02 (nolock) where pmtcod > 0

select * from tab40 (nolock) order by cdtnumcon desc

select top 1 * from SIBD.dbo.TBS002

select top 1 * from TELLABARROS.SIBD.dbo.TBS002

select clicgccpf from TELLA.dbo.tab02 (nolock)




-- analisar
Clicpgcod Condicao Pagto C ( 3 )

-- acerta inscrição estadual
update TELLA.dbo.tab02 set Cliies = replace(Cliies,'.','')
update TELLA.dbo.tab02 set Cliies = replace(Cliies,'-','')
update TELLA.dbo.tab02 set Cliies = replace(Cliies,'ME','')
update TELLA.dbo.tab02 set Cliies = replace(Cliies,',','')
update TELLA.dbo.tab02 set Cliies = replace(Cliies,'/','')
begin tran
update TELLA.dbo.tab02 set Cliies = 'ISENTO' where Cliies Like('ISENT%')
commit tran

update TELLA.dbo.tab02 set Cliies = '' where isnumeric(cliies) = 0 and Cliies not Like('ISENTO')

select cliies from TELLA.dbo.tab02 (nolock)
select * from TBS002 (nolock)

DBCC CHECKTABLE ('TBS002')
GO


DBCC CHECKTABLE ('tab02')
GO


-- vendedores
select top 1 * from SIBD_tella.dbo.TBS004
select top 1 * from TELLA.dbo.tab04


select * from SIBD_tella.dbo.TBS004

select Vennom,Vencgccpf from TELLA.dbo.tab04

-- acerta cpf vendedor
update TELLA.dbo.tab04 set Vencgccpf = replace(Vencgccpf,'.','')
update TELLA.dbo.tab04 set Vencgccpf = replace(Vencgccpf,'-','')
update TELLA.dbo.tab04 set Vencgccpf = replace(Vencgccpf,'/','')

select * from TELLA.dbo.tab08

select TBS002.VENCOD from SIBD_tella.dbo.TBS002 TBS002 where not exists(select '' from SIBD_tella.dbo.TBS004 TBS004 where TBS004.VENCOD = TBS002.VENCOD)

begin tran
update SIBD_tella.dbo.TBS002 set VENCOD = 0 
  from SIBD_tella.dbo.TBS002 TBS002 where not exists(select '' from SIBD_tella.dbo.TBS004 TBS004 where TBS004.VENCOD = TBS002.VENCOD)
commit tran

select TBS002.VENCOD,TBS004.VENCOD,TBS004.cod
  from SIBD_tella.dbo.TBS002 TBS002 join SIBD_tella.dbo.TBS004 TBS004 on TBS002.VENCOD = TBS004.VENCOD

update SIBD_tella.dbo.TBS002 set VENCOD = TBS004.cod
  from SIBD_tella.dbo.TBS002 TBS002 join SIBD_tella.dbo.TBS004 TBS004 on TBS002.VENCOD = TBS004.VENCOD

update SIBD_tella.dbo.TBS004 set VENCOD = cod


-- fornecedores
select top 1 * from TELLA.dbo.tab05
select * from SIBD_tella.dbo.TBS006

select * from SIBD_tella.dbo.TBS006

insert into SIBD_tella.dbo.TBS006
   (FORCOD,FORNOM,FORNOMFAN,FOREND,FORBAI,FORCEP,UFESIG,FORCGC,FORCPF,FORIES,FORTEL,FORFAX,FOREMAIL,FORURL,FORCONTAT,FORDATCAD,MUNCOD,FORNUM) 
select convert(int,forcod),subString(fornom,1,50),fornomfan,forend,forbai,forcep,ufesig,
       case 
          when Len(forcgccpf) = 18 then subString(forcgccpf,1,2)+subString(forcgccpf,4,3)+subString(forcgccpf,8,3)+subString(forcgccpf,12,4)+
                                        subString(forcgccpf,17,2)
          else ''
          end,
       case 
          when Len(forcgccpf) = 14 then subString(forcgccpf,1,3)+subString(forcgccpf,5,3)+subString(forcgccpf,9,3)+subString(forcgccpf,13,2)
          else ''
       end,
       subString(Fories,1,18),subString(Fortel,1,15),subString(Forfax,1,15),Foremail,subString(Forurl,1,15),Forcontat,getDate(),muncod,fornum
  from TELLA.dbo.tab05


Forcod Fornom                                                       Fornomfan            Forend                                             Forbai                         Forcid                         Forcep    Forcgccpf          Fories                                                                                                         Forstatus Ufesig                                              Forcpgcod MUNCOD      Fornum                                                       


-- acerta inscrição estadual
select fories from TELLA.dbo.tab05 (nolock) where isnumeric(fories) = 0 and fories not Like('ISENTO')

update TELLA.dbo.tab05 set fories = replace(fories,'.','')
update TELLA.dbo.tab05 set fories = replace(fories,'-','')
update TELLA.dbo.tab05 set fories = replace(fories,'ME','')
update TELLA.dbo.tab05 set fories = replace(fories,',','')
update TELLA.dbo.tab05 set fories = replace(fories,'/','')
   

-- recodificação
update SIBD_tella.dbo.TBS006 set cod = 0

   declare @contador int
   declare @registro int

   set @contador = 0
   set @registro = (select top 1 FORCOD from SIBD_tella.dbo.TBS006 where cod = 0 order by FORCOD)

   while((select count(*) from SIBD_tella.dbo.TBS006 where cod = 0) > 0)
      begin
         update SIBD_tella.dbo.TBS006 set cod = @contador + 1 where cod = 0 and FORCOD = @registro
         
	 set @contador = @contador +1
         set @registro = (select top 1 FORCOD from SIBD_tella.dbo.TBS006 where cod = 0 order by FORCOD)

         if((select count(*) from SIBD_tella.dbo.TBS006 where cod = 0) > 0)
            continue
         else 
            break
      end

select FORCOD,cod from SIBD_tella.dbo.TBS006 order by cod

-- produtos
select top 1 * from TELLA.dbo.tab12

select * from SIBD_tella.dbo.TBS010


insert into SIBD_tella.dbo.TBS010
   (PROCOD,PRODES,PROSTATUS,PROPESLIQ,PROUM1,PROUM1QTD,PROICMSSAI,PROPBISAI,PRODATCAD,PROSTBA,PROSTBB,PROCLAFIS,PROSTBPIS,PROPIS,PROSTBCOFINS,PROCOFINS)
select
   procod,prodes,prostatus,propesliq,unicod,1,proicm,100-properred,getdate(),procodsta,procodstb,procodncm,propissit,propisaliq,procofinssit,procofinsaliq
  from TELLA.dbo.tab12


select procod,properred from TELLA.dbo.tab12 where properred > 0
select distinct properred from TELLA.dbo.tab12 where properred > 0


select * from TELLA.dbo.tab15 order by marcod

select PROCOD from SIBD_tella.dbo.TBS010 where PROSTBPIS = '06' or PROSTBCOFINS = '06'

select distinct PROSTBPIS from SIBD_tella.dbo.TBS010
select distinct PROSTBCOFINS from SIBD_tella.dbo.TBS010

select PROCOD from SIBD_tella.dbo.TBS010 where FORCOD > 0


select FORNOM from SIBD_tella.dbo.TBS010

update SIBD_tella.dbo.TBS010 set FORCOD = cod
  from SIBD_tella.dbo.TBS010 TBS010 join SIBD_tella.dbo.TBS006 TBS006 on TBS010.FORCOD = TBS006.FORCOD

update SIBD_tella.dbo.TBS010 set FORNOM = TBS006.FORNOM
  from SIBD_tella.dbo.TBS010 TBS010 join SIBD_tella.dbo.TBS006 TBS006 on TBS010.FORCOD = TBS006.cod

select procod,proforcod from TELLA.dbo.tab12 where convert(int,proforcod ) >= 50000

update SIBD_tella.dbo.TBS006 set FORCOD = cod

-- atualiza o estoque
update SIBD.dbo.TBS032 set ESTQTDATU = 0

update SIBD_tella.dbo.TBS032 set ESTQTDATU = Proqtd - Proqtdres
  from SIBD_tella.dbo.TBS032 TBS032 join TELLABARROS.TELLA.dbo.tab12 tab12 on TBS032.PROCOD collate database_default = tab12.Procod collate database_default

select PROCOD,ESTQTDATU from SIBD_tella.dbo.TBS032 where ESTQTDATU <> 0

select PROCOD,ESTQTDATU from SIBD_tella.dbo.TBS032 where ESTQTDATU < 0

select * from TELLABARROS.TELLA.dbo.tab12 where (Proqtd - Proqtdres) < 0

select top 1 * from TELLABARROS.TELLA.dbo.tab17

select PROCOD,ESTLOC,ESTQTDATU from SIBD_tella.dbo.TBS032

select procod from TELLA.dbo.tab12 where unicod = 'KG' and prostatus = 'A'


-- unidades de medidas
select top 1 * from TELLA.dbo.tab13

select * from SIBD_tella.dbo.TBS011







-- politica de preços
insert into SIBD_tella.dbo.TBS015
   (PDPCOD,PRODES,PDPPREFOR,PDPUNI,PDPQTDEMB,PDPPREPRO1,PDPPRECOR1,PDPPRELOJ1,PDPPREWE11,PDPPREWE21,PDPPREREV1)
select procod,prodes,propre,unicod,1,propre,propre,propre,propre,propre,propre from TELLA.dbo.tab12 where propre > 0

delete SIBD_tella.dbo.TBS015

update SIBD_tella.dbo.TBS015 set PDPSEGFOR = 'N'
update SIBD_tella.dbo.TBS015 set PDPDATCAD = getdate()

select count(*) from TELLA.dbo.tab12
select count(*) from TELLA.dbo.tab12 where propre > 0

select PRODES from SIBD.dbo.TBS015


-- transportadoras
select top 1 * from TELLA.dbo.tab07

select top 1 * from SIBD_tella.dbo.TBS005

insert into SIBD_tella.dbo.TBS005
   (TRNCOD,TRNNOM,TRNNOMFAN,TRNEND,TRNBAI,TRNCEP,TRNCGC,TRNIES,TRNTEL,TRNFAX,TRNEMAIL,TRNURL,TRNCONTAT,TRNUFESIG,TRNDATCAD,TRNMUNCOD)
select convert(int,Trncod),subString(Trnnom,1,50),subString(Trnnomfan,1,15),subString(Trnend,1,40),Trnbai,Trncep,
       case 
          when Len(Trncgccpf) = 18 then subString(trncgccpf,1,2)+subString(trncgccpf,4,3)+subString(trncgccpf,8,3)+subString(trncgccpf,12,4)+
                                        subString(trncgccpf,17,2)
          else ''
       end,
       Trnies,subString(Trntel,1,15),subString(Trnfax,1,15),Trnemail,subString(Trnurl,1,30),subString(Trncontat,1,15),Ufesig,getdate(),MUNCOD     
  from TELLA.dbo.tab07


select trnies from TELLA.dbo.tab07 where trnies <> ''

update TELLA.dbo.tab07 set trnies = replace(trnies,'.','')
update TELLA.dbo.tab07 set trnies = replace(trnies,'-','')
update TELLA.dbo.tab07 set trnies = replace(trnies,'ME','')
update TELLA.dbo.tab07 set trnies = replace(trnies,',','')
update TELLA.dbo.tab07 set trnies = replace(trnies,'/','')
update TELLA.dbo.tab02 set Cliies = 'ISENTO' where Cliies Like('ISENT%')
commit tran

update TELLA.dbo.tab02 set Cliies = '' where isnumeric(cliies) = 0 and Cliies not Like('ISENTO')

select trnies from TELLA.dbo.tab07 (nolock) where isnumeric(trnies) = 0 and trnies not Like('ISENT%') and trnies <> ''
select trnies from TELLA.dbo.tab07 (nolock) where isnumeric(trnies) = 0 and rtrim(trnies) <> 'ISENT0'
select trnies from TELLA.dbo.tab07 (nolock) where trnies Like('ISENT%')

update TELLA.dbo.tab07 set trnies = upper(trnies)

select * from SIBD_tella.dbo.TBS003 





-- 6set2013
select * from TBS010 (nolock)


-- tbs001: estados
-- tbs050: ocorrências

select * from TBS001 (nolock) -- ok
select * from TBS050 (nolock) -- ok

--tbs025: parâmetros do sistema..ok
select * from TBS025 (nolock)

--tbs003: municípios..ok
select * from TBS003 (nolock)

--tbs071: paises..ok
select * from TBS071 (nolock)

--tbs039: cst..ok
select * from TBS039 (nolock)

--tbs040: grupos de cfop..ok
select * from TBS040 (nolock)

--tbs041: cfop..ok
select * from TBS041 (nolock)

--tbs033: tipos de movimentações
select * from TBS033 (nolock)

--tbs034: locais de estoque
select * from TBS034 (nolock)

--tbs064: série de notas fiscais
select * from TBS064 (nolock)

-- importações

-- clientes

update TELLA.dbo.tab02 set cliies = rtrim(cliies)
update TELLA.dbo.tab02 set cliies = ltrim(cliies)

insert into SIBD_tella.dbo.TBS002
   (CLICOD,CLINOM,CLINOMFAN,CLIEND,CLICEP,CLIBAI,MUNCOD,CLICONTAT,CLITEL,CLIFAX,CLICGC,CLIIES,CLIDATCAD,CLIEMAIL,CLIURL,VENCOD,UFESIG,CLIBLQTRN,CLIOBS,CLINUM,
    CLISUFRAMA,CLICPF)
   select convert(int,Clicod),Clinom,Clinomfan,Cliend,Clicep,Clibai,MUNCOD,Clicontat,subString(Clitel,1,15),subString(Clifax,1,15),
          case 
             when Len(Clicgccpf) = 18 then subString(Clicgccpf,1,2)+subString(Clicgccpf,4,3)+subString(Clicgccpf,8,3)+subString(Clicgccpf,12,4)+
                                           subString(Clicgccpf,17,2)
             else ''
          end,
          subString(Cliies,1,18),Clidatcad,Cliemail,subString(Cliurl,1,30),convert(int,Clivencod),Ufesig,Cliblcred,subString(Cliobs,1,254),Clinum,Clisuframa,
          case 
             when Len(Clicgccpf) = 14 then subString(Clicgccpf,1,3)+subString(Clicgccpf,5,3)+subString(Clicgccpf,9,3)+subString(Clicgccpf,13,2)
             else ''
          end
     from TELLA.dbo.tab02 (nolock)

update SIBD_tella.dbo.TBS002 set CLIIES=replace(CLIIES,'.','')
update SIBD_tella.dbo.TBS002 set CLIIES=replace(CLIIES,'-','')
update SIBD_tella.dbo.TBS002 set CLIIES=replace(CLIIES,'/','')
update SIBD_tella.dbo.TBS002 set CLIIES=replace(CLIIES,' ','')
update SIBD_tella.dbo.TBS002 set CLIIES=replace(CLIIES,'ME','')
update SIBD_tella.dbo.TBS002 set CLIIES=replace(CLIIES,'M','')
update SIBD_tella.dbo.TBS002 set CLIIES=replace(CLIIES,'''','')
update SIBD_tella.dbo.TBS002 set CLIIES=replace(CLIIES,',','')
update SIBD_tella.dbo.TBS002 set CLIIES=upper(CLIIES)
update SIBD_tella.dbo.TBS002 set CLIIES='ISENTO' where upper(CLIIES)='ISENTA'

update SIBD_tella.dbo.TBS002 set CLIIES='' where isnumeric(CLIIES)=0 and CLIIES<>'ISENTO' and CLIIES<>''

update SIBD_tella.dbo.TBS002 set CLIIES='' where CLIIES Like('RG%')

select * from SIBD_tella.dbo.TBS002 where isnumeric(CLINOM) = 1
delete SIBD_tella.dbo.TBS002 where isnumeric(CLINOM) = 1

update SIBD_tella.dbo.TBS002 set CLITIPPES='J' where CLICGC<>''
update SIBD_tella.dbo.TBS002 set CLITIPPES='F' where CLICPF<>''

select CLICONICMS from SIBD_tella.dbo.TBS002 (nolock)

update SIBD_tella.dbo.TBS002 set CLICONICMS='S'

update SIBD_tella.dbo.TBS002 set CLICONICMS='N' where CLIIES='' or CLIIES='ISENTO'


-- vendedores

insert into SIBD_tella.dbo.TBS004
   (VENCOD,VENNOM,VENEND,VENBAI,VENCID,VENCEP,VENCPF,VENTEL,VENFAX,VENRAM,VENEMAIL,VENURL,VENCALCOM,VENPERCOM,VENLOC,VENUFESIG,VENDATCAD)
select convert(int,Vencod),Vennom,Venend,Venbai,Vencid,Vencep,
       case 
          when Len(Vencgccpf) = 11 then subString(Vencgccpf,1,2)+subString(Vencgccpf,4,3)+subString(Vencgccpf,8,3)+subString(Vencgccpf,12,4)+
                                        subString(Vencgccpf,17,2)
             else ''
          end,
       subString(Ventel,1,15),subString(Venfax,1,15),convert(int,Venramal),Venemail,subString(Venurl,1,30),
       case when Vencomis > 0 then 'S' else 'N' end,
       Vencomis,Venlocal,Ufesig,getdate()
  from TELLA.dbo.tab04

delete SIBD_tella.dbo.TBS004
 where VENCOD in(2,3,4,9,17,24,29,32,33,34,36,38,508,511,512,513,515,516,517,519,520,521,522,523,524,525,526,527,529,531,532,536,537,538,539,540,541,
                 542,543,544,545,546,547,548,549,550,551,552,553,554,555,557,558,559,561,562,563,565,566,567,570,572,573,574,575,576,577,579,580,
                 581,582,583,584,588,589,591,592,593,596,599)

select * from SIBD_tella.dbo.TBS004 (nolock)

select distinct TBS002.VENCOD from SIBD_tella.dbo.TBS002 TBS002
 where VENCOD > 0 and not exists(select '' from SIBD_tella.dbo.TBS004 TBS004 where TBS004.VENCOD = TBS002.VENCOD)

select count(*) from SIBD_tella.dbo.TBS002 TBS002
 where VENCOD > 0 and not exists(select '' from SIBD_tella.dbo.TBS004 TBS004 where TBS004.VENCOD = TBS002.VENCOD)

begin tran
update SIBD_tella.dbo.TBS002 set VENCOD=0 from SIBD_tella.dbo.TBS002 as TBS002
 where VENCOD > 0 and not exists(select '' from SIBD_tella.dbo.TBS004 as TBS004 where TBS004.VENCOD = TBS002.VENCOD)
commit tran


-- fornecedores

insert into SIBD_tella.dbo.TBS006
   (FORCOD,FORNOM,FORNOMFAN,FOREND,FORBAI,FORCEP,UFESIG,FORCGC,FORCPF,FORIES,FORTEL,FORFAX,FOREMAIL,FORURL,FORCONTAT,FORDATCAD,MUNCOD,FORNUM) 
select convert(int,forcod),subString(fornom,1,50),fornomfan,forend,forbai,forcep,ufesig,
       case 
          when Len(forcgccpf) = 18 then subString(forcgccpf,1,2)+subString(forcgccpf,4,3)+subString(forcgccpf,8,3)+subString(forcgccpf,12,4)+
                                        subString(forcgccpf,17,2)
          else ''
          end,
       case 
          when Len(forcgccpf) = 14 then subString(forcgccpf,1,3)+subString(forcgccpf,5,3)+subString(forcgccpf,9,3)+subString(forcgccpf,13,2)
          else ''
       end,
       subString(Fories,1,18),subString(Fortel,1,15),subString(Forfax,1,15),Foremail,subString(Forurl,1,15),Forcontat,getDate(),muncod,fornum
  from TELLA.dbo.tab05

select FORIES,isnumeric(FORIES) from SIBD_tella.dbo.TBS006 where isnumeric(FORIES)=0 and FORIES<>'ISENTO' and FORIES<>''

update SIBD_tella.dbo.TBS006 set FORIES=replace(FORIES,'.','')
update SIBD_tella.dbo.TBS006 set FORIES=replace(FORIES,'-','')
update SIBD_tella.dbo.TBS006 set FORIES=replace(FORIES,'/','')
update SIBD_tella.dbo.TBS006 set FORIES=replace(FORIES,' ','')
update SIBD_tella.dbo.TBS006 set FORIES=replace(FORIES,'ME','')

update SIBD_tella.dbo.TBS006 set FORIES='' where isnumeric(FORIES)=0 and FORIES<>'ISENTO' and FORIES<>''

select FORCOD,FORCGC from SIBD_tella.dbo.TBS006 (nolock) where isnumeric(FORCGC)=0 and FORCGC<>''

update SIBD_tella.dbo.TBS006 set FORCGC='' where isnumeric(FORCGC)=0 and FORCGC<>''

update SIBD_tella.dbo.TBS006 set FORTIPPES='J' where FORCGC<>''
update SIBD_tella.dbo.TBS006 set FORREGTRI=3


-- marcas de produtos
select * from SIBD_tella.dbo.TBS014

insert into SIBD_tella.dbo.TBS014 values(0,1,'TELLA',0,'20130907')


-- produtos

insert into SIBD_tella.dbo.TBS010
   (PROCOD,PRODES,PROSTATUS,PROPESLIQ,PROUM1,PROUM1QTD,PROICMSSAI,PROPBISAI,PRODATCAD,PROSTBA,PROSTBB,PROCLAFIS,PROSTBPIS,PROPIS,PROSTBCOFINS,PROCOFINS)
select
   procod,prodes,prostatus,propesliq,unicod,1,proicm,100-properred,getdate(),procodsta,procodstb,procodncm,propissit,propisaliq,procofinssit,procofinsaliq
  from TELLA.dbo.tab12

update SIBD_tella.dbo.TBS010 set PROGERPEN = 'N'
update SIBD_tella.dbo.TBS010 set PROWEB = 'N'
update SIBD_tella.dbo.TBS010 set PROCTRLOT = 'N'
update SIBD_tella.dbo.TBS010 set MARCOD = 1 ,MARNOM = 'TELLA BARROS'
update SIBD_tella.dbo.TBS010 set PROPESAVEL='N'

update SIBD_tella.dbo.TBS010 set PROPESAVEL='S' where PROUM1='KG'

update SIBD_tella.dbo.TBS010 set PROSTBPIS = '',PROPIS = 0 where PROSTBPIS = '01'
update SIBD_tella.dbo.TBS010 set PROSTBCOFINS = '',PROCOFINS = 0 where PROSTBCOFINS = '01'

update SIBD_tella.dbo.TBS010 set FORCOD = convert(int,tab12.proforcod) 
  from SIBD_tella.dbo.TBS010 TBS010 join TELLA.dbo.tab12 tab12 on TBS010.PROCOD collate database_default = tab12.procod collate database_default


-- unidades de medidas

insert into SIBD_tella.dbo.TBS011 (UNICOD,UNIDES,UNIDATCAD) select UNICOD,UNIDES,getdate() from TELLA.dbo.tab13

select * from SIBD_tella.dbo.TBS011 (nolock)


-- fiscal

-- tabela do IPI
insert into SIBD_tella.dbo.TBS093 (IPICOD,IPIDES,IPIDATCAD) select IPICOD,IPIDES,getdate() from SIBD.dbo.TBS093

-- tabela do PIS
insert into SIBD_tella.dbo.TBS094 (PISCOD,PISDES,PISDATCAD) select PISCOD,PISDES,getdate() from SIBD.dbo.TBS094

-- tabela do COFINS
insert into SIBD_tella.dbo.TBS095 (COFINSCOD,COFINSDES,COFINSDATCAD) select COFINSCOD,COFINSDES,getdate() from SIBD.dbo.TBS095


-- transportadora

insert into SIBD_tella.dbo.TBS005
   (TRNCOD,TRNNOM,TRNNOMFAN,TRNEND,TRNBAI,TRNCEP,TRNCGC,TRNIES,TRNTEL,TRNFAX,TRNEMAIL,TRNURL,TRNCONTAT,TRNUFESIG,TRNDATCAD,TRNMUNCOD)
select convert(int,Trncod),subString(Trnnom,1,50),subString(Trnnomfan,1,15),subString(Trnend,1,40),Trnbai,Trncep,
       case 
          when Len(Trncgccpf) = 18 then subString(trncgccpf,1,2)+subString(trncgccpf,4,3)+subString(trncgccpf,8,3)+subString(trncgccpf,12,4)+
                                        subString(trncgccpf,17,2)
          else ''
       end,
       Trnies,subString(Trntel,1,15),subString(Trnfax,1,15),Trnemail,subString(Trnurl,1,30),subString(Trncontat,1,15),Ufesig,getdate(),MUNCOD     
  from TELLA.dbo.tab07

update SIBD_tella.dbo.TBS005 set TRNIES=replace(TRNIES,'.','')
update SIBD_tella.dbo.TBS005 set TRNIES=replace(TRNIES,'-','')
update SIBD_tella.dbo.TBS005 set TRNIES=upper(TRNIES)

update SIBD_tella.dbo.TBS005 set TRNMUNNOM=MUNNOM from SIBD_tella.dbo.TBS003 where MUNCOD=TRNMUNCOD


-- politica de preços

insert into SIBD_tella.dbo.TBS015
   (PDPCOD,PRODES,PDPPREFOR,PDPUNI,PDPQTDEMB,PDPPREPRO1,PDPPRECOR1,PDPPRELOJ1,PDPPREWE11,PDPPREWE21,PDPPREREV1)
select procod,prodes,propre,unicod,1,propre,propre,propre,propre,propre,propre from TELLA.dbo.tab12 where propre > 0


-- grupos/subgrupos de produtos

select * from TELLA.dbo.tab14
select * from TELLA.dbo.tab141

insert into SIBD_tella.dbo.TBS012 (GRUEMPCOD,GRUCOD,GRUDES,GRUDATCAD)
select 0,convert(int,grucod),subString(grudes,1,20),'20130907' from TELLA.dbo.tab14

select * from SIBD_tella.dbo.TBS012 (nolock)

insert into SIBD_tella.dbo.TBS0121 (GRUEMPCOD,GRUCOD,SUBGRUCOD,SUBGRUDES)
select 0,convert(int,grucod),convert(int,subgrucod),subString(subgrudes,1,20) from TELLA.dbo.tab141

select * from SIBD_tella.dbo.TBS0121 (nolock)

select GRUCOD as 'codigo',count(*) as 'itens' into #grupos from SIBD_tella.dbo.TBS0121 (nolock) group by GRUCOD

select * from #grupos

drop table #grupos

update SIBD_tella.dbo.TBS012 set SUBGRUUIT=itens from #grupos where GRUCOD=codigo

update SIBD_tella.dbo.TBS010 set GRUCOD=convert(int,tab12.grucod),SUBGRUCOD=convert(int,tab12.subgrucod)
  from SIBD_tella.dbo.TBS010 TBS010 join TELLA.dbo.tab12 tab12 on TBS010.PROCOD collate database_default = tab12.procod collate database_default

-- outros endereços

select * from TELLA.dbo.tab03 (nolock)
select * from SIBD_tella.dbo.TBS0021 (nolock)

insert into SIBD_tella.dbo.TBS0021 (CLICOD,CLIENDTIP,CLILOG,CLIENDBAI,CLIENDUFE,CLIENDCEP)
select convert(int,endcod),'C',endend,endbai,ufesig,endcep from TELLA.dbo.tab03 (nolock) where endtip=1

insert into SIBD_tella.dbo.TBS0021 (CLICOD,CLIENDTIP,CLILOG,CLIENDBAI,CLIENDUFE,CLIENDCEP)
select convert(int,endcod),'E',endend,endbai,ufesig,endcep from TELLA.dbo.tab03 (nolock) where endtip=2

update SIBD_tella.dbo.TBS0021 set CLIENDCOD=1
update SIBD_tella.dbo.TBS0021 set CLIENDCOD=2 where CLIENDTIP='E'

update SIBD_tella.dbo.TBS0021 set CLIENDTIPPES=(select CLITIPPES from SIBD_tella.dbo.TBS002 as TBS002 where TBS002.CLICOD=TBS0021.CLICOD)
  from SIBD_tella.dbo.TBS0021 as TBS0021

select CLILOG,
       charindex(',',CLILOG),
       substring(CLILOG,charindex(',',CLILOG)+1,60)
  from SIBD_tella.dbo.TBS0021 (noLock)
 where charindex(',',CLILOG) > 0

select CLILOG,
       charindex(',',CLILOG),
       substring(CLILOG,1,charindex(',',CLILOG)-1)
  from SIBD_tella.dbo.TBS0021 (noLock)
 where charindex(',',CLILOG) > 0

update SIBD_tella.dbo.TBS0021 set CLIENDNUM = substring(CLILOG,charindex(',',CLILOG)+1,60) from SIBD_tella.dbo.TBS0021 (nolock)
 where CLIENDNUM = '' and charindex(',',CLILOG) > 0

update SIBD_tella.dbo.TBS0021 set CLILOG = substring(CLILOG,1,charindex(',',CLILOG)-1) where charindex(',',CLILOG) > 0

update SIBD_tella.dbo.TBS0021 set CLILOG = ltrim(CLILOG)
update SIBD_tella.dbo.TBS0021 set CLIENDNUM = ltrim(CLIENDNUM)

update SIBD_tella.dbo.TBS0021 set CLIENDCPL=(select endcid from TELLA.dbo.tab03 (nolock) where endcod=CLICOD and endtip=1)
 where CLIENDTIP='C'

update SIBD_tella.dbo.TBS0021 set CLIENDCPL=(select endcid from TELLA.dbo.tab03 (nolock) where endcod=CLICOD and endtip=2)
 where CLIENDTIP='E'


update SIBD_tella.dbo.TBS0021 set CLIENDCPL=replace(CLIENDCPL,'Ã','A')

update SIBD_tella.dbo.TBS0021 set CLIENDMUNCOD=MUNCOD from SIBD_tella.dbo.TBS003 where CLIENDCPL=MUNNOM

update SIBD_tella.dbo.TBS0021 set CLIENDCPL=''


-- estoque

select * from SIBD_tella.dbo.TBS032 (nolock)

update SIBD_tella.dbo.TBS032 set ESTQTDATU = Proqtd
  from SIBD_tella.dbo.TBS032 TBS032 join TELLA.dbo.tab12 tab12 on TBS032.PROCOD collate database_default = tab12.Procod collate database_default

select count(*) from SIBD.dbo.TBS032 (nolock)

update SIBD.dbo.TBS032 set ESTQTDATU = Proqtd
  from SIBD.dbo.TBS032 TBS032 join TELLA.dbo.tab12 tab12 on TBS032.PROCOD collate database_default = tab12.Procod collate database_default

select proqtd,* from TELLA.dbo.tab12 (nolock) where proqtd < 0

select count(*) from SIBD.dbo.TBS032 (nolock) where ESTQTDATU < 0 -- 27

begin tran
update SIBD.dbo.TBS032 set ESTQTDATU = 0 where ESTQTDATU < 0
commit tran


-- condições de pagto

select cpgcod,count(*) as 'qtde' from TELLA.dbo.tab17 (nolock) group by cpgcod order by 'qtde' desc

select * from TELLA.dbo.tab10 (nolock)

select cpgdias,count(*) from TELLA.dbo.tab10 (nolock) group by cpgdias

select * from SIBD_tella.dbo.TBS008 (nolock)

insert into SIBD_tella.dbo.TBS008 (CPGCOD,CPGMOD,CPGCOND,CPGDES,CPGTIPVEN,CPGDATCAD,CPGGERDUP,CPGHAB)
select convert(int,cpgcod),1,cpgcond,cpgdes,cpgdias,'20130908','S','S' from TELLA.dbo.tab10

update SIBD_tella.dbo.TBS008 set CPGTIPVEN='DD' where CPGTIPVEN='AV'

select * from SIBD_tella.dbo.TBS008 (nolock) where CPGTIPVEN='SV'

delete SIBD_tella.dbo.TBS008 where CPGTIPVEN='SV'

select CPGCOND,Len(CPGCOND) from SIBD_tella.dbo.TBS008 (nolock)

update SIBD_tella.dbo.TBS008 set CPGCOND=subString(CPGCOND,1,Len(CPGCOND)-1)

update SIBD_tella.dbo.TBS008 set CPGCOND=replace(CPGCOND,',','/')

update SIBD_tella.dbo.TBS002 set CPGCOD=convert(int,clicpgcod)
  from SIBD_tella.dbo.TBS002 as TBS002 join TELLA.dbo.tab02 as tab02 on TBS002.CLICOD collate database_default=convert(int,tab02.clicod) collate database_default

select clicod as 'codigo',convert(int,clicpgcod) as 'pagto' into #pagto from TELLA.dbo.tab02 where clicpgcod<>''

select * from #pagto

drop table #pagto

update SIBD_tella.dbo.TBS002 set CPGCOD=pagto from #pagto where CLICOD=codigo


-- 12set2013

select TBS010.PROCLAFIS as 'NCM',TBS067.UFESIG as 'UF',count(*)
  from TBS010 (nolock) join TBS0671 (nolock) on

select tab12.procodncm as 'ncm',tab18.ufesig as 'uf',count(*) as 'qtde'
  from tab12 (nolock) join tab181 (nolock) on tab12.procod=tab181.procod
                      join tab18 (nolock) on tab18.nfsnum=tab181.nfsnum
 where tab18.nfsdata >= '20090701' and tab12.prostatus='A' and tab12.procodstb='60'
 group by tab12.procodncm,tab18.ufesig
 order by qtde desc

select top 100 enfdatemi from tab39 (nolock) order by enfdatemi


select tab12.procodncm as 'ncm',tab18.ufesig as 'uf',rtrim(tab12.procod)+' '+rtrim(tab12.prodes)
  from tab12 (nolock) join tab181 (nolock) on tab12.procod=tab181.procod
                      join tab18 (nolock) on tab18.nfsnum=tab181.nfsnum
 where tab18.nfsdata >= '20090701' and tab12.prostatus='A' and tab12.procodstb='60'


select procod,prodes,proicm,properred from tab12 (nolock) where proicm>0 or properred>0

select procod,prodes,proicm,properred from tab12 (nolock) where properred<>66.67 and properred>0

select * from tab12 (nolock) where procod='01.11.0036'

select procod,prodes,proicm from tab12 (nolock) where proicm>0

select * from tab11 (nolock) where convert(int,tescfo)<5000

select nfetescod,count(*) as 'qtde' from tab21 (nolock) where nfedata >= '20100101' group by nfetescod order by qtde desc


-- rede de lojas

update SIBD.dbo.TBS002 set RDLCOD=convert(int,TELLA.dbo.tab02.rdlcod)
  from SIBD.dbo.TBS002 as TBS002 join TELLA.dbo.tab02 as tab02 on TBS002.CLICOD collate database_default=convert(int,tab02.clicod) collate database_default
