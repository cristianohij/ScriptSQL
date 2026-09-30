-- exclusão da ST em 01/07/2026 - SP

DECLARE @ST TABLE
(
    NCM  VARCHAR(8),
    CEST VARCHAR(7),
    DESCRICAO VARCHAR(200)
);

INSERT INTO @ST VALUES
('22011000','0300300','Água mineral/potável em vidro descartável'),
('22011000','0300301','Água mineral/potável com sais em vidro descartável'),
('22019000','0300301','Água mineral/potável com sais em vidro descartável'),
('22011000','0300500','Água mineral/potável em copo plástico descartável'),
('22019000','0300500','Água mineral/potável em copo plástico descartável'),
('22011000','0300501','Água mineral/potável com sais em copo plástico descartável'),
('22019000','0300501','Água mineral/potável com sais em copo plástico descartável'),
('22011000','0300502','Água mineral/potável em jarra descartável'),
('22019000','0300502','Água mineral/potável em jarra descartável'),
('22011000','0300503','Água mineral/potável com sais em jarra descartável'),
('22019000','0300503','Água mineral/potável com sais em jarra descartável'),
('22011000','0300504','Água mineral/potável em demais embalagens descartáveis'),
('22019000','0300504','Água mineral/potável em demais embalagens descartáveis'),
('22011000','0300505','Água mineral/potável com sais em demais embalagens descartáveis'),
('22019000','0300505','Água mineral/potável com sais em demais embalagens descartáveis'),
('2201','0300600','Outras águas minerais, gasosas ou potáveis naturais'),
('22021000','0300700','Água aromatizada artificialmente'),
('22029900','0300800','Outras águas minerais'),
('22011000','0302400','Água mineral em retornáveis (10L a <20L)'),
('22011000','0302500','Água mineral em retornáveis (>=20L)'),
('210500','2300100','Sorvetes'),
('1806','2300200','Preparados para sorvete'),
('1901','2300200','Preparados para sorvete'),
('2106','2300200','Preparados para sorvete'),
('0404','2300200','Preparados para sorvete'),
('6905','1002800','Telhas e produtos cerâmicos'),
('32131000','1900100','Tinta guache'),
('39162000','1900200','Espiral plástico'),
('39161000','1900300','Outros espirais'),
('391690','1900300','Outros espirais'),
('39261000','1900400','Artigos escolares de plástico'),
('42021','1900500','Maletas e pastas'),
('42029','1900500','Maletas e pastas'),
('42021','1900501','Baús e malas'),
('42029','1900501','Baús e malas'),
('39269090','1900600','Prancheta'),
('48022090','1900700','Bobina fax'),
('48119090','1900700','Bobina fax'),
('4802549','1900800','Papel seda'),
('48025499','1900900','Bobina PDV'),
('48025799','1900900','Bobina PDV'),
('48162000','1900900','Bobina PDV'),
('4802569','1901000','Cartolina'),
('4802579','1901000','Cartolina'),
('4802589','1901000','Cartolina'),
('37031010','1901100','Papel fotográfico'),
('37031029','1901100','Papel fotográfico'),
('37032000','1901100','Papel fotográfico'),
('37039010','1901100','Papel fotográfico'),
('37040000','1901100','Papel fotográfico'),
('48022000','1901100','Papel fotográfico'),
('48101390','1901200','Papel almaço'),
('48169010','1901300','Papel hectográfico'),
('39202019','1901400','Celofane'),
('48062000','1901500','Papel impermeável'),
('48081000','1901600','Papel crepon'),
('48102290','1901700','Papel fantasia'),
('4809','1901800','Papel carbono'),
('4816','1901800','Papel carbono'),
('4817','1901900','Envelopes'),
('48201000','1902000','Livros de registro'),
('48202000','1902100','Cadernos'),
('48203000','1902200','Classificadores'),
('48204000','1902300','Formulários'),
('48205000','1902400','Álbuns'),
('48209000','1902500','Pastas'),
('49090000','1902600','Cartões postais'),
('96081000','1902700','Canetas esferográficas'),
('96082000','1902800','Canetas ponta porosa'),
('96083000','1902900','Canetas tinteiro'),
('9608','1903000','Outras canetas'),
('480256','1903100','Papel cutsize'),
('52105990','1903200','Papel camurça'),
('76071190','1903300','Papel laminado');

SELECT DISTINCT
       P.PROCOD,
       P.PRODES,
       P.PROCLAFIS AS NCM_CADASTRO,
       P.PROCEST   AS CEST_CADASTRO,
       ST.NCM      AS NCM_ST,
       ST.CEST     AS CEST_ST,
       ST.DESCRICAO,
       P.PROSTATUS,
       P.PROSTBB,
       P.TGZCOD
 --into  PRO_EXCLUIDOS_ST_01_JUL_2026
FROM TBS010 P
INNER JOIN @ST ST
       ON P.PROCEST = ST.CEST
      AND P.PROCLAFIS LIKE ST.NCM + '%'
 where P.PROSTBB in ('10','30','60','70')
