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
    sql = "SELECT id FROM kunde WHERE name == (?) "

    cursor = conn.execute(sql, (customer, ))
    return cursor.fetchone()["id"]

def get_article_id(conn, name):
    sql = "SELECT id FROM artikel WHERE name == (?); "

    cursor = conn.execute(sql, (name, ))
    return cursor.fetchone()["id"]

def get_price(conn, name):
    sql = "SELECT verkaufspreis FROM artikel WHERE name == (?); "
    cursor = conn.execute(sql, (name, ))
    return cursor.fetchone()["verkaufspreis"]

def get_order_sum(conn, article_dict):
    result = 0;

    for key, value in article_dict.items():
        sql = "SELECT verkaufspreis * (?) AS sum FROM artikel WHERE name == (?);"

        cursor = conn.execute(sql, (value, key))
        result += cursor.fetchone()["sum"]
    return result


def insert_order(conn, customer_id, order_sum):

    sql = "INSERT INTO bestellung (kunde_id, gesamtwert) VALUES (?, ?);"

    cursor = conn.execute(sql, (customer_id, order_sum))
    return cursor.lastrowid

def insert_order_position(conn, order_id, article_id, amount, price):

    sql = "INSERT INTO bestell_position (bestellung_id, artikel_id, menge, einzelpreis) VALUES (?, ?, ?, ?);"

    cursor = conn.execute(sql, (order_id, article_id, amount, price))


def transaction(conn, customer, article_dict):

    customer_id = get_customer(conn, customer)
    order_sum = get_order_sum(conn, article_dict)
    order_id = insert_order(conn, customer_id, order_sum)

    for name, amount in article_dict.items():
        insert_order_position(
            conn,
            order_id,
            get_article_id(conn, name),
            amount,
            get_price(conn, name),
            )

    print(order_id, customer_id, order_sum)
    print(conn.execute("SELECT * FROM bestellung").fetchall())




@with_connect(":memory:")
def test(conn):
    customer = "TechShop Wien"
    article_dict = {"Arduino Uno" : 5, "Raspberry Pi 4" : 2, "LED 5mm rot" : 50}

    with open("table.sql", "r") as f:
        conn.executescript(f.read())

    with open("insert.sql", "r") as f:
        conn.executescript(f.read())

    transaction(conn, customer, article_dict)



if __name__ == "__main__":
    test()


