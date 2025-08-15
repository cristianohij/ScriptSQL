-- NOTAS FISCAIS DE ENTRADAS --------------------------------------------------------------------------------------------

-- declara e inicializa as variaveis para filtro por data
declare @datini char(8),@datfin char(8),@locest int

select @datini='20090701',@datfin='20090731',@locest=1

-- elimina a tabela de notas fiscais de entradas
if exists(select name from sysobjects where name='NFENTRADA' and type='U')
   drop table NFENTRADA

-- cria a tabela de notas fiscais de entrada
select	TBS059.NFENUM,						-- numero da NF
	TBS059.NFECOD,						-- codigo do fornecedor
	NFEDATEMI,						-- data emissao
	NFEESTORI,						-- estado origem
	NFECAN,							-- se NF cancelada
	NFEITE,							-- item
	TBS0591.PROCOD,						-- codigo do produto
	NFEQTD*NFEQTDEMB as 'QTDE',				-- quantidade na menor unidade
	NFEPRE-(NFEPRE*NFEPDDITE/100) as 'PRECO',		-- preco liquido c/desconto
	-- subtotal por item
	(NFEQTD*NFEQTDEMB)*(NFEPRE-(NFEPRE*NFEPDDITE/100)) as 'SUBTOTAL',
	TBS0591.TESCOD,						-- tipo de entrada
        TESCNTCOM,						-- se contabiliza em compras
	NFEMOVEST,						-- se movimenta estoque
	NFEBASICMS,						-- valor base ICMS
	NFEPERICMS,						-- percentual do ICMS
	NFEBASICMS*NFEPERICMS/100 as 'BASEICMS',		-- valor do ICMS cobrado
	NFECFOP,						-- CFOP
	NFEPERIPI,						-- percentual do IPI
	-- valor do IPI cobrado
	(NFEQTD*NFEQTDEMB)*(NFEPRE-(NFEPRE*NFEPDDITE/100))*NFEPERIPI/100 as 'VALIPI',
	-- data da efetivacao
	convert(datetime,subString(NFEUSUEFE,1,10),103) as 'DATEFETIV',
	MARCOD

  into	NFENTRADA

  from	TBS059 (noLock) join TBS0591 (noLock) on TBS059.NFENUM=TBS0591.NFENUM and TBS059.NFECOD=TBS0591.NFECOD
                        join TBS010 (noLock) on TBS0591.PROCOD=TBS010.PROCOD
                        join TBS042 (noLock) on TBS0591.TESCOD=TBS042.TESCOD
 where	TBS059.NFETIP='N' and
	subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2) between @datini and @datfin and
	LESCOD=@locest

-- cria chave primaria da tabela de notas fiscais de entrada
alter table NFENTRADA add constraint PK_NFE primary key(NFENUM,NFECOD,NFEITE)


-- NOTAS FISCAIS DE SAIDAS ----------------------------------------------------------------------------------------------

-- declara e inicializa as variaveis para filtro por data
declare @datini datetime,@datfin datetime,@locest int

select @datini='20090701',@datfin='20090731',@locest=1

-- elimina a tabela de notas fiscais de saida
if exists(select name from sysobjects where name='NFSAIDA' and type='U')
   drop table NFSAIDA

-- cria a tabela de notas fiscais de saida
select	TBS067.NFSNUM,						-- numero da NF
	NFSDATEMI,						-- data da emissao
	NFSCAN,							-- se NF cancelada
	NFSDEV,							-- se NF devolvida
	NFSCLICOD,						-- codigo do cliente
	VENCOD,							-- codigo do vendedor
	UFESIG,							-- estado destino
	NFSITE,							-- item
	TBS0671.PROCOD,						-- codigo do produto
	NFSQTD*NFSQTDEMB as 'QTDE',				-- quantidade na menor unidade
	NFSPRE-(NFSPRE*NFSPDDITE/100) as 'PRECO',		-- preco liquido c/desconto
	-- subtotal por item
	(NFSQTD*NFSQTDEMB)*(NFSPRE-(NFSPRE*NFSPDDITE/100)) as 'SUBTOTAL',
	TBS0671.TESCOD,						-- tipo de entrada
	TESCNTVEN,						-- se contabiliza em vendas
	NFSMOVEST,						-- se movimenta estoque
	-- valor base ICMS
	NFSPBI*(NFSQTD*NFSQTDEMB)*(NFSPRE-(NFSPRE*NFSPDDITE/100)) 'BASEICMS',
	NFSPERICMS,						-- percentual do ICMS
	-- valor do ICMS cobrado
	(NFSPBI*(NFSQTD*NFSQTDEMB)*(NFSPRE-(NFSPRE*NFSPDDITE/100)))*NFSPERICMS/100 as 'VALORICMS',
	NFSCFOP,						-- CFOP
	MARCOD

  into	NFSAIDA

  from	TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                        join TBS010 (noLock) on TBS0671.PROCOD=TBS010.PROCOD  
                        join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
 where	NFSTIP='N' and
	NFSDATEMI between @datini and @datfin and LESCOD=@locest

