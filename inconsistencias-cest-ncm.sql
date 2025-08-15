select PROSTATUS,PROCEST,* from TBS010 (nolock) where PROCEST<>'' and isNumeric(PROCEST) = 0

select PROSTATUS,PROCEST,* from TBS010 (nolock) where PROCEST<>'' and Len(PROCEST) <> 7 

select PROSTATUS,PROCLAFIS,* from TBS010 (nolock) where PROCLAFIS<>'' and isNumeric(PROCLAFIS) = 0

select PROSTATUS,PROCLAFIS,* from TBS010 (nolock) where PROCLAFIS<>'' and Len(PROCLAFIS) <> 8
