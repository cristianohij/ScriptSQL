select PROCOD
       ,PRODES
	   ,PROCLAFIS
	   ,PROCEST
  from TBS010 with (nolock)
 where PROCEST != ''

select PROCOD
       ,PRODES
	   ,PROCLAFIS
	   ,PROCEST
  from TBS010 with (nolock)
 where PROCEST != ''
       and Len(PROCEST) != 7

select PROCOD
       ,PRODES
	   ,PROCLAFIS
	   ,PROCEST
  from TBS010 with (nolock)
 where PROCEST != ''
       and PROCLAFIS = ''

select PROCLAFIS
	   ,PROCEST
	   ,count(*)
  from TBS010 with (nolock)
 where PROCEST != ''
 group by PROCLAFIS
          ,PROCEST
 order by PROCLAFIS

select *
  from TBS123 with (nolock)

SELECT modify_date
FROM sys.objects
WHERE type = 'U' -- 'U' indica que é uma tabela de usuário
AND name = 'TBS123'; -- Substitua 'NomeDaTabela' pelo nome da sua tabela

if object_id('tempdb..#cest_nf_entrada') is not null
   begin
      drop table #cest_nf_entrada
   end

select PROCOD
       ,NFECESTXML
       --,(select )
  into #cest_nf_entrada
  from TBS0591 i with (nolock)
 inner join TBS059 c with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where i.NFECESTXML != ''
 group by i.PROCOD
          ,i.NFECESTXML
 order by i.PROCOD,
c.NFEDATEFE

-- empresas do grupo cadastradas como fornecedores

if object_id('tempdb.dbo.#fornecedoresGrupo') is not null
    begin
    	drop table #fornecedoresGrupo
    end

create table #fornecedoresGrupo (codigo int)

insert into #fornecedoresGrupo
exec sp_ClientesGrupo

select *
  from #fornecedoresGrupo with (nolock)

if object_id('tempdb.dbo.#fornecedoresGrupo') is not null
    begin
    	drop table #fornecedoresGrupo
    end

-- CEST das notas fiscais de fornecedores

select c.NFETIP
       ,c.SERCOD
       ,c.NFECOD
       ,c.NFENUM
       ,c.NFEDATEFE
       ,i.PROCOD
       ,i.NFECESTXML
  into #procest
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE != '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
       and i.NFECESTXML != ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from TBS059 c1 with (nolock)
                            inner join TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE != '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFECESTXML != ''
                                  and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
                         )

select PROCOD
       ,count(*)
  from #cest_nf_entrada
 group by PROCOD
having count(*) > 1

select *
  from #cest_nf_entrada with (nolock)
 where PROCOD='3252051'

select PROUCPDAT
       ,PROUCPFOR
       ,PROUCPNFE
       ,PROUCPSER
       ,*
  from TBS010 with (nolock)
 where PROCOD='3252051'

select count(*)
  from TBS010 with (nolock)
 where PROCEST != ''

select *
  from #procest

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,c.NFECESTXML
  from TBS010 p with (nolock)
 inner join #procest c
    on c.PROCOD=p.PROCOD
 where p.PROCEST = ''
       and p.PROCLAFIS != ''
 order by p.PROCOD

select PROCOD
       ,PROCEST
  into TBS010_PROCEST_BKP
  from TBS010 with (nolock)
 where PROCEST != ''

update p
   set p.PROCEST = c.NFECESTXML
  from TBS010 p with (nolock)
 inner join #procest c 
    on c.PROCOD = p.PROCOD
 where p.PROCEST = ''
       and p.PROCLAFIS != ''

-- cadastros de produtos com CEST diferentes da última NF de entrada

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,c.NFECESTXML
  from TBS010 p with (nolock)
 inner join #procest c
    on c.PROCOD=p.PROCOD
 where p.PROCEST != c.NFECESTXML
 order by p.PROCOD

select PROCLAFIS
       ,PROCEST
  from TBS010 with (nolock)
 where PROCOD='1640054'

-- nova tabela cest

