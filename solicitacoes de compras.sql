select 'documento','item','cod-produto','descricao','unidade','qtde-emb','qtde-solicitada','qtde-atendida','qtde-baixada','residuo','qtde-reservada','qtde-pendente'

select SDCNUM,SDCITE,PROCOD,SDCPRODES,SDCUNI,SDCQTDEMB,SDCQTDPED,SDCQTDATD,SDCQTDBAI,SDCQTDRES,
       case when SDCQTDATD > (SDCQTDBAI + SDCQTDRES) then SDCQTDATD - (SDCQTDBAI + SDCQTDRES) else 0 end as 'reserva',
       case when SDCQTDPED > (SDCQTDATD + SDCQTDRES) then SDCQTDPED - (SDCQTDATD + SDCQTDRES) else 0 end as 'pendente'
  from TBS0761 (nolock)
