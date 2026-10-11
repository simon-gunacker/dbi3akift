-- Aufgabe 3
DROP VIEW IF EXISTS kontakt_kunde;
CREATE VIEW kontakt_kunde AS SELECT id AS kundennummer, vorname, nachname, email
                      FROM kunde; 

--Aufgabe 4
DROP VIEW IF EXISTS gesamt_wert;
CREATE VIEW gesamt_wert AS SELECT b.id AS bestellnummer, b.kunde_id AS kundennummer, ROUND(SUM(bp.menge * p.preis), 2) AS gesamt
                           FROM bestellung b
                           LEFT JOIN bestellposition bp ON bp.bestellung_id = b.id
                           LEFT JOIN produkt p ON p.id = bp.produkt_id
                           GROUP BY b.id;

--Aufgabe 5
DROP VIEW IF EXISTS bestell_uebersicht;
CREATE VIEW bestell_uebersicht AS SELECT b.id AS bestellnummer, b.kunde_id AS kundennummer, b.bestelldatum, b.status AS bestellstatus, k.vorname, k.nachname
                 FROM bestellung b
                 LEFT JOIN kunde k ON b.kunde_id = k.id;

-- Überlege dir anschließend eine konkrete Abfrage, 
-- bei der diese View die eigentliche SQL-Abfrage deutlich übersichtlicher macht.
SELECT *
FROM bestell_uebersicht
WHERE bestellstatus = "offen"
ORDER BY bestelldatum
LIMIT 10;

-- Aufgabe 6
--Variante A
DROP VIEW IF EXISTS letzte_bestellung_a;
CREATE VIEW letzte_bestellung_a AS SELECT
                    b.kunde_id,
                    b.id AS bestellung_id,
                    b.bestelldatum
                FROM bestellung b
                WHERE b.bestelldatum = (
                    SELECT MAX(b2.bestelldatum)
                    FROM bestellung b2
                    WHERE b2.kunde_id = b.kunde_id
                    AND b2.id <= 10000
                )
                AND b.id <= 10000;

-- Variante B
DROP VIEW IF EXISTS letzte_bestellung_b;
CREATE VIEW letzte_bestellung_b AS SELECT 
                                        b.kunde_id,
                                        b.id AS bestellung_id,
                                        b.bestelldatum
                                    FROM bestellung b
                                    JOIN (
                                        SELECT
                                            kunde_id,
                                            MAX(bestelldatum) AS bestelldatum
                                        FROM bestellung
                                        WHERE id <= 10000  
                                        GROUP BY kunde_id
                                    ) letzte
                                        ON letzte.kunde_id = b.kunde_id
                                        AND letzte.bestelldatum = b.bestelldatum
                                    WHERE b.id <= 10000;
