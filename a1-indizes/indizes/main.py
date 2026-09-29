import sqlite3
from faker import Faker

fake = Faker("de_AT")
conn = sqlite3.connect("names.db")
c = conn.cursor()

names = []

for i in range (1, 250001):
    vorname = fake.first_name()
    nachname = fake.last_name()
    names.append((i, vorname, nachname))


for i in range (250002, 500001):
    vorname = "Hauns"
    nachname = "Földbocha"
    names.append((i, vorname, nachname))



c.execute(
    """CREATE TABLE IF NOT EXISTS personen(
    id INTEGER PRIMARY KEY,
    vorname TEXT NOT NULL,
    nachname TEXT NOT NULL);
    """
    )

c.executemany(
    "INSERT INTO personen (id, vorname, nachname) VALUES (?, ?, ?)",
    names
    )

conn.commit()
print("Data inserted successfully")
conn.close()

#Statements used:

""""
#Verteilung:

SELECT vorname, COUNT(*) AS anzahl
FROM personen
GROUP BY vorname
ORDER BY anzahl DESC;

////
Prozentuale Verteilung:

WITH verteilung AS (
    SELECT vorname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY vorname
),
werte AS (
    SELECT
        vorname,
        anzahl,
        100.0 * anzahl / (SELECT SUM(anzahl) FROM verteilung) AS prozent,
        100.0 / (SELECT COUNT(*) FROM verteilung) AS erwartet
    FROM verteilung
)
SELECT
    vorname,
    ROUND(prozent, 2) AS prozent,
    ROUND(prozent - erwartet, 2) AS abweichung
FROM werte
ORDER BY ABS(prozent - erwartet) DESC;

////
#Streuung MIN und MAX

WITH verteilung AS (
    SELECT vorname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY vorname
)
SELECT
    MIN(anzahl) AS minimum,
    MAX(anzahl) AS maximum,
    MAX(anzahl) - MIN(anzahl) AS differenz,
    ROUND(
        100.0 * (MAX(anzahl) - MIN(anzahl)) / AVG(anzahl),
        2
    ) AS relative_differenz_prozent
FROM verteilung;

"""
