select reverse(rtrim(subString(reverse(rtrim(CLIMAILNFE)),2,255))),
       CLIMAILNFE
  from TBS002 (nolock)
 where right(rtrim(CLIMAILNFE),1)=';'

begin tran
update TBS002 set CLIMAILNFE=reverse(rtrim(subString(reverse(rtrim(CLIMAILNFE)),2,255)))
 where right(rtrim(CLIMAILNFE),1)=';'
commit tran

select --reverse(rtrim(subString(reverse(rtrim(CLIMAILNFE)),2,255))),
       CLIMAILNFE
  from TBS002 (nolock)
 where CLIMAILNFE<>'' and
       rtrim(CLIMAILNFE) Like('% %')

select --reverse(rtrim(subString(reverse(rtrim(CLIMAILNFE)),2,255))),
       CLIOBS,
       CLIMAILNFE
  from TBS002 (nolock)
 where CLIMAILNFE<>'' and
       rtrim(CLIMAILNFE) not Like('%@%')
