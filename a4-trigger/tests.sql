.headers ON
.mode box
.read schema.sql
.read testdaten.sql
.read triggers.sql

---------------------------
-- 1. Bestandsverwaltung --
---------------------------

-- Normale Ausleihe - Bestand 'Der Zauberberg' -1
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (1, 1);
SELECT id, titel, bestand FROM medium WHERE id = 1;

-- Letztes Exemplar ausleihen 'Programmieren lernen mit Python' -1
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (1, 2);
SELECT id, titel, bestand FROM medium WHERE id = 2;

-- Ausleihe bei Bestand 0, es sollte Fehler kommen weil nichts mehr möglich ist
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (2,2);
SELECT COUNT(*) AS anzahl_ausleihen FROM ausleihe;

-- Rückgabe vom Python Buch
UPDATE ausleihe SET status = 'beendet' WHERE id = 2;
SELECT id, titel, bestand FROM medium WHERE id = 2;
