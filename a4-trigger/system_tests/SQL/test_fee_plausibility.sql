/*
Testcase 1: Mahnung mit 0€ als Betrag
*/

-- Nutzer mit genug Geld anlegen
INSERT INTO nutzer (name, konto_guthaben) VALUES 
('Emanuel Krieger', 100000.00);

-- Eine normale Ausleihung anlegen
INSERT INTO ausleihe(nutzer_id, medium_id)
VALUES(4, 3);

-- Versuch eine Mahnung für die Ausleihung mit 0€ Mahngebühr anzulegen
INSERT INTO mahnung (ausleihe_id, betrag)
VALUES ((SELECT MAX(id) FROM ausleihe), 0);
/*
OUTPUT: Runtime error: Mahngebühr zu klein, bitte einen gültigen Betrag eingeben! (19)
*/