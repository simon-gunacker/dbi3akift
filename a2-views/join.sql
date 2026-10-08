
SELECT sum(p.preis * bp.menge) AS gesamtpreis, k.vorname, k.nachname
FROM bestellposition as bp
LEFT JOIN produkt AS p ON
bp.produkt_id = p.id
LEFT JOIN bestellung AS b ON
bp.bestellung_id = b.id
LEFT JOIN kunde AS k ON
b.kunde_id = k.id
WHERE k.id = 1
GROUP BY bp.bestellung_id;


SELECT p.preis * bp.menge AS gesamtpreis, k.vorname, k.nachname, bp.bestellung_id
FROM bestellposition as bp
LEFT JOIN produkt AS p ON
bp.produkt_id = p.id
LEFT JOIN bestellung AS b ON
bp.bestellung_id = b.id
LEFT JOIN kunde AS k ON
b.kunde_id = k.id
WHERE bp.bestellung_id = 1
LIMIT 10;
