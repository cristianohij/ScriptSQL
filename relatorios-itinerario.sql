select *
  from TBS109 with (nolock)

select *
  from TBS1091 with (nolock)

select convert(date,ITIDATEMI) as 'data'
       ,count(*) as 'contador'
  from TBS109 with (nolock)
 where ITIDATEMI between '20240101' and '20240731'
 group by ITIDATEMI

select ITICARPLA as 'placa'
       ,convert(date,ITIDATEMI) as 'data'
       ,count(*) as 'contador'
  from TBS109 with (nolock)
 where ITIDATEMI between '20240101' and '20240731'
 group by ITICARPLA, ITIDATEMI

select ITICARPLA as 'placa'
       ,(select CARCODNOM from TBS108 with (nolock) where CARPLA=ITICARPLA) as 'carro'
       ,count(*) as 'contador'
  from TBS109 with (nolock)
 where ITIDATEMI between '20240101' and '20240731'
 group by ITICARPLA

select *
  from TBS108 with (nolock)

select (select m.MOTNOM from TBS142 m with (nolock) where m.MOTCOD=i.MOTCOD) as 'motorista'
       ,count(*) as 'contador'
  from TBS109 i with (nolock)
 where i.ITIDATEMI between '20240101' and '20240731'
 group by i.MOTCOD

select *
  from TBS142 with (nolock)


-- média de itinerários por mês

select convert(char(6),ITIDATEMI,112) as 'data'
       ,count(*) as qtde_no_mes
       ,count(*)/22 as media_por_dia
  from TBS109 with (nolock)
 where ITIDATEMI between '20230101' and '20250915'
 group by convert(char(6),ITIDATEMI,112)
 order by convert(char(6),ITIDATEMI,112)

-- valores mensal

drop table #itinerario

select c.ITIDATEMI
       ,c.ITINUM
       ,d.ITITOTDOC
  into #itinerario
  from TBS109 c with (nolock)
 inner join TBS1091 d with (nolock)
    on d.ITINUM=c.ITINUM

select *
  from #itinerario

select convert(char(6),ITIDATEMI,112) as 'data'
       ,count(distinct ITINUM) as qtde_no_mes
       ,count(distinct ITINUM)/22 as media_por_dia
       ,format(sum(ITITOTDOC), 'C', 'pt-BR') as valor_total
  from #itinerario
 where ITIDATEMI between '20250101' and '20250228'
 group by convert(char(6),ITIDATEMI,112)
 order by convert(char(6),ITIDATEMI,112)

-- 

select *
  from TBS108 with (nolock)

select convert(char(6),ITIDATEMI,112) as periodo
       ,ITICARPLA as placa
       ,(select CARCODNOM from TBS108 car with (nolock) where car.CARPLA=iti.ITICARPLA)
       ,count(*) as 'contador'
  from TBS109 iti with (nolock)
 where ITIDATEMI between '20230101' and '20250915'
 group by convert(char(6),ITIDATEMI,112)
          ,ITICARPLA
 order by convert(char(6),ITIDATEMI,112)
          ,ITICARPLA

drop table #itinerario

select convert(char(6),c.ITIDATEMI,112) as periodo
       ,c.ITICARPLA
       ,(select CARCODNOM from TBS108 car with (nolock) where car.CARPLA=c.ITICARPLA) as nome_carro
       ,d.ITITOTDOC
       ,c.ITINUM
       ,(select count(*) from TBS1091 with (nolock) where ITINUM=c.ITINUM) as qtde_notas
  into #itinerario
  from TBS109 c with (nolock)
 inner join TBS1091 d with (nolock)
    on d.ITINUM=c.ITINUM

select *
  from #itinerario

select periodo
       ,ITICARPLA
       ,nome_carro
       ,count(distinct ITINUM) as qtde_itinerarios
       --,round(count(distinct ITINUM)/22,2) as media_itinerarios
       ,round(cast(count(distinct ITINUM) as decimal)/22,2) as media_itinerarios
       ,count(*) as qtde_notas_fiscais
       ,round(cast(count(*) as decimal)/22,2) as media_notas
       --,format(sum(ITITOTDOC), 'C', 'pt-BR') as valor_total
       ,sum(ITITOTDOC) as valor_total
  from #itinerario
 where periodo between '202301' and '202509'
 group by periodo, ITICARPLA, nome_carro
 order by periodo desc, nome_carro


EXEC sp_help 'TBS142';

SELECT * FROM TBS142 WHERE MOTNOM = 'ANTÔNIO';

select *
  from usuarios with (nolock)


