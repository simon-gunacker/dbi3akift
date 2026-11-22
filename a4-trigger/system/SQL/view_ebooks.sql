-- View mit Name des Nutzers + Buchtitel
CREATE VIEW borrow_ebook AS
SELECT
    n.name,
    m.titel
FROM nutzer n
JOIN medium m
WHERE m.typ = 'ebook';

/*
Ausleihe auf oben beschriebene View; Man soll "INSERT ON borrow_ebook VALUES(name, titel)" schreiben können
*/
CREATE TRIGGER catch_borrow_ebook
INSTEAD OF INSERT ON borrow_ebook
BEGIN
    INSERT INTO ausleihe(
        nutzer_id,
        medium_id,
        startdatum,
        rueckgabedatum,
        status
    )
    VALUES(
        (SELECT id
        FROM nutzer
        WHERE name = NEW.name),
        (SELECT id
        FROM medium
        WHERE titel = NEW.titel),
        DATE('now'),
        DATE('now', '+14 day'),
        'aktiv'
    );
END;