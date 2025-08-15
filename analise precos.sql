   -- preco na menor unidade
   select PDPCOD,PDPPREFOR,ZZ_PYCOD,ZZ_PYCUSTB from TBS015,PHANTOM.DADOSAP5.dbo.SZZ010
    where D_E_L_E_T_='' and ZZ_PYCOD=PDPCOD and ZZ_PYCUSB2=0 and cast(ZZ_PYCUSTB as float)<>cast(PDPPREFOR as float)

   -- preco na segunda unidade de medida
   select PDPCOD,PDPPREFOR,ZZ_PYCOD,ZZ_PYCUSB2 from TBS015,PHANTOM.DADOSAP5.dbo.SZZ010
    where D_E_L_E_T_='' and ZZ_PYCOD=PDPCOD and ZZ_PYCUSB2>0 and cast(ZZ_PYCUSB2 as float)<>cast(PDPPREFOR as float)