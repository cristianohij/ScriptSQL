SE RODAR TODO O CÓDIGO POR ENGANO, NÃO IRÁ FUNCIONAR

-- cest para nfc-e

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBA + p.PROSTBB
       ,p.PROCEST
  from TBS010 p with (nolock)
 where p.PROSTBB = '60'
       and p.PROCEST = ''

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBA + p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST
  from TBS010 p with (nolock)
 where --p.PROSTBB = '60'
       --and 
       --p.PROCEST = ''
       --and p.PROCOD in ('1864753','12130610','0110434')     -- não encontrado
       --and p.PROCOD in ('7883253','7883269','7883273','7883277','7883280','12180001','19540011','19730134','27050064','28610509','35030001','35030002')
       p.PROCOD in ('16720049','26340016','16720049','27050034','27050064','27050029')
 order by p.PROCOD

begin tran
update TBS010
   set PROCEST = '1706200'
 where PROCOD in ('35030001','35030002')

rollback tran
commit tran

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBA + p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST
  from TBS010 p with (nolock)
 where p.PROSTBB = '60'
       and p.PROCEST = ''
       and p.PROCOD in 
('0061002','0110434','0124958','0125059','0680302','1540842','1547020','1547021','1547022','1547043',
 '1864683','1864737','1990039','1990176','1990179','1990188','2130329','2130330','2130334','2130338',
 '2130341','2320049','2320051','2320090','2320122','2320127','2320129','2540072','2881813','2881818',
 '2881821','2881827','3310061','3390015','3940160','3940195','5360501','5860016','5860024','5867759',
 '5867761','6150016','6150022','6150023','6150033','6150060','6150065','6150066','6150070','6150071',
 '6150072','6150073','6150074','6150093','7040015','7040017','7040113','7040270','7040288','7040296',
 '7040482','7040490','7040504','7040581','7040652','7041834','7041862','7041895','7041896','7041906',
 '7041907','7041910','7041919','7041920','7041926','7041927','7041948','7041956','7041988','7042015',
 '7440111','7440112','7440123','7650029','7889969','7960026','7960034','8130002','8130003','8130005',
 '8130007','8130013','8130015','8130016','8130019','8130022','8130028','8130029','8130030','8130032',
 '8130033','8130034','8130036','8130041','8132311','8132312','8132314','8260003','8260009','8260014',
 '8260109','8260117','8260150','8260168','8260176','8260633','8260642','8260646','8260649','8260660',
 '8260663','8260671','8260673','8260681','8407758','8770119','9360343','9360350','9360355','9380023',
 '9870016','9870024','9870035','9870071','9870076','9870077','9870078','9870091','9870121','9870177',
 '9870178','9870188','9870192','9870196','9870214','9870231','9877137','9877138','9877187','9877197',
 '9877200','9877201','9877210','9970079','10360328','10420041','10820005','10820018','10820021',
 '11080002','11080008','11080036','11080037','11080038','11080046','11080055','11080056','11080058',
 '11080059','11080072','11080080','11080135','11080138','11080140','11080149','11080152','11080172',
 '11080173','11080188','11080195','11080202','11080205','11380062','11380070','11440021','11440023',
 '11440025','11550029','11610257','11610312','11780184','11840001','11840006','11860001','11860002',
 '11860007','11890076','11990012','11990013','12130010','12130059','12130098','12130102','12130121',
 '12130126','12130163','12130164','12130166','12130310','12130383','12130499','12130510','12130511',
 '12130512','12130514','12130523','12130610','12130699','12130701','12130709','12130715','12130765',
 '12130780','12130822','12130826','12130827','12130846','12130848','12130858','12180002','12180021',
 '12270008','12270085','12270120','12270153','12270168','12430002','12430007','12430093','12570190',
 '12570257','12570265','12570266','12570286','12570289','12570543','13400117','15700002','16220005',
 '16220011','16220012','16220024','16220029','16360014','18264733','18880001','18880002','18880013',
 '18880014','18880015','18880017','19520019','19540010','19540021','19540022','19540039','19540041',
 '19540045','19590003','19590005','19590006','20050144','20320031','20540070','20560010','20960449',
 '20960534','20963358','20965054','20966071','20967402','21510020','21530025','21830002','21910006',
 '21910007','21910008','21910015','23660061','24020042','24100002','24100014','24100028','24100065',
 '24100098','24100120','25920007','26340039','26340040','26450062','26510067','26830001','26830002',
 '26970004','26970008','27130011','27870005','34510001','34550001','34550002','34580001','34580002',
 '34580003','34580004','34580005','34580006','34580007','34580008','35030003','35240001','35290001',
 '76020001','76020002','76020003','76020005','76020006','76020009','76020010','76020011','76020013',
 '76020018','76020019','76020022','76100001','76100003','84230002')

---------------------------------------


-- códigos dos fornecedores do grupo

if object_id('tempdb.dbo.#grupo') is not null
    begin
    	drop table #grupo
    end

create table #grupo (codigo int)

insert into #grupo
exec usp_FornecedoresGrupo 1

select *
  from #grupo

select FORCOD
       ,FORNOM
       ,FORCGC
  from TBS006 with (nolock)
 where FORCOD in(select codigo from #grupo)

-- NCM do produto conforme nota fiscal do fornecedor

if object_id('tempdb.dbo.#ncm_cest_entrada') is not null
    begin
    	drop table #ncm_cest_entrada
    end

select c.NFETIP
       ,c.SERCOD
       ,c.NFECOD
       ,c.NFENUM
       ,c.NFEDATEFE
       ,i.PROCOD
       ,i.NFENCMXML
       ,i.NFECESTXML
  into #ncm_cest_entrada
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE != '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #grupo with (nolock))
       and i.NFENCMXML != ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from TBS059 c1 with (nolock)
                            inner join TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE != '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML != ''
                                  and c.NFECOD not in(select codigo from #grupo with (nolock))
                         )

select *
  from #ncm_cest_entrada

-- lista de produtos do cadastro, com NCM vazio ou de tamanho menor do que 8

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       --,n.NFENCMXML
  from TBS010 p with (nolock)
 where p.PROCLAFIS = ''
       or Len(p.PROCLAFIS) < 8
 order by p.PROCOD

-- lista de produtos do cadastro, com NCM vazio ou tamanho menor do que 8 e com NCM recebido na nota fiscal de entrada

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
       ,n.NFECESTXML
       ,n.NFEDATEFE
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD=p.PROCOD
 where p.PROCLAFIS = ''
       or Len(p.PROCLAFIS) < 8
 order by p.PRODES

-- lista de produtos do cadastro, com NCM diferente do NCM recebido na nota fiscal de entrada

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
       ,n.NFECESTXML
       ,n.NFEDATEFE
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD=p.PROCOD
 where Len(p.PROCLAFIS) = 8
       and p.PROCLAFIS <> n.NFENCMXML
 order by p.PRODES


begin tran
update p
   set p.PROCLAFIS = n.NFENCMXML
  from TBS010 p with (nolock)
 inner join #proncm n
    on n.PROCOD = p.PROCOD
 where (p.PROCLAFIS = ''
       or Len(p.PROCLAFIS) < 8)
       and Len(n.NFENCMXML) = 8

rollback tran
commit tran

-- conta produtos com st e cest vazio

select count(*)
  from TBS010 p with (nolock)
 where p.PROSTBB = '60'
       and p.PROCEST = ''

-- cest com tamanho inválido

select PROCOD
       ,PRODES
	     ,PROCLAFIS
	     ,PROCEST
  from TBS010 with (nolock)
 where PROCEST <> ''
       and Len(PROCEST) <> 7

-- cest preenchido, ncm vazio

select PROCOD
       ,PRODES
	   ,PROCLAFIS
	   ,PROCEST
  from TBS010 with (nolock)
 where PROCEST <> ''
       and PROCLAFIS = ''


-- empresas do grupo cadastradas como fornecedores

if object_id('tempdb.dbo.#fornecedoresGrupo') is not null
    begin
    	drop table #fornecedoresGrupo
    end

create table #fornecedoresGrupo (codigo int)

insert into #fornecedoresGrupo
exec usp_FornecedoresGrupo 1

select *
  from #fornecedoresGrupo with (nolock)

-- cest das notas fiscais de fornecedores

if object_id('tempdb.dbo.#ncm_cest_entrada') is not null
    begin
    	drop table #ncm_cest_entrada
    end

select c.NFETIP
       ,c.SERCOD
       ,c.NFECOD
       ,c.NFENUM
       ,c.NFEDATEFE
       ,i.PROCOD
       ,i.NFENCMXML
       ,i.NFECESTXML
  into #ncm_cest_entrada
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE <> '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP = 'N'
       and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
       --and i.NFECESTXML <> ''
       --and cast(NFECESTXML as int) > 0
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from TBS059 c1 with (nolock)
                            inner join TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE != '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP ='N'
                                  and i1.PROCOD = i.PROCOD
                                  --and i1.NFECESTXML != ''
                                  and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
                         )

-- cest inválido

select *
  from #ncm_cest_entrada
 where cast(NFECESTXML as int) = 0

begin tran
update #ncm_cest_entrada
   set NFECESTXML = ''
 where cast(NFECESTXML as int) = 0

rollback tran
commit tran

-- ncm inválido

select *
  from #ncm_cest_entrada
 where cast(NFENCMXML as int) = 0

