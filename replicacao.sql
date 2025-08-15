select time, error_text, xact_seqno,command_id
from distribution.dbo.MSrepl_errors
where error_code <> ''