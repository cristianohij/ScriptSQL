delete from TBS002
delete from TBS004
delete from TBS005
delete from TBS006
delete from TBS007
delete from TBS008
delete from TBS009
delete from TBS012
delete from TBS028
delete from TBS030
delete from TBS036
delete from TBS044
delete from TBS047
delete from TBS050
delete from TBS026
delete from TBS045
delete from TBS046
delete from TBS048
delete from TBS076
delete from TBS016
delete from TBS0161
delete from TBS0162
delete from TBS0163
delete from TBS0164
delete from TBS017
delete from TBS0171
delete from TBS051
delete from TBS013
delete from TBS037
delete from TBS0371
delete from TBS049
delete from TBS059
delete from TBS0591
delete from TBS0592
delete from TBS0593
delete from TBS056
delete from TBS057
delete from TBS060
delete from TBS062
delete from TBS070
delete from TBS073
delete from TBS075
delete from TBS077
delete from TBS078
delete from TBS042
delete from TBS054
delete from TBS064
delete from TBS038
delete from TBS043
delete from TBS0431
delete from TBS052
delete from TBS053
delete from TBS055
delete from TBS0551
delete from TBS058
delete from TBS067
delete from TBS0671
delete from TBS0672
delete from TBS069

delete from TBS010 where MARCOD not in(108,164,500)
delete from TBS014 where MARCOD not in(108,164,500)
delete from TBS015 where PDPCOD not Like('108%') and PDPCOD not Like('164%') and PDPCOD not Like('500%')
delete from TBS032 where MARCOD not in(108,164,500)


