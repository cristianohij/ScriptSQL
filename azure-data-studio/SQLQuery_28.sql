if object_id('tempdb.dbo.#empresas_grupo') is not null
   drop table #empresas_grupo

select '05118717000156' as 'cnpj' -- best bag
  into #empresas_grupo
union
select '52080207000117' -- misaspel
union
select '44125185000136' -- papelyna
union
select '65069593000350' -- tanby cd
union
select '65069593000198' -- tanby matriz
union
select '65069593000279' -- tanby taubaté
union
select '41952080000162' -- winpack

--select getdate()+1

declare @datai date, @dataf date

select @dataf = convert(date,(getdate())-1,112)

set @datai = iif((select datepart(weekday,getdate()))=2, dateadd(day, -2, @dataf), @dataf)

select convert(date,NEEDATEMI,112) as 'emissao'
       ,rtrim(NEENOM) as 'emitente'
       ,NEEUFESIG as 'uf_origem'
       ,NEENUM as 'num_nota'
       ,rtrim(NEENATOPE) as 'natureza'
       ,iif(Len(NEECGCCPF)=14, dbo.FormatarCnpj(NEECGCCPF), dbo.FormatarCpf(NEECGCCPF)) as 'cnpj_cpf'
       ,NEEVALPRO as 'valor_produtos'
       ,NEEVALTOT as 'valor_nota'
       ,NEEVALFRE as 'valor_frete'
       ,NEEVALIPI as 'valor_ipi'
       ,NEEVALICMSST as 'valor_icms_st'
       ,NEEVALOUTDES as 'valor_outras_despesas'
       ,NEEVALSEG as 'valor_seguro'
       ,Left(NEECHAACE,4)+' '+subString(NEECHAACE,5,4)+' '+subString(NEECHAACE,9,4)+' '+subString(NEECHAACE,13,4)+' '+subString(NEECHAACE,17,4)+' '+subString(NEECHAACE,21,4)+' '+subString(NEECHAACE,25,4)+' '+subString(NEECHAACE,29,4)+' '+subString(NEECHAACE,33,4)+' '+subString(NEECHAACE,37,4)+' '+right(NEECHAACE,4) as 'chave'
  from TBS099 with (nolock)
 where convert(date,NEEDATEMI,112) between @datai and @dataf
       and NEECGCCPF not in(select cnpj from #empresas_grupo)

 order by NEEDATEMI, NEENOM


declare @datai date, @dataf date

select @dataf = convert(date,(getdate())-1,112)

set @datai = iif((select datepart(weekday,getdate()))=2, dateadd(day, -2, @dataf), @dataf)

select @datai, @dataf

select *
  from TBS010 with (nolock)
 where PROCOD='1640054'



