CREATE VIEW view_kunde AS
SELECT 
    id AS kundennummer
    ,vorname
    ,nachname
    ,email
FROM kunde;
--eingeschränkter datenzugriff (Datenschutz)


CREATE VIEW view_bestellung_gesamtwert AS
SELECT 
    b.id AS bestellnummer
    ,b.kunde_id AS kundennummer
    ,SUM(bp.menge * p.preis) AS gesamtwert
FROM bestellung b
JOIN bestellposition bp ON b.id = bp.bestellung_id
JOIN product p ON bp.produkt_id = p.id
GROUP BY b.id, b.kunde_id;

CREATE VIEW view_vereinfachte_schnittstelle AS
SELECT 
     b.id AS bestellnummer
    ,k.id AS kundennummer
    ,b.bestelldatum
    ,b.status AS bestellstatus
    ,k.vorname
    ,k.nachname
FROM bestellung b
JOIN kunde k ON b.kunde_id= k.id

