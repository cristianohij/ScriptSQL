select top 10 M2_PRECUS from MSL002 (nolock)

select top 500 MSL002.M2_PROCOD,avg(MSL002.M2_VALUNI),avg(TBS0671.NFSPRECUS/TBS0671.NFSQTDEMB)
  from MSL002 (nolock) join TBS0671 (nolock) on MSL002.M2_PROCOD = TBS0671.PROCOD
                       join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
 where MSL002.M2_DAT between '20121001' and '20121031' and TBS067.NFSDATEMI = MSL002.M2_DAT
 group by M2_PROCOD

select M2_PROCOD,M2_VALUNI,
       (select avg(TBS0671.NFSPRECUS/case TBS0671.NFSQTDEMB when 0 then 1 else TBS0671.NFSQTDEMB end)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI = MSL002.M2_DAT and TBS0671.PROCOD = MSL002.M2_PROCOD)
  from MSL002 (nolock)
 where MSL002.M2_DAT between '20121001' and '20121031' and (MSL002.M2_PRECUS = 0 or MSL002.M2_PRECUS is null)

update MSL002 set M2_PRECUS = (select avg(TBS0671.NFSPRECUS/case TBS0671.NFSQTDEMB when 0 then 1 else TBS0671.NFSQTDEMB end)
                                 from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                                where TBS067.NFSDATEMI = MSL002.M2_DAT and TBS0671.PROCOD = MSL002.M2_PROCOD)
  from MSL002 (nolock)
 where MSL002.M2_DAT between '20121001' and '20130131' and (MSL002.M2_PRECUS = 0 or MSL002.M2_PRECUS is null)

select count(*)
  from MSL002 (nolock) where MSL002.M2_DAT between '20121001' and '20130131' and (MSL002.M2_PRECUS = 0 or MSL002.M2_PRECUS is null) group by M2_PROCOD

select M2_PROCOD,M2_VALUNI,
       (select isnull(avg(TBS0671.NFSPRECUS/case TBS0671.NFSQTDEMB when 0 then 1 else TBS0671.NFSQTDEMB end),0)
          from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
         where TBS067.NFSDATEMI between '20121001' and '20121031' and TBS0671.PROCOD = MSL002.M2_PROCOD)
  from MSL002 (nolock)
 where MSL002.M2_DAT between '20121001' and '20121031' and (MSL002.M2_PRECUS = 0 or MSL002.M2_PRECUS is null)

update MSL002 set M2_PRECUS = (select avg(TBS0671.NFSPRECUS/case TBS0671.NFSQTDEMB when 0 then 1 else TBS0671.NFSQTDEMB end)
                                 from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
                                where TBS067.NFSDATEMI between '20121001' and '20130131' and TBS0671.PROCOD = MSL002.M2_PROCOD)
  from MSL002 (nolock)
 where MSL002.M2_DAT between '20121001' and '20130131' and (MSL002.M2_PRECUS = 0 or MSL002.M2_PRECUS is null)

update MSL002 set M2_PRECUS = (select isnull(TDPCUSBAS,0) from TBS031 (nolock) where TDPPROCOD = M2_PROCOD)
  from MSL002 (nolock)
 where MSL002.M2_DAT between '20121001' and '20130131' and (MSL002.M2_PRECUS = 0 or MSL002.M2_PRECUS is null)
