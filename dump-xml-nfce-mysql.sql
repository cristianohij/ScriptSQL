DROP PROCEDURE IF EXISTS dump_xml_por_data;
DELIMITER //

CREATE PROCEDURE dump_xml_por_data(par_data_inicial DATE, par_data_final DATE)
BEGIN
    DECLARE this_id INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR 
        SELECT id FROM xmlnfce WHERE subString(nfce_chave,21,2)='65' and DATE(data) BETWEEN par_data_inicial AND par_data_final;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO this_id;
        IF done THEN 
            LEAVE read_loop;
        END IF;

        SET @query = CONCAT(
            'SELECT arquivo FROM xmlnfce WHERE id=', this_id, 
            ' INTO DUMPFILE "/tmp/xmlnfce-id-', this_id, '.xml.zip"'
        );

        PREPARE write_file FROM @query;
        EXECUTE write_file;
        DEALLOCATE PREPARE write_file;
    END LOOP;
    CLOSE cur1;
END //
DELIMITER ;

CALL dump_xml_por_data('2025-09-24','2025-09-24');

DROP PROCEDURE IF EXISTS dump_xml_por_data;

CREATE PROCEDURE dump_xml_por_data(par_data_inicial DATE, par_data_final DATE)
BEGIN
    DECLARE this_id INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur1 CURSOR FOR 
        SELECT id 
        FROM xmlnfce 
        WHERE SUBSTRING(nfce_chave, 21, 2) = '65'
          AND DATE(data) BETWEEN par_data_inicial AND par_data_final;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO this_id;
        IF done THEN 
            LEAVE read_loop;
        END IF;

        SET @query = CONCAT(
            'SELECT arquivo FROM xmlnfce WHERE id=', this_id, 
            ' INTO DUMPFILE "/tmp/xmlnfce-id-', this_id, '.xml.zip"'
        );

        PREPARE write_file FROM @query;
        EXECUTE write_file;
        DEALLOCATE PREPARE write_file;
    END LOOP;
    CLOSE cur1;
END;

SELECT cupom
  FROM movcaixa
 where nfce_modelo = 65
       and status = '03'
       and cancelado = 'S'
 group by cupom, status;

SELECT cupom
       ,sum(valortot)
  FROM movcaixa
 where nfce_modelo = 65
       and status = '03'
       and cancelado = ''
 group by cupom, status;

SELECT * FROM xmlnfce x
where subString(nfce_chave,21,2)='65';