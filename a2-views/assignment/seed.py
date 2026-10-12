from sqlite3 import connect
import random

random.seed(1)

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

# 5 zip code + cities
ZIP_CODE_CITIES = [
    "8010 Graz", "8020 Graz", "8200 Gleisdorf", "8311 Markt Hartmannsdorf", "8160 Weiz"
]

