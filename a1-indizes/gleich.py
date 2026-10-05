import sqlite3
from faker import Faker

con = sqlite3.connect('gleich.db')
cursor = con.cursor()

# Source - https://stackoverflow.com/a/71750937
# Posted by Michael Stachura
# Retrieved 2026-09-21, License - CC BY-SA 4.0

fake = Faker("de_AT")
Faker.seed(42)
names = []

N = 500000

for _ in range(N):
    vorname = fake.first_name()
    names.append([vorname, fake.last_name()])

dropif = 'DROP TABLE IF EXISTS personen'
cursor.execute(dropif)
create = 'CREATE TABLE personen (id INTEGER PRIMARY KEY, vorname TEXT, nachname TEXT)'
cursor.execute(create)

cursor.executemany("INSERT INTO personen (vorname, nachname) VALUES (?, ?)", names)

con.commit()
con.close()



