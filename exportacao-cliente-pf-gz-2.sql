select COMCOD
       ,*
  from TBS010 with (nolock)
 where PRODATCAD = '20251210'
       and COMCOD = 1556
 order by PRODES


select Left(Ltrim(cli.CLIBAI),30) as bairro                                                                                                                                                                        --  1. bairro
       ,Left(Ltrim(replace(cli.CLICEP,'-','')),8) as cep                                                                                                                                                           --  2. CEP
           ,'' as cnpj                                                                                                                                                                                             --  3. cnpj
           ,cli.CLICOD as codigo                                                                                                                                                                                   --  4. codigo
           ,0 as codigoAcordo                                                                                                                                                                                      --  5. codigoAcordo
           ,0 as codigoTabelaPreo                                                                                                                                                                                  --  6. codigoTabelaPreco
           ,Left(Ltrim(CLICPLEND),20) as complemento                                                                                                                                                               --  7. complemento
           ,Left(cli.CLICPF,3) + '.' + subString(cli.CLICPF,3,3) + '.' + subString(cli.CLICPF,7,3) + '-' + right(rtrim(cli.CLICPF),2)           --  8. cpf
       ,Left(Ltrim(dbo.fn_ExtraiSomenteNumeros(CLITEL) + replicate(' ',2)),2) as dddTelefone                                                                                    --  9. dddTelefone
           ,rtrim(Left(Ltrim(cli.CLIEMAIL),100)) as email                                                                                                                                                          -- 10. email
           ,cli.MUNCOD as ibgeMunicipio                                                                                                                                                                             
-- 11. ibgeMunicipio
           ,'false' as identificaPlaca                                                                                                                                                                             -- 12. identificaPlaca
           ,replicate(' ',4) as ie                                                                                                                                                                                 -- 13. ie
           ,'NAO_CONTRIBUINTE' as indicadorIe                                                                                                                                                                       
        -- 14. indicadorIe
           ,0 as limite                                                                                                                                                                                            -- 15. limite
           ,Left(Ltrim(cli.CLIEND),60) as logradouro                                                                                                                                                               -- 16. logradouro
           ,1 as loja                                                                                                                                                                                              -- 17. loja
           ,Left(Ltrim(cli.CLINOM),50) as nome                                                                                                                                                                     -- 18. nome
           ,iif(cli.CLINOMFAN='',' ',Left(Ltrim(cli.CLINOMFAN),15)) as nomeFantasia                                                                                                                     -- 19. nomeFantasia
           ,cli.CLINUM as numero                                                                                                                                                                                   -- 20. numero
           ,Left(Ltrim(cli.CLINOM),50) as razaoSocial                                                                                                                                                              -- 21. razaoSocial
           ,cli.CLIRG as rg                                                                                                                                                                                        -- 22. rg
           ,'LIBERADO' as situacao                                                                                                                                                                                 -- 23. situacao
           ,subString(Ltrim(dbo.fn_ExtraiSomenteNumeros(CLITEL) + replicate(' ',9)),3,9) as telefone                                                                            -- 24. telefone
           ,'FINAL' as tipoCliente                                                                                                                                                                                 -- 25. tipoCliente
           ,'' as validade                                                                                                                                                                                         -- 26. validade

  from TBS002 cli with (nolock)
 where cli.CLITIPPES = 'F'
       and dbo.fn_EmailValido(cli.CLIEMAIL) = 1
     and cli.CLIDATCAD between '20251201' and '20251210'