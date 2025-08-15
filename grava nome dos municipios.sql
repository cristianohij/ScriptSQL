declare @tabela varchar(10) ,
        @atributo varchar(10) ,
        @comando varchar(4000) ,
        @municipio varchar(50) ,
        @cidades varchar(4000)

-- clientes
set @tabela='TBS002'
set @atributo='CLICID'

-- transportadoras
--set @tabela='TBS005'
--set @atributo='TRNCID'

-- fornecedores
--set @tabela='TBS006'
--set @atributo='FORCID'


set @municipio='ALFENAS'
set @cidades=''''+'ALFENAS\'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO JOSE DOS CAMPOS'
set @cidades=''''+'ASO JOSE DOS CAMPOS'+''''+','+''''+
                  'S J CAMPOS'+''''+','+''''+
                  'SAO JOS DOS CAMPOS'+''''+','+''''+
                  'SAO JOSE  DOS CAMPOS'+''''+','+''''+
                  'SAO JODE DOS CAMPOS'+''''+','+''''+
                  'SAO JOSE  DOS SANTOS'+''''+','+''''+
                  'SAO JOSE CAMPOS'+''''+','+''''+
                  'SAO JOSE CMAPOS'+''''+','+''''+
                  'SAO JOSE DO CAMPOS'+''''+','+''''+
                  'SAO JOSE DOS  CAMPOS'+''''+','+''''+
                  'SAO JOSE DOS CAMOS'+''''+','+''''+
                  'SAO JOSE DOS CAMPO'+''''+','+''''+
                  'SAO JOSE DOS CMAPOS'+''''+','+''''+
                  'SAO JOSE ODS CAMPOS'+''''+','+''''+
                  'SAO JOSEE DOS CAMPOS'+''''+','+''''+
                  'SAO JOSO DOS CAMPOS'+''''+','+''''+
                  'SAO JSOE CAMPOS'+''''+','+''''+
                  'S.J.CAMPOS'+''''+','+''''+
                  'S.J.DOS CAMPOS'+''''+','+''''+
                  'JSCAMPOS'+''''+','+''''+
                  'SJ CAMPOS'+''''+','+''''+
                  'SJC'+''''+','+''''+
                  'SJCAMPO'+''''+','+''''+
                  'SJCAMPOS'+''''+','+''''+
                  'SJCAMPS'+''''+','+''''+
                  'SJCCAMPOS'+''''+','+''''+
                  'SJCMPOS'+''''+','+''''+
                  'SJOCAMPOS'+''''+','+''''+
                  'SJOSE DOS CAMPOS'+''''+','+''''+
                  'SLCAMPOS'+''''+','+''''+
                  'SO JOSE DOS CAMPOS'+''''+','+''''+
                  'SOA JOSE CAMPOS'+''''+','+''''+
                  'SOA JOSE DOS CAMPOS'+''''+','+''''+
                  'SSAO JOSE DOS CAMPOS'+''''+','+''''+
                  'SÃO JOSE DOS CAMPOS'+''''+','+''''+
                  'SÄO JOSE DOS CAMPOS'+''''+','+''''+
                  'JD. AQUARIUS'+''''+','+''''+
                  'JARDIM CALIFORNIA'+''''+','+''''+
                  'JD.INDUSTRIAS'+''''+','+''''+
                  'SA OJOSE DOS CAMPOS'+''''+','+''''+
                  'SAO  JOSE DOS CAMPOS'+''''+','+''''+
                  'SA OJOSE DOS CAMPOS'+''''+','+''''+
                  'SAP JOSE DOS CAMPOS'+''''+','+''''+
                  'SÃO JOSÉ DOS CAMPOS'+''''+','+''''+
                  'SäO JOSE DOS CAMPOS'+''''+','+''''+
                  'VILA ADYANNA'+''''+','+''''+
                  'S. JOSE DOS CAMPO'+''''+','+''''+
                  'SAO JOSEDOSSAMPOS'+''''+','+''''+
                  'ASO JOSE DOS CAMPOS'+''''+','+''''+
                  'S J CAMPOS'+''''+','+''''+
                  'SAO JOS DOS CAMPOS'+''''+','+''''+
                  'SAO JOSE  DOS CAMPOS'+''''+','+''''+
                  'SAO JODE DOS CAMPOS'+''''+','+''''+
                  'SAO JOSE  DOS SANTOS'+''''+','+''''+
                  'SAO JOSE CAMPOS'+''''+','+''''+
                  'SAO JOSE CMAPOS'+''''+','+''''+
                  'SAO JOSE DO CAMPOS'+''''+','+''''+
                  'SAO JOSE DOS  CAMPOS'+''''+','+''''+
                  'SAO JOSE DOS CAMOS'+''''+','+''''+
                  'SAO JOSE DOS CAMPO'+''''+','+''''+
                  'SAO JOSE DOS CMAPOS'+''''+','+''''+
                  'SAO JOSE ODS CAMPOS'+''''+','+''''+
                  'SAO JOSEE DOS CAMPOS'+''''+','+''''+
                  'SAO JOSO DOS CAMPOS'+''''+','+''''+
                  'SAO JSOE CAMPOS'+''''+','+''''+
                  'S.J.CAMPOS'+''''+','+''''+
                  'S.J.DOS CAMPOS'+''''+','+''''+
                  'JSCAMPOS'+''''+','+''''+
                  'SJ CAMPOS'+''''+','+''''+
                  'SJC'+''''+','+''''+
                  'SJCAMPO'+''''+','+''''+
                  'SJCAMPOS'+''''+','+''''+
                  'SJCAMPS'+''''+','+''''+
                  'SJCCAMPOS'+''''+','+''''+
                  'SJCMPOS'+''''+','+''''+
                  'SJOCAMPOS'+''''+','+''''+
                  'SJOSE DOS CAMPOS'+''''+','+''''+
                  'SLCAMPOS'+''''+','+''''+
                  'SO JOSE DOS CAMPOS'+''''+','+''''+
                  'SOA JOSE CAMPOS'+''''+','+''''+
                  'SOA JOSE DOS CAMPOS'+''''+','+''''+
                  'SSAO JOSE DOS CAMPOS'+''''+','+''''+
                  'SÃO JOSE DOS CAMPOS'+''''+','+''''+
                  'SÄO JOSE DOS CAMPOS'+''''+','+''''+
                  'JD. AQUARIUS'+''''+','+''''+
                  'JARDIM CALIFORNIA'+''''+','+''''+
                  'JD.INDUSTRIAS'+''''+','+''''+
                  'SA OJOSE DOS CAMPOS'+''''+','+''''+
                  'SAO  JOSE DOS CAMPOS'+''''+','+''''+
                  'SA OJOSE DOS CAMPOS'+''''+','+''''+
                  'SAP JOSE DOS CAMPOS'+''''+','+''''+
                  'SÃO JOSÉ DOS CAMPOS'+''''+','+''''+
                  'SäO JOSE DOS CAMPOS'+''''+','+''''+
                  'VILA ADYANNA'+''''+','+''''+
                  'S J DOS CAMPOS'+''''+','+''''+
                  'S JOSE DOS CAMPOS'+''''+','+''''+
                  'S.JOSE DOS CAMPOS'+''''+','+''''+
                  'SAO JOSE DOS CA'+''''+','+''''+
                  'S J CAMPOS'+''''+','+''''+
                  'S J DOS CAMPOS'+''''+','+''''+
                  'S+O JOS+ DOS CA'+''''+','+''''+
                  'S.J. CAMPOS'+''''+','+''''+
                  'S.J.CAMPOS'+''''+','+''''+
                  'S.J.DOS CAMPOS'+''''+','+''''+
                  'SAO JOSE CAMPOS'+''''+','+''''+
                  'SAO JOSE DO CAM'+''''+','+''''+
                  'SAO JOSE DOS CA'+''''+','+''''+
                  'SJ CAMPOS'+''''+','+''''+
                  'SJC'+''''+','+''''+
                  'SJCAMPOS'+''''+','+''''+
                  'SÃO JOSÉ DOS CA'+''''+','+''''+
                  'SÃO JOSÉ DOS CAMPOS'+''''+','+''''+
                  'SJCAMPOS.'+''''+','+''''+
                  'SJCCAMPOS'+''''+','+''''+
                  'S J CAMPOS'+''''+','+''''+
                  'SAO JOSE DOS CA'+''''+','+''''+
                  'SJCAMPOS'+''''+','+''''+
                  'SAO J. DOS CAMPOS'+''''+','+''''+
                  'SAO J.DOS CAMPOS'+''''+','+''''+
                  'SAO JOSE DOS CAMPOS - SP'+''''+','+''''+
                  'SÄO JOSE'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BARUERI'
