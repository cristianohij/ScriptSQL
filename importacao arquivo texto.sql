-- objetos
create table objintegros (nome char(8) default '' ,descricao char(100) ,atualizacao datetime default '17530101' ,proprietario char(10) default '' ,
                          tipo char(2) default '')
on [PRIMARY]

--drop table objintegros

bulk insert objintegros from 'C:\temp\CristianoTransaction.txt' with (FIELDTERMINATOR = ';', ROWTERMINATOR = '\n')

select * from objintegros where nome = 'BAS001' and tipo = 'P'

update objintegros set tipo = subString(tipo,1,1)

delete objintegros

select a.nome,a.atualizacao,b.nome,b.atualizacao,c.nome,c.atualizacao
  from objintegros a Left join objintegros b on a.nome = b.nome and a.tipo = b.tipo
                     Left join objintegros c on a.nome = c.nome and a.tipo = c.tipo
 where a.tipo = 'P'
 group by a.nome,a.atualizacao,b.nome,b.atualizacao,c.nome,c.atualizacao
 order by a.nome

select atualizacao,tipo,nome,proprietario from objintegros order by nome,atualizacao desc,tipo,proprietario

select max(atualizacao),nome,tipo,proprietario from objintegros
 group by nome,tipo,proprietario
 order by nome

select atualizacao,tipo,nome,proprietario,descricao
  from objintegros a
 where proprietario = 'Alex' and atualizacao >
       (select max(atualizacao) from objintegros b where a.proprietario <> b.proprietario and a.nome = b.nome and a.tipo = b.tipo)
 order by atualizacao desc

select atualizacao,substring(convert(char(23),atualizacao,21),1,10) from objintegros where nome = 'TESTE'

select atualizacao,convert(char(23),atualizacao,21),substring(convert(char(23),atualizacao,21),12,2),
       convert(int,substring(convert(char(23),atualizacao,21),12,2)),convert(int,substring(convert(char(23),atualizacao,21),12,2))-3,
       right('0' + rtrim(convert(char(2),convert(int,substring(convert(char(23),atualizacao,21),12,2))-3)),2),
       substring(convert(char(23),atualizacao,21),1,11) + right('0' + rtrim(convert(char(2),convert(int,substring(convert(char(23),atualizacao,21),12,2))-3)),2) +
       substring(convert(char(23),atualizacao,21),14,10),
       convert(datetime,substring(convert(char(23),atualizacao,21),1,11) + right('0' + rtrim(convert(char(2),convert(int,substring(convert(char(23),atualizacao,21),12,2))-3)),2) +
       substring(convert(char(23),atualizacao,21),14,10))
  from objintegros where nome = 'TESTE' and
       convert(int,substring(convert(char(23),atualizacao,21),12,2))-3 > 0

select atualizacao from objintegros where nome = 'TESTE'

update objintegros set atualizacao = convert(datetime,substring(convert(char(23),atualizacao,21),1,11) +
                                     right('0' + rtrim(convert(char(2),convert(int,substring(convert(char(23),atualizacao,21),12,2))-3)),2) +
                                     substring(convert(char(23),atualizacao,21),14,10))
 where nome = 'TESTE' and
       convert(int,substring(convert(char(23),atualizacao,21),12,2))-3 > 0

update objintegros set atualizacao = convert(datetime,substring(convert(char(23),atualizacao,21),1,11) +
                                     right('0' + rtrim(convert(char(2),convert(int,substring(convert(char(23),atualizacao,21),12,2))-3)),2) +
                                     substring(convert(char(23),atualizacao,21),14,10))
 where convert(int,substring(convert(char(23),atualizacao,21),12,2))-3 > 0


-- atributos
create table attintegros (nome char(8) default '' ,descricao char(100) default '' ,tamanho int default 0 ,decima int default 0 ,picture char(19) default '' ,
                          atualizacao datetime default '17530101' ,tipo char(6) default '' ,range char(11) default '' ,formula char(200) default '' ,
                          proprietario char(10) default '')
on [PRIMARY]

--drop table attintegros

bulk insert attintegros from 'C:\temp\Cristiano.txt' with (FIELDTERMINATOR = ';', ROWTERMINATOR = '\n')

select * from attintegros