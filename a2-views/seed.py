from sqlite3 import connect


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
            lagerbestand integer,
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS bestellung(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kunde_id INTEGER,
            bestelldatum datetime,
            status varchar,
            FOREIGN KEY (kund_id) REFERNCES kund(id)
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
            adresse varchar,
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
        SELECT COUNT(*)
        FROM produkt
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()
