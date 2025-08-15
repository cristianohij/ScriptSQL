--drop type GZestoque

-- tabela completa
create type GZestoque
	as table
	(
		 id int identity(1,1) primary key
		,cdprod char(20) default ''
		,codbarra char(20) default ''
		,descricao char(40) default ''
		,descpdv varchar(24) default ''
		,formula char(1) default ''
		,unidade char(2) default ''
		,armacao int default 0
		,setor int default 0
		,termvenda decimal(10,3) default 0
		,termprom decimal(10,3) default 0
		,quant decimal(13,3) default 0
		,descpadrao char(1) default ''
		,variavel char(1) default ''
		,alterapre char(1) default ''
		,multiplica char(1) default ''
		,promocao char(6) default ''
		,tributa int default 0
		,reservado2 char(1) default ''
		,multiplos decimal(8,3) default 0
		,embfechada char(1) default ''
		,descmult decimal(5,2) default 0
		,complement char(1) default ''
		,reservado1 varchar(80) default ''
		,termatac decimal(10,3) default 0
		,sointeiro char(1) default ''
		,referencia varchar(40) default ''
		,st char(3) default ''
		,situacao char(1) default ''
		,vasilhame int default 0
		,reservado3 varchar(81) default ''
		,descmax decimal(5,2) default 0
		,multiatac decimal(8,3) default 0
		,embfecatac char(1) default ''
		,descmtatac decimal(5,2) default 0
		,cfiscal varchar(10) default ''
		,quantpend decimal(13,3) default 0
		,datapend char(4) default ''
		,termesp decimal(10,3) default 0
		,multiesp decimal(8,3) default 0
		,embfecesp char(1) default ''
		,descmtesp decimal(5,2) default 0
		,acimadeata decimal(13,3) default 0
		,acimadeesp decimal(13,3) default 0
		,grupo int default 0
		,depto int default 0
		,marca int default 0
		,pontos decimal(9,4) default 0
		,calcponto char(1) default ''
		,cdprodass varchar(20) default ''
		,grupofin int default 0
		,descfinesp decimal(10,2) default 0
		,descfintab varchar(90) default ''
		,impremota int default 0
		,maxitvenda int default 0
		,cupomvinc char(1) default ''
		,bloqvenda char(1) default ''
		,tipoprod int default 0
		,impremota2 int default 0
		,impremota3 int default 0
		,impremota4 int default 0
		,impremota5 int default 0
		,solsenha char(1) default ''
		,grupobalc int default 0
		,ippt char(1) default ''
		,iat char(1) default ''
		,ultatu date default NULL
		,precopmc decimal(10,3) default 0
		,quantdata decimal(13,3) default 0
		,saldodata datetime default NULL
		,cargatrib decimal(5,2) default 0
		,tipoitem int default 0
		,csosn char(4) default ''
		,entregavel char(1) default 'S'
		,cargatribuf decimal(5,2) default 0
		,chaveibpt char(10) default ''
		,cstpis char(2) default ''
		,cstcofins char(2) default ''
		,aliqpis decimal(9,2) default 0
		,aliqcofins decimal(9,2) default 0
		,unitpis decimal(9,4) default 0
		,unitcofins decimal(9,4) default 0
		,cest char(7) default ''
		,precocusto decimal(10,3) default 0
		,dtiniprom date default NULL
		,dtfimprom date default NULL
		,comissao decimal(5,2) default -99
		,mensagem varchar(128) default ''
		,descfinespperc decimal(4,2) default 0
		,cod_produto_anp int default 0
		,aliqfcp decimal(9,4) default 0
		,aliqfcpst decimal(9,4) default 0
		,aliqfcpret decimal(9,4) default 0
		,codigo_gtin char(20) default ''
		--,primary key (id)
		--,index CHAVE NONCLUSTERED  (cdprod)
    )
go

-- não é possível
--create index CHAVE on GZestoque(cdprod);
--go



-- tabela com somente os atributos utilizados
create type GZestoque
	as table
	(
		 cdprod char(20) default ''
		,descricao char(40) default ''
		,descpdv varchar(24) default ''
		,formula char(1) default ''
		,unidade char(2) default ''
		,termvenda decimal(10,3) default 0
		,descpadrao char(1) default ''
		,variavel char(1) default ''
		,alterapre char(1) default ''
		,multiplica char(1) default ''
		,tributa int default 0
		,multiplos decimal(8,3) default 0
		,embfechada char(1) default ''
		,complement char(1) default ''
		,sointeiro char(1) default ''
		,st char(3) default ''
		,situacao char(1) default ''
		,multiatac decimal(8,3) default 0
		,embfecatac char(1) default ''
		,cfiscal varchar(10) default ''
		,embfecesp char(1) default ''
		,bloqvenda char(1) default ''
		,solsenha char(1) default ''
		,ippt char(1) default ''
		,iat char(1) default ''
		,ultatu date default NULL
		,cargatrib decimal(5,2) default 0
		,tipoitem int default 0
		,csosn char(4) default ''
		,entregavel char(1) default 'S'
		,chaveibpt char(10) default ''
		,cstpis char(2) default ''
		,cstcofins char(2) default ''
		,aliqpis decimal(9,2) default 0
		,aliqcofins decimal(9,2) default 0
		,cest char(7) default ''
		,precocusto decimal(10,3) default 0
		,marca varchar(30) default ''
		,validinicial datetime default '17530101'
		,validfinal datetime default '17530101'
		,tabela smallint default 0
    )
go