select *
  from TBS154 with (nolock)
 where CESTMVACOD not in (
   '1900100',
'1900200',
'1900300',
'1900400',
'1900500',
'1900501',
'1900600',
'1900700',
'1900800',
'1900900',
'1901000',
'1901100',
'1901200',
'1901300',
'1901400',
'1901500',
'1901600',
'1901700',
'1901800',
'1901900',
'1902000',
'1902100',
'1902200',
'1902300',
'1902400',
'1902500',
'1902600',
'1902700',
'1902800',
'1902900',
'1903000',
'1903100',
'1903200',
'1903300',
'1400100',
'1400200',
'1400300',
'1400400',
'1400500',
'1400600',
'1400601',
'1400700',
'1400800',
'1400900',
'1401000',
'1401100',
'1401200',
'1401300',
'0800100',
'0800200',
'0800300',
'0800400',
'0800500',
'0800600',
'0800700',
'0800800',
'0800900',
'0801000',
'0801100',
'0801200',
'0801300',
'0801400',
'0801500',
'0801600',
'0801700',
'0801800',
'0801900',
'0801901',
'0802000',
'0802100',
'0802200',
'0802300',
'1100100',
'1100200',
'1100300',
'1100400',
'1100500',
'1100600',
'1100700',
'1100800',
'1100900',
'1101000',
'1101100',
'1101200',
'0900100',
'0900200',
'0900300',
'0900400',
'0900500',
'1000100',
'1000200',
'1000300',
'1000400',
'1000500',
'1000600',
'1000700',
'1000800',
'1000900',
'1001000',
'1001100',
'1001200',
'1001300',
'1001400',
'1001500',
'1001600',
'1001700',
'1001800',
'1001900',
'1002000',
'1002100',
'1002200',
'1002400',
'1002500',
'1002600',
'1002700',
'1002800',
'1002900',
'1003000',
'1003001',
'1003100',
'1003200',
'1003300',
'1003400',
'1003500',
'1003600',
'1003700',
'1003800',
'1003900',
'1004000',
'1004100',
'1004101',
'1004200',
'1004300',
'1004400',
'1004500',
'1004501',
'1004600',
'1004700',
'1004800',
'1004900',
'1005000',
'1005100',
'1005200',
'1005300',
'1005400',
'1005500',
'1005600',
'1005700',
'1005800',
'1005900',
'1005901',
'1006000',
'1006100',
'1006200',
'1006300',
'1006400',
'1006500',
'1006600',
'1006700',
'1006800',
'1006900',
'1007000',
'1007100',
'1007200',
'1007300',
'1007400',
'1007500',
'1007600',
'1007700',
'1007800',
'1007900',
'1008000',
'1200100',
'1200200',
'1200300',
'1200400',
'1200500',
'1200600',
'1200700',
'1200800',
'1200900',
'2000100',
'2000101',
'2000200',
'2000300',
'2000400',
'2000500',
'2000600',
'2000700',
'2000800',
'2000900',
'2001000',
'2001100',
'2001200',
'2001300',
'2001400',
'2001500',
'2001600',
'2001700',
'2001800',
'2001900',
'2002000',
'2002100',
'2002200',
'2002300',
'2002400',
'2002500',
'2002600',
'2002700',
'2002701',
'2002800',
'2002900',
'2002901',
'2003000',
'2003100',
'2003200',
'2003201',
'2003300',
'2003400',
'2003401',
'2003500',
'2003600',
'2003700',
'2003800',
'2003900',
'2004000',
'2004100',
'2004200',
'2004300',
'2004400',
'2004500',
'2004600',
'2004700',
'2004800',
'2004801',
'2004900',
'2005000',
'2005100',
'2005200',
'2005300',
'2005400',
'2005500',
'2005600',
'2005700',
'2005800',
'2005900',
'2006000',
'2006100',
'2006200',
'2006300',
'2006400',
'2006500',
'2100100',
'2100200',
'2100300',
'2100400',
'2100500',
'2100600',
'2100700',
'2100800',
'2100900',
'2101000',
'2101100',
'2101200',
'2101300',
'2101400',
'2101500',
'2101600',
'2101700',
'2101800',
'2101900',
'2102000',
'2102100',
'2102200',
'2102300',
'2102400',
'2102500',
'2102600',
'2102700',
'2102800',
'2102900',
'2103000',
'2103100',
'2103200',
'2103300',
'2103400',
'2103500',
'2103600',
'2103700',
'2103800',
'2103900',
'2104000',
'2104100',
'2104200',
'2104300',
'2104400',
'2104500',
'2104600',
'2104700',
'2104800',
'2104900',
'2105000',
'2105100',
'2105200',
'2105300',
'2105301',
'2105400',
'2105500',
'2105501',
'2105600',
'2105601',
'2105700',
'2105800',
'2105900',
'2106000',
'2106100',
'2106200',
'2106300',
'2106400',
'2106500',
'2106600',
'2106700',
'2106701',
'2106800',
'2106900',
'2107000',
'2107100',
'2107200',
'2107300',
'2107400',
'2107500',
'2107600',
'2107700',
'2107800',
'2107900',
'2108000',
'2108100',
'2108200',
'2108300',
'2108400',
'2108500',
'2108600',
'2108700',
'2108800',
'2108801',
'2108900',
'2109000',
'2109100',
'2109200',
'2109300',
'2109400',
'2109500',
'2109600',
'2109700',
'2109800',
'2109801',
'2109900',
'2110000',
'2110100',
'2110200',
'2110300',
'2110400',
'2110500',
'2110600',
'2110700',
'2110800',
'2110900',
'2111000',
'2111100',
'2111200',
'2111300',
'2111400',
'2111500',
'2111600',
'2111700',
'2111800',
'2111900',
'2112000',
'2112100',
'2112200',
'2112300',
'2112400',
'2112500',
'2112600',
'2112700',
'2400100',
'2400200',
'2400201',
'2400300',
'1700100',
'1700101',
'1700102',
'1700103',
'1700200',
'1700201',
'1700202',
'1700203',
'1700300',
'1700301',
'1700400',
'1700401',
'1700500',
'1700501',
'1700600',
'1700601',
'1700602',
'1700700',
'1700800',
'1700900',
'1701000',
'1701100',
'1701200',
'1701300',
'1701400',
'1701500',
'1701600',
'1701601',
'1701700',
'1701701',
'1701800',
'1701801',
'1701900',
'1701901',
'1701902',
'1701903',
'1702000',
'1702001',
'1702100',
'1702101',
'1702200',
'1702300',
'1702301',
'1702400',
'1702401',
'1702402',
'1702403',
'1702404',
'1702405',
'1702500',
'1702501',
'1702502',
'1702600',
'1702700',
'1702701',
'1702702',
'1702800',
'1702801',
'1702900',
'1703000',
'1703100',
'1703101',
'1703102',
'1703200',
'1703300',
'1703301',
'1703400',
'1703500',
'1703600',
'1703700',
'1703800',
'1703900',
'1704000',
'1704100',
'1704200',
'1704300',
'1704400',
'1704401',
'1704402',
'1704403',
'1704404',
'1704405',
'1704406',
'1704407',
'1704408',
'1704409',
'1704410',
'1704411',
'1704412',
'1704413',
'1704414',
'1704415',
'1704416',
'1704417',
'1704418',
'1704419',
'1704420',
'1704421',
'1704422',
'1704423',
'1704424',
'1704425',
'1704426',
'1704427',
'1704500',
'1704600',
'1704601',
'1704602',
'1704603',
'1704604',
'1704605',
'1704606',
'1704607',
'1704608',
'1704609',
'1704610',
'1704611',
'1704612',
'1704613',
'1704614',
'1704615',
'1704616',
'1704700',
'1704701',
'1704800',
'1704801',
'1704802',
'1704900',
'1704901',
'1704902',
'1704903',
'1704904',
'1704905',
'1704906',
'1704907',
'1705000',
'1705100',
'1705200',
'1705300',
'1705301',
'1705302',
'1705400',
'1705401',
'1705402',
'1705600',
'1705601',
'1705602',
'1705700',
'1705800',
'1705900',
'1706000',
'1706200',
'1706201',
'1706202',
'1706203',
'1706300',
'1706400',
'1706500',
'1706600',
'1706700',
'1706701',
'1706702',
'1706800',
'1706900',
'1706901',
'1707000',
'1707100',
'1707200',
'1707300',
'1707400',
'1707500',
'1707600',
'1707700',
'1707701',
'1707800',
'1707900',
'1707901',
'1707902',
'1707903',
'1707904',
'1707905',
'1707906',
'1707907',
'1707908',
'1708000',
'1708001',
'1708100',
'1708200',
'1708300',
'1708301',
'1708400',
'1708500',
'1708600',
'1708700',
'1708701',
'1708702',
'1708800',
'1708801',
'1708900',
'1708901',
'1709000',
'1709001',
'1709100',
'1709101',
'1709200',
'1709201',
'1709300',
'1709301',
'1709400',
'1709401',
'1709500',
'1709501',
'1709600',
'1709601',
'1709602',
'1709603',
'1709604',
'1709605',
'1709700',
'1709800',
'1709900',
'1709901',
'1709902',
'1710000',
'1710001',
'1710002',
'1710100',
'1710101',
'1710102',
'1710200',
'1710201',
'1710202',
'1710300',
'1710301',
'1710302',
'1710400',
'1710401',
'1710402',
'1710500',
'1710501',
'1710502',
'1710600',
'1710700',
'1710701',
'1710800',
'1710801',
'1710900',
'1711000',
'1711100',
'1711200',
'1711300',
'1711400',
'1711500',
'1711600',
'1711700',
'0100100',
'0100200',
'0100300',
'0100400',
'0100500',
'0100600',
'0100700',
'0100800',
'0100900',
'0101000',
'0101100',
'0101200',
'0101300',
'0101400',
'0101500',
'0101600',
'0101700',
'0101800',
'0101900',
'0102000',
'0102100',
'0102200',
'0102300',
'0102400',
'0102500',
'0102600',
'0102700',
'0102800',
'0102900',
'0103000',
'0103100',
'0103200',
'0103300',
'0103400',
'0103500',
'0103600',
'0103700',
'0103800',
'0103900',
'0104000',
'0104100',
'0104200',
'0104300',
'0104400',
'0104500',
'0104501',
'0104600',
'0104700',
'0104800',
'0104900',
'0105000',
'0105100',
'0105200',
'0105300',
'0105301',
'0105400',
'0105500',
'0105600',
'0105700',
'0105800',
'0105900',
'0106000',
'0106100',
'0106200',
'0106201',
'0106300',
'0106400',
'0106500',
'0106600',
'0106700',
'0106800',
'0106900',
'0107000',
'0107100',
'0107200',
'0107300',
'0107400',
'0107500',
'0107600',
'0107700',
'0107800',
'0107900',
'0108000',
'0108100',
'0108200',
'0108300',
'0108400',
'0108500',
'0108600',
'0108700',
'0108800',
'0108900',
'0109000',
'0109100',
'0109200',
'0109300',
'0109400',
'0109500',
'0109600',
'0109700',
'0109800',
'0109900',
'0110000',
'0110100',
'0110200',
'0110300',
'0110400',
'0110500',
'0110600',
'0110700',
'0110800',
'0110900',
'0111100',
'0111200',
'0111300',
'0111400',
'0111500',
'0111600',
'0111700',
'0111800',
'0111900',
'0112000',
'0112100',
'0112200',
'0112300',
'0112400',
'0112500',
'0112600',
'0112700',
'0112800',
'0199900',
'0200100',
'0200200',
'0200300',
'0200400',
'0200500',
'0200600',
'0200700',
'0200800',
'0200900',
'0201000',
'0201100',
'0201200',
'0201300',
'0201400',
'0201500',
'0201600',
'0201700',
'0201800',
'0201900',
'0202000',
'0202100',
'0202200',
'0202300',
'0202400',
'0299900',
'0300300',
'0300301',
'0300301',
'0300500',
'0300501',
'0300501',
'0300502',
'0300503',
'0300504',
'0300504',
'0300505',
'0300505',
'0300600',
'0300700',
'0300800',
'0300800',
'0301000',
'0301001',
'0301001',
'0301002',
'0301002',
'0301100',
'0301100',
'0301101',
'0301200',
'0301201',
'0301300',
'0301300',
'0301300',
'0301301',
'0301301',
'0301302',
'0301500',
'0301500',
'0302100',
'0302100',
'0302101',
'0302102',
'0302103',
'0302104',
'0302105',
'0302106',
'0302200',
'0302201',
'0302202',
'0302203',
'0302204',
'0302205',
'0302206',
'0302300',
'0302400',
'0302500',
'2300100',
'2300200',
'1300100',
'1300101',
'1300102',
'1300200',
'1300201',
'1300202',
'1300300',
'1300301',
'1300302',
'1300400',
'1300401',
'1300402',
'1300500',
'1300501',
'1300502',
'1300503',
'1300504',
'1300505',
'1300600',
'1300700',
'1300701',
'1300800',
'1300801',
'1300900',
'1300901',
'1301000',
'1301001',
'1301100',
'1301200',
'1301300',
'1301400',
'1301500',
'1301600',
'2800100',
'2800200',
'2800300',
'2800400',
'2800500',
'2800600',
'2800700',
'2800800',
'2800900',
'2801000',
'2801100',
'2801200',
'2801300',
'2801400',
'2801500',
'2801600',
'2801601',
'2801602',
'2801700',
'2801701',
'2801702',
'2801800',
'2801900',
'2802000',
'2802001',
'2802100',
'2802200',
'2802300',
'2802400',
'2802401',
'2802500',
'2802501',
'2802502',
'2802600',
'2802700',
'2802701',
'2802800',
'2802801',
'2802900',
'2803000',
'2803100',
'2803200',
'2803300',
'2803400',
'2803500',
'2803600',
'2803700',
'2803800',
'2803900',
'2804000',
'2804100',
'2804200',
'2804300',
'2804400',
'2804500',
'2804600',
'2804700',
'2804800',
'2804900',
'2805000',
'2805100',
'2805200',
'2805300',
'2805400',
'2805500',
'2805600',
'2805700',
'2805800',
'2805900',
'2806000',
'2806100',
'2806200',
'2806300',
'2806400',
'2899900'
 )

