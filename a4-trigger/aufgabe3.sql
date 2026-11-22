--Aufgabe 3
CREATE VIEW IF NOT EXISTS ebook_ausleihe AS
SELECT n.name  AS nutzername, m.titel AS titel,
    CAST(julianday(a.rueckgabedatum) - julianday(a.startdatum) AS INTEGER) AS dauer
FROM ausleihe a
JOIN nutzer n ON n.id = a.nutzer_id
JOIN medium m ON m.id = a.medium_id
WHERE m.typ = 'ebook';

CREATE TRIGGER IF NOT EXISTS ebook_ausleihe_einfuegen
INSTEAD OF INSERT ON ebook_ausleihe 
FOR EACH ROW
BEGIN
    -- nur ebooks sind erlaubt
    SELECT RAISE (ABORT, 'Kein E-Book mit diesem Titel gefunden')
    WHERE NOT EXISTS (SELECT 1 FROM medium
                      WHERE titel = NEW.titel AND typ = 'ebook');
    
    -- der Nutzer muss existieren 
    SELECT RAISE (ABORT, 'Nutzer nicht gefunden')
    WHERE NOT EXISTS (SELECT 1 FROM nutzer WHERE name = NEW.nutzername);
    
    --ausfüllen der fehlenden Daten
    INSERT INTO ausleihe (nutzer_id, medium_id, rueckgabedatum)
    VALUES (
        (SELECT id FROM nutzer WHERE name = NEW.nutzername),
        (SELECT id FROM medium WHERE titel = NEW.titel AND typ = 'ebook'),
        DATE('now', '+' || NEW.dauer || ' day')
    );

END;

-- Test von Aufgabe 3
-- Erwartet wir einmal das sich die Daten die fehlen eingetragen werden 

-- Anna borgt sich ein e-book für 4 Tage
INSERT INTO ebook_ausleihe (nutzername, titel, dauer)
VALUES ('Anna Muster', 'Digitale Welten', 5);
SELECT * FROM ausleihe;       

-- id  nutzer_id  medium_id  startdatum  rueckgabedatum  status 
-- --  ---------  ---------  ----------  --------------  -------
-- 1   2          2          2026-11-21  2026-12-05      gemahnt
-- 2   1          3          2026-11-21  2026-11-26      aktiv  

SELECT * FROM ebook_ausleihe; 
-- nutzername   titel            dauer
-- -----------  ---------------  -----
-- Anna Muster  Digitale Welten  5  

-- und wenn zB der Titel falsch ist dann sol es einen Error geben
-- "Kein E-Book mit diesem Titel gefunden"

INSERT INTO ebook_ausleihe (nutzername, titel, dauer)
VALUES ('Anna Muster', 'Der Zauberberg', 7);

--sqlite3.IntegrityError: Kein E-Book mit diesem Titel gefunden