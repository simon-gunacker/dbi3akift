SELECT '--- Nutzer löschen ---' AS 'Trigger erstellen';

CREATE TRIGGER trg_nutzer_loeschen
BEFORE DELETE ON nutzer
BEGIN
    DELETE FROM mahnung WHERE ausleihe_id IN (
        SELECT id FROM ausleihe WHERE nutzer_id = OLD.id
    );

    DELETE FROM ausleihe WHERE nutzer_id = OLD.id;

    INSERT INTO system_log (aktion, info) VALUES 
        ('Nutzer gelöscht', 'Nutzer ' || OLD.name || ' (ID ' || OLD.id || ') inkl. Ausleihen/Mahnungen entfernt');
END;

