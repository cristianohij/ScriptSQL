-- lista arquivos do diretório

exec master..xp_cmdshell 'dir d:\temp\gz /s /o:n /b'

drop table #dir

create table #dir(arquivo varchar(300))

declare @diretorio as varchar(200)

-- /s inclui subdiretórios
--set @diretorio='dir C:\temp\gz\bb\1907\02\can /s /o:n /b'
--set @diretorio='dir d:\temp\gz\bb\1912\06 /s /o:n /b'
--set @diretorio='dir D:\Documents\GRM\xml\sat\tanby\taubate\2020\04-abr /s /o:n /b'
--set @diretorio='dir c:\temp\sat\08-ago\pdv-1 /s /o:n /b'

set @diretorio='dir D:\Documents\GRM\xml\sat\tanby\taubate\2022\05-mai\cancelados /s /o:n /b'
--set @diretorio='dir D:\Documents\GRM\xml\sat\best-bag\2021\10-out\todos /s /o:n /b'
--set @diretorio='dir D:\Documents\GRM\xml\sat\best-bag\2021\10-out\exp /s /o:n /b'

--set @diretorio='dir D:\Documents\GRM\xml\sat\tanby\matriz\2021\12-dez\pdv-6 /s /o:n /b'
--set @diretorio='dir D:\Documents\GRM\xml\sat\tanby\matriz\2021\12-dez\pdv-1 /s /o:n /b'

--set @diretorio='dir D:\Documents\GRM\xml\sat\best-arts\2022\05-mai\pdv-2 /s /o:n /b'

--set @diretorio='dir d:\temp\gz\nd\todos /s /o:n /b'

--set @diretorio='dir d:\temp\gz\nd\0001\006 /s /o:n /b'

--set @diretorio='dir d:\temp\gz\bb\11 /s /o:n /b'

--set @diretorio='dir D:\Documents\GRM\xml\sat\tanby\matriz\2020\11-nov\xml /s /o:n /b'
--set @diretorio='dir D:\Documents\GRM\xml\sat\tanby\matriz\2020\11-nov\caixa3 /s /o:n /b'
--set @diretorio='dir D:\Documents\GRM\xml\sat\best-bag\2020\11-nov\2020-11-best-bag /s /o:n /b'

--set @diretorio='dir D:\Documents\GRM\xml\sat\best-bag\2020\11-nov\recuperados\todos /s /o:n /b'

--set @diretorio='dir D:\Documents\GRM\xml\sat\best-bag\2020\11-nov\caixa6 /s /o:n /b'

insert into #dir exec master..xp_cmdshell @diretorio

select * from #dir

delete #dir where arquivo is null or arquivo='can'

drop table #arquivo

select arquivo,row_number() over(order by arquivo) as linha into #arquivo from #dir

select * from #arquivo order by linha

/*
SELECT
    X.ide.query('vCFe').value('.', 'float')
FROM
( 	
    SELECT CAST(X AS XML)
    FROM OPENROWSET(
        BULK 'C:\temp\gz\AD35190565069593000198590005243920142364375513.xml',
        SINGLE_BLOB) AS T(X)
) AS T(X)
CROSS APPLY X.nodes('CFe/infCFe/total') AS X(ide)

SELECT X.ide.query('total/vCFe').value('.', 'float'),X.ide.query('infAdic/infCpl').value('.', 'varchar(25)') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK 'c:\temp\gz\AD35190565069593000198590005243920142364375513.xml',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes('CFe/inf'

SELECT
    --X.ide.query('@chCanc').value('.', 'varchar(44)'),
    X.ide.query('total/vCFe').value('.', 'float'),
    X.ide.query('infAdic/infCpl').value('.', 'varchar(25)'),
    X.ide.query('ide/nCFe').value('.', 'varchar(25)')
FROM
( 	
    SELECT CAST(X AS XML)
    FROM OPENROWSET(
        BULK 'C:\temp\gz\bb\1907\02\AD35190705118717000156590005882450125037077944.xml',
        SINGLE_BLOB) AS T(X)
) AS T(X)
CROSS APPLY X.nodes('CFe/infCFe') AS X(ide)
*/

