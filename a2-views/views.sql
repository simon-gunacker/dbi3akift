CREATE VIEW IF NOT EXISTS gesamtpreis_bestellung AS
SELECT sum(p.preis * bp.menge) AS gesamtpreis, k.id as kunde_id , bp.bestellung_id
FROM bestellposition as bp
LEFT JOIN produkt AS p ON
bp.produkt_id = p.id
LEFT JOIN bestellung AS b ON
bp.bestellung_id = b.id
LEFT JOIN kunde AS k ON
b.kunde_id = k.id
GROUP BY bp.bestellung_id;

CREATE VIEW IF NOT EXISTS join_view AS
SELECT *
FROM bestellposition as bp
LEFT JOIN produkt AS p ON
bp.produkt_id = p.id
LEFT JOIN bestellung AS b ON
bp.bestellung_id = b.id
LEFT JOIN kunde AS k ON
b.kunde_id = k.id;

