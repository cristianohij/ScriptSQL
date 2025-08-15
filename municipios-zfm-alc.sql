select *
  from TBS003 (nolock)
 where (MUNNOM = 'GUAJARA-MIRIM' and UFESIG='RO') or
       (MUNNOM = 'BRASILEIA' and UFESIG='AC') or
       (MUNNOM = 'CRUZEIRO DO SUL' and UFESIG='AC') or
       (MUNNOM = 'MANAUS' and UFESIG='AM') or
       (MUNNOM = 'BONFIM' and UFESIG='RR') or
       (MUNNOM = 'MACAPA' and UFESIG='AP') or
       (MUNNOM = 'SANTANA' and UFESIG='AP') or
       (MUNNOM = 'PRESIDENTE FIGUEIREDO' and UFESIG='AM') or
       (MUNNOM = 'RIO PRETO DA EVA' and UFESIG='AM') or
       (MUNNOM = 'TABATINGA' and UFESIG='AM') or
       (MUNNOM = 'EPITACIOLANDIA' and UFESIG='AC') or
       (MUNNOM = 'BOA VISTA' and UFESIG='RR') or
       (MUNNOM = 'PACARAIMA' and UFESIG='RO')

select count(*)
  from TBS002 (nolock)
 where exists(select '' from TBS003 (nolock)
               where ((MUNNOM = 'GUAJARA-MIRIM' and UFESIG='RO') or
                      (MUNNOM = 'BRASILEIA' and UFESIG='AC') or
                      (MUNNOM = 'CRUZEIRO DO SUL' and UFESIG='AC') or
                      (MUNNOM = 'MANAUS' and UFESIG='AM') or
                      (MUNNOM = 'BONFIM' and UFESIG='RR') or
                      (MUNNOM = 'MACAPA' and UFESIG='AP') or
                      (MUNNOM = 'SANTANA' and UFESIG='AP') or
                      (MUNNOM = 'PRESIDENTE FIGUEIREDO' and UFESIG='AM') or
                      (MUNNOM = 'RIO PRETO DA EVA' and UFESIG='AM') or
                      (MUNNOM = 'TABATINGA' and UFESIG='AM') or
                      (MUNNOM = 'EPITACIOLANDIA' and UFESIG='AC') or
                      (MUNNOM = 'BOA VISTA' and UFESIG='RR') or 
                      (MUNNOM = 'PACARAIMA' and UFESIG='RO')) and
                      TBS003.UFESIG=TBS002.UFESIG and TBS003.MUNCOD=TBS002.MUNCOD)

select count(*)
  from TBS080 (nolock)
 where ENFSIT=6 and ENFCODDES in(select CLICOD
                                   from TBS002 (nolock)
                                  where exists(select '' from TBS003 (nolock)
                                                where ((MUNNOM = 'GUAJARA-MIRIM' and UFESIG='RO') or
                                                       (MUNNOM = 'BRASILEIA' and UFESIG='AC') or
                                                       (MUNNOM = 'CRUZEIRO DO SUL' and UFESIG='AC') or
                                                       (MUNNOM = 'MANAUS' and UFESIG='AM') or
                                                       (MUNNOM = 'BONFIM' and UFESIG='RR') or
                                                       (MUNNOM = 'MACAPA' and UFESIG='AP') or
                                                       (MUNNOM = 'SANTANA' and UFESIG='AP') or
                                                       (MUNNOM = 'PRESIDENTE FIGUEIREDO' and UFESIG='AM') or
                                                       (MUNNOM = 'RIO PRETO DA EVA' and UFESIG='AM') or
                                                       (MUNNOM = 'TABATINGA' and UFESIG='AM') or
                                                       (MUNNOM = 'EPITACIOLANDIA' and UFESIG='AC') or
                                                       (MUNNOM = 'BOA VISTA' and UFESIG='RR') or 
                                                       (MUNNOM = 'PACARAIMA' and UFESIG='RO')) and
                                                       TBS003.UFESIG=TBS002.UFESIG and TBS003.MUNCOD=TBS002.MUNCOD))
