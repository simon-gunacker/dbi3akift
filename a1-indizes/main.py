#!usr/bin/env python3

import time

from sqlite3 import connect
from faker import Faker

# Faker needs to be initialized.
fake = Faker()

""" Task:
Write a Python script that populates a table persons
(id, first_name, last_name) with a large number of records (at least 500k).
Use a suitable library to obtain meaningful random data.

Analyze how randomly the chosen library distributes the data.

You cannot simply calculate the variance here without thinking!
Variance is a mathematical measure that assumes two objects have a distance
from each other. With first and last names, this is not so straightforward, 
so you have to consider what you mean by "distribution" (or spread).

Show the performance impact of an index and how it affects storage 
requirements. 
Helpful database commands: .headers on, .mode column, .timer on, 
WITH statement for SELECT regarding relative distribution.

Assuming that the library populated the indexed column uniformly: create a 
database that has a bias; e.g., 50% identical first names.

Also create an index for this database, investigate what changes now, and 
find reasons for these changes.

Create a short report (approx. 1/2 page) in which you record and justify your 
findings. The report must be submitted via GitHub Classroom by the start of the 
next class.
"""


DB_NAME = "index.db"
TOTAL_RECORDS = 500_000
BATCH_SIZE = 50_000


# Generating fake people
def create_people(total):
    for _ in range(total):
        yield (fake.first_name(), fake.last_name())


# Measuring time
start = time.time()

# SQL connect and verification query
with connect(DB_NAME) as conn:
    cursor = conn.cursor()
    # Creats `.wal` file (Write Ahead Logging) transaction is appended to that
    # file and writes the data into the db from there.
    cursor.execute("PRAGMA journal_mode = WAL;")
    # If crash happens data will be lost, or corrupts db.
    cursor.execute("PRAGMA syncronous = OFF;")

    sql_create = """
                CREATE TABLE IF NOT EXISTS persons(
                    id INTEGER PRIMARY KEY AUTOINCREMENT, 
                    first_name TEXT NOT NULL, 
                    last_name TEXT NOT NULL
                )
                """

    cursor.execute(sql_create)

    # SQL str to use in cursor.executemany command
    sql_insert = "INSERT INTO persons (first_name, last_name) VALUES (?, ?)"

    batch = []
    for count, person in enumerate(create_people(TOTAL_RECORDS), start=1):
        batch.append(person)

        # If batch size reached, insert data
        if len(batch) >= BATCH_SIZE:
            cursor.executemany(sql_insert, batch)

            conn.commit()
            batch.clear()

            print(f"Inserted {count:,} records...")

    # insert rimaining batch data
    if batch:
        cursor.executemany(sql_insert, batch)
        # cursor.commit()


    # Timer output
    end = time.time()
    elapsed_time = end - start
    print(f"Elapsed time: {elapsed_time:.2f}")

    # Insertion done message
    print(f"Done! All {TOTAL_RECORDS} records successfully generated and saved.")


    # Verifing table content
    cursor.execute("SELECT first_name, last_name FROM persons LIMIT 10")
    print("Verify inserted data:" + "\n", cursor.fetchall())

conn.close()
