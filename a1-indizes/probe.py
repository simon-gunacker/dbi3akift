from sqlite3 import connect

from faker import Faker


def createTablePersonen(conn):
    cursor = conn.cursor()
    sql = """
    CREATE TABLE IF NOT EXISTS personen(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vorname TEXT NOT NULL,
    nachname TEXT NOT NULL
    )
    """
    cursor.execute(sql)

def insertPersonen(conn,n):

    fake = Faker("de_AT")

    for _ in range(n):
        conn.execute("INSERT INTO personen(vorname, nachname) VALUES (?, ?)",
                 (fake.first_name(), fake.last_name())
        )
    conn.commit()

def insertPersonenBias(conn, n):
    fake = Faker("de_AT")

    for item in range(n):
        if item < n//2:
            vorname = 'Rosa'
        else:
            vorname = fake.first_name()
            while vorname == 'Rosa':
                vorname = fake.first_name()
        nachname = fake.last_name()
        conn.execute("INSERT INTO personen(vorname, nachname) VALUES (?, ?)",
                    (vorname, nachname)
        )
    conn.commit()


###----------main-------------
with connect("bias.db") as conn:
    createTablePersonen(conn)
    insertPersonenBias(conn, 500000)
