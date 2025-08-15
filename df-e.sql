select * from TBS025 (nolock)

insert into TBS025 select 1287,'NOME DO CERTIFICADO DIGITAL','C','CN=BEST BAG EMBALAGENS EIRELI:05118717000156, OU=AR ACSP, OU=RFB e-CNPJ A1, OU=Secretaria da Receita Federal do Brasil - RFB, O=ICP-Brasil, L=SAO PAULO, S=SP, C=BR',getdate()

begin tran
delete TBS025 where PARCHV=1287
commit tran

-- best bag
select * from TBS025 (nolock) where PARCHV=1267 -- 17/08/2015 15:22:23
select * from TBS025 (nolock) where PARCHV=1281 -- 15190, última consulta após programa atualizado: 15192

begin tran
update TBS025 set PARVAL='0' where PARCHV=1281
commit tran

select * from TBS0802 (nolock)

select * from TBS023 (nolock)

