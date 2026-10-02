import sqlite3
import time

from faker import Faker

Faker.seed(42) # 42 als Startzahl, damit Ergebnisse Vergleichbar sind und immer gleich ausgegeben werden
fake = Faker("de_AT")

conn = sqlite3.connect("personen.db")

# Tabelle jedes Mal neu anlegen
conn.execute("DROP TABLE IF EXISTS personen")
conn.execute(
    """
    CREATE TABLE personen (
        id INTEGER PRIMARY KEY AUTOINCREMENT
        , vorname TEXT NOT NULL
        , nachname TEXT NOT NULL
    )
    """
)

start = time.time()

# 50 Durchgänge mit je 10.000 Personen = 500.000 (Batches, damit es schneller geht)
for durchgang in range(50):
    zeilen = []
    for i in range(10_000):
        zeilen.append((fake.first_name(), fake.last_name()))

    conn.executemany("INSERT INTO personen (vorname, nachname) VALUES(?,?)", zeilen)
    conn.commit()
    print("Durchgang", durchgang + 1, "von 50 fertig")

print("Fertig in", round(time.time() - start, 3), "Sekunden")
conn.close()