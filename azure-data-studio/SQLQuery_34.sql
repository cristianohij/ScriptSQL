select top(1000)
       *
  from TBS0371 i with (nolock)
       inner join TBS037 c with (nolock)
          on c.MVIDOC=i.MVIDOC
 where c.MVILOCORI = 0
       and c.MVIPDVNUM > 0
 order by c.MVIDATEFE desc

select c.MVIDATEFE
       ,count(i.MVIITE)
  from TBS0371 i with (nolock)
       inner join TBS037 c with (nolock)
          on c.MVIDOC=i.MVIDOC
 where c.MVILOCORI = 0
       and c.MVIPDVNUM > 0
 group by c.MVIDATEFE
 order by c.MVIDATEFE desc

select convert(char(6), c.MVIDATEFE, 112) as 'data'
       ,count(i.MVIITE) as 'qtde produtos'
  from TBS0371 i with (nolock)
       inner join TBS037 c with (nolock)
          on c.MVIDOC=i.MVIDOC
 where c.MVILOCORI = 0
       and c.MVIPDVNUM > 0
 group by convert(char(6), c.MVIDATEFE, 112)
 order by convert(char(6), c.MVIDATEFE, 112) desc



