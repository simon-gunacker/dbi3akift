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