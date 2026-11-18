SELECT '--- Testfall 1 ---' AS 'Testing';
-- ============================================================
-- Testfall 1: Bestand wird bei Ausleihe reduziert
-- Erwartung: Bestand von "Der Zauberberg" sinkt von 3 auf 2
-- ============================================================
SELECT 'Bestand vorher:' AS info;
SELECT titel, bestand FROM medium WHERE titel = 'Der Zauberberg';

INSERT INTO ausleihe (nutzer_id, medium_id)
SELECT id, (SELECT id FROM medium WHERE titel = 'Der Zauberberg')
FROM nutzer WHERE name = 'Anna Muster';

SELECT 'Bestand nachher:' AS info;
SELECT titel, bestand FROM medium WHERE titel = 'Der Zauberberg';

SELECT '--- Testfall 2 ---' AS 'Testing';
-- ============================================================
-- Testfall 2: Mahnung wird erstellt und Guthaben abgezogen
-- Erwartung: Neue Zeile in mahnung, Guthaben von Anna sinkt um 2.50
-- ============================================================
UPDATE ausleihe SET status = 'gemahnt' WHERE id = (SELECT MAX(id) FROM ausleihe);

SELECT * FROM mahnung;
SELECT name, konto_guthaben FROM nutzer WHERE name = 'Anna Muster';

SELECT '--- Testfall 3 ---' AS 'Testing';
-- ============================================================
-- Testfall 3: E-Book-Ausleihe über die View
-- Erwartung: Neue Ausleihe mit korrektem Rückgabedatum
-- ============================================================
INSERT INTO v_ebook_ausleihe (name, titel, dauer)
VALUES ('Ben Beispiel', 'Digitale Welten', 7);

SELECT a.id, n.name, m.titel, a.rueckgabedatum
FROM ausleihe a
JOIN nutzer n ON n.id = a.nutzer_id
JOIN medium m ON m.id = a.medium_id
WHERE m.typ = 'ebook';
