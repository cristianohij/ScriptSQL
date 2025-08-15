-- sp_WYEST087", &PROEMPCOD, &produto, &qtdTM_1, &qtdTM_2, &qtdCmpTM, &qtdTT_1, &qtdTT_2, &qtdCmpTT, &qtdCD_1, &qtdCD_2, &qtdCmpCD, &qtdPP_1, &qtdPP_2, &qtdCmpPP, &qtdBB_1, &qtdBB_2, &qtdCmpBB, &qtdMI_1, &qtdMI_2, &qtdCmpMI)	

declare @qtdTM_1 int, @qtdTM_2 int, @qtdCmpTM int, @qtdTT_1 int, @qtdTT_2 int, @qtdCmpTT int, @qtdCD_1 int, @qtdCD_2 int, @qtdCmpCD int, @qtdPP_1 int, @qtdPP_2 int, @qtdCmpPP int, @qtdBB_1 int, @qtdBB_2 int, @qtdCmpBB int, @qtdMI_1 int, @qtdMI_2 int, @qtdCmpMI int

--execute dbo.SP_WYEST087 0, '1640054', @qtdTM_1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
execute dbo.SP_WYEST087 0, '1640054', @qtdTM_1, @qtdTM_2, @qtdCmpTM, @qtdTT_1, @qtdTT_2, @qtdCmpTT, @qtdCD_1, @qtdCD_2, @qtdCmpCD, @qtdPP_1, @qtdPP_2, @qtdCmpPP, @qtdBB_1, @qtdBB_2, @qtdCmpBB, @qtdMI_1, @qtdMI_2, @qtdCmpMI

select @qtdTM_1, @qtdTM_2, @qtdCmpTM, @qtdTT_1, @qtdTT_2, @qtdCmpTT, @qtdCD_1, @qtdCD_2, @qtdCmpCD, @qtdPP_1, @qtdPP_2, @qtdCmpPP, @qtdBB_1, @qtdBB_2, @qtdCmpBB, @qtdMI_1, @qtdMI_2, @qtdCmpMI

declare @codigo varchar(15)
        ,@LC_estoque int
        ,@LC_loja int
        ,@LC_compras int
        ,@BB_estoque int
        ,@BB_loja int
        ,@BB_compras int
        ,@MI_estoque int
        ,@MI_loja int
        ,@MI_compras int
        ,@PP_estoque int
        ,@PP_loja int
        ,@PP_compras int
        ,@TC_loja int
        ,@TC_estoque int
        ,@TC_compras int
        ,@TM_estoque int
        ,@TM_loja int
        ,@TM_compras int
        ,@TT_estoque int
        ,@TT_loja int
        ,@TT_compras int

set @codigo='1640054'

execute sp_saldosRemotos @codigo out
        ,@LC_estoque out
        ,@LC_loja output
        ,@LC_compras output
        ,@BB_estoque output
        ,@BB_loja output
        ,@BB_compras output
        ,@MI_estoque output
        ,@MI_loja output
        ,@MI_compras output
        ,@PP_estoque output
        ,@PP_loja output
        ,@PP_compras output
        ,@TC_loja output
        ,@TC_estoque output
        ,@TC_compras output
        ,@TM_estoque output
        ,@TM_loja output
        ,@TM_compras output
        ,@TT_estoque output
        ,@TT_loja output
        ,@TT_compras output

select @LC_estoque
        ,@LC_loja
        ,@LC_compras
        ,@BB_estoque
        ,@BB_loja
        ,@BB_compras
        ,@MI_estoque
        ,@MI_loja
        ,@MI_compras
        ,@PP_estoque
        ,@PP_loja
        ,@PP_compras
        ,@TC_loja
        ,@TC_estoque
        ,@TC_compras
        ,@TM_estoque
        ,@TM_loja
        ,@TM_compras
        ,@TT_estoque
        ,@TT_loja
        ,@TT_compras

-- stored procedure retorna saldos produto nas unidades

drop procedure dbo.sp_saldosRemotos
go

