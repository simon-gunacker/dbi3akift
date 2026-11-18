CREATE TRIGGER trg_bestand_pruefen
BEFORE INSERT ON ausleihe
WHEN NEW.medium_id IS NOT NULL
BEGIN
    SELECT RAISE(ABORT, 'Kein Bestand mehr verfügbar')
    WHERE (SELECT bestand FROM medium WHERE id = NEW.medium_id) <= 0;
END;

CREATE TRIGGER trg_bestand_reduzieren
AFTER INSERT ON ausleihe
WHEN NEW.medium_id IS NOT NULL
BEGIN
    UPDATE medium SET bestand = bestand - 1 WHERE id = NEW.medium_id;
    INSERT INTO system_log (aktion, info) 
        VALUES (
            'Ausleihe', 
            'Medium ' || NEW.medium_id || ' ausgeliehen von Nutzer ' || NEW.nutzer_id
        );
END;
