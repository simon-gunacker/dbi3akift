from sqlite import connect
import random
import json

DB = "test.db"
KUNDE_ROWS = 10000
PRODUKT_ROWS = 10000
BESTELLUNG_ROWS = 100000
BESTELLPOS_ROWS = 500000

"""
kunde: 
    - vorname/nachname: List + random choice
    - mail: <vorname>.<nachname><ID>@mail.com
    - geburtstag: https://generate-random.org/dates/python
    - telefon: generate a a string of (for example 12) numbers, since the datatype is VARCHAR
    - adresse: make a dict, key countries, values cities, choose random key, use randomint as index for city. 
                Or would it be easier to store the city as the key, and add country and zip code as value?

produkt: 
    - bezeichnung: List + random choice
    - preis: float(decimal.Decimal(random.randrange(155, 389))/100)
    - lagerbestand: randomint

bestellung: 
    - kunde_id: choose random from 1 - number of rows in kunde
    - bestelldatum: same as geburtstag
    - status: List + choose random (bestellt, bezahlt, Versandfertig, Versandt, erhalten)

bestellposition: 
    - bestellung_id: choose random from 1 - number of rows in bestellung
    - produkt_id: choose random
    - menge: randomint (max 10 maybe)
"""

def create_kunden(kunde_rows):

    with open ("./json_data/names.json", "r") as file:
        names_dict = json.load(file)

    for i in range(kunde_rows): 
        yield (
            random.choice(names_dict["vorname"]), 
            random.choice(names_dict["nachname"])
        )

def insert_kunden(cursor, kunden): 
    cursor.executemany("INSERT INTO kunde (vorname, nachname) VALUES (?, ?)", kunden)

def main(): 
    conn = connect(DB)
    cursor = conn.cursor()

    # create tables
    create_table_kunde(cursor)

    kunden = create_kunden(KUNDE_ROWS)


if __name__ == "__main__"
    main()