select *
  from TBS011 with (nolock)

select '|0220|'+
       Ltrim(rtrim(UNICOD))+'|'+
       replace(Ltrim(str(1,12,3)),'.',',')+'|'
  from TBS011 (nolock)

select '|0000'
       +'|118'
       +'|0'
       +'|20241201'
       +'|20241231'
       +'|MISASPEL COMERCIO DE PAPEIS LTDA'
       +'|52080207000117'
       +'|'
       +'|SP'
       +'|110763416118'
       +'|3550308'
       +'|'
       +'|'
       +'|A'
       +'|0|'

select '|0190'
       +'|'+rtriM(UNICOD)
       +'|'+rtrim(UNIDES)
  from TBS011 with (nolock)

select top(500)
       rtrim(PROCOD)
       ,rtrim(PRODES)
       ,rtrim(PROCLAFIS)
       ,10
       ,PROUM1
       ,32.5
       ,18
       ,PROSTBA+PROSTBB
       ,'1.1.1'
       ,'00'
       ,0
       ,''
       ,0
       ,''
       ,''
       ,rtrim(PROCEST)
  from TBS010 with (nolock)

select top(1) *
  from SALDOINICIAL with (nolock)

select rtrim(p.PROCOD)
       ,rtrim(PRODES)
       ,rtrim(PROCLAFIS)
       ,Ltrim(convert(varchar,floor(s.E1)))
       ,rtrim(s.UNI)
       ,Ltrim(convert(varchar,round(s.CUSTO,2)))
       ,0
       ,p.PROSTBA+p.PROSTBB
       ,'1.01.03.01.01.01'
       ,'00'
       ,0
       ,''
       ,0
       ,iif(Len(p.PROCEST)=7,rtrim(p.PROCEST),'')
  from SALDOINICIAL s with (nolock)
 inner join TBS010 p with (nolock)
     on p.PROCOD=s.CODIGO
-- inner join TBS032 e with (nolock)
     --on e.PROCOD=s.CODIGO
 where s.ANOMES='202412'
	   and (s.E1 > 0) -- or E2 > 0)
       and s.CUSTO > 0

exec sp_help 'SALDOINICIAL'


-- tanby matriz: estoque + loja

select 'tanby matriz'
       ,format(sum((s.E1 + s.E2) * s.CUSTO), 'N', 'pt-BR')
  from SALDOINICIAL s with (nolock)
 inner join TBS010 p with (nolock)
     on p.PROCOD=s.CODIGO
 where s.ANOMES='202412'
	   and (s.E1 + s.E2 > 0)
       and s.CUSTO > 0

union

-- tanby taubate: estoque + loja

select 'tanby taubaté'
       ,format(round(sum((s.E1 + s.E2) * s.CUSTO),2), 'N', 'pt-BR')
  from tt.SIBD.dbo.SALDOINICIAL s with (nolock)
 inner join tt.SIBD.dbo.TBS010 p with (nolock)
     on p.PROCOD=s.CODIGO
 where s.ANOMES='202412'
	     and (s.E1 + s.E2 > 0)
       and s.CUSTO > 0

union

-- tanby cd: estoque

select 'tanby cd'
       ,format(round(sum(s.E1 * s.CUSTO),2), 'N', 'pt-BR')
  from cd.SIBD.dbo.SALDOINICIAL s with (nolock)
 inner join cd.SIBD.dbo.TBS010 p with (nolock)
     on p.PROCOD=s.CODIGO
 where s.ANOMES='202412'
	     and (s.E1 > 0)
       and s.CUSTO > 0

union

-- best bag: loja

select 'best bag'
       ,format(round(sum(s.E2 * s.CUSTO),2), 'N', 'pt-BR')
  from bb.SIBD2.dbo.SALDOINICIAL s with (nolock)
 inner join bb.SIBD2.dbo.TBS010 p with (nolock)
     on p.PROCOD=s.CODIGO
 where s.ANOMES='202412'
	     and s.E2 > 0
       and s.CUSTO > 0

union

-- misaspel: estoque

select 'misaspel'
       ,format(round(sum(s.E1 * s.CUSTO),2), 'N', 'pt-BR')
  from mi.SIBD3.dbo.SALDOINICIAL s with (nolock)
 inner join mi.SIBD3.dbo.TBS010 p with (nolock)
     on p.PROCOD=s.CODIGO
 where s.ANOMES='202412'
	     and (s.E1 > 0)
       and s.CUSTO > 0

union

-- papelyna: estoque

select 'papelyna'
       ,format(round(sum(s.E1 * s.CUSTO),2), 'N', 'pt-BR')
  from pp.SIBD.dbo.SALDOINICIAL s with (nolock)
 inner join pp.SIBD.dbo.TBS010 p with (nolock)
    on p.PROCOD=s.CODIGO
 where s.ANOMES='202412'
	     and (s.E1 > 0)
       and s.CUSTO > 0


