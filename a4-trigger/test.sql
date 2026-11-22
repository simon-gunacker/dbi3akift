-- A1 Bestand sinkt bei Ausleihe
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (1, 2); -- erwartet: bestand medium 2 = 0
-- ergebnis: ausleihe angelegt
SELECT bestand FROM medium WHERE id = 2;
-- ergebnis: 0

-- A2 Ausleihe bei Bestand 0 abgelehnt
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (2, 2); -- erwartet: fehler Bestand nicht ausreichend
-- ergebnis: fehler, wie erwartet

-- A3 E-Book-Ausleihe ändert Bestand nicht
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (2, 3); -- erwartet: bestand medium 3 = 9999
-- ergebnis: ausleihe angelegt
SELECT bestand FROM medium WHERE id = 3;
-- ergebnis: 9999

-- A4 Rückgabe erhöht Bestand und wird geloggt
UPDATE ausleihe SET status = 'beendet' WHERE id = 1; -- erwartet: bestand medium 2 = 1, Log RUECKGABE
-- ergebnis: status ist beendet
SELECT bestand FROM medium WHERE id = 2;
-- ergebnis: 1
SELECT * FROM system_log WHERE aktion = 'RUECKGABE';
-- ergebnis: ein eintrag rueckgabe, ausleihe 1 beendet

-- A5 Zweites 'beendet' erhöht Bestand nicht erneut
UPDATE ausleihe SET status = 'beendet' WHERE id = 1; -- erwartet: bestand medium 2 = 1
-- ergebnis: bestand bleibt gleich
SELECT bestand FROM medium WHERE id = 2;
-- ergebnis: 1

-- A6 Überfällige Ausleihe wird automatisch gemahnt
INSERT INTO ausleihe (nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES (1, 1, DATE('now', '-30 day'), DATE('now', '-16 day')); -- erwartet: Mahnung 1.00 für Ausleihe 3, Status gemahnt
-- ergebnis: ausleihe 3 angelegt, mahnung kommt automatisch
SELECT * FROM mahnung;
-- ergebnis: mahnung 1 für ausleihe 3, betrag 1.00
SELECT status FROM ausleihe WHERE id = 3;
-- ergebnis: gemahnt

-- A7 Mahnung mit Betrag 0 abgelehnt
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (3, 0); -- erwartet: fehler Betrag muss > 0
-- ergebnis: fehler, wie erwartet

-- A8 Mahnung mit negativem Betrag abgelehnt
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (3, -5); -- erwartet: fehler Betrag muss > 0
-- ergebnis: fehler, wie erwartet

-- A9 Mahngebühr wird sofort abgezogen, Guthaben wird negativ
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (3, 10); -- erwartet: konto_guthaben Anna = -1.00
-- ergebnis: mahnung angelegt
SELECT konto_guthaben FROM nutzer WHERE id = 1;
-- ergebnis: -1.00

-- A10 Negatives Guthaben sperrt neue Ausleihe
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (1, 1); -- erwartet: fehler Guthaben negativ
-- ergebnis: fehler, wie erwartet

-- A11 Sperre betrifft nur diesen Nutzer
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (2, 1); -- erwartet: Ausleihe OK, bestand medium 1 = 1
-- ergebnis: ausleihe angelegt
SELECT bestand FROM medium WHERE id = 1;
-- ergebnis: 1

-- A12 E-Book-Eingabe ergänzt Datum und Rückgabedatum
INSERT INTO ebook_ausleihe_eingabe (nutzer_name, titel, dauer_tage)
VALUES ('Ben Beispiel', 'Digitale Welten', 7); -- erwartet: rueckgabedatum = heute + 7 Tage
-- ergebnis: ausleihe über view angelegt
SELECT * FROM ausleihe ORDER BY id DESC LIMIT 1;
-- ergebnis: ausleihe 5, start heute, rückgabe in 7 tagen, status aktiv

-- A13 Unbekannter Nutzer abgelehnt
INSERT INTO ebook_ausleihe_eingabe (nutzer_name, titel, dauer_tage)
VALUES ('Max Unbekannt', 'Digitale Welten', 7); -- erwartet: fehler Nutzer nicht gefunden
-- ergebnis: fehler, wie erwartet

-- A14 Unbekanntes E-Book abgelehnt
INSERT INTO ebook_ausleihe_eingabe (nutzer_name, titel, dauer_tage)
VALUES ('Ben Beispiel', 'Der Zauberberg', 7); -- erwartet: fehler E-Book nicht gefunden
-- ergebnis: fehler, wie erwartet

-- A15 Nutzer löschen entfernt offene Ausleihen und Mahnungen
DELETE FROM nutzer WHERE id = 1; -- erwartet: keine offenen Ausleihen von Nutzer 1, keine Mahnungen zu Ausleihe 3
-- ergebnis: nutzer 1 gelöscht
SELECT * FROM ausleihe WHERE nutzer_id = 1 AND status != 'beendet';
-- ergebnis: keine zeilen
SELECT * FROM mahnung WHERE ausleihe_id = 3;
-- ergebnis: keine zeilen
SELECT * FROM system_log WHERE aktion = 'NUTZER_GELOESCHT';
-- ergebnis: eintrag mit nutzer 1 (anna muster) gelöscht
-- hinweis: laut trigger wird auch die beendete ausleihe 1 gelöscht, geprüft habe ich das nicht

-- A16 Medium löschen wird geloggt
DELETE FROM medium WHERE id = 2; -- erwartet: Log MEDIUM_GELOESCHT
-- ergebnis: medium 2 gelöscht
SELECT * FROM system_log WHERE aktion = 'MEDIUM_GELOESCHT';
-- ergebnis: eintrag mit medium 2 (test)
