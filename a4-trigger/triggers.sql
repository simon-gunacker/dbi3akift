CREATE TRIGGER IF NOT EXISTS bestandsprüfung
BEFORE UPDATE ON medium
BEGIN
    SELECT RAISE(ROLLBACK, 'Bestand zu klein')
    WHERE NEW.bestand < 0;
END;
