-- tabela temporária
if object_id('TempDB.dbo.#POLITICA') is not null
   drop table #POLITICA;

declare @tabela char(2);

set @tabela='C';

while @tabela in('C','L','R','W1','W2')
   begin

-- carrega registro da planilha do excel
select CODIGO,
       convert(decimal(12,4),case @tabela when 'C' then MKP1COR when 'L' then MKP1LOJ when 'W1' then MKP1WE1 when 'W2' then MKP1WE2 when 'R' then MKP1REV end) as 'MARKUP1',
       convert(decimal(12,4),case @tabela when 'C' then MKP2COR when 'L' then MKP2LOJ when 'W1' then MKP2WE1 when 'W2' then MKP2WE2 when 'R' then MKP2REV end) as 'MARKUP2'
       into #POLITICA 
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\polpapelyna.xlsx', 'select * from [1906$]') 
       join TBS015 (nolock) on PDPCOD collate database_default=CODIGO;

-- custo da mercadoria
alter table #POLITICA add CUSTO smallmoney default 0 with values;

-- decimais
alter table #POLITICA add DECTRUNC1 decimal(12,2) default 0 with values;
alter table #POLITICA add DECCENT1 int default 0 with values;
alter table #POLITICA add DECDEZE1 int default 0 with values;

alter table #POLITICA add DECTRUNC2 decimal(12,2) default 0 with values;
alter table #POLITICA add DECCENT2 int default 0 with values;
alter table #POLITICA add DECDEZE2 int default 0 with values;

-- preços
alter table #POLITICA add PRECO1 smallmoney default 0 with values;
alter table #POLITICA add PRECO2 smallmoney default 0 with values;

-- preços arredondados
alter table #POLITICA add PREVENDA1 smallmoney default 0 with values;
alter table #POLITICA add PREVENDA2 smallmoney default 0 with values;

-- reduções
alter table #POLITICA add REDUCAO1 smallmoney default 0 with values;
alter table #POLITICA add REDUCAO2 smallmoney default 0 with values;

-- segunda unidade de medida do produto
alter table #POLITICA add EMB2 char(2) default '' with values;

-- unidades de medidas dos produtos
update #POLITICA set EMB2=PROUM2
  from TBS010 (nolock) right join #POLITICA on CODIGO=PROCOD collate database_default;

-- custo da mercadoria
update #POLITICA set CUSTO=dbo.PDPCUSBAS(PDPEMPCOD,PDPCOD)
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

-- preços
update #POLITICA set PRECO1=dbo.PDPCUSBAS(PDPEMPCOD,PDPCOD)/case when MARKUP1 > 0 then MARKUP1/100 else 1 end/case when MARKUP2 > 0 then MARKUP2/100 else 1 end
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

update #POLITICA set PRECO2=PRECO1*case when MARKUP2 > 0 then MARKUP2/100 else 1 end
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where EMB2<>'';

-- arredondamento truncado
update #POLITICA set DECTRUNC1=round(PRECO1-round(PRECO1,0,1),2,1) --*100
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

update #POLITICA set DECTRUNC2=round(PRECO2-round(PRECO2,0,1),2,1) --*100
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where EMB2<>'';

-- centena
update #POLITICA set DECCENT1=left(right(DECTRUNC1,2),1)
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

update #POLITICA set DECCENT2=left(right(DECTRUNC2,2),1)
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where EMB2<>'';

-- dezena
update #POLITICA set DECDEZE1=right(DECTRUNC1,1)
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

update #POLITICA set DECDEZE2=right(DECTRUNC2,1)
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where EMB2<>'';

-- preço 1 e 2 se produto com centeza 9 e dezena > 5
update #POLITICA set PREVENDA1=round(PRECO1,0),DECTRUNC1=0,DECCENT1=0,DECDEZE1=0
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where DECCENT1=9 and DECDEZE1 > 5;

update #POLITICA set PREVENDA2=round(PRECO2,0),DECTRUNC2=0,DECCENT2=0,DECDEZE2=0
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where EMB2<>'' and DECCENT2=9 and DECDEZE2 > 5;

-- se os preços 1 e 2 não foram calculados no update acima
update #POLITICA set PREVENDA1=round(PRECO1,0,1)
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where PREVENDA1=0;

update #POLITICA set PREVENDA2=round(PRECO2,0,1)
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where EMB2<>'' and PREVENDA2=0;

-- centeza com arredondamento
update #POLITICA set DECCENT1=case when DECDEZE1 > 5 and DECCENT1 < 9 then DECCENT1+1 else DECCENT1 end
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where DECDEZE1 not in(0,5);

