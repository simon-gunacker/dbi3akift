# Überlege, welchen Vorteil eine solche View gegenüber einem direkten Zugriff auf die Tabelle haben kann.

Der wohl größte Vorteil ist hier der Datenschutz, da die Mitarbeiter des Onlineshops, die nur Zugriff auf diese View haben, keine Einsicht auf persönliche Daten wie Geburtsdatum oder Adresse erhalten. Des weiteren kann die Tabelle "Kunde" nicht über die View verändert werden, was Datenmanipulation verhindert.

Die größte Gefahr bei Views stellt wohl das Unwissen des Anwenders da. Wer die Struktur des Views nicht kennt, kann sich unmöglich sicher sein, dass er alle relevanten Daten aus der Datenbank bekommt oder die Ressourcen, die eine Abfrage der View benötigt, einschätzen kann.


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
```
Meine View erleichtert es, Bestellungen bestimmten Kundenzuzuordnen und deren Status einzusehen. Sollte der Support eine Anfrage zum Status einer Bestellung bekommen, in der weder die Kundennummer noch die Bestellnummer enthalten sind, kann man hier ganz einfach mit dem Namen filtern.

```sql
SELECT *
FROM bestellungen_kunden_einsicht
WHERE vorname = 'Max'
AND nachname = 'Mustermann'
ORDER BY bestelldatum DESC;
```

Ohne die View würde die Abfrage wie folgt aussehen.

```sql
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
```

# Views und Performance
Beide Views liefern das exakt gleiche Ergebnis.
Ich habe den Select von beiden Views 1000 mal abgefragt und bin zu folgenden Ergebnissen gekommen.
Mit View A benötigt der Selekt durchschnittlich 85,4336 Sekunden um 1000 mal abgefragt zu werden. Mit View B benötigt der Selekt durchschnittlich 15,9075 Sekunden um 1000 mal abgefragt zu werden. Daraus ergibt sich, dass der Selekt im Schnitt 5,3706 mal schneller beendet ist, wenn er auf View B zugreift.

Von außen könnte man nicht erkennen, welcher View schneller abgefragt werden kann, da der zeitaufwendigste Teil des Selekts in den Views "versteckt" ist. Das ist nicht ungefährlich, da man nicht einschätzen kann, welche Ressourcen dieser Selekt tatsächlich benötigt, oder auf welche Tabellen er nun wirklich zugreift.

----------------------------------
```sql
EXPLAIN QUERY PLAN
SELECT *
FROM letzte_bestellung_a
WHERE kunde_id = 100;
```
Ergebnis:
QUERY PLAN
|--SCAN b
`--CORRELATED SCALAR SUBQUERY 3
   `--SEARCH b2
----------------------------------

```sql
EXPLAIN QUERY PLAN
SELECT *
FROM letzte_bestellung_b
WHERE kunde_id = 100;
```
Ergebnis:
QUERY PLAN
|--CO-ROUTINE letzte
|  `--SCAN bestellung
|--SCAN b
|--BLOOM FILTER ON letzte (kunde_id=?)
`--SEARCH letzte USING AUTOMATIC PARTIAL COVERING INDEX (kunde_id=?)

----------------------------------

Ich Interpretiere den Output von View B so, dass für den Selekt eine "neue Tabelle", die nur die Kundennummer und das letzte Bestelldatum dieses Kunden enthält "angelegt" und durchsucht wird. Schneller ist das, da diese Tabelle viel kleiner ist, als die gesamte "Bestellung" Tabelle. Anscheinend wurde auch automatisch ein Index erzeugt, der nur relevante Daten abdeckt und somit den Findungsprozess weiter beschleunigt.

Fazit zur Performance:
Es müssen weniger Daten durchsucht werden, da nur pro Kunde und nicht pro Bestellung berechnet wird. Das Durchsuchen verläuft effizienter, da ein Index angewandt wird.

# Fazit
Natürlich kann eine View Abfragen von außen betrachtet vereinfachen, da das Selekt-Statement kürzer und leichter lesbar ist. Allerdings verändert das überhaupt nichts an der Komplexität und die Performance wird dadurch auch nicht gesteigert. Wie man aus meinen Messergebnissen ableiten kann, ist Performance von der Effizienz der tiefsten Ebene der Abfragelogik abhängig und nicht davon, ob sie in einen View "verpackt" ist.