begin tran
update #ncm_cest_entrada
   set NFENCMXML = ''
 where cast(NFENCMXML as int) = 0

rollback tran
commit tran

-- lista de produtos do cadastro, com NCM vazio ou de tamanho menor do que 8

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
  from TBS010 p with (nolock)
 where p.PROCLAFIS = ''
       or Len(p.PROCLAFIS) < 8
 order by p.PROCOD

-- lista de produtos do cadastro, com NCM vazio ou tamanho menor do que 8 e com NCM recebido na nota fiscal de entrada

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
       ,n.NFECESTXML
       ,n.NFEDATEFE
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD = p.PROCOD
 where cast(p.PROCLAFIS as int) = 0
       and cast(n.NFENCMXML as int) > 0

-- update

begin tran
update p
   set p.PROCLAFIS = n.NFENCMXML
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD = p.PROCOD
 where cast(p.PROCLAFIS as int) = 0
       and cast(n.NFENCMXML as int) > 0

rollback tran
commit tran

-- lista de produtos do cadastro, com NCM diferente do NCM recebido na nota fiscal de entrada

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
       ,n.NFECESTXML
       ,n.NFEDATEFE
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD=p.PROCOD
 where Len(p.PROCLAFIS) = 8
       and Len(n.NFENCMXML) = 8
       and p.PROCLAFIS <> n.NFENCMXML
 order by p.PRODES

begin tran
update p
   set p.PROCLAFIS = n.NFENCMXML
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD = p.PROCOD
 where Len(p.PROCLAFIS) = 8
       and Len(n.NFENCMXML) = 8
       and p.PROCLAFIS <> n.NFENCMXML

rollback tran
commit tran

-- conta produtos com st e cest vazio

select count(*)
  from TBS010 p with (nolock)
 where p.PROSTBB = '60'
       and p.PROCEST = ''

-- cest com tamanho inválido

select PROCOD
       ,PRODES
	     ,PROCLAFIS
	     ,PROCEST
  from TBS010 with (nolock)
 where PROCEST <> ''
       and Len(PROCEST) <> 7

-- cest preenchido, ncm vazio

select PROCOD
       ,PRODES
	   ,PROCLAFIS
	   ,PROCEST
  from TBS010 with (nolock)
 where PROCEST <> ''
       and PROCLAFIS = ''

-- lista produtos com cst de substituição trituária 

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,p.PROSTBA
       ,p.PROSTBB
  from TBS010 p with (nolock)
 where p.PROSTBB in ('10','30','60','70')
 order by p.PROCOD

-- update cst

begin tran
update p
   set p.PROSTBB = '60'
  from TBS010 p with (nolock)
  where p.PROSTBB in ('10','30','70')

rollback tran
commit tran

-- lista produtos com cest inválido

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,p.PROSTBA
       ,p.PROSTBB
  from TBS010 p with (nolock)
 where p.PROSTBB in ('10','30','70')
       and cast(p.PROCEST as int) = 0
 order by p.PROCOD

-- lista produto com st (cst 60) e sem cest cadastrado

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,p.PROSTBA
       ,p.PROSTBB
  from TBS010 p with (nolock)
 where p.PROSTBB in ('10','30','60','70')
       and p.PROCEST = ''
 order by p.PROCOD

-- lista de produtos do cadastro, com CEST vazio e CST de substituição tributária, com CEST recebido na nota fiscal de entrada

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
       ,n.NFECESTXML
       ,n.NFEDATEFE
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD = p.PROCOD
 where p.PROSTBB in ('10','30','60','70')
       and p.PROCEST = ''
       and cast(n.NFECESTXML as int) > 0

-- update

begin tran
update p
   set p.PROCEST = n.NFECESTXML
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD = p.PROCOD
 where p.PROSTBB in ('10','30','60','70')
       and p.PROCEST = ''
       and cast(n.NFECESTXML as int) > 0

rollback tran
commit tran

-- lista de produtos do cadastro, com CEST diferente do CEST recebido na nota fiscal de entrada

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
       ,n.NFECESTXML
       ,n.NFEDATEFE
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD = p.PROCOD
 where Len(p.PROCEST) = 7
       and Len(n.NFECESTXML) = 7
       and p.PROCEST <> n.NFECESTXML
 order by p.PRODES

begin tran
update p
   set p.PROCEST = n.NFECESTXML
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada n
    on n.PROCOD = p.PROCOD
 where Len(p.PROCEST) = 7
       and Len(n.NFECESTXML) = 7
       and p.PROCEST <> n.NFECESTXML

rollback tran
commit tran

/*
TBS092	NCM
TBS157	reduções da BC do ICMS
TBS154	CEST (...1541/2)
	1541 CEST X NCM
	1542 descrição da NCM
TBS123	CEST (utilizar?)
*/

-- tabela CEST x NCM

select *
  from TBS1541 cest_ncm with (nolock)

select count(distinct p.PROCOD) as TotalProdutos
  from TBS010 p with (nolock)
 where p.PROSTBB in ('10','30','60','70')
       and p.PROCEST = ''
       and exists (
                    select 1
                      from TBS1541 cn with (nolock)
                     where cn.CESTMVANCM = p.PROCLAFIS
                           and cast(cn.CESTMVACOD as int) > 0
                           and len(cn.CESTMVACOD) = 7
                  );

-- update

begin tran
update p
   set p.PROCEST = cn.CESTMVACOD
  from TBS010 p with (nolock)
 inner join TBS1541 cn with (nolock)
         on cn.CESTMVANCM = p.PROCLAFIS
 where p.PROSTBB in ('10','30','60','70')
       and p.PROCEST = ''
       and cast(cn.CESTMVACOD as int) > 0
       and Len(cn.CESTMVACOD) = 7

rollback tran
commit tran

-- tabelão de NCM

drop table #tabelao_ncm_cest

-- tanby nd

select p.PROCOD collate database_default as codigo
       ,p.PROCLAFIS collate database_default as ncm
       ,p.PROCEST collate database_default as cest
  into #tabelao_ncm_cest
  from TBS010 p with (nolock)
 where cast(p.PROCLAFIS as int) > 0

union

-- best bag

select p.PROCOD
       ,p.PROCLAFIS
       ,p.PROCEST
  from bb.SIBD2.dbo.TBS010 p with (nolock)
 where cast(p.PROCLAFIS as int) > 0

union

-- misaspel

select p.PROCOD
       ,p.PROCLAFIS
       ,p.PROCEST
  from mi.SIBD3.dbo.TBS010 p with (nolock)
 where cast(p.PROCLAFIS as int) > 0

union

-- papelyna

select p.PROCOD
       ,p.PROCLAFIS
       ,p.PROCEST
  from pp.SIBD.dbo.TBS010 p with (nolock)
 where cast(p.PROCLAFIS as int) > 0

union

-- tanby cd

select p.PROCOD
       ,p.PROCLAFIS
       ,p.PROCEST
  from cd.SIBD.dbo.TBS010 p with (nolock)
 where cast(p.PROCLAFIS as int) > 0

union

-- tanby taubaté 

select p.PROCOD
       ,p.PROCLAFIS
       ,p.PROCEST
  from tt.SIBD.dbo.TBS010 p with (nolock)
 where cast(p.PROCLAFIS as int) > 0

select count(*)
  from #tabelao_ncm_cest

-- atualiza NCM vazios e que existam em outras empresas do grupo

-- tanby nd (x), best bag (x), misaspel (x), papelyna (x), tanby cd (x), tanby taubaté (x)

select p.PROCOD
       ,p.PROCLAFIS
  from tt.SIBD.dbo.TBS010 p with (nolock)
 where Len(p.PROCLAFIS) < 8
       and exists (
                    select 1
                      from #tabelao_ncm_cest ncm_cest with (nolock)
                     where ncm_cest.codigo = p.PROCOD collate database_default
                           and cast(ncm_cest.ncm as int) > 0
                           and Len(ncm_cest.ncm) = 8
                  );

-- update

begin tran
update p
   set p.PROCLAFIS = ncm.ncm
from tt.SIBD.dbo.TBS010 p
cross apply (
    select top (1) nc.ncm
    from #tabelao_ncm_cest nc
    where nc.codigo = p.PROCOD collate database_default
      and len(nc.ncm) = 8
      and try_cast(nc.ncm as int) > 0
    order by nc.ncm  -- 🔹 ajuste se houver um critério melhor
) ncm
where len(p.PROCLAFIS) < 8;

rollback tran
commit tran

-- atualiza CEST vazios e que existam em outras empresas do grupo

-- tanby nd (x), best bag (x), misaspel (x), papelyna (x), tanby cd (x), tanby taubaté (x)

select p.PROCOD
       ,p.PROCEST
  from tt.SIBD.dbo.TBS010 p with (nolock)
 where Len(p.PROCEST) < 7
       and exists (
                    select 1
                      from #tabelao_ncm_cest ncm_cest with (nolock)
                     where ncm_cest.codigo = p.PROCOD collate database_default
                           and cast(ncm_cest.cest as int) > 0
                           and Len(ncm_cest.cest) = 7
                  );

-- update

begin tran
update p
   set p.PROCEST = cest.cest
