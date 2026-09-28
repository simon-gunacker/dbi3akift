= Mögliche Definitonen von Streuung

+ Gleichmäßigkeit: Kommt jeder Name ungefähr gleich oft dran?
Also wenn ich 100.000 Namen bekomme und 500 verschiedene Namen enthalten sind. Sollte jeder Name etwa 200 mal vorkommen.

+ Wiederholungen: Kommt derselbe Name auffällig oft direkt hintereinandner?
Bei Zufall kann sein das ein Name zweimal hintereinander vorkommen kann. Bei sehr vielen aufrufen sollte aber jeder Name mindestens einmal vorkommen.


== Erstes Ergebnis der Gleichmäßigkeit

**Idee**
Die Varianz zu zeigen bei Namen ist kompliziert, welche Gewichtung/Wert gibt man einen Namen.
Also habe ich mit Group by alle bei Vornamen sortiert. Dann habe ich alle Gruppen in eine Liste hinzugefügt, davon aber nur die Anzahl wie viele Vornamen in dieser Gruppe sind. 
Damit habe ich nun eine Liste mit anzahlen, damit kann man die Varianz berechnen. Die mir dann sagt wie oft jeder Vorname vorkommt.

**Ergebnis**
Varianz: 2308.52
Erwartet: 892.85
Verhältnis: 2.59

=== Was sagt die Varianz aus?

Ich habe gezählt, wie oft jeder Vorname vorkommt. Die Varianz misst, wie stark diese Anzahlen voneinander abweichen. Ist sie klein, kommen alle Namen ungefähr gleich oft vor. Ist sie groß, kommen manche Namen viel öfter vor als andere.

=== Was ist der Erwartungswert?

Das ist die Varianz, die man bei einem fairen Lostopf erwarten würde, in dem jeder Name gleich oft vorkommt und rein zufällig gezogen wird. Auch dabei schwanken die Anzahlen ein bisschen, das ist normal. Der Wert ist meine Vergleichsmarke: So viel Streuung ist durch Zufall allein zu erklären.

Die Formel dafür ist n · (1/k) · (1 − 1/k), mit n = Anzahl der Ziehungen und k = Anzahl der Namen im Pool.

=== Was ist das Verhältnis?

Das ist gemessene Varianz geteilt durch erwartete Varianz. Bei 1 streut Faker genau so, wie ein fairer Zufall es tun würde. Bei einem Wert deutlich über 1 streuen die Häufigkeiten stärker, es gibt also Namen, die bevorzugt werden. Bei einem Wert deutlich unter 1 wäre es gleichmäßiger als Zufall.

=== Was ist dein Ergebnis?

"Mit 500.000 Ziehungen kam ein Verhältnis von etwa 2,6 heraus. Faker zieht die Vornamen also nicht gleichverteilt. Manche Namen kommen deutlich öfter vor als andere."
