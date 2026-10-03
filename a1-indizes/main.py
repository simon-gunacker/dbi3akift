from sqlite3 import connect
from faker import Faker 
#CRUD

DB_FILE = "personen.db"
NUM_ROWS = 500000

#connects to the database
def conn_to_db(db):

    with connect (db) as conn:
        cursor = conn.cursor()

    return cursor

#creates Table for our people
def create_table(cursor):
    sql = """CREATE TABLE IF NOT EXISTs personen(
        id INTEGER NOT NULL PRIMARY KEY,
        vorname VARCHAR(25),
        nachname VARCHAR(25))"""

    cursor.execute(sql)

#inserts people into database
def insert_personen(cursor, rows):

    sql = "INSERT INTO personen (vorname, nachname) VALUES(?,?)"

    cursor.executemany(sql, rows)


def generating_persons(fake, count):
    for _ in range(count):
        yield (fake.first_name(), fake.last_name())


def main():

    Faker.seed(42)

    fake = Faker("de_AT")

    cursor = conn_to_db(DB_FILE)

    conn = cursor.connection
    
    try: 
        create_table(cursor)
        insert_personen(cursor, generating_persons(fake, NUM_ROWS))
        conn.commit()

        sql = "SELECT COUNT (*) FROM personen"

        count = cursor.execute(sql).fetchone()[0]
        print(f"{count} Datensätze eingefügt")

    finally:
        conn.close()


if __name__ == "__main__":
    main()