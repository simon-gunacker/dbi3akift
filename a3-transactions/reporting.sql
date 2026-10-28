-- Artikel die unter Mindestbestand gefallen sind (Nachbestellung nötig)
SELECT *
FROM artikel
WHERE lagerbestand < mindestbestand;

-- Kunden die ihr Kreditlimit fast ausgeschöpft haben (>90%)
SELECT *
FROM kunde 
WHERE aktueller_kredit > (kreditlimit * 90 / 100);

--Umsatz des heutigen Tages
SELECT SUM(gesamtwert)
FROM bestellung
WHERE date(datum) = date(CURRENT_TIMESTAMP);

-- Konsistenzprüfung: Stimmen Lagerbewegungen mit aktuellem Bestand überein?

SELECT artikel_id, SUM(menge)
FROM lagerbewegung
GROUP BY artikel_id;

SELECT a.id, a.name, a.lagerbestand, SUM(l.menge) AS bewegungen,
        a.lagerbestand - SUM(l.menge) AS startbestand
FROM artikel a
JOIN lagerbewegung l ON l.artikel_id = a.id
GROUP BY a.id;