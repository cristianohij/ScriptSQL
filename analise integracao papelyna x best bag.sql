declare c cursor for
 select col.name
   from sysobjects obj join syscolumns col on col.id = obj.id
                       join systypes typ on typ.xtype = col.xtype
  where obj.name = 'TBS010' and
        col.name not in('PROCOD','PRODES','PROPRICOM','PROPCPVAL','PROPCPNFE','PROPCPFOR','PROPCPSER','PROUCPDAT','PROUCPVAL','PROUCPNFE','PROUCPFOR','PROUCPSER',
                        'PROMCPDAT','PROMCPVAL','PROMCPNFE','PROMCPFOR','PROMCPSER','PROPRIVEN','PROPVDVAL','PROPVDNFS','PROUVDDAT','PROUVDVAL','PROUVDNFS',
                        'PROMVDDAT','PROMVDVAL','PROMVDNFS','PROLOCFIS','PROLOCFIS2','PROLOCFIS3','PROLOCFIS4','PROPESLIQ','PROPESBRU','PROSAICOD','PROENTCOD',
                        'PROICMSENT','PROPBIENT','PROCSN','PROCSNENT','PROIPI','PROWEB','PROSTATUS','PRODESWEB','FORCOD','FORNOM','MARCOD','MARNOM','FABCOD',
                        'PROREFFOR','GRUCOD','SUBGRUCOD','PROCALPOP','PROCTRLOT','PROGERPEN','PROINTBAL','PROCODBAL','PRODATCAD','PRODATVAL','PROCODTMP',
                        'PRODESTMP','PROGEN','PROSTBENTA','PROSTBENTB','PROISS')
  order by col.name

declare @com char(5000) ,@campos varchar(5000) ,@fil varchar(5000)

set @com = ' from TBS010 BES (nolock) join PAPELYNA.SIBD.dbo.TBS010 PAP on BES.PROCOD=PAP.PROCOD and BES.PRODES=PAP.PRODES'

set @fil = ' where '
set @campos = 'BES.PROCOD,PAP.PROCOD,BES.PRODES,PAP.PRODES,'

open c

declare @att char(20)

fetch next from c into @att

while @@fetch_status = 0
   begin
      set @campos = rtrim(@campos) + 'BES.' + rtrim(@att) + ',' + 'PAP.' + rtrim(@att) + ','
      set @fil = rtrim(@fil) + ' BES.' + rtrim(@att) + '<>PAP.' + rtrim(@att) + ' or '

      fetch next from c into @att
   end

set @com = 'select ' + rtrim(@campos) + rtrim(@com) + rtrim(@fil)

print @com

close c
deallocate c




declare c cursor for
select col.name
  from TBS010 BES (nolock) join PAPELYNA.SIBD.dbo.TBS010 PAP on BES.PROCOD=PAP.PROCOD
 where BES.PRODES=PAP.PRODES


-- cria link para planilha do excel
sp_addlinkedserver excel,'Jet 4.0','Microsoft.Jet.OLEDB.4.0','c:\temp\relat.xls',null,'Excel 5.0'
sp_addlinkedsrvlogin excel,false,sa,null

-- insere dados na planilha do excel
insert excel...dados$ select BES.PROCOD,PAP.PROCOD,BES.FABEMPCOD,PAP.FABEMPCOD,BES.FOREMPCOD,PAP.FOREMPCOD,BES.GRUEMPCOD,PAP.GRUEMPCOD,BES.MAREMPCOD,PAP.MAREMPCOD,BES.PROCLAFIS,PAP.PROCLAFIS,BES.PROCODBAR1,PAP.PROCODBAR1,BES.PROCODBAR2,PAP.PROCODBAR2,BES.PROCODBAR3,PAP.PROCODBAR3,BES.PROCODBAR4,PAP.PROCODBAR4,BES.PROCODNCM,PAP.PROCODNCM,BES.PRODES,PAP.PRODES,BES.PRODESDET,PAP.PRODESDET,BES.PROEMPCOD,PAP.PROEMPCOD,BES.PROEMPUM,PAP.PROEMPUM,BES.PROENTEMP,PAP.PROENTEMP,BES.PROICMSSAI,PAP.PROICMSSAI,BES.PROPBISAI,PAP.PROPBISAI,BES.PROSAIEMP,PAP.PROSAIEMP,BES.PROSTBA,PAP.PROSTBA,BES.PROSTBB,PAP.PROSTBB,BES.PROUM1,PAP.PROUM1,BES.PROUM1QTD,PAP.PROUM1QTD,BES.PROUM2,PAP.PROUM2,BES.PROUM2QTD,PAP.PROUM2QTD,BES.PROUM3,PAP.PROUM3,BES.PROUM3QTD,PAP.PROUM3QTD,BES.PROUM4,PAP.PROUM4,BES.PROUM4QTD,PAP.PROUM4QTD,BES.PROUMV,PAP.PROUMV from TBS010 BES (nolock) join PAPELYNA.SIBD.dbo.TBS010 PAP on BES.PROCOD=PAP.PROCOD where BES.FABEMPCOD<>PAP.FABEMPCOD or BES.FOREMPCOD<>PAP.FOREMPCOD or BES.GRUEMPCOD<>PAP.GRUEMPCOD or BES.MAREMPCOD<>PAP.MAREMPCOD or BES.PROCLAFIS<>PAP.PROCLAFIS or BES.PROCODBAR1<>PAP.PROCODBAR1 or BES.PROCODBAR2<>PAP.PROCODBAR2 or BES.PROCODBAR3<>PAP.PROCODBAR3 or BES.PROCODBAR4<>PAP.PROCODBAR4 or BES.PROCODNCM<>PAP.PROCODNCM or BES.PRODES<>PAP.PRODES or BES.PRODESDET<>PAP.PRODESDET or BES.PROEMPCOD<>PAP.PROEMPCOD or BES.PROEMPUM<>PAP.PROEMPUM or BES.PROENTEMP<>PAP.PROENTEMP or BES.PROICMSSAI<>PAP.PROICMSSAI or BES.PROPBISAI<>PAP.PROPBISAI or BES.PROSAIEMP<>PAP.PROSAIEMP or BES.PROSTBA<>PAP.PROSTBA or BES.PROSTBB<>PAP.PROSTBB or BES.PROUM1<>PAP.PROUM1 or BES.PROUM1QTD<>PAP.PROUM1QTD or BES.PROUM2<>PAP.PROUM2 or BES.PROUM2QTD<>PAP.PROUM2QTD or BES.PROUM3<>PAP.PROUM3 or BES.PROUM3QTD<>PAP.PROUM3QTD or BES.PROUM4<>PAP.PROUM4 or BES.PROUM4QTD<>PAP.PROUM4QTD or BES.PROUMV<>PAP.PROUMV

