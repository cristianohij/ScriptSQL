-- checar leitura da tabela do excel

select * 
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP23.2.B.xlsx', 'select * from [TabelaIBPTaxSP23.2.B$]')

-- apaga dados da tabela atual

delete TBS092

-- importa dados da planilha excel

insert into TBS092 (
   NCMCOD,
   NCMDES,
   NCMDATCAD,
   NCMALIIMP,
   NCMALINAC,
   NCMEX,
   NCMCHV,
   NCMFONTAB,
   NCMVER,
   NCMVIGFIN,
   NCMVIGINI)
   select right('00000000' + Ltrim(str(codigo,8)),8),
          subString(descricao,1,255),
          getdate(),
          convert(decimal(10,4),importadosfederal),
          convert(decimal(10,4),nacionalfederal),
          isnull(subString(ex,1,2),''),
		  chave,
          subString(fonte,1,10),
          subString(versao,1,10),
          vigenciafim,
          vigenciainicio
     from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\TabelaIBPTaxSP23.1.F.xlsx', 'select * from [TabelaIBPTaxSP23.1.F$]')
    where tipo=0

-- muda descrição para letras maiúsculas

update TBS092 set NCMDES=upper(NCMDES)

-- verifica ncm na tabela de ncm por estados

select NCMCOD
  from TBS0921 (nolock)
 where not exists(select ''
                    from TBS092 (nolock)
				   where TBS092.NCMCOD=TBS0921.NCMCOD)

-- se o retornou algum resultado no select acima, rodar este abaixo para eliminar ncm que não existem mais

delete TBS0921
 where not exists(select ''
                    from TBS092 (nolock)
				   where TBS092.NCMCOD=TBS0921.NCMCOD)



