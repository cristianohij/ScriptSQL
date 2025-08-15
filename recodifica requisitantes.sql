alter table [TBS047] add [numero] int default 0 with values
alter table [TBS047] add [antigo] int default 0 with values

select numero,antigo,* from TBS047

update TBS002 set CLIULTREQ=0
update TBS047 set numero=0
update TBS047 set antigo=REQCOD

declare @cliente int,@requisitante int

set @cliente = (select top 1 CLICOD from TBS047 where numero=0 order by CLICOD,REQCOD)
set @requisitante = (select top 1 REQCOD from TBS047 where numero=0 order by CLICOD,REQCOD)

while (select count(*) from TBS047 where numero=0) > 0
   begin
      update TBS047 set numero = (select CLIULTREQ+1 from TBS002 where CLICOD=@cliente)
       where CLICOD=@cliente and REQCOD=@requisitante

      update TBS002 set CLIULTREQ = CLIULTREQ+1 where CLICOD=@cliente

      set @cliente = (select top 1 CLICOD from TBS047 where numero=0 order by CLICOD,REQCOD)
      set @requisitante = (select top 1 REQCOD from TBS047 where numero=0 order by CLICOD,REQCOD)
  end

update TBS047 set REQCOD=numero

-- atualiza pedidos de vendas com o novo codigo de requisitante
update TBS055 set PDVREQCOD=REQCOD from TBS055 join TBS047 on PDVCLICOD=CLICOD and PDVREQCOD=antigo where PDVREQCOD > 0

-- atualiza orcamentos com o novo codigo de requisitante
update TBS043 set ORCREQCOD=REQCOD from TBS043 join TBS047 on ORCCLI=CLICOD and ORCREQCOD=antigo where ORCREQCOD > 0

--alter table [TBS047] drop column [numero]
--alter table [TBS047] drop column [antigo]
