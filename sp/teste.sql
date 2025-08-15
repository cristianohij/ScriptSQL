if exists(select name from sysobjects where name='SP_NUMNFS' and type='P')
   drop procedure SP_NUMNFS
go

create procedure SP_NUMNFS(@numeroNF numeric output) as
   if (select TBSMOD from TBS024 (noLock) where TBSNOM='TBS067') = 'C'
      set @numeroNF = (select max(update TBS024 set TBSVALSEQ = TBSVALSEQ + 1 where TBSNOM='TBS067') from TBS024 where TBSNOM='TBS067')
go

declare @mensa varchar(40)
exec TESTE @mensa output
select @mensa

begin
   if (select TBSMOD from TBS024 (noLock) where TBSNOM='TBS067') = 'C'
      print 'compartilhada'
   else
      print 'exclusiva'
end

// verifica qual modo a tabela trabalha. 'E'-Exclusivo; 'C'-Compartilhado'
&TBSMOD = udp(PBAS007 ,TBSNOM)

if &TBSMOD = 'C'                                // se tabela compartilhada
    for each TBSNOM                             // TBS024: tabelas do sistema (cabecalho)
        TBSVALSEQ = TBSVALSEQ +1                // pega sequencia atual +1
        &sequencia = str(TBSVALSEQ ,TBSATRTAM)  // transforma sequencia em caracteres

        if(TBSTIP = 'T' and TBSZERESC = 'S')    // se atributo for texto e solicitado preenchimento a esquerda com "zeros"
            // se o tamanho da sequencia estiver menor que o tamanho do atributo
            if(Len(trim(&sequencia)) < TBSATRTAM)   
                &sequencia = strReplace(&sequencia ,' ' ,'0')   // preenche com zeros
            endif 
        endif
    endfor
else                                            // tabela exclusiva definida por empresa
    for each TBSNOM, EMPCOD                     // TBS0241: tabelas do sistema (itens)
        TBSVALSEQE = TBSVALSEQE +1              // pega sequencia atual +1
        &sequencia = str(TBSVALSEQE ,TBSATRTAM) // transforma sequencia em caracteres

        if(TBSTIP = 'T' and TBSZERESCE = 'S')   // se atributo for texto e solicitado preenchimento a esquerda com "zeros"
            // se o tamanho da sequencia estiver menor que o tamanho do atributo
            if(Len(Trim(&sequencia)) < TBSATRTAM)
                &sequencia = strReplace(&sequencia,' ', '0')    // preenche com zeros
            endif 
        endif
    endfor
endif
    
if(&emsg = 'S')         // se deve exibir mensagem
    if(null(&mensa))    // se nao foi passada a mensagem a ser exibida
        &mensa = 'Sequencia gerada: '
    endif
    &mensa = &mensa + &sequencia
    msg(&mensa )
endif
