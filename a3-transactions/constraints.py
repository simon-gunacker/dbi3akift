
"""

if lagerbestand < 0 --> refill lager

"""

def get_value(cur: object, col: str, target_id: int) -> str:
    return cur.execute(
        f"SELECT {col} FROM artikel WHERE id={target_id}"
        ).fetchall()[0][0]

def check_constraint(
    cur: object, error: str, bestellung: dict
    ) -> None:
    print("Check constr: ", error)

    # error = lagerbestand
    if error.find("lagerbestand") != -1:
        # find artikel to reorder
        for artikel_id, menge in bestellung.items():
            lagerbestand = get_value(
                cur, 'lagerbestand', artikel_id
                )
            if menge > lagerbestand:
                artikel = get_value(cur, 'name', artikel_id)
                order_amount = menge
        if artikel:
            print(
                f"Lagerbestand von {artikel} zu klein, Nachbestellung wird durchgeführt"
                )
            cur.execute(
                f"UPDATE artikel SET lagerbestand = {order_amount}"
                )
