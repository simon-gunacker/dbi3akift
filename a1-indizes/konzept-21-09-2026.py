import sqlite3
from faker import Faker

fake = Faker()
connection = sqlite3.connect('indizes.db')

cursor = connection.cursor()

cursor.execute("DROP TABLE IF EXISTS PERSON")

table = """
    CREATE TABLE PERSON(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name CHAR(30) NOT NULL,
        last_name CHAR(30) NOT NULL
    )
"""

cursor.execute(table)

data = []

for i in range(500000):
    first_name = fake.first_name()
    last_name = fake.last_name()
    data.append((first_name, last_name))

cursor.executemany("INSERT INTO PERSON (first_name, last_name) VALUES (?, ?)", data)

connection.commit()
connection.close()