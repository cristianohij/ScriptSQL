if object_id('TempDB.dbo.#empresa') is not null
begin
	drop table #empresa
end

select e.EMPNOM as 'nome'
       ,e.EMPEND as 'endereco'
       ,e.EMPBAI as 'bairro'
       ,e.EMPCEP as 'cep'
       ,e.EMPUFESIG as 'uf'
       ,isnull((select m.MUNNOM from TBS003 m with (nolock) where m.MUNCOD=e.EMPMUNCOD),'') as 'municipio'
       ,dbo.FormatarCnpj(e.EMPCGC) as 'CNPJ'
  into #empresa
  from TBS023 e with (nolock)
 where e.EMPCOD = 1

--select *
  --from #empresa

declare @orcamento int

set @orcamento = 807747

if object_id('TempDB.dbo.#cliente') is not null
begin
	drop table #cliente
end

select c.CLINOM as 'nome'
       ,c.CLIEND  as 'endereco'
       ,c.CLIBAI as 'bairro'
       ,c.CLICEP as 'cep' 
       ,c.UFESIG as 'uf'
       ,isnull((select m.MUNNOM from TBS003 m with (nolock) where m.MUNCOD=c.MUNCOD),'') as 'municipio'
       ,iif(c.CLITIPPES='J', dbo.FormatarCnpj(c.CLICGC), dbo.FormatarCpf(c.CLICPF)) as 'CNPJ/CPF'
  into #cliente
  from TBS002 c with (nolock)
 where CLICOD = isnull((select ORCCLI from TBS043 o with (nolock) where o.ORCNUM=@orcamento),0)

select *
  from #cliente

if object_id('TempDB.dbo.#vendedor') is not null
begin
	drop table #vendedor
end

select v.VENNOM as 'nome'
       ,v.VENEMAIL  as 'email'
       ,v.VENTEL as 'fone'
  into #vendedor
  from TBS004 v with (nolock)
 where v.VENCOD = isnull((select VENCOD from TBS043 o with (nolock) where o.ORCNUM=@orcamento),0)

select *
  from #vendedor

if object_id('TempDB.dbo.#orcamento') is not null
begin
	drop table #orcamento
end

select o.ORCNUM as 'orcamento'
       ,o.ORCDATCAD as 'data'
       ,o.ORCPRAENT as 'entrega'
       ,o.ORCVALPRO as 'validade'
       ,i.ORCITEM as 'item'
       ,i.ORCDES as 'descricao'
       ,i.ORCUNI as 'unidade'
       ,i.ORCQTD as 'quantidade'
       --,i.ORCPRE as 'preco'
       ,convert(decimal(12,2),dbo.ORCPRELIQ(i.ORCEMPCOD, i.ORCNUM, i.ORCITEM)) as 'preco'
       ,convert(decimal(12,2),dbo.ORCTOTITEST(i.ORCEMPCOD, i.ORCNUM, i.ORCITEM)) as 'total'
       ,convert(float,0) as 'reajuste_m'
       ,convert(float,0) as 'reajuste_p'
  into #orcamento
  from TBS043 o with (nolock)
  inner join TBS0431 i with (nolock)
     on i.ORCEMPCOD=o.ORCEMPCOD
        and i.ORCNUM=o.ORCNUM
 where o.ORCNUM=@orcamento
 order by i.ORCITEM

/*select *
  from #orcamento

declare @total decimal(12,2), @qitens smallint

select @total=sum(total), @qitens=count(*) from #orcamento

select @total, @qitens

select rand()

declare @i int, @j int

select @i=4, @j = 9

--select floor(@i + rand() * (@j-@i))

select @i + rand() * (@j-@i)

SELECT FLOOR(3 + RAND()*(9 - 3 + 1));
*/

declare @item int

declare cursor_orcamento cursor for
    select item
      from #orcamento

-- abre o cursor
open cursor_orcamento

-- le próxima linha
fetch next from cursor_orcamento into @item

-- percorre linhas do cursor
while @@fetch_status = 0
   begin
      --select item from #orcamento where item=@item
      
      update #orcamento
         set reajuste_m = 5 + rand() * (9-5)
       where item=@item

      update #orcamento
         set reajuste_p = 6 + rand() * (12-6)
       where item=@item

      -- le próxima linha
      fetch next from cursor_orcamento into @item
   end

-- eecha o cursor
close cursor_orcamento

-- desaloca o cursor
deallocate cursor_orcamento

select orcamento
       ,[data]
       ,entrega
       ,validade
       ,item
       ,descricao
       ,unidade
       ,quantidade
       ,preco
       ,total
       ,convert(decimal(12,2),preco * (1 + reajuste_m / 100)) as preco_m
       ,convert(decimal(12,2),quantidade * (convert(decimal(12,2),preco * (1 + reajuste_m / 100)))) as total_m
       ,convert(decimal(12,2),preco * (1 + reajuste_p / 100)) as preo_p
       ,convert(decimal(12,2),quantidade * (convert(decimal(12,2),preco * (1 + reajuste_p / 100)))) as total_p
  from #orcamento


