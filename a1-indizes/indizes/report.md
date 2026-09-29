# REPORT: indizes

## python code erstellen:

Mit der Hilfe einer for-Schleife und der Faker-Bibliothek 
konnte ich die 500k Daten in eine names.db
Datei einbauen.

## Gleichverteilung:

Die relative Verteilung (ohne index) sieht so aus: 

vorname       anzahl  prozent
------------  ------  -------
Nikola        1818    0.36   
Karina        997     0.2    
Nathalie      981     0.2    
Stephanie     970     0.19   
Kristina      968     0.19   
Rene          964     0.19   
Run Time: real 0.216 user 0.206787 sys 0.009762


**Im ganzen Datensatzt (bis auf Nikola) bewegt sich zwischen 20 und 10 prozent)**

## Performance ohne Index:

SELECT *
FROM personen
WHERE vorname = "Anna";

878

Run Time: real 0.034 user 0.030708 sys 0.004010

## Performance mit Index:


878
Run Time: real 0.000 user 0.000237 sys 0.000237

**Die Zeit ist um einiges schneller seitdem ich einen Index benutze.**


## Verteilung 50%

Hauns         249999
Nikola        882   
Joel          519   
Jan           501   
Gregor        500   
Carlo         496   
...

**Die Verteilung ist relativ gleich (bis auf die Hälfte der Daten) und bewegt sich pro Vornamen zwischen 500 und 400 gleichen Namen.
Also der Bias ist auf jeden Fall sichtbar.**

## Streuung 50%

minimum  maximum  differenz  relative_differenz_prozent
-------  -------  ---------  --------------------------
379      249999   249620     27957.5

Run Time: real 0.279 user 0.268636 sys 0.010487

## Index mit Bias

SELECT COUNT(*)
FROM personen     
WHERE vorname = 'Hauns';
COUNT(*)
--------
249999  
**Run Time: real 0.023 user 0.019773 sys 0.002985**

WHERE vorname = "Anna";

437     
**Run Time: real 0.001 user 0.000883 sys 0.000000**

**Man sieht, dass die Verarbeitungszeit vom Index bei den zufälligen (gestreuten) Daten schneller ist als beim Bias.**




