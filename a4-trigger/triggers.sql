CREATE TRIGGER IF NOT EXISTS bestandsprüfung_medium
BEFORE UPDATE ON medium
BEGIN
    SELECT RAISE(ROLLBACK, 'Bestand zu niedrig')
    WHERE NEW.bestand < 0;
END;


CREATE TRIGGER IF NOT EXISTS mahnung
AFTER UPDATE ON ausleihe
WHEN NEW.status = 'gemahnt' AND OLD.status = 'aktiv'
BEGIN
    INSERT INTO mahnung (ausleihe_id, betrag)
    VALUES(NEW.id, 5);

      /* UPDATE mahnung
       SET betrag = (julianday('now') - julianday(NEW.rueckgabedatum))
       WHERE ausleihe_id = NEW.id;*/

    UPDATE nutzer
    SET konto_guthaben = CASE
                            WHEN konto_guthaben - 5 < 0 THEN 0
                            ELSE konto_guthaben - 5
                         END
    WHERE id = NEW.nutzer_id;

    INSERT INTO system_log(aktion, info)
    VALUES('Mahnung', 'Nutzer mit ID: ' || NEW.nutzer_id || ' wurde gemahnt');
END;


CREATE TRIGGER IF NOT EXISTS sperrprüfung_ausleihe
BEFORE INSERT ON ausleihe
BEGIN
    SELECT RAISE(ROLLBACK, 'Nutzer gesperrt')
    WHERE (SELECT 1 FROM nutzer WHERE id = NEW.nutzer_id AND konto_guthaben = 0);
END;


CREATE TRIGGER IF NOT EXISTS log_ausleihe
AFTER INSERT ON ausleihe
BEGIN
    INSERT INTO system_log(aktion, info)
    VALUES('Ausleihe', 'Nutzer mit ID: ' || NEW.nutzer_id || ' leit Medium mit ID: ' || NEW.medium_id || ' aus bis zum ' || NEW.rueckgabedatum || '.');
END;


CREATE TRIGGER IF NOT EXISTS log_rueckgabe
AFTER UPDATE ON ausleihe
WHEN NEW.status = 'beendet'
BEGIN
    UPDATE medium
    SET bestand = bestand + 1
    WHERE id = NEW.medium_id;

    INSERT INTO system_log(aktion, info)
    VALUES('Rueckgabe', 'Nutzer mit ID: ' || NEW.nutzer_id || ' gab Medium mit ID: ' || NEW.medium_id || ' zurück.');
END;


CREATE TRIGGER IF NOT EXISTS sperrung_nutzer
AFTER UPDATE ON nutzer
WHEN NEW.konto_guthaben = 0 AND OLD.konto_guthaben < 5
BEGIN
    UPDATE ausleihe
    SET status = 'gesperrt'
    WHERE nutzer_id = NEW.id AND status = 'gemahnt';

    INSERT INTO system_log(aktion, info)
    VALUES('Sperrung', 'Nutzer mit ID: ' || NEW.id || ' wurde fürs Überziehen gesperrt');
END;


CREATE TRIGGER IF NOT EXISTS loeschung_ausleihe
BEFORE DELETE ON ausleihe
BEGIN
    INSERT INTO system_log(aktion, info)
    VALUES('Loeschung', 'Ausleihe mit ID: ' || OLD.id || ' wurde gelöscht');
END;


CREATE TRIGGER IF NOT EXISTS loeschung_mahnung
BEFORE DELETE ON mahnung
BEGIN
    INSERT INTO system_log(aktion, info)
    VALUES('Loeschung', 'Mahnung mit ID: ' || OLD.id || ' wurde mit einem Betrag von: ' || OLD.betrag || '€ gelöscht.');
END;


CREATE TRIGGER IF NOT EXISTS loeschung_nutzer
BEFORE DELETE ON nutzer
BEGIN
    DELETE FROM mahnung
    WHERE ausleihe_id IN (SELECT id FROM ausleihe WHERE nutzer_id = OLD.id);

    DELETE FROM ausleihe
    WHERE nutzer_id = OLD.id;

    INSERT INTO system_log(aktion, info)
    VALUES('Loeschung', 'Nutzer mit ID: ' || OLD.id || ' wurde gelöscht');
END;

