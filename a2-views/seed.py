#from sqlite import connect
import random
import json

DB = "miniature_shop.db"
KUNDE_ROWS = 10000
PRODUKT_ROWS = 10000
BESTELLUNG_ROWS = 100000
BESTELLPOS_ROWS = 500000

RANDOM_SEED = 42

NAMES_PATH = "./json_data/names.json"
ADDR_PATH = "./json_data/addresses.json"
PRODUCTS_PATH = "./jsond_data/products.json"

STATUS_LIST = ["bestellt", "bezahlt", "versandbereit", "versandt", "erhalten"]
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

# returns the contents of a given JSON file
def load_json(filepath):
    with open (filepath, "r") as file: 
        data = json.load(file)
    return data


def create_kunden(rows):
    name_data = load_json(NAMES_PATH)
    addr_data = load_json(ADDR_PATH)

    for i in range(rows):

        first_name = random.choice(name_data["first_names"])
        last_name = random.choice(name_data["last_names"])
        mail = first_name.lower() + "." + last_name.lower() + str(i + 1) + "@mail.com"
        birthdate = str(random.randint(1930, 2005)) + "-" + str(random.randint(1, 12)) + "-" + str(random.randint(1, 28))
        # random.choices returns a list, list -> string via join
        phone = "43676" + "".join(random.choices("0123456789", k=7))

        city = random.choice(addr_data["cities"])
        addr = (random.choice(addr_data["streets"]) + " " +
                str(random.randint(1, 100)) + ", " +
                city["city"] + " " +
                city["zip"] +  " " +
                city["country"])

        yield (
            first_name, 
            last_name, 
            mail,
            birthdate, 
            phone, 
            addr
        )

def create_produkte(rows): 
    product_data = load_json(PRODUCTS_PATH)

    for i in range(rows): 
        desc = random.choice(product_data["products"])
        price = random.random() * 40
        inventory = random.randint(0, 100)

        yield ( 
            desc, 
            price, 
            inventory
        )

def create_bestellung(rows):
    for i in range(rows): 
        kunde_id = random.randint(1, KUNDE_ROWS)
        bestelldatum = str(random.randint(2025, 2026)) + "-" + str(random.randint(1, 12)) + "-" + str(random.randint(1, 28))
        status = random.choice(STATUS_LIST)

        yield ( 
            kunde_id, 
            bestelldatum, 
            status
        )
        
def create_bestellpos(rows): 

    # need a position_count for every order -> 500k in total
    position_counts = (
        [1] * 10000 + 
        [3] * 20000 +
        [5] * 42000 +
        [7] * 20000 +
        [10] * 8000
    )
    random.shuffle(position_counts)

    for i in range(rows): 
        bestellung_id = i + 1
        positions = position_counts[i]
        product_id_list = random.sample(range(1, PRODUKT_ROWS + 1), k=positions)
        

        for j in range(positions): 
            produkt_id = product_id_list[j]
            menge = random.randint(1, 10)

            yield (
                bestellung_id, 
                produkt_id,
                menge
            )


"""
if __name__ == "__main__":
    main()
"""