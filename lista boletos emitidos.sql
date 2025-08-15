select PFXCOD as 'prefixo',CRETIT as 'titulo',CREPAR as 'parcela',CLICOD as 'cliente',CLINOM as 'razao_social',
       convert(char(8),CREDATEMI,3) as 'emissao',convert(char(8),CREDATVENREA,3) as 'vencto_real',
       CREIMPBOLRES as 'boleto_impresso',TBS056.BANCOD as 'banco',TBS056.BANNUMAGE as 'agencia',BANNOM as 'nome_banco',
       case CREDATBAI
          when '17530101' then ''
          else convert(char(8),CREDATBAI,3)
       end
       as 'baixado'
  from TBS056 (noLock) join TBS007 (noLock) on TBS056.BANCOD=TBS007.BANCOD
 where '20'+subString(CREIMPBOLRES,7,2)+subString(CREIMPBOLRES,4,2)+subString(CREIMPBOLRES,1,2)
       between '20080101' and '20091231'