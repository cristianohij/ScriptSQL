select top 5 convert(char(7),MUNCOD) from TBS003
select top 5 subString(convert(char(7),MUNCOD),1,2) from TBS003
select top 5 convert(int,subString(convert(char(7),MUNCOD),1,2)) from TBS003
select top 5 convert(int,subString(convert(char(7),MUNCOD),1,2))*100000 from TBS003
select top 5 MUNCOD-convert(int,subString(convert(char(7),MUNCOD),1,2))*100000 from TBS003

update TBS003 set MUNCOD=MUNCOD-convert(int,subString(convert(char(7),MUNCOD),1,2))*100000 from TBS003