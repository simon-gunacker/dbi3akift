    CREATE TEMP TABLE var_ids (kunde_id INT NOT NULL, medium_id INT NOT NULL, dauer INT);
    INSERT INTO temp.var_ids (kunde_id, medium_id, dauer)
    VALUES(
    COALESCE(?, (SELECT id FROM nutzer WHERE name = ?)),
    COALESCE(?, (SELECT id FROM medium WHERE titel = ?)),
    ?
    )
