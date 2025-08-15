--select * from SZZ010 where D_E_L_E_T_='' and 

--select ZZ_PYUM2,ZZ_PYCUSB2,ZZ_PYCUSTB,* from PHANTOM.DADOSAP5.dbo.SZZ010 where D_E_L_E_T_='' and ZZ_PYCUSB2>0

select * from TBS015 join PHANTOM.DADOSAP5.dbo.SZZ010 on PDPCOD=ZZ_PYCOD
 where PDPQTDEMB > 0 and D_E_L_E_T_='' and ZZ_PYCUSB2 = 0 


select PDPCOD as 'codigo SI',str(PDPPREUNI,12,2) as 'SI',str(ZZ_PYCUSTB,12,2) as 'AP5',ZZ_PYCOD as 'codigo AP5',
       cast(PDPDATATU as varchar(11)) as 'atualizacao SI'
  from TBS015 join PHANTOM.DADOSAP5.dbo.SZZ010 on PDPCOD=ZZ_PYCOD
 where str(PDPPREUNI,12,2) <> str(ZZ_PYCUSTB,12,2) and D_E_L_E_T_=''


and cast(PDPDATATU as varchar(11))>='May  7 2008'

select cast(PDPDATATU as varchar(11)) from TBS015

select PDPCOD,* from TBS015 join PHANTOM.DADOSAP5.dbo.SZZ010 on PDPCOD=ZZ_PYCOD
 where PDPUNI=ZZ_PYUM2 and ZZ_PYCUSB2 = 0 and PDPQTDEMB > 1 and D_E_L_E_T_=''