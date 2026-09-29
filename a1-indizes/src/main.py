import sqlite3
from faker import Faker
import random 


# Faker initialisieren + sprachauswahl
fake = Faker('de_DE')


TOTAL_RECORDS = 500000
BATCH_SIZE = 10000 # 10.000 Datensätze pro Schreibvorgang,wie viele Datensätze in einem einzigen Durchlauf  generiert und an SQLite übergeben werden

create_table__personen_string='''
    CREATE TABLE IF NOT EXISTS personen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vorname TEXT NOT NULL,
        nachname TEXT NOT NULL
    )
'''

#ertellen der Standard DB
db_name = 'personen.db'
conn = sqlite3.connect(db_name)
cursor = conn.cursor()


cursor.execute(create_table__personen_string)
conn.commit()


for i in range(0,TOTAL_RECORDS,BATCH_SIZE):
    batch_data=[]#Liste von tuple
    for j in range(BATCH_SIZE):
        batch_data.append((fake.first_name(), fake.last_name()))

    cursor.executemany(
        "INSERT INTO personen (vorname, nachname) VALUES (?, ?)", 
        batch_data
    )
    conn.commit()

conn.close()    

#ertellen der Bias DB
db_name_bias = 'bias.db'
conn_bias = sqlite3.connect(db_name_bias)
cursor_bias = conn_bias.cursor()


cursor_bias.execute(create_table__personen_string)
conn_bias.commit()

for i in range(0,TOTAL_RECORDS,BATCH_SIZE):
    batch_data_bias=[]#Liste von tuple
    for j in range(BATCH_SIZE):
        if random.random() < 0.5: # erzeugt 50% wahrscheinlichkeit
            vorname="Simon"
        else:
            vorname = fake.first_name()   

        batch_data_bias.append((vorname, fake.last_name()))

    cursor_bias.executemany(
        "INSERT INTO personen (vorname, nachname) VALUES (?, ?)", 
        batch_data_bias
    )
    conn_bias.commit()

conn_bias.close()    

