select TBS067.NFSNUM,PROCOD,str((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD,10,2) as 'NFSTOTITE'
  from TBS0671 join TBS067 on TBS0671.NFSNUM = TBS067.NFSNUM
 where NFSTESCOM = 'S' and NFSPRECUS = 0 and NFSDATEMI between '2008-10-26' and '2008-11-24'
 order by TBS067.NFSNUM


select NFSNUM,PROCOD,str((NFSPRE-(NFSPRE*NFSPDDITE/100))*NFSQTD,10,2) as 'NFSTOTITE'
  from TBS0671
 where NFSTESCOM = 'S' and NFSPRECUS = 0



select PROCOD,PROICMSSAI,B1_COD,B1_PICM
  from TBS010 (noLock) join SERVIDORDADOS.DADOSADV_507.dbo.SB1010
                       on PROCOD collate database_default = B1_COD collate database_default
 where D_E_L_E_T_='' and PROICMSSAI <> B1_PICM and B1_PICM <> 18

update TBS010 set PROICMSSAI = B1_PICM
  from TBS010 (noLock) join SERVIDORDADOS.DADOSADV_507.dbo.SB1010
                       on PROCOD collate database_default = B1_COD collate database_default
 where D_E_L_E_T_='' and PROICMSSAI <> B1_PICM and B1_PICM <> 18

select PROCOD,PROICMSSAI,B1_COD,B1_PICM
  from TBS010 (noLock) join SERVIDORDADOS.DADOSADV_507.dbo.SB1010
                       on PROCOD collate database_default = B1_COD collate database_default
 where D_E_L_E_T_='' and PROICMSSAI > 0 and B1_PICM = 0

select PROCOD,PROSTBA,PROSTBB,B1_COD,B1_GRTRIB
  from TBS010 (noLock) join SERVIDORDADOS.DADOSADV_507.dbo.SB1010
                       on PROCOD collate database_default = B1_COD collate database_default
 where D_E_L_E_T_='' and PROSTBA+PROSTBB <> B1_GRTRIB collate database_default

select PROCOD,PROSTBA,PROSTBB from TBS010 (noLock) where PROSTBA = '' or PROSTBB = ''

update TBS010 set PROSTBA='0' where PROSTBA = ''

select PROCOD,PROSTBA,PROSTBB from TBS010 (noLock) where PROSTBB = ''

update TBS010 set PROSTBB='00' where PROSTBB = ''
