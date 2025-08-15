select '2022' as ANO
       ,'12' as MES
	   ,CODIGO as COD_ITEM
	   ,(select PRODES from TBS010 where TBS010.PROCOD=CODIGO) as DESCR_ITEM
	   ,isnull((select PROCLAFIS from TBS010 where TBS010.PROCOD=CODIGO),'') as COD_NCM
	   ,case when E1 > 0 then E1 else 0 end + case when E2 > 0 then E2 else 0 end as QTDE
	   ,(select PROUM1 from TBS010 where TBS010.PROCOD=CODIGO) as UNID_INV
	   ,round(CUSTO,2) as VL_UNIT
     ,(select PROSTBA+PROSTBB from TBS010 where TBS010.PROCOD=CODIGO) as CST_ICMS
     ,'' as CSOSN_ICMS
     ,0 BC_ICMS
	   --,(select iif(PROICMSINT > 0, PROICMSINT, 18) from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_ICMS
	   ,(select case when PROICMSINT > 0 then PROICMSINT else 18 end from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_ICMS
	   ,0 as VL_ICMS
	   --,(select iif(PROPIS='', 1.65,0) from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_PIS
	   ,(select case when PROPIS='' then 1.65 else 0 end from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_PIS
	   ,0 as VL_PIS
	   --,(select iif(PROCOFINS='', 1.65,0) from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_COFINS
	   ,(select case when PROCOFINS='' then 7.60 else 0 end from TBS010 where TBS010.PROCOD=CODIGO) as ALIQ_COFINS
	   ,0 as VL_COFINS
	   ,0 as VL_ITEM_IR
     ,0 as IVA_ST
     ,0 as BC_ICMS_ST
     ,0 as ICMS_ST
     ,0 as ALIQ_FCP
     ,0 as FCP_ST
	   ,1 as IND_PROP
       ,(select 'S'+EMPCGC from TBS023 with (nolock) where EMPCOD=(case when Left(EMPNOM,8)='BEST BAG' then 2 else 1 end)) as CNPJ
       ,'SP' as UF
	   ,'1' as GRUPO
  from SALDOINICIAL with (nolock)
 where ANOMES='202212'
	     and (E1 > 0 or E2 > 0)
       and CUSTO > 0
 order by CODIGO
