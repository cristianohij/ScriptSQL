-- 1o. passo
-- criei uma lista de códigos de produtos de cada unidade do grupo
-- uni as listas e eliminei os códigos de produtos duplicados (excel)

-- 2o. passo
-- criar uma tabela para registro das ocorrências de entradas e saídas de todas as lojas do grupo

-- estrutura:
--    codigoUnico
--    codigoBOffice
--    descricaoBOffice
--    codigoBB
--    descricaoBB
--    codigoMisaspel
--    descricaoMisaspel
--    codigoPapelyna
--    descricaoPapelyna
--    codigoTbyMatriz
--    descricaoTbyMatriz
--    codigoTbyTte
--    descricaoTbyTte
--    codigoTbyCD
--    descricaoTbyCD
--    totalEntrada
--    ultimaEntrada
--    totalSaida
--    ultimaSaida
--    destino
--    naturezaOperacao
--    finalidadeAquisicao

create table SYSTAX (
   codigoUnico char(15) default '',
   codigoBOffice char(15) default '' ,
   descricaoBOffice char(60) default '' ,
   codigoBB char(15) default '' ,
   descricaoBB char(60) default '' ,
   codigoMisaspel char(15) default '' ,
   descricaoMisaspel char(60) default '' ,
   codigoPapelyna char(15) default '' ,
   descricaoPapelyna char(60) default '' ,
   codigoTbyMatriz char(15) default '' ,
   descricaoTbyMatriz char(60) default '' ,
   codigoTbyTte char(15) default '' ,
   descricaoTbyTte char(60) default '' ,
   codigoTbyCD char(15) default '' ,
   descricaoTbyCD char(60) default '' ,
   totalEntrada int default 0 ,
   ultimaEntrada datetime default '17530101' ,
   totalSaida int default 0 ,
   ultimaSaida datetime default '17530101' ,
   destino char(2) default '' ,
   naturezaOperacao char(30) default '' ,
   finalidadeAquisicao char(1) default '' )

-- 3o. passo
-- gravei os códigos gerados no excel em um arquivo do tipo texto, pois não foi possível ler do excel devido a versão

-- inserir códigos dos produtos para gerar relatório
insert into SYSTAX (codigoUnico)
select subString(registro,11,15)
  from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from codigos.txt')


select * from SYSTAX (nolock) order by codigoUnico

select count(*) from SYSTAX (nolock)
 where descricaoBOffice='' and descricaoBB='' and descricaoMisaspel='' and descricaoPapelyna='' and descricaoTbyMatriz='' and descricaoTbyTte='' and 
       descricaoTbyCD=''

delete SYSTAX
 where descricaoBOffice='' and descricaoBB='' and descricaoMisaspel='' and descricaoPapelyna='' and descricaoTbyMatriz='' and descricaoTbyTte='' and 
       descricaoTbyCD=''


delete SYSTAX

drop table SYSTAX


-- 4o. passo
-- grava dados dos produtos de cada unidade

update SYSTAX set codigoBOffice=PROCOD,descricaoBOffice=PRODES
  from BOFFICE.SIBD.dbo.TBS010
 where PROCOD=codigoUnico

update SYSTAX set codigoBB='',descricaoBB=''

select count(*) from TANBYM.SIBD.dbo.TBS010

select * from SYSTAX (nolock) where not exists(select '' from TANBYM.SIBD.dbo.TBS010 where PROCOD=codigoUnico)


-- 5o. passo
-- grava as datas de última entrada e saída por produto

-- best bag		
-- best office		
-- misaspel		
-- papelyna		
-- tanby matriz		
--   "   taubaté	
--   "   cd		

-- última entrada/saída

update SYSTAX set ultimaEntBOffice='17530101',ultimaEntBB='17530101',ultimaEntMisaspel='17530101',ultimaEntPapelyna='17530101',ultimaEntTbyMatriz='17530101',ultimaEntTbyTte='17530101',ultimaEntTbyCD='17530101',ultimaSaiBOffice='17530101',ultimaSaiBB='17530101',ultimaSaiMisaspel='17530101',ultimaSaiPapelyna='17530101',ultimaSaiTbyMatriz='17530101',ultimaSaiTbyTte='17530101',ultimaSaiTbyCD='17530101'

