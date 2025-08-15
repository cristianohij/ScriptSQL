select *
  from orca_esc with (nolock)
 where id=34
-- order by id desc

select *
  from orca_esc_det with (nolock)
 where id_orca=1
-- order by id_orca desc

drop table orca_esc
drop table orca_esc_det

alter table orca_esc alter column data_cadastro datetime

-- controlar acesso por empresa

alter table orca_esc add column cab_empresa varchar(10)
alter table orca_esc_det add column det_empresa varchar(10)

ALTER TABLE orca_esc ADD cab_empresa VARCHAR(10) NOT NULL DEFAULT '';
ALTER TABLE orca_esc_det ADD det_empresa VARCHAR(10) NULL DEFAULT '';

update orca_esc
   set cab_empresa=''

update orca_esc_det
   set det_empresa=''

orca_esc
id int chave primária
num_orca_origem int default 0
data_inclusao datetime default '17530101'
data_alteracao datetime default '17530101'
data_tanby date default '17530101'
data_misaspel date default '17530101'
data_papelyna date default '17530101'
total_tanby decimal(9,2) default 0
total_misaspel decimal(9,2) default 0
total_papelyna decimal(9,2) default 0

orca_esc_det
id_orca int chave primária
item in chave primária
descricao varchar(60) default ''
unidade char(2) default ''
unidade_desc varchar(50) default ''
quantidade decimal(9,3) default 0
preco_tanby decimal(9,2) default 0
preco_misaspel decimal(9,2) default 0
preco_papelyna decimal(9,2) default 0
total_item_tanby decimal(9,2) default 0
total_item_misaspel decimal(9,2) default 0
total_item_papelyna decimal(9,2) default 0

 SELECT ORCDES, ORCQTD, ORCPRE, ORCUNI
        ,(SELECT UNIDES FROM TBS011 with (nolock) WHERE UNICOD=ORCUNI) AS UNIDESC
        FROM TBS0431 with (nolock)
        WHERE ORCEMPCOD = 0 AND ORCNUM = 911360

update orca_esc
   set data_misaspel='17530101'
       ,data_papelyna='17530101'

-- tanby

select item
       ,descricao
       ,unidade
       ,quantidade
       ,preco_tanby
       ,total_item_tanby
  from orca_esc_det with (nolock)
 where id_orca = 3

-- misaspel

select item
       ,rtrim(descricao) + ' (' + unidade + ')' as descricao
       ,quantidade
       ,preco_misaspel
       ,total_item_misaspel
  from orca_esc_det with (nolock)
 where id_orca = 3

-- papelyna

select item
       ,descricao
       ,unidade
       ,quantidade
       ,preco_misaspel
       ,total_item_misaspel
  from orca_esc_det with (nolock)
 where id_orca = 3

begin tran
update orca_esc
   set data_winpack='17530101'
 where data_winpack is null

rollback tran
commit tran

begin tran
update orca_esc
   set data_bestbag='17530101'
 where data_bestbag is null

rollback tran
commit tran

begin tran
update orca_esc
   set total_winpack=0
 where total_winpack is null

rollback tran
commit tran

begin tran
update orca_esc
   set total_bestbag=0
 where total_bestbag is null

rollback tran
commit tran

begin tran
update orca_esc_det
   set preco_bestbag=0
       ,total_item_bestbag=0
 where preco_bestbag is null

rollback tran
commit tran

begin tran
update orca_esc_det
   set preco_winpack=0
       ,total_item_winpack=0
 where preco_winpack is null

rollback tran
commit tran

SELECT descricao, unidade, unidade_desc, quantidade, preco_tanby, preco_misaspel, preco_papelyna, total_item_tanby, total_item_misaspel, total_item_papelyna, preco_bestbag, total_item_bestbag, preco_winpack, total_item_winpack
FROM orca_esc_det with (nolock)
        WHERE id_orca = ?

begin tran
update orca_esc
   set cab_empresa='wi'
 where id=50

rollback tran
commit tran


select *
  from orca_esc with (nolock)
 where id=52

select *
  from orca_esc_det with (nolock)
 where id_orca=52

exec sp_help 'orca_esc'

