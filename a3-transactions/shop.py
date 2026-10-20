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


def get_sum_order(conn, article: dict) -> int:
    result = 0
    
    for name, amount in article.items():
        
        sql = f"""
            SELECT {amount} * verkaufspreis AS sum
            FROM artikel
            WHERE name = '{name}'
        """

        cursor = conn.execute(sql)
        result += cursor.fetchone()["sum"]

    return result


def get_id_article(conn, name: str) -> int:
    sql = f"""
        SELECT id
        FROM artikel
        WHERE name = '{name}'
    """

    cursor = conn.execute(sql)
    return cursor.fetchone()["id"]




def transaction(conn, customer: str, article: dict):
    customer_id = get_kunde_id(conn, customer)
    sum_of_order = get_sum_order(conn, article)

    get_id_article(conn, "Arduino Uno")


@with_connect(":memory:")
def test_in_memory(conn):
    customer = "TechShop Wien"
    article_dict = {"Arduino Uno": 5, "Raspberry Pi 4": 2, "LED 5mm rot": 50}


    with open("model.sql", encoding="utf-8") as file:
        conn.executescript(file.read())

    with open("test_data.sql", encoding="utf-8") as file:
        conn.executescript(file.read())

    transaction(conn, customer, article_dict)


if __name__ == "__main__":
    test_in_memory()