set @cidades=''''+'BARURI'+''''+','+''''+
                  'ARUERI'+''''+','+''''+
                  'BABUERI'+''''+','+''''+
                  'BARUERI   SAO PAULO'+''''+','+''''+
                  'BARUERI  SP'+''''+','+''''+
                  'BARUERI SAO PAULO'+''''+','+''''+
                  'BARUERI SP'+''''+','+''''+
                  'BARUERI-SP'+''''+','+''''+
                  'BARUEIRI'+''''+','+''''+          
                  'BARUERI - SP'+''''+','+''''+
                  'BARUEI'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BOM JESUS DOS PERDOES'
set @cidades=''''+'BOM JESUS DOS PEDOES'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BRAGANCA PAULISTA'
set @cidades=''''+'BRAGANÃA PAULISTA'+''''+','+''''+
                  'BRAG PAULISTA'+''''+','+''''+
                  'BRAGANCA PTA'+''''+','+''''+
                  'BRAGAN€A PAULISTA'+''''+','+''''+
                  'BREGANCA PAULISTA'+''''+','+''''+
                  'BRAG.PAULISTA'+''''+','+''''+
                  'BRAGANCA PTA.'+''''+','+''''+
                  'BRAGANÄA PAULISTA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CACAPAVA'
set @cidades=''''+'CACAPACA'+''''+','+''''+
                  'CACAPAVA VELHA'+''''+','+''''+
                  'CAÃAPAVA'+''''+','+''''+
                  'CAÄAPAVA'+''''+','+''''+
                  'CAÇAPAVA'+''''+','+''''+
                  'CA€APAVA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CACHOEIRA PAULISTA'
