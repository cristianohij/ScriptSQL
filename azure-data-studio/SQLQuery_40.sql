-- GARE

select NFEPERICMSST, NFEPERICMS, NFEGAREICMSINT, NFEGAREICMSST, NFEBASICMS, NFEGARENCMMVA, *
  from TBS0591 with (nolock)
 where NFENUM=33
       and NFECOD=3624

begin tran
update TBS0591
   set NFEPERICMS=12
       ,NFEPERICMSST=12
	 ,NFEGAREICMSINT=18
	 ,NFEGAREICMSST=12
	 ,NFEBASICMS=3650
	 ,NFEGARENCMMVA=40.71
 where NFENUM=33
       and NFECOD=3624
   
rollback tran
commit tran

-- contagem

select convert(char(6), NFEDATEFE, 112) as 'ano_mes'
       ,count(*) as 'contagem'
  from TBS059 with (nolock)
 where NFEDATEFE between '20220101' and '20230731'
       and NFECAN='N'
       and NFEGARE='S'
 group by convert(char(6), NFEDATEFE, 112)
 order by convert(char(6), NFEDATEFE, 112) desc