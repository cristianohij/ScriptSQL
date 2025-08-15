select * into #sped from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\spedinv.xlsx', 'select * from [dados$]')

select * from #sped

select *
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\sped0615tella.xlsx', 'select * from [Plan3$]')

select '"'+codigo+'",'+
       '06/2015,'+
	   rtrim(convert(char(12),convert(decimal(8,4),qtde)))+','+
	   rtrim(convert(char(12),convert(decimal(8,4),preco)))+','+
	   '0.0000,'+
	   rtrim(convert(char(12),convert(decimal(12,4),total)))+','+
	   '1,'+
	   '"",'+
	   '"01.1.2.10.001",'+
	   '"",'+
	   '0.0000,'+
	   '"",'+
	   '0.0000'
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\sped0615tella.xlsx', 'select * from [Plan3$]') 


-- 

select * from spedinv where codigo is null

delete spedinv where codigo is null

select codigo,descricao from spedinv where not exists(select '' from TBS010 (nolock) where PROCOD=codigo)

update spedinv set descricao=PRODES from TBS010 (nolock) where PROCOD=codigo

select * from spedinv

select sum(total) from spedinv


select '"'+rtrim(codigo)+'",'+
       '09/2015,'+
	   rtrim(convert(char(12),convert(decimal(8,4),qtde)))+','+
	   rtrim(convert(char(12),convert(decimal(8,4),preco)))+','+
	   '0.0000,'+
	   rtrim(convert(char(12),convert(decimal(12,4),total)))+','+
	   '1,'+
	   '"",'+
	   '"01.1.2.10.001",'+
	   '"",'+
	   '0.0000,'+
	   '"",'+
	   '0.0000'
  from spedinv
