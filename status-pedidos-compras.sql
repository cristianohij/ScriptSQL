select top(100) *
  from TBS045 c with (nolock)
  inner join TBS0451 d with (nolock)
  on d.PDCEMPCOD=c.PDCEMPCOD
     and d.PDCNUM=c.PDCNUM
 where c.PDCSIT<>0
       and d.PDCQTDENT + d.PDCQTDRES = 0

-- iif(PDCTOTQTD = 0 OR (PDCTOTQTD > 0 AND PDCTOTQTDENT + PDCTOTQTDRES = 0), 0, iif(PDCTOTQTD > PDCTOTQTDENT + PDCTOTQTDRES, 1, iif(PDCTOTQTD = PDCTOTQTDRES, 2, iif(PDCTOTQTD = PDCTOTQTDENT, 3, 4))))

-- em aberto

select *
  from TBS045 c with (nolock)
 where PDCSIT <> 0
       and (
             (select sum(PDCQTD)
              from TBS0451 d with (nolock) 
             where d.PDCEMPCOD=c.PDCEMPCOD
                   and d.PDCNUM=c.PDCNUM) = 0
             or
             (select sum(PDCQTDENT + PDCQTDRES)
                from TBS0451 d with (nolock) 
               where d.PDCEMPCOD=c.PDCEMPCOD
                     and d.PDCNUM=c.PDCNUM) = 0
           )

-- atendido parcialmente

select *
  from TBS045 c with (nolock)
 where PDCSIT <> 1
       and (select sum(PDCQTDENT + PDCQTDRES)
                from TBS0451 d with (nolock) 
               where d.PDCEMPCOD=c.PDCEMPCOD
                     and d.PDCNUM=c.PDCNUM) > 0
       and (select sum(PDCQTD) - sum(PDCQTDENT + PDCQTDRES)
                from TBS0451 d with (nolock) 
               where d.PDCEMPCOD=c.PDCEMPCOD
                     and d.PDCNUM=c.PDCNUM) > 0

begin tran
update TBS045
   set PDCSIT=1
 where PDCNUM in (select c.PDCNUM
                    from TBS045 c with (nolock)
                   where PDCSIT <> 1
                         and (select sum(PDCQTDENT + PDCQTDRES)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) > 0
                         and (select sum(PDCQTD) - sum(PDCQTDENT + PDCQTDRES)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) > 0)

rollback tran 
commit tran

-- pedido eliminado

select *
  from TBS045 c with (nolock)
 where PDCSIT <> 2
       and (select sum(PDCQTD)
                from TBS0451 d with (nolock) 
               where d.PDCEMPCOD=c.PDCEMPCOD
                     and d.PDCNUM=c.PDCNUM) > 0
       and (select sum(PDCQTD - PDCQTDRES)
              from TBS0451 d with (nolock) 
             where d.PDCEMPCOD=c.PDCEMPCOD
                   and d.PDCNUM=c.PDCNUM) = 0

begin tran
update TBS045
   set PDCSIT=2
 where PDCNUM in (select c.PDCNUM
                    from TBS045 c with (nolock)
                   where PDCSIT <> 2
                         and (select sum(PDCQTD)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) > 0
                         and (select sum(PDCQTD - PDCQTDRES)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) = 0)

rollback tran 
commit tran

-- totalmente atendidos

select *
  from TBS045 c with (nolock)
 where PDCSIT <> 3
       and (select sum(PDCQTD)
              from TBS0451 d with (nolock) 
              where d.PDCEMPCOD=c.PDCEMPCOD
                    and d.PDCNUM=c.PDCNUM) > 0
       and (select sum(PDCQTD - PDCQTDENT)
              from TBS0451 d with (nolock) 
             where d.PDCEMPCOD=c.PDCEMPCOD
                   and d.PDCNUM=c.PDCNUM) = 0

begin tran
update TBS045
   set PDCSIT=3
 where PDCNUM in (select c.PDCNUM
                    from TBS045 c with (nolock)
                   where PDCSIT <> 3
                         and (select sum(PDCQTD)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) > 0
                         and (select sum(PDCQTD - PDCQTDENT)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) = 0)

rollback tran 
commit tran 

-- atendido + resíduo eliminado

select *
  from TBS045 c with (nolock)
 where PDCSIT <> 4
       and (select sum(PDCQTD)
                from TBS0451 d with (nolock) 
               where d.PDCEMPCOD=c.PDCEMPCOD
                     and d.PDCNUM=c.PDCNUM) > 0
       and (select sum(PDCQTDENT)
              from TBS0451 d with (nolock) 
             where d.PDCEMPCOD=c.PDCEMPCOD
                   and d.PDCNUM=c.PDCNUM) > 0
       and (select sum(PDCQTDRES)
              from TBS0451 d with (nolock) 
             where d.PDCEMPCOD=c.PDCEMPCOD
                   and d.PDCNUM=c.PDCNUM) > 0
       and (select sum(PDCQTD - PDCQTDENT - PDCQTDRES)
                from TBS0451 d with (nolock) 
               where d.PDCEMPCOD=c.PDCEMPCOD
                     and d.PDCNUM=c.PDCNUM) = 0

begin tran
update TBS045
   set PDCSIT=4
 where PDCNUM in (select c.PDCNUM
                    from TBS045 c with (nolock)
                   where PDCSIT <> 4
                         and (select sum(PDCQTD)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) > 0
                         and (select sum(PDCQTDENT)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) > 0
                         and (select sum(PDCQTDRES)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) > 0
                         and (select sum(PDCQTD - PDCQTDENT - PDCQTDRES)
                                from TBS0451 d with (nolock) 
                               where d.PDCEMPCOD=c.PDCEMPCOD
                                     and d.PDCNUM=c.PDCNUM) = 0)

rollback tran 
commit tran 