-- Aufgabe 1
-- nach shema.sql und test_data.sql ausführen 
CREATE TRIGGER verfuegbarkeit_ausleihen
BEFORE INSERT ON ausleihe
FOR EACH ROW
BEGIN
    SELECT RAISE (ABORT, 'Bestand zu nierdrig um Buch auszuleihen')
    WHERE (
        SELECT bestand 
        FROM medium 
        WHERE id = NEW.medium_id ) <= 0;
END;

CREATE TRIGGER bestands_verringerung
AFTER INSERT ON ausleihe
FOR EACH ROW
BEGIN
    UPDATE medium SET bestand = bestand - 1
    WHERE id = NEW.medium_id;

    --Aufgabe 5
    INSERT INTO system_log (aktion, info)
    VALUES ('AUSLEIHE', (SELECT name
                                FROM nutzer
                                WHERE id = NEW.nutzer_id) || '-' || 
                                (SELECT titel
                                FROM medium
                                WHERE id = NEW.medium_id));
END;


-- Test zu Aufgabe 1

-- Erwartet: Bestand laut Testdaten (Zauberberg 3, Python 1, Digitale Welten 9999)
SELECT * FROM medium;

-- 2 ist das Python Buch davon ist nur eines im Bestand momentan soll den Bestand auf 0 bringen
INSERT INTO ausleihe (nutzer_id, medium_id) 
VALUES (2, 2);

-- Erwartet: Python Buch hat jetzt Bestand 0, die anderen bleiben gleich
SELECT * FROM medium;

-- jetzt will sich Anna(id=1) auch das buch ausborgen 
-- Erwartet: Fehler "Bestand zu nierdrig um Buch auszuleihen"
INSERT INTO ausleihe (nutzer_id, medium_id) 
VALUES (1, 2);

-- Erwartet: nur Bens Ausleihe ist in der Tabelle, Annas wurde nicht eingefügt
SELECT * FROM ausleihe;