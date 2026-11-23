BEGIN TRANSACTION;
    UPDATE ausleihe
    SET status = 'beendet'
    WHERE id = (SELECT id
                FROM ausleihe
                WHERE (status = 'aktiv' OR status = 'gemahnt')
                AND nutzer_id = (SELECT kunde_id FROM var_ids)
                AND medium_id = (SELECT medium_id FROM var_ids)
                AND (SELECT 1 FROM nutzer WHERE id = (SELECT kunde_id FROM var_ids)) AND (SELECT 1 FROM medium WHERE id = (SELECT medium_id FROM var_ids))
                ORDER by startdatum ASC
                LIMIT 1);
COMMIT;
