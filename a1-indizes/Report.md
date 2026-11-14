## Streuungsanalyse

Da wir es mit Namen zu tun haben, können wir nicht sagen, wie groß der Abstand zwischen zwei Namen ist. Deswegen müssen wir schauen, wie gleichmäßig die einzelnen Namen vorkommen.

Ich habe gemessen, wie oft jeder Vorname vorkommt und dabei die minimale Anzahl, die maximal vorkommende Anzahl und den Durchschnitt ermittelt. Bei der Konzept-Datenbank variiert die Häufigkeit zwischen 42 und 11.440 Vorkommen pro Name (Durchschnitt: 724,6). Bei der Bias-Datenbank liegt das Maximum bei 255.989 Vorkommen. Die Spannbreite ist extrem, was zeigt, dass manche Namen deutlich öfter vorkommen als andere.

## Index-Effekt bei gleichverteilten Daten

Bei der Konzept-Datenbank hilft der Index:

| Variante | Zeit |
|----------|------|
| Ohne Index | 0,0276 sec |
| Mit Index | 0,0198 sec |


Der Speicherbedarf stieg dabei von 10,6MB auf 17,8MB.

## Index-Effekt bei Bias-Daten

Bei der Bias-Datenbank war die Abfrage mit Index langsamer als ohne Index:

| Variante | Zeit |
|----------|------|
| Ohne Index | 0,1784 sec |
| Mit Index | 0,1861 sec |

Das liegt daran, dass die Datenbank bei so vielen Treffern (255.989 Vorkommen) für jede gefundene Zeile einzeln nachschlagen muss, statt einfach die ganze Tabelle am Stück durchzugehen. Der B-Tree-Navigation kostet Zeit, während ein direkter Tabellen-Scan effizienter ist.