set @cidades=''''+'CACH.PAULISTA'+''''+','+''''+
                  'CACHOEIRA PAULIST'+''''+','+''''+
                  'CAHOEIRA PAULISTA'+''''+','+''''+
                  'C.PAULISTA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CAMPOS DO JORDAO'
set @cidades=''''+'CAMPO JORDAO'+''''+','+''''+
                  'CAMPOS DO JORDAO-CX P. 58'+''''+','+''''+
                  'CAMPOS DO JORDÄO'+''''+','+''''+
                  'CAMPOS JORDAO'+''''+','+''''+
                  'CAAMPOS DO JORDAO'+''''+','+''''+
                  'CAMPOS  DO JORDAO'+''''+','+''''+
                  'CAMPOS DO JORDAÖ'+''''+','+''''+
                  'CAMPOS DO JORDÃO'+''''+','+''''+
                  'CAMPOS DOP JORDAO'+''''+','+''''+
                  'CAMPOS DOS CAMPOS'+''''+','+''''+
                  'CAMPOS DOS JORDAO'+''''+','+''''+
                  'COMPOS DO JORDAO'+''''+','+''''+
                  'CAMP DO JORDAO'+''''+','+''''+
                  'CAMPO DO JORDAO'+''''+','+''''+
                  'CAMPOS'+''''+','+''''+
                  'CAMPOS DE JORDAO'+''''+','+''''+
                  'CAMPOS DO JORDÇO'+''''+','+''''+
                  'CAMPOS JORDAO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CARAGUATATUBA'
set @cidades=''''+'CARAGUARATUBA'+''''+','+''''+
                  'CRAGUATATUBA'+''''+','+''''+
                  'GUARAGUATATUBA'+''''+','+''''+
                  'CARAGUA'+''''+','+''''+
                  'CARAGUATUBA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CUBATAO'
set @cidades=''''+'CUBATäO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='GUARATINGUETA'
set @cidades=''''+'GUARANTINGUETA'+''''+','+''''+
                  'GUARATINGUET-'+''''+','+''''+
                  'GUARATINQUETA'+''''+','+''''+
                  'GUARATIGUETA'+''''+','+''''+
                  'GUARETIGUETA'+''''+','+''''+
                  'GUARATINGUETA PROX SEM FREI GALVÂO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='JACAREI'
set @cidades=''''+'JACARE-'+''''+','+''''+
                  'JACAREI  - CX POSTAL 137'+''''+','+''''+
                  'JACAREI SP'+''''+','+''''+
                  'JACAREI.'+''''+','+''''+
                  'JACAREÍ'+''''+','+''''+
                  'JSACAREI'+''''+','+''''+
                  'JACAREI-CAC CXP.33'+''''+','+''''+
                  'JACAREÖ'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='PARAISOPOLIS'
set @cidades=''''+'PARAISOPOLES'+''''+','+''''+
                  'PARAISOPOLIS MG'+''''+','+''''+
                  'PARAISËPOLIS'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='PINDAMONHANGABA'
set @cidades=''''+'PINDA'+''''+','+''''+
                  'PINDA MONHANGABA'+''''+','+''''+
                  'PINDAMONHAGABA'+''''+','+''''+
                  'PINTAMONHANGABA'+''''+','+''''+
                  'PINA'+''''+','+''''+
                  'PINADA'+''''+','+''''+
                  'PINADAMONHANGABA'+''''+','+''''+
                  'PINAMONHANGABA'+''''+','+''''+
                  'PINDA - SP'+''''+','+''''+
                  'PINDA / MOREIRA CESAR'+''''+','+''''+
                  'PINDA.BA.'+''''+','+''''+
                  'PINDAMINHANGABA'+''''+','+''''+
                  'PINDAMONANGABA'+''''+','+''''+
                  'PINDAMONGABA'+''''+','+''''+
                  'PINDAMONHANGA'+''''+','+''''+
                  'PINDAMONHANGABA - SP'+''''+','+''''+
                  'PINDAMONHANGADA'+''''+','+''''+
                  'PINDAMONHAGABA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='RIBERAO PRETO'
