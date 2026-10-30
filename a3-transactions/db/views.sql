CREATE VIEW nachbestellung_noetig AS
    SELECT id, name, einkaufspreis, lagerbestand, mindestbestand
    FROM artikel
    WHERE lagerbestand < mindestbestand;

CREATE VIEW kreditlimit_hoch AS
    SELECT id, name, kreditlimit, aktueller_kredit
    WHERE aktueller_kredit > kreditlimit * 0.9 ;

CREATE VIEW tagesumsatz AS
    SELECT
        datum, SUM(gesamtwert) AS tagesumsatz
    FROM bestellung
    WHERE status != "storniert"
    AND date(datum) = date();

-- CREATE VIEW check_lagerbestand AS
    SELECT
        a.id AS artikel_id, a.name,
        SUM(l.menge) AS summe_lagerbewegungen,
        (a.lagerbestand + SUM(l.menge))
            AS soll,
        a.lagerbestand AS ist
    FROM artikel a
        JOIN lagerbewegung l
        ON a.id = l.artikel_id
    GROUP BY a.name
;
