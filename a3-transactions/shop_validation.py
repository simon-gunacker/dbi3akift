import sqlite3
from shop import transaction, with_connect


@with_connect("storage.db")
def safe_transaction(conn, customer, article):
    try:
        transaction(conn, customer, article)
        print("Bestellung erfolgreich")
    except sqlite3.IntegrityError as e:
        print(f"Bestellung abgelehnt: {e}")


@with_connect("storage.db")
def show_state(conn):
    print("Bestellungen:", conn.execute("SELECT COUNT(*) FROM bestellung").fetchone())
    print(
        "Positionen:",
        conn.execute("SELECT COUNT(*) FROM bestellposition").fetchone(),
    )
    print("Lagerbestand:", conn.execute("SELECT lagerbestand FROM artikel").fetchall())
    print("Kredit:", conn.execute("SELECT aktueller_kredit FROM kunde").fetchall())


print("Status vor Transaktion")
show_state()
print("-" * 25)
safe_transaction("TechShop Wien", {"Arduino Uno": 150})
safe_transaction("MakerSpace Graz", {"Raspberry Pi 4": 40})
print("-" * 25)
print("Status nach Transaktion")
show_state()
