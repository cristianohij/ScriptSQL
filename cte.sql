select * into #cte
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\cte.xlsx', 'select * from [cte$]')

select * from #cte

select * from TBS130 (nolock) where exists(select '' from #cte where chave collate database_default=CTEENTCHA)



delete freteEstrelaVale where Id is null
  
with tab as (
select *
  from freteEstrelaVale
 where not vTPrest is null)
 
 --select * from tab

update freteEstrelaVale set vTPrest=(select top 1 tab.vTPrest from tab where tab.Id = freteEstrelaVale.Id)

with tab as (
select *
  from freteEstrelaVale
 where not vRec is null)

update freteEstrelaVale set vRec=(select top 1 tab.vRec from tab where tab.Id = freteEstrelaVale.Id)
 
select * from frete where Id='CTe35161203233998000162570000000470081000952232'

delete freteEstrelaVale where chave is null

select * from frete

select top 1 * from TBS059 (nolock)

select NFEDATEFE,NFENUM,NFECHAACE,dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD),
       Id,chave,vTPrest
  from TBS059 (nolock)
       inner join freteEstrelaVale on chave=NFECHAACE collate database_default
 where NFECAN='N' and
       NFEDATEFE between '20171101' and '20171130'
 order by NFEDATEFE desc

select NFEDATEFE data_entrada,
       NFENUM num_nf,
       --NFECHAACE chave,
       dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD) total_nf,
       Id chave_cte,
       chave chave_nf,
       dhEmi emissao,
       vTPrest valor_frete
  from frete
       inner join TBS059 (nolock) on chave=NFECHAACE collate database_default
 where NFECAN='N' and
       NFEDATEFE between '20171101' and '20171130'
 order by NFEDATEFE desc

select 'copy ' + Id + '.xml 17-11-nov\*'
  from freteEstrelaVale
       inner join TBS059 (nolock) on chave=NFECHAACE collate database_default
 where NFECAN='N' and
       NFEDATEFE between '20171101' and '20171130'
 order by NFEDATEFE desc



select * from TBS130 (nolock)


-- liomar

select * into freteLiomar
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\cte-liomar.xlsx', 'select * from [resumo$]')

delete freteLiomar where Id is null
  
with tab as (
select *
  from freteLiomar
 where not vTPrest is null)
 
 --select * from tab

update freteLiomar set vTPrest=(select top 1 tab.vTPrest from tab where tab.Id = freteLiomar.Id)

with tab as (
select *
  from freteLiomar
 where not vRec is null)

update freteLiomar set vRec=(select top 1 tab.vRec from tab where tab.Id = freteLiomar.Id)

delete freteLiomar where chave is null

select NFEDATEFE data_entrada,
       NFENUM num_nf,
       --NFECHAACE chave,
       dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD) total_nf,
       Id chave_cte,
       chave chave_nf,
       dhEmi emissao,
       vTPrest valor_frete
  from freteLiomar
       inner join TBS059 (nolock) on chave=NFECHAACE collate database_default
 where NFECAN='N' and
       NFEDATEFE between '20171201' and '20171220'
 order by NFEDATEFE desc

select 'copy ' + Id + '.xml 17-11-nov\*'
  from freteLiomar
       inner join TBS059 (nolock) on chave=NFECHAACE collate database_default
 where NFECAN='N' and
       NFEDATEFE between '20171101' and '20171130'
 order by NFEDATEFE desc

select * from TBS0591 (nolock) where NFENUM=6154




--  todas

drop table frete

select * into frete from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\cte2.xlsx', 'select * from [resumo$]')

select * from frete (nolock) where dhEmi > '20161231'

select * from frete (nolock) where nCT=26678

select * from frete (nolock) where dhEmi is null

select * from frete (nolock)

delete frete where Id is null

-- atualiza valores

with tab as (
select *
  from frete
 where not vTPrest is null)