ORDER BY
       ST.DESCRICAO,
       P.PRODES;

-- alterar
-- PROSTBB = '00'
-- TGZCOD = 5

select *
  from PRO_EXCLUIDOS_ST_01_JUL_2026 with (nolock)

select count(*)      
  from TBS010 p with (nolock)
 inner join PRO_EXCLUIDOS_ST_01_JUL_2026 st with (nolock)
    on p.PROCOD = st.PROCOD

begin tran
update p
   set p.PROSTBB = '00'
       ,p.TGZCOD = 5
  from TBS010 p with (nolock)
 inner join PRO_EXCLUIDOS_ST_01_JUL_2026 st with (nolock)
    on p.PROCOD = st.PROCOD

rollback tran
commit tran

-- pedidos em aberto

select i.PDVCST
       ,Left(i.PDVCST,1)
       ,right(rtrim(i.PDVCST),2)
       ,i.PDVPERICMS
       ,i.PDVCFOP
       ,i.*
  from TBS0551 i with (nolock)
 inner join TBS010 p with (nolock)
         on p.PROCOD = i.PROCOD
 where exists (select 1 from TBS058 pr with (nolock) where pr.PRPNUM = i.PDVNUM and pr.PROCOD = i.PROCOD)
       and exists (select 1 from PRO_EXCLUIDOS_ST_01_JUL_2026 st with (nolock) where st.PROCOD = i.PROCOD)
       and right(rtrim(i.PDVCST),2) = '60'
       and i.PDVCFOP <> '5.409'

begin tran
update i
   set i.PDVCST = Left(i.PDVCST,1) + '00'
       ,i.PDVCFOP = '5.102'
       ,i.PDVPERICMS = 18
  from TBS0551 i with (nolock)
 inner join TBS010 p with (nolock)
         on p.PROCOD = i.PROCOD
 where exists (select 1 from TBS058 pr with (nolock) where pr.PRPNUM = i.PDVNUM and pr.PROCOD = i.PROCOD)
       and exists (select 1 from PRO_EXCLUIDOS_ST_01_JUL_2026 st with (nolock) where st.PROCOD = i.PROCOD)
       and right(rtrim(i.PDVCST),2) = '60'
       and i.PDVCFOP <> '5.409'

rollback tran
commit tran

-- orçamentoss em aberto (excesso de registro antigos)

/*
select i.ORCCST
       ,Left(i.ORCCST,1)
       ,right(rtrim(i.ORCCST),2)
       ,i.ORCPERICMS
       ,i.ORCCFOP
       ,i.*
  from TBS0431 i with (nolock)
 inner join TBS010 p with (nolock)
         on p.PROCOD = i.PROCOD
 where exists (select 1 from PRO_EXCLUIDOS_ST_01_JUL_2026 st with (nolock) where st.PROCOD = i.PROCOD)
       and right(rtrim(i.ORCCST),2) = '60'
       and i.ORCCFOP <> '5.409'
*/

-- lista de códigos para filtrar atualização GZ

select '''' + rtrim(ex.PROCOD) + ''','
  from PRO_EXCLUIDOS_ST_01_AGO_2026 ex with (nolock)

select *
  from TBS015 pp with (nolock)
 where pp.PDPCOD = '1640054'

go

-- exclusão da ST em 01/08/2026 - SP

DECLARE @ST TABLE
(
NCM       VARCHAR(8),
CEST      VARCHAR(7),
DESCRICAO VARCHAR(300)
);

