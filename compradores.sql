set nocount on;

if object_id('tempdb.dbo.#comprador') is not null 
    drop table #comprador;

select
    codigo,
    nome,
    situacao,
    limite_compra,
    vencto_limite,
    data_cadastro
into #comprador
from openrowset(
    'SQLNCLI',
    '192.168.1.205';'integros';'int3gro5@15387',
    '
    select top(1)
        COMCOD as codigo,
        COMNOM as nome,
        COMSTA as situacao,
        COMLIMCOM as limite_compra,
        COMLIMVEN as vencto_limite,
        COMDATCAD as data_cadastro
    from SIBD.dbo.TBS046 with (nolock)
    order by COMCOD desc
    '
) as tab;

--select *
--  from #comprador;

declare @codigo smallint
        ,@empresa smallint
        ,@bestbag char(1);

-- teste
--set @codigo=56

-- código do comprador

select @codigo=codigo
  from #comprador;

--select 'código: ' + cast(@codigo as varchar);

--print @codigo;

set @bestbag = isnull((select top(1) 'S' from TBS023 with (nolock) where EMPNOM Like('BEST BAG%')),'N');

--select @bestbag;

select @empresa=(select iif(TBSMOD='C', 0, 99) from TBS024 with (nolock) where TBSNOM='TBS046');
       --,nome
       --,situacao
       --,limite_compra
       --,vencto_limite
       --,data_cadastro
--  from #comprador;

--select 'empresa: ' + cast(@empresa as varchar);

if @empresa = 99
   begin
      if @bestbag = 'S'
         -- se a empresa for best bag então 2, as demais empresa 1
         set @empresa=(select EMPCOD from TBS0241 with (nolock) where EMPCOD = iif(@bestbag='S',2,1) and TBSNOM='TBS046');
   end; 

--select 'empresa: ' + cast(@empresa as varchar);

if not exists (
    select 1 from TBS046 with (nolock)
    where COMEMPCOD = @empresa and COMCOD = @codigo
)
begin
    --select 'codigo: ' + cast(codigo as varchar) + ' nome: ' + nome
        --from #comprador

    insert into TBS046 (COMEMPCOD, COMCOD, COMNOM, COMSTA, COMLIMCOM, COMLIMVEN, COMDATCAD)
    select @empresa
            ,codigo
            ,nome
            ,situacao
            ,limite_compra
            ,vencto_limite
            ,data_cadastro
        from #comprador
end;


select *
  from TBS024 with (nolock)
 where TBSNOM='TBS056'

select *
  from TBS0241 with (nolock)
 where TBSNOM='TBS056'

select *
  from TBS023 with (nolock)
