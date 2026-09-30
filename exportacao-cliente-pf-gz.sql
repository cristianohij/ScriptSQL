select rtrim(Left(Ltrim(cli.CLIBAI),30)) as bairro																							--  1. bairro
       ,rtrim(Left(Ltrim(replace(cli.CLICEP,'-','')),8)) as cep																				--  2. CEP
	   --,'' as cnpj																															--  3. cnpj
	   ,cli.CLICOD as codigo																												--  4. codigo
	   ,0 as codigoAcordo																													--  5. codigoAcordo
	   ,0 as codigoTabelaPreo																												--  6. codigoTabelaPreco
	   ,rtrim(Left(Ltrim(CLICPLEND),20)) as complemento																						--  7. complemento
	   	--  8. cpf
	   ,rtrim(replace(replace(Left(cli.CLICPF,3) + '.' + subString(cli.CLICPF,4,3) + '.' + subString(cli.CLICPF,7,3) + '-' + right(rtrim(cli.CLICPF),2),'.',''),'-','')) as cpf
       ,rtrim(Left(Ltrim(dbo.fn_ExtraiSomenteNumeros(CLITEL) + replicate('00',2)),2)) as dddTelefone											--  9. dddTelefone
	   ,rtrim(Left(Ltrim(cli.CLIEMAIL),100)) as email																						-- 10. email
	   ,right(cast(cli.MUNCOD as varchar),7) as ibgeMunicipio																				-- 11. ibgeMunicipio
	   ,'false' as identificaPlaca																											-- 12. identificaPlaca
	   --,replicate(' ',4) as ie																												-- 13. ie
	   --,'NAO_CONTRIBUINTE' as indicadorIe																					            	-- 14. indicadorIe
	   --,0 as limite																															-- 15. limite
	   ,rtrim(Left(Ltrim(cli.CLIEND),60)) as logradouro																						-- 16. logradouro
	   ,3 as loja																															-- 17. loja
	   ,rtrim(Left(Ltrim(cli.CLINOM),50)) as nome																							-- 18. nome
	   --,iif(cli.CLINOMFAN='',' ',rtrim(Left(Ltrim(cli.CLINOMFAN),15))) as nomeFantasia														-- 19. nomeFantasia
	   ,dbo.fn_ExtraiSomenteNumeros(Ltrim(rtrim(CLINUM))) as numero																											-- 20. numero
	   --,Left(Ltrim(cli.CLINOM),50) as razaoSocial																							-- 21. razaoSocial
	   ,iif(cli.CLIRG <> '',rtrim(cli.CLIRG) , replicate('0',8)) as rg																		-- 22. rg
	   ,'LIBERADO' as situacao																												-- 23. situacao
	   --,Left(Ltrim(replicate(replicate(replicate(cli.CLITEL,'(',''),')',''),'-','')),15) as telefone																							-- 24. telefone
	   ,iif(Len(Left(dbo.fn_formata_telefone(rtrim(Ltrim(dbo.fn_ExtraiSomenteNumeros(cli.CLITEL)))),9)) < 7 ,'0000000', Left(dbo.fn_formata_telefone(rtrim(Ltrim(dbo.fn_ExtraiSomenteNumeros(cli.CLITEL)))),9)) as telefone										-- 24. telefone
	   ,'FINAL' as tipoCliente																												-- 25. tipoCliente
	   --,'20391231' as validade																												-- 26. validade

  from TBS002 cli with (nolock)
 where cli.CLITIPPES = 'F'
       --and dbo.fn_EmailValido(cli.CLIEMAIL) = 1







