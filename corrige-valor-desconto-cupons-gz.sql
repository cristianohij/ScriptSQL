select * from MSL002 (nolock)
 where M2_DAT between '20150113' and '20150113' and M2_NUMECF = 18 and M2_TIPREG='03' and M2_REGCAN='F' and M2_NUMDOC=52854

select * from MSL002 (nolock)
 where M2_DAT between '20141201' and '20141201' and M2_NUMECF = 18 and M2_TIPREG='02' and M2_REGCAN='F' and M2_NUMDOC=52854

select M2_COO,M2_VALTOT,M2_ABT,round(M2_VALTOT-M2_ABT,2),M2_QTD,M2_VALTOT/M2_QTD,* from MSL002 (nolock)
 where M2_DAT between '20150112' and '20150112' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_NUMDOC=52694
 order by M2_COO
compute sum(M2_VALTOT),sum(M2_ABT)

select sum(M2_VALTOT),round(sum(M2_ABT),2),sum(M2_VALTOT)-round(sum(M2_ABT),2) from MSL002 (nolock)
 where M2_DAT between '20150113' and '20150113' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_TRB='F00.00'

select M2_VALUNI,M2_QTD,M2_VALTOT,M2_ABT from MSL002 (nolock)
 where M2_DAT between '20150113' and '20150113' and M2_NUMECF = 18 and M2_TIPREG='01' and M2_REGCAN='F' and M2_NUMDOC=52854

select sum(M2_VALTOT) from MSL002 (nolock)
 where M2_DAT between '20141201' and '20141201' and M2_NUMECF = 18 and M2_TIPREG='02' and M2_REGCAN='F'


update MSL002 set M2_ABT=0 where M2_DAT='20150113' and M2_TIPREG='01'

update MSL002 set M2_VALTOTABT=0 where M2_DAT='20150113' and M2_TIPREG='01'


-- registro 03
-- A contem o total do cupom subtraido o abatimento

-- registro 02
-- B contem o valor do abatimento

-- C total do cupom = A + B

-- encontrar quantos porcento o total do item representa do total do cupom

-- total do item dividido pelo total do cupom vezes 100
-- D = total do item * 100 / C

-- valor do abatimento por item
-- = D * B / 100

-- se já existir a tabela, exclui
if object_id('SIBD..CUPONS') is not null
   begin
      drop table CUPONS
   end

select M2_EMPCOD as 'Empresa',
       M2_LOJ as 'Loja',
       M2_CXA as 'Caixa',
       M2_DAT as 'Data',
       M2_HOR as 'Hora',
       M2_NUMPED as 'NumeroDoPedido',
       M2_TIPDOC as 'TipoDoDocumento',
       M2_NUMDOC as 'NumeroDoDocumento',
       M2_NUMECF as 'NumeroDaECF',
       M2_VALTOT as 'ValorDoAbatimento',
       isnull((select sum(M2_VALTOT) from MSL002 as B (nolock)
                where B.M2_EMPCOD=A.M2_EMPCOD and
                      B.M2_LOJ=A.M2_LOJ and 
                      B.M2_CXA=A.M2_CXA and
                      B.M2_DAT=A.M2_DAT and
                      B.M2_HOR=A.M2_HOR and
                      B.M2_NUMDOC=A.M2_NUMDOC and
                      B.M2_NUMPED=A.M2_NUMPED and
                      B.M2_TIPDOC=A.M2_TIPDOC and
                      B.M2_TIPREG='03' and
                      B.M2_REGCAN='F'),0) as 'TotalComAbatimento'
  into CUPONS
  from MSL002 as A (nolock)
 where M2_DAT between '20150113' and '20150113' and 
       M2_NUMECF = 18 and
       M2_TIPREG='02' and
       M2_REGCAN='F'

