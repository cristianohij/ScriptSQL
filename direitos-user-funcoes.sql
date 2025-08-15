where
                [FUNÇÃO] in (
select SPECIFIC_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_TYPE = 'FUNCTION'
)”

select ROUTINE_NAME
  from INFORMATION_SCHEMA.ROUTINES with (nolock)
 where ROUTINE_NAME='sp_ClientesGrupo'

select *
  from INFORMATION_SCHEMA.ROUTINES with (nolock)
 where ROUTINE_NAME Like('NFS%')

grant execute on NFEPRELIQ to [gelder]

select ROUTINE_NAME
  from INFORMATION_SCHEMA.ROUTINES with (nolock)
 where ROUTINE_NAME Like('NFE%')

select 'grant execute on ' + (select ROUTINE_NAME
                               from INFORMATION_SCHEMA.ROUTINES with (nolock)
                              where ROUTINE_NAME Like('NFS%'))
       + 'to [gelder]'

select 'grant execute on ' + ROUTINE_NAME + ' to [gelder]'
  from INFORMATION_SCHEMA.ROUTINES with (nolock)
 where ROUTINE_NAME Like('NFS%')


grant execute on sp_ClientesGrupo to [gelder]
grant execute on sp_movcaixa to [gelder]
grant execute on sp_movcaixagz to [gelder]


grant execute on NFECUSAQU to [gelder]
--grant execute on NFEPRELIQ to [gelder]
grant execute on NFETOTBCICMSSN to [gelder]
grant execute on NFETOTBCICMSSNSEMST to [gelder]
grant execute on NFETOTBICMS to [gelder]
grant execute on NFETOTBICMSSEMST to [gelder]
grant execute on NFETOTBICMSST to [gelder]
grant execute on NFETOTBRU to [gelder]
grant execute on NFETOTDES to [gelder]
grant execute on NFETOTFRE to [gelder]
grant execute on NFETOTITE to [gelder]
--grant execute on NFETOTITEBRU to [gelder]
grant execute on NFETOTLIQ to [gelder]
grant execute on NFETOTOPE to [gelder]
grant execute on NFETOTOUT to [gelder]
grant execute on NFETOTPAR to [gelder]
grant execute on NFETOTSEG to [gelder]
grant execute on NFETOTVCOFINS to [gelder]
grant execute on NFETOTVICMS to [gelder]
grant execute on NFETOTVICMSSEMST to [gelder]
grant execute on NFETOTVICMSSN to [gelder]
grant execute on NFETOTVICMSSNSEMST to [gelder]
grant execute on NFETOTVICMSST to [gelder]
grant execute on NFETOTVIPI to [gelder]
grant execute on NFETOTVPIS to [gelder]
grant execute on NFEVALCOFINSE to [gelder]
grant execute on NFEVALICMS to [gelder]
grant execute on NFEVALIPI to [gelder]
grant execute on NFEVALPISENT to [gelder]
grant execute on NFEVDDITE to [gelder]


grant execute on ORCBASICMS to [gelder]
grant execute on ORCBASICMSISE to [gelder]
grant execute on ORCBASICMSST to [gelder]
grant execute on ORCDESITEVAL to [gelder]
grant execute on ORCFREITEVAL to [gelder]
grant execute on ORCPRELIQ to [gelder]
grant execute on ORCSEGITEVAL to [gelder]
grant execute on ORCTOTBRU to [gelder]
grant execute on ORCTOTITE to [gelder]
grant execute on ORCTOTITEST to [gelder]
grant execute on ORCTOTLIQ to [gelder]
grant execute on ORCTOTPRO to [gelder]
grant execute on ORCVALAGR to [gelder]
grant execute on ORCVALCUS to [gelder]
grant execute on ORCVALICMS to [gelder]
grant execute on ORCVALICMSISE to [gelder]
grant execute on ORCVALICMSST to [gelder]
grant execute on ORCVALICMSSTRET to [gelder]
grant execute on ORCVDDITE to [gelder]
grant execute on ORCVDDTOT to [gelder]


