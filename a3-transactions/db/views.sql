CREATE VIEW IF NOT EXISTS nachbestellung_noetig AS
    SELECT id, name, einkaufspreis, lagerbestand, mindestbestand
    FROM artikel
    WHERE lagerbestand < mindestbestand;

CREATE VIEW IF NOT EXISTS kreditlimit_hoch AS
    SELECT id, name, kreditlimit, aktueller_kredit
    FROM kunde
    WHERE aktueller_kredit > kreditlimit * 0.9 ;

CREATE VIEW IF NOT EXISTS tagesumsatz AS
    SELECT
        date(datum), SUM(gesamtwert) AS tagesumsatz
    FROM bestellung
    WHERE status != "storniert"
    AND date(datum) = date();

CREATE VIEW IF NOT EXISTS check_lagerbestand AS
    SELECT
        a.id AS artikel_id, a.name,
        a.lagerbestand - SUM(l.menge)
            AS lagerbestand_alt,
        SUM(l.menge) AS lagerbewegungen,
        a.lagerbestand AS lagerbestand_aktuell
    FROM artikel a
        JOIN lagerbewegung l
        ON a.id = l.artikel_id
    GROUP BY a.name
;
