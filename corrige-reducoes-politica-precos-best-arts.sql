select top 1 * from TBS015 (nolock) 

update TBS015
   set PRPREDCOR1=0,
       PDPREDCOR2=0,
       PDPREDCOR3=0,
       PDPREDCOR4=0,
       PRPREDLOJ1=0,
       PDPREDLOJ2=0,
       PDPREDLOJ3=0,
       PDPREDLOJ4=0,
       PRPREDREV1=0,
       PDPREDREV2=0,
       PDPREDREV3=0,
       PDPREDREV4=0,
       PRPREDWE11=0,
       PDPREDWE12=0,
       PDPREDWE13=0,
       PDPREDWE14=0,
       PRPREDWE21=0,
       PDPREDWE22=0,
       PDPREDWE23=0,
       PDPREDWE24=0
 where PDPCOD between '880' and '880Z'