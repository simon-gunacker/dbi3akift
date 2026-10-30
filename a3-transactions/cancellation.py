

def cancel_order(cur: object) -> None:

    cur.execute("BEGIN TRANSACTION")

    bestellung_id = input("Bestellung_id um Bestellung zu stornieren (Enter zum Beenden): ")
    if bestellung_id == "":
        print("Cancellation cancelled")
        return
    # set bestellung to storniert and bestellwert to 0
    cur.execute(
        "UPDATE bestellung SET status='storniert', gesamtwert=0 WHERE id=?", [bestellung_id]
        )
    # delete all lagerbewegungen of the cancelled order
    cur.execute(
        "DELETE FROM lagerbewegung WHERE id=?", [bestellung_id]
        )
    # get bestellpositions of the selected order
    best_pos = cur.execute(
        "SELECT artikel_id, menge FROM bestellposition WHERE bestellung_id=?", [bestellung_id]
        ).fetchall()

    # update lagerbestand
    for line in best_pos:
        art_id, menge = line[0], line[1]
        cur.execute(
            f"UPDATE artikel SET lagerbestand = lagerbestand + {art_menge} WHERE id = {art_id}"
            )

    cur.execute("END TRANSACTION")
