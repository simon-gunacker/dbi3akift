SELECT '--- Ausleihe von E-Books ---' AS 'Trigger erstellen';

CREATE VIEW v_ebook_ausleihe AS
SELECT n.name, m.titel, 14 AS dauer
FROM nutzer n, medium m
WHERE 1=0;

CREATE TRIGGER trg_ebook_einfach
INSTEAD OF INSERT ON v_ebook_ausleihe
BEGIN
    INSERT INTO ausleihe (nutzer_id, medium_id, rueckgabedatum)
    SELECT n.id, m.id, DATE('now', '+' || NEW.dauer || ' day')
    FROM nutzer n
    JOIN medium m ON m.typ = 'ebook'
    WHERE n.name = NEW.name
    AND m.titel = NEW.titel;
END;

