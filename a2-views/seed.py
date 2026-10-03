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


def insert_kunde(conn, vorname: str, nachname: str, email_end: str, geburtsdatum: str, telefon: str, adresse: str) -> int:
    sql = """
        INSERT INTO kunde (vorname, nachname, email, geburtsdatum, telefon, adresse)
        VALUES (?, ?, ?, ?, ?, ?)
    """
    email_end = f"{vorname}.{nachname}{email_end}"
    cursor = conn.execute(
        sql,
            (vorname, nachname, email_end, geburtsdatum, telefon, adresse),
    )
    conn.commit()
    return cursor.lastrowid

def insert_bestellung(conn, kunde_id: int, bestelldatum: str) -> int:
    sql = """
        INSERT INTO bestellung (kunde_id, bestelldatum, status)
        VALUES (?, ?, ?)
    """
    status_list = ["versendet", "in Bearbeitun", "neu"]
    status = status_list[random.randint(0, 2)]
    cursor = conn.execute(
        sql,
            (kunde_id, bestelldatum, status),
    )
    conn.commit()
    return cursor.lastrowid


def insert_bestellpostion(conn, bestell_id: str, produkt_id: int, menge: int):
    sql = """
        INSERT INTO bestellposition (bestellung_id, produkt_id, menge)
        VALUES (?, ?, ?)
    """
    conn.execute(
        sql,
            (bestell_id, produkt_id, menge),
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
        SELECT COUNT(*) AS amount
        FROM kunde
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_count_bestellung(conn):
    sql = """
        SELECT COUNT(*) AS amount
        FROM bestellung
    """
    cursor = conn.execute(sql)
    return cursor.fetchall()


def get_count_bestellposition(conn):
    sql = """
        SELECT COUNT(*) AS amount
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

def get_all_kunde(conn):
    sql = """
        SELECT *
        FROM kunde
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
    with open(".data/produkt.json", "r", encoding="utf-8") as file:
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

    with open(".data/vorname.json", "r", encoding="utf-8") as file:
        vorname_dict = json.load(file)

    for i in range(paare):
        result_vorname += (vorname_dict["konsonanten"][k] + vorname_dict["vokale"][v])
        k = random.randint(0, 17)
        v = random.randint(0, 4)

    return result_vorname

def random_nachname(stamm: int, end: int) -> str:
    """ Stamm/Wort -> Leange: 24
        Endung -> Leange: 9
    """

    with open(".data/nachname.json", "r", encoding="utf-8") as file:
        nachname_dict = json.load(file)

    return nachname_dict["stamms"][stamm] + nachname_dict["endungen"][end]

def random_datum(start_datum: str) -> str:
    result_date = ""

    minute = int(start_datum[14] + start_datum[15])
    hour = int(start_datum[11] + start_datum[12])
    day = int(start_datum[8] + start_datum[9])
    month = int(start_datum[5] + start_datum[6])
    year = int(start_datum[:4])

    if minute >= 55:
        minute = 0
        hour += 1
    else:
        minute += random.randrange(5, 46, 5)
        if minute > 55:
            minute = 55
    
    if hour > 23:
        hour = 1
        day += 1

    if day >= 30:
        day = 1
        month += 1

    if month >= 12:
        month = 1
        year += 1

    return f"{str(year)}-{str(month).zfill(2)}-{str(day).zfill(2)} {str(hour).zfill(2)}:{str(minute).zfill(2)}"


def random_geburtsdatum() -> str:
    year = str(random.randint(1955, 2026))
    month = str(random.randint(1, 12))
    day = str(random.randint(1, 30))
    return f"{year}-{month.zfill(2)}-{day.zfill(2)}"

def random_telefonummer() -> str:
    result = "06"
    len_number = random.randint(10, 12)
    prefix = random.randint(60, 90)
    result += str(prefix)

    for i in range(len_number):
        result += str(random.randint(0, 9))

    return result


def random_adresse(strassen_staemme: int, strassen_endungen: int, orte: int) -> str:
    """ Str. Stam -> Leange: 36
        Str. Endung -> Leange: 8
        Orte -> Leange: 20
    """
    with open(".data/adressen.json", "r", encoding="utf-8") as file:
        adressen_dict = json.load(file)

    return f"{adressen_dict["strassen_staemme"][strassen_staemme] + adressen_dict["strassen_endungen"][strassen_endungen]} {str(random.randint(1, 999))}, {adressen_dict["orte"][orte]["plz"]} {adressen_dict["orte"][orte]["ort"]}"


@with_connect(":memory:")
def test_in_memory(conn):
    create_tables(conn)
    
    for i in range(10_000):
        produkt = random_produkt(random.randint(0, 1), random.randint(0, 91))
        preis = random.randint(99, 9999_99) / 100
        lagerbestand = random.randint(1, 100)
        insert_produkt(conn, produkt, preis, lagerbestand)

    date = "2026-10-02 10:15"
    email_end="@maily.com"
    produkt_list = set()
    produkt_id = random.randint(1, 10_000)
    for i in range(10_000):
        vorname = random_vorname().capitalize()
        nachname = random_nachname(random.randint(0, 23), random.randint(0, 8))
        geburstdatum = random_geburtsdatum()
        telefonnummer = random_telefonummer()
        adresse = random_adresse(random.randint(0, 35), random.randint(0, 7), random.randint(0, 19))
        kunde_id = insert_kunde(conn, vorname, nachname, email_end, geburstdatum, telefonnummer, adresse)

        for i in range(10):
            date = random_datum(date)
            bestell_id = insert_bestellung(conn, kunde_id, date)
            for i in range(5):
                while (produkt_id in produkt_list):
                    produkt_id = random.randint(1, 10_000)
                produkt_list.add(produkt_id)
                insert_bestellpostion(conn, bestell_id, produkt_id, random.randint(1, 12))
            produkt_list.clear()

    print(get_count_produkt(conn))
    print(get_count_kunde(conn))
    print(get_count_bestellung(conn))
    print(get_count_bestellposition(conn))


if __name__ == "__main__":
    seed = input("Ohne seed Enter: ")
    if seed == "":
        test_in_memory()
    else:
        random.seed(seed)
        test_in_memory()

