DROP VIEW IF EXISTS kontakt_kunde;
CREATE VIEW kontakt_kunde AS SELECT id AS kundennummer, vorname, nachname, email
                      FROM kunde; 