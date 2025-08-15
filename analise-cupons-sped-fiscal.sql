select M2_CXA,M2_DAT,M2_TIPREG,sum(M2_VALTOT)
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_TIPREG='04'
 group by M2_CXA,M2_DAT,M2_TIPREG

select * from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_REGCAN = 'T'

select M2_COO,M2_CONCUPFIS,* from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_COO in(34653,34655,34778)

select M2_DAT,M2_CXA,M2_COO,* from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG=25 and M2_CXA=3

drop table #CUPCAN

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC
  into #CUPCAN
  from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG = '04'

update MSL002 set M2_REGCAN='F' where M2_DAT between '20130701' and '20130731' and M2_TIPREG='01' and M2_REGCAN='T'

update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130701' and '20130731' and --M2_TIPREG='01' and
       exists(select '' from #CUPCAN
               where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                     #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC)

select MSL002.M2_REGCAN,*
  from #CUPCAN (nolock) join MSL002 (nolock) on MSL002.M2_EMPCOD=#CUPCAN.M2_EMPCOD and MSL002.M2_LOJ=#CUPCAN.M2_LOJ and MSL002.M2_CXA=#CUPCAN.M2_CXA and
                                                MSL002.M2_DAT=#CUPCAN.M2_DAT and MSL002.M2_NUMDOC=#CUPCAN.M2_NUMDOC and MSL002.M2_NUMPED=#CUPCAN.M2_NUMPED and
                                                MSL002.M2_TIPDOC=#CUPCAN.M2_TIPDOC
where #CUPCAN.M2_CXA=3

select * from #CUPCAN (nolock) where M2_CXA=3

drop table #VENCAN

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC
  into #VENCAN
  from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG = '11'

select MSL002.M2_REGCAN,*
  from #VENCAN (nolock) join MSL002 (nolock) on MSL002.M2_EMPCOD=#VENCAN.M2_EMPCOD and MSL002.M2_LOJ=#VENCAN.M2_LOJ and MSL002.M2_CXA=#VENCAN.M2_CXA and
                                                MSL002.M2_DAT=#VENCAN.M2_DAT and MSL002.M2_NUMDOC=#VENCAN.M2_NUMDOC and MSL002.M2_NUMPED=#VENCAN.M2_NUMPED and
                                                MSL002.M2_TIPDOC=#VENCAN.M2_TIPDOC

update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130701' and '20130731' and --M2_TIPREG='01' and
       exists(select '' from #VENCAN
               where #VENCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #VENCAN.M2_LOJ=MSL002.M2_LOJ and #VENCAN.M2_CXA=MSL002.M2_CXA and #VENCAN.M2_DAT=MSL002.M2_DAT and
                     #VENCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #VENCAN.M2_NUMPED=MSL002.M2_NUMPED and #VENCAN.M2_TIPDOC=MSL002.M2_TIPDOC)

select M2_REGCAN,* from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and
       M2_EMPCOD = 0 and
       M2_LOJ = 1 and
       M2_CXA = 3 and
       M2_DAT = '20130704' and
       M2_NUMDOC = 21147 and
       M2_NUMPED = '' and
       M2_TIPDOC = 'T'

select M2_TRB from MSL002 (nolock) where M2_DAT between '20130901' and '20130930' group by M2_TRB

select M2_REGCAN,* from MSL002
 where M2_DAT between '20130701' and '20130731' and not exists


select count(*) from MSL002 (nolock) where M2_DAT between '20130901' and '20130930'

select count(*) from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG='01' and M2_REGCAN='T' -- 111

select M2_REGCAN,count(*) from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG='01' group by M2_REGCAN -- F=13613 T=111

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC
  into #CUPCAN
  from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG = '04'

select * from #CUPCAN

select M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,M2_NUMDOC,M2_NUMPED,M2_TIPDOC from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_TIPREG='01' and M2_REGCAN='T'

update MSL002 set M2_REGCAN='F' where M2_DAT between '20130701' and '20130731' and M2_TIPREG='01' and M2_REGCAN='T'

update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130701' and '20130731' --and M2_TIPREG='01' and
       exists(select '' from #CUPCAN
               where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                     #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC)

select * from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_COO=36004

select M2_NUMECF,* from MSL002 (nolock) where M2_DAT between '20130703' and '20130703' and M2_CXA=1 order by M2_TIPREG

select M2_NUMECF,* from MSL002 (nolock) where M2_DAT between '20130703' and '20130703' and M2_TIPREG='04'

select M2_TIPREG, sum(M2_VALTOT - M2_ABT) 
from MSL002
where M2_DAT between '20130701' and '20130731' ---and M2_REGCAN = 'F'
group by M2_TIPREG

update MSL002 set M2_REGCAN='T' where M2_DAT between '20130701' and '20130731' and (M2_TIPREG='10' or M2_TIPREG='11')

select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20130801' and '20130831' and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'
 group by M2_TIPREG,M2_REGCAN

-- F00.00
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'
 group by M2_TIPREG,M2_REGCAN

select M2_TIPREG,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20140701' and '20140731' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_TRB='F00.00'
 group by M2_TIPREG

--

-- I00.00 = 119,87
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='I00.00'
 group by M2_TIPREG,M2_REGCAN

-- T07.00
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T07.00'
 group by M2_TIPREG,M2_REGCAN

-- T12.00
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T12.00'
 group by M2_TIPREG,M2_REGCAN

-- T18.00
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20140701' and '20140731' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T18.00'
 group by M2_TIPREG,M2_REGCAN

select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20140701' and '20140731' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='T18.00'
 group by M2_TIPREG,M2_REGCAN

-- DT (desconto total)
select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20140701' and '20140731' and M2_NUMECF = 18 and M2_TIPREG='02' --and M2_REGCAN='F'
 group by M2_TIPREG,M2_REGCAN

select M2_TIPREG,sum(M2_VALTOT),sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20140701' and '20140731' and M2_NUMECF = 18 and M2_TIPREG='02'
 group by M2_TIPREG

--

-- CT (cancelamento total)
select M2_REGCAN,sum(M2_VALTOT),sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20130901' and '20130930' and M2_NUMECF = 18 and M2_REGCAN='T' and M2_TIPREG in('02','04','10','11')
 group by M2_REGCAN

select M2_TIPREG,M2_REGCAN,sum(M2_VALTOT) as 'totBruto',sum(M2_VALTOT - M2_ABT) as 'tot-liquido',sum(M2_VALTOT)-sum(M2_VALTOT - M2_ABT) as 'abatimento'
  from MSL002 (nolock)
 where M2_DAT between '20140701' and '20140731' and M2_NUMECF = 18 and M2_TIPREG in('04','10','11')
 group by M2_TIPREG,M2_REGCAN


select M2_TIPREG as 'COD TIPO REGISTRO',
case M2_TIPREG
when 01 then 'Venda Item'
when 02 then 'Desconto Total'
when 03 then 'Finalizador Venda'
when 04 then 'Cancelamento Cupom'
when 05 then 'Acréscimo sobre Total do Cupom'
when 06 then 'Contra-Vale emitido'
when 07 then 'Cupom Vasilhame'
when 08 then 'Ticket de Troca Emitido'
when 09 then 'Correção de Finalizador'
when 10 then 'Cancelamento de Item'
when 11 then 'Cancelamento de Venda'
when 12 then 'Troco de Finalizador'
when 13 then 'Identificação do Cliente (CAT)'
when 14 then 'Promoção Campanha'
when 15 then 'Cartão Fidelidade'
when 16 then 'Sangria'
when 17 then 'Dados para geração de registro R06 - Ato Cotepe 06/08'
when 18 then 'Identificação do Cliente (Lei Anti-Álcool)'
when 21 then 'Entrada em Caixa (Reforço)'
when 22 then 'Saída no Caixa'
when 23 then 'Abertura de Caixa'
when 24 then 'Fechamento de Caixa'
when 25 then 'Encerramento de Dia ( Redução Z )'
when 30 then 'Emissão Cupom sobre Pedido'
when 35 then 'Iniciante ( Tanque/Bico )'
when 36 then 'Abastecimento'
when 37 then 'Encerrante ( Tanque/Bico )'
when 40 then 'Cancelamento Compra Cartão Próprio / Autorizadores'
when 41 then 'Cancelamento Compra Cartão Crédito Rotativo'
when 42 then 'Cancelamento Transação TEF DISCADO'
when 43 then 'Cancelamento Transação TEF'
when 44 then 'Cancelamento de Pagamento de Conta'
when 45 then 'Cancelamento de Recebimento de Conta de Cliente Loja'
when 50 then 'Cadastro de Senha de Cliente'
when 60 then 'Pagamento de Conta'
when 70 then 'Recebimento de Conta de Cliente Loja'
when 80 then 'Correspondente Bancário'
when 81 then 'Saque Cartão ( Compra&Saque e Troco-Fácil )'
when 82 then 'Correspondente Bancário ( Banco Completo )'
when 90 then 'Recarga de Celular'
end as 'TIPO REGISTRO', M2_TRB,
SUM(M2_VALTOT)
from MSL002
where M2_DAT between '20130901' and '20130930' and M2_NUMECF = 11
group by M2_TIPREG, M2_TRB
order by M2_TIPREG


begin tran
update MSL002 set M2_TIPREG='10' where M2_TIPREG='T' and M2_PROCOD<>''
commit tran

begin tran
update MSL002 set M2_TIPREG='11' where M2_TIPREG='T' and M2_PROCOD=''
commit tran

select M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,M2_NUMDOC,M2_NUMPED,M2_TIPDOC,M2_NUMNFS,M2_USULIBBLQ,M2_PRECUS,M2_DATPROC,M2_HORPROC,M2_PROCODNUM
  from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731'

delete MSL002 where M2_DAT between '20130901' and '20130930'

select * from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG='10' and M2_REGCAN<>'T'

select * from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG='11' and M2_REGCAN<>'T'

begin tran
update MSL002 set M2_REGCAN='T' where M2_DAT between '20130701' and '20130731' and M2_TIPREG='10'
commit tran


select * from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_REGCAN='T' and M2_TIPREG in('01','03') and
       not exists(select '' from #CUPCAN
                   where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                         #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC)

select * from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_REGCAN='F' and M2_TIPREG in('01','03') and
       exists(select '' from #CUPCAN
               where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                     #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC)

select * from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_REGCAN='F' and M2_TIPREG in('01','03') and
       exists(select '' from #CUPCAN
                   where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                         #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC)

select M2_TIPREG,M2_REGCAN,* from MSL002 (nolock)
 where M2_DAT between '20130701' and '20130731' and M2_REGCAN='T' and --M2_TIPREG in('01','03') and
       exists(select '' from #VENCAN
                   where #VENCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #VENCAN.M2_LOJ=MSL002.M2_LOJ and #VENCAN.M2_CXA=MSL002.M2_CXA and #VENCAN.M2_DAT=MSL002.M2_DAT and
                         #VENCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #VENCAN.M2_NUMPED=MSL002.M2_NUMPED and #VENCAN.M2_TIPDOC=MSL002.M2_TIPDOC)

begin tran
update MSL002 set M2_REGCAN='F'
 where M2_DAT between '20130701' and '20130731' and M2_REGCAN='T' and M2_TIPREG in('01','03') and
       not exists(select '' from #CUPCAN
                   where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                         #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC)
commit tran

select * from #CUPCAN
 where M2_DAT between '20130701' and '20130731' and
       not exists(select '' from MSL002 (nolock)
                   where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                         #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC and
                         MSL002.M2_REGCAN='T')

----------

begin tran
update MSL002 set M2_REGCAN='F' where M2_DAT between '20130901' and '20130930'
commit tran

begin tran
update MSL002 set M2_REGCAN='T' where M2_DAT between '20130901' and '20130930' and M2_TIPREG in('04','10','11') and M2_REGCAN<>'T'
commit tran
rollback tran

begin tran
update MSL002 set M2_REGCAN='F' where M2_DAT between '20130901' and '20130930' and M2_TIPREG not in('04','10','11')
commit tran

drop table #CUPCAN

if object_id('SIBD..CUPCAN') is not null
   begin
      drop table CUPCAN
   end

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC,
       M2_NUMECF
  into CUPCAN
  from MSL002 (nolock) where M2_DAT between '20150101' and '20150128' and M2_TIPREG = '04' and M2_NUMECF=18

select * from CUPCAN (nolock)

if object_id('SIBD..VENCAN') is not null
   begin
      drop table VENCAN
   end

select M2_EMPCOD,
       M2_LOJ,
       M2_CXA,
       M2_DAT,
       M2_NUMDOC,
       M2_NUMPED,
       M2_TIPDOC
  into VENCAN
  from MSL002 (nolock) where M2_DAT between '20130901' and '20130930' and M2_TIPREG = '11' and M2_NUMECF=18

select * from VENCAN (nolock)

begin tran
update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130901' and '20130930' and M2_TIPREG<>'04' and M2_REGCAN<>'T' and
       exists(select '' from #CUPCAN
               where #CUPCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #CUPCAN.M2_LOJ=MSL002.M2_LOJ and #CUPCAN.M2_CXA=MSL002.M2_CXA and #CUPCAN.M2_DAT=MSL002.M2_DAT and
                     #CUPCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #CUPCAN.M2_NUMPED=MSL002.M2_NUMPED and #CUPCAN.M2_TIPDOC=MSL002.M2_TIPDOC)
commit tran

begin tran
update MSL002 set M2_REGCAN='T'
 where M2_DAT between '20130901' and '20130930' and M2_TIPREG<>'11' and M2_REGCAN<>'T' and
       exists(select '' from #VENCAN
               where #VENCAN.M2_EMPCOD=MSL002.M2_EMPCOD and #VENCAN.M2_LOJ=MSL002.M2_LOJ and #VENCAN.M2_CXA=MSL002.M2_CXA and #VENCAN.M2_DAT=MSL002.M2_DAT and
                     #VENCAN.M2_NUMDOC=MSL002.M2_NUMDOC and #VENCAN.M2_NUMPED=MSL002.M2_NUMPED and #VENCAN.M2_TIPDOC=MSL002.M2_TIPDOC)
commit tran

select distinct M2_TRB from MSL002 (nolock) where M2_DAT between '20130701' and '20130731'


begin tran
update MSL002 set M2_TRB='I00.00' where M2_DAT between '20130701' and '20130731' and M2_TRB='T00.00'
commit tran


select M2_PROCOD,M2_PROCODNUM from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG='11'

select * from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_NUMECF='06'

select count(*) from MSL002 (nolock)

select count(*) from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG='10'

begin tran
update MSL002 set M2_REGCAN='T' where M2_DAT between '20130801' and '20130831' and M2_TIPREG='10' and M2_REGCAN<>'T'
commit tran

select count(*) from MSL002 (nolock) where M2_DAT between '20130701' and '20130731' and M2_TIPREG='11'

begin tran
update MSL002 set M2_REGCAN='T' where M2_DAT between '20130801' and '20130831' and M2_TIPREG='11' and M2_REGCAN<>'T'
commit tran

select count(*) from MSL002 (nolock) where M2_TIPREG='04'

begin tran
update MSL002 set M2_REGCAN='T' where M2_DAT between '20130801' and '20130831' and M2_TIPREG='04' and M2_REGCAN<>'T'
commit tran


-------------

 select M2_NUMECF as 'ecf',
        M2_DATMOV as 'data',
        M2_TIPREG as 'registro',
        M2_REGCAN as 'cancelado',
        sum(M2_VALTOT) as 'bruto',
        sum(M2_ABT) as 'abatimento',
        sum(M2_VALTOT)-sum(M2_ABT) as 'liquido',
        case
           when M2_TIPREG='01' then M2_TRB
           when M2_TIPREG='02' and M2_REGCAN='F' then 'DT'
           when M2_TIPREG='02' and M2_REGCAN='T' then 'CT'
           when M2_TIPREG='04' then 'CT'
           when M2_TIPREG='10' then 'CT'
           when M2_TIPREG='11' then 'CT'
           when M2_TIPREG='16' then '0N'
           when M2_TIPREG='22' then '0N'
           when M2_TIPREG='24' then '0N'
        end
   from MSL002 (nolock) where M2_DATMOV between '20131001' and '20131031' and M2_NUMECF = 1 and
        (((M2_TIPREG in('01','02','16','24') and M2_REGCAN='F') or M2_TIPREG in('04','10','11','40','41','42','43','44','45')) or
        (M2_TIPREG in('02','05','06','07','08','16','21','22') and M2_REGCAN='T'))
  group by M2_NUMECF,M2_DATMOV,M2_TIPREG,M2_REGCAN,M2_TRB
  order by M2_NUMECF,M2_DATMOV,M2_TIPREG,M2_REGCAN
compute sum(sum(M2_VALTOT)-sum(M2_ABT)) by M2_NUMECF,M2_DATMOV

-- por ecf

 select
        M2_NUMECF as 'ecf',
        M2_DATMOV as 'data',
        M2_TIPREG as 'registro',
        M2_REGCAN as 'cancelado',
        sum(M2_VALTOT) as 'bruto',
        sum(M2_ABT) as 'abatimento',
        sum(M2_VALTOT)-sum(M2_ABT) as 'liquido',
        case
           when M2_TIPREG='01' then M2_TRB
           when M2_TIPREG='02' and M2_REGCAN='F' then 'DT'
           when M2_TIPREG='02' and M2_REGCAN='T' then 'CT'
           when M2_TIPREG='04' then 'CT'
           when M2_TIPREG='10' then 'CT'
           when M2_TIPREG='11' then 'CT'
           when M2_TIPREG='16' then '0N'
           when M2_TIPREG='23' then '0N'
           when M2_TIPREG='24' then '0N'
        end as 'totalizador'
   from MSL002 (nolock) where M2_DATMOV between '20141201' and '20141231' and M2_NUMECF = 18 and
        (((M2_TIPREG in('01','02','16','23','24') and M2_REGCAN='F') or M2_TIPREG in('04','10','11','40','41','42','43','44','45')) or
        (M2_TIPREG in('02','05','06','07','08','16','21','22','23') and M2_REGCAN='T'))
  group by M2_NUMECF,M2_DATMOV,M2_TIPREG,M2_REGCAN,M2_TRB
  order by M2_NUMECF,M2_DATMOV,M2_TIPREG,M2_REGCAN
compute sum(sum(M2_VALTOT)-sum(M2_ABT)) by M2_NUMECF,M2_DATMOV

------

select M2_REGCAN,M2_PROCOD,M2_QTD,M2_VALTOT,M2_ABT,M2_VALTOT-M2_ABT from MSL002 (nolock)
 where M2_DAT between '20130903' and '20130903' and M2_NUMECF = 2 and M2_TIPREG='01' --and M2_REGCAN='F'
 order by convert(money,M2_PROCOD)


--

select M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,M2_NUMDOC,M2_NUMPED,M2_TIPDOC,M2_TIPREG,M2_REGCAN,M2_TRB,*
  from MSL002 (nolock) where M2_DAT between '20130902' and '20130902' and M2_NUMDOC = 26053

select M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,M2_NUMDOC,M2_NUMPED,M2_TIPDOC,M2_TIPREG,M2_REGCAN,M2_TRB,*
  from MSL002 (nolock) where M2_DAT between '20130902' and '20130902' and M2_NUMDOC in(25508,25984)

select M2_EMPCOD,M2_LOJ,M2_CXA,M2_DAT,M2_NUMDOC,M2_NUMPED,M2_CONCUPFIS,M2_TIPDOC,M2_TIPREG,M2_REGCAN,M2_TRB,*
  from MSL002 (nolock) where M2_DAT between '20130903' and '20130903' and M2_NUMDOC in(26107,26135)



select M2_REGCAN,* from MSL002 (nolock) where M2_DAT between '20130903' and '20130903' and M2_NUMECF=2 and M2_PROCOD='1533479'

select M2_REGCAN,* from MSL002 (nolock) where M2_DAT between '20130903' and '20130903' and M2_NUMECF=2 and M2_TIPREG='04'

--

select M2_NUMECF,M2_CXA from MSL002 (nolock) where M2_DAT between '20131001' and '20131031' group by M2_NUMECF,M2_CXA order by M2_NUMECF,M2_CXA


delete MSL002 where M2_DAT between '20130925' and '20130925' and M2_NUMECF=2

select M2_TIPREG,sum(M2_VALTOT),sum(M2_ABT),sum(M2_VALTOT-M2_ABT) from MSL002 (nolock)
 where M2_DAT between '20130903' and '20130903' and M2_NUMECF=2
 group by M2_TIPREG

select M2_REGCAN,* from MSL002 (nolock) where M2_DAT between '20130902' and '20130902' and M2_NUMECF = 2 and M2_VALTOT=16.45
select M2_REGCAN,* from MSL002 (nolock) where M2_DAT between '20130902' and '20130902' and M2_NUMECF = 2 and round(M2_VALTOT,0,1)=16

select * from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select linha from ecf2.txt')
