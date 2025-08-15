if exists(select name from sysobjects where name='SP_EXISTECLIENTE' and type='P')
   drop procedure [dbo].[SP_EXISTECLIENTE]
go

-- @tipo_pessoa: F = física; J = jurídica

create procedure SP_EXISTECLIENTE (@empresa int out, @registro int out, @cli_empresa int out, @tipo_pessoa char(1) out, @documento varchar(14) out, @ven_empresa int out, @conta int out)
as
begin

set nocount ON

declare @cnpj_empresa varchar(14), @empresa_local char(2)
--, @link int, @codigo as varchar(15)

set @cnpj_empresa=(select top(1) EMPCGC from TBS023 with (nolock) order by EMPCOD desc)

set @empresa_local = case
                        when @cnpj_empresa='05118717000156' then 'BB'
                        when @cnpj_empresa='52080207000117' then 'MI'
                        when @cnpj_empresa='44125185000136' then 'PP'
                        when @cnpj_empresa='65069593000350' then 'TC'
                        when @cnpj_empresa='65069593000198' then 'TM'
                        when @cnpj_empresa='65069593000279' then 'TT'
                     end

--print @cnpj_empresa

if object_id('tempdb.dbo.#clientes') is not null 
   begin 
      drop table #clientes
   end

create table #clientes
(empresa char(2), codigo int, nome varchar(60), ultima_compra date, vendedor varchar(35))

--select *
--  from #clientes

-- empresa local

if @tipo_pessoa = 'J'
   begin
      if (select top(1) 1 from TBS002 with (nolock) where CLICGC=@documento) > 0
         
         insert into #clientes
         select @empresa_local
                ,c.CLICOD
                ,rtrim(c.CLINOM)
                ,c.CLIUCPDAT
                ,isnull((select rtrim(VENNOM)
                    from TBS004 v with (nolock)
                   where v.VENEMPCOD=@ven_empresa
                         and v.VENCOD=c.VENCOD),'') as 'VENNOM'
           from TBS002 c with (nolock)
          where c.CLIEMPCOD=@cli_empresa
                and c.CLICGC=@documento
      end
else
   begin
      if (select top(1) 1 from TBS002 with (nolock) where CLICGC=@documento) > 0
         
         insert into #clientes
         select @empresa_local
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICPF=@documento
      end

-- empresas remotas

-- best bag

if @cnpj_empresa != '05118717000156' and dbo.fncMaquina_Ligada('192.168.0.3') > 0
   if @tipo_pessoa = 'J'
      begin
         if (select top(1) 1 from bb.SIBD2.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0
            
            insert into #clientes
            select 'BB'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from bb.SIBD2.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from bb.SIBD2.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICGC=@documento
      end
   else
      begin
         if (select top(1) 1 from bb.SIBD2.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'BB'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from bb.SIBD2.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from bb.SIBD2.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICPF=@documento
      end

-- misaspel

if @cnpj_empresa != '52080207000117' and dbo.fncMaquina_Ligada('192.168.0.7') > 0
   if @tipo_pessoa = 'J'
      begin
         if (select top(1) 1 from mi.SIBD3.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0
            
            insert into #clientes
            select 'MI'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from mi.SIBD3.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from mi.SIBD3.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICGC=@documento
      end
   else
      begin
         if (select top(1) 1 from mi.SIBD3.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'MI'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from mi.SIBD3.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from mi.SIBD3.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICPF=@documento
      end

-- papelyna

if @cnpj_empresa != '44125185000136' and dbo.fncMaquina_Ligada('192.168.0.7') > 0
   if @tipo_pessoa = 'J'
      begin
         if (select top(1) 1 from pp.SIBD.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'PP'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from pp.SIBD.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from pp.SIBD.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICGC=@documento
      end
   else
      begin
         if (select top(1) 1 from pp.SIBD.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'PP'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from pp.SIBD.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from pp.SIBD.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICPF=@documento
      end

-- tanby cd

if @cnpj_empresa != '65069593000350' and dbo.fncMaquina_Ligada('192.168.10.7') > 0
   if @tipo_pessoa = 'J'
      begin
         if (select top(1) 1 from cd.SIBD.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'TC'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from cd.SIBD.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from cd.SIBD.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICGC=@documento
      end
   else
      begin
         if (select top(1) 1 from cd.SIBD.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'TC'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from cd.SIBD.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from cd.SIBD.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICPF=@documento
      end

-- tanby matriz

if @cnpj_empresa != '65069593000198' and dbo.fncMaquina_Ligada('192.168.1.205') > 0
   if @tipo_pessoa = 'J'
      begin
         if (select top(1) 1 from nd.SIBD.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'TM'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from nd.SIBD.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from nd.SIBD.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICGC=@documento
      end
   else
      begin
         if (select top(1) 1 from nd.SIBD.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'TM'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from nd.SIBD.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from nd.SIBD.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICPF=@documento
      end

-- tanby taubaté

if @cnpj_empresa != '65069593000279' and dbo.fncMaquina_Ligada('192.168.3.205') > 0
   if @tipo_pessoa = 'J'
      begin
         if (select top(1) 1 from tt.SIBD.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'TT'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from tt.SIBD.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from tt.SIBD.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICGC=@documento
      end
   else
      begin
         if (select top(1) 1 from tt.SIBD.dbo.TBS002 with (nolock) where CLICGC=@documento) > 0

            insert into #clientes
            select 'TT'
                   ,c.CLICOD
                   ,rtrim(c.CLINOM)
                   ,c.CLIUCPDAT
                   ,isnull((select rtrim(VENNOM)
                       from tt.SIBD.dbo.TBS004 v with (nolock)
                      where v.VENEMPCOD=@ven_empresa
                            and v.VENCOD=c.VENCOD),'') as 'VENNOM'
              from tt.SIBD.dbo.TBS002 c with (nolock)
             where c.CLIEMPCOD=@cli_empresa
                   and c.CLICPF=@documento
      end

select @conta = count(*) from #clientes

if @conta > 0
   insert into TMP025
   select @empresa
          ,@registro
          ,empresa
          ,codigo
          ,nome
          ,ultima_compra
          ,vendedor
     from #clientes
    order by empresa
return
end


--return isnull(@existe,0)

-- teste

/*
declare @encontrado varchar(10)

exec dbo.sp_existeCliente @tipo_pessoa = 'J', @documento = '65069593000198', @empresa = @encontrado output

select @encontrado
*/

declare @encontrado varchar(max)

exec dbo.SP_EXISTECLIENTE @tipo_pessoa = 'J', @documento = '65069593000198', @empresa = '', @xml_clientes = @encontrado output

select @encontrado

print @encontrado

select UFESIG
       ,UFENOM
  from TBS001 with (nolock)
   for xml path ('estados'), ROOT ('uf')

delete TMP025

exec dbo.sp_existeCliente 0, 1, 'J', '65069593000198'

select *
  from TMP025 with (nolock)

declare @n int

exec dbo.SP_EXISTECLIENTE 0, 1, 0, 'J', '65069593000198', 0, @conta = @n output

print @n

-- habilitando o clr na sua instância sql server

sp_configure 'clr enabled'
GO
sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO
sp_configure 'clr enabled'
GO

-- nível de permissão do assembly

ALTER DATABASE [SIBD4] SET TRUSTWORTHY ON

