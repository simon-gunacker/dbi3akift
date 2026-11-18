SELECT '--- Logging ---' AS 'Trigger erstellen';

CREATE TRIGGER trg_log_medium_delete
BEFORE DELETE ON medium
BEGIN
    INSERT INTO system_log (aktion, info) VALUES 
        ('Medium gelöscht', 'Medium ' || OLD.titel || ' (ID ' || OLD.id || ') gelöscht');
END;