CREATE TABLE refresh_tokens (
    id INT IDENTITY(1,1) PRIMARY KEY,       -- Identificador único auto-incrementado
    user_id INT NOT NULL,                   -- ID do usuário (relaciona-se com a tabela 'usuarios')
    refresh_token VARCHAR(255) NOT NULL,    -- O token de atualização
    expiration DATETIME NOT NULL,           -- Data e hora de expiração do token
    created_at DATETIME DEFAULT GETDATE(),  -- Data e hora de criação do token, com o padrão atual do sistema
    CONSTRAINT FK_user_id FOREIGN KEY (user_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

select *
  from usuarios with (nolock)
 where id=9
  order by nome

update usuarios
   set visualizar='N'

delete usuarios
 where id=19
 
SELECT TOP(1) id, nome, senha, codigo, primeiro_acesso, data_alteracao FROM usuarios WHERE codigo = 21

update usuarios
   set codigo=35
 where id=19

update usuarios
   set id_session=123456
 where id=8

update usuarios
   set data_alteracao='2024-11-05 12:14:00'
 where id=8

select *
  from refresh_tokens with (nolock)
 order by id desc

select MOTCOD
       ,MOTNOM
  from TBS142 m with (nolock)
 where exists(select 'e' from TBS109 i with (nolock) where i.MOTCOD=m.MOTCOD)
 
-- Passo 1: Remova a restrição de DEFAULT associada à coluna
ALTER TABLE refresh_tokens
DROP CONSTRAINT DF__refresh_t__id_se__7EA4EFEA;

-- Passo 2: Altere o tipo da coluna
ALTER TABLE refresh_tokens
ALTER COLUMN id_session VARCHAR(255);

-- Passo 3: (Opcional) Adicione novamente a restrição DEFAULT, se necessário
-- Exemplo: ALTER TABLE refresh_tokens
-- ADD CONSTRAINT DF_refresh_tokens_id_session DEFAULT 'valor_padrao' FOR id_session;


SELECT TOP(1) user_id, expiration FROM refresh_tokens WHERE refresh_token='8525d6737c223881c3df413a119a118034e25656392b62b053a96035fe09b5f6' AND id_session=123456 ORDER BY id DESC

exec sp_help 'usuarios'

ALTER TABLE refresh_tokens
ADD id_session INT NOT NULL DEFAULT 0

update usuarios
   set primeiro_acesso='S'

delete refresh_tokens

delete usuarios

alter table usuarios
  add alteracao DATETIME NOT NULL;

alter table usuarios
  add data_inclusao datetime not null default getdate(),
      data_alteracao datetime null default '17530101';

delete usuarios
 where id=7

select *
  from TBS1091 with (nolock)
 where ITINUM=4020
 order by ITIORDENT

select *
  from TBS109 with (nolock)
 where ITINUM=4020

SELECT user_id, expiration FROM refresh_tokens WHERE refresh_token = 9801400a55fbef8852f70715b085a9057bad058235c0d9c29576b0f0b51f4c1d
SELECT user_id, expiration FROM refresh_tokens WHERE refresh_token = '9801400a55fbef8852f70715b085a9057bad058235c0d9c29576b0f0b51f4c1d'

SELECT id, nome, senha, codigo, primeiro_acesso, data_alteracao FROM usuarios WHERE nome = '21' OR codigo = '21'

EXEC sp_help 'TBS1091'

ALTER TABLE TBS1091
ADD ITIRECPOR CHAR(50) NULL DEFAULT '';

ALTER TABLE TBS1091
ADD ITIDEPREC CHAR(50) NULL DEFAULT '';

CREATE TABLE versao_app_itinerario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo_versao INT NOT NULL,
    nome_versao VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE()
);

drop table versao_app_itinerario

insert into versao_app_itinerario (codigo_versao, nome_versao) values(1,'1.0.0')

select * from versao_app_itinerario with (nolock)



SELECT id, codigo_versao, nome_versao FROM versao_app_itinerario ORDER BY id DESC

update versao_app_itinerario
   set codigo_versao=1
      ,nome_versao='1.0.0'

insert into versao_app_itinerario (codigo_versao, nome_versao) values(5,'1.1.0')

select *
  from TBS1091 with (nolock)

update TBS1091
   set ITIRECPOR=''
       ,ITIDEPREC=''

SELECT a.ITIEMPCOD empresa
       ,a.ITINUM num_itinerario
       ,a.ITIDATSAI data_saida
       ,rtrim(a.ITIHORSAI) hora_saida
       ,rtrim(b.MOTNOM) condutor
       ,rtrim(c.CARCODNOM) nome_veiculo
                    FROM TBS109 a WITH (NOLOCK)
                    INNER JOIN TBS142 b WITH (NOLOCK) ON a.MOTCOD = b.MOTCOD
                    INNER JOIN TBS108 c WITH (NOLOCK) ON a.ITICARPLA = c.CARPLA
                    WHERE ITIEMPCOD = 0 AND ITIDATSAI = '20250203'

select *
  from usuarios with (nolock)
 order by nome

update usuarios
   set visualizar='S'
 where nome in('cristiano', 'Olimpio') 

SELECT id, codigo_versao, nome_versao FROM versao_app_itinerario ORDER BY id DESC



