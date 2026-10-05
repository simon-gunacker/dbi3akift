SELECT 'kunde' AS tabelle, COUNT(*) AS anzahl FROM kunde
UNION ALL
SELECT 'product', COUNT(*) FROM product
UNION ALL
SELECT 'bestellung', COUNT(*) FROM bestellung
UNION ALL
SELECT 'bestellposition', COUNT(*) FROM bestellposition;


SELECT * FROM view_kunde;

SELECT * FROM view_bestellung_gesamtwert;

SELECT * FROM view_vereinfachte_schnittstelle;

.headers on
.mode column

SELECT *
FROM letzte_bestellung_a
WHERE kunde_id = 42;

SELECT *
FROM letzte_bestellung_b
WHERE kunde_id = 42;