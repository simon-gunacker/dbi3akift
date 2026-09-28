from sqlite3 import connect
from faker import Faker

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
            id INT,
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


@with_connect(":memory:")
def test_in_memory(conn):
    create_table(conn)

    for i in range(500):
        first_name = fake.first_name()
        last_name = fake.last_name()
        insert_person(conn, first_name, last_name)

    for i in get_first_name_group_amount(conn):
        print(i)


if __name__ == "__main__":
    test_in_memory()