set @cidades=''''+'RIBEIRAO'+''''+','+''''+
                  'RIBEIRÃO PRETO'+','+''''+
                  'RIBERAO PRETO'+','+''''+
                  'RIBEIRO PRETO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO PAULO'
set @cidades=''''+'S+O PAULO'+''''+','+''''+
                  'S.PAULO'+''''+','+''''+
                  'SP'+''''+','+''''+
                  'SP PAULO'+''''+','+''''+
                  'SPAULO'+''''+','+''''+
                  'SÃO PAULO'+''''+','+''''+
                  'SÃO PAULO - SP'+''''+','+''''+
                  'SÄO PAULO'+''''+','+''''+
                  'SAO  PAULO'+''''+','+''''+
                  'SAO PAILO'+''''+','+''''+
                  'SAO PAUJLO'+''''+','+''''+
                  'SAO SAULO'+''''+','+''''+
                  'SAO PAULOI'+''''+','+''''+
                  'S+O PAULO'+''''+','+''''+
                  'S.PAULO'+''''+','+''''+
                  'SP'+''''+','+''''+
                  'SP PAULO'+''''+','+''''+
                  'SPAULO'+''''+','+''''+
                  'SÃO PAULO'+''''+','+''''+
                  'SÃO PAULO - SP'+''''+','+''''+
                  'SÄO PAULO'+''''+','+''''+
                  'SAO  PAULO'+''''+','+''''+
                  'SAO PAILO'+''''+','+''''+
                  'SAO PAUJLO'+''''+','+''''+
                  'SAO SAULO'+''''+','+''''+
                  'SAO PAULOI'+''''+','+''''+
                  '+AO PAULO'+''''+','+''''+
                  ',AO PAULO'+''''+','+''''+
                  ',SAO PAULO'+''''+','+''''+
                  '.SAO PAULO'+''''+','+''''+
                  '.SP'+''''+','+''''+
                  'S PAULO'+''''+','+''''+
                  'SA PAULO'+''''+','+''''+
                  'SA0 PAULO'+''''+','+''''+
                  'SAA PAULO'+''''+','+''''+
                  'SAAO PAULO'+''''+','+''''+
                  'SAIO PAULO'+''''+','+''''+
                  'SAO  PAULO'+''''+','+''''+
                  'SAO -PAULO'+''''+','+''''+
                  'SAO APAULO'+''''+','+''''+
                  'SAO APULO'+''''+','+''''+
                  'SAO LAULO'+''''+','+''''+
                  'SAO PALO'+''''+','+''''+
                  'SAO PAUL0'+''''+','+''''+
                  'SAO PAULCO'+''''+','+''''+
                  'SAO PAULIO'+''''+','+''''+
                  'SAO PAULO     N§40'+''''+','+''''+
                  'SAO PAULO , SP'+''''+','+''''+
                  'SAO PAULO AMD BOX 4'+''''+','+''''+
                  'SAO PAULO PAV.APE-BOX11'+''''+','+''''+
                  'SAO PAULO S.P'+''''+','+''''+
                  'SAO PAULO SERRA'+''''+','+''''+
                  'SAO PAULO SP'+''''+','+''''+
                  'SAO PAULO ST AMARO'+''''+','+''''+
                  'SAO PAULO USP'+''''+','+''''+
                  'SAO PAULO jd.MONTE ALEGRE'+''''+','+''''+
                  'SAO PAULO,'+''''+','+''''+
                  'SAO PAULO,,,'+''''+','+''''+
                  'SAO PAULO,SP'+''''+','+''''+
                  'SAO PAULO-CENTRO'+''''+','+''''+
                  'SAO PAULO-SP'+''''+','+''''+
                  'SAO PAULO.'+''''+','+''''+
                  'SAO PAULO0'+''''+','+''''+
                  'SAO PAULO3'+''''+','+''''+
                  'SAO PAULOE SAPUCAI'+''''+','+''''+
                  'SAO PAULOILIA'+''''+','+''''+
                  'SAO PAULOP'+''''+','+''''+
                  'SAO PAULOSP'+''''+','+''''+
                  'SAO PAULO['+''''+','+''''+
                  'SAO PAUO'+''''+','+''''+
                  'SAO PAU€P'+''''+','+''''+
                  'SAO POULO'+''''+','+''''+
                  'SAO PUALO'+''''+','+''''+
                  'SAO PULO'+''''+','+''''+
                  'SAO PµULO'+''''+','+''''+
                  'SAO SAO PAULO'+''''+','+''''+
                  'SAO ÁULO'+''''+','+''''+
                  'SAO, PAULO'+''''+','+''''+
                  'SAO,PAULO'+''''+','+''''+
                  'SAO-PAULO'+''''+','+''''+
                  'SAO9 PAULO'+''''+','+''''+
                  'SAOM PAULO'+''''+','+''''+
                  'SAOP PAULO'+''''+','+''''+
                  'SAOPAULO'+''''+','+''''+
                  'SAP'+''''+','+''''+
                  'SAP PAULO'+''''+','+''''+
                  'SASO PAULO'+''''+','+''''+
                  'SASO PAULO,'+''''+','+''''+
                  'SDAO PAULO'+''''+','+''''+
                  'SO PAULO'+''''+','+''''+
                  'SOA PAULO'+''''+','+''''+
                  'SP'+''''+','+''''+
                  'SP PAULO'+''''+','+''''+
                  'SP SAO PAULO'+''''+','+''''+
                  'SP,'+''''+','+''''+
                  'SP.  SHOPPING MORUMBI'+''''+','+''''+
                  'SP3'+''''+','+''''+
                  'SPAULO'+''''+','+''''+
                  'SQO PAULO'+''''+','+''''+
                  'SÃO PAULO'+''''+','+''''+
                  'SÃO PAULO,'+''''+','+''''+
                  'SÄO PAULO'+''''+','+''''+
                  'SÇO PAULO'+''''+','+''''+
                  'SÇO PAULO SP'+''''+','+''''+
                  'SAO AULO'+''''+','+''''+
                  'SAO PAULO PAV.APE-BOX112'+''''+','+''''+
                  'SAO PAULOA'+''''+','+''''+
                  'SAO PAULO]'+''''+','+''''+
                  'SAO PAULP['+''''+','+''''+
                  'SAOPULO'+''''+','+''''+
                  'S¶O PAULO'+''''+','+''''+
                  'SÆo Paulo'+''''+','+''''+
                  'sao paulo'+''''+','+''''+
                  'SAO PAULO - SP'+''''+','+''''+
                  'SAOPAULO - SP'+''''+','+''''+
                  'S+O PAULO'+''''+','+''''+
                  'SA0 PAULO'+''''+','+''''+
                  'SAO  PAULO'+''''+','+''''+
                  'SAO PAUILO'+''''+','+''''+
                  'SAO PAULO / SP'+''''+','+''''+
                  'SAO PAULO PROX.KM 16 RAPOSO TAVARES'+''''+','+''''+
                  'SAOPAULO'+''''+','+''''+
                  'SP'+''''+','+''''+
                  'SÃO PAULO'+''''+','+''''+
                  'SÃO PAULO / SP'+''''+','+''''+
                  'SÃO PAULO/CP'+''''+','+''''+
                  'BROKLIN NOVO'+''''+','+''''+
                  'BUTANTA'+''''+','+''''+
                  'BUTANTÃ'+''''+','+''''+
                  'SAO   PAULO'+''''+','+''''+
                  'SAO  PAUILO'+''''+','+''''+
                  'SAO PAIULO'+''''+','+''''+
                  'SAO PAJLO'+''''+','+''''+
                  'SAO PAULO ,'+''''+','+''''+
                  'SAO PAYULO'+''''+','+''''+
                  'SÄO PAULO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO BENTO DO SAPUCAI'