update frete set vTPrest=(select top 1 tab.vTPrest from tab where tab.Id = frete.Id)

with tab as (
select *
  from frete
 where not vRec is null)

update frete set vRec=(select top 1 tab.vRec from tab where tab.Id = frete.Id)

with tab as (
select *
  from frete
 where not vNF is null)

update frete set vNF=(select top 1 tab.vNF from tab where tab.Id = frete.Id)

/* não funcionou

with tab as (
select *
  from frete
 where not dhEmi is null)

select * from tab

update frete set dhEmi=(select top 1 tab.dhEmi from tab where tab.Id = frete.Id)

select * from frete where not dhEmi is null
*/

-- elimina nulos

delete frete where chave is null and nDoc is null

-- confronta os dados

select top 1 * from TBS059 (nolock)

--select Id from frete (nolock) --where Id='CTe35161203233998000162570000000470081000952232'
-- where frete.Id not in
--select NFECTECHA from TBS059 (nolock) where NFECTECHA='' and
--NFECTECHA not in
select Id from frete (nolock)
 where replace(frete.Id,'CTe','') in
('35171203233998000162570000000841761001328026',
'35171203233998000162570000000842301001328561',
'35171203233998000162570000000842601001328862',
'35171203233998000162570000000843721001329954',
'35171203233998000162570000000846921001333101',
'35171203233998000162570000000849411001335535',
'35171203233998000162570000000849491001335614',
'35171203233998000162570000000849561001335686',
'35171203233998000162570000000849691001335811',
'35171203233998000162570000000854041001340133',
'35171203233998000162570000000855891001341647',
'35171203233998000162570000000856521001342274',
'35171203233998000162570000000859281001344960',
'35171203233998000162570000000859381001345068',
'35171203233998000162570000000865151001350787',
'35171258636739000174570010000539661000324497',
'35171258636739000174570010000540251000325550',
'35171258636739000174570010000541421000327800',
'35171258636739000174570010000541451000327837',
'35171258636739000174570010000542191000329002',
'35171258636739000174570010000542871000330485',
'35171258636739000255570010000262251000323150',
'35171258636739000255570010000262331000323233',
'35171258636739000255570010000262351000323254',
'35171258636739000255570010000262361000323260',
'35171258636739000255570010000262391000323296',
'35171258636739000255570010000262631000323798',
'35171258636739000255570010000262641000323809',
'35171258636739000255570010000263041000324624',
'35171258636739000255570010000263311000325180',
'35171258636739000255570010000263541000325681',
'35171258636739000255570010000263551000325697',
'35171258636739000255570010000263641000325785',
'35171258636739000255570010000263661000325801',
'35171258636739000255570010000263671000325817',
'35171258636739000255570010000263751000326157',
'35171258636739000255570010000263811000326219',
'35171258636739000255570010000263881000326287',
'35171258636739000255570010000264061000326708',
'35171258636739000255570010000264121000326845',
'35171258636739000255570010000264131000326869',
'35171258636739000255570010000264211000327255',
'35171258636739000255570010000264261000327308',
'35171258636739000255570010000264291000327334',
'35171258636739000255570010000264411000327460',
'35171258636739000255570010000264441000327497',
'35171258636739000255570010000264611000327900',
'35171258636739000255570010000264621000327916',
'35171258636739000255570010000264651000327950',
'35171258636739000255570010000264661000327966',
'35171258636739000255570010000264981000328508',
'35171258636739000255570010000265001000328524',
'35171258636739000255570010000265101000329187',
'35171258636739000255570010000265181000329266',
'35171258636739000255570010000265281000329564',
'35171258636739000255570010000265311000329594',
'35171258636739000255570010000265331000329610',
'35171258636739000255570010000265351000329631',
'35171258636739000255570010000265391000329673',
'35171258636739000255570010000265401000329682',
'35171258636739000255570010000265681000330193',
'35171258636739000255570010000265881000330625',
'35171258636739000255570010000265891000330630',
'35171258636739000255570010000266021000330766',
'35171258636739000255570010000266051000330792',
'35171258636739000255570010000266201000330985',
'35171258636739000255570010000266341000331170',
'35171258636739000255570010000266381000331234',
'35171258636739000255570010000266391000331240',
'35171258636739000255570010000266511000331392',
'35171258636739000255570010000266531000331419',
'35171258636739000255570010000266591000331498',
'35171258636739000255570010000266601000331502',
'35171258636739000255570010000266721000331716')

