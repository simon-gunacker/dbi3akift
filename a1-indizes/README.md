# Indizes

- Schreibe ein python-Skript, das eine Tabelle `personen(id, vorname, nachname)` mit vielen (mind. 500k) Datensätzen befüllt. Verwende dazu eine geeignete Bibliothek, um sinnvolle Zufallsdaten zu bekommen.

- Analysiere, wie zufällig die gewählte Bibliothek streut. 
  
	⚠️ Hier kann nicht unüberlegt die Varianz ermittelt werden! 
	
	Die Varianz ist ein mathematisches Maß, dass davon ausgeht, dass zwei Objekte eine Distanz zueinander haben. Bei Vor-/Nachnamen ist das nicht so einfach, man muss sich also überlegen, was man unter Streuung versteht.
	
- Zeige, welche Performance ein Index bringt und wie er sich auf den Speicherbedarf auswirkt. Hilfreiche Kommandos in der Datenbank: `.headers on`, `.mode column`, `.timer on`,  `WITH`-Statement für Select zur relativen Verteilung
- Unter der Annahme, dass die Bibliothek die indizierte Spalte gleichverteilt befüllt hat: erzeuge eine Datenbank, die einen Bias hat; z.B. 50% gleicher Vorname. 
- Erstelle auch für diese Datenbank einen Index, untersuche, was sich jetzt ändert und suche Gründe für diese Änderungen.
- Erstelle einen kurzen Report (ca. 1/2 Seite), in dem du deine Erkenntnisse festhältst und begründest. Der Report ist bis zum Anfang der nächsten Stunde **im github classroom** abzugeben.
