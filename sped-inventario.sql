select * from TBS098 (nolock) where SALVAL = 0 or SALVAL is null

select * from TBS098 (nolock) where SALQTD < 0 or SALQTD is null

delete TBS098 where SALVAL = 0 or SALVAL is null

select PROCOD,PRODES from TBS010 (nolock) where PROCOD in('2881497','2235905')

select PDPPREUNI from TBS015 (nolock) where PDPCOD in('2881497','2235905')

select * from TBS098 (nolock)

select * from TBS098 (nolock) where SALREF='12/2013'

update TBS098 set SALCONSPED = '011210001'

select sum(SALVAL*SALQTD) from TBS098 (nolock)

select PROCOD,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD),
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD)
  from TBS098 (nolock) where SALVAL is null or SALVAL = 0

declare @ref char(7)
set @ref = right('0'+convert(varchar,datepart(mm,dateAdd(mm,dateDiff(mm,0,getDate()),-1))),2)+'/'+convert(varchar,datepart(yyyy,dateAdd(mm,dateDiff(mm,0,getDate()),-1)))

insert into TBS098
       (SALREF,
        PROCOD,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS,
        SALUNI)
select @ref,
       PROCOD,
       isnull(sum(ESTQTDATU),0),
       isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD = TBS032.PROCOD),0),
       1,
       isnull((select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = TBS032.PROCOD),'0/00'),
       isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS032.PROCOD),'UN')
  from TBS032 (nolock)
 group by PROCOD

select * from TBS010 (nolock) where PROCODBAR1 = '7897424082124'

update TBS098 set SALQTD = 0 where SALREF = '03/2013' and SALQTD is null
update TBS098 set SALVAL = 0 where SALREF = '03/2013' and SALVAL is null

select sum(SALQTD*SALVAL) from TBS098 (nolock) where SALREF = '03/2013' and SALQTD > 0

select PROCOD,(select PRODES from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD),SALQTD,SALVAL from TBS098 (nolock) where SALREF = '06/2013' and SALQTD > 0

-- mre

select TBS0671.PROCOD,avg(TBS0671.NFSPRECUS/TBS0671.NFSQTDEMB)
  from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSNUM = TBS0671.NFSNUM
 where NFSDATEMI between '20130301' and '20130331'
 group by TBS0671.PROCOD

select TBS098.PROCOD,TBS098.SALVAL from TBS098 (nolock)
 where SALREF = '03/2013' and SALQTD > 0 and
       SALVAL <> (select avg(TBS0671.NFSPRECUS/TBS0671.NFSQTDEMB)
                    from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSNUM = TBS0671.NFSNUM
                   where NFSDATEMI between '20131201' and '20131231' and TBS0671.PROCOD = TBS098.PROCOD
                   group by TBS0671.PROCOD) and
       (select avg(TBS0671.NFSPRECUS/TBS0671.NFSQTDEMB)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSNUM = TBS0671.NFSNUM
         where NFSDATEMI between '20131201' and '20131231' and TBS0671.PROCOD = TBS098.PROCOD
         group by TBS0671.PROCOD) > 0

update TBS098 set SALVAL = (select avg(TBS0671.NFSPRECUS/TBS0671.NFSQTDEMB)
                              from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSNUM = TBS0671.NFSNUM
                             where NFSDATEMI between '20131201' and '20131231' and TBS0671.PROCOD = TBS098.PROCOD
                             group by TBS0671.PROCOD)
 where SALREF = '12/2013' and SALQTD > 0 and
       SALVAL <> (select avg(TBS0671.NFSPRECUS/TBS0671.NFSQTDEMB)
                    from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSNUM = TBS0671.NFSNUM
                   where NFSDATEMI between '20131201' and '20131231' and TBS0671.PROCOD = TBS098.PROCOD
                   group by TBS0671.PROCOD) and
       (select avg(TBS0671.NFSPRECUS/TBS0671.NFSQTDEMB)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSNUM = TBS0671.NFSNUM
         where NFSDATEMI between '20131201' and '20131231' and TBS0671.PROCOD = TBS098.PROCOD
         group by TBS0671.PROCOD) > 0

