CREATE VIEW view_kunde AS
SELECT 
    id AS kundennummer,
    vorname,
    nachname,
    email
FROM kunde;
--eingeschränkter datenzugriff (Datenschutz)
