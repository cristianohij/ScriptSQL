-- cBenef

select p.PROSTBB
       ,count(*)
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41')
 group by p.PROSTBB

select distinct
       Left(Ltrim(p.PRODES),20)
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41')

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROSTATUS
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41')

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41')
       and p.PRODES Like '%MILHO%'

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PRODES Like '%COURO%'

select *
  from TBS0551 d with (nolock)
 where d.PDVNUM = 736420

exec sp_help 'TBS161'

select *
  from TBS161 with (nolock)

select *
  from TBS110 c with (nolock)
 inner join TBS1101 d with (nolock)
         on d.ROPEMPCOD = c.ROPEMPCOD
            and d.ROPREG = c.ROPREG
 where c.ROPCTR = 'DE'

select *
  from TBS092 with (nolock)

delete TBS161

select distinct
       p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41','70','90')
 order by p.PROSTBB
          ,p.PROCLAFIS

-- contagem por CST

select p.PROSTBB
       ,count(*)
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41','50','51','70','90')
 group by p.PROSTBB
 order by p.PROSTBB

-- produtos com redução da bc do icms

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB = '20'
 order by p.PRODES

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB = '20'
       and p.PROCLAFIS in('09012100',
'19053100',
'19059090',
'20091200',
'22090000',
'25010020',
'84193200',
'84201010',
'84201090',
'84224090',
'84411090',
'84659900',
'84681000',
'87168000')

select p.PROCSN
       ,count(*)
  from TBS010 p with (nolock)
 group by p.PROCSN

select Left(p.PROCLAFIS,2)
       ,count(*)
  from TBS010 p with (nolock)
 where Len(rtrim(p.PROCLAFIS)) = 8
 group by Left(p.PROCLAFIS,2)

select p.PROCOD
       ,p.PROSTBB
       ,p.PROSTATUS
  from TBS010 p with (nolock)
 where p.PROSTBB in ('20','30','40','41','50','51','70','90')

select i.PDVCST
       ,Left(i.PDVCST,1)
       ,right(rtrim(i.PDVCST),2)
       ,i.PDVPERICMS
       ,i.PDVCFOP
       ,i.*
  from TBS0551 i with (nolock)
 inner join TBS010 p with (nolock)
         on p.PROCOD = i.PROCOD
 where exists (select 1 from TBS058 pr with (nolock) where pr.PRPNUM = i.PDVNUM and pr.PROCOD = i.PROCOD)
       and right(rtrim(i.PDVCST),2) in ('20','30','40','41','50','51','70','90')

select distinct p.PROSTBB
  from TBS010 p with (nolock)
 order by p.PROSTBB

select p.PROCOD
  from TBS010 p with (nolock)
 where p.PROCOD in
('0052566',
'11840002',
'11990014',
'12360001',
'12360002',
'12360008',
'12360010',
'12360012',
'12360013',
'12360014',
'12360015',
'12360016',
'12360019',
'12360020',
'12360021',
'13020003',
'1360003',
'1360078',
'1496005',
'16220034',
'16220035',
'16220036',
'16220037',
'16420006',
'16420007',
'16420022',
'17980005',
'18264747',
'18264748',
'18520001',
'20810046',
'20880006',
'2160001',
'2160003',
'2160004',
'2160015',
'2160018',
'2160023',
'2160025',
'2160026',
'2160041',
'2160043',
'2160049',
'2161006',
'26340015',
'26340020',
'26340021',
'29880001',
'29880005',
'29880006',
'30950003',
'30950010',
'3250351',
'3250458',
'3250859',
'3250877',
'3250878',
'3250880',
'3250882',
'3250885',
'3250886',
'3251533',
'3251534',
'3251536',
'3251545',
'3251650',
'3251652',
'3251656',
'3252225',
'3252337',
'3252869',
'3255409',
'3255433',
'3257991',
'33030001',
'36200006',
'5380596',
'5380669',
'5380936',
'5501766',
'5510104',
'5510756',
'8407706',
'8461209',
'8461210',
'8461211',
'8461212',
'8461213',
'8461214',
'8461215',
'8461216',
'8461217',
'8461218',
'8461219',
'8461220',
'8461221',
'8461222',
'8478632',
'8478823',
'8478914',
'8479014',
'8479092',
'8479125',
'8770066',
'8770116',
'8770118',
'9870028',
'9870078',
'9870177',
'9870214',
'9877210',
'9880002',
'9880102',
'9880113')
and p.PROSTBB = '20'


select *
  into REDUCAO_BC_ICMS_ECONET
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-reducao-bc-icms-econet.xlsx', 'select * from [Planilha1$]')

select *
  from REDUCAO_BC_ICMS_ECONET with (nolock)

update REDUCAO_BC_ICMS_ECONET
   set NCM = replace(NCM,'.','')

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROSTBB
       ,p.PROSTATUS
  from TBS010 p with (nolock)
 inner join REDUCAO_BC_ICMS_ECONET r with (nolock)
         on r.NCM = p.PROCLAFIS collate database_default
 where p.PROSTBB <> '20'
       and p.PROSTATUS = 'A'
order by p.PROCLAFIS


select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB = '20'
       and not exists (select 0
                         from REDUCAO_BC_ICMS_ECONET r with (nolock)
                        where Len(r.NCM) = 8
                              and r.NCM = p.PROCLAFIS collate database_default)
 order by p.PRODES

select distinct
       p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41','70','90')
 order by p.PROSTBB
          ,p.PROCLAFIS

begin tran
update TBS010
   set PROCBENEF = 'SP020120'
 where PROCLAFIS = '84411090'

rollback tran
commit tran

select distinct
       p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCBENEF
  from TBS010 p with (nolock)
 where p.PROSTBB in('20','40','41','70','90')
       and p.PROCBENEF <> ''
 order by p.PROSTBB
          ,p.PROCLAFIS

begin tran
update TBS010
   set PROCBENEF = ''
 where PROSTBB not in('20','40','41','70','90')
       and PROCBENEF <> ''

rollback tran
commit tran

update TBS010
   set PROCBENEF = ''
 where PROCBENEF is null

select distinct
       p.PROSTBB
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROSTBB in('40','41','70','90')
 order by p.PROSTBB
          ,p.PROCLAFIS

select --p.PROCOD
       --,p.PRODES
       distinct p.PROCLAFIS
  from TBS010 p with (nolock)
 where exists (
select l.LOGID
  from TBS035 l with (nolock)
 where l.[LOGDAT] = '20260715'
       and l.LOGUSU = 'DESENV'
       and l.LOGROTDES = 'MANUTENCAO LOTE'
       and l.LOGATT = 'PROSTBB'
       and l.LOGVALANT = '40'
       and l.LOGID = p.PROLOGID)

-- NCM
-- 7615.20.00 cBenef SP010160

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROSTATUS
  from TBS010 p with (nolock)
 where p.PROCLAFIS in ('','00000000')

select count(*)
  from TBS010 p with (nolock)
 where p.PROSTBB = '40'

select '''' + rtrim(p.PROCOD) + ''','
  from TBS010 p with (nolock)
 where p.PROSTBB = '40'


