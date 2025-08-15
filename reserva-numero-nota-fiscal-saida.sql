select TBSVALSEQ from TBS024 (nolock) where TBSNOM = 'TBS067'
update TBS024 set TBSVALSEQ = (select TBSVALSEQ+1 from TBS024 (nolock) where TBSNOM = 'TBS067') where TBSNOM = 'TBS067'
select TBSVALSEQ from TBS024 (nolock) where TBSNOM = 'TBS067'