set @cidades=''''+'S B DO  SAPUCAI'+''''+','+''''+
                  'S BENTO DO SAPUCAI'+''''+','+''''+
                  'S. BENTO SAPUCAI'+''''+','+''''+
                  'S.BENTO DO SAPUCA'+''''+','+''''+
                  'S.BENTO DO SAPUCAI'+''''+','+''''+
                  'S.BENTO SAPUCAI'+''''+','+''''+
                  'SAO BENTO SAPUCAI'+''''+','+''''+
                  'SAO BTO. SAPUCAI'+''''+','+''''+
                  'SÃO BENTO SAPUCAI'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='RIO DE JANEIRO'
set @cidades=''''+'RIO JANEIRO'+''''+','+''''+
                  'RIO'+''''+','+''''+
                  'RIO DE DE JANEIRO'+''''+','+''''+
                  'RJ'+''''+','+''''+
                  'R DE JANEIRO'+''''+','+''''+
                  'RIIO DE JANEIRO'+''''+','+''''+
                  'RIO DE  JANEIRO'+''''+','+''''+
                  'RIO DE JANEIRO / RJ'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SANTO ANDRE'
set @cidades=''''+'SANTO ANDRÉ - SP'+''''+','+''''+
                  'SANTOANDRE'+''''+','+''''+
                  'ST ANDRE'+''''+','+''''+
                  'SANTO ANDRE - SP'+''''+','+''''+
                  'SANTO ANDRÉ'+''''+','+''''+
                  'STO ANDRE'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SANTO ANTONIO DO PINHAL'
set @cidades=''''+'SANTO ANT. PINHAL'+''''+','+''''+
                  'SANTO ANTONIO DOS PINHAL'+''''+','+''''+
                  'S. ANTONIO PINHAL'+''''+','+''''+
                  'STO ANT PINHAL'+''''+','+''''+
                  'STO ANTONIO PINHA'+''''+','+''''+
                  'STO ANTONIO PINHAL'+''''+','+''''+
                  'STO ANTONIO DO PINHAL'+''''+','+''''+
                  'STO. ANTONIO DO PINHAL'+''''+','+''''+
                  'Sto ANT DO PINHAL'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO BERNARDO DO CAMPO'
