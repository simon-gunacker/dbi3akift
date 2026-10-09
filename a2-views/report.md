# Assignment 2 - Views


## Ad Aufgabe 5:

Ein SELECT der durch den View wesentlich einfacher ist, wäre z.B.:

```SQL
    SELECT * FROM orders_name 
    WHERE status = 'failed'
    ;
```
Hierdurch können alle fehlgeschlagenen Bestellungen sehr einfach abgerufen werden. 

Durchläufe: 1.000 Mal 
Python `timeit()` gibt die Summe der Gesamtzeit der Anzahl der Durchläufe zurück - dividiert durch 1.000 ergibt sich der Durchschnittswert.
Der SELECT alle Kunden mit der id 42 von view a dauert im Schnitt:
        0.05s.
Der gleiche SELECT von view b dauert durchschnittlich: 
        0.14s