-- exporta pra SCI
select '|'+ltrim(rtrim(PROCOD))+'|','03/2013',ltrim(str(SALQTD,8,4)),ltrim(str(SALVAL,8,4)),0,ltrim(str(SALQTD*SALVAL,8,4)),1,'','|'+'04.1.1.01.002'+'|','',0,(select '|'+PROSTBA+PROSTBB+'|' from SIBD.dbo.TBS010 TBS010 (nolock) where TBS010.PROCOD=TBS098.PROCOD) from SIBD.dbo.TBS098 TBS098 (nolock) where SALREF = '03/2013' and SALQTD > 0

declare @comando varchar(1000)
set @comando = 'bcp "select ''|''+ltrim(rtrim(PROCOD))+''|'',''03/2013'',ltrim(str(SALQTD,8,4)),ltrim(str(SALVAL,8,4)),0,ltrim(str(SALQTD*SALVAL,8,4)),1,''||'',''|''+''04.1.1.01.002''+''|'',''||'',0,(select ''|''+PROSTBA+PROSTBB+''|'' from SIBD.dbo.TBS010 TBS010 (nolock) where TBS010.PROCOD=TBS098.PROCOD) from SIBD.dbo.TBS098 TBS098 (nolock) where SALREF = ''03/2013'' and SALQTD > 0" queryout c:\temp\13-03-sped-inventario-mre-sci.txt -c -T -t","'
exec master..xp_cmdshell @comando

declare @comando varchar(1000)
set @comando = 'bcp "select ''|''+ltrim(rtrim(PROCOD))+''|'',''12/2012'',ltrim(str(SALQTD,8,4)),ltrim(str(SALVAL,8,4)),0,ltrim(str(SALQTD*SALVAL,8,4)),1,''||'',''|''+''04.1.1.01.002''+''|'',''||'',0,''|''+SALCSTICMS+''|'' from SIBD.dbo.TBS098 (nolock) where SALREF = ''12/2012''" queryout c:\temp\2012-12-sped-inventario-papelyna-sci.txt -c -T -t","'
exec master..xp_cmdshell @comando


-- trabalhando com datas
print month(getdate())
print year(getdate())
print datepart(mm, getdate())
select right('0'+convert(varchar,datepart(mm,getdate())),2) + '/' + convert(varchar,datepart(yyyy, getdate()))

select right('0'+convert(varchar,datepart(mm,dateAdd(mm,dateDiff(mm,0,getDate()),-1))),2)+'/'+convert(varchar,datepart(yyyy,dateAdd(mm,dateDiff(mm,0,getDate()),-1)))


select PROCOD,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD),
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD)
  from TBS098 (nolock) where SALVAL is null or SALVAL = 0

update TBS098 set SALUNI = (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD) where SALREF = '12/2013'

select * from TBS098 (nolock) where SALREF = '09/2013' and SALQTD < 0
select * from TBS098 (nolock) where SALREF = '09/2013' and SALQTD >= 10000
select * from TBS098 (nolock) where SALREF = '09/2013' and SALVAL < 0

delete TBS098 where SALREF = '09/2013' and SALQTD >= 10000

select * from TBS032 (nolock) where exists(select '' from TBS098 (nolock) where SALREF = '06/2013' and SALQTD >= 9999 and TBS098.PROCOD=TBS032.PROCOD)

select * from TBS0371 (nolock) where PROCOD = '1080482'
select * from TBS049 (nolock) where PROCOD = '1080482'
select * from TBS0591 (nolock) where PROCOD = '1080482'
select * from TBS051 (nolock) where PROCOD = '1080482'

-- best bag

select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from sped.txt')

delete TBS098 where SALREF='09/2013'

declare @ref char(7)
set @ref = right('0'+convert(varchar,datepart(mm,dateAdd(mm,dateDiff(mm,0,getDate()),-1))),2)+'/'+convert(varchar,datepart(yyyy,dateAdd(mm,dateDiff(mm,0,getDate()),-1)))

insert into TBS098
       (SALREF,
        PROCOD,
        SALUNI,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS)