set @cidades=''''+'SAO BERNADO DO CAMPO'+''''+','+''''+
                  'SAO BERNADO DO CAMPOS'+''''+','+''''+
                  'SAO BERNARDO CAMP'+''''+','+''''+
                  'S B DO CAMPO'+''''+','+''''+
                  'S BERNARDO CAMPO'+''''+','+''''+
                  'S. BERNARDO'+''''+','+''''+
                  'S. BERNARDO DO CAMPO'+''''+','+''''+
                  'S.BERNARDO CAMPO'+''''+','+''''+
                  'SAO BERNADO CAMPO'+''''+','+''''+
                  'SAO BERNADO DO CAMPO'+''''+','+''''+
                  'SAO BERNADO DO CAMPOS'+''''+','+''''+
                  'SAO BERNARDO CAMP'+''''+','+''''+
                  'S B DO CAMPO'+''''+','+''''+
                  'S BERNARDO CAMPO'+''''+','+''''+
                  'S. BERNARDO'+''''+','+''''+
                  'S. BERNARDO DO CAMPO'+''''+','+''''+
                  'S.BERNARDO CAMPO'+''''+','+''''+
                  'S B CAMPOS'+''''+','+''''+
                  'S BERN CAMPO'+''''+','+''''+
                  'S BERNADO DO CAMPO'+''''+','+''''+
                  'S. B CAMPO'+''''+','+''''+
                  'S. B DO CAMPO'+''''+','+''''+
                  'S. B. DE CAMPO'+''''+','+''''+
                  'S. B. DO CAMPO'+''''+','+''''+
                  'S. B. DO CAMPOS'+''''+','+''''+
                  'S. BERNADO DO CAMPO'+''''+','+''''+
                  'S. BERNARDO CAMPO'+''''+','+''''+
                  'S.B DO CAMPO'+''''+','+''''+
                  'S.B. DO CAMPO'+''''+','+''''+
                  'S.BERNARDO DO CAMP'+''''+','+''''+
                  'S.BERNARDO DO CAMPO'+''''+','+''''+
                  'SAO BERNADO'+''''+','+''''+
                  'SAO BERNADO DOS CAMP'+''''+','+''''+
                  'SAO BERNARDO CAMPO'+''''+','+''''+
                  'SAO BERNARDO DE CAMP'+''''+','+''''+
                  'SAO BERNARDO DO CAMP'+''''+','+''''+
                  'SAO BERNARDO DOS CAMPOS'+''''+','+''''+
                  'SB CAMPO'+''''+','+''''+
                  'SBCAMPO'+''''+','+''''+
                  'SBERNARDO CAMPO'+''''+','+''''+
                  'S B DO CAMPO'+''''+','+''''+
                  'S BERNARDO CAMP'+''''+','+''''+
                  'S. BERNA. CAMPO'+''''+','+''''+
                  'SAO BERNARDO CA'+''''+','+''''+
                  'SAO BERNARDO DO'+''''+','+''''+
                  'SÃO BERNARDO DO'+''''+','+''''+
                  'S BERNARDO DO CAMPO'+''''+','+''''+
                  'S. B.DO CAMPO'+''''+','+''''+
                  'S. BERN. DO CAMPO'+''''+','+''''+
                  'S.B.CAMPO'+''''+','+''''+
                  'S.B.CAMPOS'+''''+','+''''+
                  'S.B.DO CAMPO'+''''+','+''''+
                  'SAO B. DO CAMPO'+''''+','+''''+
                  'SAO BER. DO CAMPO'+''''+','+''''+
                  'SAO BERN. CAMPO'+''''+','+''''+
                  'SAO BERN. DO CAMPO'+''''+','+''''+
                  'SAO BERN.DO CAMPO'+''''+','+''''+
                  'SAO BERNADO DOS CAMPOS'+''''+','+''''+
                  'SAO BERNARDO DE CAMPO'+''''+','+''''+
                  'SÃO BERNARDO DO CAMPO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='MOGI DAS CRUZES'
set @cidades=''''+'MOGI'+''''+','+''''+
                  'MOGI DAS CRUZES - SP'+','+''''+
                  'MOGI MIRIM'+','+''''+
                  'MONGI DAS CRUZES'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SANTA BRANCA'
set @cidades=''''+'STA BRANCA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO SEBASTIAO'
set @cidades=''''+'SÄO SEBASTIÄO'+''''+','+''''+
                  'SAO SEBASTIAO, 271'+''''+','+''''+
                  'SAO SEBASTIÄO'+''''+','+''''+
                  'SAO SEBATIAO'+''''+','+''''+
                  'S SEBASTIAO'+''''+','+''''+
                  'S+O SEBASTI+O'+''''+','+''''+
                  'S.SEBASTIAO'+''''+','+''''+
                  'SAO SEBASTIAO.'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='TAUBATE'
set @cidades=''''+'TABAUTE'+''''+','+''''+
                  'RAUBATE'+''''+','+''''+
                  'TAUABTE'+''''+','+''''+
                  'TAUATE'+''''+','+''''+
                  'TAUBAT+'+''''+','+''''+
                  'TAUBATE (STAR SHOPPING)'+''''+','+''''+
                  'TAUBATE - SP'+''''+','+''''+
                  'TAUBATE / SP'+''''+','+''''+
                  'TAUBATE 1036'+''''+','+''''+
                  'TAUBATE 365'+''''+','+''''+
                  'TAUBATE BANCA N8'+''''+','+''''+
                  'TAUBATE SP'+''''+','+''''+
                  'TAUBATE.'+''''+','+''''+
                  'TAUBATE/SP'+''''+','+''''+
                  'TAUBATES'+''''+','+''''+
                  'TAUBATE]'+''''+','+''''+
                  'TAUBATTE'+''''+','+''''+
                  'TAUBAT[E'+''''+','+''''+
                  'TAUBATÉ'+''''+','+''''+
                  'TAUBATÉ - SP'+''''+','+''''+
                  'TAUBETE'+''''+','+''''+
                  'TAUBTE'+''''+','+''''+
                  'TTE.'+''''+','+''''+
                  'TTE´.'+''''+','+''''+
                  'TTÉ'+''''+','+''''+
                  'TTÉ.'+''''+','+''''+
                  'TUABATE'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO CAETANO DO SUL'
set @cidades=''''+'SÃO CAETANO DO SUL'+''''+','+''''+
                  'SäO CAETANO DO SUL'+''''+','+''''+
                  'S. CAETANO SUL'+''''+','+''''+
                  'SAO CAETANO'+''''+','+''''+
                  'SAO CAETANO DO'+''''+','+''''+
                  'S. CAETANO DO SUL'+''''+','+''''+
                  'S.CAETANO DO SUL'+''''+','+''''+
                  'SAO CAETANO SUL'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='TABOAO DA SERRA'
