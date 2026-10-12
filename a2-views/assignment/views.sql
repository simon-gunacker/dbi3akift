-- mit .read in der database erzeugen

CREATE VIEW kundendaten_beschraenkte_einsicht AS
SELECT
    id AS kundennummer,
    vorname,
    nachname,
    email
FROM kunde;