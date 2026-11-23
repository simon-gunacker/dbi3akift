-- Augabenstellung
/*
Für digitale Medien (E-Books) soll die Ausleihe besonders bequem funktionieren: 
Wenn ein Eintrag mit Nutzername, Titel und gewünschter Dauer gemacht wird, 
soll das System automatisch alle weiteren notwendigen Informationen ergänzen, 
sodass der Ausleihvorgang vollständig ist.
*/

--triggers
CREATE VIEW IF NOT EXISTS ebook AS 
SELECT n.name AS name, m.titel AS titel, NULL AS dauer_in_tagen FROM ausleihe a 
INNER JOIN nutzer n ON a.nutzer_id = n.id
INNER JOIN medium m ON a.medium_id = m.id
WHERE m.typ = 'ebook';

CREATE TRIGGER IF NOT EXISTS ebook_ausleihe
INSTEAD OF INSERT ON ebook
FOR EACH ROW 
BEGIN 

INSERT INTO ausleihe (nutzer_id, medium_id, rueckgabedatum)
VALUES ((
    SELECT id FROM nutzer
    WHERE name = NEW.name
    ), (
        SELECT id FROM medium
        WHERE titel = NEW.titel
    ), (date('now', '+' ||NEW.dauer_in_tagen|| ' day'))
    );

END;

--test

INSERT INTO ebook VALUES ('Anna Muster', 'Programmieren lernen mit Python', 2);

SELECT nutzer_id, medium_id, startdatum, rueckgabedatum, status FROM ausleihe
WHERE nutzer_id = 1;

/*
│ nutzer_id │ medium_id │ startdatum │ rueckgabedatum │ status │
│ 1 │ 2 │ 2026-11-23 │ 2026-11-25 │ aktiv │
*/


