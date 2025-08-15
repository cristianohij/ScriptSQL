select * from TBS057 (nolock) where CPATIT=100617

select * from TBS0165 (nolock) where USUCOD='LAISAL'

select * from master..sysservers

select * from filial1.SIBD.dbo.TBS057 where CPATIT=100617

select * from filial2.SIBD.dbo.TBS057 where CPATIT=100617

select * from BA.SIBD.dbo.TBS057 where CPATIT=100617


select count(*) from integros.SIBDND.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'

select max(CPADATBAI) from integros.SIBDND.dbo.TBS057

select max(CPADATBAI) from integros.SIBD2014.dbo.TBS057

select max(ENFDATEMI) from integros.SIBDND.dbo.TBS080

select max(ENFDATEMI) from integros.SIBD2014.dbo.TBS080

select * into CPRESTAURAR2 from integros.SIBDND.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

begin tran
insert into TBS057 select * from integros.SIBDND.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'
rollback tran
commit tran

begin tran
delete TBS057 from TBS057 as A (nolock)
 where exists(select '' from integros.SIBD2014.dbo.TBS057 as B where CPADATEMI<='20141231' and CPADATBAI='17530101' and
       A.CPAEMPCOD=B.CPAEMPCOD and A.PFXEMPCOD=B.PFXEMPCOD and A.FOREMPCOD=B.FOREMPCOD and A.PFXCOD=B.PFXCOD and A.CPATIT=B.CPATIT and A.CPAPAR=B.CPAPAR and
                             A.FORCOD=B.FORCOD)

rollback tran
commit tran

begin tran
insert into TBS062
select *
  from integros.SIBDND.dbo.TBS062 as A
 where --HCPDAT<='20141231' and 
       exists(select * from integros.SIBDND.dbo.TBS057 as B
                       where A.HCPEMPCOD=B.CPAEMPCOD and A.HCPPFXEMPCOD=B.PFXEMPCOD and A.HCPFOREMPCOD=B.FOREMPCOD and A.HCPPFXCOD=B.PFXCOD and A.HCPTIT=B.CPATIT and A.HCPPAR=B.CPAPAR and
                             A.HCPFORCOD=B.FORCOD and B.CPADATEMI<='20141231' and B.CPADATBAI='17530101'
                             and
                             not exists(select * from TBS062 as C
                                         where C.HCPEMPCOD=B.CPAEMPCOD and C.HCPPFXEMPCOD=B.PFXEMPCOD and C.HCPFOREMPCOD=B.FOREMPCOD and C.HCPPFXCOD=B.PFXCOD and
                                               C.HCPTIT=B.CPATIT and C.HCPPAR=B.CPAPAR and C.HCPFORCOD=B.FORCOD))
rollback tran
commit tran

select * from #HIS as B
 where not exists(select * from TBS062 as C
                   where C.HCPEMPCOD=B.CPAEMPCOD and C.HCPPFXEMPCOD=B.PFXEMPCOD and C.HCPFOREMPCOD=B.FOREMPCOD and C.HCPPFXCOD=B.PFXCOD and C.HCPTIT=B.CPATIT and C.HCPPAR=B.CPAPAR and
                         C.HCPFORCOD=B.FORCOD and C.HCPSEQ=B.HCPSEQ))

select * from TBS062 (nolock) where 
HCPEMPCOD=0 and HCPPFXEMPCOD=0 and HCPFOREMPCOD=0 and HCPPFXCOD='S11' and HCPTIT=100518 and HCPPAR='A0' and HCPFORCOD=1259

select * from TBS062 (nolock)
 where HCPEMPCOD=0 and HCPPFXEMPCOD=0 and HCPFOREMPCOD=0 and HCPPFXCOD='S11' and HCPFORCOD=1259 and HCPCAMPO='VALOR PAGO'
 order by HCPDAT
 


begin tran
delete TBS062
--select * into HISCPNAOEXISTE
--select *
 from TBS062 (nolock)
 where not exists(select ''
                    from TBS057 (nolock)
                   where HCPEMPCOD=CPAEMPCOD and HCPPFXEMPCOD=PFXEMPCOD and HCPFOREMPCOD=FOREMPCOD and HCPPFXCOD=PFXCOD and HCPTIT=CPATIT and HCPPAR=CPAPAR and HCPFORCOD=FORCOD)
