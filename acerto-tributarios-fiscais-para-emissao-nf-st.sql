select top 1 * from TBS110 (nolock)
select top 1 * from tt.SIBD.dbo.TBS110

select top 1 * from TBS1101 (nolock)
select top 1 * from tt.SIBD.dbo.TBS1101

delete tt.SIBD.dbo.TBS110

insert into tt.SIBD.dbo.TBS110 select * from TBS110 (nolock)

delete tt.SIBD.dbo.TBS1101

insert into tt.SIBD.dbo.TBS1101 select * from TBS1101 (nolock)

select * from py.SIBD.dbo.TBS039 (nolock) where CSTTAB='B'

select * from TANBYM.SIBD.dbo.TBS039 where CSTTAB='B'

update TANBYM.SIBD.dbo.TBS039 set CSTICMS='S' where CSTTAB='B' and CSTCOD in('00','10','20','51','70','90')

update TANBYM.SIBD.dbo.TBS039 set CSTBASRED=(select CSTBASRED from TBS039 as A (nolock) where A.CSTTAB=B.CSTTAB and A.CSTCOD=B.CSTCOD)
  from TANBYM.SIBD.dbo.TBS039 as B
 where CSTTAB='B'

update TANBYM.SIBD.dbo.TBS039 set CSTICMSST=(select CSTICMSST from TBS039 as A (nolock) where A.CSTTAB=B.CSTTAB and A.CSTCOD=B.CSTCOD)
  from TANBYM.SIBD.dbo.TBS039 as B
 where CSTTAB='B'

-- finalidade da aquisição da mercadoria
select * from py.SIBD.dbo.TBS002 where CLIFINAQU=''

update py.SIBD.dbo.TBS002 set CLIFINAQU='C' where CLIFINAQU=''

-- classificação fiscal
select * from SIBD.dbo.TBS0921

select count(*) from py.SIBD.dbo.TBS092

select count(*) from SIBD.dbo.TBS092

select * from master..sysservers

delete py.SIBD.dbo.TBS0921

insert into py.SIBD.dbo.TBS0921 select * from SIBD.dbo.TBS0921

select * from TBS025 (nolock) where PARCHV=1285

insert TBS025 select 1285,'CRIAR SALDO NESTES LOCAIS ESTOQUE NA IMPORTACAO DE PRODUTOS','C','1/2',getdate()

-- usuários com acesso
select * from py.SIBD.dbo.TBS025 (nolock) where PARCHV=1286

update py.SIBD.dbo.TBS025 set PARVAL='NFCOMST' where PARCHV=1286