-- cria chave primaria da tabela de notas fiscais de saida
alter table NFSAIDA add constraint PK_NFS primary key(NFSNUM,NFSITE)


-- INVENTARIO -----------------------------------------------------------------------------------------------------------

-- declara e inicializa as variaveis para filtro por data
declare @datini datetime,@datfin datetime,@locest int

select @datini='20090701',@datfin='20090731',@locest=1

-- elimina a tabela de inventario
if exists(select name from sysobjects where name='INVENT' and type='U')
   drop table INVENT

-- cria a tabela de inventario
select	INVDATLAN,						-- data do lancamento
	TBS013.PROCOD,						-- codigo do produto
	INVITE,							-- item
	INVQTD*INVQTDEMB as 'QTDE',				-- quantidade na menor unidade
	INVDATEFE,						-- data da efetivacao
	MARCOD

  into	INVENT

  from	TBS013 (noLock) join TBS010 (noLock) on TBS013.PROCOD=TBS010.PROCOD
 where	INVDATEFE between @datini and @datfin and LESCOD=@locest

-- cria chave primaria da tabela de notas fiscais de saida
alter table INVENT add constraint PK_INV primary key(INVDATLAN,INVITE)


-- MOVIMENTOS INTERNOS --------------------------------------------------------------------------------------------------

-- declara e inicializa as variaveis para filtro por data
declare @datini datetime,@datfin datetime,@locest int

select @datini='20090701',@datfin='20090731',@locest=1

-- elimina a tabela de movimentos internos
if exists(select name from sysobjects where name='MOVINT' and type='U')
   drop table MOVINT

-- cria a tabela de inventario
select	TBS037.MVIDOC,						-- documento
	MVIDATEFE,						-- data da efetivacao
	TMVTIP,							-- tipo de movimentacao E/S
	TMVINFTRA,						-- se transferencia
	MVILOCORI,						-- estoque de origem
	MVILOCDES,						-- estoque de destino
	MVIITE,							-- item
	TBS0371.PROCOD,						-- codigo do produto
	MVIQTDATD*MVIQTDEMB as 'QTDE',				-- quantidade movimentada
	MARCOD

  into	MOVINT

  from	TBS037 (noLock) join TBS0371 (noLock) on TBS037.MVIDOC=TBS0371.MVIDOC
                        join TBS010 (noLock) on TBS0371.PROCOD=TBS010.PROCOD  
                        join TBS033 (noLock) on TBS037.TMVCOD=TBS033.TMVCOD
 where	MVIDATEFE between @datini and @datfin and MVILOCORI= @locest

-- cria chave primaria da tabela de notas fiscais de saida
alter table MOVINT add constraint PK_MVI primary key(MVIDOC,MVIITE)


-- MANUTENCAO DOS SALDOS (ACERTOS) --------------------------------------------------------------------------------------

-- declara e inicializa as variaveis para filtro por data
declare @datini datetime,@datfin datetime,@locest int

select @datini='20090701',@datfin='20090731',@locest=1

-- elimina a tabela de manutencao dos saldos (acertos)
if exists(select name from sysobjects where name='ACERT' and type='U')
   drop table ACERT

