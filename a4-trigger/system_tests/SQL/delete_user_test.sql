/*
Testcase 1: Nutzer 3 anlegen, ein E-Book und ein physisches Buch ausborgen und wieder löschen
*/

-- Nutzer anlegen
INSERT INTO nutzer (name, konto_guthaben) VALUES 
('Emanuel Krieger', 100000.00);

/*
OUTPUT nutzer: 3|Emanuel Krieger|100000
*/

-- E-Book ausleihen mit Mahnung
INSERT INTO ausleihe(nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES(3, 3, (DATE('now', '-15 day')), (DATE('now', '-1 day')));

-- Ein physischen Buch ausleihen mit Mahnung
INSERT INTO ausleihe(nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES(3, 1, (DATE('now', '-15 day')), (DATE('now', '-1 day')));

/*
OUTPUT ausleihe:  7|3|3|2026-11-07|2026-11-21|aktiv
                8|3|1|2026-11-07|2026-11-21|aktiv
*/

-- User Löschen
DELETE FROM nutzer
WHERE id = 3;

/*
OUTPUT ausleihe:  8|3|1|2026-11-07|2026-11-21|aktiv

OUTPUT system_log: 13|Nutzerlöschung|Nutzer Emanuel Krieger mit der ID 3 wurde gelöscht.|2026-11-22 13:01:38
*/