select *
  from TBS154 with (nolock)
 where CESTMVACOD = '2802502'

select *
  from TBS1541 with (nolock)
 where CESTMVANCM = '82141000'

-- NCM das notas fiscais de fornecedores

select c.NFETIP
       ,c.SERCOD
       ,c.NFECOD
       ,c.NFENUM
       ,c.NFEDATEFE
       ,i.PROCOD
       ,i.NFENCMXML
  into #proncm
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE != '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
       and i.NFENCMXML != ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from TBS059 c1 with (nolock)
                            inner join TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE != '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML != ''
                                  and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
                         )

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
  from TBS010 p with (nolock)
 inner join #proncm n
    on n.PROCOD=p.PROCOD
 where (p.PROCLAFIS = ''
       or Len(p.PROCLAFIS) < 8)
       and Len(n.NFENCMXML) = 8
 order by p.PROCOD

begin tran
update p
   set p.PROCLAFIS = n.NFENCMXML
  from TBS010 p with (nolock)
 inner join #proncm n
    on n.PROCOD = p.PROCOD
 where (p.PROCLAFIS = ''
       or Len(p.PROCLAFIS) < 8)
       and Len(n.NFENCMXML) = 8

rollback tran
commit tran


select NFENCMXML
       ,NFECESTXML
       ,*
  from TBS0591 with (nolock)
 where NFENUM=53813
       and NFECOD=2895
 order by NFEITE

