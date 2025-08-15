select count(*)
  from TBS0371 with (nolock)

select *
  from TBS010 with (nolock)
 where PROCOD in('1080067','1640054')

select *
  from TBS133 with (nolock)
 where CFCID=14180

select cab.*
       ,det.*
  from TBS1331 det with (nolock)
  inner join TBS133 cab with (nolock)
 on cab.CFCID=14180
       and det.CFCNFEEMPCOD=cab.CFCNFEEMPCOD
       and det.CFCNFETIP=cab.CFCNFETIP
	   and det.CFCNFENUM=cab.CFCNFENUM
	   and det.CFCSERCOD=cab.CFCSERCOD
	   and det.CFCNFECOD=cab.CFCNFECOD
 where cab.CFCID=14180

select *
  from TBS1331 with (nolock)
 where CFCPROUM1QTD > 1

select *
  from TBS1332 with (nolock)

CREATE TABLE [TBS1332] (
  [CFCNFEEMPCOD] SMALLINT     NOT NULL,
  [CFCNFETIP]    CHAR(1)     NOT NULL,
  [CFCNFENUM]    DECIMAL(10)     NOT NULL,
  [CFCSERCOD]    CHAR(3)     NOT NULL,
  [CFCNFECOD]    INT     NOT NULL,
  [CFCLOGAPPITE] SMALLINT     NOT NULL,
  [CFCLOGAPPDES] VARCHAR(60)     NULL,
      PRIMARY KEY ( [CFCNFEEMPCOD],[CFCNFETIP],[CFCNFENUM],[CFCSERCOD],[CFCNFECOD],[CFCLOGAPPITE] ))
	  
ALTER TABLE [TBS133]
ADD [CFCULTITELOG] SMALLINT     NULL


ALTER TABLE [TBS1332]
ADD [CFCLOGAPPHOT] CHAR(8)     NULL,
    [CFCLOGAPPDAT] DATETIME     NULL

exec sp_rename 'TBS1332.CFCLOGAPPHOT', 'CFCLOGAPPHOR', 'COLUMN'

ALTER TABLE [TBS1332]
ADD [CFCLOGAPPHOS] VARCHAR(30)     NULL,
    [CFCLOGAPPIP] VARCHAR(15)     NULL,
    [CFCLOGAPPOPE] CHAR(25)     NULL

select *
  from TBS134 with (nolock)

delete TBS134
 where LCKID=14180

select *
  from TBS010 with (nolock)
 where PROCOD='0018717'