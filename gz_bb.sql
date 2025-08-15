select top 1
       *
  from cuponsbb with (nolock)

select *
  from cuponsbb with (nolock)
 where not exists(select 'ne'
                    from cuponsbb2 with (nolock)
                   where cuponsbb2.extrato=cuponsbb.extrato)

select *
  from cuponsbb with (nolock)
 where not exists(select 'ne'
                    from cuponsbb2 with (nolock)
                   where cuponsbb2.doc=cuponsbb.doc)

select sum(valor)
  from cuponsbb with (nolock)

select extrato
       ,count(*)
  from cuponsbb with (nolock)
 group by extrato
having count(*) > 1

select caixa
       ,cancelado       
	   ,right(cuponsbbgz.nfce_aut_prot,6)
       ,*
  from cuponsbbgz with (nolock)
 where not exists(select 'ne'
                    from cuponsbb with (nolock)
                   where cuponsbb.extrato=right(cuponsbbgz.nfce_aut_prot,6))

