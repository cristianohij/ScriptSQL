select * from TBS123 (nolock) where CESTNCM lIKE('83%')

update TBS123 set CESTNCM='' where CESTNCM is null

update TBS123 set CESTNCM=replace(CESTNCM,'.','')

select * from TBS123 (nolock) where CESTNCM Like('%,%') and CESTNCM not Like('Capítulos%')

update TBS123 set CESTNCM=replace(CESTNCM,',','') where CESTNCM Like('%,%') and CESTNCM not Like('Capítulos%')

update TBS123 set CESTDATCAD=convert(char(8),getdate(),112)

select convert(char(8),getdate(),112)

update TBS123 set CESTDES=upper(CESTDES)


select PROCOD,PROCLAFIS,PROSTBB from TBS010 (nolock) where PROCLAFIS<>'' and PROSTBB in('10','30','60','70','90')

select PROSTATUS,PROCOD,PRODES,PROCLAFIS,PROSTBB,CESTCOD,CESTNCM,CESTDES,CESTSEG
  from TBS010 (nolock)
       full join TBS123 (nolock)
          on CESTNCM Like(subString(PROCLAFIS,1,4)) or CESTNCM Like(subString(PROCLAFIS,1,5)) or CESTNCM Like(subString(PROCLAFIS,1,6)) or CESTNCM Like(subString(PROCLAFIS,1,7))
 where PROCLAFIS<>'' and PROSTBB in('10','30','60','70','90')

select * from master..sysservers

exec sp_addlinkedserver @server ='TANBYM',
                        @srvproduct ='SQLOLEDB',
                        @provider ='SQLOLEDB',
                        @datasrc ='192.168.1.205',
                        @location ='192.168.1.205',
                        @provstr =NULL,
                        @catalog =NULL

insert into TANBYM.SIBD.dbo.TBS123 select * from TBS123

---
select PROSTATUS,
       PROCOD,
       PRODES,
       PROCLAFIS,
       PROSTBB,
       isnull(CESTCOD,''),
       isnull(CESTNCM,''),
       case when CESTNCM Like('%'+subString(PROCLAFIS,1,4)+'%') then 1 else 0 end + -- 4 caracteres iguais valor 1
       case when CESTNCM Like('%'+subString(PROCLAFIS,1,5)+'%') then 1 else 0 end + -- 5 caracteres iguais valor 2
       case when CESTNCM Like('%'+subString(PROCLAFIS,1,6)+'%') then 1 else 0 end + -- 6 caracteres iguais valor 3
       case when CESTNCM Like('%'+subString(PROCLAFIS,1,7)+'%') then 1 else 0 end + -- 7 caracteres iguais valor 4
       case when CESTNCM Like('%'+PROCLAFIS+'%') then 1 else 0 end as igualdade,    -- 8 caracteres iguais valor 5
       isnull(CESTDES,''),
       isnull(CESTANEX,''),
       isnull(CESTSEG,'')
  from TBS010 (nolock)
       full join TBS123 (nolock)
          on CESTNCM Like(subString(PROCLAFIS,1,4)+'%') or CESTNCM Like(subString(PROCLAFIS,1,5)+'%') or CESTNCM Like(subString(PROCLAFIS,1,6)+'%') or
             CESTNCM Like(subString(PROCLAFIS,1,7)+'%') or CESTNCM Like(PROCLAFIS)
 where PROCLAFIS<>'' and
       PROSTBB in('10','30','60','70','90') --and
--       not exists(select '' from #anexo where anexo=CESTANEX not in('XII','XV','XVI','XVII','XX','XXI','XXV')
 order by PROCOD,PRODES,igualdade desc

select * from TBS010 (nolock) where Len(PROCOD) < 7

select * from TBS123 (nolock) where CESTNCM Like('42021%')

select * from TBS010 (nolock) where PRODATALT>='20160311' and PRODATALT <='20160312'

drop table #anexo

select CESTANEX as anexo,CESTSEG as segmento,count(*) as qtde into #anexo from TBS123 (nolock) group by CESTANEX,CESTSEG

select * from #anexo


select *
  --into #produtos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\cest.xlsx', 'select * from [dados$]') 
  
select * from TBS123 (nolock)  
  
select REPLACE(cest,'.','') as cest,item,REPLACE(ncm,'.','') as ncm,descricao,anexo,segmento
  into #cest
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\cest.xlsx', 'select * from [dados$]') 

delete TBS123

alter table TBS123 alter column CESTANEX smallint

insert into TBS123 select *,CONVERT(char(8),getdate(),112) from #cest

select CONVERT(char(8),getdate(),112)