select *
  from TBS1541 with (nolock)
 where CESTMVANCM Like ('9017%')
 order by CESTMVANCM

select --VNFTRIBST, *
VNFFORCNPJ,     VNFPROFOR ,VNFNCMORI,  VNFCESTORI,  VNFCSTCSOSNORI,  VNFICMSPROORI,  VNFICMSSTORI,  VNFMVAORI,  VNFREDICMSORI,  VNFREDICMSSTORI,  VNFIPIORI,  VNFCFOP,   VNFTRIBST
  from TBS0105 with (nolock)
 where VNFPROEMP=0
       and VNFFORCNPJ='08228010000433'
       and VNFPROFOR='22558' --in ('22558','17571') 

update TBS0105
   set VNFCSTCSOSNORI='400'
 where VNFPROEMP=0
       and VNFFORCNPJ='08228010000433'
       and VNFPROFOR='22558'

update TBS0105
   set VNFCFOP='6102'
 where VNFPROEMP=0
       and VNFFORCNPJ='08228010000433'
       and VNFPROFOR='22558'

update TBS0105
   set VNFICMSPROORI=12
 where VNFPROEMP=0
       and VNFFORCNPJ='08228010000433'
       and VNFPROFOR='22558'

select *
  from TBS1541 with (nolock)
 where Len(CESTMVANCM) = 3

