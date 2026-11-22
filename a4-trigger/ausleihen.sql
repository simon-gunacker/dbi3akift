BEGIN TRANSACTION;
    UPDATE medium
    SET bestand = bestand - 1
    WHERE id = (SELECT medium_id FROM var_ids);

    INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum)
        SELECT kunde_id, medium_id,
            CASE
                WHEN (SELECT typ FROM medium WHERE id = medium_id) = 'ebook' AND dauer > 0 AND dauer IS NOT NULL THEN DATE('now', '+' || dauer || ' days')
                ELSE DATE('now', '+14 day')
            END as rueckgabedatum
        FROM var_ids;

COMMIT;

