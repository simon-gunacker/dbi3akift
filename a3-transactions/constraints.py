
def handle_constraint(
    cur: object, error_type: str, target_id: int,
    bestellung: dict = None, menge: int=0, bestellung_id: int=0
    ) -> None:

    # reorder product with amount of order + 10 and create
    # lagerbewegung
    if error_type == "lagerbestand":
        print(
            f"FEHLER: Lagerbestand von Artikel '{target_id}' zu klein - Nachbestellung von {menge} Stück wird durchgeführt"
            )
        # only change lagerbewegung, reordered amount
        # wont be stored, but sold
        cur.execute(
                f"INSERT INTO lagerbewegung(artikel_id, bestellung_id, menge, typ) VALUES (?, ?, ?, ?)", [target_id, bestellung_id, menge, 'nachlieferung']
                )

    # set price of bestellung to 0 and make it a storno
    elif error_type == "kreditlimit":
        print("FEHLER: Kreditlimit überschritten, Bestellung storniert")
        cur.execute(
            f"UPDATE bestellung SET gesamtwert=0, status='storniert' WHERE id={bestellung_id}"
            )
        for artikel_id, art_menge in bestellung.items():
            cur.execute(
                f"UPDATE artikel SET lagerbestand = lagerbestand + {art_menge} WHERE id = {artikel_id}"
                )
        cur.execute(f"DELETE FROM lagerbewegung WHERE bestellung_id={bestellung_id}")


