# Report: Views und Performance

## Views
Eine View kann man als gespeicherte Abfrage sehen. Will ich zum Beispiel nur die Kontaktdaten der Kunden, rufe ich die View kontakt_kunde auf, ohne das SELECT Statement jedes Mal neu zu schreiben. Wer nur über diese View zugreift, sieht die für den Kontakt nötigen Daten, also Name und E-Mail. Geburtsdatum, Telefon und Adresse bleiben verborgen, was dem Datenschutz dient. Ein weiterer Vorteil zeigt sich bei gesamt_wert: Ohne View müsste ich die Joins und die Berechnung jedes Mal ausschreiben, mit View ist das einmal getippt und danach eine kurze Zeile.

Ähnlich ist es bei bestell_uebersicht: Die ältesten offenen Bestellungen samt Kundennamen bekomme ich mit einer kurzen Abfrage auf die View, ohne den Join auf die Kundentabelle selbst schreiben zu müssen.

Views haben aber auch Nachteile. Sie hängen von den Tabellen ab: Fällt dort eine Spalte weg, funktioniert die View nicht mehr. Außerdem speichert eine View kein Ergebnis, sondern führt ihre Abfrage bei jedem Aufruf neu aus. Hinter einem harmlos aussehenden SELECT * FROM gesamt_wert stecken Joins über drei Tabellen mit hunderttausenden Zeilen. Diesen Aufwand sieht man der kurzen Zeile nicht an.

## Performance
Die Views letzte_bestellung_a und letzte_bestellung_b liefern dasselbe Ergebnis. Das habe ich mit EXCEPT geprüft: Beide haben 6.315 Zeilen, und in keiner Richtung bleibt eine Zeile übrig. Bei der Laufzeit ist A langsamer als B. Frage ich nur einen Kunden ab (WHERE kunde_id = 42), ist der Unterschied klein: A braucht im Schnitt etwa 1,1 ms und B etwa 0,8 ms, das ist ein Faktor von etwa 1,5. Frage ich alle Zeilen ab, braucht A etwa 4 s und B etwa 13 ms. A ist dann rund 300-mal langsamer.

Das Problem ist, dass man von außen nicht sieht, wie komplex die Abfrage hinter einer View ist. Beide Views werden gleich abgefragt und liefern dasselbe. Wenn man Pech hat, dauert eine harmlos aussehende Abfrage mehrere Minuten und braucht viel Rechenleistung, und man sieht nicht warum.

EXPLAIN QUERY PLAN zeigt den Grund. Bei A steht dort CORRELATED SCALAR SUBQUERY. Das heißt, A ruft das Sub-Select für jede Bestellung neu auf und geht dabei jedes Mal wieder alle 10.000 Zeilen durch. Bei 10.000 Bestellungen sind das etwa 100 Millionen gelesene Zeilen. B berechnet das Sub-Select nur einmal und schlägt danach über einen automatisch angelegten Index nach. Bei der Abfrage für einen Kunden ist A fast gleich schnell, weil das Sub-Select dann nur für die Bestellungen von diesem Kunden läuft.

## Schlussfolgerung
Ja, eine View macht eine Abfrage einfacher zu schreiben, aber sie nimmt mir nur die Schreibarbeit ab. Die Komplexität dahinter bleibt. Ich denke die Abfrage einmal durch, mache eine sinnvolle View daraus und verwende sie dann, ohne das ganze SELECT jedes Mal zu schreiben. Meine Messungen zeigen, dass es darauf ankommt, wie die View gebaut ist: A und B sehen gleich aus und liefern dasselbe, trotzdem ist A bei allen Zeilen rund 300-mal langsamer. Deshalb sollte man wissen, welche Abfrage hinter einer View steckt.