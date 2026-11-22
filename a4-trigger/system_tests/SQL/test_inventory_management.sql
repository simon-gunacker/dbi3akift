/*
Testcase 1: Zwei verschiede Nutzer wollen hintereinander das selbe Buch (Bestand nur 1) ausleihen
*/


-- Der 1. Nutzer kann das Buch ausleihen, da Bestand = 1
INSERT INTO ausleihe(nutzer_id, medium_id)
VALUES(1, 2);

-- Der 2. Nutzer kann das Buch nicht ausleihen, da Bestand = 0
INSERT INTO ausleihe(nutzer_id, medium_id)
VALUES(2, 2);