commit tran

                   where B.HCPEMPCOD=A.HCPEMPCOD and B.HCPPFXEMPCOD=A.HCPPFXEMPCOD and B.HCPFOREMPCOD=A.HCPFOREMPCOD and B.HCPPFXCOD=A.HCPPFXCOD and B.HCPTIT=A.HCPTIT and B.HCPPAR=A.HCPPAR and
                         B.HCPFORCOD=A.HCPFORCOD and B.HCPSEQ=A.HCPSEQ)



select * from integros.SIBDND.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'
and PFXCOD='S11' and CPATIT=2010803621 
--and CPAPAR='A0'
and FORCOD=2155

select * from CPRESTAURAR where PFXCOD='S11' and CPATIT=100317 and CPAPAR='A0' and FORCOD=1259

select * from integros.SIBDND.dbo.TBS062 where 
HCPPFXCOD='S11' and HCPTIT=2010803621 
and HCPPAR='G0'
and HCPFORCOD=2155


begin tran
insert into TBS056 select * from integros.SIBDND.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'
rollback tran
commit tran

select * into CRRESTAURAR from integros.SIBDND.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'

select CRETITORI,count(*) from integros.SIBDND.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101' group by CRETITORI

select * from integros.SIBDND.dbo.TBS056
 where CREDATEMI<='20141231' and CREDATBAI='17530101' 
       and CRETITORI='A'
       and exists(select '' from integros.SIBDND.dbo.TBS080 where ENFNUM=CRETIT and ENFCODDES=CLICOD and ENFTIPDOC=1 and ENFSIT=6)

select top 1 * from TBS080 (nolock)

select * from integros.SIBDND.dbo.TBS056
 where CREDATEMI<='20141231' and CREDATBAI='17530101' 
       and CRETITORI='A'
       and exists(select '' from integros.SIBDND.dbo.TBS080 as A
                   where ENFNUM=CRETIT and ENFCODDES=CLICOD and ENFTIPDOC=1 and ENFSIT=6
                         and exists(select '' from integros.SIBDND.dbo.TBS067 as B
                                     where B.SNESER=A.SNESER and B.NFSNUM=A.ENFNUM
                                           and NFSDEV='S'))

select top 1 * from TBS067 (nolock)


begin tran
insert into TBS060
select *
  from integros.SIBDND.dbo.TBS060 as A
 where --HCPDAT<='20141231' and 
       exists(select * from integros.SIBDND.dbo.TBS056 as B
                       where A.HCREMPCOD=B.CREEMPCOD and A.HCRPFXEMPCOD=B.PFXEMPCOD and A.HCRCLIEMPCOD=B.CLIEMPCOD and A.HCRPFXCOD=B.PFXCOD and A.HCRTIT=B.CRETIT and A.HCRPAR=B.CREPAR and
                             A.HCRCLICOD=B.CLICOD and B.CREDATEMI<='20141231' and B.CREDATBAI='17530101'
                             and
                             not exists(select * from TBS060 as C
                                         where C.HCREMPCOD=B.CREEMPCOD and C.HCRPFXEMPCOD=B.PFXEMPCOD and C.HCRCLIEMPCOD=B.CLIEMPCOD and C.HCRPFXCOD=B.PFXCOD and
                                               C.HCRTIT=B.CRETIT and C.HCRPAR=B.CREPAR and C.HCRCLICOD=B.CLICOD))
rollback tran
commit tran

select top 1 * from TBS060 (nolock)


-- taubaté

select * from INTG.SIBDTT.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

select max(CPADATBAI) from INTG.SIBDTT.dbo.TBS057

select * into CPARESTAURAR from INTG.SIBDTT.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

-- contas a pagar

begin tran
insert into TBS057 select * from INTG.SIBDTT.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS062
select *
  from INTG.SIBDTT.dbo.TBS062 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDTT.dbo.TBS057 as B
                       where A.HCPEMPCOD=B.CPAEMPCOD and A.HCPPFXEMPCOD=B.PFXEMPCOD and A.HCPFOREMPCOD=B.FOREMPCOD and A.HCPPFXCOD=B.PFXCOD and A.HCPTIT=B.CPATIT and A.HCPPAR=B.CPAPAR and
                             A.HCPFORCOD=B.FORCOD and B.CPADATEMI<='20141231' and B.CPADATBAI='17530101'
                             and
                             not exists(select * from TBS062 as C
                                         where C.HCPEMPCOD=B.CPAEMPCOD and C.HCPPFXEMPCOD=B.PFXEMPCOD and C.HCPFOREMPCOD=B.FOREMPCOD and C.HCPPFXCOD=B.PFXCOD and
                                               C.HCPTIT=B.CPATIT and C.HCPPAR=B.CPAPAR and C.HCPFORCOD=B.FORCOD))
