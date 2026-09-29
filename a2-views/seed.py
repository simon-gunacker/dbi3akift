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
            id INTEGER NOT NULL,
            bezeichnung varchar,
            preis decimal,
            lagerbestand integer,
            PRIMARY KEY (id),
            FOREIGEN KEY (id) REFERENCES bestellpostion(produkt_id)
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS bestellposition(
            bestellung_id INTEGER NOT NULL,
            produkt_id INTEGER NOT NULL,
            menge INTEGER,
            PRIMARY KEY (bestellung_id, produkt_id),
            FOREIGEN KEY (bestellung_id) REFERENCES bestellung(id),
            FOREIGEN KEY (produkt_id) REFERENCES produkt(id)
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS bestellung(
            id INTEGER NOT NULL,
            kunde_id INTEGER,
            bestelldatum datetime,
            status varchar,
            PRIMARY KEY (id),
            FOREIGEN KEY (id) REFERENCES bestellposition(bestellung_id),
            FOREIGEN KEY (kunde_id) REFERENCES kunde(id)
        )
    """)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS kunde(
            id INTEGER NOT NULL,
            vorname varchar,
            nachname varchar,
            email varchar,
            geburtsdatum date,
            telefon varchar,
            adresse varchar,
            PRIMARY KEY (id),
            FOREIGEN KEY (id) REFERENCES kunde(kunde_id)
        )
    """)


def insert_produkt(conn, bezeichnung: str, preis: float, lagerbestand: int):
    sql = """
        INSERT INTO produkt (bezeichnung, preis, lagerbestand)
        VALUES (?, ?, ?)
    """
    conn.execute(
        sql,
            (bezeichnung, preis, lagerbestand),
    )
    conn.commit()

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
