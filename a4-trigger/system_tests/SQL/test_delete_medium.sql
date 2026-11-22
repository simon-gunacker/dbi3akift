/*
Testcase 1: Neues Medium anlegen und löschen
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