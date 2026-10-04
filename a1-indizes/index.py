from sqlite3 import connect
from faker import Faker

DB = "index_test.db"
BIAS_DB = "index_bias.db"
ROWS = 500000
BIAS_NAME = "BiasName"

# prompts Faker to generate German / Austrian names
Faker.seed(1)
faker = Faker("de_AT")

def create_table(cursor):
    """
    Helper function to create the table with 3 columns.
    """

    # deletes the table if it already exists to avoid duplicate rows
    cursor.execute("DROP TABLE IF EXISTS personen")

    # creates the table with the columns id, vorname and nachname
    cursor.execute("""
        CREATE TABLE personen (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vorname TEXT NOT NULL,
            nachname TEXT NOT NULL
        );
    """)


def create_persons(rows):
    """
    Uses Faker to create a given number of random names as tuples.
    """
    for i in range(rows):
        yield (
            faker.first_name(),
            faker.last_name()
        )


def insert_persons(cursor, persons):
    """
    Takes a cursor and generated persons and inserts them into the table.
    """
    cursor.executemany("INSERT INTO personen (vorname, nachname) VALUES (?, ?)", persons)

def create_biased_persons(rows):
    """
    Creates persons where exactly 50% have the first "name" BiasName.
    """
    for i in range(rows):
        # Integer division to avoid problems with uneven row numbers
        if i < rows // 2:
            vorname = BIAS_NAME
        else:
            vorname = faker.first_name()
            # prevents additional BiasNames in the other 50%
            while vorname == BIAS_NAME:
                vorname = faker.first_name()
        yield (
            vorname,
            faker.last_name()
        )


def main():
    # connection to the DBs
    conn = connect(DB)
    bias_conn = connect(BIAS_DB)

    # cursors used to execute SQL statements
    cursor = conn.cursor()
    bias_cursor = bias_conn.cursor()

    # create the tables
    create_table(cursor)
    create_table(bias_cursor)

    # create the persons
    persons = create_persons(ROWS)
    biased_persons = create_biased_persons(ROWS)

    # insert the persons
    insert_persons(cursor, persons)
    insert_persons(bias_cursor, biased_persons)

    # save changes
    conn.commit()
    bias_conn.commit()

    # check normal DB
    count = cursor.execute("SELECT COUNT(*) FROM personen").fetchone()[0]

    # check bias DB
    bias_count = bias_cursor.execute("SELECT COUNT(*) FROM personen").fetchone()[0]
    biasName_count = bias_cursor.execute("SELECT COUNT(*) FROM personen WHERE vorname = ?", (BIAS_NAME,)).fetchone()[0]

    print(f"Normal DB: {count} rows")
    print(f"Bias DB: {bias_count} rows")
    print(f"Same names in Bias DB: {biasName_count} rows")

    # close connections
    conn.close()
    bias_conn.close()


if __name__ == "__main__":
    main()