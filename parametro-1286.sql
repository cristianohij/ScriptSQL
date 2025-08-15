alter table [TBS025] alter column [PARVAL] char(200)

select * from TBS025 (nolock) where PARCHV=1286

update TBS025 set PARVAL='NENHUM' where PARCHV=1286

insert into TBS025 select 1286,'USUARIOS COM ACESSO A EMISSAO DE NF-E UTILIZANDO REGRAS DO ICMS','C','NENHUM',getdate()