rollback tran
commit tran


-- contas a receber

begin tran
insert into TBS056 select * from INTG.SIBDTT.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS060
select *
  from INTG.SIBDTT.dbo.TBS060 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDTT.dbo.TBS056 as B
                       where A.HCREMPCOD=B.CREEMPCOD and A.HCRPFXEMPCOD=B.PFXEMPCOD and A.HCRCLIEMPCOD=B.CLIEMPCOD and A.HCRPFXCOD=B.PFXCOD and A.HCRTIT=B.CRETIT and A.HCRPAR=B.CREPAR and
                             A.HCRCLICOD=B.CLICOD and B.CREDATEMI<='20141231' and B.CREDATBAI='17530101'
                             and
                             not exists(select * from TBS060 as C
                                         where C.HCREMPCOD=B.CREEMPCOD and C.HCRPFXEMPCOD=B.PFXEMPCOD and C.HCRCLIEMPCOD=B.CLIEMPCOD and C.HCRPFXCOD=B.PFXCOD and
                                               C.HCRTIT=B.CRETIT and C.HCRPAR=B.CREPAR and C.HCRCLICOD=B.CLICOD))
rollback tran
commit tran


-- contas a pagar

begin tran
delete TBS062
--select * into HISCPNAOEXISTE
--select *
 from TBS062 (nolock)
 where not exists(select ''
                    from TBS057 (nolock)
                   where HCPEMPCOD=CPAEMPCOD and HCPPFXEMPCOD=PFXEMPCOD and HCPFOREMPCOD=FOREMPCOD and HCPPFXCOD=PFXCOD and HCPTIT=CPATIT and HCPPAR=CPAPAR and HCPFORCOD=FORCOD)
commit tran

-- contas a receber

begin tran
delete TBS060
--select * into HISCPNAOEXISTE
--select *
 from TBS060 (nolock)
 where not exists(select ''
                    from TBS056 (nolock)
                   where HCREMPCOD=CREEMPCOD and HCRPFXEMPCOD=PFXEMPCOD and HCRCLIEMPCOD=CLIEMPCOD and HCRPFXCOD=PFXCOD and HCRTIT=CRETIT and HCRPAR=CREPAR and HCRCLICOD=CLICOD)
commit tran



-- CD

select * from INTG.SIBDCD.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

select max(CPADATBAI) from INTG.SIBDCD.dbo.TBS057 where CPADATBAI<='20170815'
 
select * into CPARESTAURAR from INTG.SIBDCD.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

-- contas a pagar

begin tran
insert into TBS057 select * from INTG.SIBDCD.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS062
select *
  from INTG.SIBDCD.dbo.TBS062 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDCD.dbo.TBS057 as B
                       where A.HCPEMPCOD=B.CPAEMPCOD and A.HCPPFXEMPCOD=B.PFXEMPCOD and A.HCPFOREMPCOD=B.FOREMPCOD and A.HCPPFXCOD=B.PFXCOD and A.HCPTIT=B.CPATIT and A.HCPPAR=B.CPAPAR and
                             A.HCPFORCOD=B.FORCOD and B.CPADATEMI<='20141231' and B.CPADATBAI='17530101'
                             and
                             not exists(select * from TBS062 as C
                                         where C.HCPEMPCOD=B.CPAEMPCOD and C.HCPPFXEMPCOD=B.PFXEMPCOD and C.HCPFOREMPCOD=B.FOREMPCOD and C.HCPPFXCOD=B.PFXCOD and
                                               C.HCPTIT=B.CPATIT and C.HCPPAR=B.CPAPAR and C.HCPFORCOD=B.FORCOD))
rollback tran
commit tran


-- contas a receber

begin tran
insert into TBS056 select * from INTG.SIBDCD.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS060
select *
  from INTG.SIBDCD.dbo.TBS060 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDCD.dbo.TBS056 as B
                       where A.HCREMPCOD=B.CREEMPCOD and A.HCRPFXEMPCOD=B.PFXEMPCOD and A.HCRCLIEMPCOD=B.CLIEMPCOD and A.HCRPFXCOD=B.PFXCOD and A.HCRTIT=B.CRETIT and A.HCRPAR=B.CREPAR and
                             A.HCRCLICOD=B.CLICOD and B.CREDATEMI<='20141231' and B.CREDATBAI='17530101'
                             and
                             not exists(select * from TBS060 as C
                                         where C.HCREMPCOD=B.CREEMPCOD and C.HCRPFXEMPCOD=B.PFXEMPCOD and C.HCRCLIEMPCOD=B.CLIEMPCOD and C.HCRPFXCOD=B.PFXCOD and
                                               C.HCRTIT=B.CRETIT and C.HCRPAR=B.CREPAR and C.HCRCLICOD=B.CLICOD))
