

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

    # get needed values
    result = cur.execute(
        "SELECT artikel_id, menge FROM bestellposition WHERE bestellung_id=?",
        bestellung_id
        ).fetchall()

    # create lagerbewegung for storno
    # for artikel_id, art_menge in result:

    # get bestellpositions of the selected order
    best_pos = cur.execute(
        "SELECT artikel_id, menge FROM bestellposition WHERE bestellung_id=?", [bestellung_id]
        ).fetchall()

    for line in best_pos:
        art_id, menge = line[0], line[1]
        # update lagerbestand
        cur.execute(
            f"UPDATE artikel SET lagerbestand = lagerbestand + {menge} WHERE id = {art_id}"
            )
        # create lagerbewegungen
        cur.execute(
            f"INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?, ?, ?, ?)",
            [art_id, bestellung_id, menge, 'storno']
            )


    if bestellung_id != '':
        input(
            f"Bestellung {bestellung_id} wurde storniert - (Enter zum Fortfahren)"
            )

    cur.execute("END TRANSACTION")
