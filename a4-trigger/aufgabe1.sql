-- Aufgabe 1
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
END;


-- Test zu Aufgabe 1
INSERT INTO ausleihe (nutzer_id, medium_id) 
VALUES (2, 2); -- 2 ist das Python Buch davon ist nur eines im Bestand momentan soll den Bestand auf 0 bringen 

INSERT INTO ausleihe (nutzer_id, medium_id) 
VALUES (1, 2); -- jetzt will sich Anna(id=1) auch das buch ausborgen 
-- Es soll jetzt wenn diese Insert ausgeführt wird die Nachricht 
-- "Bestand zu nierdrig um Buch auszuleihen" kommen

-- Tatsächliches Ergebnis
-- sqlite3.IntegrityError: Bestand zu nierdrig um Buch auszuleihen