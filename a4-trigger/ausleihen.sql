
--BEGIN TRANSACTION;üö
    CREATE TABLE IF NOT EXISTS var_ids (kunde_id INT, kunde_name TEXT, medium_id INT, medium_title TEXT, dauer INT);üö
    CREATE VIEW IF NOT EXISTS var_ids_view AS SELECT * FROM var_ids;üö

    CREATE TRIGGER IF NOT EXISTS nameresolution
    INSTEAD OF INSERT ON var_ids_view
    BEGIN
        INSERT INTO var_ids
        VALUES (
            COALESCE(new.kunde_id, (SELECT id FROM nutzer WHERE name = NEW.kunde_name)), new.kunde_name,
            COALESCE(new.medium_id, (SELECT id FROM medium WHERE titel = NEW.medium_title)), new.medium_title,
            new.dauer,
        );
    END;üö

    INSERT INTO var_ids_view(kunde_id, medium_id) VALUES(1, 1);üö

    UPDATE medium
    SET bestand = bestand - 1
    WHERE id = (SELECT medium_id FROM var_ids);üö

    INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum)
        SELECT kunde_id as nutzer_id, medium_id,
            CASE
                WHEN (SELECT typ FROM medium WHERE id = medium_id) = 'ebook' AND dauer > 0 AND dauer IS NOT NULL THEN DATE('now', '+' || dauer || 'days')
                ELSE DATE('now', '+14 day')
            END as rueckgabedatum
        FROM var_ids;üö




--COMMIT;

