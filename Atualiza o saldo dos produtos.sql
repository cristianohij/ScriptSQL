select distinct B2_FILIAL from SERVIDORDADOS.DADOSADV.dbo.SB2010 where D_E_L_E_T_=''

select * from SERVIDORDADOS.DADOSADV.dbo.SB2010
 where D_E_L_E_T_='' and B2_FILIAL='01' and B2_LOCAL='01' and B2_COD Like('164%')

select * from TBS032 where PROCOD Like('0164%')

update TBS032 set ESTQTDATU=B2_QATU from SERVIDORDADOS.DADOSADV.dbo.SB2010
 where D_E_L_E_T_='' and B2_FILIAL='01' and B2_LOCAL='01' and B2_COD=PROCOD and ESTLOC=1


select * from TBS032