rollback tran
commit tran


-- contas a pagar

begin tran
delete TBS062
--select * into HISCPNAOEXISTE
--select *
 from TBS062 (nolock)
 where not exists(select ''
                    from TBS057 (nolock)
                   where HCPEMPCOD=CPAEMPCOD and HCPPFXEMPCOD=PFXEMPCOD and HCPFOREMPCOD=FOREMPCOD and HCPPFXCOD=PFXCOD and HCPTIT=CPATIT and HCPPAR=CPAPAR and HCPFORCOD=FORCOD)
commit tran

-- contas a receber

begin tran
delete TBS060
--select * into HISCPNAOEXISTE
--select *
 from TBS060 (nolock)
 where not exists(select ''
                    from TBS056 (nolock)
                   where HCREMPCOD=CREEMPCOD and HCRPFXEMPCOD=PFXEMPCOD and HCRCLIEMPCOD=CLIEMPCOD and HCRPFXCOD=PFXCOD and HCRTIT=CRETIT and HCRPAR=CREPAR and HCRCLICOD=CLICOD)
commit tran



-- best bag

select * from INTG.SIBDBB.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

select max(CPADATBAI) from INTG.SIBDBB.dbo.TBS057 where CPADATBAI<='20170815'
 
select * into CPARESTAURAR from INTG.SIBDBB.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

-- contas a pagar

begin tran
insert into TBS057 select * from INTG.SIBDBB.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS062
select *
  from INTG.SIBDBB.dbo.TBS062 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDBB.dbo.TBS057 as B
                       where A.HCPEMPCOD=B.CPAEMPCOD and A.HCPPFXEMPCOD=B.PFXEMPCOD and A.HCPFOREMPCOD=B.FOREMPCOD and A.HCPPFXCOD=B.PFXCOD and A.HCPTIT=B.CPATIT and A.HCPPAR=B.CPAPAR and
                             A.HCPFORCOD=B.FORCOD and B.CPADATEMI<='20141231' and B.CPADATBAI='17530101'
                             and
                             not exists(select * from TBS062 as C
                                         where C.HCPEMPCOD=B.CPAEMPCOD and C.HCPPFXEMPCOD=B.PFXEMPCOD and C.HCPFOREMPCOD=B.FOREMPCOD and C.HCPPFXCOD=B.PFXCOD and
                                               C.HCPTIT=B.CPATIT and C.HCPPAR=B.CPAPAR and C.HCPFORCOD=B.FORCOD))
rollback tran
commit tran


-- contas a receber

begin tran
insert into TBS056 select * from INTG.SIBDBB.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS060
select *
  from INTG.SIBDBB.dbo.TBS060 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDBB.dbo.TBS056 as B
                       where A.HCREMPCOD=B.CREEMPCOD and A.HCRPFXEMPCOD=B.PFXEMPCOD and A.HCRCLIEMPCOD=B.CLIEMPCOD and A.HCRPFXCOD=B.PFXCOD and A.HCRTIT=B.CRETIT and A.HCRPAR=B.CREPAR and
                             A.HCRCLICOD=B.CLICOD and B.CREDATEMI<='20141231' and B.CREDATBAI='17530101'
                             and
                             not exists(select * from TBS060 as C
                                         where C.HCREMPCOD=B.CREEMPCOD and C.HCRPFXEMPCOD=B.PFXEMPCOD and C.HCRCLIEMPCOD=B.CLIEMPCOD and C.HCRPFXCOD=B.PFXCOD and
                                               C.HCRTIT=B.CRETIT and C.HCRPAR=B.CREPAR and C.HCRCLICOD=B.CLICOD))
rollback tran
commit tran


-- contas a pagar

begin tran
delete TBS062
--select * into HISCPNAOEXISTE
--select *
 from TBS062 (nolock)
 where not exists(select ''
                    from TBS057 (nolock)
                   where HCPEMPCOD=CPAEMPCOD and HCPPFXEMPCOD=PFXEMPCOD and HCPFOREMPCOD=FOREMPCOD and HCPPFXCOD=PFXCOD and HCPTIT=CPATIT and HCPPAR=CPAPAR and HCPFORCOD=FORCOD)