-- cria a tabela de inventario
select	MDSREG,							-- registro
	MDSTIP,							-- tipo de movimentacao E/S
	MDSLAN,							-- data/hora do lancamento
	TBS049.PROCOD,						-- codigo do produto
	MDSQTD*MDSQTDEMB as 'QTDE',				-- quantidade na menor unidade
	MARCOD

  into	ACERT

  from	TBS049 (noLock) join TBS010 (noLock) on TBS049.PROCOD=TBS010.PROCOD
 where	MDSLAN between @datini and @datfin and LESCOD=@locest

-- cria chave primaria da tabela de notas fiscais de saida
alter table ACERT add constraint PK_ACE primary key(MDSREG)




	
select * from NFENTRADA A
 where (select count(*) from NFENTRADA B where B.NFENUM=A.NFENUM and B.NFECOD=A.NFECOD)>1
 order by NFENUM,NFECOD

select * from NFENTRADA
select * from NFSAIDA

select distinct NFSAIDA.PROCOD,sum(NFSAIDA.QTDE),sum(NFENTRADA.QTDE) 
  from NFSAIDA (noLock) join NFENTRADA (noLock) on NFSAIDA.PROCOD=NFENTRADA.PROCOD
 where NFSDATEMI between '2009-07-01' and '2009-07-31' and
       DATEFETIV between '2009-07-01' and '2009-07-31'
 group by NFSAIDA.PROCOD


declare cursor_SB1 scroll cursor for
 select B1_COD ,B1_DESC from DADOSADV.dbo.SB1010
  where D_E_L_E_T_ <>'*' and B1_FILIAL=@filial and rtrim(B1_COD) >=@codde and rtrim(B1_COD) <=@codate 
  order by B1_COD


declare @datini datetime,@datfin datetime
declare @marini int,@marfin int
declare @produto varchar(100)

select @datini='20090701',@datfin='20090731'
select @marini=164,@marfin=164

-- elimina a tabela temporaria
if exists(select name from sysobjects where name='KPRO' and type='U')
   delete KPRO
else
   -- cria a tabela temporaria
   create table KPRO(DATA datetime,PROCOD char(15),PRODES char(50),PROUM1 char(2),VENDAS money)

--select PROCOD,PRODES,PROUM1,0 as 'VENDAS' into KPRO from TBS010 (noLock) where MARCOD between @marini and @marfin

while @datini < @datfin begin
--   print @datini
   set @datini=@datini+1

--   update KPRO set VENDAS=(select isnull(sum(QTDE),0)
--     from NFSAIDA (noLock) join KPRO (noLock) on KPRO.PROCOD=NFSAIDA.PROCOD and NFSDATEMI=@datini)
--     from KPRO (noLock) join NFSAIDA (noLock) on KPRO.PROCOD=NFSAIDA.PROCOD and NFSDATEMI=@datini

   insert into KPRO select @datini,NFSAIDA.PROCOD,TBS010.PRODES,TBS010.PROUM1,isnull(sum(NFSAIDA.QTDE),0)
     from NFSAIDA (noLock) join TBS010 (noLock) on NFSAIDA.PROCOD=TBS010.PROCOD and NFSDATEMI=@datini
    where TBS010.MARCOD between @marini and @marfin
    group by NFSDATEMI,NFSAIDA.PROCOD,PRODES,TBS010.PROUM1


--   update KPRO set DATA=@datini,PROCOD
--VENDAS=(select isnull(sum(QTDE),0)
--     from NFSAIDA (noLock) join KPRO (noLock) on KPRO.PROCOD=NFSAIDA.PROCOD and NFSDATEMI=@datini)
--     from KPRO (noLock) join NFSAIDA (noLock) on KPRO.PROCOD=NFSAIDA.PROCOD and NFSDATEMI=@datini
   
--   set @produto=(select PROCOD+' '+PRODES+' '+PROUM1 from TBS010 (noLock) where MARCOD between @marini and @marfin)
--   print @produto

end

print @datini

create view KPRO as select top 1 PROCOD,PRODES,PROUM1,0 as 'vendas' from TBS010 (noLock)

select distinct PROCOD,sum(VENDAS) from KPRO group by PROCOD order by PROCOD

update KPRO set vendas=10

drop view KPRO

