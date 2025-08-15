select CLICOD
       ,CLINOM
       ,CLISINHAB
       ,CLIDATBAICON
       ,CLIDATHORCONSIN
       ,CLIINIATI
       ,CLIMODSITCAD
       ,CLICRENFE
       ,CLICRT
       ,CLICNAE
       ,replicate('',60) xNome
       ,replicate('',14) CNPJ
       ,replicate('',18) IE
       ,replicate('', 2) UF
       ,replicate('',60) xLgr
       ,replicate('',60) nro
       ,replicate('',60) xBairro
       ,0 cMun
       ,replicate('',9) CEP
       ,replicate('',60) xCpl
--  into CLISINTEGRA
  from TBS002 with (nolock)

delete CLISINTEGRA

select *
  from CLISINTEGRA with (nolock)

insert into CLISINTEGRA (CLICOD,CLIDATBAICON) values(1,'08/05/19')

CLICOD CLINOM CLISINHAB CLIDATBAICON CLIDATHORCONSIN CLIINIATI CLIMODSITCAD CLICRENFE CLICRT CLICNAE xNome CNPJ IE UF xLgr nro xBairro cMun CEP xCpl

insert into CLISINTEGRA
select 4
       ,'BLINDEX VIDROS DE SEGURANCA LTDA (B)'
       ,1
       ,convert(date,'01/01/53')
       ,convert(datetime,'08/05/2019 13:50:30'),convert(date,'24/01/63'),convert(date,'24/01/63'),1,3,2311700,'PILKINGTON BRASIL LTDA.','61736732000562','234001767110','SP','RODOVIA PRESIDENTE DUTRA (BR 116)','SN','VILA ANTONIO AUGUSTO LUIZ',3508504,'12286160','KM 131 133 KM 131'

select convert(date,'24/01/63')

insert into CLISINTEGRA select 2,'PARKER HANNIFIN IND.COM. LTDA',1,convert(date,'01/01/53'),convert(datetime,'08/05/2019 15:55:58'),convert(date,'04/01/56'),convert(date,'04/01/56'),1,3,2829199,'PARKER HANNIFIN INDUSTRIA E COMERCIO LTDA','54823455000802','392001544114','SP','AVENIDA Lucas Nogueira Garcez','2181','Esperanca',3524402,'12325900',''

select count(*) from TBS002 with (nolock)

insert into CLISINTEGRA select 440,'USIMON ENG. LTDA.',0,convert(date,'01/01/53'),convert(datetime,'09/05/2019 15:56:46'),convert(date,'22/07/87'),convert(date,'26/06/06'),0,3,2822402,'USIMONSERV BRASIL ENGENHARIA LTDA','57225930000160','645112790111','SP','RUA GUACUI','300','CHACARAS REUNIDAS',3549904,'12238480',''

select getdate()