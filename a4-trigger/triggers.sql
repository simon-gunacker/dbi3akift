CREATE TRIGGER IF NOT EXISTS bestandsprüfung_medium
BEFORE UPDATE ON medium
BEGIN
    SELECT RAISE(ROLLBACK, 'Bestand zu niedrig')
    WHERE NEW.bestand = 0;
END;


CREATE TRIGGER IF NOT EXISTS mahnung
AFTER UPDATE ON ausleihe
WHEN NEW.status = 'gemahnt'
BEGIN
    INSERT INTO mahnung (ausleihe_id, betrag)
    VALUES(NEW.id, 5)

      /* UPDATE mahnung
       SET betrag = (julianday('now') - julianday(NEW.rueckgabedatum))
       WHERE ausleihe_id = NEW.id;*/

    UPDATE nutzer
    SET kontoguthaben = kontoguthaben - 5
    WHERE id = NEW.nutzer_id

    INSERT INTO systemlog(aktion, info)
    VALUES('Mahnung', 'Nutzer mit ID: 'NEW.nutzer_id || ' wurde gemahnt für ' || 5 || '€');
END;

CREATE TRIGGER IF NOT EXISTS sperrprüfung_ausleihe
BEFORE INSERT ON ausleihe
BEGIN
    SELECT RAISE(ROLLBACK, 'Nutzer gesperrt')
    WHERE (SELECT 1 FROM nutzer WHERE id = NEW.nutzer_id AND kontoguthaben < 0);
END;


CREATE TRIGGER IF NOT EXISTS log_ausleihe
AFTER INSERT ON ausleihe
BEGIN
    INSERT INTO systemlog(aktion, info)
    VALUES('Ausleihe', 'Nutzer mit ID: 'NEW.nutzer_id || ' leit Medium mit ID: ' || NEW.medium_id || ' aus bis zum ' || NEW.rueckgabedatum || ' .');
END;


CREATE TRIGGER IF NOT EXISTS log_rueckgabe
AFTER UPDATE ON ausleihe
WHEN NEW.status = 'beendet'
BEGIN
    UPDATE medium
    SET bestand = bestand + 1
    WHERE id = NEW.medium_id;

    INSERT INTO systemlog(aktion, info)
    VALUES('Rueckgabe', 'Nutzer mit ID: 'NEW.nutzer_id || ' gab Medium mit ID: ' || NEW.medium_id || ' zurück.');
END;


CREATE TRIGGER IF NOT EXISTS sperrung_nutzer
AFTER UPDATE ON nutzer
WHEN NEW.kontoguthaben < 0
BEGIN
    UPDATE ausleihe
    SET status = 'gesperrt'
    WHERE nutzer_id = NEW.id AND status = 'gemahnt'

    INSERT INTO systemlog(aktion, info)
    VALUES('Sperrung', 'Nutzer mit ID: 'NEW.nutzer_id || ' wurde fürs Überziehen gesperrt');
END;



CREATE TRIGGER IF NOT EXISTS delete_user
AFTER DELETE ON nutzer
BEGIN

END;