select NFSDATEMI,NFSAIDA.PROCOD,TBS010.PRODES,TBS010.PROUM1,isnull(sum(NFSAIDA.QTDE),0)
  from NFSAIDA (noLock) join TBS010 (noLock) on NFSAIDA.PROCOD=TBS010.PROCOD and NFSDATEMI='20090701'
 group by NFSDATEMI,NFSAIDA.PROCOD,PRODES,TBS010.PROUM1

select sum(QTDE) from NFSAIDA (noLock) where PROCOD='1640054'


-- elimina a tabela temporaria
if exists(select name from sysobjects where name='KPRO' and type='U')
   delete KPRO
else
   -- cria a tabela temporaria
   create table KPRO(DATA datetime,PROCOD char(15),PRODES char(50),PROUM1 char(2),VENDAS money,COMPRAS money,
                     INVENT money,MOVINTE money,MOVINTS money,ACERTOSE money,ACERTOSS money,TRANSF money)

-- elimina a tabela temporaria
-- drop table KPRO

declare @datini datetime,@datfin datetime
declare @marini int,@marfin int
declare @codpro char(15),@descpro char(50),@prouni char(2)
declare @qVendas money,@qCompras money,@qInvent money,@qMovinte money,@qMovints money,@qAcertose money,@qAcertoss money,
        @qTransf money

select @datini='20090701',@datfin='20090731'
select @marini=164,@marfin=164

declare curProdutos scroll cursor for
 select PROCOD,PRODES,PROUM1 from TBS010 (noLock) where MARCOD between @marini and @marfin order by PROCOD

while @datini < @datfin begin
   open curProdutos

   fetch next from curProdutos into @codpro,@descpro,@prouni

   while @@fetch_status=0 begin
      set @qVendas = (select isnull(sum(QTDE),0) from NFSAIDA (noLock)
                       where PROCOD=@codpro and NFSDATEMI=@datini and NFSMOVEST='S' and TESCNTVEN='S' and
                             NFSCLICOD not in(512,850,6710,4567))

      set @qTransf = (select isnull(sum(QTDE),0) from NFSAIDA (noLock)
                       where PROCOD=@codpro and NFSDATEMI=@datini and NFSMOVEST='S' and
                             NFSCLICOD in(512,850,6710,4567))

      set @qCompras = (select isnull(sum(QTDE),0) from NFENTRADA (noLock)
                       where PROCOD=@codpro and DATEFETIV=@datini)

      set @qInvent = (select isnull(sum(QTDE),0) from INVENT (noLock)
                       where PROCOD=@codpro and INVDATLAN=@datini)

      set @qMovinte = (select isnull(sum(QTDE),0) from MOVINT (noLock)
                        where PROCOD=@codpro and MVIDATEFE=@datini and TMVTIP='E')

      set @qMovints = (select isnull(sum(QTDE),0) from MOVINT (noLock)
                        where PROCOD=@codpro and MVIDATEFE=@datini and TMVTIP='S')

      set @qAcertose = (select isnull(sum(QTDE),0) from ACERT (noLock)
                       where PROCOD=@codpro and MDSLAN=@datini and MDSTIP='E')

      set @qAcertoss = (select isnull(sum(QTDE),0) from ACERT (noLock)
                       where PROCOD=@codpro and MDSLAN=@datini and MDSTIP='S')

/*      print @codpro+' '+@descpro+' '+@prouni+' '+str(@qVendas,10)+' '+str(@qCompras,10)+' '+str(@qInvent,10)+' '+
            str(@qMovint,10)+' '+str(@qAcertos,10) */

      insert into KPRO values(@datini,@codpro,@descpro,@prouni,@qVendas,@qCompras,@qInvent,@qMovinte,@qMovints,
                              @qAcertose,@qAcertoss,@qTransf)

      fetch next from curProdutos into @codpro,@descpro,@prouni
   end

   close curProdutos

   set @datini=@datini+1

   print ''
end

close curProdutos
deallocate curProdutos


-- cria link para planilha do excel
sp_addlinkedserver 'ExcelTella',
   'Jet 4.0',
   'Microsoft.Jet.OLEDB.4.0',
   'C:\temp\tella2.xls',
   null,
   'Excel 8.0'


-- insere dados na planilha do excel
insert relExcel...Plan1$ select * from KPRO (noLock)

VALUES(4,'D',5.8)