update #POLITICA set DECCENT2=case when DECDEZE2 > 5 and DECCENT2 < 9 then DECCENT2+1 else DECCENT2 end
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where EMB2<>'' and DECDEZE2 not in(0,5);

-- dezenas com arredondamento
update #POLITICA set DECDEZE1=case when DECDEZE1 < 5 then 5 else 0 end
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where DECDEZE1 not in(0,5);

update #POLITICA set DECDEZE2=case when DECDEZE2 < 5 then 5 else 0 end
  from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default
 where EMB2<>'' and DECDEZE2 not in(0,5);

-- preço final
update #POLITICA set PREVENDA1=PREVENDA1+convert(decimal,ltrim(str(DECCENT1))+ltrim(str(DECDEZE1)))/100;

update #POLITICA set PREVENDA2=PREVENDA2+convert(decimal,ltrim(str(DECCENT2))+ltrim(str(DECDEZE2)))/100 where EMB2<>'';

-- redução
update #POLITICA set REDUCAO1=convert(money,100-PREVENDA1*100/PRECO1);

update #POLITICA set REDUCAO2=convert(money,100-PREVENDA2*100/PRECO1) where EMB2<>'';

-- atualização da política de preços do sistema

--set @tabela=''

-- corporativo
if @tabela='C'
   update TBS015 set PDPMKPCOR1=MARKUP1,
                     PDPREDCOR1=REDUCAO1,
                     PDPPRECOR1=PREVENDA1,
                     PDPMKPCOR2=MARKUP2,
                     PDPREDCOR2=REDUCAO2,
                     PDPPRECOR2=PREVENDA2,
                     PDPDATALT=convert(char(8),getdate(),112),PDPHORALT=convert(char(8),getdate(),114),
                     PDPUSUALT=convert(char(10),getdate(),103)+' '+convert(char(8),getdate(),114)+' ELAINE'
     from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

-- loja
if @tabela='L'
   update TBS015 set PDPMKPLOJ1=MARKUP1,
                     PDPREDLOJ1=REDUCAO1,
                     PDPPRELOJ1=PREVENDA1,
                     PDPMKPLOJ2=MARKUP2,
                     PDPREDLOJ2=REDUCAO2,
                     PDPPRELOJ2=PREVENDA2,
                     PDPDATALT=convert(char(8),getdate(),112),PDPHORALT=convert(char(8),getdate(),114),
                     PDPUSUALT=convert(char(10),getdate(),103)+' '+convert(char(8),getdate(),114)+' ELAINE'
     from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

-- revenda
if @tabela='R'
   update TBS015 set PDPMKPREV1=MARKUP1,
                     PDPREDREV1=REDUCAO1,
                     PDPPREREV1=PREVENDA1,
                     PDPMKPREV2=MARKUP2,
                     PDPREDREV2=REDUCAO2,
                     PDPPREREV2=PREVENDA2,
                     PDPDATALT=convert(char(8),getdate(),112),PDPHORALT=convert(char(8),getdate(),114),
                     PDPUSUALT=convert(char(10),getdate(),103)+' '+convert(char(8),getdate(),114)+' ELAINE'
     from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

-- web1
if @tabela='W1'
   update TBS015 set PDPMKPWE11=MARKUP1,
                     PDPREDWE11=REDUCAO1,
                     PDPPREWE11=PREVENDA1,
                     PDPMKPWE12=MARKUP2,
                     PDPREDWE12=REDUCAO2,
                     PDPPREWE12=PREVENDA2,
                     PDPDATALT=convert(char(8),getdate(),112),PDPHORALT=convert(char(8),getdate(),114),
                     PDPUSUALT=convert(char(10),getdate(),103)+' '+convert(char(8),getdate(),114)+' ELAINE'
     from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

-- web2
if @tabela='W2'
   update TBS015 set PDPMKPWE21=MARKUP1,
                     PDPREDWE21=REDUCAO1,
                     PDPPREWE21=PREVENDA1,
                     PDPMKPWE22=MARKUP2,
                     PDPREDWE22=REDUCAO2,
                     PDPPREWE22=PREVENDA2,
                     PDPDATALT=convert(char(8),getdate(),112),PDPHORALT=convert(char(8),getdate(),114),
                     PDPUSUALT=convert(char(10),getdate(),103)+' '+convert(char(8),getdate(),114)+' ELAINE'
     from TBS015 (nolock) join #POLITICA on CODIGO=PDPCOD collate database_default;

-- tabela temporária
drop table #POLITICA

      set @tabela=
      case @tabela
         when 'C'  then 'L'
         when 'L'  then 'R'
         when 'R'  then 'W1'
         when 'W1' then 'W2'
         else ''
      end
   end

--select * from #POLITICA where PRECO1=0