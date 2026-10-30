

def cancel_order(cur: object) -> None:
    bestellung_id = input("Bestellung_id um Bestellung zu stornieren (Enter zum Beenden): ")
    if bestellung_id == "":
        print("Cancellation cancelled")
        return
    # bestellung = cur.execute(
    #     "SELECT * FROM bestellung WHERE id=?", [bestellung_id]
    #     ).fetchall()
    cur.execute(
        "UPDATE bestellung SET status='storniert', gesamtwert=0 WHERE id=?", [bestellung_id]
        )
    cur.execute(
        "DELETE FROM lagerbewegung WHERE id=?", [bestellung_id]
        )
    best_pos = cur.execute(
        "SELECT artikel_id, menge FROM bestellposition WHERE bestellung_id=?", [bestellung_id]
        ).fetchall()

    bestellung = dict()
    for line in best_pos:
        art_id, menge = line[0], line[1]
        bestellung[art_id] = menge
    for art_id, art_menge in bestellung.items():
         cur.execute(
            f"UPDATE artikel SET lagerbestand = lagerbestand + {art_menge} WHERE id = {art_id}"
            )