INSERT INTO @ST VALUES
('74111010','1006400','Tubos de cobre e suas ligas, para instalacoes de agua quente e gas, para uso na construcao'),
('842112','2101100','Secadoras de roupa de uso domestico'),
('84211990','2101200','Outras secadoras de roupas e centrifugas de uso domestico'),
('84186931','2101300','Bebedouros refrigerados para agua'),
('84219','2101400','Partes das secadoras de roupas e centrifugas de uso domestico e dos aparelhos para filtrar ou depurar agua'),
('84501100','2101900','Maquinas de lavar roupa ate 10 kg, inteiramente automaticas, de uso domestico'),
('84501200','2102000','Outras maquinas de lavar roupa com secador centrifugo incorporado, de uso domestico'),
('84501900','2102100','Outras maquinas de lavar roupa de uso domestico'),
('845020','2102200','Maquinas de lavar roupa acima de 10 kg, de uso domestico'),
('84512100','2102400','Maquinas de secar de uso domestico ate 10 kg'),
('84512990','2102500','Outras maquinas de secar de uso domestico'),
('845190','2102600','Partes de maquinas de secar de uso domestico'),
('84521000','2102700','Maquinas de costura de uso domestico'),
('8508','2104000','Aspiradores'),
('8509','2104100','Aparelhos eletromecanicos de motor eletrico incorporado, de uso domestico e suas partes'),
('85098010','2104200','Enceradeiras'),
('85161000','2104300','Chaleiras eletricas'),
('85164000','2104400','Ferros eletricos de passar'),
('85166000','2104600','Outros fornos; fogareiros, grelhas e assadeiras (exceto portateis)'),
('85166000','2104700','Outros fornos; fogareiros, grelhas e assadeiras portateis'),
('85167100','2104800','Cafeteiras eletricas'),
('85167200','2104900','Torradeiras eletricas'),
('851679','2105000','Outros aparelhos eletrotermicos de uso domestico'),
('85169000','2105100','Partes dos aparelhos eletrotermicos da posicao 85.16 (chaleiras, ferros, fornos etc.)'),
('84145','2108800','Ventiladores (exceto os de uso agricola e do CEST 21.088.01)'),
('84145910','2108801','Microventiladores com area de carcaca inferior a 90 cm2'),
('84146000','2109000','Coifas com dimensao horizontal maxima nao superior a 120 cm'),
('84149020','2109100','Partes de ventiladores ou coifas aspirantes'),
('84212100','2109801','Outros aparelhos eletricos para filtrar ou depurar agua'),
('84243010','2109900','Lavadora de alta pressao e suas partes'),
('84243090','2109900','Lavadora de alta pressao e suas partes'),
('84249090','2109900','Lavadora de alta pressao e suas partes'),
('84672100','2110000','Furadeiras eletricas'),
('85162','2110100','Aparelhos eletricos para aquecimento de ambientes'),
('84231000','2110800','Balancas de uso domestico'),
('2309','2200100','Racao tipo pet para animais domesticos'),
('28289011','1100100','Agua sanitaria, branqueador e outros alvejantes'),
('28289019','1100100','Agua sanitaria, branqueador e outros alvejantes'),
('32064100','1100100','Agua sanitaria, branqueador e outros alvejantes'),
('34025000','1100100','Agua sanitaria, branqueador e outros alvejantes'),
('38089419','1100100','Agua sanitaria, branqueador e outros alvejantes'),
('34012090','1100200','Saboes, desinfetantes e sanitizantes em po, flocos, palhetas, granulos ou outras formas semelhantes, para lavar roupas'),
('38089419','1100200','Saboes, desinfetantes e sanitizantes em po, flocos, palhetas, granulos ou outras formas semelhantes, para lavar roupas'),
('34012090','1100300','Saboes, desinfetantes e sanitizantes liquidos para lavar roupas'),
('38089419','1100300','Saboes, desinfetantes e sanitizantes liquidos para lavar roupas'),
('34025000','1100400','Detergentes em po, flocos, palhetas, granulos ou outras formas semelhantes, inclusive adicionados de propriedades desinfetantes ou sanitizantes'),
('34025000','1100500','Detergentes liquidos, exceto para lavar roupa'),
('34025000','1100600','Detergente liquido para lavar roupa, inclusive adicionados de propriedades desinfetantes ou sanitizantes'),
('3402','1100700','Outros agentes organicos de superficie; preparacoes tensoativas, preparacoes para lavagem e preparacoes para limpeza (inclusive multiuso e limpadores), mesmo contendo sabao; em embalagem <= 50 litros ou 50 kg'),
('38099190','1100800','Amaciante/suavizante'),
('39241000','1100900','Esponjas para limpeza'),
('39249000','1100900','Esponjas para limpeza'),
('68053010','1100900','Esponjas para limpeza'),
('68053090','1100900','Esponjas para limpeza'),
('2207','1101000','Alcool etilico para limpeza'),
('22089000','1101000','Alcool etilico para limpeza'),
('73231000','1101100','Esponjas e palhas de aco; esponjas para limpeza, polimento ou uso semelhantes; todas de uso domestico'),
('39232','1101200','Sacos de lixo de conteudo igual ou inferior a 100 litros');

SELECT DISTINCT
       P.PROCOD,
       P.PRODES,
       P.PROCLAFIS AS NCM_CADASTRO,
       P.PROCEST   AS CEST_CADASTRO,
       ST.NCM      AS NCM_ST,
       ST.CEST     AS CEST_ST,
       ST.DESCRICAO,
       P.PROSTATUS,
       P.PROSTBB,
       P.TGZCOD
 into PRO_EXCLUIDOS_ST_01_AGO_2026
FROM TBS010 P
INNER JOIN @ST ST
       ON P.PROCEST = ST.CEST
      AND P.PROCLAFIS LIKE ST.NCM + '%'
 where P.PROSTBB in ('10','30','60','70')
ORDER BY
       ST.DESCRICAO,
       P.PRODES;

-- alterar
-- PROSTBB = '00'
-- PROCEST = ''
-- TGZCOD = 5

select *
  from PRO_EXCLUIDOS_ST_01_AGO_2026 with (nolock)

select count(*)      
  from TBS010 p with (nolock)
 inner join PRO_EXCLUIDOS_ST_01_AGO_2026 st with (nolock)
    on p.PROCOD = st.PROCOD

begin tran
update p
   set p.PROSTBB = '00'
       ,p.PROCEST = ''
       ,p.TGZCOD = 5
  from TBS010 p with (nolock)
 inner join PRO_EXCLUIDOS_ST_01_AGO_2026 st with (nolock)
    on p.PROCOD = st.PROCOD

rollback tran
commit tran