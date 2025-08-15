-- Aba 2: Monitoramento dos arquivos SQL

IF (OBJECT_ID('_CheckList_Arquivos_SQL') IS NOT NULL) drop table _CheckList_Arquivos_SQL

create table dbo._CheckList_Arquivos_SQL (
[Name] varchar(250) , [FileName] varchar(250) , [Size] bigint, [MaxSize] bigint, Growth varchar(100), Proximo_Tamanho bigint, Situacao varchar(15))

insert into dbo._CheckList_Arquivos_SQL
select convert(varchar, name) as NAME ,Filename ,
cast(Size * 8 as bigint) / 1024.00 Size,
case when MaxSize = -1 then -1 else cast(MaxSize as bigint)* 8 / 1024.00 end MaxSize,
case when substring(cast(Status as varchar),1,2) = 10 then cast(Growth as varchar) + ' %'
else cast (cast((Growth * 8 )/1024.00 as numeric(15,2)) as varchar) + ' MB'end Growth,
case when substring(cast(Status as varchar),1,2) = 10
then (cast(Size as bigint) * 8 / 1024.00) * ((Growth/100.00) + 1)
else (cast(Size as bigint) * 8 / 1024.00) + cast((Growth * 8 )/1024.00 as numeric(15,2))
end Proximo_Tamanho ,
case when MaxSize = -1 then 'OK' -- OK
when
( case when substring(cast(Status as varchar),1,2) = 10
then (cast(Size as bigint)* 8 / 1024.00) * ((Growth/100.00) + 1)
else (cast(Size as bigint) * 8/ 1024.00) + cast((Growth * 8 )/1024.00 as numeric(15,2))
end
) < (cast(MaxSize as bigint) * 8/1024.00) then 'OK' else 'PROBLEMA'
end Situacao
from master..sysaltfiles with(nolock)
order by Situacao, Size desc

select * from _CheckList_Arquivos_SQL