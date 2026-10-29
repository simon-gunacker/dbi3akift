
def handle_constraint(
    cur: object, error_type: str, target_id: int, menge: int=0,
    bestellung_id: int=0
    ):
    # reorder product with amount of order + 10 and create
    # lagerbewegung
    if error_type == "lagerbestand":
        print(
            f"FEHLER: Lagerbestand von '{target_id}' zu klein - Nachbestellung von {menge+10} wird durchgeführt"
            )
        cur.execute(
                f"INSERT INTO lagerbewegung(artikel_id, bestellung_id, menge, typ) VALUES (?, ?, ?, ?)", [target_id, bestellung_id, menge, 'nachlieferung']
                )
        cur.execute(
            f"UPDATE artikel SET lagerbestand = {menge + 10} WHERE id={target_id}"
            )

    # set price of bestellung to 0 and make it a storno
    elif error_type == "kreditlimit":
        gesamtwert = 0
        status = 'storniert'
        print(status, "FEHLER: Kreditlimit überschritten, bestellung storniert")
        cur.execute(
            f"UPDATE bestellung SET gesamtwert={gesamtwert}, status='{status}' WHERE id={bestellung_id}"
            )
        cur.execute(f"DELETE FROM lagerbewegung WHERE bestellung_id={bestellung_id}")