select '12/2014',
       subString(linha,8,15),
       subString(linha,23,2),
       sum(convert(money,subString(linha,25,8))),
       sum(convert(money,subString(linha,33,12))),
       1,
       (select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = subString(linha,8,15))
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from sped.txt')
 group by subString(linha,8,15)

--

insert into TBS098
       (SALREF,
        PROCOD,
        SALUNI,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS)
select '12/2012',
       subString(linha,1,15),
       subString(linha,76,2),
       convert(money,subString(linha,90,12)),
       convert(money,subString(linha,78,12)),
       1,
       (select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = subString(linha,1,15))
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from sped.txt')

update TBS098 set LESCOD=1 where SALREF='12/2011'

update TBS098 set SALVAL=7.9270,SALQTD=11 where SALREF='12/2012' and PROCOD='9830055'

select PROCOD from TBS098 as T1 (nolock) where SALREF='12/2011' and (select count(*) from TBS098 as T2 (nolock) where T1.SALREF=T2.SALREF and T1.PROCOD=T2.PROCOD) > 1

select sum(SALQTD*SALVAL) from TBS098 (nolock) where SALREF='12/2012'

select PROCOD,SALVAL,SALQTD from TBS098 (nolock) where SALREF='12/2012' order by PROCOD


-- sharpel

declare @ref char(7)
set @ref = right('0'+convert(varchar,datepart(mm,dateAdd(mm,dateDiff(mm,0,getDate()),-1))),2)+'/'+convert(varchar,datepart(yyyy,dateAdd(mm,dateDiff(mm,0,getDate()),-1)))

insert into TBS098
       (SALREF,
        PROCOD,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS)
select @ref,
       PROCOD,
       sum(ESTQTDATU),
       isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD = TBS032.PROCOD),0),
       1,
       (select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = TBS032.PROCOD)
  from TBS032 (nolock)
 where ESTLOC=1
 group by PROCOD

select PROCOD,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD),
       SALUNI,
       SALQTD,
       SALVAL
  from TBS098 (nolock) where SALREF='09/2013' and SALQTD > 0 

-- misaspel

delete TBS098 where SALREF='09/2013'

declare @ref char(7)
set @ref = right('0'+convert(varchar,datepart(mm,dateAdd(mm,dateDiff(mm,0,getDate()),-1))),2)+'/'+convert(varchar,datepart(yyyy,dateAdd(mm,dateDiff(mm,0,getDate()),-1)))

insert into TBS098
       (SALREF,
        PROCOD,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS)
select @ref,
       subString(linha,8,15),
       sum(convert(money,subString(linha,85,8))),
       sum(convert(money,subString(linha,93,12))),
       1,
       (select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = subString(linha,8,15))
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from sped.txt')
 group by subString(linha,8,15)

update TBS098 set SALUNI = (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD) where SALREF = '12/2013'

select count(*) from TBS098 (nolock) where SALREF='09/2013'

select sum(SALQTD*SALVAL) from TBS098 (nolock) where SALREF='09/2013'

select * from TBS098 (nolock) where SALREF='09/2013' and PROCOD='8570081'

select PROCOD,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD),
       SALUNI,
       SALQTD,
       SALVAL,
       isnull(SALQTD*SALVAL,0)
  from TBS098 (nolock)
 where SALREF = '12/2013' and SALQTD*SALVAL > 0
compute sum(SALQTD*SALVAL) by SALQTD,SALVAL

insert into TBS098
       (SALREF,
        PROCOD,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS)
select '12/2013',
       PROCOD,
       sum(ESTQTDATU),
       isnull((select TDPCUSBAS from SIBDTEMP.dbo.TBS031 T31 (nolock) where T31.TDPPROCOD = T32.PROCOD),0),
       1,
       (select PROSTBA + '/' + PROSTBB from SIBDTEMP.dbo.TBS010 T10 (nolock) where T10.PROCOD = T32.PROCOD)
  from SIBDTEMP.dbo.TBS032 T32 (nolock)
 group by PROCOD

update TBS098 set SALUNI = (select PROUM1 from SIBDTEMP.dbo.TBS010 T10 (nolock) where T10.PROCOD = TBS098.PROCOD) where SALREF = '12/2013'

update TBS098 set SALQTD=24 where SALREF='12/2013' and PROCOD='7601256'

