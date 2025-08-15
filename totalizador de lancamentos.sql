select TBS0671.NFSCFOP as 'CFOP',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))   else 0 end as 'valor',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))   else 0 end as 'valor-cancelado',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSBASICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'base-ICMS',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSBASICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'base-ICMS-cancelado',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'valor-icms',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'valor-icms-cancelado',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSBASICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'base-ICMS-orgao-publico',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSBASICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'base-ICMS-orgao-publico-cancelado',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSVALICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'valor-ICMS-orgao-publico',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSVALICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'valor-ICMS-orgao-publico-cancelado',
       case when TBS0671.NFSPBI < 100 then sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'outros-ICMS'
  from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
 where TBS067.NFSDATEMI between '20121201' and '20121231'
 group by TBS067.NFSCAN,TBS0671.NFSCFOP,TBS0671.NFSPBI
 order by TBS0671.NFSCFOP

select TBS0671.NFSCFOP,TBS0671.NFSCST,TBS0671.NFSPBI,
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)),
       sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))
  from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
 where TBS067.NFSDATEMI between '20121201' and '20121231' and TBS067.NFSCAN = 'N'
 group by TBS0671.NFSCFOP,TBS0671.NFSCST,TBS0671.NFSPBI
 order by TBS0671.NFSCFOP

select TBS0671.NFSCFOP as 'CFOP',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))   else 0 end as 'valor',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))   else 0 end as 'valor-cancelado',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSBASICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'base-ICMS',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSBASICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'base-ICMS-cancelado',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'valor-icms',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'valor-icms-cancelado',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSBASICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'base-ICMS-orgao-publico',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSBASICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'base-ICMS-orgao-publico-cancelado',
       case when TBS067.NFSCAN <> 'S' then sum(dbo.NFSVALICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'valor-ICMS-orgao-publico',
       case when TBS067.NFSCAN =  'S' then sum(dbo.NFSVALICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'valor-ICMS-orgao-publico-cancelado',
       case when sum(dbo.NFSBASICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) = 0 then sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'outros-ICMS'
  from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
 where TBS067.NFSDATEMI between '20121201' and '20121231'
 group by TBS067.NFSCAN,TBS0671.NFSCFOP
 order by TBS0671.NFSCFOP


-- rodar este aqui

select TBS067.NFSTIP as 'tipo-NF',
       TBS0671.NFSCFOP as 'CFOP',
       case when TBS067.NFSCAN = 'N' then sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))   else 0 end as 'valor',
       case when TBS067.NFSCAN = 'S' then sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))   else 0 end as 'valor-cancelado',
       case when TBS067.NFSCAN = 'N' then sum(dbo.NFSBASICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'base-ICMS',
       case when TBS067.NFSCAN = 'S' then sum(dbo.NFSBASICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'base-ICMS-cancelado',
       case when TBS067.NFSCAN = 'N' then sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'valor-icms',
       case when TBS067.NFSCAN = 'S' then sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE))    else 0 end as 'valor-icms-cancelado',
       case when TBS067.NFSCAN = 'N' then sum(dbo.NFSBASICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'base-ICMS-orgao-publico',
       case when TBS067.NFSCAN = 'S' then sum(dbo.NFSBASICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'base-ICMS-orgao-publico-cancelado',
       case when TBS067.NFSCAN = 'N' then sum(dbo.NFSVALICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'valor-ICMS-orgao-publico',
       case when TBS067.NFSCAN = 'S' then sum(dbo.NFSVALICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'valor-ICMS-orgao-publico-cancelado',
       case when TBS0671.NFSPBI = 0 then sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'outros-ICMS'
  from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
 where TBS067.NFSDATEMI between '20121201' and '20121231'
 group by TBS067.NFSTIP,TBS067.NFSCAN,TBS0671.NFSCFOP,TBS0671.NFSPBI
 order by TBS067.NFSTIP,TBS067.NFSCAN,TBS0671.NFSCFOP,TBS0671.NFSPBI

select distinct TBS067.NFSCAN
  from TBS067 (nolock)
 where TBS067.NFSDATEMI between '20121201' and '20121231'


drop function NFSCAN
go

create function NFSCAN(@empresa smallint ,@nf int) returns int as
   begin
      declare @retorno int
      set @retorno = (select 1 from TBS067 (nolock) where NFSEMPCOD = @empresa and NFSNUM = @nf and NFSCAN = 'S')
      return @retorno
   end
go


select TBS0671.NFSCFOP as 'CFOP',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) as 'valor',
       sum(dbo.NFSBASICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) as 'base-ICMS',
       sum(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) as 'valor-icms',
       sum(dbo.NFSBASICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) as 'base-ICMS-orgao-publico',
       sum(dbo.NFSVALICMSISE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) as 'valor-ICMS-orgao-publico',
       case when TBS0671.NFSPBI = 0 then sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.NFSITE)) else 0 end as 'outros-ICMS'
  from TBS0671 (nolock) join TBS067 (nolock) on TBS067.NFSEMPCOD = TBS0671.NFSEMPCOD and TBS067.NFSNUM = TBS0671.NFSNUM
 where TBS067.NFSDATEMI between '20121201' and '20121231' and TBS067.NFSCAN = 'N'
 group by TBS0671.NFSCFOP,TBS0671.NFSPBI
 order by TBS0671.NFSCFOP


   &aENFSIT( 1) = 'Em Digitacao'
    &aENFSIT( 2) = 'Dados Validos'
    &aENFSIT( 3) = 'Dados Invalidos'
    &aENFSIT( 4) = 'XML Gerado'
    &aENFSIT( 5) = 'Assinada'
    &aENFSIT( 6) = 'Autorizada'
    &aENFSIT( 7) = 'Cancelada'
    &aENFSIT( 8) = 'Denegada'
    &aENFSIT( 9) = 'Processamento na Sefaz'
    &aENFSIT(10) = 'Rejeitada'
    &aENFSIT(11) = 'Inutilizada'
    &aENFSIT(12) = 'Servico Paralisado'
    &aENFSIT(13) = 'Contingencia via DPEC'
    &aENFSIT(20) = 'Outras'

select count(*),
       case ENFSIT
          when  1 then 'Em digitacao'
          when  2 then 'Dados validos'
          when  3 then 'Dados invalidos'
          when  4 then 'XML gerado'
          when  5 then 'Assinada'
          when  6 then 'Autorizada'
          when  7 then 'Cancelada'
          when  8 then 'Denegada'
          when  9 then 'Em processamento na Sefaz'
          when 10 then 'Rejeitada'
          when 11 then 'Inutilizada'
          when 12 then 'Servico paralizado'
          when 13 then 'Contingencia via DPEC'
          when 20 then 'Outras'
       end
  from TBS080 (nolock)
 where ENFDATEMI between '20130101' and '20130131'
 group by ENFSIT