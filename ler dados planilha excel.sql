select * FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0','Excel 8.0';DATABASE='C:\GeneXus\modelos\ver90\STella\excel\Planilha estoque Tella 02Jan13.xls',
 SELECT * FROM [Plan2$])

SELECT a.*
FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0', 
   'c:\temp\tella2.xls', Orders) 
   AS a
GO

exec sp_configure
'show advanced options', 1
reconfigure
 
exec sp_configure
'Ad Hoc Distributed Queries', 1
reconfigure

SELECT * FROM OPENROWSET ('Microsoft.Jet.OleDB.4.0','EXCEL 8.0;Database=c:\temp\tella2.xls',Plan2$)

-- criando link
sp_addlinkedserver 'TANBY',
   'Jet 4.0',
   'Microsoft.Jet.OLEDB.4.0',
   'C:\temp\importar.xls',
   null,
   'Excel 8.0'

sp_dropserver TANBY

sp_addlinkedsrvlogin TANBY,false,sa,null

SELECT * INTO tella2 FROM OPENQUERY(ExcelTella,
    'SELECT * FROM [Plan2$]')


SELECT * FROM OPENQUERY(ExcelTella, 'SELECT ''12/2012'',codigo,qtde,0,'' '',0,'' '',''04.1.1.01.002'',1,0,0 FROM [Plan1$] where unidade=''KG''') 

delete tab41

insert tab41 SELECT * FROM OPENQUERY(ExcelTella, 'SELECT ''12/2012'',codigo,qtde,0,''-'',0,''-'',''04.1.1.01.002'',1,0,0 FROM [Plan1$] where unidade=''KG''') 

select * from tab41

select * from openquery(ExcelTella, 'select codigo from [Plan1$] a where (select count(*) from [Plan1$] b where b.codigo = a.codigo)) > 1 '

select * from openquery(MRE, 'select ''update TBS010 set PRODESPDV = |'' + rtrim(des24) + ''| where PROCOD = |'' + rtrim(codigo) + ''|'' from [Plan1$]')

select PROCOD,PRODES from TBS010 A
 where (select count(*) from TBS010 B where convert(int,B.PROCOD)=convert(int,A.PROCOD)) > 1
 order by PROCOD

select procodsta + '/' + procodstb,proprecus from tab12 (nolock)

update tab41 set Invcsticms = procodsta + '/' + procodstb,Invval = proprecus from tab12 (nolock) join tab41 (nolock) on tab12.procod = tab41.procod

select * from tab16
select * from tab41
delete tab16

insert into tab16
declare @res int
select 0,
       '20130102',
       case when (select unicod from tab12 (nolock) where tab12.procod = tab41.procod) <> 'KG' then invqtd else 0 end,
       tab41.procod,
       'E',
       '',
       case when (select unicod from tab12 (nolock) where tab12.procod = tab41.procod) = 'KG' then invqtd else 0 end
  from tab41 (nolock) join tab12 (nolock) on tab41.procod = tab12.procod


select tbsvalor from tab19 (nolock) where tbsnom = 'TAB16'


create function tabSequencia(@tabela char(10)) returns int as
   begin
      declare @retorno int
      exec sp_sequencial 'tab16',@retorno output
      return @retorno
   end
go

drop function seqTabela

-- conta registros da SB1010
if exists(select name from sysobjects where name='sp_sequencial' and type='P')
   drop procedure sp_sequencial
go

create procedure sp_sequencial(@tabela char(10),@retorno int output) as
   begin
      update TELLA.dbo.tab19 set tbsvalor = tbsvalor + 1 where tbsnom = @tabela
      set @retorno = (select tbsvalor from TELLA.dbo.tab19 (nolock) where tbsnom = @tabela)
   end
go

declare @res int
exec sp_sequencial 'tab16',@res output
select @res

