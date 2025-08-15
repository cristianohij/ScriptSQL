select *
  from Categoria

-- categoria default do site
insert into Categoria (CategoriaNome,CategoriaIdRef)
select 'DEFAULT CATEGORY',2



select *
  from CategoriaSubcategoria
 order by CategoriaId, SubcategoriaId

begin tran
update CategoriaSubcategoria
   set CategoriaId=(select CategoriaId from Categoria where CategoriaIdRef=SubcategoriaIdPai)
 from CategoriaSubcategoria
rollback tran

select *
       ,(select CategoriaId from Categoria where CategoriaIdRef=SubcategoriaIdPai)
 from CategoriaSubcategoria

delete CategoriaSubcategoria
 where SubcategoriaIdPai=403

SELECT 
  ROW_NUMBER() OVER(PARTITION BY CategoriaId ORDER BY CategoriaId) 
    AS n
  ,*
into #tab
FROM CategoriaSubcategoria

select *
  from #tab

begin tran
update CategoriaSubcategoria
   set SubcategoriaId=(select n from #tab where #tab.CategoriaId=cat.CategoriaId and #tab.SubcategoriaId=cat.SubcategoriaId)
 from CategoriaSubcategoria cat
rollback tran
commit tran


update Categoria
   set CategoriaNome=upper(CategoriaNome)

update CategoriaSubcategoria
   set SubcategoriaNome=upper(SubcategoriaNome)

drop table #tab

-- tanby
select iif(Len(sku)<7, right('0000000' + sku,7),sku) as sku
       --,item
  into #tab
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produtos-site-tanby.xlsx', 'select * from [Planilha1$]')

-- papelyna
select iif(Len(sku)<7, right('0000000' + sku,7),''+sku) as sku
       ,item
  into #tab
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\produto-categoria-papelyna.xlsx', 'select * from [Planilha2$]')

select *
  from #tab
 where sku='28050001'

select *
  from #tab
 where sku Like('%_%')

delete #tab
 where RIGHT( sku,2)='_2'

delete #tab
 where sku='000.185'

delete #tab
 where sku='1170040_1.jpg'

select *
  from #tab

select iif(Len(Ltrim(sku))<7, right('0000000' + Ltrim(sku),7),sku)
       ,sku
  from #tab

update #tab
   set sku=iif(Len(sku)<7, right('0000000' + sku,7),sku)

select a.ProdutoId
       ,a.ProdutoCodigo
       ,subString(b.sku,1,15)
	   ,b.item
	   ,c.CategoriaId
	   ,c.SubcategoriaId
	   ,c.SubcategoriaIdRef
  from Produto a
       inner join #tab b
	   on a.ProdutoCodigo=b.sku collate database_default
	   inner join CategoriaSubcategoria c
	   on c.SubcategoriaIdRef=b.item
 order by ProdutoCodigo
          ,CategoriaId
		  ,SubcategoriaId

select p.ProdutoId
       ,p.ProdutoCodigo
       ,p.ProdutoNome
	     ,pc.CategoriaId
       ,c.CategoriaNome
	     ,pc.SubcategoriaId
	     ,s.SubcategoriaNome
  from Produto p
       full outer join ProdutoCategoria pc
	     on pc.ProdutoId=p.ProdutoId
	     full outer join Categoria c
	     on c.CategoriaId=pc.CategoriaId
	     full outer join CategoriaSubcategoria s
	     on s.CategoriaId=pc.CategoriaId and s.SubcategoriaId=pc.SubcategoriaId
 where c.CategoriaId is NULL
       p.ProdutoCodigo='7160021'

select *
  from ProdutoCategoria with (nolock)
 where ProdutoId=330

insert into ProdutoCategoria (ProdutoId,CategoriaId,SubcategoriaId)
select 330,6,1



select *
  from Produto with (nolock)
 where not exists(select ''
                    from ProdutoCategoria with (nolock)
                   where ProdutoCategoria.ProdutoId=Produto.ProdutoId)

select *
  from ProdutoCategoria with (nolock)
 where ProdutoCategoria.ProdutoId=(select ProdutoId
                                     from Produto with (nolock)
                                    where Produto.ProdutoCodigo='28050001')

begin tran
update Produto
   set ProdutoPreco=1
 where Produto.ProdutoCodigo='28050001'
commit TRAN

select top 1 *
  from Produto with (nolock)

select top 1 *
  from Categoria with (nolock)

select top 1 *
  from CategoriaSubcategoria with (nolock)

select top 1 *
  from ProdutoCategoria with (nolock)

select *
  from ProdutoCategoria with (nolock)
 where ProdutoId=621

select *
  from ProdutoCategoria with (nolock)
 where CategoriaId=9

-- produtos com categoria/subcategoria
insert into ProdutoCategoria (ProdutoId,CategoriaId,SubcategoriaId)
select a.ProdutoId
	   ,c.CategoriaId
	   ,c.SubcategoriaId
  from Produto a
       inner join #tab b
	   on a.ProdutoCodigo=b.sku collate database_default
	   inner join CategoriaSubcategoria c
	   on c.SubcategoriaIdRef=b.item

-- produtos somente com categoria
begin tran
insert into ProdutoCategoria (ProdutoId,CategoriaId,SubcategoriaId)
select a.ProdutoId
	   ,c.CategoriaId
     ,0
  from Produto a
       inner join #tab b
	   on a.ProdutoCodigo=b.sku collate database_default
	   inner join Categoria c
	   on c.CategoriaIdRef=b.item
commit tran

insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId)
select 11,0

