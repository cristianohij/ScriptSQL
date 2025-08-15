-- cria a tabela de dados
exec sp_PENLOC

-- lista os dados da tabela criada
select PROCOD as 'produto',PRODES as 'descricao',PROUM1 as 'um',QTDPEN as 'qtde_pendente',QTDESTLOC as 'disponivel_local',QTDESTCD as 'disponivel_CD',
       case 
          when QTDESTLOC - QTDPEN >= 0 then QTDPEN
          when QTDESTLOC - QTDPEN <  0 then QTDESTLOC
          else 0
       end as 'reservar_local',
       case 
          when QTDESTLOC - QTDPEN >= 0 then 0
          when QTDPEN - QTDESTLOC >  0 and QTDESTCD - (QTDPEN - QTDESTLOC) >= 0 then QTDPEN - QTDESTLOC
          when QTDPEN - QTDESTLOC >  0 and QTDESTCD - (QTDPEN - QTDESTLOC) <  0 then QTDESTCD
          else 0
       end as 'reservar_CD'
  from PENLOC
 order by PRODES