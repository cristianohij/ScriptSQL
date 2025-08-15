select TBS016.USUCOD as 'usuario',
       TBS016.USUBLOQ as 'bloqueado',
       TBS019.MNUNOM as 'menu',
       case when charindex('1',TBS0191.PRGEVE)>0 then 'S' else '' end as 'credito cliente',
       case when charindex('2',TBS0191.PRGEVE)>0 then 'S' else '' end as 'desmarcar todos',
       case when charindex('3',TBS0191.PRGEVE)>0 then 'S' else '' end as 'inverter marcacao',
       case when charindex('4',TBS0191.PRGEVE)>0 then 'S' else '' end as 'liberar credito',
       case when charindex('5',TBS0191.PRGEVE)>0 then 'S' else '' end as 'liberar precos',
       case when charindex('6',TBS0191.PRGEVE)>0 then 'S' else '' end as 'precos manualmente',
       case when charindex('7',TBS0191.PRGEVE)>0 then 'S' else '' end as 'marcar todos',
       case when charindex('8',TBS0191.PRGEVE)>0 then 'S' else '' end as 'orcamento/pedidos',
       case when charindex('9',TBS0191.PRGEVE)>0 then 'S' else '' end as 'vendedor'
  from TBS016 (nolock)
          join TBS0164 (nolock) on TBS0164.USUCOD=TBS016.USUCOD
          join TBS0162 (nolock) on TBS0162.USUCOD=TBS016.USUCOD
          join TBS019 (nolock) on TBS019.MNUNOM=TBS0162.MNUNOM
          join TBS0191 (nolock) on TBS0191.MNUNOM=TBS019.MNUNOM
where USUBLOQ='N' --and
      --PRGCOD='WYVEN007'
group by TBS016.USUCOD,TBS016.USUBLOQ,TBS019.MNUNOM,TBS0191.PRGEVE