create procedure sp_saldosRemotos
   ( @codigo varchar(15) output
     ,@LC_estoque int output
     ,@LC_loja int output
     ,@LC_compras int output
     ,@BB_estoque int output
     ,@BB_loja int output
     ,@BB_compras int output
     ,@MI_estoque int output
     ,@MI_loja int output
     ,@MI_compras int output
     ,@PP_estoque int output
     ,@PP_loja int output
     ,@PP_compras int output
     ,@TC_loja int output
     ,@TC_estoque int output
     ,@TC_compras int output
     ,@TM_estoque int output
     ,@TM_loja int output
     ,@TM_compras int output
     ,@TT_estoque int output
     ,@TT_loja int output
     ,@TT_compras int output) as

   begin
      set nocount on

      select @LC_estoque=0
             ,@LC_loja=0
             ,@LC_compras=0
             ,@BB_estoque=0
             ,@BB_loja=0
             ,@BB_compras=0
             ,@MI_estoque=0
             ,@MI_loja=0
             ,@MI_compras=0
             ,@PP_estoque=0
             ,@PP_loja=0
             ,@PP_compras=0
             ,@TC_loja=0
             ,@TC_estoque=0
             ,@TC_compras=0
             ,@TM_estoque=0
             ,@TM_loja=0
             ,@TM_compras=0
             ,@TT_estoque=0
             ,@TT_loja=0
             ,@TT_compras=0

      if object_id('tempdb.dbo.#saldos') is not null
         begin
	         drop table #saldos
         end

      declare @cnpj_empresa varchar(14)
              ,@link int

      set @cnpj_empresa=(select top(1) EMPCGC from TBS023 with (nolock) order by EMPCOD desc)

      -- saldo local

      select @LC_estoque = isnull((select ESTQTDATU-ESTQTDRES from TBS032 with (nolock) where ESTLOC=1 and PROCOD=@codigo),0)
             ,@LC_loja = isnull((select ESTQTDATU-ESTQTDRES from TBS032 with (nolock) where ESTLOC=2 and PROCOD=@codigo),0)
             ,@LC_compras = isnull((select sum(ESTQTDCMP) from TBS032 with (nolock) where PROCOD=@codigo),0)

      -- best bag

      if @cnpj_empresa != '05118717000156' and dbo.fncMaquina_Ligada('192.168.0.3') > 0
         begin
            select @BB_estoque = isnull((select ESTQTDATU-ESTQTDRES from bb.SIBD2.dbo.TBS032 with (nolock) where ESTLOC=1 and PROCOD=@codigo),0)
                   ,@BB_loja = isnull((select ESTQTDATU-ESTQTDRES from bb.SIBD2.dbo.TBS032 with (nolock) where ESTLOC=2 and PROCOD=@codigo),0)
                   ,@BB_compras = isnull((select sum(ESTQTDCMP) from bb.SIBD2.dbo.TBS032 with (nolock) where PROCOD=@codigo),0)
         end 

      -- misaspel

      if @cnpj_empresa != '52080207000117' and dbo.fncMaquina_Ligada('192.168.0.7') > 0
         begin
            select @MI_estoque = isnull((select ESTQTDATU-ESTQTDRES from mi.SIBD3.dbo.TBS032 with (nolock) where ESTLOC=1 and PROCOD=@codigo),0)
                   ,@MI_loja = isnull((select ESTQTDATU-ESTQTDRES from mi.SIBD3.dbo.TBS032 with (nolock) where ESTLOC=2 and PROCOD=@codigo),0)
                   ,@MI_compras = isnull((select sum(ESTQTDCMP) from mi.SIBD3.dbo.TBS032 with (nolock) where PROCOD=@codigo),0)
         end 

      -- papelyna

      if @cnpj_empresa != '44125185000136' and dbo.fncMaquina_Ligada('192.168.0.7') > 0
         begin
            select @PP_estoque = isnull((select ESTQTDATU-ESTQTDRES from pp.SIBD.dbo.TBS032 with (nolock) where ESTLOC=1 and PROCOD=@codigo),0)
                   ,@PP_loja = isnull((select ESTQTDATU-ESTQTDRES from pp.SIBD.dbo.TBS032 with (nolock) where ESTLOC=2 and PROCOD=@codigo),0)
                   ,@PP_compras = isnull((select sum(ESTQTDCMP) from pp.SIBD.dbo.TBS032 with (nolock) where PROCOD=@codigo),0)
         end 

      -- tanby cd

      if @cnpj_empresa != '65069593000350' and dbo.fncMaquina_Ligada('192.168.10.7') > 0
         begin 
            select @TC_estoque = isnull((select ESTQTDATU-ESTQTDRES from cd.SIBD.dbo.TBS032 with (nolock) where ESTLOC=1 and PROCOD=@codigo),0)
                   ,@TC_loja = isnull((select ESTQTDATU-ESTQTDRES from cd.SIBD.dbo.TBS032 with (nolock) where ESTLOC=2 and PROCOD=@codigo),0)
                   ,@TC_compras = isnull((select sum(ESTQTDCMP) from cd.SIBD.dbo.TBS032 with (nolock) where PROCOD=@codigo),0)
         end 

      -- tanby matriz

      if @cnpj_empresa != '65069593000198' and dbo.fncMaquina_Ligada('192.168.1.205') > 0
         begin 
            select @TM_estoque = isnull((select ESTQTDATU-ESTQTDRES from nd.SIBD.dbo.TBS032 with (nolock) where ESTLOC=1 and PROCOD=@codigo),0)
                   ,@TM_loja = isnull((select ESTQTDATU-ESTQTDRES from nd.SIBD.dbo.TBS032 with (nolock) where ESTLOC=2 and PROCOD=@codigo),0)
                   ,@TM_compras = isnull((select sum(ESTQTDCMP) from nd.SIBD.dbo.TBS032 with (nolock) where PROCOD=@codigo),0)
         end 

      -- tanby taubaté

      if @cnpj_empresa != '65069593000279' and dbo.fncMaquina_Ligada('192.168.3.205') > 0
         begin 
            select @TT_estoque = isnull((select ESTQTDATU-ESTQTDRES from tt.SIBD.dbo.TBS032 with (nolock) where ESTLOC=1 and PROCOD=@codigo),0)
                   ,@TT_loja = isnull((select ESTQTDATU-ESTQTDRES from tt.SIBD.dbo.TBS032 with (nolock) where ESTLOC=2 and PROCOD=@codigo),0)
                   ,@TT_compras = isnull((select sum(ESTQTDCMP) from tt.SIBD.dbo.TBS032 with (nolock) where PROCOD=@codigo),0)
         end 
      
      return
   end 


