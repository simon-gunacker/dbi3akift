from sqlite3 import connect
from sqlite3 import IntegrityError

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

    sql = "INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (?, ?, ?, ?);"

    conn.execute(sql, (order_id, article_id, amount, price))

def reduce_stock(conn, article_id, amount):

    sql = "UPDATE artikel SET lagerbestand = lagerbestand - (?) WHERE id = (?)"

    conn.execute(sql, (amount, article_id))

def increase_credit(conn, customer_id, order_sum):

    sql = "UPDATE kunde SET aktueller_kredit = aktueller_kredit + (?) WHERE id = (?)"

    conn.execute(sql, (order_sum, customer_id))

def log_movement(conn, article_id, order_id, amount):

    sql = "INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?, ?, ?, 'verkauf')"

    conn.execute(sql, (article_id, order_id, -amount))

der cancel_order(conn, order_id):

    try:
    order = conn.execute(
            "SELECT status, kunde_id, gesamtwert FROM bestellung WHERE id = ?",
            (order_id,)).fetchone()

    if order == None:
        raise ValueError("Bestellung existiert nicht!")

    if order["status"] != offen:
        raise ValueError("Bestellung ist nicht offen!")

    position = conn.execute("SELECT artikel_id, menge FROM bestellposition WHERE bestellung_id = (?)", (order_id,),).fetchall



# Pro Position: Bestand zurück und Lagerbewegung eintragen
"UPDATE artikel SET lagerbestand = lagerbestand + ? WHERE id = ?"       # (menge, artikel_id)
"INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?, ?, ?, 'storno')"  # (artikel_id, order_id, menge)

# Einmal pro Bestellung: Kredit senken, Status setzen
"UPDATE kunde SET aktueller_kredit = aktueller_kredit - ? WHERE id = ?" # (gesamtwert, kunde_id)
"UPDATE bestellung SET status = 'storniert' WHERE id = ?"               # (order_id,)
    except (IntegrityError, ValueError):
        conn.rollback()
        raise

def transaction(conn, customer, article_dict):

    try:
        customer_id = get_customer(conn, customer)
        order_sum = get_order_sum(conn, article_dict)
        order_id = insert_order(conn, customer_id, order_sum)

        increase_credit(conn, customer_id, order_sum)


        for name, amount in article_dict.items():
            article_id = get_article_id(conn, name)
            log_movement(conn, article_id, order_id, amount)

            insert_order_position(
                conn,
                order_id,
                article_id,
                amount,
                get_price(conn, name),
                )
            reduce_stock(conn, article_id, amount)

    except IntegrityError:
        print("Bestellung abgelehnt")



    except IntegrityError as e:
        print("Fehler:", e)
        conn.rollback()
        raise

    print(order_id, customer_id, order_sum)
    print(conn.execute("SELECT * FROM bestellung").fetchall(), "\n")
    print(conn.execute("SELECT * FROM bestellposition").fetchall(), "\n")

    print(conn.execute("SELECT id, lagerbestand FROM artikel").fetchall(), "\n")
    print(conn.execute("SELECT id, aktueller_kredit FROM kunde").fetchall(), "\n")
    print(conn.execute("SELECT * FROM lagerbewegung").fetchall(), "\n")





@with_connect(":memory:")
def test(conn):
    customer = "Elektronik Steiner"
    article_dict = {"Arduino Uno" : 200, "Raspberry Pi 4" : 2, "LED 5mm rot" : 50}

    with open("table.sql", "r") as f:
        conn.executescript(f.read())

    with open("insert.sql", "r") as f:
        conn.executescript(f.read())

    try:
        transaction(conn, customer, article_dict)
    except IntegrityError:
        print("Bestellung abgelehnt")



if __name__ == "__main__":
    test()


