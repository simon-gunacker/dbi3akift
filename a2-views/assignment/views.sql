CREATE VIEW kundeninfo AS
    SELECT id AS kundennummer, vorname, nachname, email
    FROM kunde;