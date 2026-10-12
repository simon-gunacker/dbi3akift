#erste View

CREATE VIEW IF NOT EXISTS kunden_oeffentlich AS
SELECT id, vorname, nachname, email
FROM kunde;

