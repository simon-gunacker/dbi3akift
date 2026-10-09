# Assignment 2 - Views


## Aufgabe 5

Ein SELECT der durch den View wesentlich einfacher ist, wäre z.B.:

```SQL
    SELECT * FROM orders_name 
    WHERE status = 'failed'
    ;
```

Hierdurch können alle fehlgeschlagenen Bestellungen sehr einfach abgerufen werden. 

## Aufgabe 7 - Untersuchung und Report

### Views
* Durch Views können komplexe abfragen als Tabelle gespeichert werden und somit abfragen, die darauf aufbauen, vereinfacht werden. 

Vorteile:
* vereinfachte Abfragen
* weniger Tipparbeit
* Wahrscheinlichkeit für Fehler sinkt als Folge der Vereinfachung
* schnellerer Zugriff auf Daten

Nachteile:
* Performance kann wesentlich leiden bei schlechter Umsetzung
* Fehler in View-Abfragen führen dauerhaft zu fehlerhaften Ergebnissen bei Verwendung des Views

### Performance

Nach Testungen beider Views mit dem gleichen Select konnte festgestellt werden, dass es bei beiden zum gleichen Ergebnis kommt. In Bezug auf die Performance zeigt sich, dass View A im Durchschnitt 5 Mal länger braucht, als View B:

Python `timeit()` gibt die Summe der Gesamtzeit der Anzahl der Durchläufe zurück - dividiert durch deren Anzahl ergibt sich der Durchschnittswert.

Durchläufe: 1.000 Mal 
Test-Statement: 
```SQL
SELECT * from letzte_bestellung_{a,b}
WHERE customer_id = 10000
LIMIT 10000;
```

>Der SELECT alle Kunden mit der id 42 von View a dauert im Schnitt:
>        0.05s.
>Der gleiche SELECT von View b dauert durchschnittlich: 
>        0.01s

Dass die SQL-Abfrage einer View bei weiteren Abfragen nicht sichtbar ist, kann einerseits problematisch sein, da man eventuell auftretende Performanceverluste nicht direkt nachvollziehen kann. Perfomanceverluste könnten aber auch dadurch auftreten, dass man Folgeabfragen nicht direkt darauf anpassen kann. 

`SUB QUERY PLAN`:  
* **Bei View A** - Tabelle `orders` wird gescannt (vollständig durchsucht) und die aus dem Subselect entstandene Tabelle wird durchsucht, was heißt, dass nicht die gesamte Tabelle durchsucht wird.
* **Bei View B** - der Subselect `letzte` wird gescannt, daraufhin die Tabelle `orders`. SQP zeigt auch, dass `letzte` mit einem Index nach der angegebenen id durchsucht wird, was auf eine bessere Performance hinweist. 

Bei View A sieht man, dass der innere Select für jeden Datensatz des äußeren ausgeführt wird. Bei View B hingegen wird der zweite Select dem ersten gejoined, sodass beide Selects nur einmal ausgeführt werden und anschließend nur noch die gesuchten Datensätze gefunden werden müssen.


## Schlussfolgerung

Die Beispiele der beiden Views zeigen, dass die Komplexität von Abfragen wesentlich vereinfacht werden können. Dies gilt jedoch nicht für die Performance, vor allem, wenn durch die Art der Abfrage wesentliche Verluste gemacht werden, wie es aus den Messungen hervorgeht, braucht View A um das 5-fache länger, als View B.
