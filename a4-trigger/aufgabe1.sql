-- Augabenstellung
/*
Wenn jemand ein Medium ausleiht, soll der verfügbare Bestand dieses Mediums automatisch angepasst werden. 
Es darf nicht vorkommen, dass mehr Exemplare ausgeliehen werden, als tatsächlich vorhanden sind.
*/

--triggers

CREATE TRIGGER IF NOT EXISTS medium_ausleihe_ueberschritten
BEFORE INSERT ON ausleihe
FOR EACH ROW
WHEN (SELECT bestand FROM medium  WHERE NEW.medium_id = medium.id) <= 0
BEGIN
SELECT RAISE(ABORT, 'Dieser Artikel ist derzeit nicht verfuegbar');
END;

CREATE TRIGGER IF NOT EXISTS medium_weniger_ausleihe
AFTER INSERT ON ausleihe
FOR EACH ROW 
WHEN NEW.status = 'aktiv'
BEGIN 
UPDATE medium 
SET bestand = bestand -1
WHERE NEW.medium_id = id;
END;

CREATE TRIGGER IF NOT EXISTS medium_mehr_rueckgabe
AFTER UPDATE ON ausleihe
FOR EACH ROW 
WHEN OLD.status != 'beendet' AND NEW.status = 'beendet'
BEGIN 
UPDATE medium 
SET bestand = bestand + 1
WHERE NEW.medium_id = id;
END;

--test

SELECT id, bestand FROM medium WHERE id = 2;

/*
id | bestand
2 | 1
*/

INSERT INTO ausleihe (nutzer_id, medium_id)
VALUES (1, 2);

SELECT id, bestand FROM medium WHERE id = 2;

/*
id | bestand
2 | 0
*/


INSERT INTO ausleihe (nutzer_id, medium_id)
VALUES (2, 2);

/*
Error near line [number]: Dieser Artikel ist derzeit nicht verfuegbar
*/

UPDATE ausleihe 
SET status = 'beendet'
WHERE nutzer_id = 1 AND medium_id = 2;

SELECT id, bestand FROM medium WHERE id = 2;

/*
id | bestand
2 | 1
*/

