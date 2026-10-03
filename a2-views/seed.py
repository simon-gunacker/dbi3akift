from sqlite3 import connect
import json
import random


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


def create_tables(conn):
    conn.execute("""
        CREATE TABLE IF NOT EXISTS produkt(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bezeichnung varchar,
            preis decimal,
            lagerbestand integer
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS bestellung(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kunde_id INTEGER,
            bestelldatum datetime,
            status varchar,
            FOREIGN KEY (kunde_id) REFERENCES kunde(id)
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS kunde(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            vorname varchar,
            nachname varchar,
            email varchar,
            geburtsdatum date,
            telefon varchar,
            adresse varchar
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS bestellposition(
            bestellung_id INTEGER NOT NULL,
            produkt_id INTEGER NOT NULL,
            menge INTEGER,
            PRIMARY KEY (bestellung_id, produkt_id),
            FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
            FOREIGN KEY (produkt_id) REFERENCES produkt(id)
        )
    """)


def insert_produkt(conn, bezeichnung: str, preis: float, lagerbestand: int) -> int:
    sql = """
        INSERT INTO produkt (bezeichnung, preis, lagerbestand)
        VALUES (?, ?, ?)
    """
    cursor = conn.execute(
        sql,
            (bezeichnung, preis, lagerbestand),
    )
    conn.commit()
    return cursor.lastrowid


def insert_kunde(conn, vorname: str, nachname: str, email: str, geburtsdatum: str, telefon: str, adresse: str) -> int:
    sql = """
        INSERT INTO kunde (vorname, nachname, email, geburstdatum, telefon, adresse)
        VALUES (?, ?, ?, ?, ?, ?)
    """
    curusor = conn.execute(
        sql,
            (vorname. nachname, email, geburtsdatum, telefon, adresse),
    )
    conn.commit()
    return cursor.lastrowid

def insert_bestellung(conn, kunde_id: int, bestelldatum: str, status: str) -> int:
    sql = """
        INSERT INTO bestellung (kunde_id, bestelldatum, status)
        VALUES (?, ?, ?)
    """
    cursor = conn.execute(
        sql,
            (kunde_id, bestelldatum, status),
    )
    conn.commit()
    return cursor.lastrowid


def insert_bestellpostion(conn, bezeichnung: str, preis: float, lagerbestand: int):
    sql = """
        INSERT INTO produkt (bezeichnung, preis, lagerbestand)
        VALUES (?, ?, ?)
    """
    conn.execute(
        sql,
            (bezeichnung, preis, lagerbestand),
    )
    conn.commit()


def get_count_produkt(conn):
    sql = """
        SELECT COUNT(*) AS amount
        FROM produkt
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_count_kunde(conn):
    sql = """
        SELECT COUNT(*)
        FROM kunde
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_count_bestellung(conn):
    sql = """
        SELECT COUNT(*)
        FROM bestellung
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_count_bestellposition(conn):
    sql = """
        SELECT COUNT(*)
        FROM bestellposition
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()

def get_all_produkt(conn):
    sql = """
        SELECT *
        FROM produkt
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()

def get_produkt_by_id(conn, id: int) -> list:
    sql = f"""
        SELECT *
        FROM produkt
        WHERE id = {id}
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()

def random_produkt(suffix: bool, praefixe: int) -> str:
    with open("produkt.json", "r", encoding="utf-8") as file:
        produkt_dict = json.load(file)
        
    return produkt_dict["praefixe"][praefixe] + produkt_dict["suffixe"][suffix]

def random_vorname()-> str:
    """ K = Konstanten => Leange liste: 18
        V = Vokal => Leange liste: 5
    """
    result_vorname = ""
    k = random.randint(0, 17)
    v = random.randint(0, 4)
    paare = random.randint(1, 3)

    with open("vorname.json", "r", encoding="utf-8") as file:
        vorname_dict = json.load(file)

    for i in range(paare):
        result_vorname += (vorname_dict["konsonanten"][k] + vorname_dict["vokale"][v])
        k = random.randint(0, 17)
        v = random.randint(0, 4)

    return result_vorname
    

@with_connect(":memory:")
def test_in_memory(conn):
    create_tables(conn)
    
    for i in range(10_000):
        produkt = random_produkt(random.randint(0, 1), random.randint(0, 91))
        preis = random.randint(99, 9999_99) / 100
        lagerbestand = random.randint(1, 100)
        produkt_id = insert_produkt(conn, produkt, preis, lagerbestand)

    for i in range(100):
        vorname = random_vorname()
        print(vorname)

if __name__ == "__main__":
    seed = input("Ohne seed Enter: ")
    if seed == "":
        test_in_memory()
    else:
        random.seed(seed)
        test_in_memory()

