-- Augabenstellung
/*
Es darf nicht möglich sein, Mahngebühren mit 0 € oder negativen Beträgen zu erfassen.
*/

--triggers
CREATE TRIGGER IF NOT EXISTS plausible_mahngebuer_aenderungen
BEFORE UPDATE ON mahnung 
FOR EACH ROW 
WHEN New.betrag <= 0
BEGIN
SELECT RAISE(ABORT, 'Keine plausible Mahngebuehr');
END;

CREATE TRIGGER IF NOT EXISTS plausible_mahngebuer_erstellung
BEFORE INSERT ON mahnung 
FOR EACH ROW 
WHEN New.betrag <= 0
BEGIN
SELECT RAISE(ABORT, 'Keine plausible Mahngebuehr');
END;

--test

INSERT INTO mahnung (id, ausleihe_id, betrag) VALUES (42, 25, 4.60);

SELECT id, ausleihe_id, betrag FROM mahnung;

/*
id | ausleihe_id | betrag
42 | 25 | 4.6
*/

INSERT INTO mahnung (id, ausleihe_id, betrag) VALUES (43, 26, 0);

/*
near line [number]: Keine plausible Mahngebuehr
*/

INSERT INTO mahnung (id, ausleihe_id, betrag) VALUES (44, 26, -2);

/*
near line [number]: Keine plausible Mahngebuehr
*/

UPDATE mahnung
SET betrag = betrag - 5
WHERE id = 42;

/*
near line [number]: Keine plausible Mahngebuehr
*/