-- best bag
update SYSTAX set ultimaEntBB=(select max(T1.NFEDATENT)
                                   from BESTBAG.SIBD2.dbo.TBS059 as T1 left join BESTBAG.SIBD2.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set ultimaSaiBB=(select max(T1.NFSDATEMI)
                                 from BESTBAG.SIBD2.dbo.TBS067 as T1 left join BESTBAG.SIBD2.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- best office
update SYSTAX set ultimaEntBOffice=(select max(T1.NFEDATENT)
                                   from BOFFICE.SIBD.dbo.TBS059 as T1 left join BOFFICE.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set ultimaSaiBOffice=(select max(T1.NFSDATEMI)
                                 from BOFFICE.SIBD.dbo.TBS067 as T1 left join BOFFICE.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- misaspel
update SYSTAX set ultimaEntMisaspel=(select max(T1.NFEDATENT)
                                   from MISASPEL.SIBD.dbo.TBS059 as T1 left join MISASPEL.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set ultimaSaiMisaspel=(select max(T1.NFSDATEMI)
                                 from MISASPEL.SIBD.dbo.TBS067 as T1 left join MISASPEL.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- papelyna
update SYSTAX set ultimaEntPapelyna=(select max(T1.NFEDATENT)
                                   from PAPELYNA.SIBD.dbo.TBS059 as T1 left join PAPELYNA.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set ultimaSaiPapelyna=(select max(T1.NFSDATEMI)
                                 from PAPELYNA.SIBD.dbo.TBS067 as T1 left join PAPELYNA.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- tanby matriz

update SYSTAX set ultimaEntTbyMatriz=(select max(T1.NFEDATENT)
                                   from TANBYM.SIBD.dbo.TBS059 as T1 left join TANBYM.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

-- script acima não funcionou

update SYSTAX set ultimaEntTbyMatriz=subString(linha,32,4)+subString(linha,29,2)+subString(linha,26,2)
   from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from tanby.txt')
where SYSTAX.codigoUnico collate database_default=subString(linha,11,15) collate database_default


update SYSTAX set ultimaSaiTbyMatriz=(select max(T1.NFSDATEMI)
                                 from TANBYM.SIBD.dbo.TBS067 as T1 left join TANBYM.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- tanby taubaté
update SYSTAX set ultimaEntTbyTte=(select max(T1.NFEDATENT)
                                   from TANBYT.SIBD.dbo.TBS059 as T1 left join TANBYT.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set ultimaSaiTbyTte=(select max(T1.NFSDATEMI)
                                 from TANBYT.SIBD.dbo.TBS067 as T1 left join TANBYT.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- tanby cd
update SYSTAX set ultimaEntTbyCD=(select max(T1.NFEDATENT)
                                   from TANBYCD.SIBD.dbo.TBS059 as T1 left join TANBYCD.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set ultimaSaiTbyCD=(select max(T1.NFSDATEMI)
                                 from TANBYCD.SIBD.dbo.TBS067 as T1 left join TANBYCD.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go


-- necessária a inclusão de novos atributos por empresa

alter table [SYSTAX] add [ultimaEntBOffice] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaEntBB] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaEntMisaspel] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaEntPapelyna] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaEntTbyMatriz] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaEntTbyTte] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaEntTbyCD] datetime default '17530101' with values
go

alter table [SYSTAX] add [ultimaSaiBOffice] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaSaiBB] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaSaiMisaspel] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaSaiPapelyna] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaSaiTbyMatriz] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaSaiTbyTte] datetime default '17530101' with values
go
alter table [SYSTAX] add [ultimaSaiTbyCD] datetime default '17530101' with values
go


-- 6o. passo
-- úmero total de entradas e saídas por produto

alter table [SYSTAX] add [qtdeVezesEntBOffice] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesEntBB] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesEntMisaspel] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesEntPapelyna] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesEntTbyMatriz] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesEntTbyTte] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesEntTbyCD] datetime default '17530101' with values
go

alter table [SYSTAX] add [qtdeVezesSaiBOffice] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesSaiBB] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesSaiMisaspel] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesSaiPapelyna] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesSaiTbyMatriz] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesSaiTbyTte] datetime default '17530101' with values
go
alter table [SYSTAX] add [qtdeVezesSaiTbyCD] datetime default '17530101' with values
go

-- criei o campo do tipo errado, corrigi através do Enterprise

update SYSTAX set qtdeVezesEntBOffice=0,qtdeVezesEntBB=0,qtdeVezesEntMisaspel=0,qtdeVezesEntPapelyna=0,qtdeVezesEntTbyMatriz=0,qtdeVezesEntTbyTte=0,qtdeVezesEntTbyCD=0,qtdeVezesSaiBOffice=0,qtdeVezesSaiBB=0,qtdeVezesSaiMisaspel=0,qtdeVezesSaiPapelyna=0,qtdeVezesSaiTbyMatriz=0,qtdeVezesSaiTbyTte=0,qtdeVezesSaiTbyCD=0

-- tanby matriz		ok
--   "   taubaté	ok
--   "   cd		ok
-- best office		ok
-- misaspel		ok
-- best bag		ok
-- papelyna		