select *
  from TBS154 with (nolock)
 where CESTMVACOD='2802502'

update TBS0105
   set VNFTRIBST=c.CESTOPEINT
  from TBS0105 v with (nolock)
 inner join TBS154 c with (nolock)
    on v.VNFCESTALT=c.CESTMVACOD

select *
  from TBS154 with (nolock)
 where CESTMVADES Like ('%MADEIRA%')

select *
  from TBS1542 with (nolock)
 where CESTNCMDES Like ('%MOBILE%')

select *
  from TBS092 with (nolock)
 where  NCMCOD Like('4420%')

-- tabela CEST integros

select *
  from TBS123 with (nolock)
 where CESTNCM  Like ('8443%')

select *
  from TBS154 c with (nolock)
 inner join TBS1541 d with (nolock)
    on c.CESTMVACOD=d.CESTMVACOD 

select PROCLAFIS
       ,PROCEST
  from TBS010 with (nolock)
 where PROCOD='1640054'

exec sp_help 'TBS1542'

SELECT 
    T1.CESTMVANCM,
    T1.CESTMVACOD,
    COALESCE(T3.CESTNCMDES, T2.CESTMVADES) AS DESCRICAO,
    T2.CESTOPEINT,
    T2.CESTICMSINT,
    T2.CESTMVAPOR
FROM TBS1541 T1 WITH (NOLOCK)
LEFT JOIN TBS154 T2 WITH (NOLOCK) ON T1.CESTMVACOD = T2.CESTMVACOD
LEFT JOIN TBS1542 T3 WITH (NOLOCK) ON T1.CESTMVACOD = T3.CESTMVACOD
WHERE T1.CESTMVANCM LIKE '4802%'

select *
  from TBS154 with (nolock)

select *
  from TBS0591 with (nolock)
 where NFENUM=165854
       and NFECOD=2821
       and SERCOD <> 'CAN'
 order by NFEITE

-- PPB redução de 33,33% da base do ICMS

select *
  from TBS0105 with (nolock)
 where VNFPROEMP=0
       and VNFFORCNPJ='08228010000433'
       and Left(VNFCSTCSOSNORI,1)='4'

select c.NFEESTORI
       ,d.*
  from TBS0591 d with (nolock)
 inner join TBS059 c with (nolock)
    on c.NFETIP=d.NFETIP and c.NFENUM=d.NFENUM and c.NFECOD=d.NFECOD and c.SERCOD=d.SERCOD
 where c.NFEDATEFE >= '20230101'
       and c.NFECAN='N'
       and c.NFETIP='N'
       and d.NFEREDBASICMS > 0
 order by c.NFEDATEFE desc

select *
  from TBS154 with (nolock)
 where CESTMVACOD='2802502'

select *
--VNFFORCNPJ,     VNFPROFOR ,VNFNCMORI,  VNFCESTORI,  VNFCSTCSOSNORI,  VNFICMSPROORI,  VNFICMSSTORI,  VNFMVAORI,  VNFREDICMSORI,  VNFREDICMSSTORI,  VNFIPIORI,  VNFCFOP,   VNFTRIBST, *
  from TBS0105 with (nolock)
 where VNFPROEMP=0
       and VNFFORCNPJ='07933371000175'
       --and VNFPROFOR in ('AG0101','AP0205','AP0208','BA3850','BA7658','BA7676','CA0206','CA2201','CC3000','EE0001','ES0100','FL0001','FL0002','GP2000','GU0001','GZ0617','LP0001','LP1601','NB0001','NB1001','NB1002','OR5002','PP2012','PP2018','PP5015','RE0202','TE1321')
       and VNFPROFOR='CA5011'

-- dados da nf

select 
VNFNCMORI
,VNFCESTORI
,VNFCSTCSOSNORI
,VNFICMSPROORI
,VNFICMSSTORI
,VNFMVAORI
,VNFREDICMSORI
,VNFREDICMSSTORI
,VNFIPIORI
  from TBS0105 with (nolock)
 where VNFPROEMP=0
       and VNFFORCNPJ='07933371000175'
       and VNFNUMDOC=194222