from tt.SIBD.dbo.TBS010 p
cross apply (
    select top (1) nc.cest
    from #tabelao_ncm_cest nc
    where nc.codigo = p.PROCOD collate database_default
      and len(nc.cest) = 7
      and try_cast(nc.cest as int) > 0
    order by nc.cest  -- 🔹 ajuste se houver um critério melhor
) cest
where len(p.PROCEST) < 7;

rollback tran
commit tran

-- produto sem ST

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBA
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST

select p.PROCLAFIS as ncm
       ,count(*) as registros
  --into #ncm
  from TBS010 p with (nolock)
 where p.PROSTBB in ('10','30','60','70')
       and not exists (
                        select 'ne'
                          from TBS1541 st with (nolock)
                         where Left(st.CESTMVANCM,4) = Left(p.PROCLAFIS,4)
                      )
 group by p.PROCLAFIS
 order by count(*) desc

-- update

-- chatgpt

begin tran
update p
   set p.PROSTBB = '00',
       p.PROCEST = ''
  from TBS010 p
 where p.PROSTBB in ('10','30','60','70')
   and not exists (
        select 1
          from TBS1541 st
         where left(st.CESTMVANCM,4) = left(p.PROCLAFIS,4)
   )

rollback tran
commit tran

select *
  from #ncm

select *
  from TBS1541 nc with (nolock)
 where nc.CESTMVANCM = '42021210'

declare @ncm varchar(500)

set @ncm = '''35061010','85131010'''

select *
  from TBS010 p with (nolock)
 where p.PROCLAFIS in (@ncm)

begin tran
update TBS010
   set PROSTBB = '00'
       ,PROCEST = ''
 where PROCLAFIS = @ncm
       and PROSTBB in ('10','30','60','70')
       and exists (select 1 from #ncm where ncm = PROCLAFIS)

rollback tran
commit tran

-- empresas do grupo cadastradas como fornecedores

if object_id('tempdb.dbo.#fornecedoresGrupo') is not null
    begin
    	drop table #fornecedoresGrupo
    end

create table #fornecedoresGrupo (codigo int)

insert into #fornecedoresGrupo
exec usp_FornecedoresGrupo 1

select *
  from #fornecedoresGrupo with (nolock)

if object_id('tempdb.dbo.#reducao') is not null
    begin
    	drop table #reducao
    end

-- produtos recebidos com redução da base de cálculo do icms

select i.PROCOD
       ,i.NFECSTXML
       ,i.NFEREDBASICMS
  into #reducao
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE > '20200101'
       and c.NFECAN = 'N'
       and c.NFETIP = 'N'
       and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
       and i.NFEREDBASICMS > 0
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from TBS059 c1 with (nolock)
                            inner join TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE > '20200101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP ='N'
                                  and i1.PROCOD = i.PROCOD
                                  --and i1.NFECESTXML != ''
                                  and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
                         )

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBA
       ,p.PROSTBB
       ,r.NFECSTXML
       ,r.NFEREDBASICMS
  from TBS010 p with (nolock)
 inner join #reducao r
         on r.PROCOD = p.PROCOD
 where p.PROREDBASICMS = 0

select top (1000) *
  from DWVendas dwv with (nolock)
 order by [data] desc

select top (1000) *
  from movcaixagz m with (nolock)
 order by [data] desc

select top(1000) *
  from TBS0671 d with (nolock)

select sum(dbo.NFSTOTICMS(c.NFSEMPCOD, c.NFSNUM, c.SNEEMPCOD, c.SNESER))
  from TBS067 c with (nolock)
 where c.NFSDATEMI between '20250101' and '20251231'

select dbo.NFSBASICMS(d.NFSEMPCOD, d.NFSNUM, d.SNEEMPCOD, d.SNESER, d.NFSITE) as base_icms
       ,dbo.NFSVALICMS(d.NFSEMPCOD, d.NFSNUM, d.SNEEMPCOD, d.SNESER, d.NFSITE) as valor_icms
       ,d.NFSCST as cst_nf
       ,r.NFECSTXML as cst_xml
       ,r.NFEREDBASICMS as reducao_xml
  from TBS0671 d with (nolock)
 inner join TBS067 c with (nolock)
         on d.SNESER = c.SNESER
            and d.NFSNUM = c.NFSNUM
 inner join #reducao r
         on r.PROCOD = d.PROCOD
 where c.NFSDATEMI between '20250101' and '20251231'
       and d.NFSREDBCICMS = 0

-- Usar CROSS APPLY (melhor prática)

select v.base_icms
       ,v.valor_icms
       ,d.NFSCST as cst_nf
       ,r.NFECSTXML as cst_xml
       ,r.NFEREDBASICMS as reducao_xml
       ,d.NFSPERICMS as per_icms
       ,v.base_icms * (100 - r.NFEREDBASICMS) / 100 as base_com_reducao
       ,v.base_icms * (100 - r.NFEREDBASICMS) / 100 * (d.NFSPERICMS /100) as valor_icms_com_reducao
  from TBS0671 d with (nolock)
 inner join TBS067 c with (nolock)
         on d.SNESER = c.SNESER
        and d.NFSNUM = c.NFSNUM
 inner join #reducao r
         on r.PROCOD = d.PROCOD
 cross apply (
     select dbo.NFSBASICMS(d.NFSEMPCOD, d.NFSNUM, d.SNEEMPCOD, d.SNESER, d.NFSITE) as base_icms,
            dbo.NFSVALICMS(d.NFSEMPCOD, d.NFSNUM, d.SNEEMPCOD, d.SNESER, d.NFSITE) as valor_icms
 ) v
 where c.NFSDATEMI between '20250101' and '20251231'
   and d.NFSREDBCICMS = 0
   and v.valor_icms > 0

-- Todas as linhas detalhadas
-- Uma única linha no final com o TOTAL GERAL

;with dados as (
    select 
           d.NFSCST as cst_nf,
           v.base_icms,
           v.valor_icms,
           v.base_icms * (100 - r.NFEREDBASICMS) / 100.0 as base_com_reducao,
           v.base_icms * (100 - r.NFEREDBASICMS) / 100.0 
               * (d.NFSPERICMS / 100.0) as valor_icms_com_reducao
      from TBS0671 d with (nolock)
     inner join TBS067 c with (nolock)
             on d.SNESER = c.SNESER
            and d.NFSNUM = c.NFSNUM
     inner join #reducao r
             on r.PROCOD = d.PROCOD
     cross apply (
         select dbo.NFSBASICMS(d.NFSEMPCOD, d.NFSNUM, d.SNEEMPCOD, d.SNESER, d.NFSITE) as base_icms,
                dbo.NFSVALICMS(d.NFSEMPCOD, d.NFSNUM, d.SNEEMPCOD, d.SNESER, d.NFSITE) as valor_icms
     ) v
     where c.NFSDATEMI between '20250101' and '20251231'
       and d.NFSREDBCICMS = 0
       and v.valor_icms > 0
)

select *
from (
    -- linhas detalhadas
    select *
    from dados

    union all

    -- total geral
    select 
           'TOTAL GERAL',
           sum(base_icms),
           sum(valor_icms),
           sum(base_com_reducao),
           sum(valor_icms_com_reducao)
    from dados
) x
order by 
    case when x.cst_nf = 'TOTAL GERAL' then 1 else 0 end,
    x.cst_nf


select p.PROCOD
       ,p.PRODES
       ,p.PROSTBA
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST
  from TBS010 p with (nolock)
 where Len(p.PROCEST) = 7
       and p.PROCEST in ('1701000','1701100','1703000','1703100','1703101','1703200','1703300','1704200','1704300','1706500','1706600','1706700','1706800','1706900','1706901','1707000','1707100','1707200','1707300','1707400','1708800','1711500')

-- códigos fornecedores grupo

if object_id('tempdb.dbo.#grupo_nd') is not null
    begin
    	drop table #grupo_nd
    end

select f.FORCOD as codigo
  into #grupo_nd
  from TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- best bag

if object_id('tempdb.dbo.#grupo_bb') is not null
    begin
    	drop table #grupo_bb
    end

select f.FORCOD as codigo
  into #grupo_bb
  from bb.SIBD2.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- misaspel

if object_id('tempdb.dbo.#grupo_mi') is not null
    begin
    	drop table #grupo_mi
    end

select FORCOD as codigo
  into #grupo_mi	
  from mi.SIBD3.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- papelyna

if object_id('tempdb.dbo.#grupo_pp') is not null
    begin
    	drop table #grupo_pp
    end

select FORCOD as codigo
  into #grupo_pp
  from pp.SIBD.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- tanby cd

if object_id('tempdb.dbo.#grupo_cd') is not null
    begin
    	drop table #grupo_cd
    end

select FORCOD as codigo
  into #grupo_cd
  from cd.SIBD.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- tanby taubaté

if object_id('tempdb.dbo.#grupo_tt') is not null
    begin
    	drop table #grupo_tt
    end

select FORCOD as codigo
  into #grupo_tt
  from tt.SIBD.dbo.TBS006 f with (nolock)
 where f.FORCGC like('65069593%') or	-- tanby
       f.FORCGC like('05118717%') or	-- misaspel
       f.FORCGC like('52080207%') or	-- best bag
       f.FORCGC like('44125185%') or	-- papelyna
       f.FORCGC like('41952080%')		-- winpack
 order by f.FORCGC

-- NCM/CEST do produto conforme nota fiscal do fornecedor

if object_id('tempdb.dbo.#ncm_cest_entrada') is not null
    begin
    	drop table #ncm_cest_entrada
    end

