from sqlite3 import connect
import json
import os


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


def select_all_artikel(conn):
    sql = """
        SELECT *
        FROM artikel;
        """

    cursor = conn.execute(sql)
    return cursor.fetchall()


def select_all_kunde(conn):
    sql = """
        SELECT *
        FROM kunde;
        """

    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_kunde_id(conn, name: str) -> int:
    sql = f"""
        SELECT id
        FROM kunde
        WHERE name = '{name}';
        """

    cursor = conn.execute(sql)
    return cursor.fetchone()["id"]


def transaction(conn, customer: str, article: dict):
    customer_id = get_kunde_id(conn, customer)

    


@with_connect(":memory:")
def test_in_memory(conn):
    with open("model.sql", encoding="utf-8") as file:
        conn.executescript(file.read())

    with open("test_data.sql", encoding="utf-8") as file:
        conn.executescript(file.read())

    for i in select_all_artikel(conn):
        print(i)

    for i in select_all_kunde(conn):
        print(i)



        


if __name__ == "__main__":
    test_in_memory()