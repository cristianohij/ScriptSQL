declare @atualizacaoDe datetime, @atualizacaoAte datetime, @produtoDe char(15), @produtoAte char(15),
		@alteracaoDe datetime, @alteracaoAte datetime

set @atualizacaoDe  = '' --AAAAMMDD
set @atualizacaoAte = '' --AAAAMMDD
set @alteracaoDe  = '' --AAAAMMDD
set @alteracaoAte = '' --AAAAMMDD
set @produtoDe  = ''
set @produtoAte = ''

select PROCOD PRODUTO, TBS010.PRODES DESCRICAO, MARCOD MARCA, MARNOM MARCA, 
	   PROUM1 UM1, isnull(TDPPRECOR1,0) CORPORATIVO1, PROUM2, isnull(TDPPRECOR2,0) CORPORATIVO2,
	   PROUM1 UM1, isnull(TDPPRELOJ1,0) LOJA1, PROUM2 UM2, isnull(TDPPRELOJ2,0) LOJA2, 
	   PROUM1 UM1, isnull(TDPPREREV1,0) REVENDA1, PROUM2 UM2, isnull(TDPPREREV2,0) REVENDA2,
	   PROUM1 UM1, isnull(TDPPREWE11,0) WEB11, PROUM2 UM2, isnull(TDPPREWE12,0) WEB12,
	   PROUM1 UM1, isnull(TDPPREWE21,0) WEB21, PROUM2 UM2, isnull(TDPPREWE22,0) WEB22,
																					   case when PDPDATALT = '17530101' then 'SEM ALTERACAO'
																							else isnull(convert(char(20),PDPDATALT,113),'SEM ALTERACAO') end ALTERACAO
																					 , case when TDPDATATU = '17530101' then 'SEM ATUALIZACAO'
																							else isnull(convert(char(20),TDPDATATU,113),'SEM ATUALIZACAO') end ATUALIZACAO
from TBS010(nolock) left join TBS031(nolock) on TDPPROCOD = PROCOD
	                left join TBS015(nolock) on PDPCOD = PROCOD
where ((TDPDATATU between @atualizacaoDe and @atualizacaoAte) or (@atualizacaoDe = '' and @atualizacaoAte = ''))
  and ((PDPDATALT between @alteracaoDe and @alteracaoAte) or (@alteracaoDe = '' and @alteracaoAte = ''))  
  and ((TDPPROCOD >= @produtoDe and TDPPROCOD <= @produtoAte) or (@produtoDe = '' and @produtoAte = ''))