;WITH Base AS (
select i.PROCOD
       ,isnull(i.NFENCMXML,'') as NFENCMXML
       ,isnull(i.NFECESTXML,'') as NFECESTXML
       ,c.NFEDATEFE
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE <> '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #grupo_nd with (nolock))
       and i.NFENCMXML <> ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from TBS059 c1 with (nolock)
                            inner join TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE <> '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML <> ''
                                  and c.NFECOD not in(select codigo from #grupo_nd with (nolock))
                         )

union all

-- best bag
select i.PROCOD
       ,isnull(i.NFENCMXML,'')
       ,isnull(i.NFECESTXML,'')
       ,c.NFEDATEFE
  from bb.SIBD2.dbo.TBS059 c with (nolock)
 inner join bb.SIBD2.dbo.TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE <> '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #grupo_bb with (nolock))
       and i.NFENCMXML <> ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from bb.SIBD2.dbo.TBS059 c1 with (nolock)
                            inner join bb.SIBD2.dbo.TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE <> '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML <> ''
                                  and c.NFECOD not in(select codigo from #grupo_bb with (nolock))
                         )

union all

-- misaspel
select i.PROCOD
       ,isnull(i.NFENCMXML,'')
       ,isnull(i.NFECESTXML,'')
       ,c.NFEDATEFE
  from mi.SIBD3.dbo.TBS059 c with (nolock)
 inner join mi.SIBD3.dbo.TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE <> '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #grupo_mi with (nolock))
       and i.NFENCMXML <> ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from mi.SIBD3.dbo.TBS059 c1 with (nolock)
                            inner join mi.SIBD3.dbo.TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE <> '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML <> ''
                                  and c.NFECOD not in(select codigo from #grupo_mi with (nolock))
                         )

union all

-- papelyna
select i.PROCOD
       ,isnull(i.NFENCMXML,'')
       ,isnull(i.NFECESTXML,'')
       ,c.NFEDATEFE
  from pp.SIBD.dbo.TBS059 c with (nolock)
 inner join pp.SIBD.dbo.TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE <> '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #grupo_pp with (nolock))
       and i.NFENCMXML <> ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from pp.SIBD.dbo.TBS059 c1 with (nolock)
                            inner join pp.SIBD.dbo.TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE <> '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML <> ''
                                  and c.NFECOD not in(select codigo from #grupo_pp with (nolock))
                         )

union all

-- tanby cd
select i.PROCOD collate database_default
       ,isnull(i.NFENCMXML,'') collate database_default
       ,isnull(i.NFECESTXML,'') collate database_default
       ,c.NFEDATEFE
  from cd.SIBD.dbo.TBS059 c with (nolock)
 inner join cd.SIBD.dbo.TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE <> '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #grupo_cd with (nolock))
       and i.NFENCMXML <> ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from cd.SIBD.dbo.TBS059 c1 with (nolock)
                            inner join cd.SIBD.dbo.TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE <> '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML <> ''
                                  and c.NFECOD not in(select codigo from #grupo_cd with (nolock))
                         )

union all

-- tanby taubaté
select i.PROCOD
       ,isnull(i.NFENCMXML,'')
       ,isnull(i.NFECESTXML,'')
       ,c.NFEDATEFE
  from tt.SIBD.dbo.TBS059 c with (nolock)
 inner join tt.SIBD.dbo.TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE <> '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #grupo_tt with (nolock))
       and i.NFENCMXML <> ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from tt.SIBD.dbo.TBS059 c1 with (nolock)
                            inner join tt.SIBD.dbo.TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE <> '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML <> ''
                                  and c.NFECOD not in(select codigo from #grupo_tt with (nolock))
                         )

),
Rankeado AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY PROCOD
               ORDER BY NFEDATEFE DESC
           ) AS rn
    FROM Base
)
SELECT *
INTO #ncm_cest_entrada
FROM Rankeado
WHERE rn = 1;

select *
  from #ncm_cest_entrada

-- registro duplicados

select PROCOD
       ,count(*)
  from #ncm_cest_entrada
 group by PROCOD
having count(*) > 1

select *
  from #ncm_cest_entrada
 where PROCOD in ( select PROCOD from #ncm_cest_entrada group by PROCOD having count(*) > 1)

WITH TempUnica AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY PROCOD ORDER BY NFENCMXML) AS rn
    FROM #ncm_cest_entrada
)
SELECT 
    p.PROCOD,
    p.PROCLAFIS,
    t.NFENCMXML
FROM TBS010 p
INNER JOIN TempUnica t
    ON t.PROCOD = p.PROCOD
   AND t.rn = 1
WHERE ISNULL(p.PROCLAFIS, '') <> ISNULL(t.NFENCMXML, '');

WITH TempUnica AS (
    SELECT PROCOD, NFENCMXML
    FROM #ncm_cest_entrada
    GROUP BY PROCOD, NFENCMXML
)
SELECT 
    p.PROCOD,
    p.PROCLAFIS,
    t.NFENCMXML
FROM TBS010 p
INNER JOIN TempUnica t
    ON t.PROCOD = p.PROCOD
WHERE ISNULL(p.PROCLAFIS, '') <> ISNULL(t.NFENCMXML, '');

-- produtos com alguma nota fiscal de entrada

if object_id('tempdb.dbo.#produtos_com_entrada') is not null
    begin
    	drop table #produtos_com_entrada
    end

