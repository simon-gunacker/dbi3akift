from sqlite3 import connect
from faker import Faker
from faker.providers.person.de_AT import Provider
import os

fake = Faker("de_AT")


def conver_to_dict(cursor, row):
    result_dict = {}
    col_infos = cursor.description

    for i in range(len(col_infos)):
        name_col = col_infos[i][0]
        value = row[i]
        result_dict[name_col] = value
    return result_dict


def with_connect(db):
    def decorator(function):
        def wrapper(*args, **kwargs):
            with connect(db) as conn:
                conn.row_factory = conver_to_dict
                result = function(conn, *args, **kwargs)
                return result

        return wrapper

    return decorator


def create_table(conn):
    conn.execute("""
        CREATE TABLE IF NOT EXISTS persons(
            id INTEGER PRIMARY KEY,
            first_name TEXT,
            last_name TEXT
        )
    """)


def insert_person(conn, first_name: str, last_name: str):
    sql = """
        INSERT INTO persons (first_name, last_name)
        VALUES (?, ?)
    """
    conn.execute(
        sql,
        (first_name, last_name),
    )
    conn.commit()


def get_all_persons(conn):
    sql = "SELECT * FROM persons"

    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_count(conn):
    sql = "SELECT COUNT(*) FROM persons"

    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_first_name_group_amount(conn):
    sql = """
        SELECT first_name, COUNT(*) AS amount
        FROM persons
        GROUP BY first_name
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_first_name_group_amount_orderd(conn):
    sql = """
        SELECT first_name
        FROM persons
        ORDER BY rowid
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_uniformity(conn, first_name_amount: list):
    amount_list = []
    for person in first_name_amount:
        amount_list.append(person["amount"])

    k = len(amount_list)
    n = sum(amount_list)

    medium = sum(amount_list) / k

    temp_sum = 0
    for x in amount_list:
        temp_sum += (x - medium) ** 2
    varianc = temp_sum / k

    expected = n * (1 / k) * (1 - 1 / k)

    print("Varianz:", varianc)
    print("Erwartet:", expected)
    print("Verhältnis:", varianc / expected)


def get_repeat(conn, first_name_dict: list):
    K = len(set(Provider.first_names))
    list_first_name = []
    repeat = 0
    result = 0
    for name in first_name_dict:
        list_first_name.append(name["first_name"])
    
    n = len(list_first_name)

    for i in range(1, len(list_first_name)):
        if list_first_name[i] == list_first_name[i - 1]:
            repeat += 1

    result = (n - 1) / K
    print("=" * 25)
    print("Wiederholungen:", repeat)
    print("Erwartet:", result)
    print("Verhältnis:", repeat / result)


@with_connect(":memory:")
def test_in_memory(conn):
    user_input = 0
    user_input = int(input("Anzahl an Personen (default: 500K => 0): "))
    if user_input == 0:
        user_input = 500_000

    create_table(conn)

    for i in range(user_input):
        first_name = fake.first_name()
        last_name = fake.last_name()
        insert_person(conn, first_name, last_name)

    get_uniformity(conn, get_first_name_group_amount(conn))
    get_repeat(conn, get_first_name_group_amount_orderd(conn))


def fill_db(conn):
    rows = []

    for i in range(500_000):
        first_name = fake.first_name()
        last_name = fake.last_name()
        rows.append((first_name, last_name))

    conn.executemany(
        "INSERT INTO persons (first_name, last_name) VALUES (?, ?)", rows
    )
    conn.commit()

def fill_db_bias(conn):
    bias_name = "Anna"
    rows = []

    for i in range(500_000 // 2):
        last_name = fake.last_name()
        rows.append((bias_name, last_name))

    for i in range(500_000 // 2):
        first_name = fake.first_name()
        last_name = fake.last_name()
        rows.append((first_name, last_name))

    conn.executemany(
        "INSERT INTO persons (first_name, last_name) VALUES (?, ?)", rows
    )
    conn.commit()


@with_connect("persons.db")
def run_person_db(conn):
    create_table(conn)
    fill_db(conn)

    get_uniformity(conn, get_first_name_group_amount(conn))
    get_repeat(conn, get_first_name_group_amount_orderd(conn))


@with_connect("persons_bias.db")
def run_person_db_bias(conn):
    create_table(conn)
    fill_db_bias(conn)

    get_uniformity(conn, get_first_name_group_amount(conn))
    get_repeat(conn, get_first_name_group_amount_orderd(conn))


if __name__ == "__main__":
    if os.path.exists("persons.db"):
        os.remove("persons.db")
    if os.path.exists("persons_bias.db"):
        os.remove("persons_bias.db")

    # test_in_memory()
    run_person_db()
    print("+"* 25)
    run_person_db_bias()
