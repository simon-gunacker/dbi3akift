import sqlite3

def convert_dict(cursor, row):
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
                conn.row_factory = convert_to_dict
                result = function(conn, *args, **kwargs)
                return result

        return wrapper

    return decorator

def create_table(conn):
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS  produkt(
        id INTEGER NOT NULL,
        bezeichnung varchar(255),
        preis DECIMAL,
        lagerbestand INTEGER,
        PRIMARY KEY (id),
        FOREIGN KEY (id) REFERENCES bestellposition(produkt_id)
        );
        """
        )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS bestellposition(
        bestellung_id INTEGER NOT NULL,
        produkt_id PRIMARY KEY,
        menge INTEGER
        PRIMARY KEY (bestellung_id),
        PRIMARY KEY (produkt_id),
        FOREIGN KEY (bestellung_id) REFERENCES bestellung(id),
        FOREIGN KEY (produkt_id) REFERENCES produkt(id)
        );
        """
        )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS bestellung(
        id INTEGER NOT NULL,
        kunde_id INTEGER,
        bestelldatum DATE,
        status VARCHAR(255),
        PRIMARY KEY (id),
        FOREIGN KEY (id) REFERENCES bestellposition(bestellung_id),
        FOREIGN KEY (kunde_id) REFERENCES kunde(id)
        );
        """
        )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS kunde(
        id INTEGER NOT NULL,
        vorname VARCHAR(255),
        nachname VARCHAR(255),
        email VARCHAR(255),
        geburtsdatum DATE,
        telefon VARCHAR(255),
        adresse VARCHAR(255),
        PRIMARY KEY (id),
        FOREIGN KEY (id) REFERENCES bestellung(kunde_id)
        );
        """
        )


conn.commit()
print("Data inserted successfully")
conn.close()