and not exists(select '' from TBS059 (nolock) where NFECAN='N' and NFECTECHA=replace(frete.Id,'CTe','') collate database_default)

group by frete.Id


-- com chave

select nCT,chave from frete
 where dhEmi between '20171201' and '20171231' and not chave is null and CNPJ15=65069593000198
       and not exists(select '' from TBS059 (nolock) where NFECHAACE=chave collate database_default and NFECAN='N')
 group by nCT, chave


-- sem chave

select nCT,nDoc from frete
 where dhEmi between '20171201' and '20171231' and not nDoc is null and CNPJ15=65069593000198
       and not exists(select '' from TBS059 (nolock)
                       where NFENUM=nDoc and dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)=vNF and NFECAN='N')
 group by nCT, nDoc


select * from frete (nolock) where 


select top 1 * from TBS059 (nolock)

select NFEDATEFE,NFENUM,NFECHAACE,dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD),
       Id,chave,vTPrest
  from TBS059 (nolock)
       inner join frete on chave=NFECHAACE collate database_default
 where NFECAN='N' and
       NFEDATEFE between '20171101' and '20171130'
 order by NFEDATEFE desc

select NFEDATEFE data_entrada,
       NFENUM num_nf,
       --NFECHAACE chave,
       dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD) total_nf,
       Id chave_cte,
       chave chave_nf,
       dhEmi emissao,
       vTPrest valor_frete,
       convert(int,subString(Id,29,9)) num_cte,
       dhEmi

  from frete
       inner join TBS059 (nolock) on --chave=NFECHAACE collate database_default or 
nDoc=NFENUM
 where NFECAN='N' and
       NFEDATEFE between '20171201' and '20171231'
       and dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)=vNF
       and NFECTECHA<>''
       and subString(Id,6,2) <> '16'

--       and dhEmi > '20161231'
 order by --NFEDATEFE desc
          convert(int,subString(Id,29,9))

select * from frete where Id='CTe35171258636739000174570010000539661000324497'

select dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD) total_nf,
       *
  from TBS059 (nolock) 
 where NFENUM=86981


-- CT-e com chave

drop table fretecc

select * into fretecc from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\cte-cc.xlsx', 'select * from [resumo$]')

select * from frete (nolock) where dhEmi > '20161231'

delete fretecc where Id is null

-- atualiza valores

with tab as (
select *
  from fretecc
 where not vTPrest is null)

update fretecc set vTPrest=(select top 1 tab.vTPrest from tab where tab.Id = fretecc.Id)

with tab as (
select *
  from fretecc
 where not vRec is null)

update fretecc set vRec=(select top 1 tab.vRec from tab where tab.Id = fretecc.Id)

with tab as (
select *
  from fretecc
 where not vCarga is null)

update fretecc set vCarga=(select top 1 tab.vCarga from tab where tab.Id = fretecc.Id)

with tab as (
select *
  from fretecc
 where not dhEmi is null)

update fretecc set dhEmi=(select top 1 tab.dhEmi from tab where tab.Id = fretecc.Id) where dhEmi is null

select * from fretecc (nolock)

delete fretecc where chave is null


-- CT-e sem chave

drop table fretesc

select * into fretesc from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\cte-sc.xlsx', 'select * from [resumo$]')

select * from frete (nolock) where dhEmi > '20161231'

delete fretesc where Id is null