sp_addlinkedsrvlogin 'planExcel','false','sa','',null

sp_droplinkedsrvlogin 'planExcel','si'


-- cria link para arquivo texto
sp_addlinkedserver arquivoTexto,
   'Jet 4.0', 
   'Microsoft.Jet.OLEDB.4.0',
   'C:\temp',
   null,
   'Text'

insert arquivoTexto...rel#txt select * from TBS001 (nolock)
insert arquivoTexto...rel#txt select PROCOD,PRODES,PROUM1 from KPRO (noLock)
select convert(char(10),DATA,3),PROCOD,PRODES,PROUM1,str(VENDAS,10,2),str(COMPRAS,10,2),str(INVENT,10,2),
       str(MOVINTE,10,2),str(MOVINTS,10,2),str(ACERTOSE,10,2),str(ACERTOSS,10,2),str(TRANSF,10,2)
  from KPRO (noLock)

select top 1 DATA,convert(char(10),DATA,3) from KPRO

select top 1 VENDAS,convert(char(10),str(VENDAS,10,2)) from KPRO where VENDAS > 0

insert arquivoTexto...rel#txt select top 10 convert(char(10),str(VENDAS,10,2)) from KPRO (noLock) where VENDAS > 0


insert arquivoTexto...rel#txt select top 10 str(VENDAS,10,2) from KPRO (noLock) where VENDAS > 0

insert arquivoTexto...kpro#txt (DATA,PROCOD,PRODES,PROUM1,VENDAS,COMPRAS,INVENT,MOVINTE,MOVINTS,ACERTOSE,ACERTOSS,
                                TRANSF)
select convert(char(10),DATA,3),PROCOD,PRODES,PROUM1,str(VENDAS,10,2),str(COMPRAS,10,2),str(INVENT,10,2),
       str(MOVINTE,10,2),str(MOVINTS,10,2),str(ACERTOSE,10,2),str(ACERTOSS,10,2),str(TRANSF,10,2)
  from KPRO (noLock)

insert arquivoTexto...kpro#txt
select convert(char(10),DATA,3),PROCOD,PRODES,PROUM1,str(VENDAS,10,2),str(COMPRAS,10,2),str(INVENT,10,2),
       str(MOVINTE,10,2),str(MOVINTS,10,2),str(ACERTOSE,10,2),str(ACERTOSS,10,2),str(TRANSF,10,2)
  from KPRO (noLock)


insert arquivoTexto...rel#txt select top 10 DATA from KPRO (noLock)

-- remove link para arquivo texto
sp_dropserver arqTexto


select * from KPRO


SELECT *
FROM arqTexto...teste#txt


select top 1 convert(datetime,(subString(NFEUSUEFE,7,4)+subString(NFEUSUEFE,4,2)+subString(NFEUSUEFE,1,2)),103)
  from TBS059



TIPMOV char(1),DATMOV datetime,CODPRO char(15),VALVEN money,QTDVEN money,
VALCOM money,QTDCOM money,QTDINV money,QTDMVI money,QTDACE money


-- cria tabela de movimentacoes
if exists(select name from sysobjects where name='MOVTO' and type='U')
   delete MOVTO
else
   create table MOVTO(TIPMOV char(1),DATMOV datetime,CODPRO char(15),VALVEN money,QTDVEN money,VALCOM money,QTDCOM money,
                      QTDINV money,QTDMVI money,QTDACE money)




-- cria tabela de movimentacoes
if exists(select name from sysobjects where name='MOVTO' and type='U')
   delete MOVTO
else
   create table MOVTO(MOVEST varchar(1) not null default '',TIPMOV varchar(1) not null default '',
                      CONTAB varchar(1) not null default '',DATMOV datetime not null default '17530101',
                      TRANS varchar(3) not null default '',CODPRO varchar(15) not null default '',
                      DESPRO varchar(50) default '',PROUNI varchar(2) default '',NOMMAR varchar(30) default '',
                      VALOR money default 0,QTDE money default 0
                      constraint PK_MOV primary key clustered(MOVEST,TIPMOV,CONTAB,DATMOV,TRANS,CODPRO))

-- elimina a tabela de movimentacoes
-- drop table MOVTO

--VEN COM INV ACE


