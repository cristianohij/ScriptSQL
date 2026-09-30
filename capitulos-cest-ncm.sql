-- remover tabela temporária
if OBJECT_ID('tempdb..#NCM_capitulo;') IS NOT NULL
   DROP TABLE #NCM_capitulo;

select Column1#Codigo as capitulo
       ,Column1#Descricao as descricao
  into #NCM_capitulo
  --into #ncm_antiga
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\Tabela_NCM_Vigente_20250918.xlsx', 'select * from [Tabela_NCM_Vigente_20250918$]')
 where Len(Column1#Codigo) = 2

select *
  from #NCM_capitulo

select pro.PROCOD as codigo
       ,pro.PROCLAFIS as NCM
       ,pro.PRODES as descricao
       ,ncm.capitulo as NCM_capitulo
       ,ncm.descricao as NCM_descricao_capitulo
  from TBS010 pro with (nolock)
 inner join #NCM_capitulo ncm
         on Left(pro.PROCLAFIS,2) = ncm.capitulo collate database_default

select Left(PROCLAFIS,2)
  from TBS010 with (nolock)
 group by Left(PROCLAFIS,2)
 order by Left(PROCLAFIS,2)

select PROCLAFIS
       ,PROCOD
       ,PRODES
  from TBS010 with (nolock)
 where Left(PROCLAFIS,2) = '25'