-- número de notas fiscais de entradas/saídas emitidas por produto

-- best bag
update SYSTAX set qtdeVezesEntBB=(select count(*)
                                   from BESTBAG.SIBD2.dbo.TBS059 as T1 left join BESTBAG.SIBD2.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set qtdeVezesSaiBB=(select count(*)
                                 from BESTBAG.SIBD2.dbo.TBS067 as T1 left join BESTBAG.SIBD2.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- best office
update SYSTAX set qtdeVezesEntBOffice=(select count(*)
                                   from BOFFICE.SIBD.dbo.TBS059 as T1 left join BOFFICE.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set qtdeVezesSaiBOffice=(select count(*)
                                 from BOFFICE.SIBD.dbo.TBS067 as T1 left join BOFFICE.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- misaspel
update SYSTAX set qtdeVezesEntMisaspel=(select count(*)
                                   from MISASPEL.SIBD.dbo.TBS059 as T1 left join MISASPEL.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set qtdeVezesSaiMisaspel=(select count(*)
                                 from MISASPEL.SIBD.dbo.TBS067 as T1 left join MISASPEL.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- papelyna
update SYSTAX set qtdeVezesEntPapelyna=(select count(*)
                                   from PAPELYNA.SIBD.dbo.TBS059 as T1 left join PAPELYNA.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set qtdeVezesSaiPapelyna=(select count(*)
                                 from PAPELYNA.SIBD.dbo.TBS067 as T1 left join PAPELYNA.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- tanby matriz
update SYSTAX set qtdeVezesEntTbyMatriz=(select count(*)
                                   from TANBYM.SIBD.dbo.TBS059 as T1 left join TANBYM.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

-- script acima não funcionou

update SYSTAX set qtdeVezesEntTbyMatriz=subString(linha,21,9)
   from openRowset('MSDASQL','driver={microsoft text driver (*.txt; *.csv)};defaultDir=c:\temp','select * from tanby2.txt')
where SYSTAX.codigoUnico collate database_default=subString(linha,6,15) collate database_default

update SYSTAX set qtdeVezesSaiTbyMatriz=(select count(*)
                                 from TANBYM.SIBD.dbo.TBS067 as T1 left join TANBYM.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- tanby taubaté
update SYSTAX set qtdeVezesEntTbyTte=(select count(*)
                                   from TANBYT.SIBD.dbo.TBS059 as T1 left join TANBYT.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set qtdeVezesSaiTbyTte=(select count(*)
                                 from TANBYT.SIBD.dbo.TBS067 as T1 left join TANBYT.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go

-- tanby cd
update SYSTAX set qtdeVezesEntTbyCD=(select count(*)
                                   from TANBYCD.SIBD.dbo.TBS059 as T1 left join TANBYCD.SIBD.dbo.TBS0591 as T2
                                           on T1.NFETIP=T2.NFETIP and T1.NFENUM=T2.NFENUM and T1.NFECOD=T2.NFECOD and T1.SERCOD=T2.SERCOD
                                  where T2.PROCOD=SYSTAX.codigoUnico and
                                        T1.NFECAN='N')
go

update SYSTAX set qtdeVezesSaiTbyCD=(select count(*)
                                 from TANBYCD.SIBD.dbo.TBS067 as T1 left join TANBYCD.SIBD.dbo.TBS0671 as T2 on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM
                                where T2.PROCOD=SYSTAX.codigoUnico and
                                      T1.NFSCAN='N')
go


-- 7o. passo eliminação de registros

select * from SYSTAX (nolock)
 where descricaoBOffice='' and descricaoBB='' and descricaoMisaspel='' and descricaoPapelyna='' and descricaoTbyMatriz='' and descricaoTbyTte='' and
       descricaoTbyCD=''

-- produtos sem quantidades movimentadas

-- backup

select * 
  into SYSTAX_eliminados
  from SYSTAX (nolock)
 where qtdeVezesEntBOffice=0 and qtdeVezesEntBB=0 and qtdeVezesEntMisaspel=0 and qtdeVezesEntPapelyna=0 and qtdeVezesEntTbyMatriz=0 and
       qtdeVezesEntTbyTte=0 and qtdeVezesEntTbyCD=0 and qtdeVezesSaiBOffice=0 and qtdeVezesSaiBB=0 and qtdeVezesSaiMisaspel=0 and qtdeVezesSaiPapelyna=0 and
       qtdeVezesSaiTbyMatriz=0 and qtdeVezesSaiTbyTte=0 and qtdeVezesSaiTbyCD=0

-- eliminação

delete SYSTAX
 where qtdeVezesEntBOffice=0 and qtdeVezesEntBB=0 and qtdeVezesEntMisaspel=0 and qtdeVezesEntPapelyna=0 and qtdeVezesEntTbyMatriz=0 and
       qtdeVezesEntTbyTte=0 and qtdeVezesEntTbyCD=0 and qtdeVezesSaiBOffice=0 and qtdeVezesSaiBB=0 and qtdeVezesSaiMisaspel=0 and qtdeVezesSaiPapelyna=0 and
       qtdeVezesSaiTbyMatriz=0 and qtdeVezesSaiTbyTte=0 and qtdeVezesSaiTbyCD=0

-- 8o. passo
-- listagem para o Excel

select top 1 * from SYSTAX (nolock)

select case when descricaoBOffice<>descricaoBB and descricaoBB<>descricaoMisaspel and descricaoMisaspel<>descricaoPapelyna and descricaoTbyMatriz                                           codigoTbyTte    descricaoTbyTte                                              codigoTbyCD     descricaoTbyCD


-- 9o. passo função para gravar a maior data de entrada/saída por produto

drop function maiorDataEntrada
go

create function maiorDataEntrada(@data1 datetime ,@data2 datetime ,@data3 datetime ,@data4 datetime ,@data5 datetime ,@data6 datetime ,@data7 datetime) returns datetime as
   begin
      declare @retorno datetime

      set @retorno = @data1

      if @data2 > @retorno set @retorno = @data2
      if @data3 > @retorno set @retorno = @data3
      if @data4 > @retorno set @retorno = @data4
      if @data5 > @retorno set @retorno = @data5
      if @data6 > @retorno set @retorno = @data6
      if @data7 > @retorno set @retorno = @data7

      return @retorno
   end
go

drop function maiorDataSaida
go

create function maiorDataSaida(@data1 datetime ,@data2 datetime ,@data3 datetime ,@data4 datetime ,@data5 datetime ,@data6 datetime ,@data7 datetime) returns datetime as
   begin
      declare @retorno datetime

      set @retorno = @data1

      if @data2 > @retorno set @retorno = @data2
      if @data3 > @retorno set @retorno = @data3
      if @data4 > @retorno set @retorno = @data4
      if @data5 > @retorno set @retorno = @data5
      if @data6 > @retorno set @retorno = @data6
      if @data7 > @retorno set @retorno = @data7

      return @retorno
   end
go

select top 1 * from SYSTAX (nolock)

-- testa maior data entrada

select top 10 dbo.maiorDataEntrada(ultimaEntBOffice,ultimaEntBB,ultimaEntMisaspel,ultimaEntPapelyna,ultimaEntTbyMatriz,ultimaEntTbyTte,ultimaEntTbyCD)
  from SYSTAX (nolock)

select top 1 * from SYSTAX (nolock)

-- testa maior data saída

select top 10 dbo.maiorDataSaida(ultimaSaiBOffice,ultimaSaiBB,ultimaSaiMisaspel,ultimaSaiPapelyna,ultimaSaiTbyMatriz,ultimaSaiTbyTte,ultimaSaiTbyCD)
  from SYSTAX (nolock)

-- gravar maior data de entrada

update SYSTAX set ultimaEntrada=dbo.maiorDataEntrada(ultimaEntBOffice,ultimaEntBB,ultimaEntMisaspel,ultimaEntPapelyna,ultimaEntTbyMatriz,ultimaEntTbyTte,ultimaEntTbyCD)

-- gravar maior data de saída

update SYSTAX set ultimaSaida=dbo.maiorDataSaida(ultimaSaiBOffice,ultimaSaiBB,ultimaSaiMisaspel,ultimaSaiPapelyna,ultimaSaiTbyMatriz,ultimaSaiTbyTte,ultimaSaiTbyCD)


-- maior quantidade de entrada/saida

drop function maiorQtdeEntrada
go

create function maiorQtdeEntrada(@qtde1 int,@qtde2 int,@qtde3 int,@qtde4 int,@qtde5 int,@qtde6 int,@qtde7 int) returns int as
   begin
      declare @retorno int

      set @retorno = @qtde1

      if @qtde2 > @retorno set @retorno = @qtde2
      if @qtde3 > @retorno set @retorno = @qtde3
      if @qtde4 > @retorno set @retorno = @qtde4
      if @qtde5 > @retorno set @retorno = @qtde5
      if @qtde6 > @retorno set @retorno = @qtde6
      if @qtde7 > @retorno set @retorno = @qtde7

      return @retorno
   end
go

drop function maiorQtdeSaida
go

create function maiorQtdeSaida(@qtde1 int,@qtde2 int,@qtde3 int,@qtde4 int,@qtde5 int,@qtde6 int,@qtde7 int) returns int as
   begin
      declare @retorno int

      set @retorno = @qtde1

      if @qtde2 > @retorno set @retorno = @qtde2
      if @qtde3 > @retorno set @retorno = @qtde3
      if @qtde4 > @retorno set @retorno = @qtde4
      if @qtde5 > @retorno set @retorno = @qtde5
      if @qtde6 > @retorno set @retorno = @qtde6
      if @qtde7 > @retorno set @retorno = @qtde7

      return @retorno
   end
go

-- testa maior quantidade entrada

select top 1 * from SYSTAX (nolock)

select top 10 dbo.maiorQtdeEntrada(qtdeVezesEntBOffice,qtdeVezesEntBB,qtdeVezesEntMisaspel,qtdeVezesEntPapelyna,qtdeVezesEntTbyMatriz,qtdeVezesEntTbyTte,qtdeVezesEntTbyCD)
  from SYSTAX (nolock)

-- testa maior quantidade saída

select top 1 * from SYSTAX (nolock)

select top 10 dbo.maiorQtdeSaida(qtdeVezesSaiBOffice,qtdeVezesSaiBB,qtdeVezesSaiMisaspel,qtdeVezesSaiPapelyna,qtdeVezesSaiTbyMatriz,qtdeVezesSaiTbyTte,qtdeVezesSaiTbyCD)
  from SYSTAX (nolock)

-- gravar maior quantidade de entrada

update SYSTAX set totalEntrada=dbo.maiorQtdeEntrada(qtdeVezesEntBOffice,qtdeVezesEntBB,qtdeVezesEntMisaspel,qtdeVezesEntPapelyna,qtdeVezesEntTbyMatriz,qtdeVezesEntTbyTte,qtdeVezesEntTbyCD)

-- gravar maior quantidade de saída

update SYSTAX set totalSaida=dbo.maiorQtdeSaida(qtdeVezesSaiBOffice,qtdeVezesSaiBB,qtdeVezesSaiMisaspel,qtdeVezesSaiPapelyna,qtdeVezesSaiTbyMatriz,qtdeVezesSaiTbyTte,qtdeVezesSaiTbyCD)




-- grava a data da entrada da nota fiscal se vazia

select NFEUSUEFE,NFEDATENT,NFENUM from TBS059 (nolock) --where NFEUSUEFE='' or NFEUSUEFE is null
 where NFEUSUEFE<>'' and (NFEDATENT is null or NFEDATENT='17530101')

select NFEUSUEFE,NFENUM from TBS059 (nolock) where NFEUSUEFE<>'' and Len(NFEUSUEFE)<10

update TBS059 set NFEUSUEFE='' where NFEUSUEFE<>'' and Len(NFEUSUEFE)<10

update TBS059 set NFEDATENT=convert(datetime,right(subString(NFEUSUEFE,1,10),4)+subString(NFEUSUEFE,4,2)+left(subString(NFEUSUEFE,1,10),2))
 where NFEUSUEFE<>'' and (NFEDATENT is null or NFEDATENT='17530101') -- and NFENUM=13814

-- fim


if object_id(@banco+'..VENDAS') is not null
   begin
      drop table VENDAS
   end

if object_id('tempdb..#CFOP') is not null
   begin
      drop table #CFOP
   end

create table #CFOP (codigo char(5),descricao char(20))

insert into #CFOP select '5.102','VENDAS'
insert into #CFOP select '5.117','VENDAS'
insert into #CFOP select '5.118','VENDAS'
insert into #CFOP select '5.119','VENDAS'
insert into #CFOP select '5.123','VENDAS'
insert into #CFOP select '5.152','TRANSFERENCIA'
insert into #CFOP select '5.201','DEVOLUCAO'
insert into #CFOP select '5.202','DEVOLUCAO'
insert into #CFOP select '5.405','VENDAS'
insert into #CFOP select '5.409','TRANSFERENCIA'
insert into #CFOP select '5.411','DEVOLUCAO'
insert into #CFOP select '5.551','VENDAS'
insert into #CFOP select '5.556','DEVOLUCAO'
insert into #CFOP select '5.557','TRANSFERENCIA'
insert into #CFOP select '5.602','TRANSFERENCIA'
insert into #CFOP select '5.605','TRANSFERENCIA'
insert into #CFOP select '5.910','REMESSA'
insert into #CFOP select '5.911','REMESSA'
insert into #CFOP select '5.912','REMESSA'
insert into #CFOP select '5.914','REMESSA'
insert into #CFOP select '5.915','REMESSA'
insert into #CFOP select '5.916','RETORNO'
insert into #CFOP select '5.922','LANCAMENTO'
insert into #CFOP select '5.923','REMESSA'
insert into #CFOP select '5.924','REMESSA'
insert into #CFOP select '5.929','LANCAMENTO'
insert into #CFOP select '5.949','OUTRA'
insert into #CFOP select '6.102','VENDAS'
insert into #CFOP select '6.108','VENDAS'
insert into #CFOP select '6.201','DEVOLUCAO'
insert into #CFOP select '6.202','DEVOLUCAO'
insert into #CFOP select '6.403','VENDAS'
insert into #CFOP select '6.404','VENDAS'
insert into #CFOP select '6.411','DEVOLUCAO'
insert into #CFOP select '6.912','REMESSA'
insert into #CFOP select '6.915','REMESSA'
insert into #CFOP select '6.923','REMESSA'
insert into #CFOP select '6.929','LANCAMENTO'
insert into #CFOP select '6.949','OUTRA'

select * from TBS041 (nolock) where upper(COPDES) Like('OUTRA%')

select COPTIP,COPCODDDE,COPCODDFE from TBS041 (nolock) group by COPTIP,COPCODDDE,COPCODDFE

-- insere uma nova coluna para auxiliar no relatório
-- tipo da operação/natureza da operação

--alter table [TBS041] add [COPFIN] char(3) default '' with values

--alter table [TBS041] alter column [COPFIN] char(30)

alter table [TBS041] add [COPNATOPE] char(30) default '' with values

update TBS041 set COPNATOPE='VENDA' where upper(COPDES) Like('VENDA%')
update TBS041 set COPNATOPE='ANULACAO DE VALOR' where upper(COPDES) Like('ANULACAO%')
update TBS041 set COPNATOPE='INDUSTRIALIZACAO' where upper(COPDES) Like('INDUSTRIALIZACAO%')
update TBS041 set COPNATOPE='DEVOLUCAO' where upper(COPDES) Like('DEVOLUCAO%')
update TBS041 set COPNATOPE='LANCAMENTO' where upper(COPDES) Like('LANCAMENTO%')
update TBS041 set COPNATOPE='PRESTACAO DE SERVICO' where upper(COPDES) Like('PRESTACAO%')
update TBS041 set COPNATOPE='REMESSA' where upper(COPDES) Like('REMESSA%')
update TBS041 set COPNATOPE='RETORNO' where upper(COPDES) Like('RETORNO%')
update TBS041 set COPNATOPE='TRANSFERENCIA' where upper(COPDES) Like('TRANSFERENCIA%')
update TBS041 set COPNATOPE='UTILIZACAO DE SALDO DEVEDOR' where upper(COPDES) Like('UTILIZACAO%')
update TBS041 set COPNATOPE='TRANSFERENCIA' where upper(COPDES) Like('TRANSFERENCIA%')
update TBS041 set COPNATOPE='OUTRA' where upper(COPDES) Like('OUTRA%')

--update TBS041 set COPNATOPE=COPFIN

select COPNATOPE,count(*) from TBS041 (nolock) group by COPNATOPE


select * from TBS041 (nolock) where COPNATOPE='' order by COPDES

update TBS041 set COPNATOPE='AQUISICAO DE SERVICO' where upper(COPDES) Like('AQUISICAO%')
update TBS041 set COPNATOPE='COMPRA' where upper(COPDES) Like('COMPRA%')
update TBS041 set COPNATOPE='ENTRADA' where upper(COPDES) Like('ENTRADA%')
update TBS041 set COPNATOPE='RECEBIMENTO' where upper(COPDES) Like('RECEBIMENTO%')
update TBS041 set COPNATOPE='RESSARCIMENTO' where upper(COPDES) Like('RESSARCIMENTO%')

-- fim


select top 100 NFSDATEMI from TBS067 (nolock) order by NFSDATEMI

select top 500 CLIDATCAD from TBS002 (nolock) order by CLIDATCAD

select T1.PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD) as 'descricao',
       T2.UFESIG as 'uf',
       count(*) as 'contador',
       (select convert(char(8),max(T4.NFSDATEMI),3)
          from TBS067 as T4 (nolock) 
                  join TBS0671 as T5 (nolock) on T5.NFSEMPCOD=T4.NFSEMPCOD and T5.SNEEMPCOD=T4.SNEEMPCOD and T5.SNESER=T4.SNESER and T5.NFSNUM=T4.NFSNUM
                  join TBS042 as T6 (nolock) on T6.TESCOD=T5.TESCOD
         where T5.PROCOD=T1.PROCOD and
               T4.NFSCAN='N' and 
               T6.TESCNTVEN='S' ) as 'ultima venda',
       (select convert(char(8),max(T7.NFEDATENT),3)
          from TBS059 as T7 (nolock) 
                  join TBS0591 as T8 (nolock)
                     on T8.NFEEMPCOD=T7.NFEEMPCOD and T8.NFETIP=T7.NFETIP and T8.NFENUM=T7.NFENUM and T8.NFECOD=T7.NFECOD and T8.SEREMPCOD=T7.SEREMPCOD and
                        T8.SERCOD=T7.SERCOD
                  join TBS042 as T9 (nolock) on T9.TESCOD=T8.TESCOD
          where T8.PROCOD=T1.PROCOD and
                T7.NFECAN='N' and 
                T9.TESCNTCOM='S') as 'ultima compra'
  from TBS0671 as T1 (nolock)
          right join TBS067 as T2 (nolock)
             on T1.NFSEMPCOD=T2.NFSEMPCOD and T1.SNEEMPCOD=T2.SNEEMPCOD and T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM 
          join TBS042 as T3 (nolock) on T1.TESCOD=T3.TESCOD
 where T2.NFSDATEMI >= '20140801' and
       T2.NFSCAN<>'S' and 
       T3.TESCNTVEN='S'
 group by T1.PROCOD,T2.UFESIG
 order by T1.PROCOD,T2.UFESIG

select T1.PROCOD as 'código do produto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD) as 'descrição do produto',
       T2.UFESIG as 'destino',
       (select CLIFINAQU from TBS002 (nolock) where TBS002.CLICOD=T2.NFSCLICOD) as 'finalidade da aquisição',
       (select convert(char(8),max(T4.NFSDATEMI),3)
          from TBS067 as T4 (nolock) 
                  join TBS0671 as T5 (nolock) on T5.SNESER=T4.SNESER and T5.NFSNUM=T4.NFSNUM
         where T5.PROCOD=T1.PROCOD and
               T4.NFSCAN='N') as 'última saída',
       (select convert(char(8),max(T7.NFEDATENT),3)
          from TBS059 as T7 (nolock) 
                  join TBS0591 as T8 (nolock)
                     on T8.NFETIP=T7.NFETIP and T8.NFENUM=T7.NFENUM and T8.NFECOD=T7.NFECOD and T8.SERCOD=T7.SERCOD
          where T8.PROCOD=T1.PROCOD and
                T7.NFECAN='N') as 'última entrada'
  from TBS0671 as T1 (nolock)
          right join TBS067 as T2 (nolock)
             on T1.SNESER=T2.SNESER and T1.NFSNUM=T2.NFSNUM 
 where T2.NFSDATEMI >= '20140801' and
       T2.NFSCAN<>'S'
 group by T1.PROCOD,T2.UFESIG,T2.NFSCLICOD
 order by T1.PROCOD,T2.UFESIG


select T1.PROCOD,
       T1.PRODES,
       (select count(*)
          from TBS0671 (nolock) right join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
         where NFSDATEMI >= '20140801' and
               NFSCAN='N' and
               TBS0671.PROCOD=T1.PROCOD),
       (select count(*) from TBS0591 (nolock) where TBS0591.PROCOD=T1.PROCOD)
  from TBS010 as T1 (nolock)


select top 500 T1.PROCOD,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=T1.PROCOD),
       (select COPNATOPE from TBS041 (nolock) where COPTIP='S' and (COPCODDDE=T1.NFSCFOP or COPCODDFE=T1.NFSCFOP))
  from TBS0671 as T1 (nolock)
 group by T1.PROCOD,T1.NFSCFOP


select NFSFINAQU,count(*) from TBS067 (nolock) group by NFSFINAQU

begin tran
update TBS067 set NFSFINAQU=CLIFINAQU from TBS002 (nolock) where CLICOD=NFSCLICOD and NFSFINAQU=''


select * from #CFOP


select TBS0671.PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'descricao',
       TBS067.UFESIG as 'uf',
       TBS0671.NFSCFOP as 'CFOP',
       TBS0671.NFSCST as 'CST'
  from TBS0671 (nolock) right
  join TBS067 (nolock)
       on TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.SNEEMPCOD=TBS067.SNEEMPCOD and TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where TBS067.NFSDATEMI >= '20140101' and
       TBS067.NFSCAN<>'S'
 group by TBS0671.PROCOD,TBS067.UFESIG,TBS0671.NFSCFOP,TBS0671.NFSCST


-- notas fiscais por CFOP

select TBS0671.NFSCFOP as 'CFOP'
  from TBS0671 (nolock) right
  join TBS067 (nolock)
       on TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.SNEEMPCOD=TBS067.SNEEMPCOD and TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where TBS067.NFSDATEMI >= '20090101' and
       TBS067.NFSCAN<>'S'
 group by TBS0671.NFSCFOP



-- atualiza última compra/venda do produto

select max(T1.NFSDATEMI) --,T1.NFSNUM,T1.SNESER,dbo.NFSTOTLIQ(T1.NFSEMPCOD,T1.NFSNUM,T1.SNEEMPCOD,T1.SNESER)
  from TBS067 as T1 (nolock) 
          join TBS0671 as T2 (nolock) on T2.NFSEMPCOD=T1.NFSEMPCOD and T2.SNEEMPCOD=T1.SNEEMPCOD and T2.SNESER=T1.SNESER and T2.NFSNUM=T1.NFSNUM
          join TBS042 as T3 (nolock) on T3.TESCOD=T2.TESCOD
 where T2.PROCOD='1640054' and
       T1.NFSCAN='N' and 
       T3.TESCNTVEN='S' 

select max(T1.NFEDATENT) --,T1.NFSNUM,T1.SNESER,dbo.NFSTOTLIQ(T1.NFSEMPCOD,T1.NFSNUM,T1.SNEEMPCOD,T1.SNESER)
  from TBS059 as T1 (nolock) 
          join TBS0591 as T2 (nolock)
             on T2.NFEEMPCOD=T1.NFEEMPCOD and T2.NFETIP=T1.NFETIP and T2.NFENUM=T1.NFENUM and T2.NFECOD=T1.NFECOD and T2.SEREMPCOD=T1.SEREMPCOD and
                T2.SERCOD=T1.SERCOD
          join TBS042 as T3 (nolock) on T3.TESCOD=T2.TESCOD
 where T2.PROCOD='1640054' and
       T1.NFECAN='N' and 
       T3.TESCNTCOM='S' 


select NFENUM,NFEDATENT,NFEUSUEFE from TBS059 (nolock) order by NFEDATENT

select NFEDATENT,NFEUSUEFE from TBS059 (nolock) where NFENUM=13814

print convert(datetime,'20/03/2013')

print convert(datetime,right('20/03/2013',4)+subString('20/03/2013',4,2)+left('20/03/2013',2))

update TBS059 set NFEDATENT=convert(datetime,right(subString(NFEUSUEFE,1,10),4)+subString(subString(NFEUSUEFE,1,10),4,2)+left(subString(NFEUSUEFE,1,10),2))
 where NFENUM=13814

update TBS059 set NFEDATENT='17530101' where NFENUM=13814

select NFEDATCAN from TBS059 (nolock) where NFENUM=13814

select NFEDATENT,NFEUSUEFE from TBS059 (nolock) where isEmpty(NFEUSUEFE)

-- grava data vazia (default SQL) nos registros sem a data da entrada

select NFEDATENT,NFENUM from TBS059 (nolock) where NFEDATENT is null or NFEDATENT='17530101'

update TBS059 set NFEDATENT='17530101' where NFEDATENT is null

-- grava a data da entrada da nota fiscal se vazia

select NFEUSUEFE,NFEDATENT,NFENUM from TBS059 (nolock) --where NFEUSUEFE='' or NFEUSUEFE is null
 where NFEUSUEFE<>'' and (NFEDATENT is null or NFEDATENT='17530101')

select NFEUSUEFE,NFENUM from TBS059 (nolock) where NFEUSUEFE<>'' and Len(NFEUSUEFE)<10

update TBS059 set NFEUSUEFE='' where NFEUSUEFE<>'' and Len(NFEUSUEFE)<10

update TBS059 set NFEDATENT=convert(datetime,right(subString(NFEUSUEFE,1,10),4)+subString(NFEUSUEFE,4,2)+left(subString(NFEUSUEFE,1,10),2))
 where NFEUSUEFE<>'' and (NFEDATENT is null or NFEDATENT='17530101') -- and NFENUM=13814


--- atualiza finalidade da aquisição do cliente conforme planilhas excel preenchidas pelos vendedores

-- trocar os nomes das planilhas

select count(*)
  from openrowset('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=c:\temp\clientes-best-bag.xls',Plan1$)


select codigo,nome,finalidade,CLICOD,CLINOM,CLIFINAQU
  from openrowset('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=c:\temp\clientes-best-bag.xls',Plan1$)
          left join TBS002 (nolock) on CLICOD=codigo

begin tran
update TBS002 set CLIFINAQU=finalidade
  from openrowset('Microsoft.Jet.OLEDB.4.0','Excel 8.0;Database=c:\temp\clientes-best-bag.xls',Plan1$)
          left join TBS002 (nolock) on CLICOD=codigo

commit tran


select count(*) from TBS002 (nolock) where CLIFINAQU=''
select count(*) from TBS002 (nolock) where CLIFINAQU is null


sp_addlinkedserver 'Systax','Jet 4.0','Microsoft.Jet.OLEDB.4.0','c:\temp\',null,'Excel 8.0'

sp_dropserver Systax

sp_addlinkedsrvlogin Systax,false,sa,null