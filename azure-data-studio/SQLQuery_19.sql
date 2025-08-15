select tab.localizados
       ,tab.q_produtos
	   ,convert(decimal(9), tab.localizados * 100.0 / tab.q_produtos) as 'porcentagem'
  from (
         select (select count(*) from TBS010 with (nolock) where PROLOCFIS != '') as 'localizados',
                (select count(*) from TBS032 with (nolock) where ESTLOC=1 and ESTQTDATU > 0) as 'q_produtos'
        ) tab