set @cidades=''''+'TALVAO DA SERRA'+''''+','+''''+
                  'TOBAO DA SERRA'+''''+','+''''+
                  'T DA SERRA'+''''+','+''''+
                  'T SERRA'+''''+','+''''+
                  'T. DA SERRA'+''''+','+''''+
                  'TAB DA SERRA'+''''+','+''''+
                  'TABAO DA SERRA'+''''+','+''''+
                  'TABOA DA SERRA'+''''+','+''''+
                  'TABOAO'+''''+','+''''+
                  'TABOAO DA SERRA  SP'+''''+','+''''+
                  'TABOAO DA SERRA SP'+''''+','+''''+
                  'TABOAO DA SESRA'+''''+','+''''+
                  'TABOAO DE SERRA'+''''+','+''''+
                  'TABOAO SA SERRA'+''''+','+''''+
                  'TABOAO SERRA'+''''+','+''''+
                  'TABOAÖ DA SERRA'+''''+','+''''+
                  'TABOÃO DA SERRA'+''''+','+''''+
                  'TABOÃO DA SERRA SP'+''''+','+''''+
                  'TAB.DA SERRA'+''''+','+''''+
                  'TABOAO  DA SERRA'+''''+','+''''+
                  'TABOÄO DA SERRA'+''''+','+''''+
                  'TABOÇO DA SERRA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='UBATUBA'
set @cidades=''''+'UABTUBA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='TRES CORACOES'
set @cidades=''''+'TRES CORECOES'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='PARATI'
set @cidades=''''+'PARATY'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='PRESIDENTE PRUDENTE'
set @cidades=''''+'P. PRUDENTE'+''''+','+''''+
                  'PRESID PRUDENTE'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='LORENA'
set @cidades=''''+'LORENA SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='GUARULHOS'
set @cidades=''''+'GUARULHOS SP'+''''+','+''''+
                  'GARULHOS'+''''+','+''''+
                  'GUARULHO'+''''+','+''''+
                  'GUARULHOS SP'+''''+','+''''+
                  'MUNICIPIO DE GUARULHOS'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='AMPARO'
set @cidades=''''+'AMPARO - SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='APARECIDA'
set @cidades=''''+'APARECIDA DO NORTE'+''''+','+''''+
                  'APAREC. DO NORTE'+''''+','+''''+
                  'APARECIDA DO NORT'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='APARECIDA DO TABOADO'
set @cidades=''''+'APARECIDA DO TABOA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='ARACARIGUAMA'
set @cidades=''''+'ARACARIGUAMA CXPOSTAL121'+''''+','+''''+
                  'ARARIGUAMA'+''''+','+''''+
                  'ARA€ARIGUAMA'+''''+','+''''+
                  'ARAÇARIGUAMA   - SÃO PAULO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='ARACATUBA'
set @cidades=''''+'ARA€ATUBA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='ARACARIGUAMA'
set @cidades=''''+'ARACARIGUAMA CXPOSTAL121'+''''+','+''''+
                  'ARARIGUAMA'+''''+','+''''+
                  'ARA€ARIGUAMA'+''''+','+''''+
                  'ARAÇARIGUAMA   - SÃO PAULO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='ARUJA'
set @cidades=''''+'ARUJA-SAO PAULO'+''''+','+''''+
                  'ARUJA / SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='OSASCO'
set @cidades=''''+'ASASCO'+''''+','+''''+
                  'OSAACO'+''''+','+''''+
                  'OSACO'+''''+','+''''+
                  'OSAS CO'+''''+','+''''+
                  'OSASCO  O'+''''+','+''''+
                  'OSASCO - SP'+''''+','+''''+
                  'OSASCO SAO PAULO'+''''+','+''''+
                  'OSASCO SP'+''''+','+''''+
                  'OSASCO-SP'+''''+','+''''+
                  'OSASO'+''''+','+''''+
                  'OSSCO'+''''+','+''''+
                  'OASACO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BELO HORIZONTE'
set @cidades=''''+'BELO HORINZONTE'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BIRITIBA-MIRIM'
set @cidades=''''+'BIRITIBA MIRIM'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BOTUCATU'
set @cidades=''''+'BOTUCATU - CXP 059'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CAMPO LIMPO PAULISTA'
set @cidades=''''+'C LIMPO PTA.'+''''+','+''''+
                  'C LIMPO-SAO PAULO'+''''+','+''''+
                  'CAMPO LIMPO'+''''+','+''''+
                  'CAMPO LIMPO PAULIS'+''''+','+''''+
                  'CAMPO LIMPO PTA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BRASILIA'
set @cidades=''''+'BRASILIA D.F'+''''+','+''''+
                  'DISTRITO FEDERAL'+''''+','+''''+
                  'BRASILIA -DF'+''''+','+''''+
                  'DESTRITO  FEDERAL'+','+''''+
                  'DISTRITO FEDRAL'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BRASILIA'
set @cidades=''''+'BRASILIA D.F'+''''+','+''''+
                  'DISTRITO FEDERAL'+''''+','+''''+
                  'DISTRITO FEDRAL'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='COTIA'
set @cidades=''''+'COTIA SAO PAULO'+''''+','+''''+
                  'COTIA-SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CAIEIRAS'
set @cidades=''''+'CAEIRAS'+''''+','+''''+
                  'CAIEIRA'+''''+','+''''+
                  'CAIEIRAS]'+''''+','+''''+
                  'CAIERAS'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CARAPICUIBA'
