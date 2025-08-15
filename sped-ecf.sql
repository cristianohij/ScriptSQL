select concat(
          '0200','|',
          if(est.cdprod<=999999,lpad(trim((convert(est.cdprod,char(20)))),7,'0'),trim(convert(est.cdprod,char(20)))),'|',
          trim(descricao),'|'
       ) as campo,
       est.*
       
  from estoque as est where cdprod <= 999999 limit 100;
  
select * from movcaixa where data=datamovto limit 500;

select * from movcaixa as mov where status='01' and cancelado='' and data between '2016-10-01' and '2016-10-31' group by cdprod order by cdprod;

select * from estoque where cdprod=1640054;

select * from mapaecf where data between '2016-10-01' and '2016-10-31' group by serie,caixapdv;

select * from ecf order by serie,ecf;

select * from movcaixa where data between '2016-10-01' and '2016-10-31' and status='01' and cancelado='' and ecf=18 order by data,cdprod;

select mov.cdprod from movcaixa as mov where status='01' and cancelado='' and data between '2016-10-01' and '2016-10-31' and ecf=18 group by cdprod order by cdprod;

select * from movcaixa as mov where status='01' and cancelado='' and data between '2016-10-01' and '2016-10-31' and ecf=18 and cdprod=41092;

select * from ecf;

select * from mapaecf where data = '2016-10-01' and caixa in(17,18);

select * from mapaecf where data = '2016-10-01' and caixa in(17,18);

select * from movcaixa as mov where status='01' and cancelado='' and data between '2016-10-01' and '2016-10-31' and ecf=18 order by ecf,data;

select * from mapaecf where data = '2016-10-01' and serie='DR0913BR000000372757';

select * from movcaixa as mov where status='01' and cancelado='' and data between '2016-10-01' and '2016-10-31' and ecf=18 and (aliqcofins > 0 or aliqpis > 0) order by ecf,data;

select * from movcaixa as mov where status='01' and cancelado='' and data between '2016-11-01' and '2016-11-08' and ecf=18 and (aliqcofins > 0 or aliqpis > 0) order by ecf,data;

select * from estoque where cdprod=1900013;

select * from movcaixa as mov where status='01' and cancelado='' and data between '2016-10-01' and '2016-10-31' and ecf=18 and cdprod=10460022;

select * from movcaixa as mov where status='01' and cancelado='' and data = '2016-10-10' and ecf=18 and cdprod=1900013;

select * from estoque where cstpis<>'07';