commit tran

-- contas a receber

begin tran
delete TBS060
--select * into HISCPNAOEXISTE
--select *
 from TBS060 (nolock)
 where not exists(select ''
                    from TBS056 (nolock)
                   where HCREMPCOD=CREEMPCOD and HCRPFXEMPCOD=PFXEMPCOD and HCRCLIEMPCOD=CLIEMPCOD and HCRPFXCOD=PFXCOD and HCRTIT=CRETIT and HCRPAR=CREPAR and HCRCLICOD=CLICOD)
commit tran



-- misaspel

select * from TBS023 (nolock)

select * from INTG.SIBDMIS.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

select max(CPADATBAI) from INTG.SIBDMIS.dbo.TBS057 where CPADATBAI<='20170815'
 
select * into CPARESTAURAR from INTG.SIBDMIS.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

-- contas a pagar

begin tran
insert into TBS057 select * from INTG.SIBDMIS.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS062
select *
  from INTG.SIBDMIS.dbo.TBS062 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDMIS.dbo.TBS057 as B
                       where A.HCPEMPCOD=B.CPAEMPCOD and A.HCPPFXEMPCOD=B.PFXEMPCOD and A.HCPFOREMPCOD=B.FOREMPCOD and A.HCPPFXCOD=B.PFXCOD and A.HCPTIT=B.CPATIT and A.HCPPAR=B.CPAPAR and
                             A.HCPFORCOD=B.FORCOD and B.CPADATEMI<='20141231' and B.CPADATBAI='17530101'
                             and
                             not exists(select * from TBS062 as C
                                         where C.HCPEMPCOD=B.CPAEMPCOD and C.HCPPFXEMPCOD=B.PFXEMPCOD and C.HCPFOREMPCOD=B.FOREMPCOD and C.HCPPFXCOD=B.PFXCOD and
                                               C.HCPTIT=B.CPATIT and C.HCPPAR=B.CPAPAR and C.HCPFORCOD=B.FORCOD))
rollback tran
commit tran


-- contas a receber

select * from INTG.SIBDMIS.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'

select max(CREDATBAI) from INTG.SIBDMIS.dbo.TBS056 where CREDATBAI<='20170815'
 
select * into CRERESTAURAR from INTG.SIBDMIS.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'

begin tran
insert into TBS056 select * from INTG.SIBDMIS.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS060
select *
  from INTG.SIBDMIS.dbo.TBS060 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDMIS.dbo.TBS056 as B
                       where A.HCREMPCOD=B.CREEMPCOD and A.HCRPFXEMPCOD=B.PFXEMPCOD and A.HCRCLIEMPCOD=B.CLIEMPCOD and A.HCRPFXCOD=B.PFXCOD and A.HCRTIT=B.CRETIT and A.HCRPAR=B.CREPAR and
                             A.HCRCLICOD=B.CLICOD and B.CREDATEMI<='20141231' and B.CREDATBAI='17530101'
                             and
                             not exists(select * from TBS060 as C
                                         where C.HCREMPCOD=B.CREEMPCOD and C.HCRPFXEMPCOD=B.PFXEMPCOD and C.HCRCLIEMPCOD=B.CLIEMPCOD and C.HCRPFXCOD=B.PFXCOD and
                                               C.HCRTIT=B.CRETIT and C.HCRPAR=B.CREPAR and C.HCRCLICOD=B.CLICOD))
rollback tran
commit tran


-- contas a pagar

begin tran
delete TBS062
--select * into HISCPNAOEXISTE
--select *
 from TBS062 (nolock)
 where not exists(select ''
                    from TBS057 (nolock)
                   where HCPEMPCOD=CPAEMPCOD and HCPPFXEMPCOD=PFXEMPCOD and HCPFOREMPCOD=FOREMPCOD and HCPPFXCOD=PFXCOD and HCPTIT=CPATIT and HCPPAR=CPAPAR and HCPFORCOD=FORCOD)
commit tran

-- contas a receber

begin tran
delete TBS060
--select * into HISCPNAOEXISTE
--select *
 from TBS060 (nolock)
 where not exists(select ''
                    from TBS056 (nolock)
                   where HCREMPCOD=CREEMPCOD and HCRPFXEMPCOD=PFXEMPCOD and HCRCLIEMPCOD=CLIEMPCOD and HCRPFXCOD=PFXCOD and HCRTIT=CRETIT and HCRPAR=CREPAR and HCRCLICOD=CLICOD)
