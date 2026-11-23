-- Augabenstellung
/*
Das System soll jede wichtige Änderung automatisch dokumentieren, etwa:

    Ausleihen oder Rückgaben,
    Mahnungen,
    das Löschen von Medien oder Nutzern.

Diese Informationen sollen später auswertbar sein, um Abläufe nachvollziehen zu können.
*/
--triggers
CREATE TRIGGER IF NOT EXISTS dokumentation_von_ausleihung
AFTER INSERT ON ausleihe
FOR EACH ROW
BEGIN
INSERT INTO system_log (aktion, info) VALUES ('ausleihe', 'ausleihe des artikels '  || (SELECT titel FROM medium WHERE NEW.medium_id = id));
END;

CREATE TRIGGER IF NOT EXISTS dokumentation_von_ausleihungsbeendung
AFTER UPDATE ON ausleihe
FOR EACH ROW
WHEN NEW.status != OLD.status AND NEW.status = 'beendet'
BEGIN
INSERT INTO system_log  (aktion, info) VALUES ('rueckgabe', 'rueckgabe des artikels ' || (SELECT titel FROM medium WHERE NEW.medium_id = id));
END;

CREATE TRIGGER IF NOT EXISTS dokumentation_von_mahnung
AFTER UPDATE ON ausleihe
FOR EACH ROW
WHEN NEW.status != OLD.status AND NEW.status = 'gemahnt'
BEGIN
INSERT INTO system_log (aktion, info) 
VALUES ('mahnung', 'mahnung and den benutzer' || (SELECT name FROM nutzer WHERE NEW.nutzer_id = id) || 'wegen des artikels ' || (SELECT titel FROM medium WHERE NEW.medium_id = id));
END;

CREATE TRIGGER IF NOT EXISTS medien_loeschung
AFTER DELETE ON medium
FOR EACH ROW
BEGIN
INSERT INTO system_log (aktion, info) VALUES ('entfernung von medium', 'loeschung des Artikels ' || OLD.titel);
END;


--test
-- Ausleihen-Ändeung
INSERT INTO ausleihe (id, nutzer_id, medium_id, status) VALUES (32, 1, 3, 'aktiv');

-- Rückgabe-Änderung
INSERT INTO ausleihe (id, nutzer_id, medium_id, status) VALUES (34, 1, 2, 'aktiv');

UPDATE ausleihe 
SET status = 'beendet'
WHERE id = 34;

-- Mahnungen
INSERT INTO ausleihe (id, nutzer_id, medium_id, status) VALUES (35, 1, 3, 'aktiv');

UPDATE ausleihe 
SET status = 'gemahnt'
WHERE id = 35;

-- Löschung von Medien
INSERT INTO medium (id, titel, typ, bestand) VALUES
(42, 'Per Anhalter durch die Galaxis', 'buch', 42);

DELETE FROM medium WHERE id = 42;

-- Löschung von Nutzern (Aufgabe 4)
INSERT INTO nutzer (id, name, konto_guthaben) VALUES 
(42, 'John Doe', 10.00);

DELETE FROM nutzer WHERE id = 42;

-- Übersicht 
SELECT aktion, info FROM system_log;

/*
│ aktion │ info │

│entfernung von benutzer | loeschung des Benutzers Jon Doe │

│ausleihe │ ausleihe des artikels Digitale Welten │

│ausleihe │ ausleihe des artikels Programmieren lernen mit Python │

│rueckgabe │ rueckgabe des artikels Programmieren lernen mit Python │

│ausleihe │ ausleihe des artikels Digitale Welten │

│ mahnung │ mahnung and den benutzerAnna Musterwegen des artikels Digitale Welten │

│entfernung von medium │ loeschung des Artikels Per Anhalter durch die Galaxis |
*/