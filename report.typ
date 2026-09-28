#set page(header: align(center)[Mario Vogrin])
= Mögliche Definitionen von Streuung
\

- Gleichmäßigkeit: Kommt jeder Name ungefähr gleich oft dran?
Wenn ich zum Beispiel 100.000 Namen bekomme und darin 500 verschiedene Namen enthalten sind, sollte jeder Name etwa 200-mal vorkommen.

- Wiederholungen: Kommt derselbe Name auffällig oft direkt hintereinander vor?
Bei Zufall kann es sein, dass ein Name zweimal hintereinander vorkommt. Bei sehr vielen Aufrufen sollte aber trotzdem jeder Name mindestens einmal vorkommen.


== Erstes Ergebnis der Gleichmäßigkeit

*Idee*
\
Die Varianz bei Namen zu zeigen ist kompliziert, weil man sich fragen muss, welche Gewichtung/welchen Wert man einem Namen gibt.
Also habe ich mit Group by alle Einträge nach Vornamen gruppiert. Dann habe ich alle Gruppen in eine Liste eingefügt, aber nur die Anzahl, wie viele Vornamen in dieser Gruppe sind.
Damit habe ich nun eine Liste mit Anzahlen, mit der man die Varianz berechnen kann. Sie sagt mir dann, wie oft jeder Vorname vorkommt.

*Ergebnis* \
Varianz: 2171.8114253346585 \
Erwartet: 892.8542855405608 \
Verhältnis: 2.4324365806451596
\
Wiederholungen: 903
Erwartet: 894.4525939177101
Verhältnis: 1.0095560191120383

*Dateigröße* \
11 MiB

*Zeitmessung*
```sql
SELECT first_name, COUNT(\*) AS anzahl
FROM persons
GROUP BY first_name
ORDER BY anzahl ASC
LIMIT 3;
```

Run Time: real 0.167530 user 0.160507 sys 0.006268

*Nach Indexierung* \
```sql
CREATE INDEX idx_first_name ON persons(first_name)
```

Run Time: real 0.021526 user 0.020459 sys 0.000985

- Viel schneller als vorher
- Die Dateigröße ist aber gestiegen auf *17,2 MiB*

*Warum die Datei größer wird*

Ein Index ist eine zusätzliche Datenstruktur, die SQLite in derselben Datei speichert. Er ist ein sortierter Baum (B-Baum), in dem jeder Vorname zusammen mit der Zeilennummer (rowid) der passenden Zeile steht. Damit findet SQLite einen Namen schnell, ohne die ganze Tabelle durchzulesen. Diese Kopie der Spalte plus Verwaltungsdaten braucht Platz.


== Durchlauf bei Bias
*Ergebnis* \
Varianz: 111601204.28369725 \
Erwartet: 892.8542855405608 \
Verhältnis: 124993.74880205735 \

Wiederholungen: 250442 \
Erwartet: 894.4525939177101 \
Verhältnis: 279.994715989432 \

*Zeit* \
Run Time: real 0.131400 user 0.125903 sys 0.004599

*Dateigröße*
10.6 MiB

Die Varianz ist jetzt so hoch, weil 50 % davon den gleichen Namen haben.


=== Was sagt die Varianz aus?

Ich habe gezählt, wie oft jeder Vorname vorkommt. Die Varianz misst, wie stark diese Anzahlen voneinander abweichen. Ist sie klein, kommen alle Namen ungefähr gleich oft vor. Ist sie groß, kommen manche Namen viel öfter vor als andere.

=== Was ist der Erwartungswert?

Das ist die Varianz, die man bei einem fairen Lostopf erwarten würde, in dem jeder Name gleich oft vorkommt und rein zufällig gezogen wird. Auch dabei schwanken die Anzahlen ein bisschen, das ist normal. Der Wert ist meine Vergleichsmarke: So viel Streuung ist durch Zufall allein zu erklären.

Die Formel dafür ist n · (1/k) · (1 − 1/k), mit n = Anzahl der Ziehungen und k = Anzahl der Namen im Pool.

=== Was ist das Verhältnis?

Das ist die gemessene Varianz geteilt durch die erwartete Varianz. Bei 1 streut Faker genau so, wie ein fairer Zufall es tun würde. Bei einem Wert deutlich über 1 streuen die Häufigkeiten stärker, es gibt also Namen, die bevorzugt werden. Bei einem Wert deutlich unter 1 wäre es gleichmäßiger als Zufall.

=== Was ist dein Ergebnis?

"Mit 500.000 Ziehungen kam ein Verhältnis von etwa 2,6 heraus. Faker zieht die Vornamen also nicht gleichverteilt. Manche Namen kommen deutlich öfter vor als andere."