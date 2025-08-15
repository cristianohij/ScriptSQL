select distinct UF,Nome_UF,Municipio,Municipio_Nome from MUNICIPIOS order by Nome_UF,Municipio_Nome

--select * from TBS001 order by UFENOM

select * from TBS001 where UFENOM=''
delete TBS001 where UFENOM=''

select distinct UF,Nome_UF from MUNICIPIOS

update TBS001 set UFECODIBGE=select distinct UF,Nome_UF from MUNICIPIOS

update TBS001 set UFECODIBGE=UF from TBS001 join MUNICIPIOS on UFENOM=Nome_UF
select distinct UFESIG,UFENOM,UF,Nome_UF from TBS001 join MUNICIPIOS on UFENOM=Nome_UF

select * from TBS001 order by UFECODIBGE


select distinct UFESIG,Municipio,Municipio_Nome from TBS001 join MUNICIPIOS on UFECODIBGE=UF order by UFESIG,Municipio

select * from MUNICIPIOS A
 where (select count(*) from MUNICIPIOS B where B.UF=A.UF and B.Municipio=A.Municipio)>1
 order by UF,Municipio


insert into TBS003
select distinct UFESIG,Municipio,Municipio_Nome from TBS001 join MUNICIPIOS on UFECODIBGE=UF order by UFESIG,Municipio

select * from PAISES

update PAISES set Pais=upper(Pais)

select * from TBS071
insert into TBS071 select *,getdate() from PAISES

select * from PAISES A
 where (select count(*) from PAISES B where B.Codigo=A.Codigo)>1
 order by Codigo

update TBS071 set PAIDATCAD=getdate()