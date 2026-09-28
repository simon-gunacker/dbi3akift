# Indizes
Tabelle mit 500.000 zufällig generierten Datensätzen mit dem PyPy-Modul [names-generator](https://pypi.org/project/names-generator/):

* Varianz: 19.42 - Standardabweichung: 4.41 (ermittelt durch die Häufigkeit, in welcher derselbe Name vorkommt)

# Auswirkung von indices auf die Geschwindigkeit und den Speicher

```sql
    SELECT * FROM person;
```

* benötigt `6.250s` und der aufgewendete Speicher für die DB ist `11.5MB`

Fügt man einen Index zur Tabelle auf die Spalten Vorname, Nachname hinzu, ergeben sich folgende Werte für Zeit des SELECTs und Speichergröße der DB:

* benötigt `4.194s` und der aufgewendete Speicher für die DB ist `24.2MB`

