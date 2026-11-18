CREATE TRIGGER trg_bestand_pruefen
BEFORE INSERT ON ausleihe
WHEN NEW.medium_id IS NOT NULL
BEGIN
    SELECT RAISE(ABORT, 'Kein Bestand mehr verfügbar')
    WHERE (SELECT bestand FROM medium WHERE id = NEW.medium_id) <= 0;
END;
