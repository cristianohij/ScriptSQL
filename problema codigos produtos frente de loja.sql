select * from TBS010 where PROCOD Like('%041408%')

select * from SB1010 A
 where D_E_L_E_T_='' and (select count(*) from SB1010 B where D_E_L_E_T_='' and B.B1_COD=A.B1_COD)>1
 order by B1_COD

select * from TBS010 A 
 where (select count(*) from TBS010 B where convert(int,B.PROCOD)=convert(int,rtrim(A.PROCOD)+'2'))>1

select top 10 convert(int,PROCOD) from TBS010