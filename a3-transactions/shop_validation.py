import sqlite3
from shop import transaction, with_connect


@with_connect("storage.db")
def safe_transaction(conn, customer, article):
    try:
        transaction(conn, customer, article)
        print("Bestellung erfolgreich")
    except sqlite3.IntegrityError as e:
        print(f"Bestellung abgelehnt: {e}")


safe_transaction("TechShop Wien", {"Arduino Uno": 150})
safe_transaction("MakerSpace Graz", {"Raspberry Pi 4": 40})
