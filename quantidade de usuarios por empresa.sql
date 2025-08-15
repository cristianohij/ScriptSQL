select distinct MUSIP from BESTBAG.SIBD2.dbo.TBS116 as B
 where not exists(select '' from PAPELYNA.SIBD.dbo.TBS116 as P where P.MUSIP=B.MUSIP)

select distinct MUSIP from PAPELYNA.SIBD.dbo.TBS116 as P
 where not exists(select '' from BESTBAG.SIBD2.dbo.TBS116 as B where B.MUSIP=P.MUSIP)


if object_id('tempdb..#IP') is not null
   begin
      drop table #IP
   end

select distinct MUSIP 
  into #IP
  from --TANBYT.SIBD.dbo.TBS116
       TBS116
 where MUSIP Like('192.168.1.%') and MUSIP<>'192.168.3.205'

select count(*) as 'qtde usuário',39*count(*) as 'valor total p/usuarios',515 as 'valor p/servidor',39*count(*)+515 as 'valor total' from #IP

select MUSIP,count(*),max(MUSDATLOGOF) from MISASPEL.SIBD.dbo.TBS116 where MUSIP Like('192.168.1.%') group by MUSNOM,MUSIP

select count(MUSIP) from MISASPEL.SIBD.dbo.TBS116 where MUSIP Like('192.168.18.%') and MUSIP<>'192.168.18.11' group by subString(MUSIP,1,10)

select distinct MUSIP 
  into #IP
  from TBS116 (nolock)
 where MUSIP Like('192.168.3.%') and MUSIP<>'192.168.3.205'

select MUSIP,count(*),max(MUSDATLOGOF) from TBS116 where MUSIP Like('192.168.1.%') group by MUSNOM,MUSIP

select MUSIP,max(MUSDATLOGOF) from TBS116 where MUSIP Like('192.168.1.%') group by MUSNOM,MUSIP order by MUSDATLOGOF

select MUSIP,MUSDATLOGIN from TBS116 (nolock) where MUSIP Like('192.168.1.%') group by MUSIP,MUSDATLOGIN order by MUSDATLOGIN desc

select convert(char(7),MUSDATLOGIN,111),MUSIP,MUSDATLOGIN,count(*) from TBS116 (nolock) group by convert(char(7),MUSDATLOGIN,111),MUSIP,MUSDATLOGIN

-- quantidade de acessos mensal
select convert(char(7),MUSDATLOGIN,111),count(*) from TBS116 (nolock)
 where MUSIP Like('192.168.1.%') group by convert(char(7),MUSDATLOGIN,111) order by convert(char(7),MUSDATLOGIN,111) desc

select convert(char(7),MUSDATLOGIN,111),subString(MUSIP,1,10),count(*)
  from TBS116 (nolock)
 where MUSIP Like('192.168.1.%')
 group by convert(char(7),MUSDATLOGIN,111),subString(MUSIP,1,10) order by convert(char(7),MUSDATLOGIN,111) desc

select MUSIP,MUSNOM from TBS116 (nolock) where MUSIP Like('192.168.1.%') group by MUSIP,MUSNOM

select convert(char(7),MUSDATLOGIN,111) as 'AnoMes',
       MUSIP as 'IP',
       count(*) as 'contador'
  from TBS116 (nolock)
 where MUSIP Like('192.168.1.%')
 group by convert(char(7),MUSDATLOGIN,111),MUSIP
 order by convert(char(7),MUSDATLOGIN,111) desc
--compute count(convert(char(7),MUSDATLOGIN,111)) by convert(char(7),MUSDATLOGIN,111)

drop table #CONTAIP


select convert(char(7),MUSDATLOGIN,111) as 'AnoMes',
       MUSIP as 'IP'
       into #CONTAIP
  from TBS116 (nolock)
 where MUSIP Like('192.168.1.%')
 group by convert(char(7),MUSDATLOGIN,111),MUSIP
 order by convert(char(7),MUSDATLOGIN,111) desc

select convert(char(7),MUSDATLOGIN,111) as 'AnoMes',count(*)
  from TBS116 (nolock)
 where MUSIP Like('192.168.1.%')
 group by convert(char(7),MUSDATLOGIN,111),subString(MUSIP,1,10)
 order by convert(char(7),MUSDATLOGIN,111) desc

select AnoMes,count(*) from #CONTAIP group by AnoMes


-- notas fiscais eletrônicas

select convert(char(7),
       ENFDATEMI,111),
       ENFSIT,
       case
          when ENFSIT in(1,2,3,4,5,9,10,12,20) then 'NAO AUTORIZADA'
          when ENFSIT=6 then 'AUTORIZADA'
          when ENFSIT=7 then 'CANCELADA'
          when ENFSIT=8 then 'DENEGADA'
          when ENFSIT=11 then 'INUTILIZADA'
          when ENFSIT=13 then 'CONTINGENCIA'
       end,
       count(*),
       sum(ENFVALTOT)
  from TBS080 (nolock)
 group by convert(char(7),ENFDATEMI,111),ENFSIT
 order by convert(char(7),ENFDATEMI,111) desc,ENFSIT

select distinct ENFSIT from TBS080 (nolock)

select distinct ENFSIT from TBS080 (nolock) where ENFDATEMI between '20150701' and '20150731'



------------------------------------

select top 100 * from TBS116 (nolock) where MUSHOST<>''

select MUSHOST from TBS116 (nolock)
 where MUSHOST<>'' and MUSDATLOGIN between '20160901' and '20160930' and MUSIP Like('%168.1.%')
 group by MUSHOST

select * from TBS116 (nolock)
 where MUSHOST<>'' and MUSDATLOGIN between '20160901' and '20160930' and MUSIP Like('%168.1.%') and MUSHOST Like('JARVE%')

select * from TBS116 (nolock)
 where MUSHOST<>'' and MUSDATLOGIN between '20160901' and '20160930' and MUSIP Like('%168.1.%')


