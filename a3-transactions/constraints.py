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

    # error = lagerbestand
    if error.find("lagerbestand") != -1:
        # find artikel to reorder
        for artikel_id, menge in bestellung.items():
            lagerbestand = get_value(
                cur, 'lagerbestand', artikel_id
                )
            if menge > lagerbestand:
                art_name = get_value(cur, 'name', artikel_id)
                best_art_id = artikel_id
                art_min_best = get_value(
                    cur, 'mindestbestand', artikel_id
                    )
                best_menge = menge + art_min_best
        if art_name:
            print(
                f"Lagerbestand von {art_name} zu klein, Nachbestellung wird durchgeführt"
                )
            cur.execute(
                f"INSERT INTO lagerbewegung(artikel_id, menge, typ) VALUES (?, ?, ?)", [best_art_id, best_menge, 'nachlieferung']
                )
            cur.execute(
                f"UPDATE artikel SET lagerbestand = {best_menge}"
                )
