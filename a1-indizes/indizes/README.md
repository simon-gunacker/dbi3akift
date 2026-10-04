# Indizes-Report

### Wie wird dieser Report ausgearbeitet?:
    Über das FAQ-Format, da ich dieses bei Reports als zeitsparender für den Schreiber und Leser empfinde.
---

### Warum wird dieser Report in die README geschrieben?:
    Die README für diesen Unterordner wird automatisch im Browser mit Formatierung dargestellt.

### Gibt es einen großen Untschried zwischen der Suche mit indizierten Columns vs nicht-indizierten Columns?:
    Ja, sogar einen sehr großen, selbst mit Bias ist die Suchanfragen auf indizierte Columns wesentlich schneller, aber auf Kosten von zusätzlichem Speicherplatz.
    
### Wann lohnt es sich Indexe zu verwenden:
    Wenn die Laufzeit die höchste Priorität ist d.h Suchergebnisse schnell abgefragt werden sollen können.
    
### Wann lohnt es sich nicht Indexe zu verwenden:
    Generell dann, wenn die Laufzeit keine wirkliche Priorität hat aber der Speicherverbrauch eine hohe Priorität hat.
    
### Gibt es Unterschiede in der Laufzeit zwischen Abfragen über hauptsächlich SQL, Python oder eine Mischung von beidem?:
    Kurzgesagt ja, wobei der Unterschied in meinem konkreten Programm nicht großartig ersichtlich ist, das der größte Teil der Berechnungen vom **GROUP BY** von SQL übernommen wird.
    Dies geschieht in meinem Programm in der fast puren SQL-Funktion, sowie der Python-lastigen Funktion, hätte ich jedoch die funktionalität des GROUP BY durch eine eigene Python-Logik ersetzt-
    dann wäre die Laufzeit dramatisch erhöht worden.
    
### Welche ist also die beste Herangehensweise, für ein automatisierungs-Skript mit Python?:
    Für Entwickler mit SQL und Python Erfahrung würde ich zur Lesbarkeit ich eine Mischung empfehlen aus beidem, 
    da manche mathematische Prozesse in Python für den Großteil der Entwickler, die kaum bis keine Berührungspunkte mit SQL oder anderen Datenbank-Sprachen haben, wahrscheinlich einfacher zu lesen und nachvollziehen sind. 
