select d.PROCOD
       ,p.PRODES
	   ,p.PROLOCFIS
       ,count(*)
  from TBS0371 d with (nolock)
       inner join TBS037 c with (nolock)
          on d.MVIDOC=c.MVIDOC
	   inner join TBS010 p with (nolock)
	      on p.PROCOD=d.PROCOD
 where c.MVIDATEFE between '20230731' and '20230801'
	   and c.MVIOBS='GERADA PELA ROTINA DE RESERVA DE PEDIDO DE VENDAS'
      and d.PROCOD='2540001'
 group by d.PROCOD
          ,p.PRODES
		  ,p.PROLOCFIS

select *
  from TBS0671 d with (nolock)
       inner join TBS067 c with (nolock)
          on c.NFSNUM=d.NFSNUM
 where c.NFSTIP='L'
       and c.NFSDATEMI between '20230731' and '20230801'
       and c.NFSCAN='N'
       and d.PROCOD='1640054'



