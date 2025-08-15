-- Script executa alterações na tabela(TBS056:CONTAS A RECEBER) que afeta a geração do "Nosso Numero"
-- pela impressão do Boleto Formatado(A4), onde posteriormente a alteração o mesmo só armazenava a sequência
-- numérica gerada pelo sistema, sendo agora armazenado o mesmo "Nosso Número" impresso no boleto.
-- Ex. Banco do Brasil: Anteriormente  Nosso Numero
--			Armazenado...: 000000000025
--			Impresso.....: 188729000258
--					    !----! -> sequencia

--			Atualmente     Nosso Numero
--			Armazenado...: 188729000258
--			Impresso.....: 188729000258



-- Deixa atributo com valores em '' para '0', para que se possa converter String para numerico sem erros 
UPDATE TBS056 SET CRENUMBAN = '0'
WHERE CRENUMBAN = ''

-- Converte atributo CRENUMBAN de String para decimal
ALTER TABLE TBS056 ALTER COLUMN CRENUMBAN decimal(13, 0)

-- Inclusão de atributo CRENOSNUM
ALTER TABLE TBS056 ADD CRENOSNUM decimal(13, 0)

-- Atribui valor do atributo CRENUMBAN para o CRENOSNUM, para que boletos possom ser reimpressos
UPDATE TBS056 SET CRENOSNUM = CRENUMBAN


-- Controle de Atualização nas Empresas-Clientes:
-- Grupo Papelyna: 
--[ ] Tanby - DD/MM/AAAA	[ ] Tanby TTE - DD/MM/AAAA	[ ] Papelyna - DD/MM/AAAA	[ ] Misaspel - DD/MM/AAAA
--[ ] BestBag - DD/MM/AAAA	


-- HOFFMAN&GOMES
--[ ] LiderExpress - DD/MM/AAAA
