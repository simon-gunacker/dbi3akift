SELECT 'kunde' AS tabelle, COUNT(*) AS anzahl FROM kunde
UNION ALL
SELECT 'product', COUNT(*) FROM product
UNION ALL
SELECT 'bestellung', COUNT(*) FROM bestellung
UNION ALL
SELECT 'bestellposition', COUNT(*) FROM bestellposition;
