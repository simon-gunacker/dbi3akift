# Report: Views und Performance

## Views
Eine View kann man als gespeicherte Abfrage sehen. Will ich zum Beispiel nur die Kontaktdaten der Kunden, rufe ich die View kontakt_kunde auf, ohne das SELECT Statement jedes Mal neu zu schreiben. Wer nur über diese View zugreift, sieht die für den Kontakt nötigen Daten, also Name und E-Mail. Geburtsdatum, Telefon und Adresse bleiben verborgen, was dem Datenschutz dient. Ein weiterer Vorteil zeigt sich bei gesamt_wert: Ohne View müsste ich die Joins und die Berechnung jedes Mal ausschreiben, mit View ist das einmal getippt und danach eine kurze Zeile.

Ähnlich ist es bei bestell_uebersicht: Die ältesten offenen Bestellungen samt Kundennamen bekomme ich mit einer kurzen Abfrage auf die View, ohne den Join auf die Kundentabelle selbst schreiben zu müssen.

Views haben aber auch Nachteile. Sie hängen von den Tabellen ab: Fällt dort eine Spalte weg, funktioniert die View nicht mehr. Außerdem speichert eine View kein Ergebnis, sondern führt ihre Abfrage bei jedem Aufruf neu aus. Hinter einem harmlos aussehenden SELECT * FROM gesamt_wert stecken Joins über drei Tabellen mit hunderttausenden Zeilen. Diesen Aufwand sieht man der kurzen Zeile nicht an.

## Performance
Die Views letzte_bestellung_a und letzte_bestellung_b liefern dasselbe Ergebnis. Das habe ich mit EXCEPT geprüft: Beide haben 10.000 Zeilen, und in keiner Richtung bleibt eine Zeile übrig. Beide Views habe ich gleich abgefragt, jeweils mit LIMIT 10000: einmal nur für einen Kunden (WHERE kunde_id = 42) und einmal ohne Filter. Bei der Laufzeit ist A immer langsamer als B. Für einen Kunden braucht A im Schnitt etwa 90 ms und B etwa 17 ms, das ist ein Faktor von etwa 5. Ohne Filter braucht A etwa 14 Minuten und B etwa 0,13 s. A ist dann rund 6.200-mal langsamer.

Das Problem ist, dass man von außen nicht sieht, wie komplex die Abfrage hinter einer View ist. Wenn man Pech hat, dauert eine harmlos aussehende Abfrage wie bei mir mehrere Minuten und braucht viel Rechenleistung, und man sieht nicht warum. Auch das LIMIT hilft nicht: Die Views liefern sowieso genau 10.000 Zeilen, und sie müssen vorher trotzdem alle 100.000 Bestellungen verarbeiten.

EXPLAIN QUERY PLAN zeigt den Grund. Bei A steht dort CORRELATED SCALAR SUBQUERY. Das heißt, A ruft das Sub-Select für jede Bestellung neu auf und geht dabei jedes Mal wieder die Bestellungen durch. Grob geschätzt sind das bei 100.000 Bestellungen etwa 10 Milliarden gelesene Zeilen. Bei B steht das nicht, dort wird das Sub-Select als eigener Schritt (CO-ROUTINE) einmal ausgeführt und danach über einen automatisch angelegten Index nachgeschlagen. Bei der Abfrage für einen Kunden ist der Unterschied kleiner, weil das Sub-Select dann nur für die Bestellungen von diesem Kunden läuft.

## Schlussfolgerung
Eine View kann eine Abfrage vereinfachen, die Komplexität dahinter verschwindet dadurch aber nicht. Meine Messungen zeigen, dass es darauf ankommt, wie die View gebaut ist: A und B sehen gleich aus und liefern dasselbe, trotzdem braucht A ohne Filter etwa 14 Minuten und B nur etwa 0,13 Sekunden. Eine View ist also nur dann sinnvoll, wenn das SELECT dahinter auch sinnvoll und effizient geschrieben ist.