select *
  from ProdutoCategoria p
 where exists (select a.ProdutoId
	   ,c.CategoriaId
     ,0
  from Produto a
       inner join #tab b
	   on a.ProdutoCodigo=b.sku collate database_default
	   inner join Categoria c
	   on c.CategoriaIdRef=b.item
     where a.ProdutoId=p.ProdutoId
           and c.CategoriaId=p.CategoriaId
)

begin tran
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaIdPai)
select c.CategoriaId
       ,0
       ,b.item
  from Produto a
       inner join #tab b
	     on a.ProdutoCodigo=b.sku collate database_default
	     inner join Categoria c
	     on c.CategoriaIdRef=b.item
 group by c.CategoriaId, b.item
commit TRAN

insert into ProdutoCategoria (ProdutoId,CategoriaId,SubcategoriaId)
select 475,11,0

select * 
  from ProdutoCategoria with (nolock)
 where SubcategoriaId=0

begin TRAN
delete ProdutoCategoria
 where SubcategoriaId=0
commit TRAN

select * 
  from CategoriaSubcategoria with (nolock)
 where SubcategoriaId=0

begin tran
delete CategoriaSubcategoria
 where SubcategoriaId=0
commit TRAN


begin tran
delete ProdutoCategoria
 where ProdutoId=475
       and CategoriaId=11
       and SubcategoriaId=0
rollback tran

select *
  from Produto with (nolock)
 where ProdutoCodigo='28050001'

update Produto
   set ProdutoCor=''
 where ProdutoCor is null

-- papelyna

insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'EMBALAGENS',389
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'DESCARTAVEIS E COPA',399
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'DESCARTAVEIS E COPA',399
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'DESCARTAVEIS E COPA',399
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'DESCARTAVEIS E COPA',399
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'DESCARTAVEIS E COPA',399
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LIMPEZA E HIGIENE',405
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ESCRITORIO',367
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'CARTUCHOS & TONERS',415
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'CARTUCHOS & TONERS',415
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'INFORMATICA',418
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'INFORMATICA',418
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'INFORMATICA',418
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'INFORMATICA',418
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'INFORMATICA',418
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'INFORMATICA',418
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'INFORMATICA',418
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'INFORMATICA',418
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ARTESANATO',427
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ARTESANATO',427
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ARTESANATO',427
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'ARTESANATO',427
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LISTAS ESCOLARES',220
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'LISTAS ESCOLARES',220
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'DESTAQUES',219
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'NOVIDADES',217
insert into Categoria (CategoriaNome,CategoriaIdRef)select 'PATROCINADOS',218

select *
  from Categoria with (nolock)

select CategoriaNome, CategoriaIdRef
  into #cat
  from Categoria with (nolock)
 group by CategoriaNome, CategoriaIdRef

select *
  from #cat

delete Categoria

DBCC CHECKIDENT ('Categoria', RESEED, 0)

insert into Categoria (CategoriaNome,CategoriaIdRef)
select *
  from #cat

select *
  from CategoriaSubcategoria with (nolock)

insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,2,'CAIXA',390,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,3,'FITA',391,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,4,'FITILHO',392,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,5,'ISOPOR',393,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,6,'PAPEL',394,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,7,'PLASTICO',395,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,8,'SACOLA',396,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,9,'SACO',397,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,10,'TNT',398,389
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,11,'COPOS',400,399
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,12,'FRASCOS',401,399
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,13,'GUARDANAPO',402,399
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,14,'PRATO',403,399
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,15,'POTE',404,399
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,16,'DETERGENTE',406,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,17,'ESPONJAS E FLANELAS',407,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,18,'LUVA',408,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,19,'PAPEL HIGIENICO',409,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,20,'PAPEL INTERFOLHA',410,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,21,'PROTETORES',412,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,22,'PANO',411,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,23,'SACO ALVEJADO',413,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,24,'VASSOURA',414,405
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,25,'ARQUIVO MORTO',368,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,26,'BORRACHA',369,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,27,'CANETA ESFEROGRAFICAS',370,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,28,'CANETA MARCA TEXTO',371,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,29,'CANETA P/ QUADRO BRANCO',372,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,30,'CRACHA',373,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,31,'CLIPES',374,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,32,'ESTILETE',375,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,33,'ELASTICO',376,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,34,'ENVELOPE',377,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,35,'EXPOSITOR',378,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,36,'FITA',379,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,37,'GRAMPEADOR',380,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,38,'GRAMPO',381,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,39,'MARCADOR',382,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,40,'PASTA',384,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,41,'PRANCHETA',385,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,42,'PROTETOR',386,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,43,'QUADRO',388,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,44,'TINTA',387,367
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,45,'HP',416,415
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,46,'EPSON',417,415
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,47,'BASE P/ MOUSE',419,418
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,48,'BOBINAS FISCAIS',420,418
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,49,'BOBINAS NAO FISCAL',421,418
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,50,'CALCULADORA',422,418
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,51,'FITA & RIBON',423,418
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,52,'PAPEIS ESPECIAIS',424,418
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,53,'PENDRIVE',425,418
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,54,'PILHAS E BATERIAS',426,418
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,55,'COLAS',428,427
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,56,'PINCEL',429,427
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,57,'TELA',430,427
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,58,'TRINCHA',431,427
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,59,'Mater Dei',221,220
insert into CategoriaSubcategoria (CategoriaId,SubcategoriaId,SubcategoriaNome,SubcategoriaIdRef,SubcategoriaIdPai) select 1,60,'ESCOLA 2',222,220
