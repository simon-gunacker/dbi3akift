# Überlege, welchen Vorteil eine solche View gegenüber einem direkten Zugriff auf die Tabelle haben kann.

Der wohl größte Vorteil ist hier der Datenschutz, da die Mitarbeiter des Onlineshops, die nur Zugriff auf diese View haben, keine Einsicht auf persönliche Daten wie Geburtsdatum oder Adresse erhalten. Des weiteren kann die Tabelle "Kunde" nicht über die View verändert werden, was Datenmanipulation verhindert.


# Erstelle eine weitere View, welche Informationen aus mehreren Tabellen so zusammenfasst, dass eine häufig benötigte Abfrage einfacher wird.

```sql
CREATE VIEW bestellungen_kunden_einsicht AS
SELECT
    b.id AS bestellnummer,
    b.kunde_id AS kundennummer,
    b.bestelldatum AS bestelldatum,
    b.status AS bestellstatus,
    k.vorname AS vorname,
    k.nachname AS nachname
FROM bestellung b
JOIN kunde k ON k.id = b.kunde_id;
´´´
Meine View erleichtert es, Bestellungen bestimmten Kundenzuzuordnen und deren Status einzusehen. Sollte der Support eine Anfrage zum Status einer Bestellung bekommen, in der weder die Kundennummer noch die Bestellnummer enthalten sind, kann man hier ganz einfach mit dem Namen filtern.

´´´sql
SELECT *
FROM bestellungen_kunden_einsicht
WHERE vorname = 'Max'
AND nachname = 'Mustermann'
ORDER BY bestelldatum DESC;
´´´

Ohne die View würde die Abfrage wie folgt aussehen.

´´´sql
SELECT
    b.id AS bestellnummer,
    b.kunde_id AS kundennummer,
    b.bestelldatum AS bestelldatum,
    b.status AS bestellstatus,
    k.vorname AS vorname,
    k.nachname AS nachname
FROM bestellung b
JOIN kunde k ON k.id = b.kunde_id
WHERE k.vorname = 'Max'
AND k.nachname = 'Mustermann'
ORDER BY b.bestelldatum DESC;

´´´
