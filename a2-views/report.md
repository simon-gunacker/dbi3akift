## Views:
   - Zweck: Das vereinfach eines Queries durch die Abstraktion des Selects.
   
   - Vorteil: Man muss sich keine Gedanken mehr über Joins oder Subselects machen, sobald die View so arbeitet, wie man es sich vorstellt und möchte.
   
   - Nachteil: Vermeindlich richtig gejointe oder subselectete SELECTS können durchaus fehlerhaft sein, sowie das man nicht mehr sieht, welche constraints in den SELECTS verwendet wurden.
   
    
## Performance:
   - Ergebnis der beiden View: Diese liefern hier tatsächlich das selbe Ergebnis.
   
   - Laufzeiten: Die Laufzeiten unterscheiden sich durch einen Faktor von 1.8, wobei View A bei hier mit diesem Faktor vor View B liegt. Lässt man nun aber einen Test für 10000 Ausführungen laufen, so wird klar, dass der View B vorne liegt, sobald die aufgewendete Rechen- und Speicherleistung durch das erstellen einer temporären Tabelle überwunden wurde und die Indezes für jede neue Ausführungen immer mehr Zeit wieder gut machen.
   
   - Probleme der Undurchsichtbarkeit der Views: Wie bereits bei den Nachteilen angeschnitten, kann es hier zu fehlerhaften SELECTS kommen, zusätzlich kann man aber auch nicht auf einem Blick einsehen, wie und ob andere Tabellen subselected oder gejoint werden, was je nach Datenmenge natürlich auch die Performance beeinflussen kann.
   
   - EXPLAIN QUERY PLAN: Bei View A wird zuerst Tabelle b komplett gescannt, und dann wird für jede Zeile in diesem Scan mit dem b2 Select verglichen.
   Bei View B wird es etwas komplexer, hier wird zuerst letzte als eine co-routine in den Speicher gegeben, wobei letzte aus einem Scan von bestellung besteht, auch wird ein B-TREE für das GROUP BY angelegt. Dann wird wieder b gescannt, ein Filter auf die letzte Tabelle gelegt, um herauszufinden ob der Wert überhaupt existiert. Sollte dieser existieren wird ein temporärer Index für die column erstellt und dann nach dem gefragten Wert gesucht.
   
   
## Schlussfolgerung:
   Ja, ein View kann komplexe Subselects oder Joins für die Augen des Anwenders komplett verschwinden lassen, ist dieser aber für den Use-Case nicht optimal geschrieben merkt man dennoch Unterschieder in der Performance, vor allem bei größeren Datenmengen, oder häufigen Aufrufen.