-- dados alterados

select
VNFPROFOR
,VNFNCMALT
,VNFCESTALT
,VNFCSTCSOSNALT
,VNFICMSPROALT
,VNFICMSINTALT
,VNFICMSSTALT
,VNFMVAORIALT
,VNFMVAOPEALT
,VNFREDICMSALT
,VNFREDICMSSTALT
,VNFIPIALT
,VNFTRIBST
,*
  from TBS0105 with (nolock)
 where VNFPROEMP=0
       and VNFFORCNPJ='07933371000175'
       and VNFNUMDOC=194222

-- mva ajustado

begin tran
update TBS0105
   set VNFMVAOPEALT=VNFMVAORI
 where VNFMVAORI > 0
       and VNFMVAOPEALT = 0

rollback tran
commit tran

-- alíquota icms-st

begin tran
update TBS0105
   set VNFICMSSTALT=VNFICMSSTORI
 where VNFICMSSTALT=0
       and VNFICMSSTORI > 0

rollback tran
commit tran

-- alítuota MVA do CEST

select top(100)
       *
  from TBS0105 with (nolock)

select top(100)
       *
  from TBS154 with (nolock)
 where CESTOPEINT='S'

begin tran
update TBS0105
   set VNFMVAORIALT=CESTMVAPOR
  from TBS0105 pro with (nolock)
 inner join TBS154 cest with (nolock)
    on pro.VNFCESTALT=cest.CESTMVACOD

rollback tran
commit tran

-- cálculo da MVA ajustada

-- ICMS interno

update TBS0105
   set VNFICMSINTALT=18
 where VNFICMSINTALT=0

begin tran
update TBS0105
   set VNFMVAOPEALT=dbo.fn_CalcularMVA_Ajustado(VNFMVAORIALT, VNFICMSPROALT, VNFICMSINTALT)

rollback tran
commit tran

-- redução da base de cálculo do ICMS

select *
  from TBS0105 with (nolock)
 where VNFREDICMSORI > 0
       and VNFREDICMSALT = 0

-- redução da base de cálculo do ICMS-ST

select *
  from TBS0105 with (nolock)
 where VNFREDICMSSTORI > 0
       and VNFREDICMSSTALT = 0

select *
  from TBS0105 with (nolock)
 where VNFNCMALT='82141000'

select *
  from TBS0105 with (nolock)
 where VNFTRIBST='S'

-- primeiro

begin tran
update TBS0105
   set VNFTRIBST='S'
 where VNFMVAORIALT > 0
       and VNFTRIBST is null

rollback tran
commit tran

-- segundo

begin tran
update TBS0105
   set VNFTRIBST='N'
 where VNFTRIBST is null

rollback tran
commit tran

select VNFFORCNPJ, VNFPROFOR ,VNFNCMORI,  VNFCESTORI,  VNFCSTCSOSNORI,  VNFICMSPROORI,  VNFICMSSTORI,  VNFMVAORI,  VNFREDICMSORI,  VNFREDICMSSTORI,  VNFIPIORI,  VNFCFOP,   VNFTRIBST
      ,*
  from TBS0105 with (nolock)
 where VNFPROEMP=0
       and VNFFORCNPJ='07933371000175'
       and VNFPROFOR='AP0204'

drop table #ap0204

select VNFSEQ
       ,VNFPROEMP
       ,VNFFORCNPJ
       ,VNFPROFOR
       ,VNFNUMDOC
       ,VNFSERDOC
       ,VNFNCMORI
       ,VNFCESTORI
       ,VNFCSTCSOSNORI
       ,VNFICMSPROORI
       ,VNFICMSSTORI
       ,VNFMVAORI
       ,VNFREDICMSORI
       ,VNFREDICMSSTORI
       ,VNFIPIORI
       ,VNFPRODES
       ,VNFCFOP
       ,VNFICMSINTALT
       ,VNFICMSSTALT
       ,VNFMVAORIALT
       ,VNFMVAOPEALT
       ,VNFNCMALT
       ,VNFCESTALT
       ,VNFREDICMSSTALT
	    ,VNFTRIBST
  --into #ap0208
  from TBS0105 with (nolock)
 where VNFPROEMP=0
       and VNFFORCNPJ='07933371000175'
       and VNFPROFOR = 'RE0202' --in ('AP0204','AP0205','AP0208')

begin tran
delete TBS0105
 where VNFPROFOR = 'RE0202'

rollback tran
commit tran

select *
  from #ap0208

update TBS0105
   set VNFCFOP='6102'
 where VNFPROEMP=0
       and VNFFORCNPJ='07933371000175'
       and VNFPROFOR in ('AP0204','AP0205')

begin tran
delete TBS0105
 where VNFFORCNPJ='07933371000175'
       and VNFPROFOR='AP0208'

rollback tran
commit tran

