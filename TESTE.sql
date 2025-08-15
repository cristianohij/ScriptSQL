--select * from TBS010 where Len(Ltrim(PROCOD)) > 8

--select Left(PROCOD,1) from TBS010 where MARCOD=100

--update TBS010 where 

select * from TBS010 where Len(Ltrim(PROCOD)) = 9 and Left(PROCOD,1) <> '1'

select * from TBS010 where Len(Ltrim(PROCOD)) = 8 and Left(PROCOD,1) = '1'

begin tran
update TBS010 set PROCOD=subString(PROCOD,2,8) where Len(Ltrim(PROCOD)) > 8 
commit tran

begin tran
   update TBS010 set PROCOD=subString(PROCOD,2,7) where Len(Ltrim(PROCOD)) = 8 and Left(PROCOD,1) <> '1'
commit tran

begin tran
   update TBS015 set PDPCOD=subString(PDPCOD,2,8) where Len(Ltrim(PDPCOD)) = 9
commit tran

begin tran
   update TBS010 set PROCOD=subString(PROCOD,2,7) where Len(Ltrim(PROCOD)) = 8 and Left(PROCOD,1) <> '1'
commit tran


select * from TBS013  where Len(Ltrim(PROCOD)) = 8
select * from TBS0131 where Len(Ltrim(PROCOD)) = 8
select * from TBS0261 where Len(Ltrim(PROCOD)) = 8
select * from TBS030  where Len(Ltrim(PROCOD)) = 8
select * from TBS0371 where Len(Ltrim(PROCOD)) = 8	-- 205 linhas
select * from TBS0431 where Len(Ltrim(PROCOD)) = 8	-- 631 linhas
select * from TBS049  where Len(Ltrim(PROCOD)) = 8	--  17 linhas
select * from TBS051  where Len(Ltrim(PROCOD)) = 8
select * from TBS0521 where Len(Ltrim(PROCOD)) = 8
select * from TBS0551 where Len(Ltrim(PROCOD)) = 8
select * from TBS058  where Len(Ltrim(PROCOD)) = 8
select * from TBS0591 where Len(Ltrim(PROCOD)) = 8
select * from TBS0671 where Len(Ltrim(PROCOD)) = 8
select * from TBS069  where Len(Ltrim(PROCOD)) = 8

begin tran
   update TBS0431 set PROCOD=subString(PROCOD,2,10) where Len(Ltrim(PROCOD)) = 8
commit tran
