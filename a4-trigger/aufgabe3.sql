--Aufgabe 3

CREATE VIEW ebook_ausleihe AS
SELECT n.name  AS nutzername, m.titel AS titel,
    CAST(julianday(a.rueckgabedatum) - julianday(a.startdatum) AS INTEGER) AS dauer
FROM ausleihe a
JOIN nutzer n ON n.id = a.nutzer_id
JOIN medium m ON m.id = a.medium_id
WHERE m.typ = 'ebook';

CREATE TRIGGER ebook_ausleihe_einfuegen
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

-- Anna borgt sich ein e-book für 5 Tage
INSERT INTO ebook_ausleihe (nutzername, titel, dauer)
VALUES ('Anna Muster', 'Digitale Welten', 5);

-- Erwartet: neue Ausleihe mit nutzer_id 1, medium_id 3,
-- startdatum heute und rueckgabedatum heute + 5 Tage
SELECT * FROM ausleihe;

-- Erwartet: Anna Muster | Digitale Welten | 5
SELECT * FROM ebook_ausleihe;

-- und wenn zB der Titel falsch ist dann sol es einen Error geben
-- Erwartet: Fehler "Kein E-Book mit diesem Titel gefunden"
INSERT INTO ebook_ausleihe (nutzername, titel, dauer)
VALUES ('Anna Muster', 'Der Zauberberg', 7);