begin tran
delete TBS0105
 where VNFFORCNPJ='07933371000175' 
 and VNFPROFOR in ('AP0204',
'AP0205',
'AP0208',
'AP2001',
'BA3850',
'BA3851',
'BA3890',
'BC0003',
'CA0032',
'CA0200',
'CA0217',
'CA0222',
'CA0702',
'CA2048',
'CA2201',
'CA2202',
'CA2203',
'CA2204',
'CA5011',
'CA5013',
'CA8002',
'CC1000',
'CC1002',
'CC1003',
'FL0002',
'GP0107',
'GP2000',
'LP0014',
'LP0100',
'LP0108',
'LP0704',
'LP0712',
'LP0912',
'LP1701',
'LP1702',
'LP1706',
'LP1713',
'LP2024',
'LP2044',
'LP3000',
'LP7204',
'LP7205',
'NB0001',
'NB0002',
'NB1000',
'NB1001',
'OR5003',
'PP2012',
'PP2015',
'PP5018',
'PP5118',
'RE0202',
'TE1701',
'TE1702'
)

rollback tran
commit tran

select *
  from TBS0105 with (nolock)
 where VNFPROFOR=''

select *
  from TBS001 with (nolock)
 where UFESIG='SP'

select FORCGC
       ,count(*)
  from TBS006 with (nolock)
 group by FORCGC having count(*) > 1

select *
  from TBS156 with (nolock)

ALTER TABLE [TBS156]
ADD [FOREMPCOD] SMALLINT     NOT NULL CONSTRAINT FOREMPCODTBS156_DEFAULT DEFAULT Convert(INT,0),
    [VICHORGUIA] CHAR(8)     NULL,
    [VICDATGUIA] DATETIME     NULL,
    [VICVALGUIA] MONEY     NULL,
    [VICVALNFE] DECIMAL(10)     NULL,
    [FORCOD] INT     NOT NULL CONSTRAINT FORCODTBS156_DEFAULT DEFAULT Convert(INT,0),
    [VICHOREMI] CHAR(8)     NULL,
    [VICDATEMI] DATETIME     NULL,
    [VICSERNF] SMALLINT     NULL,
    [VICNUMNF] DECIMAL(10)     NULL

 
 

ALTER TABLE [TBS156]
DROP CONSTRAINT FOREMPCODTBS156_DEFAULT

 
 

ALTER TABLE [TBS156]
DROP CONSTRAINT FORCODTBS156_DEFAULT

 
 

INSERT INTO [TBS006]
           ([FOREMPCOD],
            [FORCOD],
            [FORNOM],
            [FORNOMFAN],
            [FOREND],
            [FORBAI],
            [FORCEP],
            [FORCID],
            [UFESIG],
            [FORCGC],
            [FORCPF],
            [FORIES],
            [FORIMU],
            [FORTEL],
            [FORCEL],
            [FORFAX],
            [FOREMAIL],
            [FORURL],
            [FORCONTAT],
            [FORDATCAD],
            [FORLIC],
            [FORLICVEN],
            [FORPRICOM],
            [FORPCPVAL],
            [FORPCPNFE],
            [FORMCPDAT],
            [FORMCPVAL],
            [FORMCPNFE],
            [FORUCPDAT],
            [FORUCPVAL],
            [FORUCPNFE],
            [FORPEDLIB],
            [FORPEDBLQ],
            [FORTITABT],
            [FORTIPPES],
            [CPGCOD],
            [CPGEMPCOD],
            [FORIPI],
            [FORDIFICM],
            [FORPIS],
            [FORCOF],
            [FORFRE],
            [FORCUSADM],
            [FORMKPCOR1],
            [FORMKPCOR2],
            [FORMKPLOJ1],
            [FORMKPLOJ2],
            [FORMKPREV1],
            [FORMKPREV2],
            [FORMKPWE11],
            [FORMKPWE12],
            [FORMKPWE21],
            [FORMKPWE22],
            [FORREDCOR1],
            [FORREDCOR2],
            [FORREDCOR3],
            [FORREDCOR4],
            [FORREDLOJ1],
            [FORREDLOJ2],
            [FORREDLOJ3],
            [FORREDLOJ4],
            [FORREDREV1],
            [FORREDREV2],
            [FORREDREV3],
            [FORREDREV4],
            [FORREDWE11],
            [FORREDWE12],
            [FORREDWE13],
            [FORREDWE14],
            [FORREDWE21],
            [FORREDWE22],
            [FORREDWE23],
            [FORREDWE24],
            [FORCMS],
            [FORPDD1],
            [FORPDD2],
            [FORPDD3],
            [FORPDD4],
            [FORPDD5],
            [FORDATFUN],
            [FOROBS],
            [TRNCOD],
            [TRNEMPCOD],
            [FORSINHAB],
            [FORRECATI],
            [FORCONRES],
            [MUNCOD],
            [FORNUM],
            [FORENDTMP],
            [FORTEMREP],
            [FORSIT],
            [FORFATSEG],
            [FORUSUALT],
            [FORREGTRI],
            [FORFIL],
            [FORUTICODINT],
            [FORPORST],
            [FORPOREMP],
            [FORPORCOD],
            [FORDEHCONSIN],
            [FORCRENFE],
            [FORINIATI],
            [FORDATMODSIN],
            [FORDATBAISIN],
            [FORHABSIN],
            [FORCNAE],
            [FORVALMIN],
            [FORTIPVALMIN],
            [FORINDIE],
            [FORCPLEND],
            [FORHORCAD],
            [FORUSUCAD],
            [FORDATALT],
            [FORHORALT],
            [FOREMAILNFE],
            [FOREMAILFIN],
            [FORID])
