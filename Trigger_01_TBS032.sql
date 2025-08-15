create trigger UltimaAleracaoSaldo_TBS032 on TBS032 after update as
   begin
      -- atualiza a data/hora da alteração do saldo do produto na TBS032
      update TBS032 set TBS032.ESTDATALT=getdate(),TBS032.ESTROTEXE='TRIGGER' from inserted
       where TBS032.PROEMPCOD=inserted.PROEMPCOD and TBS032.ESTLOC=inserted.ESTLOC and TBS032.PROCOD=inserted.PROCOD
   end

create trigger ValorICMS_TBS0591 on TBS0591 after insert,update as
   begin
      -- grava o valor do ICMS
      update TBS0591 set TBS0591.NFEVALICMS=dbo.NFEVALICMS(inserted.NFEEMPCOD,inserted.NFETIP,inserted.NFENUM,inserted.NFECOD,inserted.SEREMPCOD,inserted.SERCOD,inserted.NFEITE)
        from inserted
       where TBS0591.NFEEMPCOD=inserted.NFEEMPCOD and TBS0591.NFETIP=inserted.NFETIP and TBS0591.NFENUM=inserted.NFENUM and TBS0591.NFECOD=inserted.NFECOD and
             TBS0591.SEREMPCOD=inserted.SEREMPCOD and TBS0591.SERCOD=inserted.SERCOD and TBS0591.NFEITE=inserted.NFEITE
   end


-- grava data/hora/número do último pedido de compras incluído

create trigger UltimoPedidoComprasIncluido on TBS0451 after insert as
   begin
      -- grava dados na TBS010
      update TBS010 set PRODATULTPEDCOM=convert(char(8),getdate(),112),PROHORULTPEDCOM=convert(char(8),getdate(),14),PRONUMULTPEDCOM=inserted.PDCNUM
        from inserted where TBS010.PROEMPCOD=inserted.PROEMPCOD and inserted.PROCOD=TBS010.PROCOD
   end


-- grava data/hora/número da última NF-E de venda emitida

drop trigger UltimaNfeVendaEmitida

create trigger UltimaNfeVendaEmitida on TBS0671 after insert as
   begin
      -- grava dados na TBS010
      update TBS010 set PRODATULTNFEVEN=convert(char(8),getdate(),112),PROHORULTNFEVEN=convert(char(8),getdate(),14),PRONUMULTNFEVEN=inserted.NFSNUM
        from inserted left join TBS042 (nolock) on TBS042.TESCOD=inserted.TESCOD
                      left join TBS067 (nolock) on TBS067.SNESER=inserted.SNESER and TBS067.NFSNUM=inserted.NFSNUM
       where TBS010.PROEMPCOD=inserted.PROEMPCOD and TBS010.PROCOD=inserted.PROCOD and TESCNTVEN='S' and NFSTIP='N'
   end


-- grava data/hora/número do último cupom fiscal emitido

drop trigger UltimaCupomFiscalEmitido

create trigger UltimaCupomFiscalEmitido on MSL002 after insert as
   begin
      -- grava dados na TBS010
      update TBS010 set PRODATULTCUPFIS=convert(char(8),getdate(),112),PROHORULTCUPFIS=convert(char(8),getdate(),14),PRONUMULTCUPFIS=inserted.M2_NUMDOC
        from inserted where inserted.M2_TIPREG='01' and inserted.M2_REGCAN='F' and TBS010.PROCOD=inserted.M2_PROCOD
   end


print convert(char(8),getdate(),14)

SELECT TOP 1 * FROM MSL002 (NOLOCK)

select * from TBS010 (nolock) where PRODATULTPEDCOM<>'17530101'
select * from TBS010 (nolock) where PRODATULTNFEVEN<>'17530101'

select * from MSL002 (nolock) where M2_NUMDOC=56496

print convert(char(8),getdate(),112)

select PRODATULTNFEVEN from TBS010 (nolock) where PROCOD='1640054'

-- NFS
select PROCOD,PRODATULTNFEVEN,PROHORULTNFEVEN,PRONUMULTNFEVEN from TBS010 (nolock) where MARCOD=164

-- ECF
select PROCOD,PRODATULTCUPFIS,PROHORULTCUPFIS,PRONUMULTCUPFIS from TBS010 (nolock) where MARCOD=164

-- PC
select PROCOD,PRODATULTPEDCOM,PROHORULTPEDCOM,PRONUMULTPEDCOM from TBS010 (nolock) where MARCOD=164
