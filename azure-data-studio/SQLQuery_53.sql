select top(1) *
  from TBS117 with (nolock)

select *
  from TBS143 with (nolock)
 where NDFENFNUM=21592

EXEC sp_columns 'TBS117'

begin tran
insert into TBS117
   (  NFDEMPCOD
     ,SNEEMPCOD
     ,SNESER
     ,NFDNUM
     ,FOREMPCOD
     ,FORCOD
     ,NFDESTDES
     ,NFDFORNOM
     ,NFDUSUGER
     ,NFDDATEMI
     ,NFDOBS
     ,NFDUSUCAN
     ,NFDTIPFRE
     ,NFDTRNCOD
     ,NFDTRNEMP
     ,NFDVOLQTD
     ,NFDVOLESP
     ,NFDVOLMAR
     ,NFDVOLNUM
     ,NFDPESBRU
     ,NFDPESLIQ
     ,NFDESTEMI
     ,NFDPARCOM
     ,NFDQUIREGULT
     ,NFDFRMQUIREG
     ,NFDORIEMI
     ,NFDORINUM
     ,NFDMOVESTPAD
     ,NFDSTATUS
     ,NFDENTVIA
     ,NFDHORALT
     ,NFDDATALT
     ,NFDUSUALT
   )
select  0
       ,0
       ,NDFSNESER
       ,NDFENFNUM
       ,FOREMPCOD
       ,FORCOD
       ,NDFESTDES
       ,NDFFORNOM
       ,NDFUSUEMI
       ,NDFDATEMI
       ,NDFOBS
       ,''
       ,NDFTIPFRE
       ,NDFTRNCOD
       ,NDFTRNEMPCOD
       ,NDFVOLQTD
       ,NDFVOLESP
       ,NDFVOLMAR
       ,NDFVOLNUM
       ,NDFPESBRU
       ,NDFPESLIQ
       ,'SP'
       ,''
       ,0
       ,0
       ,'17530101'
       ,0
       ,'S'
       ,''
       ,'N'
       ,NDFHORALT
       ,NDFDATALT
       ,NDFUSUALT
  from TBS143 with (nolock)
 where NDFENFNUM=21592

rollback tran
commit tran