declare @datini datetime,@datfin datetime
declare @marini int,@marfin int
declare @codpro varchar(15),@descpro varchar(50),@prouni varchar(2),@nommar varchar(30)
declare @qVendas money,@qCompras money,@vVendas money,@vCompras money

select @datini='20090701',@datfin='20090731'
select @marini=164,@marfin=164


declare curProdutos scroll cursor for
 select PROCOD,PRODES,PROUM1,MARNOM from TBS010 (noLock) join TBS014 (noLock) on TBS010.MARCOD=TBS014.MARCOD
  where MARCOD between @marini and @marfin order by PROCOD

while @datini < @datfin begin
   open curProdutos

   fetch next from curProdutos into @codpro,@descpro,@prouni,@nommar

   while @@fetch_status=0 begin
      set @qVendas = (select isnull(sum(NFSAIDA.QTDE),0) from NFSAIDA (noLock)
                       where PROCOD=@codpro and NFSDATEMI=@datini)

      set @vVendas = (select isnull(sum(NFSAIDA.SUBTOTAL),0) from NFSAIDA (noLock)
                       where PROCOD=@codpro and NFSDATEMI=@datini)

      select 'ex' from MOVTO (noLock) where TIPMOV='S' and DATMOV=@datini and TRANS='VEN' and CODPRO=@codpro)
         update MOVTO set 

      set @qCompras = (select isnull(sum(NFENTRADA.QTDE),0) from NFENTRADA (noLock)
                       where PROCOD=@codpro and DATEFETIV=@datini)

      print @codpro+' '+@descpro+' '+@prouni+' '+str(@qVendas,10)+' '++str(@qCompras,10)

      fetch next from curProdutos into @codpro,@descpro,@prouni
   end

   close curProdutos

   set @datini=@datini+1

   print ''

end

begin transaction
   insert into MOVTO values('teste')

   if @@error<>0 --begin
      print 'erro na insercao'
      return
   end
commit transaction

select top 3 * from NFSAIDA (noLock)
if @@rowcount = 0
   print 'nada foi encontrado'



select	NFSMOVEST,						-- se movimenta estoque	
	TBS067.NFSNUM,						-- numero da NF
	NFSDATEMI,						-- data da emissao
	NFSCAN,							-- se NF cancelada
	NFSDEV,							-- se NF devolvida
	NFSCLICOD,						-- codigo do cliente
	VENCOD,							-- codigo do vendedor
	UFESIG,							-- estado destino
	NFSITE,							-- item
	TBS0671.PROCOD,						-- codigo do produto
	NFSQTD*NFSQTDEMB as 'QTDE',				-- quantidade na menor unidade
	NFSPRE-(NFSPRE*NFSPDDITE/100) as 'PRECO',		-- preco liquido c/desconto
	-- subtotal por item
	(NFSQTD*NFSQTDEMB)*(NFSPRE-(NFSPRE*NFSPDDITE/100)) as 'SUBTOTAL',
	TBS0671.TESCOD,						-- tipo de entrada
	TESCNTVEN,						-- se contabiliza em vendas
	
	-- valor base ICMS
	NFSPBI*(NFSQTD*NFSQTDEMB)*(NFSPRE-(NFSPRE*NFSPDDITE/100)) 'BASEICMS',
	NFSPERICMS,						-- percentual do ICMS
	-- valor do ICMS cobrado
	(NFSPBI*(NFSQTD*NFSQTDEMB)*(NFSPRE-(NFSPRE*NFSPDDITE/100)))*NFSPERICMS/100 as 'VALORICMS',
	NFSCFOP,						-- CFOP
	MARCOD

  into	MOVTO

  from	TBS067 (noLock) join TBS0671 (noLock) on TBS067.NFSNUM=TBS0671.NFSNUM
                        join TBS010 (noLock) on TBS0671.PROCOD=TBS010.PROCOD  
                        join TBS042 (noLock) on TBS0671.TESCOD=TBS042.TESCOD
 where	NFSTIP='N' and
	NFSDATEMI between @datini and @datfin


select top 10 * from KPRO (noLock)

select distinct DATA,PROCOD,PRODES,PROUM1,sum(VENDAS) from KPRO (noLock) group by DATA,PROCOD,PRODES,PROUM1