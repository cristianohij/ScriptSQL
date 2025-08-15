select * from TBS034 (nolock)

select * into ESTOQUE_D18M12A2015_16H25M from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU <> 0

select COUNT(*) from ESTOQUE_D11M12A2015_10H26M

select COUNT(*) from TBS0371 (nolock) group by PROCOD

select count(*) from TBS032 (nolock) where ESTLOC=1 and ESTQTDATU > 0

select count(*) from ESTOQUE_D11M12A2015_10H26M (nolock)

select count(*) from TBS0371 (nolock)

select (select PRODES from TBS010 (nolock) where TBS010.PROCOD=A.PROCOD),A.PROCOD,B.PROCOD,A.ESTQTDATU,B.ESTQTDATU
  from ESTOQUE_D11M12A2015_10H26M A (nolock) right join TBS032 B (nolock) on A.PROCOD=B.PROCOD and A.ESTLOC=B.ESTLOC
 where A.ESTQTDATU<>B.ESTQTDATU 


select (select PRODES from TBS010 (nolock) where TBS010.PROCOD=A.PROCOD),A.PROCOD,A.ESTQTDATU
  from TBS032 A (nolock)
 where not exists(select '' from ESTOQUE_D11M12A2015_10H26M B (nolock) WHERE B.PROCOD=A.PROCOD and B.ESTLOC=A.ESTLOC) and
       A.ESTQTDATU>0 and A.ESTLOC=1

select * from ESTOQUE_D11M12A2015_10H26M (nolock) where ESTLOC=1 and ESTQTDATU < 0

select A.PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=A.PROCOD) as descricao,
       A.ESTQTDATU as qtdeAtual,
       isnull(B.ESTQTDATU,0) as qtdeAnterior
  from TBS032 A (nolock) full outer join ESTOQUE_D11M12A2015_10H26M B (nolock) on A.PROCOD=B.PROCOD and A.ESTLOC=B.ESTLOC
 where A.ESTLOC=1 and
       (A.ESTQTDATU > 0 or B.ESTQTDATU > 0)

select * from TBS032 (nolock)
 where ESTLOC=1 and ESTQTDATU > 0 and not exists(select '' from ESTOQUE_D11M12A2015_10H26M
                                                  where ESTOQUE_D11M12A2015_10H26M.ESTLOC=TBS032.ESTLOC and ESTOQUE_D11M12A2015_10H26M.PROCOD=TBS032.PROCOD)


select * from TBS058 (nolock)

select top 1 * from TBS015 (nolock)

select sum(ESTQTDATU*dbo.PDPCUSBAS(0,PROCOD) from ESTOQUE_D11M12A2015_10H26M (nolock) where ESTQTDATU > 0


-- tanby matriz

-- ESTOQUE_D12M12A2015_12H53M
-- LOJA_D12M12A2015_15H38M

select 'anterior ',count(*) from ESTOQUE_D12M12A2015_12H53M (nolock) where ESTLOC=1 and ESTQTDATU > 0
select 'atual ',count(*) from EST (nolock) where ESTLOC=1 and ESTQTDATU > 0

-- estoque 1

select ATU.PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=ATU.PROCOD) as descricao,
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=ATU.PROCOD) as unidade,
       ATU.ESTQTDATU as qtdeAtual,
       isnull(ANT.ESTQTDATU,0) as qtdeAnterior
  from TBS032 ATU (nolock) full outer join ESTOQUE_D19M12A2015_00H29M ANT (nolock) on ATU.PROCOD=ANT.PROCOD and ATU.ESTLOC=ANT.ESTLOC
 where ATU.ESTLOC=1 and
       (ATU.ESTQTDATU > 0 or ANT.ESTQTDATU > 0)

-- -- estoque 2

select ATU.PROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=ATU.PROCOD) as descricao,
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=ATU.PROCOD) as unidade,
       ATU.ESTQTDATU as qtdeAtual,
       isnull(ANT.ESTQTDATU,0) as qtdeAnterior
  from TBS032 ATU (nolock) full outer join LOJA_D19M12A2015_15H04M ANT (nolock) on ATU.PROCOD=ANT.PROCOD and ATU.ESTLOC=ANT.ESTLOC
 where ATU.ESTLOC=2 and
       (ATU.ESTQTDATU > 0 or ANT.ESTQTDATU > 0)

select sum((ESTQTDATU - ESTQTDRES)*dbo.PDPCUSBAS(0,PROCOD) from ESTOQUE_D11M12A2015_10H26M (nolock) where ESTQTDATU > 0

