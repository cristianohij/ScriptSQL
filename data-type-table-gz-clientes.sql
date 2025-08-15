--drop type GZclientes

create type GZclientes
   as table
      ( codigo bigint default 0
	    ,razsoc char(50) default ''
		,tipoender varchar(15) default ''
		,ender varchar(60) default ''
		,numero int default 0
		,complemen varchar(20) default ''
		,bairro varchar(30) default ''
		,munic varchar(30) default ''
		,estado char(2) default ''
		,cep char(8) default ''
		,telefone varchar(15) default ''
		,cgc varchar(19) default ''
		,dtnasc date null
		,ultcompra date null
		,situacao char(1) default ''
		,limite decimal(13,2) default 0
		,saldo decimal(13,2) default 0
		,desconto decimal(5,2) default 0
		,promocao char(1) default ''
		,descgeral char(1) default ''
		,fiado char(1) default ''
		,mensagem varchar(80) default ''
		,limitechq decimal(13,2) default 0
		,limiteqtch int default 0
		,saldochq decimal(13,2) default 0
		,saldoqtchq int default 0
		,codbarra char(80) default ''
		,filler1 varchar(40) default ''
		,insest varchar(25) default ''
		,fidacum int default 0
		,filler2 char(2) default ''
		,filler3 varchar(10) default ''
		,ultcomval decimal(13,2) default 0
		,saldoconta decimal(13,2) default 0
		,qtdconta int default 0
		,bloqfin varchar(90) default ''
		,preco char(1) default ''
		,nivelbloq char(2) default ''
		,nomfan char(15) default ''
		,senha varchar(50) default ''
		,venctofia int default 0
		,livre int default 0
		,livrecond char(2) default ''
		,melhordia int default 0
		,contato varchar(40) default ''
		,ultatu date null
		,pais varchar(50) default ''
		,codpais int default 0
		,ibge int default 0
		,email varchar(200) default ''
		,indicadorinsest char(1) default ''
		,saldobonus decimal(13,2) default 0
		,acresprazo char(1) default ''
		,identifica_placa char(1) default ''
		,codigo_acordo int default 0
      );
go