grant execute on PDCPRELIQ to [gelder]
grant execute on PDCTOTBRU to [gelder]
grant execute on PDCTOTENT to [gelder]
grant execute on PDCTOTIPI to [gelder]
grant execute on PDCTOTITE to [gelder]
grant execute on PDCTOTLIQ to [gelder]
grant execute on PDCTOTPRO to [gelder]
grant execute on PDCTOTRES to [gelder]
grant execute on PDCTOTST to [gelder]
grant execute on PDCVALENT to [gelder]
grant execute on PDCVALFRE to [gelder]
grant execute on PDCVALIPI to [gelder]
grant execute on PDCVALOUT to [gelder]
grant execute on PDCVALRES to [gelder]
grant execute on PDCVALSEG to [gelder]
grant execute on PDCVALST to [gelder]
grant execute on PDCVDDITE to [gelder]
grant execute on PDCVDDTOT to [gelder]


grant execute on PDPCUSAQU to [gelder]
grant execute on PDPCUSBAS to [gelder]


grant execute on PDVBASICMS to [gelder]
grant execute on PDVBASICMSISE to [gelder]
grant execute on PDVBASICMSST to [gelder]
grant execute on PDVDESITEVAL to [gelder]
grant execute on PDVFREITEVAL to [gelder]
grant execute on PDVPRELIQ to [gelder]
grant execute on PDVQTDBLQ to [gelder]
grant execute on PDVQTDTOT to [gelder]
grant execute on PDVQTDTOTB to [gelder]
grant execute on PDVQTDTOTF to [gelder]
grant execute on PDVSEGITEVAL to [gelder]
grant execute on PDVTOTBAS to [gelder]
grant execute on PDVTOTBLQ to [gelder]
grant execute on PDVTOTBRU to [gelder]
grant execute on PDVTOTFAT to [gelder]
grant execute on PDVTOTICMS to [gelder]
grant execute on PDVTOTICMSISE to [gelder]
grant execute on PDVTOTITE to [gelder]
grant execute on PDVTOTITEST to [gelder]
grant execute on PDVTOTLIB to [gelder]
grant execute on PDVTOTLIQ to [gelder]
grant execute on PDVTOTPRO to [gelder]
grant execute on PDVVALAGR to [gelder]
grant execute on PDVVALBLQ to [gelder]
grant execute on PDVVALCUS to [gelder]
grant execute on PDVVALFAT to [gelder]
grant execute on PDVVALICMS to [gelder]
grant execute on PDVVALICMSISE to [gelder]
grant execute on PDVVALICMSST to [gelder]
grant execute on PDVVALICMSSTRET to [gelder]
grant execute on PDVVALLIB to [gelder]
grant execute on PDVVDDITE to [gelder]
grant execute on PDVVDDTOT to [gelder]


grant execute on NFSBASICMS to [gelder]
grant execute on NFSBASICMSISE to [gelder]
grant execute on NFSBASICMSST to [gelder]
grant execute on NFSDESITEVAL to [gelder]
grant execute on NFSFREITEVAL to [gelder]
grant execute on NFSPERLUC to [gelder]
grant execute on NFSPRELIQ to [gelder]
grant execute on NFSSEGITEVAL to [gelder]
grant execute on NFSTOTBAS to [gelder]
grant execute on NFSTOTBASICMSST to [gelder]
grant execute on NFSTOTBASSEMST to [gelder]
grant execute on NFSTOTBRU to [gelder]
grant execute on NFSTOTCOM to [gelder]
grant execute on NFSTOTDEV to [gelder]
grant execute on NFSTOTDEVMEN to [gelder]
grant execute on NFSTOTDPL to [gelder]
grant execute on NFSTOTICMS to [gelder]
grant execute on NFSTOTICMSISE to [gelder]
grant execute on NFSTOTICMSSEMST to [gelder]
grant execute on NFSTOTICMSST to [gelder]
grant execute on NFSTOTICMSSTRET to [gelder]
grant execute on NFSTOTITE to [gelder]
grant execute on NFSTOTITEST to [gelder]
grant execute on NFSTOTITESTSEMDES to [gelder]
grant execute on NFSTOTLIQ to [gelder]
grant execute on NFSTOTPRO to [gelder]
grant execute on NFSTOTVALDEV to [gelder]
grant execute on NFSVALAGR to [gelder]
grant execute on NFSVALCOM to [gelder]
grant execute on NFSVALDEV to [gelder]
grant execute on NFSVALDEVMEN to [gelder]
grant execute on NFSVALDPL to [gelder]
grant execute on NFSVALICMS to [gelder]
grant execute on NFSVALICMSISE to [gelder]
grant execute on NFSVALICMSST to [gelder]
grant execute on NFSVALICMSSTRET to [gelder]
grant execute on NFSVALICMSST_Antigo to [gelder]
grant execute on NFSVDDITE to [gelder]
grant execute on NFSVDDTOT to [gelder]
