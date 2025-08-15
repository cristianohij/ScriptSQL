select SNESER as serie,
       case SNESER
          when 1 then 'Geral'
          when 2 then 'Transferência'
          when 3 then 'ECF'
          when 4 then 'Entrada Devolução'
          else 'Outros'
       end,
       ENFNUM as numero,
       case ENFTIPDOC
          when 1 then 'Saída'
          when 0 then 'Entrada'
       end,
       ENFDATEMI as emissão,
       ENFCNPJCPF as CNPJ_CPF,
       ENFDESREM as Destinatário_Remetente
  from TBS080 (nolock) where ENFDATEMI between '20161101' and '20170220' and ENFSIT=6

--select * from TBS104 (nolock)