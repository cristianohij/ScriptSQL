;with
	log as (
select
	PROCOD, PROLOGID, LOGATT, LOGVALATU
from
	TBS010 a join TBS035 b on a.PROLOGID = b.LOGID
where
	(select count(*) from TBS010 b where a.PROLOGID = b.PROLOGID) > 1 and
	LOGATT <> ''),
	
	pivo as (
select
	PROCOD,
	PROLOGID,
	PROCSN,
	COMCOD,
	PROGERPEN,
	PROSTATUS,
	PROLOCFIS,
	FORCOD,
	PROWEB,
	PRODES,
	PROUM3QTD,
	PROCODBAR3,
	PROUM3,
	PROICMSINT,
	TGZCOD,
	PROCODBAR1,
	PROUM1QTD,
	PROUM2QTD,
	PROCODBAR2,
	PROUM1,
	PROUM2,
	PROUMV,
	PROSTBB,
	PROCEST,
	MARCOD,
	PRODESDET
from
	log a
		pivot (
			max(LOGVALATU) for LOGATT in (
	PROCSN,
	COMCOD,
	PROGERPEN,
	PROSTATUS,
	PROLOCFIS,
	FORCOD,
	PROWEB,
	PRODES,
	PROUM3QTD,
	PROCODBAR3,
	PROUM3,
	PROICMSINT,
	TGZCOD,
	PROCODBAR1,
	PROUM1QTD,
	PROUM2QTD,
	PROCODBAR2,
	PROUM1,
	PROUM2,
	PROUMV,
	PROSTBB,
	PROCEST,
	MARCOD,
	PRODESDET)) a),
	
	proce as (
		select 
			a.PROCOD,	
			a.PROLOGID,	
			isnull(a.PROCSN,'') PROCSN_LOG, case when isnull(a.PROCSN,'NULO') = 'NULO' then '' else b.PROCSN end PROCSN_TBS010,
			isnull(a.COMCOD,'') COMCOD_LOG, case when isnull(a.COMCOD,'NULO') = 'NULO' then '' else b.COMCOD end COMCOD_TBS010,
			isnull(a.PROGERPEN,'') PROGERPEN_LOG, case when isnull(a.PROGERPEN,'NULO') = 'NULO' then '' else b.PROGERPEN end PROGERPEN_TBS010,
			isnull(a.PROSTATUS,'') PROSTATUS_LOG, case when isnull(a.PROSTATUS,'NULO') = 'NULO' then '' else b.PROSTATUS end PROSTATUS_TBS010,
			isnull(a.PROLOCFIS,'') PROLOCFIS_LOG, case when isnull(a.PROLOCFIS,'NULO') = 'NULO' then '' else b.PROLOCFIS end PROLOCFIS_TBS010,
			isnull(a.FORCOD,'') FORCOD_LOG, case when isnull(a.FORCOD,'NULO') = 'NULO' then '' else b.FORCOD end FORCOD_TBS010,
			isnull(a.PROWEB,'') PROWEB_LOG, case when isnull(a.PROWEB,'NULO') = 'NULO' then '' else b.PROWEB end PROWEB_TBS010,
			isnull(a.PRODES,'') PRODES_LOG, case when isnull(a.PRODES,'NULO') = 'NULO' then '' else b.PRODES end PRODES_TBS010,
			isnull(a.PROUM3QTD,'') PROUM3QTD_LOG, case when isnull(a.PROUM3QTD,'NULO') = 'NULO' then '' else b.PROUM3QTD end PROUM3QTD_TBS010,
			isnull(a.PROCODBAR3,'') PROCODBAR3_LOG, case when isnull(a.PROCODBAR3,'NULO') = 'NULO' then '' else b.PROCODBAR3 end PROCODBAR3_TBS010,
			isnull(a.PROUM3,'') PROUM3_LOG, case when isnull(a.PROUM3,'NULO') = 'NULO' then '' else b.PROUM3 end PROUM3_TBS010,
			isnull(a.PROICMSINT,'') PROICMSINT_LOG, case when isnull(a.PROICMSINT,'NULO') = 'NULO' then '' else b.PROICMSINT end PROICMSINT_TBS010,
			isnull(a.TGZCOD,'') TGZCOD_LOG, case when isnull(a.TGZCOD,'NULO') = 'NULO' then '' else b.TGZCOD end TGZCOD_TBS010,
			isnull(a.PROCODBAR1,'') PROCODBAR1_LOG, case when isnull(a.PROCODBAR1,'NULO') = 'NULO' then '' else b.PROCODBAR1 end PROCODBAR1_TBS010,
			isnull(a.PROUM1QTD,'') PROUM1QTD_LOG, case when isnull(a.PROUM1QTD,'NULO') = 'NULO' then '' else b.PROUM1QTD end PROUM1QTD_TBS010,
			isnull(a.PROUM2QTD,'') PROUM2QTD_LOG, case when isnull(a.PROUM2QTD,'NULO') = 'NULO' then '' else b.PROUM2QTD end PROUM2QTD_TBS010,
			isnull(a.PROCODBAR2,'') PROCODBAR2_LOG, case when isnull(a.PROCODBAR2,'NULO') = 'NULO' then '' else b.PROCODBAR2 end PROCODBAR2_TBS010,
			isnull(a.PROUM1,'') PROUM1_LOG, case when isnull(a.PROUM1,'NULO') = 'NULO' then '' else b.PROUM1 end PROUM1_TBS010,
			isnull(a.PROUM2,'') PROUM2_LOG, case when isnull(a.PROUM2,'NULO') = 'NULO' then '' else b.PROUM2 end PROUM2_TBS010,
			isnull(a.PROUMV,'') PROUMV_LOG, case when isnull(a.PROUMV,'NULO') = 'NULO' then '' else b.PROUMV end PROUMV_TBS010,
			isnull(a.PROSTBB,'') PROSTBB_LOG, case when isnull(a.PROSTBB,'NULO') = 'NULO' then '' else b.PROSTBB end PROSTBB_TBS010,
			isnull(a.PROCEST,'') PROCEST_LOG, case when isnull(a.PROCEST,'NULO') = 'NULO' then '' else b.PROCEST end PROCEST_TBS010,
			isnull(a.MARCOD,'') MARCOD_LOG, case when isnull(a.MARCOD,'NULO') = 'NULO' then '' else b.MARCOD end MARCOD_TBS010,
			isnull(a.PRODESDET,'') PRODESDET_LOG, case when isnull(a.PRODESDET,'NULO') = 'NULO' then '' else b.PRODESDET end PRODESDET_TBS010
		
		from
			pivo a join TBS010 b on a.PROCOD = b.PROCOD)

select * from proce where PROLOGID = '107125'