drop table #cupons
go

create table #cupons(valor numeric(10,2), doc varchar(25), extrato varchar(9), data date)
go

declare @n int, @linhas int, @arquivo varchar(300), @query varchar(5000)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas
   begin
      select @arquivo = arquivo
        from #arquivo
       where linha=@n


      --print @arquivo

      set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''), X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''), X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)''), X.ide.query(''ide/dEmi'').value(''.'', ''date'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFe/infCFe'') AS X(ide)'
      --set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'

      exec(@query)
--print @query

      set @n += 1
   end
go

drop table #cupons
go

--create table #cupons(valor nvarchar, doc varchar(25), extrato varchar(9), data date, cfop char(4))
create table #cupons(valor numeric(10,2), doc varchar(25), extrato varchar(9), data date, cfop char(4))
go

declare @n int, @linhas int, @arquivo varchar(300), @query varchar(5000)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas
   begin
      select @arquivo = arquivo
        from #arquivo
       where linha=@n


      --print @arquivo

      set @query = 'insert into #cupons SELECT X.ide.query(''det/prod/vProd'').value(''.'', ''float''), X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''), X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)''), X.ide.query(''ide/dEmi'').value(''.'', ''date''), X.ide.query(''det/prod/CFOP'').value(''.'', ''varchar(4)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFe/infCFe'') AS X(ide)'
      --set @query = 'insert into #cupons SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'

      exec(@query)
--print @query

      set @n += 1
   end

select *
  --into cuponsnd
  from #cupons

select extrato
       ,count(*)
  from cuponsnd
 group by extrato
having count(*) > 1

select extrato
       ,count(*)
  from #cupons
 group by extrato
 having count(*) > 1

select *
  from #cupons
 where valor=23.2
 
select convert(float,valor),*
  from #cupons
  
select sum(valor),count(*)
  from #cupons

--  cupons válidos
select sum(valor),count(*)
  from #cupons
 where doc Like('%001-001%')

select *
  from #cancelados
   
-- cupons cancelados
select sum(valor),count(*)
  from #cancelados
 where doc Like('%001-002%')
 
select data
       ,sum(valor)
	   ,count(*)
  from #cupons
 group by data
 order by data

select data
       ,sum(valor)
	   ,count(*)
  from #cupons
 where doc Like('%001-001%')
 group by data
 order by data

select cfop
       ,sum(valor)
  from #cupons
 where data='20200711'
 group by cfop
	   
select *
       ,right(doc,6)
  from #cupons


select extrato
       ,count(*)
  from #cupons
group by extrato
having count(*) > 1

-- cancelados

drop table #cancelados
go

create table #cancelados(valor numeric(10,2), doc varchar(25), extrato varchar(9))
go

declare @n int, @linhas int, @arquivo varchar(300), @query varchar(500)

select @n = 1, @linhas = (select count(*) from #dir)

while @n <= @linhas
   begin
      select @arquivo = arquivo
        from #arquivo
       where linha=@n

      set @query = 'insert into #cancelados SELECT X.ide.query(''total/vCFe'').value(''.'', ''float''),X.ide.query(''infAdic/infCpl'').value(''.'', ''varchar(25)''),X.ide.query(''ide/nCFe'').value(''.'', ''varchar(25)'') FROM (SELECT CAST(X AS XML) FROM OPENROWSET(BULK ''' + @arquivo + ''',SINGLE_BLOB) AS T(X)) AS T(X) CROSS APPLY X.nodes(''CFeCanc/infCFe'') AS X(ide)'
      exec(@query)

      set @n += 1
   end
go

select *
  from #cancelados

select sum(valor),count(*)
  from #cancelados


select *
       ,right(doc,6)
  from #cancelados


select *
       ,subString(doc,15,5)
  from #cupons
 where subString(doc,15,5) in(24111,
24112,
24113,
24114,
24115,
24116,
24117,
24118,
24119,
24120,
24121,
24122,
24123,
24124,
24125,
24126,
24127,
24128,
24129,
24130,
24131,
24132,
24137,
24138,
24139,
24140,
24141,
24142,
24143,
24144,
24145,
24146,
24147,
24148,
24149,
24150,
24151,
24152,
24153,
24154,
24155,
24156,
24157,
24162,
24163,
24164,
24165,
24166,
24167,
24168,
24169,
24170,
24170,
24171,
24172,
24173,
24174,
24175,
24176,
24177,
24178,
24179,
24180,
24181,
24186,
24187,
24188,
24189,
24190,
24191,
24192,
24193,
24194,
24196,
24197,
24198,
24199,
24200,
24201,
24202,
24203,
24204,
24205,
24210,
24211,
24212,
24213,
24214,
24215,
24216,
24217,
24218,
24219,
24220,
24221,
24222,
24223,
24224,
24225,
24226,
24227,
24228,
24229,
24230,
24231,
24232,
24233,
24234,
24235,
24236,
24237,
24238,
24239,
24240,
24241,
24242,
24247,
24248,
24249,
24250,
24251,
24252,
24253,
24254,
24255,
24256,
24257,
24258,
24259,
24260,
24261,
24262,
24268,
24269,
24270,
24271,
24272,
24273,
24274,
24275,
24276,
24277,
24278,
24279,
24280,
24281,
24282,
24283,
24284,
24285,
24286,
24287,
24288,
24289,
24290,
24291,
24292,
24297,
24298,
24299,
24300,
24301,
24302,
24303,
24304,
24305,
24306,
24307,
24308,
24309,
24310,
24311,
24312,
24313,
24314,
24315,
24316,
24317,
24318,
24323,
24324,
24325,
24326,
24327,
24328,
24329,
24330,
24331,
24337,
24342,
24343,
24344,
24345,
24346,
24347,
24348,
24349,
24350,
24351,
24352,
24357,
24358,
24359,
24360,
24361,
24362,
24363,
24364,
24365,
24366,
24367,
24368,
24369,
24370,
24371,
24372,
24373,
24374,
24375,
24381,
24382,
24383,
24384,
24385,
24385,
24386,
24387,
24388,
24393,
24394,
24395,
24396,
24397,
24398,
24399,
24400,
24401,
24402,
24404,
24405,
24410,
24411,
24412,
24413,
24414,
24415,
24420,
24421,
24422,
24423,
24424,
24425,
24426,
24427,
24428,
24429,
24430,
24431,
24432,
24433,
24434,
24434,
24435,
24436,
24437,
24438,
24439,
24440,
24441,
24442,
24443,
24449,
24450,
24451,
24452,
24453,
24454,
24455,
24456,
24457,
24458,
24459,
24460,
24461,
24462,
24468,
24469,
24470,
24471,
24472,
24473,
24474,
24475,
24476,
24477,
24478,
24479,
24480,
24481,
24482,
24483,
24484,
24485,
24486,
24487,
24488,
24489,
24490,
24495,
24496,
24497,
24498,
24499,
24500,
24501,
24502,
24502,
24503,
24504,
24505,
24506,
24507,
24508,
24509,
24510,
24511,
24516,
24517,
24518,
24519,
24520,
24521,
24522,
24523,
24524,
24525,
24526,
24527,
24528,
24529,
24530,
24531,
24532,
24537,
24538,
24539,
24540,
24541,
24542,
24543,
24545,
24546,
24547,
24548,
24549,
24550,
24555,
24556,
24557,
24558,
24559,
24560,
24561,
24561,
24562,
24563,
24564,
24565,
24566,
24567,
24568,
24568,
24569,
24570,
24571,
24576,
24577,
24578,
24579,
24580,
24581,
24582,
24589,
24590,
24590,
24591,
24592,
24593,
24594,
24595,
24596,
24597,
24598,
24599,
24600,
24601,
24606,
24607,
24609,
24610,
24611,
24612,
24613,
24614,
24615,
24616,
24617,
24618,
24621,
24622,
24623,
24624,
24629,
24630,
24631,
24631,
24632,
24633,
24634,
24635,
24635,
24636,
24637,
24638,
24639,
24640,
24641,
24642)