set @cidades=''''+'CARAPICUIBA SAO PAULO'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='EMBU-GUACU'
set @cidades=''''+'EMBU GUACU'+''''+','+''''+
                  'EMBU GUA€U'+''''+','+''''+
                  'EMBU-GUA€U'+''''+','+''''+
                  'EMBUGUA€U'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='IBIUNA'
set @cidades=''''+'IBIUNA-SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='JUNDIAI'
set @cidades=''''+'JUNDIAI  SP'+''''+','+''''+
                  'JUNDIAÖ'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='PRESIDENTE PRUDENTE'
set @cidades=''''+'PRES PRUDENTE'+''''+','+''''+
                  'PRES. PRUDENTE'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='PRESIDENTE PRUDENTE'
set @cidades=''''+'PRES PRUDENTE'+''''+','+''''+
                  'PRES. PRUDENTE'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='VARGEM GRANDE PAULISTA'
set @cidades=''''+'V GDE PAULISTA'+''''+','+''''+
                  'VARG GDE PAULISTA'+''''+','+''''+
                  'VARG GDE PTA'+''''+','+''''+
                  'VARGEM G PAULISTA'+''''+','+''''+
                  'VARGEM G.PAULISTA'+''''+','+''''+
                  'VARGEM GD PAULISTA'+''''+','+''''+
                  'VARGEM GDE PAULIST'+''''+','+''''+
                  'VARGEM GDE PAULISTA'+''''+','+''''+
                  'VARGEM GDE PTA.'+''''+','+''''+
                  'VARGEM GDE. PAULISTA'+''''+','+''''+
                  'VARGEM GR PAULISTA'+''''+','+''''+
                  'VARGEM GR.PAULISTA'+''''+','+''''+
                  'VARGEM GRANDE  PAULISTA'+''''+','+''''+
                  'VARGEM GRANDE PAUL'+''''+','+''''+
                  'VARGEM GRANDE PAULIS'+''''+','+''''+
                  'VARGEM GRANDE PAULISTA SP'+''''+','+''''+
                  'VG.GRANDE PAULISTA'+''''+','+''''+
                  'V.GDE PAULITA'+''''+','+''''+
                  'V.GDE.PAULISTA'+''''+','+''''+
                  'VARG. GRANDE PAULISTA'+''''+','+''''+
                  'VARG.GDE.PAULISTA'+''''+','+''''+
                  'VARGEM GD.PAULISTA'+''''+','+''''+
                  'VARGEM GDE PTA'+''''+','+''''+
                  'VARGEM GDE.PAULISTA'+''''+','+''''+
                  'VGEM.GRDE.PAULISTA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO LUIZ DO PARAITINGA'
set @cidades=''''+'S L PARAITINGA'+''''+','+''''+
                  'S. L. PARAITINGA'+''''+','+''''+
                  'S. LUIS DO PARAITINGA'+''''+','+''''+
                  'S. LUIZ DO PARAITINGA'+''''+','+''''+
                  'S. LUIZ PARAITINGA'+''''+','+''''+
                  'S.L. DO PARAITING'+''''+','+''''+
                  'SAO LUIS PARAITINGA'+''''+','+''''+
                  'SAO LUIZ DE PARAITINGA'+''''+','+''''+
                  'SAO LUIZ DO PARAITINGA'+''''+','+''''+
                  'SAO LUIZ PARAITINGA'+''''+','+''''+
                  'SÃO LUIS DO PARAITINGA'+''''+','+''''+
                  'SÃO LUIZ DO PARAITINGA'+''''+','+''''+
                  'SÄO LUIZ PARAITINGA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='BAURU'
set @cidades=''''+'BAURU - SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='CURITIBA'
set @cidades=''''+'CURITIBA / PR'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='FERRAZ DE VASCONCELOS'
set @cidades=''''+'FERRAZ DE VASCONCELOS / SP'+''''+','+''''+
                  'FERRAZ DE VASC'+''''+','+''''+
                  'FERRAZ VASCONCE'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='ITAJUBA'
set @cidades=''''+'ITAJUB-'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='ITAPECERICA DA SERRA'
set @cidades=''''+'ITAPECERICA DA'+''''+','+''''+
                  'ITAPECERICA SER'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='ITAQUAQUECETUBA'
set @cidades=''''+'ITAQUAQUECETUBA / SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='JOACABA'
set @cidades=''''+'JOAÇABA / SC'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='MARINGA'
set @cidades=''''+'MARING-'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='PETROPOLIS'
set @cidades=''''+'PETRËPOLIS'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='PONTA GROSSA'
set @cidades=''''+'PONTA GROSSA / PR'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='RIBEIRAO PIRES'
set @cidades=''''+'RIBEIRÃO PIRES / SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO JOAO DA BOA VISTA'
set @cidades=''''+'S.J.BOA VISTA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO JOAO BATISTA'
set @cidades=''''+'S.JOAO BATISTA'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SAO JOSE RIO PRETO'
set @cidades=''''+'S.JOSE RIO PRET'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)

set @municipio='SOROCABA'
set @cidades=''''+'SOROCABA / SP'+''''

print @municipio

set @comando='update '+@tabela+' set '+@atributo+'='+''''+@municipio+''''+' where '+@atributo+' in('+@cidades+')'
execute(@comando)
