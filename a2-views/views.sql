-- 3. Vereinfachte Sicht auf kunde (ohne Geburtsdatum, Telefon, Adresse)
CREATE VIEW v_kunden_kontakt AS
SELECT
    id AS kundennummer,
    vorname,
    nachname,
    email
FROM kunde;

-- 4. Gesamtwert jeder Bestellung
CREATE VIEW v_bestellung_gesamtwert AS
SELECT
    b.id AS bestellnummer,
    b.kunde_id AS kundennummer,
    SUM(bp.menge * p.preis) AS gesamtwert
FROM bestellung b
JOIN bestellposition bp ON b.id = bp.bestellung_id
JOIN produkt p ON bp.produkt_id = p.id
GROUP BY b.id, b.kunde_id;

-- 5. Vereinfachte Schnittstelle: Bestellung + Kundenname
CREATE VIEW v_bestelluebersicht AS
SELECT
    b.id AS bestellnummer,
    k.id AS kundennummer,
    b.bestelldatum,
    b.status AS bestellstatus,
    k.vorname,
    k.nachname
FROM bestellung b
JOIN kunde k ON b.kunde_id = k.id;

-- 6. Performance-Vergleich: letzte Bestellung je Kunde
CREATE VIEW letzte_bestellung_a AS
SELECT
    b.kunde_id,
    b.id AS bestellung_id,
    b.bestelldatum
FROM bestellung b
WHERE b.bestelldatum = (
    SELECT MAX(b2.bestelldatum)
    FROM bestellung b2
    WHERE b2.kunde_id = b.kunde_id
);

CREATE VIEW letzte_bestellung_b AS
SELECT
    b.kunde_id,
    b.id AS bestellung_id,
    b.bestelldatum
FROM bestellung b
JOIN (
    SELECT
        kunde_id,
        MAX(bestelldatum) AS bestelldatum
    FROM bestellung
    GROUP BY kunde_id
) letzte
    ON letzte.kunde_id = b.kunde_id
   AND letzte.bestelldatum = b.bestelldatum;