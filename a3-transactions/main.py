from sqlite3 import connect

from transaction import insert_table

DB = "shop.db"

# bestellung
kunde_id = 1
status = "verarbeitet"

# bestellposition
bestellung_id = -1
artikel_menge = {
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
        # update_table returns list of tuple with id - [0][0]
        bestellung_id = insert_table(
            cur, "bestellung", bestellung_cols,
            bestellung_vals, return_id = True
            )[0][0]

        # bestellposition
        for artikel_id, menge in artikel_menge.items():

            # update lagerbestand
            cur.execute(
                f"UPDATE artikel SET lagerbestand = lagerbestand - {menge} WHERE id = {artikel_id}"
                )

            # get needed values for bestellpos
            einzelpreis = cur.execute(
                f"SELECT verkaufspreis FROM artikel WHERE id={artikel_id}"
                ).fetchall()[0][0]
            gesamtwert += einzelpreis * menge
            bestellpos_vals = [bestellung_id, artikel_id, menge, einzelpreis]
            bestellpos_cols = "('bestellung_id', 'artikel_id', 'menge', 'einzelpreis')"
            insert_table(
                cur, "bestellposition", bestellpos_cols, bestellpos_vals
                )

            # lagerbewegung
            typ = "verkauf"
            lager_vals = [artikel_id, bestellung_id, menge, typ]
            lager_cols = "('artikel_id', 'bestellung_id', 'menge', 'typ')"
            insert_table(
                cur, "lagerbewegung", lager_cols, lager_vals
                )

        # update gesamtwert
        cur.execute(f"UPDATE bestellung SET gesamtwert={gesamtwert} WHERE id={bestellung_id}")

        # update kundenkredit
        cur.execute(f"UPDATE kunde SET aktueller_kredit = aktueller_kredit + {gesamtwert} WHERE id={kunde_id}")



        print(
            "Bestellung: ",
            *cur.execute("SELECT * FROM bestellung").fetchall()
            )
        print(
            "Bestellpos: ",
            *cur.execute("SELECT * FROM bestellposition").fetchall()
            )
        print(
            "Lager: ",
            *cur.execute("SELECT * FROM lagerbewegung").fetchall()
            )
        print(
            "Artikel: ",
            *cur.execute("SELECT * FROM artikel").fetchall()
            )
        print(
            "Kunde: ",
            *cur.execute("SELECT * FROM kunde").fetchall()
            )

        cur.execute("END TRANSACTION")

if __name__ == "__main__":
    main()

