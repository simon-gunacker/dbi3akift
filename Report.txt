
sqlite> PRAGMA table_info(personen);
+-----+----------+---------+---------+------------+----+
| cid |   name   |  type   | notnull | dflt_value | pk |
+-----+----------+---------+---------+------------+----+
| 0   | id       | INTEGER | 0       |            | 1  |
| 1   | vorname  | TEXT    | 1       |            | 0  |
| 2   | nachname | TEXT    | 1       |            | 0  |
+-----+----------+---------+---------+------------+----+

a)Zeige, welche Performance ein Index bringt und wie er sich auf den Speicherbedarf auswirkt

  Ohne Index
  ----------
- Datenbank: probe.db
- Große: 11571200 bytes
- .headers on, .mode column, .mode table, .timer on
- SELECT * FROM personen WHERE vorname = 'Anna';
- Run Time: real 0.090 user 0.073851 sys 0.008483
  Zeit: 0.090 Sekunden

  Mit Index
  ----------
- Datenbank: probe.db
- Große: 19075072 bytes
- .headers on, .mode column, .mode table, .timer on
- CREATE INDEX idx_vorname ON personen(vorname);
- SELECT * FROM personen WHERE vorname = 'Anna';
- Run Time: real 0.012 user 0.002926 sys 0.008621
  Zeit: 0.012 Sekunden

  Ohne Index dauerte die Abfrage 0,090 Sekunden. Mit Index dauerte sie nur 0,012 Sekunden. Der Index macht die Abfrage also deutlich schneller. Dafür wird mehr Speicherplatz benötigt: Die Datenbank wächst von 11.571.200 Bytes auf 19.075.072 Bytes.

  WITH-Statement: für Select zur relativen Verteilung
  --------------
  WITH t AS (SELECT vorname, COUNT(*) as menge FROM personen GROUP BY vorname)
  SELECT vorname, menge, (menge*100.0)/500000 AS prozent FROM t;

  Die Verteilung der Vornamen ist relativ gleichmäßig. Die meisten Vornamen kommen mit einem Anteil von ungefähr 0,16 % bis 0.20% vor.Es gibt einige kleinere Abweichungen, zum Beispiel kommt "Nikola" mit 0.3572 % häufiger vor.

  Run Time: real 0.097 user 0.092831 sys 0.003959
  Zeit: 0.097 Sekunde

b)Unter der Annahme, dass die Bibliothek die indizierte Spalte gleichverteilt befüllt hat: erzeuge                                  eine Datenbank, die einen Bias hat; z.B. 50% gleicher Vorname.
  Ohne Index
  ----------
 - Datenbank: bias.db
 - Große: 11071488 bytes
 - .headers on, .mode column, .mode table, .timer on
 - SELECT * FROM personen WHERE vorname = 'Rosa';
 - Run Time: real 1.546 user 0.523526 sys 0.962274
   Zeit: 1.546 Sekunden

c) Erstelle auch für diese Datenbank einen Index, untersuche, was sich jetzt ändert und suche Gründe    für diese Änderungen.
  Mit Index
  ---------
 - Datenbank: bias.db
 - Große: 18075648 bytes
 - .headers on, .mode column, .mode table, .timer on
 - CREATE INDEX idx_vorname ON personen(vorname);
 - Run Time: real 1.751 user 0.581155 sys 1.042579

  Ohne Index dauerte die Abfrage 1,546 Sekunden. Mit Index dauerte sie 1,751 Sekunden. Die Abfrage wurde also etwas langsamer. Der Grund ist, dass „Rosa“ bei 50 % der Datensätze vorkommt. Der Index muss deshalb sehr viele Datensätze finden und ausgeben.



