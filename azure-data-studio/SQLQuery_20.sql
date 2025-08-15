select *
  from TBS059 with (nolock)
 where NFEGARE='S'
       and NFECAN='N'
	   and NFEDATEFE != '17530101'
	   and NFETIP='N'
 order by NFEDATEFE desc
 
select NFEITE
       ,NFENCMXML
       ,NFECESTXML
       ,NFEGARENCMMVA
       ,NFEGAREICMSST
	 ,NFEGAREICMSINT
       ,NFEGAREVALICMSST
       ,NFETOTOPEITE
       ,NFEDES
  from TBS0591 with (nolock)
 where NFENUM=33178
       and NFECOD=3318
       and NFETIP='N'
	 --and NFEGAREVALICMSST > 0
 order by NFEITE

select c.NFEGARE
       ,c.NFEDATEFE
       ,c.*
  from TBS059 c with (nolock)
 where NFEGARE='S'
       --NFEESTORI != 'SP'
       and NFECAN='N'
	 and NFEDATEFE between '20240101' and '20241022'
	 and NFETIP='N'
 order by c.NFEDATEFE desc
