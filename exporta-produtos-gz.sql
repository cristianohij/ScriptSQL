create table ##proECF (codigo varchar(20))

declare @comando as char(500)

set @comando = 'exec(''select Ltrim(cdprod) from movcaixa where data between ''''20180401'''' and ''''20180430'''' and status=''''01'''' and cancelado='''''''' group by cdprod'') at MYSQLGZ'

insert into ##proECF exec(@comando)

delete ##proECF

update ##proECF set codigo=right('0000000'+Ltrim(codigo),7) where Len(codigo) < 7

select * from ##proECF

select '|'+ltrim(rtrim(PROCOD))+'|,'+
       '|'+ltrim(rtrim(PROCOD))+'|,'+
       '|'+ltrim(rtrim(subString(replace(replace(PRODES,'"',''),',','.'),1,40)))+'|,'+
       case
          when PROCLAFIS = ''
             then '0,'
             else Ltrim(PROCLAFIS)+','
          end+
       case 
          when PROUM1 = ''
             then '|UN|,'
             else '|'+PROUM1+'|,'
          end+
       case
          when PROSTBB = '60' 
             then '0.00,' 
             else '18.00,'
          end+
       case 
          when PROSTBA<>'' and PROSTBB <>'' 
             then '|'+PROSTBA+PROSTBB+'|,'
             else '|000|,' 
          end+
       '0.00,'+
       case 
          when PROSTBB = '60'
             then '|S|,' 
             else '|N|,' 
          end+
       '0,'+
       '1.000,'+
       '||,'+
       '||,'+
       '00,'+
       '99,'+
       '01,'+
       '01,'+
       '0.0000,'+
       '0.0000,'+
       '0.0000,'+
       '|N|,'+
       '|N|,'+
       '|N|,'+
       '||,'+
       '||,'+
       '||,'+
       '||,'+
       '|N|,'+
       '0.0000'
  from TBS010 (nolock) inner join ##proECF on PROCOD=codigo collate database_default

 where isNumeric(PROCLAFIS) = 1 and Len(PROCLAFIS)=8 and isNumeric(PROCEST) = 1 and Len(PROCEST)=7
