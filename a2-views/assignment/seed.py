from sqlite3 import connect
import random

random.seed(1)


# Customers------------------------------------------------

# number of customers
N_CUSTOMERS = 10000

# 20 first names
FIRST_NAMES = [
    "Emanuel", "Bilal", "Marin", "Asmir", "Elisabeth", "Irina", "Sonja", "Michael", "Michaela", "Max",
    "Valentin", "Moritz", "Katharina", "Veronika", "Christiane", "Reinhard", "René", "Patrick", "Joshua", "Bruno"
    ]

# 20 last names
LAST_NAMES = [
    "Bauer", "Müller", "Krieger", "Wagner", "Maier", "Stocker", "Gregoritsch", "Alaba", "Schlager", "Laimer",
    "Sabitzer", "Arnautovic", "Schmid", "Griezman", "Schick", "Kane", "Kimmich", "Goretzka", "Neuer", "Diaz"
]

# 5 mail domains
DOMAINS = [
    "@yahoo.de", "@gmail.com", "@aon.at", "@bulme.at", "@gym-gleisdorf.at"
]


# 2 country codes

COUNTRY_CODES = [
    "+43", "+49"
]

# 5 carrier-specific dialing codes
CARRIER_CODES = [
    "676", "664", "680", "699", "677"
]

# 10 street names
STREETS = [
    "Wienerstraße", "Ibererstraße", "Zanklstraße", "Elisabethstraße", "Heinrichstraße", "Leonhardstraße", "Kärntnerstraße", "Neubaugasse", "Sesamstraße", "Kepplerstraße"
]

# 5 zip code + cities
ZIP_CODE_CITIES = [
    "8010 Graz", "8020 Graz", "8200 Gleisdorf", "8311 Markt Hartmannsdorf", "8160 Weiz"
]



# Products------------------------------------------------
# number of products
N_PRODUCTS = 10000

# 10 product name prefixes
PRODUCT_PREFIXES = [
    "super", "ultimate", "red", "blue", "white", "black", "strong", "electric", "diesel powered", "petrol powered"
]

# 10 product names
PRODUCT_NAMES = [
    "A-Class", "B-Class", "C-Class", "CLA-Class", "CLE-Class", "CLS-Class", "E-Class", "G-Class", "S-Class", "X-Class"
]

# 10 product name suffixes
PRODUCT_SUFFIXES = [
    "AMG", "Maybach", "Brabus", "Coupé", "Limousine", "Stationwagon", "Performance", "Convertible", "Allroad", "Limited Edition"
]


# Orders------------------------------------------------
# number of orders
N_ORDERS = 100000

# 
ORDER_STATUS = [
    "ordered", "packaged", "shipped", "delivered", "canceled"
]


conn = connect("./onlineshop.db")

def create_customers(conn):
    counter = 0
    while counter < N_CUSTOMERS:
        sql = """ 
        INSERT INTO kunde(vorname, nachname, email, geburtsdatum, telefon, adresse)
        VALUES (?, ?, ?, ?, ?, ?)
        """
        cursor = conn.cursor()
        first_name = random.choice(FIRST_NAMES)
        last_name = random.choice(LAST_NAMES)
        email = f"{first_name}.{last_name}{random.choice(DOMAINS)}"
        birthdate = f"{random.randint(1940, 2012)}-{random.randint(1, 12):02d}-{random.randint(1, 28):02d}"
        phone = f"{random.choice(COUNTRY_CODES)}{random.choice(CARRIER_CODES)}{random.randint(100000, 9999999)}"
        address = f"{random.choice(STREETS)} {random.randint(1, 200)}, {random.choice(ZIP_CODE_CITIES)}"
        cursor.execute(sql, (first_name, last_name, email, birthdate, phone, address))
        counter += 1
    conn.commit()

def create_product(conn):
    counter = 0
    while counter < N_PRODUCTS:
        sql = """ 
        INSERT INTO produkt(bezeichnung, preis, lagerbestand)
        VALUES (?, ?, ?)
        """
        cursor = conn.cursor()
        product_name = f"{random.choice(PRODUCT_PREFIXES)} {random.choice(PRODUCT_NAMES)} {random.choice(PRODUCT_SUFFIXES)}"
        price = f"{random.randint(40000, 1000000)}"
        quantity = f"{random.randint(1, 150)}"
        cursor.execute(sql, (product_name, price, quantity))
        counter += 1
    conn.commit()

def create_order(conn):
    counter = 0
    while counter < N_ORDERS:
        sql = """ 
        INSERT INTO bestellung(kunde_id, bestelldatum, status)
        VALUES (?, ?, ?)
        """
        cursor = conn.cursor()
        customer_id = random.randint(1, N_CUSTOMERS)
        date = f"{random.randint(2020, 2026)}-{random.randint(1, 12):02d}-{random.randint(1, 28):02d}"
        status = f"{random.choice(ORDER_STATUS)}"
        cursor.execute(sql, (customer_id, date, status))
        counter += 1
    conn.commit()
