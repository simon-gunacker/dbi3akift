import sqlite3
from faker import Faker

fake = Faker("de_DE")

conn = sqlite3.connect("personen.db")

conn.execute("DROP TABLE IF EXISTS personen")

conn.execute("""
CREATE TABLE personen (
    id INTEGER PRIMARY KEY,
    vorname TEXT,
    nachname TEXT
    )
""")

for i in range(500000):
    conn.execute(
        "INSERT INTO personen (vorname, nachname) VALUES (?, ?)", 
        (fake.first_name(), fake.last_name())
    )

conn.commit()
conn.close()
