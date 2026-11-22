CREATE TRIGGER return_medium
AFTER UPDATE OF status ON ausleihe
WHEN NEW.status = 'beendet'
BEGIN
    UPDATE medium
    SET bestand = bestand + 1
    WHERE id = NEW.medium_id
    AND typ = 'buch';

    INSERT INTO system_log(aktion, info)
    VALUES(
        'Rueckgabe', 'Medium ' || NEW.medium_id || ' wurde von Nutzer ' || NEW.nutzer_id || ' zurueckgegeben'
    );
END;