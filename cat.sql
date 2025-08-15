select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from cat.txt')

select * from TANBYTTE.SIBD.dbo.TBS001

-- 1923
select count(*) from TANBYTTE.SIBD.dbo.TBS010
 where exists(select '' from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from cat.txt')
               where subString(linha,1,14)=PROCOD)

select count(*) from TANBYTTE.SIBD.dbo.TBS010
 where not exists(select '' from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from cat.txt')
               where subString(linha,1,14)=PROCOD)

select subString(linha,1,14) as 'codigo',subString(linha,15,24) as 'descricao' into #PROGZ from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from cat.txt')

select *,(select PROCOD from TANBYTTE.SIBD.dbo.TBS010 where PROCOD=#PROGZ.codigo) from #PROGZ

drop table #PROGZ

select *,
       isnull(case Len(codigo)
          when 7 then (select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCOD=#PROGZ.codigo)
          when 8 then (select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCOD=subString(#PROGZ.codigo,1,7))
          else (select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCODBAR1=#PROGZ.codigo) end,



'vazio') as 'descIntegros'
  from #PROGZ

select *,
       isnull((select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCOD=#PROGZ.codigo),
       isnull((select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCOD=subString(#PROGZ.codigo,1,7)),
       isnull((select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCODBAR1=#PROGZ.codigo),
       isnull((select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCODBAR2=#PROGZ.codigo),
       isnull((select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCODBAR3=#PROGZ.codigo),
       isnull((select rtrim(PROCOD)+' '+PRODES from TANBYTTE.SIBD.dbo.TBS010 where PROCODBAR4=#PROGZ.codigo),''))))))
       as 'descIntegros'
  from #PROGZ
