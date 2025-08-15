select produto,fabricante,codigo,cod_interno,fornecedor
  from FAB join AL0601 on produto=cod_interno

update FAB set codigo=fornecedor from FAB join AL0601 on produto=cod_interno

select * from TBS028

select distinct 0,codigo,fabricante,getdate() from FAB order by codigo

insert into TBS028 select distinct 0,codigo,fabricante,getdate() from FAB order by codigo

   alter table TBS028 add codigo int default 0


   -- gera codigos sequencias para os fabricantes
   update TBS028 set codigo=FABCOD

   update TBS028 set FABCOD=0

   -- gera codigos sequencias para os fabricantes
   declare @contador int
   declare @registro varchar(6)

   set @contador = 0
   set @registro = (select top 1 codigo from TBS028 where FABCOD=0 order by codigo)

   while((select count(*) from TBS028 where FABCOD=0) > 0)
      begin
         update TBS028 set FABCOD=@contador +1 where FABCOD=0 and codigo=@registro
         
	 set @contador = @contador +1
         set @registro = (select top 1 codigo from TBS028 where FABCOD=0 order by codigo)

         if((select count(*) from TBS028 where FABCOD=0) > 0)
            continue
         else 
            break
      end


update FAB set novoCodigo=FABCOD 





select produto,fabricante,FAB.codigo,novoCodigo,TBS028.codigo,FABCOD,FABNOM
  from FAB join TBS028 on FAB.codigo=TBS028.codigo


update FAB set novoCodigo=FABCOD from FAB join TBS028 on FAB.codigo=TBS028.codigo


update FAB set novoCodigo=FABCOD from FAB join TBS028 on FAB.codigo=TBS028.codigo
select * from TBS028

select distinct codigo,fabricante from FAB order by fabricante

select * from TBS010

update TBS010 set MARCOD=novoCodigo,MARNOM=fabricante from FAB join TBS010 on FAB.produto=PROCOD

update TBS010 set MARCOD=novoCodigo,MARNOM=fabri

select * from TBS010 where MARNOM is null
select * from TBS010 where MARCOD is null

select * from TBS028 A
 where (select count(*) from TBS028 B where B.FABNOM=A.FABNOM)>1
 order by FABNOM


select * from TBS014 A
 where (select count(*) from TBS014 B where B.MARNOM=A.MARNOM)>1
 order by MARNOM


select * from TBS014 order by MARCOD


