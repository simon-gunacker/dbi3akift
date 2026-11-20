--BEGIN TRANSACTION;
    UPDATE ausleihe
    SET typ = 'beendet'
    WHERE id = (SELECT id
                FROM ausleihe
                WHERE typ = 'aktiv' OR 'gemahnt'
                AND nutzer_id = (SELECT kunde_id FROM var_ids)
                AND medium_id = (SELECT medium_id FROM var_ids)
                ORDER by startdatum ASC
                LIMIT 1);
--COMMIT;
