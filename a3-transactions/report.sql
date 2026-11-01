-- Artikel, bei denen Nachbestellung nötig sind
SELECT *  FROM artikel
WHERE lagerbestand < mindestbestand;


-- Kunden mit zu Ende gehenden Kreditlimit 
SELECT * FROM kunde
WHERE aktueller_kredit > kreditlimit * 0.9;


-- heutiger Umsatz
SELECT SUM(gesamtwert) AS 'Heutiger Umsatz' FROM bestellung
WHERE date(datum) = date('now') AND NOT status = 'storniert';


-- Konsistenzprüfung
SELECT a.id, a.name, IIF(SUM(l.menge) = a.lagerbestand, 'Passt', 'Verschieden') AS 'Konsistenzprüfung' FROM lagerbewegung l
RIGHT JOIN artikel a ON l.artikel_id = a.id
GROUP BY l.artikel_id;