select p.PROCOD
       ,p.PROCLAFIS
       ,p.PROCEST
  into #produtos_com_entrada
  from TBS010 p with (nolock)
 where exists (select 1 from #ncm_cest_entrada nc where nc.PROCOD = p.PROCOD)

declare @codigo as varchar(15)

set @codigo = '0123340'

select *
  from #produtos_com_entrada
 where PROCOD = @codigo

select *
  from #ncm_cest_entrada
 where PROCOD = @codigo

-- produtos com NCM diferente da nota fiscal de entrada

/*
select *
       ,(select v.[data] from #ultima_venda v with (nolock) where v.codigoProduto = p.PROCOD collate database_default)
  from #produtos_com_entrada p
 where not exists (select 1 from #ncm_cest_entrada nc where nc.PROCOD = p.PROCOD and nc.NFENCMXML = p.PROCLAFIS)

select distinct 
       p.*
       , nc.*
       ,(select v.[data] from #ultima_venda v with (nolock) where v.codigoProduto = p.PROCOD collate database_default)
  from #produtos_com_entrada p
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where nc.NFENCMXML <> p.PROCLAFIS
 */

select distinct 
       p.PROCOD as codigo
       ,p.PROCLAFIS as ncm_cadastro
       ,nc.NFENCMXML as ncm_nota_fiscal
       ,nc.NFEDATEFE as ultima_compra
       ,(select v.[data] from #ultima_venda v with (nolock) where v.codigoProduto = p.PROCOD collate database_default) as ultima_venda
       ,(select pro.PRODES from TBS010 pro with (nolock) where pro.PROCOD = p.PROCOD)
  from #produtos_com_entrada p
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where nc.NFENCMXML <> p.PROCLAFIS

-- produtos com CEST diferente da nota fiscal de entrada

select distinct 
       p.PROCOD as codigo
       ,p.PROCEST as cest_cadastro
       ,nc.NFECESTXML as cest_nota_fiscal
       ,nc.NFEDATEFE as ultima_compra
       ,(select v.[data] from #ultima_venda v with (nolock) where v.codigoProduto = p.PROCOD collate database_default) as ultima_venda
       ,(select pro.PRODES from TBS010 pro with (nolock) where pro.PROCOD = p.PROCOD)
  from #produtos_com_entrada p
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where nc.NFECESTXML <> p.PROCEST
       and Len(rtrim(nc.NFECESTXML)) = 7
       and exists (select 1 from TBS154 c with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and c.CESTMVACOD = nc.NFECESTXML)

-- produtos sem CEST preenchidos

select distinct 
       p.PROCOD as codigo
       ,p.PROCEST as cest_cadastro
       ,nc.NFECESTXML as cest_nota_fiscal
       ,nc.NFEDATEFE as ultima_compra
       ,(select v.[data] from #ultima_venda v with (nolock) where v.codigoProduto = p.PROCOD collate database_default) as ultima_venda
       ,(select pro.PRODES from TBS010 pro with (nolock) where pro.PROCOD = p.PROCOD)
  from #produtos_com_entrada p
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where p.PROCEST = ''
       and Len(rtrim(nc.NFECESTXML)) = 7
       and exists (select 1 from TBS154 c with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and c.CESTMVACOD = nc.NFECESTXML)

-- CEST preenchidos no cadastro de produtos

select distinct 
       p.PROCOD as codigo
       ,nc.NFECESTXML as cest_nota_fiscal
  from #produtos_com_entrada p
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where Len(rtrim(p.PROCEST)) = 7
       and nc.NFECESTXML <> p.PROCEST
       and Len(rtrim(nc.NFECESTXML)) = 7
       and exists (select 1 from TBS154 c with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and c.CESTMVACOD = nc.NFECESTXML)

-- CEST vazios/inválidos no cadastro de produtos

select distinct 
       p.PROCOD as codigo
       ,p.PROCEST
       ,nc.NFECESTXML as cest_nota_fiscal
  from #produtos_com_entrada p
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where Len(rtrim(p.PROCEST)) < 7
       and Len(rtrim(nc.NFECESTXML)) = 7
       and exists (select 1 from TBS154 c with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and c.CESTMVACOD = nc.NFECESTXML)

select p.PROCOD
       ,p.PROCEST as cest_atual
       ,nc.NFECESTXML as cest_novo
  from TBS010 p with (nolock)
 inner join #ncm_cest_entrada nc
         on nc.PROCOD = p.PROCOD
 where Len(rtrim(p.PROCEST)) < 7
       and Len(rtrim(nc.NFECESTXML)) = 7
       and exists (select 1 from TBS154 c with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and c.CESTMVACOD = nc.NFECESTXML)

-- criar Log

exec sp_help 'TBS035'

select top 1 *
  from TBS035 with (nolock)

select p.PROLOGID
  from TBS010 p with (nolock)
 where p.PROCOD = '1640054'

select top 1 *
  from TBS035 l with (nolock)
 where l.LOGEMP = 0
       and l.LOGTAB = 'TBS010'
       and l.LOGID = 36523
 order by l.LOGSEQ desc

select *
  from TBS035 l with (nolock)
 where l.LOGEMP = 0
       and l.LOGTAB = 'TBS010'
       and l.LOGATT = 'PROCEST'
       and l.LOGUSU = 'DESENV'
       and l.LOGROT = 'SQL'
 
select convert(date, getdate())
select cast(getdate() as date)
select cast(getdate() as date)

SELECT 
    GETDATE() AS data_hora_completa,
    CAST(GETDATE() AS TIME) AS somente_hora,
    CONVERT(VARCHAR(8), GETDATE(), 108) AS hora_formatada

select getdate()

select top 1 *
  from TBS035 l with (nolock)
 where l.LOGDAT = '20260325'
       and l.LOGTAB = 'TBS010'
       and l.LOGATT = 'PROCEST'
 

-- insert

/*
begin tran
insert into TBS035 (LOGEMP, LOGTAB, LOGID, LOGSEQ, LOGOPE, LOGDAT, LOGHOR, LOGUSU, LOGROT, LOGROTDES, LOGTABDES, LOGATT, LOGATTDES, LOGVALANT, LOGVALATU)
select 0
       ,'TBS010'
       ,p.PROLOGID
       ,(select top 1 l.LOGSEQ from TBS035 l with (nolock) where l.LOGEMP = 0 and l.LOGTAB = 'TBS010' and l.LOGID = p.PROLOGID order by l.LOGSEQ desc)
       ,'A'
       ,cast(getdate() as date)
       ,convert(VARCHAR(8), getdate(), 108)
       ,'DESENV'
       ,'SQL'
       ,'UPDATE VIA SQL'
       ,'CADASTRO DE PRODUTOS'
       ,'PROCEST'
       ,'CEST'
       ,p.PROCEST
       ,nc.NFECESTXML AS cest_novo
  from TBS010 p with (nolock)
 inner join #produtos_com_entrada e
         on e.PROCOD = p.PROCOD
  Left join #ncm_cest_entrada nc
         on nc.PROCOD = e.PROCOD
 where Len(rtrim(p.PROCEST)) < 7
       and Len(rtrim(nc.NFECESTXML)) = 7
       and exists (select 1 from TBS154 c with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and c.CESTMVACOD = nc.NFECESTXML)
*/

begin tran
insert into TBS035 (
    LOGEMP, LOGTAB, LOGID, LOGSEQ, LOGOPE, LOGDAT, LOGHOR,
    LOGUSU, LOGROT, LOGROTDES, LOGTABDES, LOGATT, LOGATTDES,
    LOGVALANT, LOGVALATU
)
select 0
       ,'TBS010'
       ,p.PROLOGID
       ,isnull(lu.LOGSEQ, 0) + 1
       ,'A'
       ,cast(getdate() as date)
       ,convert(varchar(8), getdate(), 108)
       ,'DESENV'
       ,'SQL'
       ,'UPDATE VIA SQL'
       ,'CADASTRO DE PRODUTOS'
       ,'PROCEST'
       ,'CEST'
       ,p.PROCEST
       ,nc.NFECESTXML
  from TBS010 p with (nolock)
 inner join #produtos_com_entrada e
         on e.PROCOD = p.PROCOD
  Left join #ncm_cest_entrada nc
         on nc.PROCOD = e.PROCOD

cross apply (
   select top 1 l.LOGSEQ
     from TBS035 l with (nolock)
    where l.LOGEMP = 0
          and l.LOGTAB = 'TBS010'
          and l.LOGID = p.PROLOGID
    order by l.LOGSEQ desc
) lu

 where Len(rtrim(p.PROCEST)) < 7
       and Len(rtrim(nc.NFECESTXML)) = 7
       and exists (select 1 from TBS154 c with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and c.CESTMVACOD = nc.NFECESTXML);

rollback tran
commit tran

-- update

begin tran
update p
   set p.PROCEST = nc.NFECESTXML
  from TBS010 p with (nolock)
 inner join #produtos_com_entrada e
         on e.PROCOD = p.PROCOD
  Left join #ncm_cest_entrada nc
         on nc.PROCOD = e.PROCOD
 where Len(rtrim(p.PROCEST)) < 7
       and Len(rtrim(nc.NFECESTXML)) = 7
       and exists (select 1 from TBS154 c with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and c.CESTMVACOD = nc.NFECESTXML)

rollback tran
commit tran

-- chatgpt

SELECT t.PROCOD,
       t.PROCEST AS cest_atual,
       nc.NFECESTXML AS cest_novo
FROM TBS010 t
INNER JOIN #produtos_com_entrada p
        ON p.PROCOD = t.PROCOD
LEFT JOIN #ncm_cest_entrada nc
       ON nc.PROCOD = p.PROCOD
WHERE nc.NFECESTXML <> t.PROCEST
  AND LEN(RTRIM(nc.NFECESTXML)) = 7
  AND EXISTS (
        SELECT 1
        FROM TBS154 c WITH (NOLOCK)
        WHERE c.CESTMVACOD = nc.NFECESTXML
  );

-- update

begin tran
UPDATE t
   SET t.PROCEST = nc.NFECESTXML
FROM TBS010 t
INNER JOIN #produtos_com_entrada p
        ON p.PROCOD = t.PROCOD
LEFT JOIN #ncm_cest_entrada nc
       ON nc.PROCOD = p.PROCOD
WHERE nc.NFECESTXML <> t.PROCEST
  AND LEN(RTRIM(nc.NFECESTXML)) = 7
  AND EXISTS (
        SELECT 1
        FROM TBS154 c WITH (NOLOCK)
        WHERE c.CESTMVACOD = nc.NFECESTXML
          AND LEN(RTRIM(nc.NFECESTXML)) = 7
  );

rollback tran
commit tran

select l.LOGDAT
       ,l.LOGOPE
       ,l.LOGUSU
       ,l.LOGVALANT
       ,l.LOGVALATU
       ,nc.NFECESTXML
       ,nc.NFEDATEFE
       ,p.PROCOD
       ,nc.PROCOD
       ,p.PROCLAFIS
       ,nc.NFENCMXML
  from TBS035 l with (nolock)
 inner join TBS010 p with (nolock)
         on p.PROLOGID = l.LOGID
 inner join #produtos_com_entrada e
         on e.PROCOD = p.PROCOD
  Left join #ncm_cest_entrada nc
         on nc.PROCOD = e.PROCOD
 where LOGTAB = 'TBS010'
       and LOGATT = 'PROCEST'
       and nc.NFECESTXML <> l.LOGVALATU
       and LEN(RTRIM(nc.NFECESTXML)) = 7
       and exists (
                    select 1
                      from TBS154 c with (nolock)
                     where c.CESTMVACOD = nc.NFECESTXML
                  )
       and l.LOGDAT < nc.NFEDATEFE

-- última venda por produto

if object_id('tempdb.dbo.#ultima_venda') is not null
    begin
    	drop table #ultima_venda
    end

CREATE TABLE #ultima_venda (
    -- defina apenas os campos que precisa
    codigoProduto VARCHAR(15),
    [data] DATE,
    hora char(8),
    quantidade DECIMAL(12,4),
    rn smallint
);

INSERT INTO #ultima_venda
EXEC dbo.sp_UltimaVendaPorProduto 
    @DataInicial = '2020-01-01',
    @DataFinal   = '2026-03-31',
    @CodigoProduto = null;

select *
  from #ultima_venda

select Left(p.PROCLAFIS,2)
       ,count(*)
  from TBS010 p with (nolock)
 where p.PROCLAFIS <> ''
 group by Left(p.PROCLAFIS,2)
 
select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
  where Left(p.PROCLAFIS,2) = '07'

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PROCLAFIS <> ''
       and Len(Ltrim(rtrim(p.PROCLAFIS))) < 8

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PRODES Like 'SQUEEZE 2221%'

begin tran
update TBS010
   set PROCLAFIS = '39249000'
 where PROCOD = '1030809'

rollback tran
commit tran

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
  from TBS010 p with (nolock)
 where p.PRODES Like 'OFURO INFANTIL 18L%'

begin tran
update TBS010
   set PROCLAFIS = '39221000'
 where PROCOD = '2881585'

rollback tran
commit tran

select top 5 *
  from TBS123 c with (nolock)

select top 5 *
  from TBS154 c with (nolock)

exec sp_help 'TBS123'

-- produtos com CEST inválidos

select p.*
  from #produtos_com_entrada p
 where Len(rtrim(p.PROCEST)) = 7
       and not exists (select 1 from TBS154 c with (nolock) where Len(rtrim(p.PROCEST)) = 7 and c.CESTMVACOD = p.PROCEST)

select p.PROCOD
       ,p.PRODES
       ,p.PROCEST
       ,p.PROCLAFIS
       ,p.PROSTBB
  from TBS010 p with (nolock)
 where Len(rtrim(p.PROCEST)) = 7
       and not exists (select 1 from TBS154 c with (nolock) where Len(rtrim(p.PROCEST)) = 7 and c.CESTMVACOD = p.PROCEST)

select nc.*
  from #ncm_cest_entrada nc
 where nc.NFECESTXML = '0030096'

select nc.*
  from #ncm_cest_entrada nc
 where nc.NFENCMXML = '42021900'

select p.PROCOD
       ,p.PRODES
       ,p.PROCEST
       ,p.PROCLAFIS
       ,p.PROSTBB
  from TBS010 p with (nolock)
 where Len(rtrim(p.PROCEST)) between 1 and 6

-- NCM inválidos

select p.PROCOD
       ,p.PRODES
       ,p.PROCEST
       ,p.PROCLAFIS
       ,p.PROSTBB
  from TBS010 p with (nolock)
 where Len(rtrim(p.PROCLAFIS)) between 1 and 7

-- tributação GZ

select *
  from MSL004 tgz with (nolock)

select p.PROCOD
       ,p.PRODES
       ,p.PROCEST
       ,p.PROCLAFIS
       ,p.PROSTBB
       ,p.TGZCOD
  from TBS010 p with (nolock)
 where PROSTBB = '00'
       and TGZCOD <> 5

-- criar Log

select top 10 *
  from TBS035 l with (nolock)
 where l.LOGEMP = 0
       and l.LOGTAB = 'TBS010'
       and l.LOGATT = 'TGZCOD'

-- insert

begin tran
insert into TBS035 (
    LOGEMP, LOGTAB, LOGID, LOGSEQ, LOGOPE, LOGDAT, LOGHOR,
    LOGUSU, LOGROT, LOGROTDES, LOGTABDES, LOGATT, LOGATTDES,
    LOGVALANT, LOGVALATU
)
select 0
       ,'TBS010'
       ,p.PROLOGID
       ,isnull(lu.LOGSEQ, 0) + 1
       ,'A'
       ,cast(getdate() as date)
       ,convert(varchar(8), getdate(), 108)
       ,'DESENV'
       ,'SQL'
       ,'UPDATE VIA SQL'
       ,'CADASTRO DE PRODUTOS'
       ,'TGZCOD'
       ,'TRIBUTACAO GZ'
       ,p.TGZCOD
       ,5
  from TBS010 p with (nolock)

cross apply (
   select top 1 l.LOGSEQ
     from TBS035 l with (nolock)
    where l.LOGEMP = 0
          and l.LOGTAB = 'TBS010'
          and l.LOGID = p.PROLOGID
    order by l.LOGSEQ desc
) lu

 where PROSTBB = '00'
       and TGZCOD <> 5

rollback tran
commit tran

-- update

begin tran
update p
   set p.TGZCOD = 1
  from TBS010 p with (nolock)
 where PROSTBB = '60'
       and TGZCOD <> 1

rollback tran
commit tran

-- NCM inexistentes

if object_id('tempdb.dbo.#ncm_inexistentes') is not null
    begin
    	drop table #ncm_inexistentes
    end

select p.PROCOD
       ,p.PROCLAFIS
       ,p.PROSTATUS
       ,p.PRODES
       ,nc.NFEDATEFE as ultima_compra
       ,(select v.[data] from #ultima_venda v with (nolock) where v.codigoProduto = p.PROCOD collate database_default) as ultima_venda
  into #ncm_inexistentes
  from TBS010 p with (nolock)
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where Len(rtrim(p.PROCLAFIS)) = 8
       and not exists (select 1 from TBS092 ncm with (nolock) where ncm.NCMCOD = p.PROCLAFIS)

select *
  from #ncm_inexistentes

-- produtos com NCM diferente da nota fiscal de entrada

select distinct 
       p.PROCOD as codigo
       ,p.PROCLAFIS as ncm_cadastro
       ,nc.NFENCMXML as ncm_nota_fiscal
       ,nc.NFEDATEFE as ultima_compra
       ,(select v.[data] from #ultima_venda v with (nolock) where v.codigoProduto = p.PROCOD collate database_default) as ultima_venda
       ,(select pro.PRODES from TBS010 pro with (nolock) where pro.PROCOD = p.PROCOD)
  from TBS010 p with (nolock)
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where nc.NFENCMXML <> p.PROCLAFIS
       and Len(rtrim(nc.NFENCMXML)) = 8
       and exists (select 1 from TBS092 ncm with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and ncm.NCMCOD = nc.NFENCMXML)
       and exists (select 1 from #ncm_inexistentes t where t.PROCOD = p.PROCOD)

-- criar Log

select top 10 *
  from TBS035 l with (nolock)
 where l.LOGEMP = 0
       and l.LOGTAB = 'TBS010'
       and l.LOGATT = 'PROCLAFIS'

-- insert

begin tran
insert into TBS035 (
    LOGEMP, LOGTAB, LOGID, LOGSEQ, LOGOPE, LOGDAT, LOGHOR,
    LOGUSU, LOGROT, LOGROTDES, LOGTABDES, LOGATT, LOGATTDES,
    LOGVALANT, LOGVALATU
)
select 0
       ,'TBS010'
       ,p.PROLOGID
       ,isnull(lu.LOGSEQ, 0) + 1
       ,'A'
       ,cast(getdate() as date)
       ,convert(varchar(8), getdate(), 108)
       ,'DESENV'
       ,'SQL'
       ,'UPDATE VIA SQL'
       ,'CADASTRO DE PRODUTOS'
       ,'PROCLAFIS'
       ,'NCM'
       ,p.PROCLAFIS
       ,nc.NFENCMXML
  from TBS010 p with (nolock)
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD

cross apply (
   select top 1 l.LOGSEQ
     from TBS035 l with (nolock)
    where l.LOGEMP = 0
          and l.LOGTAB = 'TBS010'
          and l.LOGID = p.PROLOGID
    order by l.LOGSEQ desc
) lu

 where nc.NFENCMXML <> p.PROCLAFIS
       and Len(rtrim(nc.NFENCMXML)) = 8
       and exists (select 1 from TBS092 ncm with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and ncm.NCMCOD = nc.NFENCMXML)
       and exists (select 1 from #ncm_inexistentes t where t.PROCOD = p.PROCOD)

rollback tran
commit tran

-- update

begin tran
update p
   set p.PROCLAFIS = nc.NFENCMXML
  from TBS010 p with (nolock)
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD
 where nc.NFENCMXML <> p.PROCLAFIS
       and Len(rtrim(nc.NFENCMXML)) = 8
       and exists (select 1 from TBS092 ncm with (nolock) where Len(rtrim(nc.NFECESTXML)) = 7 and ncm.NCMCOD = nc.NFENCMXML)
       and exists (select 1 from #ncm_inexistentes t where t.PROCOD = p.PROCOD)

rollback tran
commit tran

-- analises da ST

select p.PROCOD
       ,p.PROCLAFIS
       ,p.PROCEST
       ,p.PROSTBB
       ,p.PRODES
       ,p.PROSTATUS
  from TBS154 c with (nolock)
 inner join TBS010 p with (nolock)
         on p.PROCEST = c.CESTMVACOD
 where c.CESTOPEINT = 'S'
       and p.PROSTBB not in('10','30','60','70')

-- lista de marcas para identificação se compra direta do fabricante

select m.MARCOD
       ,m.MARNOM
  from TBS014 m with (nolock)

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROSTATUS
       ,(select v.[data] from #ultima_venda v with (nolock) where v.codigoProduto = p.PROCOD collate database_default) as ultima_venda
       ,nc.NFEDATEFE as ultima_compra
  from TBS010 p with (nolock)
  Left join #ncm_cest_entrada nc 
         on nc.PROCOD = p.PROCOD  
 where p.PROSTBB in('20','40','41')

-- temporária NCM CEST copiados da econet

create table #ncm_cest_econet (
    ncm varchar(8),
    cest varchar(7)
);

delete #ncm_cest_econet

insert into #ncm_cest_econet (ncm, cest)
values 
('391000','1000400'),
('3916','1000500'),
('39161000','1900300'),
('39162000','1900200'),
('391690','1900300'),
('3917','0100200'),
('3917','1000600'),
('3918','1000700'),
('39181000','0100300'),
('3919','1000800'),
('3919','1000900'),
('391910','0109000'),
('391990','0109000'),
('3920','1000900'),
('39202019','1901400'),
('3921','1000900'),
('3921','1001000'),
('3921','1001100'),
('3921','1001200'),
('3922','1001300'),
('39232','1101200'),
('39233000','0100400'),
('3924','1001400'),
('39241000','1100900'),
('39249000','1100900'),
('39251000','1001500'),
('39252000','1001800'),
('392590','1001600'),
('39261000','1900400'),
('39263000','0100500'),
('392690','1002000'),
('39269090','1900600'),
('48022000','1901100'),
('48022090','1900700'),
('4802549','1900800'),
('48025499','1900900'),
('480256','1903100'),
('4802569','1901000'),
('4802579','1901000'),
('48025799','1900900'),
('4802589','1901000'),
('48062000','1901500'),
('48081000','1901600'),
('4809','1901800'),
('48101390','1901200'),
('48102290','1901700'),
('48119090','1900700'),
('4814','1002100'),
('4816','1901800'),
('48162000','1900900'),
('48169010','1901300'),
('4817','1901900'),
('48201000','1902000'),
('48202000','1902100'),
('48203000','1902200'),
('48204000','1902300'),
('48205000','1902400'),
('48209000','1902500'),
('48234000','0108900'),
('4823909','0100700'),
('9608','1903000'),
('96081000','1902700'),
('96082000','1902800'),
('96083000','1902900'),
('96138000','0108600'),
('42021','1900500'),
('42021','1900501'),
('42029','1900500'),
('42029','1900501'),
('49090000','1902600'),
('84073','0102800'),
('840820','0102900'),
('84099','0103000'),
('84122','0103100'),
('84123110','0109100'),
('84131900','0109200'),
('841330','0103200'),
('84135090','0109200'),
('84136019','0109300'),
('84137010','0109300'),
('84138100','0109200'),
('84139190','0103500'),
('84141000','0103300'),
('84145','2108800'),
('84145910','0109400'),
('84145910','2108801'),
('84145990','0109400'),
('84146000','2109000'),
('8414801','0103400'),
('8414802','0103400'),
('84149010','0103500'),
('84149020','2109100'),
('8414903','0103500'),
('84149039','0103500'),
('841510','2109200'),
('84151011','2109300'),
('84151019','2109400'),
('84151090','2109500'),
('841520','0103600'),
('84158','2109200'),
('84159010','2109600'),
('84159020','2109700'),
('84159090','2110600'),
('84181000','2100200'),
('84182100','2100300'),
('84182900','2100400'),
('84183000','2100500'),
('84184000','2100600'),
('841850','2100700'),
('84186931','2101300'),
('8418699','2100800'),
('84186999','2100900'),
('84189900','0111300'),
('84189900','2101000'),
('841950','0111400'),
('842112','2101100'),
('84211990','2101200'),
('84212100','2109800'),
('84212100','2109801'),
('84212300','0103700'),
('84212990','0103800'),
('84213100','0104100'),
('84213200','0104200'),
('84213990','0109500'),
('84219','0103900'),
('84219','2101400'),
('84221100','2101500'),
('84229010','2101500'),
('84231000','2110800'),
('84241000','0104000'),
('84243010','2109900'),
('84243090','2109900'),
('84249090','0111500'),
('84249090','2109900'),
('84254200','0104300'),
('84254910','0111600'),
('84311010','0104400'),
('84314100','0111700'),
('8431492','0104500'),
('84339090','0104501'),
('844331','2101600'),
('844332','2101700'),
('84439','2101800'),
('84501100','2101900'),
('84501200','2102000'),
('84501900','2102100'),
('845020','2102200'),
('845090','2102300'),
('84512100','2102400'),
('84512990','2102500'),
('845190','2102600'),
('84521000','2102700'),
('8467','0801900'),
('84672100','2110000'),
('847130','2102800'),
('84714','2102900'),
('84715010','2103000'),
('8471605','2103100'),
('84716090','2103200'),
('847170','2103300'),
('847190','2103400'),
('847330','2103500'),
('84796000','2110500'),
('8481','1007900'),
('84811000','0104600'),
('84812','0104700'),
('84818092','0104800'),
('8482','0104900'),
('8483','0105000'),
('8484','0105100'),
('95045000','2107900'),
('85011019','0109600'),
('85013110','0109700'),
('85016100','0111800'),
('8504','1200100'),
('85043','2103600'),
('85044010','2103700'),
('85044040','2103800'),
('85045000','0109800'),
('850520','0105200'),
('850710','0105300'),
('85071010','0105301'),
('850720','0109900'),
('850730','0109900'),
('8508','2104000'),
('8509','2104100'),
('85098010','2104200'),
('8510','2108700'),
('8511','0105400'),
('851220','0105500'),
('85123000','0110000'),
('851240','0105500'),
('85129000','0105500'),
('8516','1200200'),
('85161000','2104300'),
('85162','2110100'),
('85163100','2110200'),
('85163200','2110300'),
('85164000','2104400'),
('85165000','2104500'),
('85166000','2104600'),
('85166000','2104700'),
('85167100','2104800'),
('85167200','2104900'),
('851679','2105000'),
('85169000','2105100'),
('8517','2111000'),
('8517','2111100'),
('85171100','2105200'),
('85171300','2105300'),
('85171300','2105301'),
('851714','2105400'),
('85171410','0105600'),
('8517143','2105300'),
('85171431','2105301'),
('85171830','2105500'),
('85171890','2105501'),
('8517621','2108000'),
('85176229','2108100'),
('85176239','2108200'),
('8517624','2108300'),
('85176254','2105601'),
('85176255','2105601'),
('85176259','2105600'),
('85176262','2108400'),
('85176277','2112700'),
('8517629','2108500'),
('85177110','2108600'),
('8518','0105700'),
('8518','2105700'),
('85185000','0105800'),
('8519','2105800'),
('851981','0105900'),
('85198190','2105900'),
('85219090','0106201'),
('85219090','2106100'),
('8522','2105800'),
('85235110','2106200'),
('852352','2106300'),
('852352','2106400'),
('8525501','0106000'),
('85256010','0106000'),
('8525891','2110700'),
('8525892','2106500'),
('8527','2110400'),
('85271','2105800'),
('85272100','0106100'),
('85272900','0106200'),
('85279','2106600'),
('85284990','2106700'),
('85285200','2106800'),
('85285900','2106700'),
('85286200','2106701'),
('852869','2106700'),
('85287','2106900'),
('85287','2107000'),
('85287','2107100'),
('85287','2107200'),
('85287','2107300'),
('8529','2111200'),
('852910','0106300'),
('8531','2111300'),
('853110','2111400'),
('85311090','0111900'),
('85318000','2111500'),
('853400','0106400'),
('853400','2111600'),
('8535','1200300'),
('853530','0106500'),
('8536','1200400'),
('85361000','0106600'),
('85362000','0106700'),
('85364','0106800'),
('853650','0106500'),
('8538','0106900'),
('8538','1200500'),
('853910','0107000'),
('85392','0107100'),
('8540','2110900'),
('85414111','2111700'),
('85414121','2111700'),
('85414122','2111700'),
('85437092','2111800'),
('8544','1200700'),
('85442000','0107200'),
('85443000','0107300'),
('8546','1200800'),
('8547','1200900'),
('3204','2400300'),
('32041700','2400200'),
('32050000','2400300'),
('3206','2400200'),
('3206','2400300'),
('32064100','1100100'),
('3208','2400100'),
('3209','2400100'),
('321000','2400100'),
('3212','2400300'),
('32131000','1900100'),
('32149000','1000300'),
('8201','0800400'),
('8202','0800700'),
('8203','0800800'),
('8204','0800900'),
('8205','0801000'),
('82060000','0801100'),
('8207','0801300'),
('8208','0801400'),
('820900','0801600'),
('8211','0801700'),
('8213','0801800'),
('821490','2108700'),
('34012090','1100200'),
('34012090','1100300'),
('3402','1100700'),
('34025000','1100100'),
('34025000','1100400'),
('34025000','1100500'),
('34025000','1100600'),
('7307','1004600'),
('73083000','1004700'),
('73084000','1004800'),
('73084000','1004900'),
('730890','1004800'),
('73089010','1004100'),
('73089010','1004101'),
('7310','1005100'),
('73110000','0101800'),
('7312','1004400'),
('73130000','1005200'),
('7314','1005300'),
('73151100','0111100'),
('73151100','1005400'),
('73151290','1005500'),
('73158200','1005600'),
('731700','1005700'),
('7320','0102000'),
('73211100','2100100'),
('73218100','2100100'),
('73219000','2100100'),
('7323','1005900'),
('7323','1005901'),
('73231000','1101100'),
('7324','1006000'),
('7325','0102100'),
('7325','1006100'),
('7326','1006200'),
('70072900','0110900'),
('70091000','0101600'),
('70140000','0101700'),
('8301','1007500'),
('830120','0102400'),
('830160','0102400'),
('830170','0102500'),
('83021000','0102600'),
('83021000','1007600'),
('83023000','0102600'),
('83024100','1007400'),
('8307','1007700'),
('831000','0102700'),
('8311','1007800'),
('7605','1200700'),
('76071190','1903300'),
('76071990','1006800'),
('7608','1006900'),
('76090000','1007000'),
('7610','1007100'),
('7614','1200700'),
('76152000','1007200'),
('44170010','0800200'),
('44170090','0800200'),
('40081100','0110300'),
('4009','0108700'),
('40103','0100600'),
('4011','1600200'),
('4011','1600400'),
('40111000','1600100'),
('40114000','1600300'),
('40115000','1600500'),
('401290','1600700'),
('4013','1600800'),
('40132000','1600900'),
('40161010','0100800'),
('40169300','0100700'),
('40169990','0100900'),
('40169990','0800100'),
('38089419','1100100'),
('38089419','1100200'),
('38089419','1100300'),
('38099190','1100800'),
('38151210','0100100'),
('38151290','0100100'),
('3816001','1000200'),
('38245000','1000200'),
('90064000','2107500'),
('900659','2107400'),
('90141000','0112000'),
('9015','0802000'),
('90172000','0802100'),
('901730','0802100'),
('901780','0802100'),
('90179090','0802100'),
('90189050','2107600'),
('90191000','2107700'),
('90251190','0802200'),
('902519','0802300'),
('90251990','0112100'),
('90259010','0112200'),
('90259010','0802200'),
('90259090','0802300'),
('902610','0107800'),
('902620','0107900'),
('902690','0112300'),
('90271000','0110200'),
('9029','0108000'),
('90303','2111900'),
('90303321','0108100'),
('903089','2112000'),
('90318040','0108200'),
('90321010','0112400'),
('90321090','0112500'),
('90322000','0112600'),
('90328911','2107800'),
('9032892','0108300'),
('9032898','0110100'),
('9032899','0110100'),
('63061','0101200'),
('56012219','0110400'),
('94012000','0108500'),
('94019900','0108500'),
('9405','2112200'),
('94051','2112300'),
('94052','2112400'),
('94054','2112500'),
('94059','2112300'),
('94059','2112400'),
('94059','2112500'),
('52105990','1903200'),
('1901','2300200'),
('19011010','1701400'),
('19011020','1701300'),
('19011030','1701500'),
('19011090','1701500'),
('1902','1704800'),
('19022000','1704802'),
('19023000','1704700'),
('19023000','1704701'),
('19024000','1704801'),
('19051000','1706300'),
('190520','1705000'),
('19052090','1705100'),
('19053100','1705300'),
('19053100','1705400'),
('19053200','1705700'),
('19053200','1705800'),
('19054000','1705900'),
('19059010','1706000'),
('19059020','1705600'),
('19059020','1705601'),
('19059020','1705602'),
('19059090','1706200'),
('19059090','1706201'),
('59039000','0101000'),
('59090000','0101100'),
('59100000','0100600'),
('59119000','0110700'),
('69039099','0110800'),
('6905','1002800'),
('69060000','1002900'),
('6907','1003000'),
('6910','1003100'),
('69120000','1003200'),
('2201','0300600'),
('22011000','0300300'),
('22011000','0300301'),
('22011000','0300500'),
('22011000','0300501'),
('22011000','0300502'),
('22011000','0300503'),
('22011000','0300504'),
('22011000','0300505'),
('22011000','0302400'),
('22011000','0302500'),
('22019000','0300300'),
('22019000','0300301'),
('22019000','0300500'),
('22019000','0300501'),
('22019000','0300502'),
('22019000','0300503'),
('22019000','0300504'),
('22019000','0300505'),
('2202','0301101'),
('22021000','0300700'),
('22021000','0301000'),
('22021000','0301001'),
('22021000','0301002'),
('22021000','0301100'),
('22029100','0302200'),
('22029100','0302201'),
('22029100','0302202'),
('22029100','0302203'),
('22029100','0302204'),
('22029100','0302205'),
('22029100','0302206'),
('22029900','0300800'),
('22029900','0301000'),
('22029900','0301001'),
('22029900','0301002'),
('22029900','0301100'),
('22029900','0301300'),
('22029900','0301301'),
('22029900','0301302'),
('22029900','0301500'),
('22030000','0302100'),
('22030000','0302101'),
('22030000','0302102'),
('22030000','0302103'),
('22030000','0302104'),
('22030000','0302105'),
('22030000','0302106'),
('22030000','0302300'),
('2207','1101000'),
('22089000','1101000'),
('21031010','1703600'),
('21032010','1703400'),
('21032010','1704100'),
('21033010','1703700'),
('21033021','1703800'),
('21039011','1703900'),
('21039021','1703500'),
('21039091','1703500'),
('210500','2300100'),
('2106','2300200'),
('210690','0301300'),
('210690','0301301'),
('210690','0301302'),
('210690','0301500'),
('21069010','0301200'),
('21069010','0301201'),
('17049010','1700100'),
('17049010','1700101'),
('17049090','1700800'),
('6804','0800300'),
('68053010','1100900'),
('68053090','1100900'),
('68101900','1002200'),
('6811','1002400'),
('68129910','0108800'),
('6813','0101400'),
('91040000','0108400'),
('910700','2112100'),
('1806','2300200'),
('18063110','1700200'),
('18063110','1700201'),
('18063210','1700300'),
('18069000','1700400'),
('18069000','1700401'),
('18069000','1700600'),
('18069000','1700602'),
('18069000','1700700'),
('18069000','1700900'),
('2821','2400200'),
('28289011','1100100'),
('28289019','1100100'),
('27101249','0601900'),
('65061000','0101300'),
('2002','1704000'),
('7213','1004300'),
('72142000','1004000'),
('72142000','1004200'),
('72171090','1004400'),
('72172010','1004500'),
('72172090','1004501'),
('74111010','1006400'),
('7412','1006500'),
('74130000','1200600'),
('7415','1006600'),
('74182000','1006700'),
('87021000','2500100'),
('87022000','2502200'),
('87023000','2502300'),
('87024090','2500200'),
('87029000','2502400'),
('87032100','2500300'),
('87032210','2500400'),
('87032290','2500500'),
('87032310','2500600'),
('87032390','2500700'),
('87032410','2500800'),
('87032490','2500900'),
('87033210','2501000'),
('87033290','2501100'),
('87033310','2501200'),
('87033390','2501300'),
('87034000','2502500'),
('87035000','2502600'),
('87036000','2502700'),
('87037000','2502800'),
('87038000','2502900'),
('87042110','2501400'),
('87042120','2501500'),
('87042130','2501600'),
('87042190','2501700'),
('87043110','2501800'),
('87043120','2501900'),
('87043130','2502000'),
('87043190','2502100'),
('87044100','2503000'),
('87045100','2503100'),
('87046000','2503200'),
('8707','0107400'),
('8708','0107500'),
('87082999','0109000'),
('8711','2600100'),
('8711','2600101'),
('87141','0107600'),
('87169090','0107700'),
('57032900','0110500'),
('57033900','0110600'),
('57050000','0100900'),
('2522','1000100'),
('2523','0500100'),
('15171000','1702600'),
('15171000','1702700'),
('151790','1702702'),
('45049000','0108800'),
('040110','1701902'),
('04011010','1701600'),
('040120','1701902'),
('04012010','1701600'),
('0401402','1701900'),
('040150','1701902'),
('04021','1701200'),
('040210','1701902'),
('04022','1701200'),
('04022130','1701900'),
('04022920','1701902'),
('04022930','1701900'),
('04029','1701200'),
('04029','1701900'),
('04029','1702000'),
('0403','1702100'),
('0404','2300200'),
('04051000','1702500'),
('0406','1702300'),
('780600','0102200'),
('80070090','0102300'),
('37031010','1901100'),
('37031029','1901100'),
('37032000','1901100'),
('37039010','1901100'),
('37040000','1901100'),
('2402','0400100'),
('24031','0400200')

select *
  from #ncm_cest_econet

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST
  from TBS010 p with (nolock)
 where Len(rtrim(p.PROCLAFIS)) = 8
       and p.PROSTBB = '60'
       and not exists (select 1 from #ncm_cest_econet where Left(ncm,4) = Left(p.PROCLAFIS,4) collate database_default)

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST
       ,e.ncm
       ,e.cest
  from TBS010 p with (nolock)
 inner join #ncm_cest_econet e
         on Left(e.ncm,4) = Left(p.PROCLAFIS,4) collate database_default
 where Len(rtrim(p.PROCLAFIS)) = 8

select p.PROCOD
       ,p.PRODES
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST
       ,e.ncm
       ,e.cest
  from TBS010 p with (nolock)
 inner join #ncm_cest_econet e
         on Left(e.ncm,4) in(p.PROCLAFIS collate database_default)
 where Len(rtrim(p.PROCLAFIS)) = 8

-- atuallização das empresas

-- NCM

update destino
   set destino.PROCLAFIS = origem.PROCLAFIS
  from bb.SIBD2.dbo.TBS010 destino
  join SIBD.dbo.TBS010 origem
    on origem.PROEMPCOD = destino.PROEMPCOD
       and origem.PROCOD = destino.PROCOD
 where destino.PROCLAFIS <> origem.PROCLAFIS

-- backup

-- best bag [x], misaspel [x], papelyna [x], tanby cd [x], tanby matriz [x], tanby taubaté [x], winpack [x]

;select p.PROCOD
       ,p.PROSTBB
       ,p.PROCLAFIS
       ,p.PROCEST
       ,p.TGZCOD
  into TBS010_020426_TM
  from TBS010 p with (nolock)

-- best bag
select * -- 98.170
  from TBS010_020426_BB with (nolock)

-- misaspel
select * -- 98.151
  from TBS010_020426_MI with (nolock)

-- papelyna
select * -- 98.160
  from TBS010_020426_PP with (nolock)

-- tanby cd
select * -- 98.214
  from TBS010_020426_TC with (nolock)

-- tanby matriz
select * -- 98.186
  from TBS010_020426_TM with (nolock)

-- tanby taubaté
select * -- 98.214
  from TBS010_020426_TT with (nolock)

-- tanby taubaté
select * -- 98.163
  from TBS010_020426_WP with (nolock)