--select M2_EMPCOD as 'Empresa',
--       M2_LOJ as 'Loja',
--       M2_CXA as 'Caixa',
--       M2_DAT as 'Data',
--       M2_HOR as 'Hora',
--       M2_NUMPED as 'NumeroDoPedido',
--       M2_TIPDOC as 'TipoDoDocumento',
--       M2_NUMDOC as 'NumeroDoDocumento',
--       M2_NUMECF as 'NumeroDaECF',
--       M2_VALTOT as 'TotalComAbatimento',
--       isnull((select M2_VALTOT from MSL002 as B (nolock)
--                where B.M2_EMPCOD=A.M2_EMPCOD and
--                      B.M2_LOJ=A.M2_LOJ and 
--                      B.M2_CXA=A.M2_CXA and
--                      B.M2_DAT=A.M2_DAT and
--                      B.M2_HOR=A.M2_HOR and
--                      B.M2_NUMDOC=A.M2_NUMDOC and
--                      B.M2_NUMPED=A.M2_NUMPED and
--                      B.M2_TIPDOC=A.M2_TIPDOC and
--                      B.M2_TIPREG='02' and
--                      B.M2_REGCAN='F'),0) as 'ValorDoAbatimento'
--  into CUPONS
--  from MSL002 as A (nolock)
-- where M2_DAT between '20150101' and '20150128' and 
--       M2_NUMECF = 18 and
--       M2_TIPREG='03' and
--       M2_REGCAN='F'
 --and M2_NUMDOC=52854

select * from CUPONS (nolock) order by NumeroDoDocumento

-- elimina cupons sem desconto
--delete CUPONS where ValorDoAbatimento=0

-- cria novo atributo
alter table CUPONS add TotalDoCupom money default 0 with values

-- atualiza o valor do novo atributo
update CUPONS set TotalDoCupom=TotalComAbatimento+ValorDoAbatimento

-- zera abatimento - correção
update MSL002 set M2_ABT=0 where M2_DAT between '20150113' and '20150113' and M2_TIPREG='01' and M2_REGCAN='F' and M2_NUMECF=18 

-- atualiza o valor do abatimento dos itens do cupom

begin tran
-- ,DESCITEM=M2_VALTOT*100/TotalDoCupom*ValorDoAbatimento/100,DESCONTOITEM=M2_VALTOT*100/TotalDoCupom*ValorDoAbatimento/100

update MSL002 set M2_ABT=M2_VALTOT/TotalDoCupom*ValorDoAbatimento
  from CUPONS (nolock)
 where Empresa=M2_EMPCOD and
       Loja=M2_LOJ and 
       Caixa=M2_CXA and
       Data=M2_DAT and
       Hora=M2_HOR and
       NumeroDoPedido=M2_NUMPED and
       TipoDoDocumento=M2_TIPDOC and
       NumeroDoDocumento=M2_NUMDOC and
       NumeroDaECF=M2_NUMECF and
       M2_TIPREG='01' and
       M2_REGCAN='F'

commit tran


-- cupons cancelados

if object_id('SIBD..CUPCANCELADOS') is not null
   begin
      drop table CUPCANCELADOS
   end

select M2_EMPCOD as 'Empresa',
       M2_LOJ as 'Loja',
       M2_CXA as 'Caixa',
       M2_DAT as 'Data',
       M2_HOR as 'Hora',
       M2_NUMPED as 'NumeroDoPedido',
       M2_TIPDOC as 'TipoDoDocumento',
       M2_NUMDOC as 'NumeroDoDocumento',
       M2_NUMECF as 'NumeroDaECF'
  into CUPCANCELADOS
  from MSL002 (nolock)
 where M2_DAT between '20150101' and '20150128' and M2_NUMECF = 18 and M2_TIPREG='04'

select * from CUPCANCELADOS

-- lista cupons não marcados
select *
  from MSL002 (nolock) right join CUPCANCELADOS on Empresa=M2_EMPCOD and
       Loja=M2_LOJ and 
       Caixa=M2_CXA and
       Data=M2_DAT and
       Hora=M2_HOR and
       NumeroDoPedido=M2_NUMPED and
       TipoDoDocumento=M2_TIPDOC and
       NumeroDoDocumento=M2_NUMDOC and
       NumeroDaECF=M2_NUMECF
 where M2_TIPREG<>'04' and
       M2_REGCAN='F'

alter table MSL002 add M2_VALTOTABT decimal(13,6)