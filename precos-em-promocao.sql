select TDPPROCOR
       ,*
  from TBS031 with (nolock)
 where TDPPROCOD in('1640054','15100009')

select TDPPROCOR
       ,*
  from TBS031 with (nolock)
 where TDPPROCOD='15100009'
 
begin tran
update TBS031
   set TDPPROCOD='N'
       ,TDPPROLOJ='N'
	   ,TDPPROWE1='N'
	   ,TDPPROWE2='N'
	   ,TDPPROREV='N'
 where TDPPROCOD='15100009'
commit tran	   
rollback tran

select *
  from TBS010 with (nolock)
 where PROCOD='15100009'

select *
  from TBS032 with (nolock)
 where PROCOD='15100009'


DBCC CHECKTABLE ('TBS031')

select *
  from TBS031 with (nolock)
 where TDPVALPROI='17530101'
       and TDPVALPROF='17530101'
	   and (TDPPROCOR='S'
	        or TDPPROLOJ='S'
	        or TDPPROWE1='S'
	        or TDPPROWE2='S'
	        or TDPPROREV='S')

select *
  from TBS031 with (nolock)
 where TDPPROCOR not in('S','N')
	   or TDPPROLOJ not in('S','N')
	   or TDPPROWE1 not in('S','N')
	   or TDPPROWE2 not in('S','N')
	   or TDPPROREV not in('S','N')

select top 1
       *
  from TBS015 with (nolock)
  
begin tran
update TBS015
   set PDPPROCOR='S'
       ,PDPPROLOJ='S'
	   ,PDPPROWE1='S'
	   ,PDPPROWE2='S'
       ,PDPPROREV='S'
 where PDPCOD='15100009'
commit tran

select *
  from TBS015 with (nolock)
 where PDPVALPROI='17530101'
       and PDPVALPROF='17530101'
	   and (PDPPROCOR='S'
	        or PDPPROLOJ='S'
	        or PDPPROWE1='S'
	        or PDPPROWE2='S'
	        or PDPPROREV='S')

begin tran
update TBS015
   set PDPPROCOR='N'
	   ,PDPPROLOJ='N'
	   ,PDPPROWE1='N'
	   ,PDPPROWE2='N'
	   ,PDPPROREV='N'
 where PDPVALPROI='17530101'
       and PDPVALPROF='17530101'
	   and (PDPPROCOR='S'
	        or PDPPROLOJ='S'
	        or PDPPROWE1='S'
	        or PDPPROWE2='S'
	        or PDPPROREV='S')
commit tran

select *
  from TBS031 with (nolock)
 where TDPPROCOD='03241769'

begin tran
update TBS031
   set TDPPROCOR='N'
	   ,TDPPROLOJ='N'
	   ,TDPPROWE1='N'
	   ,TDPPROWE2='N'
	   ,TDPPROREV='N'
 where TDPVALPROI='17530101'
       and TDPVALPROF='17530101'
	   and (TDPPROCOR='S'
	        or TDPPROLOJ='S'
	        or TDPPROWE1='S'
	        or TDPPROWE2='S'
	        or TDPPROREV='S')
commit tran
rollback tran

select CFCID
       ,count(*)
  from TBS133 with (nolock)
 group by CFCID
 having count(*) > 1