select *
  from #saldos

select *
  from tt.SIBD.dbo.TBS032 with (nolock) where PROCOD='1640054'


select col.codigo
       ,coalesce([1], 0) as 'estoque'
       ,coalesce([2], 0) as 'loja'
       ,coalesce([3], 0) as 'kit_escolar'
       ,coalesce([4], 0) as 'defeito'
       ,coalesce([5], 0) as 'perdas'
       ,coalesce([6], 0) as 'almoxarifado'
       ,coalesce([7], 0) as 'ocorrencias'
       ,coalesce([8], 0) as 'deposito_cd'
       ,coalesce([9], 0) as 'web'
       ,coalesce([10], 0) as 'in_out'
       ,isnull((select sum(ESTQTDCMP) from TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
       ,'LC' as 'empresa'
  --into #saldos
  from
     (
       select PROCOD as 'codigo'
              , ESTLOC as 'local_estoque'
              ,ESTQTDATU - ESTQTDRES as 'disponivel'
         from TBS032 with (nolock)
        where PROEMPCOD=0
              and PROCOD=@codigo
     ) lin
 pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col


select PROCOD as 'codigo'
              , ESTLOC as 'local_estoque'
              ,ESTQTDATU - ESTQTDRES as 'disponivel'
         from TBS032 with (nolock)
        where PROEMPCOD=0
              and PROCOD=@codigo

select 'PP' as 'empresa'
       ,isnull((select ESTQTDATU-ESTQTDRES from TBS032 with (nolock) where ESTLOC=1 and PROCOD='1640054'),0) as 'estoque'
       ,isnull((select ESTQTDATU-ESTQTDRES from TBS032 with (nolock) where ESTLOC=2 and PROCOD='1640054'),0) as 'loja'
       ,isnull((select sum(ESTQTDCMP) from TBS032 with (nolock) where PROCOD='1640054'),0) as 'compras'


--select *
  --from #saldos

-- best bag

if @cnpj_empresa != '05118717000156' and dbo.fncMaquina_Ligada('192.168.0.3') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from bb.SIBD2.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'BB' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from bb.SIBD2.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- misaspel

if @cnpj_empresa != '52080207000117' and dbo.fncMaquina_Ligada('192.168.0.7') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from mi.SIBD3.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'MI' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from mi.SIBD3.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- papelyna

if @cnpj_empresa != '44125185000136' and dbo.fncMaquina_Ligada('192.168.0.7') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from pp.SIBD.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'PP' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from pp.SIBD.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- tanby cd

if @cnpj_empresa != '65069593000350' and dbo.fncMaquina_Ligada('192.168.10.7') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,0 as 'compras'   -- compras feitas na tanby matriz
          ,'CD' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from cd.SIBD.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- tanby matriz

if @cnpj_empresa != '65069593000198' and dbo.fncMaquina_Ligada('192.168.1.205') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from nd.SIBD.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'ND' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from nd.SIBD.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- tanby taubaté

if @cnpj_empresa != '65069593000279' and dbo.fncMaquina_Ligada('192.168.3.205') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from tt.SIBD.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'TT' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from tt.SIBD.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

select *
  from #saldos




select *
  from TBS034 with (nolock)

select top(100) *
  from TBS032 with (nolock)
 where ESTQTDCMP > 0

if exists(select name from sysobjects where name='sp_saldosRemotos' and type='P')
   drop procedure [dbo].[sp_saldosRemotos]
go

create function PrecoLoja(@empresa int, @produto varchar(15))
returns @dados table(codigo varchar(15), preco1 smallmoney, preco2 smallmoney, preco3 smallmoney, preco4 smallmoney, custo smallmoney) as
begin

create procedure sp_saldosRemotos(@codigo varchar(15))
returns @saldos table(codigo varchar(15), estoque int, loja int, kit_escolar int, defeito int, perdas int, almoxarifado int, ocorrencias int, deposito_cd int, web int, in_out int, compras int) as
begin 

if object_id('tempdb.dbo.#saldos') is not null
begin
	drop table #saldos
end
go

declare @cnpj_empresa varchar(14), @link int, @codigo as varchar(15)

set @cnpj_empresa=(select top(1) EMPCGC from TBS023 with (nolock) order by EMPCOD desc)
set @codigo='1640054'

--select @cnpj_empresa

-- saldo local

insert into #saldos
select col.codigo
       ,coalesce([1], 0) as 'estoque'
       ,coalesce([2], 0) as 'loja'
       ,coalesce([3], 0) as 'kit_escolar'
       ,coalesce([4], 0) as 'defeito'
       ,coalesce([5], 0) as 'perdas'
       ,coalesce([6], 0) as 'almoxarifado'
       ,coalesce([7], 0) as 'ocorrencias'
       ,coalesce([8], 0) as 'deposito_cd'
       ,coalesce([9], 0) as 'web'
       ,coalesce([10], 0) as 'in_out'
       ,isnull((select sum(ESTQTDCMP) from TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
       ,'LC' as 'empresa'
  --into #saldos
  from
     (
       select PROCOD as 'codigo'
              , ESTLOC as 'local_estoque'
              ,ESTQTDATU - ESTQTDRES as 'disponivel'
         from TBS032 with (nolock)
        where PROEMPCOD=0
              and PROCOD=@codigo
     ) lin
 pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

--select *
  --from #saldos

-- best bag

if @cnpj_empresa != '05118717000156' and dbo.fncMaquina_Ligada('192.168.0.3') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from bb.SIBD2.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'BB' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from bb.SIBD2.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- misaspel

if @cnpj_empresa != '52080207000117' and dbo.fncMaquina_Ligada('192.168.0.7') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from mi.SIBD3.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'MI' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from mi.SIBD3.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- papelyna

if @cnpj_empresa != '44125185000136' and dbo.fncMaquina_Ligada('192.168.0.7') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from pp.SIBD.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'PP' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from pp.SIBD.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- tanby cd

if @cnpj_empresa != '65069593000350' and dbo.fncMaquina_Ligada('192.168.10.7') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,0 as 'compras'   -- compras feitas na tanby matriz
          ,'CD' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from cd.SIBD.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- tanby matriz

if @cnpj_empresa != '65069593000198' and dbo.fncMaquina_Ligada('192.168.1.205') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from nd.SIBD.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'ND' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from nd.SIBD.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

-- tanby taubaté

if @cnpj_empresa != '65069593000279' and dbo.fncMaquina_Ligada('192.168.3.205') > 0
   insert into #saldos
   select col.codigo
          ,coalesce([1], 0) as 'estoque'
          ,coalesce([2], 0) as 'loja'
          ,coalesce([3], 0) as 'kit_escolar'
          ,coalesce([4], 0) as 'defeito'
          ,coalesce([5], 0) as 'perdas'
          ,coalesce([6], 0) as 'almoxarifado'
          ,coalesce([7], 0) as 'ocorrencias'
          ,coalesce([8], 0) as 'deposito_cd'
          ,coalesce([9], 0) as 'web'
          ,coalesce([10], 0) as 'in_out'
          ,isnull((select sum(ESTQTDCMP) from tt.SIBD.dbo.TBS032 e with (nolock) where e.PROCOD=col.codigo),0) as 'compras'
          ,'TT' as 'empresa'
     from
        (
          select PROCOD as 'codigo'
                 , ESTLOC as 'local_estoque'
                 ,ESTQTDATU - ESTQTDRES as 'disponivel'
            from tt.SIBD.dbo.TBS032 with (nolock)
           where PROEMPCOD=0
                 and PROCOD=@codigo
        ) lin
    pivot (sum(disponivel) for local_estoque in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) col

go

declare @registros int
exec sp_saldosRemotos 'SP', @registros output
select @registros