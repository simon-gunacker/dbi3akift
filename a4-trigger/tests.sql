.headers ON
.mode box
.read schema.sql
.read testdaten.sql
.read triggers.sql

---------------------------
-- 1. Bestandsverwaltung --
---------------------------

.print '--- 1.1 Normale Ausleihe - Bestand "Der Zauberberg" -1 ---'
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (1, 1);
SELECT id, titel, bestand FROM medium WHERE id = 1;

.print '--- 1.2 Letztes Exemplar ausleihen "Programmieren lernen mit Python" -1 ---'
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (1, 2);
SELECT id, titel, bestand FROM medium WHERE id = 2;

.print '--- 1.3 Ausleihe bei Bestand 0, es sollte Fehler kommen weil nichts mehr möglich ist ---'
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (2,2);
SELECT COUNT(*) AS anzahl_ausleihen FROM ausleihe;

.print '--- 1.4 Rückgabe vom Python Buch ---'
UPDATE ausleihe SET status = 'beendet' WHERE id = 2;
SELECT id, titel, bestand FROM medium WHERE id = 2;

---------------------------------------------------
-- 2. Überfällige Ausleihen und Mahngebühren     --
--    Mahngebühr fix 10.00 Euro             --
---------------------------------------------------

.print '--- 2.1 Annas Ausleihe (id 1) wird überfällig - Mahnung 10€ : Anna 0€ ---'
UPDATE ausleihe SET status = 'gemahnt' WHERE id = 1;
SELECT * FROM mahnung;
SELECT id, name, konto_guthaben FROM nutzer;

.print '--- 2.2 Anna nochmal mahnen - sollte keine 2. Mahnung gehen ---'
UPDATE ausleihe SET status = 'gemahnt' WHERE id = 1;
SELECT COUNT(*) AS anzahl_mahnungen FROM mahnung;
SELECT id, name, konto_guthaben FROM nutzer WHERE id = 1;

.print '--- 2.3 Ben leiht "Digitale Welten" aus und gibt es normal zurück - sollte keine mahnung bekommen ---'
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (2, 3);
UPDATE ausleihe SET status = 'beendet' WHERE id = 3;
SELECT COUNT(*) AS anzahl_mahnungen FROM mahnung;
SELECT id, name, konto_guthaben FROM nutzer WHERE id = 2;

.print '--- 2.4 Ben leiht "Der Zauberberg" aus, Rückgabefrist aber schon abgelaufen - Mahnung! ---'
INSERT INTO ausleihe (nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES (2, 1, DATE('now', '-30 day'), DATE('now', '-16 day'));
UPDATE ausleihe SET status = 'gemahnt' WHERE id = 4;
SELECT * FROM mahnung;
SELECT id, name, konto_guthaben FROM nutzer WHERE id = 2;

.print '--- 2.5 Ben (-5€), will "Digitale Welt" ausliehen, gesperrt, Fehler! ---'
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (2, 3);
SELECT COUNT(*) AS anzahl_ausleihen FROM ausleihe;

.print '--- 2.6 Anna (0€), leiht "Digitale Welt" aus - erlaubt ---'
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (1, 3);
SELECT COUNT(*) AS anzahl_ausleihen FROM ausleihe;