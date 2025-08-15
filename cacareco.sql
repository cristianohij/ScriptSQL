select *
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=c:\temp\helio.xlsx', 'select * from [Plan1$]')

select ltrim(str(codigo,10)) as 'produto'
  into #codigos
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=c:\temp\helio.xlsx', 'select * from [Plan1$]')

select * from #codigos

select produto,replicate('0', 7 - Len(produto)) + rtrim(produto) from #codigos where Len(produto)<8

update #codigos set produto=replicate('0', 7 - Len(produto)) + rtrim(produto) from #codigos where Len(produto)<8

select produto,Len(rtrim(produto)),case when Len(produto)<8 then replicate('0', 7 - Len(rtrim(produto))) + rtrim(produto) else produto end from #codigos

drop table #codigos

select ''''+rtrim(produto)+''',' from #codigos

select produto from #codigos where not exists(select '' from ProdutosSemGiro where CodigoDoProduto=produto collate database_default)

select produto)+''',' from #codigos
