--  nome dos campos que devem aparecer na primeira linha do arquivo
print 'CODIGO;DESCRICAO;UNIDADE1;UNIDADE2;EMBALAGEM;PRECO1;PRECO2;MARCA'


-- grava produtos filtro pelo codigo De / Ate e que tenham segunda unidade de medida cadastrada

declare @proDe varchar(15),@proAte varchar(15)

set @proDe = '164'
set @proAte = '1649999'

select rTrim(PROCOD)+';'+rTrim(PRODES)+';'+PROUM1+';'+PROUM2+' C/;'+Ltrim(str(PROUM2QTD,9,0))+' '+PROUM1+';'+
       replace(Ltrim(str(TDPPRELOJ1,10,2)),'.',',')+';'+'R$ '+replace(Ltrim(str(TDPPRELOJ2*PROUM2QTD,10,2)),'.',',')+';'+
       rTrim(MARNOM)
  from TBS010 join TBS031 on PROCOD=TDPPROCOD
 where PROCOD between @proDe and @proAte and PROUM2QTD > 1

-- fim



-- grava produtos filtro pelo codigo De / Ate e que NAO tenham segunda unidade de medida cadastrada
declare @proDe varchar(15),@proAte varchar(15)

set @proDe = '164'
set @proAte = '1649999'

select rTrim(PROCOD)+';'+rTrim(PRODES)+';'+PROUM1+';;;'+replace(Ltrim(str(TDPPRELOJ1,10,2)),'.',',')+';;'+
       rTrim(MARNOM)
  from TBS010 join TBS031 on PROCOD=TDPPROCOD
 where PROCOD between @proDe and @proAte and PROUM2QTD = 0

-- fim



-- grava produtos filtra por varios codigos e que tenham segunda unidade de medida cadastrada

select rTrim(PROCOD)+';'+rTrim(PRODES)+';'+PROUM1+';'+PROUM2+' C/;'+Ltrim(str(PROUM2QTD,9,0))+' '+PROUM1+';'+
       replace(Ltrim(str(TDPPRELOJ1,10,2)),'.',',')+';'+'R$ '+replace(Ltrim(str(TDPPRELOJ2*PROUM2QTD,10,2)),'.',',')+';'+
       rTrim(MARNOM)
  from TBS010 join TBS031 on PROCOD=TDPPROCOD
 where PROCOD in('1640054','1170368','8470030') and PROUM2QTD > 1

-- fim



-- grava produtos filtra por varios codigos e que NAO tenham segunda unidade de medida cadastrada
print 'CODIGO;DESCRICAO;UNIDADE1;UNIDADE2;EMBALAGEM;PRECO1;PRECO2;MARCA'
select rTrim(PROCOD)+';'+rTrim(PRODES)+';'+PROUM1+';;;'+replace(Ltrim(str(TDPPRELOJ1,10,2)),'.',',')+';;'+
       rTrim(MARNOM)
  from TBS010 join TBS031 on PROCOD=TDPPROCOD
 where PROCOD in('1640054','1170368','8470030') and PROUM2QTD = 0

-- fim