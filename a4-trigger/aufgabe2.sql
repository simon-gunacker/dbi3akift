-- Augabenstellung
/*
Wird eine Ausleihe überfällig, soll automatisch eine Mahnung im System erfasst werden. 
Gleichzeitig soll dem betroffenen Nutzer der entsprechende Betrag sofort vom Guthaben abgezogen werden. 
Wird das Guthaben dadurch negativ, darf der Nutzer vorerst keine neuen Ausleihen mehr tätigen.
*/

-- zusätzliche Notizen 
/*
Es gibt eine tägliche Mahngebühr von 20 Cent (Wie bei der Bibliothek der TU Graz)
*/

--triggers


--old
CREATE TRIGGER IF NOT EXISTS neue_mahnung
AFTER UPDATE ON ausleihe
FOR EACH ROW
WHEN NEW.status = 'gemahnt' AND OLD.status != 'gemahnt'
BEGIN 

INSERT INTO mahnung (ausleihe_id, betrag) VALUES (NEW.id, 0.2);

END; 

CREATE TRIGGER IF NOT EXISTS ausleihung_überschritten
AFTER INSERT ON system_log
FOR EACH ROW
WHEN NEW.action = 'taegliche kontrolle'
BEGIN

UPDATE ausleihe
SET status = 'gemahnt'
WHERE DATE('now') < rueckgabedatum AND status = 'aktiv';

UPDATE mahnung
SET betrag = betrag + 0.2;

UPDATE nutzer
SET konto_guthaben = konto_guthaben-0.2
WHERE id IN (
    SELECT nutzer_id
    FROM ausleihe
    WHERE status = 'gemahnt'
);

END;


CREATE TRIGGER IF NOT EXISTS mahnung_zu_sperre
BEFORE UPDATE ON nutzer
FOR EACH ROW
WHEN NEW.konto_guthaben < 0
BEGIN

UPDATE ausleihe 
SET status = 'gesperrt'
WHERE status = 'gemahnt' AND nutzer_id IN (
    SELECT id FROM nutzer 
    WHERE konto_guthaben < 0 AND status != 'gesperrt'
);

SELECT RAISE(ABORT, 'Nutzer wurde gesperrt aufgrund eines negativen Guthaben');

END;


CREATE TRIGGER IF NOT EXISTS neue_gemahnte_ausleihung
AFTER UPDATE ON ausleihe
FOR EACH ROW
WHEN NEW.status = 'gemahnt' AND OLD.status != 'gemahnt'
BEGIN 

INSERT INTO mahnung (ausleihe_id, betrag) VALUES (NEW.id, 0.2);

END; 


CREATE TRIGGER IF NOT EXISTS gesperrter_user_ausleihe
BEFORE INSERT ON ausleihe 
FOR EACH ROW
WHEN nutzer_id IN (
    SELECT nutzer_id FROM ausleihe
    WHERE status = 'gesperrt' 
)
BEGIN

SELECT RAISE(ABORT, 'Nutzer ist gesperrt aufgrund eines negativen Guthaben');

END;

--test
INSERT INTO ausleihe (nutzer_id, medium_id, rueckgabedatum) VALUES (2, 3, '2026-11-12');

SELECT * FROM ausleihe
WHERE rueckgabedatum = '2026-11-23';
