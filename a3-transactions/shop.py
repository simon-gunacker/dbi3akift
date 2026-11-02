from sqlite3 import connect

def convert_dict(cursor, row):
    result_dict = {}
    col_infos = cursor.description

    for i in range(len(col_infos)):
        col_name = col_infos[i][0]
        value = row[i]
        result_dict[col_name] = value

    return result_dict



def with_connect(db):
    def decorator(function):
        def wrapper(*args, **kwargs):
            with connect(db) as conn:
                conn.row_factory = convert_dict
                result = function(conn, *args, **kwargs)
                return result
        return wrapper
    return decorator

def get_customer(conn, customer):
    conn.executemany(
    "INSERT INTO kunde (id, name, kreditlimit, aktueller_kredit) VALUES (?, ?, ?, ?)",
    kunde
    )





def transaction(conn, customer, article_dict):
    conn.execute("TRANSACTION STARTING")
    customer_id = get_customer()
    for


@with_connect(":memory:")
def test(conn):
    customer = "Techshop Wien"
    article_dict = {"Arduino Uno:" 5, "Raspberry Pi 4" : 2, "LED 5mm rot" : 50}

    with open("table.sql", "r") as f:
        conn.executescript(f.read())

    with open("insert.sql", "r") as f:
        conn.executescript(f.read())


if __name__ == "__main__":
    test()


