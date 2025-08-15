-- lê planilha excel - relatório da sefaz
-- arquivo deve ser pré-formatado

if object_id('TempDB.dbo.#relatorio') is not null
   begin
	drop table #relatorio
   end;
go

-- tentei rodar servidor local... derruba server sql

select *
       ,row_number() over(order by F2) as lin
  into #relatorio
  --from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\CST - Cupom de Movimento_Fevereiro_2023_65069593000198.xlsx', 'select * from [Planilha1$]');
  --from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\CST - Cupom de Movimento_Novembro_2024_65069593000279.xlsx', 'select * from [Planilha1$]');
  --from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\RPA - Cupom de Movimento_Novembro_2022_05118717000156.xlsx', 'select * from [Planilha1$]');
  --from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\RPA - Cupom de Movimento_Julho_2022_65069593000279.xlsx', 'select * from [Planilha1$]');
  --from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=D:\Documents\GRM\xml\sat\planilha_sefaz\RPA - Cupom de Movimento_Julho_2022_65069593000198.xlsx', 'select * from [Planilha1$]');
  --from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=c:\integros\temp\CSOSN - Cupom de Movimento_Dezembro_2024_33605802000184.xlsx', 'select * from [CDU113_SN_CFe_SAT$]');
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\CST - Cupom de Movimento_Maio_2025_65069593000279.xlsx', 'select * from [Planilha2$]');
go

--select * from #relatorio

-- tabela para carregamento dos dados da planilha

if object_id('TempDB.dbo.#dados') is not null
   begin
      drop table #dados
   end;
go

create table #dados
([data] date, eliminarF2 char(1), equipamento varchar(20), eliminarF4 char(1), eliminar3 varchar(40), eliminarF6 char(1), eliminar4 varchar(40), eliminarF8 char(1), eliminarF9 char(1), cancelado smallint, valor decimal(12,2), eliminarF12 char(1), eliminarF13 char(1)
,cfop smallint, eliminarF15 char(1), eliminar7 float, eliminar8 varchar(40), eliminar9 float, eliminarF19 char(1), eliminar10 float, eliminar11 float, lin smallint);
go

-- carrega os dados

insert into #dados
select *
  from #relatorio

-- select * from #dados

-- elimina colunas desnecessárias

alter table #dados
 drop column eliminarF2
             ,eliminarF4
             ,eliminar3
             ,eliminarF6
             ,eliminar4
             ,eliminarF8
             ,eliminarF9
             ,eliminarF12
             ,eliminarF13
             ,eliminarF15
             ,eliminar7
             ,eliminar8
             ,eliminar9
             ,eliminarF19
             ,eliminar10
             ,eliminar11

-- update do cfop nulo

update #dados
   set cfop=9999
 where cfop is null
       and equipamento='Total do Equipamento'

-- update dos campos "cancelado" nulos

update #dados
   set cancelado=0
 where cancelado is null

-- ajustes das datas

declare @i smallint, @n smallint, @d date

select @i=1
       ,@n = (select count(*) from #dados)
       ,@d = (select top(1) [data] from #dados)

print @i
print @n
print @d

while @i <= @n
   begin
      if (select 1 from #dados where [data] is null and lin=@i) > 0
         begin
            update #dados
               set [data]=@d
             where lin=@i
         end
      else
         set @d = (select [data] from #dados where lin=@i)
         
      set @i += 1
   end; 

-- ajustes dos números dos equipamentos

declare @eq varchar(10)

select @i=1
       ,@n = (select count(*) from #dados)
       ,@eq = (select top(1) equipamento from #dados)

while @i <= @n
   begin
      if (select 1 from #dados where (equipamento is null or equipamento='Total do Equipamento') and lin=@i) > 0
         begin
            update #dados
               set equipamento=@eq
             where lin=@i
         end
      else
         set @eq = (select equipamento from #dados where lin=@i)
         
      set @i += 1
   end;
go

-- elimina "linha" com totais do dia

delete #dados
 where cfop is null

-- tabela de equipamentos sat

if object_id('TempDB.dbo.#sat') is not null
begin
	drop table #sat
end

-- tanby matriz

select '000629181-33' as sn
       ,1 as caixa
       ,'TM' as empresa
  into #sat

union
select '001157066' as sn
       ,1 as caixa
       ,'TM' as empresa

union 
select '000524397-12'
       ,2
       ,'TM'

union
select '001157091' as sn
       ,2 as caixa
       ,'TM' as empresa

union
select '000524396-31'
       ,3
       ,'TM'

union
select '001157063' as sn
       ,3 as caixa
       ,'TM' as empresa

union 
select '000524398-01'
       ,4
       ,'TM'

union
select '001207658' as sn
       ,4 as caixa
       ,'TM' as empresa

union 
select '000524401-33'
       ,5
       ,'TM'

union
select '001157042' as sn
       ,5 as caixa
       ,'TM' as empresa

union 
select '000857694-79'
       ,6
       ,'TM'

union
select '001208596' as sn
       ,6 as caixa
       ,'TM' as empresa

-- tanby taubaté
union 
select '000555783-65'
       ,1
       ,'TT'

union 
select '000555760-79'
       ,2
       ,'TT'

union 
select '000588236-20'
       ,3
       ,'TT'

union 
select '000588219-29'
       ,4
       ,'TT'

union 
select '000555781-01'
       ,5
       ,'TT'

union 
select '000588253-20'
       ,6
       ,'TT'

union 
select '001157072-55'
       ,1
       ,'TT'

union 
select '001207657-05'
       ,2
       ,'TT'

union 
select '001208586-30'
       ,3
       ,'TT'

union 
select '001207174-92'
       ,4
       ,'TT'

union 
select '001208658-40'
       ,5
       ,'TT'

union 
select '001207216-86'
       ,6
       ,'TT'

-- best bag

union 
select '000555776-36'
       ,1
       ,'BB'

union 
select '000588245-10'
       ,2
       ,'BB'

union 
select '000556518-95'
       ,3
       ,'BB'

union 
select '000556510-38'
       ,4
       ,'BB'

union 
select '000556515-42'
       ,5
       ,'BB'

union 
select '000767396-51'
       ,6
       ,'BB'

union 
select '000698356-16'
       ,7
       ,'HH'

union 
select '000698747-86'
       ,8
       ,'HH'

select *
  from #sat 
 order by empresa, caixa
 
-- total de vendas por caixa

select *
  from (
          select (select caixa from #sat where Left(sn,9)=equipamento collate database_default) as caixa
                 ,sum(valor) as valor
            from #dados
           where cfop=9999
           group by equipamento
       ) t 
order by t.caixa

-- total de vendas por dia/caixa

select *
  from (
          select (select caixa from #sat where Left(sn,9)=equipamento collate database_default) as caixa
                 ,[data]
                 ,sum(valor) as valor
            from #dados
           where cfop=9999
           group by equipamento, [data]
       ) t
 order by t.caixa, t.[data]

-- total de vendas por dia

select [data]
       ,sum(valor) as valor
  from #dados
 where cfop=9999
 group by [data]


select *
  from #dados

-- banco de dados GZ

select *
  from movcaixa m
 where data between '20250501' and '20250531'
       and cancelado=''
       and status='03'
       and caixa=4;

select cupom
       ,sum(valortot)
  from movcaixa m
 where data between '20250501' and '20250531'
       and cancelado=''
       and status='03'
       and caixa=4
 group by cupom



