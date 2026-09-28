from sqlite3 import connect
from faker import Faker


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


if __name__ == "__main__":
    fake = Faker("de_AT")

    for i in range(10):
        print(fake.first_name(), fake.last_name())
