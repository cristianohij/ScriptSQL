create table ##CodigosClienteGrupo (codigo int)

insert into ##CodigosClienteGrupo
exec sp_ClientesGrupo

alter table ##CodigosClienteGrupo add nomeFantasia varchar(25)

update ##CodigosClienteGrupo
   set nomeFantasia=(select CLINOMFAN from TBS002 with (nolock) where CLICOD=codigo)


-- fornecedores com entregas na tanby matriz

select NFECOD
       ,NFENOM
  from TBS059 with (nolock)
 where NFEDATEFE >= '20230101'
       and NFETIP='N'
       and NFECAN='N'
       and NFENOM not Like ('TANBY%')
       and NFENOM not Like ('MISASPEL%')
       and NFENOM not Like ('WINPACK%')
       and NFENOM not Like ('%PAPELYNA%')
 group by NFECOD, NFENOM

-- quantidade de nf entregues por mês

select convert(char(6), NFEDATEFE, 112) as 'periodo'
       ,count(*) as 'contador'
  from TBS059 with (nolock)
 where NFEDATEFE >= '20230101'
       and NFETIP='N'
       and NFECAN='N'
       and NFENOM not Like ('TANBY%')
       and NFENOM not Like ('MISASPEL%')
       and NFENOM not Like ('WINPACK%')
       and NFENOM not Like ('%PAPELYNA%')
 group by convert(char(6), NFEDATEFE, 112)
 order by convert(char(6), NFEDATEFE, 112) desc

-- quantidade de nf entregues de fora do estado por mês

select convert(char(6), NFEDATEFE, 112) as 'periodo'
       ,count(*) as 'contador'
  from TBS059 with (nolock)
 where NFEDATEFE >= '20230101'
       and NFEESTORI != 'SP'
       and NFETIP='N'
       and NFECAN='N'
 group by convert(char(6), NFEDATEFE, 112)
 order by convert(char(6), NFEDATEFE, 112) desc
