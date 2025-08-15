set nocount on

declare @datai char(8),@dataf char(8)

-- informe a data inicial/final do relatório:

set @datai='20150601'
set @dataf='20150731'

if object_id('tempdb..#VENDA') is not null
   begin
      drop table #VENDA
   end

if object_id('tempdb..#FINALIZADOR') is not null
   begin
      drop table #FINALIZADOR
   end

create table #FINALIZADOR (codigo char(3),descricao char(15))

insert into #FINALIZADOR select '001','Dinheiro'
insert into #FINALIZADOR select '002','Cheque'
insert into #FINALIZADOR select '003','Cheque pre'
insert into #FINALIZADOR select '004','Convenio'
insert into #FINALIZADOR select '005','POS debito'
insert into #FINALIZADOR select '006','POS credito'
insert into #FINALIZADOR select '007','Credito'
insert into #FINALIZADOR select '008','Debito'
insert into #FINALIZADOR select '009','Faturado'
insert into #FINALIZADOR select '010','Delivery'
insert into #FINALIZADOR select '011','Requisicao'
insert into #FINALIZADOR select '012','Vale'
insert into #FINALIZADOR select '013','CHQ pre (0+2)'

select M2_CXA as 'caixa',
       M2_OPE as 'operador',
       datepart(dd,M2_DAT) as 'dia',
       subString(M2_HOR,1,2) as 'hora',
       count(M2_TIPREG) as 'cupons',
       sum(M2_VALTOT) as 'valor',
       M2_FINVEN as 'codigo_finalizador',
       (select descricao from #FINALIZADOR where codigo=M2_FINVEN collate database_default) as 'descricao_finalizador'
       into #VENDA
  from MSL002 nolock
 where M2_DAT between @datai and @dataf and
       M2_TIPREG='03' and
       M2_REGCAN<>'T'
 group by M2_TIPREG,M2_CXA,M2_OPE,M2_DAT,subString(M2_HOR,1,2),M2_FINVEN

declare @caixa int

-- informe o número do caixa ou 0 (zero) se todos:

set @caixa=0

select caixa,
       operador,
       dia,
       hora,
       cupons,
       valor,
       codigo_finalizador,
       descricao_finalizador
  from #VENDA
 where caixa >= case when @caixa > 0 then @caixa else 0 end and
       caixa <= case when @caixa > 0 then @caixa else 99 end
 order by caixa,operador,dia,hora,codigo_finalizador
compute sum(cupons),sum(valor) by caixa,operador,dia,hora
compute sum(cupons),sum(valor)



-- versão 2 --------------------------------------------------------------------------------------------------------------------------------------------------------

set nocount on

declare @datai char(8),@dataf char(8)

-- informe a data inicial/final do relatório:

set @datai='20150601'
set @dataf='20150731'

if object_id('tempdb..#VENDA') is not null
   begin
      drop table #VENDA
   end

select M2_CXA as 'caixa',
       M2_OPE as 'operador',
       M2_DAT as 'data',
       subString(M2_HOR,1,2) as 'hora',
       count(M2_TIPREG) as 'cupons',
       sum(M2_VALTOT) as 'valor'
       into #VENDA
  from MSL002 nolock
 where M2_DAT between @datai and @dataf and
       M2_TIPREG='03' and
       M2_REGCAN<>'T'
-- group by M2_TIPREG,M2_CXA,M2_OPE,M2_DAT,subString(M2_HOR,1,2)
 group by M2_CXA,M2_OPE,M2_DAT,subString(M2_HOR,1,2)

declare @caixa int,@hora char(2)

-- informe o número do caixa ou 0 (zero) se todos:

set @caixa=0
set @hora='8'

--if convert(int,'9') <= convert(int,'23') print 'sim' else print 'nao'


while convert(int,@hora) <= convert(int,'23')
   begin
      select caixa,
             operador,
             convert(char(8),data,3),
             @hora + ':00 ~ ' + ltrim(str(convert(int,@hora)+1,2)) + ':00' as 'intervalo',
             isnull(sum(cupons),0),
             isnull(sum(valor),0)
        from #VENDA
       where caixa >= case when @caixa > 0 then @caixa else 0 end and
             caixa <= case when @caixa > 0 then @caixa else 99 end and
             hora=@hora
       group by caixa,operador,data
       order by caixa,operador,data
      set @hora=ltrim(str(convert(int,@hora)+1,2))
   end


-- versão 3 --------------------------------------------------------------------------------------------------------------------------------------------------------

set nocount on

declare @datai char(8),@dataf char(8)

-- informe a data inicial/final do relatório:

set @datai='20150601'
set @dataf='20150731'

if object_id('tempdb..#VENDA') is not null
   begin
      drop table #VENDA
   end

select M2_DAT as 'data',
       subString(M2_HOR,1,2) as 'hora',
       count(M2_TIPREG) as 'clientes',
       sum(M2_VALTOT) as 'valor'
       into #VENDA
  from MSL002 nolock
 where M2_DAT between @datai and @dataf and
       M2_TIPREG='03' and
       M2_REGCAN<>'T'
 group by M2_DAT,subString(M2_HOR,1,2)

select convert(char(8),data,3) as 'data',
       hora+':00'+'~'+hora+':59' as 'intervalo',
       clientes,
       str(valor,12,2) as 'valor'
  from #VENDA
 order by data,hora
--compute sum(cupons),sum(valor) by data,hora
--compute sum(cupons),sum(valor)


select top 50 M2_REGCAN,* from MSL002 (nolock) where M2_TIPREG='03' and M2_REGCAN='T'


-- versão 4 --------------------------------------------------------------------------------------------------------------------------------------------------------

set nocount on

declare @dataDe char(8),@dataAte char(8)

-- informe a data inicial/final do relatório:

set @dataDe='20150601'
set @dataAte='20150731'

select convert(char(8),M2_DAT,3) as 'data',
       subString(M2_HOR,1,2)+':00'+'~'+subString(M2_HOR,1,2)+':59' as 'hora',
       M2_CXA as 'caixa',
       M2_OPE as 'operador',
       count(*) as 'clientes',
       sum(M2_VALTOT) as 'valor'
  from MSL002 nolock
 where M2_DAT between @dataDe and @dataAte and
       M2_TIPREG='03' and
       M2_REGCAN<>'T'
 group by M2_DAT,subString(M2_HOR,1,2),M2_CXA,M2_OPE
 order by 'data','hora','caixa'

select top 1 * from MSL002 (nolock)