select M2_PROCOD,
       (select PRODES from TBS010 (nolock) where PROCOD=M2_PROCOD),
       (select PROSTBA+PROSTBB from TBS010 (nolock) where PROCOD=M2_PROCOD),
       (select descricao from tributacao (nolock) where codigo=(select TGZCOD from TBS010 (nolock) where PROCOD=M2_PROCOD)),
       (select aliquota from tributacao (nolock) where codigo=(select TGZCOD from TBS010 (nolock) where PROCOD=M2_PROCOD)),
       (select reducao from tributacao (nolock) where codigo=(select TGZCOD from TBS010 (nolock) where PROCOD=M2_PROCOD)),
       (select cst from tributacao (nolock) where codigo=(select TGZCOD from TBS010 (nolock) where PROCOD=M2_PROCOD)),
       (select PROCLAFIS from TBS010 (nolock) where PROCOD=M2_PROCOD),
       M2_BANNUM,
       M2_TRB,
       sum(M2_VALTOT)
  from MSL002 (nolock)
 where M2_DAT between '20151201' and '20151231' and
       M2_TIPREG='01' and
       M2_REGCAN='F' and
       M2_NUMECF=18
 group by M2_BANNUM,M2_TRB,M2_PROCOD

select 10 as codigo,
       'Tributado 12% Red 27' as descricao,
       12 as aliquota,
       27.50 as reducao,
       '20' as cst
  into tributacao

select * from tributacao 

insert into tributacao select 1,'Subs.Tributaria',0,0,'40'
insert into tributacao select 2,'Isento',0,0,'40'
insert into tributacao select 3,'Tributado 7%',7,0,'00'
insert into tributacao select 4,'Tributado 12%',12,0,'00'
insert into tributacao select 5,'Tributado 18%',18,0,'00'
insert into tributacao select 7,'Tributado 18% Red',18,61.11,'20'
insert into tributacao select 8,'Tributado 12% Red',12,41.67,'20'
insert into tributacao select 9,'Tributado 18% Red 12',18,33.33,'20'




--drop table tributacao


select *
  from MSL002 (nolock)
 where M2_DAT between '20151201' and '20151231' and
       M2_TIPREG='01' and
       M2_REGCAN='F' and
       M2_NUMECF=18

select TGZCOD,
       count(*),
       (select descricao from tributacao (nolock) where codigo=TGZCOD),
       (select aliquota from tributacao (nolock) where codigo=TGZCOD),
       (select reducao from tributacao (nolock) where codigo=TGZCOD),
       (select cst from tributacao (nolock) where codigo=TGZCOD)
 from TBS010 (nolock) group by TGZCOD
order by TGZCOD