select SALQTD*SALVAL,SALUNI from TBS098 where SALREF='12/2013' and PROCOD='7601256'


update TBS098 set SALCSTICMS = (select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD)
 where SALREF = '12/2013' and SALCSTICMS is null


-- tella barros

declare @ref char(7)
set @ref = '06/2014'

insert into TBS098
       (SALREF,
        PROCOD,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS)
select @ref,
       subString(linha,8,15),
       sum(convert(money,subString(linha,85,8))),
       sum(convert(money,subString(linha,93,12))),
       1,
       (select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = subString(linha,8,15))
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from sped.txt')
 group by subString(linha,8,15)


select * from TBS098 (nolock) where SALREF='06/2014'

update TBS098 set SALUNI = (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD) where SALREF = '06/2014'

select sum(SALQTD*SALVAL) from TBS098 (nolock) where SALREF='12/2014' and SALQTD > 0 and SALVAL > 0

update TBS098 set SALCONSPED='01.1.2.10.001' where SALREF='06/2014' 


delete TBS098 where SALREF='12/2014'

insert into TBS098
       (SALREF,
        PROCOD,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS,
        SALUNI)
select '12/2014',
       PROCOD,
       isnull(sum(ESTQTDATU),0),
       isnull((select TDPCUSBAS from INVENT.dbo.TBS031 (nolock) where TDPPROCOD = PROCOD),0),
       1,
       isnull((select PROSTBA + '/' + PROSTBB from INVENT.dbo.TBS010 as TBS010 (nolock) where TBS010.PROCOD = TBS032.PROCOD),'0/00'),
       isnull((select PROUM1 from INVENT.dbo.TBS010 as TBS010 (nolock) where TBS010.PROCOD = TBS032.PROCOD),'UN')
  from INVENT.dbo.TBS032 as TBS032 (nolock)
 where ESTLOC in(1,2)
 group by PROCOD



-- tella barros

--delete TBS098 where SALREF='12/2014'

insert into TBS098
       (SALREF,
        PROCOD,
        SALUNI,
        SALQTD,
        SALVAL,
        SALINDPRO,
        SALCSTICMS)
select '12/2014',
       subString(coluna,8,15),
       subString(coluna,23,2),
       sum(convert(money,subString(coluna,25,8))),
       sum(convert(money,subString(coluna,33,12))),
       1,
       (select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = subString(coluna,8,15))
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select coluna from sped.txt')
 group by subString(coluna,8,15)

select subString(coluna,8,15) as 'codigo',subString(coluna,23,2) as 'unidade',convert(money,subString(coluna,25,8)) as 'qtde',convert(money,subString(coluna,33,12)) as 'custo'
  into #SPED
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from sped.txt')


select * from #SPED

insert into TBS098 (SALREF,PROCOD,SALUNI,SALQTD,SALVAL) select '12/2014',* from #SPED

update TBS098 set SALUNI = (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS098.PROCOD) where SALREF = '12/2014'



-- data no formato aaaa/mm

declare @ref char(7),@cont int;
set @ref = convert(varchar,datepart(yyyy,dateAdd(mm,dateDiff(mm,0,getDate()),-1)))+'/'+right('0'+convert(varchar,datepart(mm,dateAdd(mm,dateDiff(mm,0,getDate()),-1))),2)

select top 1 * from TBS098 (nolock) where SALREF=@ref

if @@rowcount = 0
   begin
      insert into TBS098
         (SALREF,
          LESCOD,
          PROCOD,
          SALQTD,
          SALVAL,
          SALINDPRO,
          SALCSTICMS,
          SALUNI,
          SALCONSPED)
      select @ref,
             ESTLOC,
             PROCOD,
             isnull(sum(ESTQTDATU),0),
             isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD = TBS032.PROCOD),0),
             1,
             isnull((select PROSTBA + '/' + PROSTBB from TBS010 (nolock) where TBS010.PROCOD = TBS032.PROCOD),'0/00'),
             isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS032.PROCOD),'UN'),
             '01.1.2.10.001'
        from TBS032 (nolock)
       where ESTLOC in(1,2) and ESTQTDATU<>0
       group by ESTLOC,PROCOD
   end