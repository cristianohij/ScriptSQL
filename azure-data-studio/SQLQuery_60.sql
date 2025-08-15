select *
  from TBS010 with (nolock)
 where MARCOD=231
       and PRODES Like('STENCIL%')
       and PROUM2QTD=5

select *
  from TBS015 with (nolock)
 where PDPCOD='02311294'

begin tran
update TBS015
   set PDPQTDEMB=3
 where PDPCOD='02311294'

rollback tran
commit tran

select*
  from TBS015 with (nolock)
 where MARCOD=231
       and PRODES Like('STENCIL%')
       and PDPQTDEMB=5

begin tran
update TBS010
   set PROUM2QTD=3
 where MARCOD=231
       and PRODES Like('STENCIL%')
       and PROUM2QTD=5

rollback tran
commit tran

begin tran
update TBS015
   set PDPQTDEMB=3
       ,PDPPREFOR=round(3 * PDPPREUNI, 4)
 where MARCOD=231
       and PRODES Like('STENCIL%')
       and PDPQTDEMB=5

rollback tran
commit tran

select *
  from TBS010 with (nolock)
 where MARCOD=231
       and PRODES Like('%DECOUPAGE%')
       and PROUM2QTD=10

begin tran
update TBS010
   set PROUM2QTD=5
 where MARCOD=231
       and PRODES Like('%DECOUPAGE%')
       and PROUM2QTD=10

rollback tran
commit tran

select *
  from TBS015 with (nolock)
 where MARCOD=231
       and PRODES Like('%DECOUPAGE%')
       and PDPQTDEMB=10

begin tran
update TBS015
   set PDPQTDEMB=5
       ,PDPPREFOR=round(5 * PDPPREUNI, 4)
 where MARCOD=231
       and PRODES Like('%DECOUPAGE%')
       and PDPQTDEMB=10

rollback tran
commit tran

select *
  from TBS010 with (nolock)
 where MARCOD=231
       and PRODES Like('CARDS OPC 15X15%')
       and PROUM2QTD=10

begin tran
update TBS010
   set PROUM2QTD=5
 where MARCOD=231
       and PRODES Like('CARDS OPC 15X15%')
       and PROUM2QTD=10

rollback tran
commit tran

select *
  from TBS015 with (nolock)
 where MARCOD=231
       and PRODES Like('CARDS OPC 15X15%')
       and PDPQTDEMB=10

begin tran
update TBS015
   set PDPQTDEMB=5
       ,PDPPREFOR=round(5 * PDPPREUNI, 4)
 where MARCOD=231
       and PRODES Like('CARDS OPC 15X15%')
       and PDPQTDEMB=10

rollback tran
commit tran



SELECT A.PROCOD AS CODIGO_A, A.PRODES AS DESCRICAO_A,
       B.PROCOD AS CODIGO_B, B.PRODES AS DESCRICAO_B
FROM TBS010 A
JOIN TBS010 B ON A.PROCOD <> B.PROCOD -- Evita comparação consigo mesmo
              AND SOUNDEX(A.PRODES) = SOUNDEX(B.PRODES) > 2;

SELECT A.PROCOD AS CODIGO_A, A.PRODES AS DESCRICAO_A,
       B.PROCOD AS CODIGO_B, B.PRODES AS DESCRICAO_B
FROM TBS010 A
JOIN TBS010 B ON A.PROCOD <> B.PROCOD -- Evita comparação consigo mesmo
              AND DIFFERENCE(A.PRODES, B.PRODES) < 2;

SELECT top(10000) A.PROCOD AS CODIGO_A, A.PRODES AS DESCRICAO_A,
       B.PROCOD AS CODIGO_B, B.PRODES AS DESCRICAO_B,
       DIFFERENCE(A.PRODES, B.PRODES) AS SIMILARIDADE
FROM TBS010 A
JOIN TBS010 B ON A.PROCOD <> B.PROCOD
              AND DIFFERENCE(A.PRODES, B.PRODES) >= 3
              and A.PROSTATUS='A'
              and A.PROSTATUS=B.PROSTATUS; -- Evita comparação consigo mesmo

SELECT top(10000) A.PROCOD AS CODIGO_A, A.PRODES AS DESCRICAO_A,
       B.PROCOD AS CODIGO_B, B.PRODES AS DESCRICAO_B,
       SOUNDEX(A.PRODES),
       SOUNDEX(B.PRODES)
FROM TBS010 A
JOIN TBS010 B ON A.PROCOD <> B.PROCOD
              AND SOUNDEX(A.PRODES) = SOUNDEX(B.PRODES)
              and A.PROSTATUS='A'
              and A.PROSTATUS=B.PROSTATUS; -- Evita comparação consigo mesmo

888