commit tran




-- papelyna

select * from INTG.SIBDPP.dbo.TBS023

select * from INTG.SIBDPP.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

select max(CPADATBAI) from INTG.SIBDPP.dbo.TBS057 where CPADATBAI<='20170815'
 
select * into CPARESTAURAR from INTG.SIBDPP.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'

-- contas a pagar

begin tran
insert into TBS057 select * from INTG.SIBDPP.dbo.TBS057 where CPADATEMI<='20141231' and CPADATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS062
select *
  from INTG.SIBDPP.dbo.TBS062 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDPP.dbo.TBS057 as B
                       where A.HCPEMPCOD=B.CPAEMPCOD and A.HCPPFXEMPCOD=B.PFXEMPCOD and A.HCPFOREMPCOD=B.FOREMPCOD and A.HCPPFXCOD=B.PFXCOD and A.HCPTIT=B.CPATIT and A.HCPPAR=B.CPAPAR and
                             A.HCPFORCOD=B.FORCOD and B.CPADATEMI<='20141231' and B.CPADATBAI='17530101'
                             and
                             not exists(select * from TBS062 as C
                                         where C.HCPEMPCOD=B.CPAEMPCOD and C.HCPPFXEMPCOD=B.PFXEMPCOD and C.HCPFOREMPCOD=B.FOREMPCOD and C.HCPPFXCOD=B.PFXCOD and
                                               C.HCPTIT=B.CPATIT and C.HCPPAR=B.CPAPAR and C.HCPFORCOD=B.FORCOD))
rollback tran
commit tran


-- contas a receber

select * from INTG.SIBDPP.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'

select max(CREDATBAI) from INTG.SIBDPP.dbo.TBS056 where CREDATBAI<='20170815'
 
select * into CRERESTAURAR from INTG.SIBDPP.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'

begin tran
insert into TBS056 select * from INTG.SIBDPP.dbo.TBS056 where CREDATEMI<='20141231' and CREDATBAI='17530101'
rollback tran
commit tran

begin tran
insert into TBS060
select *
  from INTG.SIBDPP.dbo.TBS060 as A
 where --HCPDAT<='20141231' and 
       exists(select * from INTG.SIBDPP.dbo.TBS056 as B
                       where A.HCREMPCOD=B.CREEMPCOD and A.HCRPFXEMPCOD=B.PFXEMPCOD and A.HCRCLIEMPCOD=B.CLIEMPCOD and A.HCRPFXCOD=B.PFXCOD and A.HCRTIT=B.CRETIT and A.HCRPAR=B.CREPAR and
                             A.HCRCLICOD=B.CLICOD and B.CREDATEMI<='20141231' and B.CREDATBAI='17530101'
                             and
                             not exists(select * from TBS060 as C
                                         where C.HCREMPCOD=B.CREEMPCOD and C.HCRPFXEMPCOD=B.PFXEMPCOD and C.HCRCLIEMPCOD=B.CLIEMPCOD and C.HCRPFXCOD=B.PFXCOD and
                                               C.HCRTIT=B.CRETIT and C.HCRPAR=B.CREPAR and C.HCRCLICOD=B.CLICOD))
rollback tran
commit tran


-- contas a pagar

begin tran
delete TBS062
--select * into HISCPNAOEXISTE
--select *
 from TBS062 (nolock)
 where not exists(select ''
                    from TBS057 (nolock)
                   where HCPEMPCOD=CPAEMPCOD and HCPPFXEMPCOD=PFXEMPCOD and HCPFOREMPCOD=FOREMPCOD and HCPPFXCOD=PFXCOD and HCPTIT=CPATIT and HCPPAR=CPAPAR and HCPFORCOD=FORCOD)
commit tran

-- contas a receber

begin tran
delete TBS060
--select * into HISCPNAOEXISTE
--select *
 from TBS060 (nolock)
 where not exists(select ''
                    from TBS056 (nolock)
                   where HCREMPCOD=CREEMPCOD and HCRPFXEMPCOD=PFXEMPCOD and HCRCLIEMPCOD=CLIEMPCOD and HCRPFXCOD=PFXCOD and HCRTIT=CRETIT and HCRPAR=CREPAR and HCRCLICOD=CLICOD)
commit tran