-- atualiza valores

with tab as (
select *
  from fretesc
 where not vTPrest is null)

update fretesc set vTPrest=(select top 1 tab.vTPrest from tab where tab.Id = fretesc.Id)

with tab as (
select *
  from fretesc
 where not vRec is null)

update fretesc set vRec=(select top 1 tab.vRec from tab where tab.Id = fretesc.Id)

with tab as (
select *
  from fretesc
 where not vNF is null)

update fretesc set vNF=(select top 1 tab.vNF from tab where tab.Id = fretesc.Id)

with tab as (
select *
  from fretesc
 where not dhEmi is null)

update fretesc set dhEmi=(select top 1 tab.dhEmi from tab where tab.Id = fretesc.Id) where dhEmi is null

with tab as (
select *
  from fretesc
 where not vProd is null)

update fretesc set vProd=(select top 1 tab.vProd from tab where tab.Id = fretesc.Id) where vProd is null

with tab as (
select *
  from fretesc
 where not vCarga is null)

update fretesc set vCarga=(select top 1 tab.vCarga from tab where tab.Id = fretesc.Id) where vCarga is null

select * from fretesc (nolock)

delete fretesc where nDoc is null


-- confronta os dados

-- com chave

select top 1 * from TBS059 (nolock)

select * from fretesc (nolock) where convert(date,dhEmi) between '20171201' and '20171231'

select convert(date,dhEmi) from fretecc (nolock) where year(dhEmi)=2017

select convert(date,dhEmi) from fretesc (nolock) where year(dhEmi)=2017

select convert(date,dhEmi),* from fretesc (nolock) where nCT=26568

select convert()

select NFEDATEFE data_entrada,
       NFENUM num_nf,
       dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD) total_nf,
       Id chave_cte,
       chave chave_nf,
       dhEmi emissao,
       vTPrest valor_frete,
       convert(int,subString(Id,29,9)) num_cte

  from fretecc
       inner join TBS059 (nolock) on chave=NFECHAACE collate database_default

 where NFECAN='N' and
       NFEDATEFE between '20171201' and '20171231'
--       and dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)=vNF
       and NFECTECHA=''
       and subString(Id,6,2) <> '16'

--       and dhEmi > '20161231'
 order by --NFEDATEFE desc
          convert(int,subString(Id,29,9))

select * from frete where Id='CTe35171258636739000174570010000539661000324497'

select dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD) total_nf,
       *
  from TBS059 (nolock) 
 where NFENUM=86981

select 'copy ' + Id + '.xml 17-12-dez\*'
  from fretecc
       inner join TBS059 (nolock) on chave=NFECHAACE collate database_default
 where NFECAN='N' and
       NFEDATEFE between '20171201' and '20171231'
       and subString(Id,6,2) <> '16'


-- sem chave

select top 1 * from TBS059 (nolock)

select * from fretesc (nolock)

with tab as (
select NFEDATEFE data_entrada,
       NFENUM num_nf,
       dbo.NFETOTOPE(TBS059.NFEEMPCOD,TBS059.NFETIP,TBS059.NFENUM,TBS059.NFECOD,TBS059.SEREMPCOD,TBS059.SERCOD) total_nf,
       Id chave_cte,
       nCT num_cte,
       dhEmi emissao,
       vTPrest valor_frete --,
--       convert(int,subString(Id,29,9)) num_cte

  from fretesc
       inner join TBS059 (nolock) on nDoc=NFENUM and dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)=vNF

 where NFECAN='N' and
       NFEDATEFE between '20171201' and '20171231'
--       and dbo.NFETOTOPE(TBS059.NFEEMPCOD, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, TBS059.SEREMPCOD, TBS059.SERCOD)=vNF
       and NFECTECHA=''
       and subString(Id,6,2) <> '16'

--       and dhEmi > '20161231'
-- order by --NFEDATEFE desc
--          convert(int,subString(Id,29,9))
)

