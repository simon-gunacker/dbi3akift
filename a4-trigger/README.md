## Ausführen

Im Ordner `a4-trigger` folgenden Befehl ausführen:

```bash
rm -f bib.db
for f in shema.sql test_data.sql aufgabe1.sql aufgabe2.sql aufgabe3.sql aufgabe4.sql aufgabe5.sql aufgabe6.sql; do cat "$f"; echo; done | sqlite3 -header -column -echo bib.db 2>&1 | tee ergebnis.txt
```

Die Datenbank wird neu erstellt, alle Aufgaben werden der Reihe nach ausgeführt,
und die Ergebnisse werden angezeigt und zusätzlich in `ergebnis.txt` gespeichert.