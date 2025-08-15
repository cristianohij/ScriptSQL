select *
  from TBS0591 (nolock) inner join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where TBS059.NFEDATENT between '20170101' and '20181231' and TBS0591.NFETIP<>'D' and TBS059.NFECAN<>'S' and TBS0591.PROCOD in('7480001')
 order by TBS059.NFEDATENT desc

select * from TBS010 with (nolock) where PROCOD='1370188'

select * from TBS015 with (nolock) where PDPCOF + PDPPIS > 0 

select * from TBS015 with (nolock) where PDPPDD1 > 0 and PDPPDD2 > 0 and PDPPDD3 > 0

select PDPPREFOR
       * case 
            when PDPPDD1 > 0 then ((100 - PDPPDD1) / 100)
            else 1
         end
       * case 
            when PDPPDD2 > 0 then ((100 - PDPPDD2) / 100)
            else 1
         end
       * case 
            when PDPPDD3 > 0 then ((100 - PDPPDD3) / 100)
            else 1
         end
       * case 
            when PDPPDD4 > 0 then ((100 - PDPPDD4) / 100)
            else 1
         end
       * case 
            when PDPPDD5 > 0 then ((100 - PDPPDD5) / 100)
            else 1
         end
       ,*
  from TBS015 with (nolock)
 where PDPCOD='0060055'


select dbo.PDPCUSBAS(0,'0060055')

select PDPPREUNI
       * case
            when PDPPDD1 > 0 then (100-PDPPDD1)/100
            else 1
         end
       * case
            when PDPPDD2 > 0 then (100-PDPPDD2)/100
            else 1
         end
       * case
            when PDPPDD3 > 0 then (100 - PDPPDD3)/100
            else 1
         end
       * case
            when PDPPDD4 > 0 then (100-PDPPDD4)/100
            else 1
         end
       * case
            when PDPPDD5 > 0 then (100-PDPPDD5)/100
            else 1
         end
       * case
            when PDPIPI > 0 then 1+PDPIPI/100
            else 1
         end
       --* case
       --     when PDPDIFICM > 0 then 1+PDPDIFICM/100
       --     else 1
       --  end
       --* case
       --     when PDPPIS > 0 then 1+PDPPIS/100
       --     else 1
       --  end
       --* case
       --     when PDPCOF > 0 then 1+PDPCOF/100
       --     else 1
       --  end
       * case
            when PDPFRE > 0 then 1+PDPFRE/100
            else 1
         end
       --* case
       --     when PDPCUSADM > 0 then 1+PDPCUSADM/100
       --     else 1
       --  end
       --* case
       --     when PDPCMS > 0 then 1+PDPCMS/100
       --     else 1
       --  end
       * case
            when PDPPORST > 0 then 1+PDPPORST/100
            else 1
         end
  from TBS015 (nolock)
 where PDPCOD='0050031'

drop function CUSTOPOLITICA
go

create function CUSTOPOLITICA(@empresa smallint ,@produto varchar(15)) returns decimal(11,6) as
   begin
      declare @retorno decimal(11,6)
      set @retorno = (select PDPPREUNI
                             * case
                                  when PDPPDD1 > 0 then (100-PDPPDD1)/100
                                  else 1
                               end
                             * case
                                  when PDPPDD2 > 0 then (100-PDPPDD2)/100
                                  else 1
                               end
                             * case
                                  when PDPPDD3 > 0 then (100 - PDPPDD3)/100
                                  else 1
                               end
                             * case
                                  when PDPPDD4 > 0 then (100-PDPPDD4)/100
                                  else 1
                               end
                             * case
                                  when PDPPDD5 > 0 then (100-PDPPDD5)/100
                                  else 1
                               end
                             * case
                                  when PDPIPI > 0 then 1+PDPIPI/100
                                  else 1
                               end
                             * case
                                  when PDPFRE > 0 then 1+PDPFRE/100
                                  else 1
                               end
                             * case
                                  when PDPPORST > 0 then 1+PDPPORST/100
                                  else 1
                               end
                        from TBS015 (nolock)
                       where PDPEMPCOD=@empresa
                             and PDPCOD=@produto
                     )
      return @retorno
   end
go


select dbo.CUSTOPOLITICA(0,'0050031')