select chave_cte, num_cte from tab group by chave_cte, num_cte order by num_cte

select 'copy ' + chave_cte + '.xml 17-12-dez\*'
  from tab
 group by chave_cte, num_cte order by num_cte


---

select * from frete (nolock) where dhEmi between '20171201' and '20171231'

select * from frete (nolock) where nCT=26678



--

select * from TBS130 (nolock) where CTEENTDATEMI between '20180101' and '20180110'


-- copiar arquivo XML

select top 1 * from TBS130 (nolock)
select top 1 * from TBS1301 (nolock)

select 'copy Cte' + rtrim(TBS130.CTEENTCHA) + '.xml sel\*.*'
  from TBS130 (nolock)
       inner join TBS1301 (nolock) on TBS1301.CTEENTEMP=TBS130.CTEENTEMP and TBS1301.CTEENTCHA=TBS130.CTEENTCHA
 where TBS1301.CTEENTDEFDOC between '20180301' and '20180331'

select 'copy ' + rtrim(TBS130.CTEENTCHA) + '.xml sel\*.*'
  from TBS130 (nolock)
       inner join TBS1301 (nolock) on TBS1301.CTEENTEMP=TBS130.CTEENTEMP and TBS1301.CTEENTCHA=TBS130.CTEENTCHA
 where TBS1301.CTEENTDEFDOC between '20180301' and '20180331'


-- analises

select *,
       dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA)
  from TBS130 (nolock)
 where TBS130.CTEENTCHA<>''

select TBS130.CTEENTEMP,
       TBS130.CTEENTNUM,
       sum(dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
  from TBS130 (nolock)
 where --TBS130.CTEENTCHA<>''
       TBS130.CTEENTNUM > 0
 group by TBS130.CTEENTEMP, TBS130.CTEENTNUM


  from TBS130 (nolock)
       inner join TBS005 (nolock) on TBS005.TRNCOD=TBS130.TRNCOD

select *
  from TBS130 (nolock)
       inner join TBS1301 (nolock) on TBS1301.CTEENTEMP=TBS130.CTEENTEMP and TBS1301.CTEENTCHA=TBS130.CTEENTCHA
 where TBS1301.CTEENTDEFDOC between '20180401' and '20180430'

select CTEENTNUM, count(*)
  from TBS130 (nolock)
       inner join TBS1301 (nolock) on TBS1301.CTEENTEMP=TBS130.CTEENTEMP and TBS1301.CTEENTCHA=TBS130.CTEENTCHA
 where TBS1301.CTEENTDEFDOC between '20180201' and '20180228'
 group by CTEENTNUM

select CTEENTNUM, CTEENTFREPES + CTEENTFREVAL + CTEENTGRIS + CTEENTPED + CTEENTTRT + CTEENTTDE + CTEENTSECCAT + CTEENTDES + CTEENTSEG + CTEENTTAX + CTEENTOUT
  from TBS130 (nolock)
       inner join TBS1301 (nolock) on TBS1301.CTEENTEMP=TBS130.CTEENTEMP and TBS1301.CTEENTCHA=TBS130.CTEENTCHA
 where TBS1301.CTEENTDEFDOC between '20180201' and '20180228'

select sum(CTEENTFREPES + CTEENTFREVAL + CTEENTGRIS + CTEENTPED + CTEENTTRT + CTEENTTDE + CTEENTSECCAT + CTEENTDES + CTEENTSEG + CTEENTTAX + CTEENTOUT),
       sum(dbo.CTEENTVALICM(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
  from TBS130 (nolock)
       inner join TBS1301 (nolock) on TBS1301.CTEENTEMP=TBS130.CTEENTEMP and TBS1301.CTEENTCHA=TBS130.CTEENTCHA
 where TBS1301.CTEENTDEFDOC between '20180201' and '20180228'

select * from TBS1301 (nolock)
