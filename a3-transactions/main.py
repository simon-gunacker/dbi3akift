from sqlite3 import connect

from transaction import update_table

# Einfache Bestellung
# Implementiere eine Transaktion für folgende Bestellung:
#
# Kunde: TechShop Wien (ID=1)
# Artikel: 5x Arduino Uno, 2x Raspberry Pi 4, 50x LED rot
# Die Transaktion muss:
#
# 1. Neue Bestellung anlegen
#   kunde_id
#   status
#   gesamtwert -
# 2. Bestellpositionen einfügen
# 3. Lagerbestand reduzieren
# 4. Gesamtwert berechnen und eintragen
# 5. Kundenkredit erhöhen
# 6. Lagerbewegungen protokollieren

DB = "shop.db"

# bestellung
kunde_id = 1
status = "verarbeitet"

# bestellposition
bestellung_id = -1
bestellung = {
        1: 5,
        2: 2,
        3: 50
    }
artikel_id = [1, 2, 3]

def main():
    with connect(DB) as con:
        cur = con.cursor()

        cur.execute("BEGIN TRANSACTION")

        # bestellung
        gesamtwert = 0
        bestellung_vals = [kunde_id, status, gesamtwert]
        bestellung_cols = "('kunde_id', 'status', 'gesamtwert')"
        # update_table returns list of tuple - [0][0]
        bestellung_id = update_table(
            cur, "bestellung", bestellung_cols,  bestellung_vals
            )[0][0]

        # bestellposition
        for b_id, amount in bestellung.items():
            artikel_id = b_id
            menge = amount
            einzelpreis = cur.execute(
                f"SELECT verkaufspreis FROM artikel WHERE" +\
                f"id={b_id}").fetchall()[0][0]
            gesamtwert += einzelpreis*menge
            bestellpos_vals = [bestellung_id, artikel_id, menge, einzelpreis]
            bestellpos_cols = "('bestellung_id', 'artikel_id', 'menge', 'einzelpreis')"
            update_table(
                cur, "bestellposition", bestellpos_cols,
                bestellpos_vals
                )


        # update gesamtwert
        cur.execute(f"UPDATE bestellung SET gesamtwert={gesamtwert} WHERE id={bestellung_id}")

        print(*cur.execute("SELECT * FROM bestellung").fetchall())
        print(*cur.execute("SELECT * FROM bestellposition").fetchall())

        cur.execute("ROLLBACK")

if __name__ == "__main__":
    main()