sp_addlinkedsrvlogin 'relExcel','false','sa','',null

--Create a linked server.
EXEC sp_addlinkedserver txtsrv, 'Jet 4.0', 
   'Microsoft.Jet.OLEDB.4.0',
   'c:\temp',
   NULL,
   'Text';
GO

--Set up login mappings.
EXEC sp_addlinkedsrvlogin txtsrv, FALSE, sa, NULL;
GO


------------------

-- produtos best que nao tem relacao nenhuma com produtos papelyna
select PROCOD,PRODES
  from TBS010 BES (nolock)
 where PROCODBAR1<>'' and not exists(select '' from PAPELYNA.SIBD.dbo.TBS010 PAP
                                      where BES.PROCOD=PAP.PROCOD or BES.PRODES=PAP.PRODES or BES.PROCODBAR1=PAP.PROCODBAR1)
-- 7792 registros

-- produtos best que nao tem codigos nem descricoes iguais aos produtos papelyna, mas tem o mesmo codigo de barras
select PROCOD,PRODES
  from TBS010 BES (nolock)
 where PROCODBAR1<>'' and exists(select '' from PAPELYNA.SIBD.dbo.TBS010 PAP
                                  where BES.PROCOD<>PAP.PROCOD and BES.PRODES<>PAP.PRODES and BES.PROCODBAR1=PAP.PROCODBAR1)

select BES.PROCOD,PAP.PROCOD,BES.PRODES,PAP.PRODES,BES.PROCODBAR1,PAP.PROCODBAR1
  from TBS010 BES (nolock) ,PAPELYNA.SIBD.dbo.TBS010 PAP
 where BES.PROCODBAR1<>'' and BES.PROCOD<>PAP.PROCOD and BES.PRODES<>PAP.PRODES and BES.PROCODBAR1=PAP.PROCODBAR1

-- 3332 registros


select BES.PROCOD,PAP.PROCOD,BES.PRODES,PAP.PRODES,BES.PROCODBAR1,PAP.PROCODBAR1
  from TBS010 BES (nolock) join PAPELYNA.SIBD.dbo.TBS010 PAP on BES.PROCODBAR1=PAP.PROCODBAR1
 where BES.PROCODBAR1<>'' and BES.PROCOD<>PAP.PROCOD and BES.PRODES<>PAP.PRODES



select BES.PROCOD,PAP.PROCOD,BES.PRODES,PAP.PRODES from TBS010 BES (nolock) join PAPELYNA.SIBD.dbo.TBS010 PAP on BES.PRODES=PAP.PRODES
 where BES.PROCOD<>PAP.PROCOD


select BES.PROCOD,PAP.PROCOD,BES.PRODES,PAP.PRODES from TBS010 BES (nolock) join PAPELYNA.SIBD.dbo.TBS010 PAP on BES.PROCOD=PAP.PROCOD
 where BES.PRODES=PAP.PRODES


-- produtos best com codigos de barras duplicados
select PROCOD,PRODES,PROCODBAR1 from TBS010 A (nolock) where PROCODBAR1<>'' and (select count(*) from TBS010 B (nolock) where A.PROCODBAR1=B.PROCODBAR1) > 1
 order by PROCODBAR1

-- 978 registros

begin tran
update TBS010 set PROCODBAR1='' where PROCODBAR1 = '          78974'

begin tran
update TBS010 set PROCODBAR1='' where PROCODBAR1 in('N T COD','N T PROD')

commit tran

-- produtos papelyna com codigos de barras duplicados
select PROCOD,PRODES,PROCODBAR1 from PAPELYNA.SIBD.dbo.TBS010 A
 where PROCODBAR1<>'' and (select count(*) from PAPELYNA.SIBD.dbo.TBS010 B where A.PROCODBAR1=B.PROCODBAR1) > 1
 order by PROCODBAR1

-- 1880

begin tran
update TBS010 set PROCODBAR1='' where PROCODBAR1 = '          78935'

begin tran
update TBS010 set PROCODBAR1='7896326900239' where PROCODBAR1 in('A-6-1','A-6-2')

begin tran
update TBS010 set PROCODBAR1='' where PROCODBAR1 = '78963269'

begin tran
update TBS010 set PROCODBAR1='' where PROCODBAR1 in('N','N T PROD','n')

commit tran
rollback tran