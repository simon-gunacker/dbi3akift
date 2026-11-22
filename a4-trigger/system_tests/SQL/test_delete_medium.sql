/*
Testcase 1: Mahnung Loggen; Neues Medium anlegen und löschen
*/

-- Nutzer anlegen, der genung Geld hat
INSERT INTO nutzer (name, konto_guthaben) VALUES 
('Emanuel Krieger', 100000.00);

-- Nutzer hat ein Buch vor 15 Tagen ausgeliehen und noch nicht zurückgebracht
INSERT INTO ausleihe(nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES(4, 3, (DATE('now', '-15 day')), (DATE('now', '-1 day')));

/*
OUTPUT system_log: 16|Mahnung|Die Ausleihung mit der ID 9 wurde nicht rechtzeitig zurückgebracht.|2026-11-22 13:32:41
*/

-- Neues Medium mit 0 Bestand, da der Bestand, für das Logging, irrelevant ist
INSERT INTO medium (titel, typ) VALUES 
('Der Herr der Ringe: Die Gefährten', 'buch');

/*
OUTPUT system_log: 14|Medienergänzung|Medium Der Herr der Ringe: Die Gefährten mit der ID 4 wurde mit dem Bestand 0 hinzugefügt.|2026-11-22 13:20:23
*/

-- Buch löschen
DELETE FROM medium
WHERE id = 4;

/*
OUTPUT system_log: 15|Medienlöschung|Medium Der Herr der Ringe: Die Gefährten mit der ID 4 wurde gelöscht.|2026-11-22 13:21:04
*/