SELECT TOP 1 Convert(INT,0),
             Convert(INT,0),
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             ' ',
             '',
             '',
             '',
             '',
             Convert(DATETIME,'17530101',112),
             Convert(INT,0),
             Convert(DATETIME,'17530101',112),
             Convert(DATETIME,'17530101',112),
             Convert(INT,0),
             Convert(INT,0),
             Convert(DATETIME,'17530101',112),
             Convert(INT,0),
             Convert(INT,0),
             Convert(DATETIME,'17530101',112),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             '',
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(DATETIME,'17530101',112),
             '',
             Convert(INT,0),
             Convert(INT,0),
             '',
             '',
             Convert(DATETIME,'17530101',112),
             Convert(INT,0),
             '',
             '',
             Convert(INT,0),
             '',
             Convert(INT,0),
             '',
             Convert(INT,0),
             '',
             '',
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             Convert(DATETIME,'17530101',112),
             Convert(INT,0),
             Convert(DATETIME,'17530101',112),
             Convert(DATETIME,'17530101',112),
             Convert(DATETIME,'17530101',112),
             Convert(INT,0),
             Convert(INT,0),
             Convert(INT,0),
             '',
             Convert(INT,0),
             '',
             '',
             '',
             Convert(DATETIME,'17530101',112),
             '',
             '',
             '',
             Convert(INT,0)
FROM   [TBS156]
WHERE  NOT EXISTS (SELECT 1
                   FROM   [TBS006]
                   WHERE  FOREMPCOD = Convert(INT,0)
                          AND FORCOD = Convert(INT,0))

 
 

CREATE NONCLUSTERED INDEX [ITBS157] ON [TBS156] (
      [FOREMPCOD],
      [FORCOD])

 
 

ALTER TABLE [TBS156]
DROP COLUMN [VICTRIBST] , [VICREDBCICMSST] , [VICREDBCICMS] , [VICVALIPI] , [VICBCIPI] , [VICVALICMSST] , [VICBCICMSST] , [VICVALICMS] , [VICBCICMS] , [VICTOTITE] , [VICVALOUT] , [VICVALDES] , [VICVALSEG] , [VICVALFRE] , [VICVALPRO] , [VICCALICMSST] , [VICCALICMS] , [VICCALMVA] , [VICCALCEST] , [VICCALNCM]

ALTER TABLE TBS156
DROP CONSTRAINT DF_TBS156_VICCALNCM;

select *
  from TBS157 with (nolock)
 



-- códigos dos fornecedores do grupo

if object_id('tempdb.dbo.#grupo') is not null
    begin
    	drop table #grupo
    end

create table #grupo (codigo int)

insert into #grupo
exec usp_FornecedoresGrupo 1

select *
  from #grupo


-- NCM do produto conforme nota fiscal do forncedor

if object_id('tempdb.dbo.#ncm_cest_entrada') is not null
    begin
    	drop table #ncm_cest_entrada
    end

select c.NFETIP
       ,c.SERCOD
       ,c.NFECOD
       ,c.NFENUM
       ,c.NFEDATEFE
       ,i.PROCOD
       ,i.NFENCMXML
       ,i.NFECESTXML
  into #ncm_cest_entrada
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE != '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #grupo with (nolock))
       and i.NFENCMXML != ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from TBS059 c1 with (nolock)
                            inner join TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE != '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFENCMXML != ''
                                  and c.NFECOD not in(select codigo from #grupo with (nolock))
                         )

select *
  from #ncm_cest_entrada

-- lista de produtos do cadastro, com NCM vazio ou de tamanho menor do que 8

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
  from TBS010 p with (nolock)
 inner join #proncm n
    on n.PROCOD=p.PROCOD
 where (p.PROCLAFIS = ''
       or Len(p.PROCLAFIS) < 8)
       and Len(n.NFENCMXML) = 8
 order by p.PROCOD

-- lista de produtos do cadastro, com NCM diferente do NCM recebido na nota fiscal de entrada

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,n.NFENCMXML
  from TBS010 p with (nolock)
 inner join #proncm n
    on n.PROCOD=p.PROCOD
 where p.PROCLAFIS <> ''
       and Len(p.PROCLAFIS) = 8
       and p.PROCLAFIS <> n.NFENCMXML
 order by p.PRODES


begin tran
update p
   set p.PROCLAFIS = n.NFENCMXML
  from TBS010 p with (nolock)
 inner join #proncm n
    on n.PROCOD = p.PROCOD
 where (p.PROCLAFIS = ''
       or Len(p.PROCLAFIS) < 8)
       and Len(n.NFENCMXML) = 8

rollback tran
commit tran