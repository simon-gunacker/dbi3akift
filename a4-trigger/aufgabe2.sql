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

CREATE TRIGGER IF NOT EXISTS neue_mahnung
AFTER UPDATE ON ausleihe
FOR EACH ROW
WHEN NEW.status = 'gemahnt' AND OLD.status != 'gemahnt'
BEGIN 

INSERT INTO mahnung (ausleihe_id, betrag) VALUES (NEW.id, 0.2);

END;

CREATE TRIGGER IF NOT EXISTS ausleihung_ueberschritten
AFTER INSERT ON system_log
FOR EACH ROW
WHEN NEW.aktion LIKE 'taegliche kontrolle'
BEGIN

UPDATE betrag FROM mahnung
SET betrag = betrag + 0.2
WHERE ausleihe_id IN (
    SELECT id FROM ausleihe
    WHERE status = 'gemahnt' OR status = 'gesperrt';
)

UPDATE ausleihe
SET status = 'gemahnt'
WHERE DATE('now') > rueckgabedatum AND status = 'aktiv';

END;






--test

--Ausleihe wird als gemahnt eingestuft und in "mahnung" eingetragen
INSERT INTO ausleihe (id, nutzer_id, medium_id, rueckgabedatum) VALUES (12, 2, 3, '2026-11-12');

SELECT * FROM ausleihe
WHERE rueckgabedatum = '2026-11-12';

INSERT INTO system_log (aktion) VALUES ('taegliche kontrolle');

SELECT * FROM ausleihe
WHERE rueckgabedatum = '2026-11-12';

SELECT * FROM mahnung 
WHERE id = 12;












