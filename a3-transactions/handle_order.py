from typing import Any
import sqlite3

from constraints import handle_constraint

def insert_into_table(
    cur: object, table_name: str, cols: tuple, vals: list,
    return_id: bool = False
    ) -> Any:
    if return_id:
        sql = f"INSERT INTO {table_name}{cols} VALUES "\
            f"({('?, '*len(vals))[:-2]}) RETURNING id"
        res = cur.execute(sql, vals)

        return res.fetchall()
    sql = f"INSERT INTO {table_name}{cols} VALUES({('?, '*len(vals))[:-2]})"
    cur.execute(sql, vals)

def create_new_order(
    cur: object, kunde_id: int, bestellung: dict, tables: list
    ) -> None:

    cur.execute("BEGIN TRANSACTION")

    # bestellung
    gesamtwert = 0
    status = 'offen'
    bestellung_vals = [kunde_id, gesamtwert]
    bestellung_cols = "('kunde_id', 'gesamtwert')"
    # update_table returns list of tuple with id - [0][0]
    bestellung_id = insert_into_table(
        cur, "bestellung", bestellung_cols,
        bestellung_vals, return_id = True
        )[0][0]

    # bestellposition
    for artikel_id, menge in bestellung.items():

        # update lagerbestand
        try:
            cur.execute(
            f"UPDATE artikel SET lagerbestand = lagerbestand - {menge} WHERE id = {artikel_id}"
            )
        except:
            handle_constraint(cur, 'lagerbestand', artikel_id, menge=menge, bestellung_id=bestellung_id)

        # get needed values for bestellpos
        einzelpreis = cur.execute(
            f"SELECT verkaufspreis FROM artikel WHERE id={artikel_id}"
            ).fetchall()[0][0]
        gesamtwert += einzelpreis * menge
        bestellpos_vals = [bestellung_id, artikel_id, menge, einzelpreis]
        bestellpos_cols = "('bestellung_id', 'artikel_id', 'menge',"\
            + "'einzelpreis')"
        insert_into_table(
            cur, "bestellposition", bestellpos_cols, bestellpos_vals
            )

        # lagerbewegung
        typ = "verkauf"
        lager_vals = [artikel_id, bestellung_id, menge*-1, typ]
        lager_cols = "('artikel_id', 'bestellung_id', 'menge', 'typ')"
        insert_into_table(
            cur, "lagerbewegung", lager_cols, lager_vals
            )

    # update gesamtwert & kundenkredit
    try:
        cur.execute(
        f"UPDATE kunde SET aktueller_kredit = aktueller_kredit + {gesamtwert} WHERE id={kunde_id}"
        )
        cur.execute(f"UPDATE bestellung SET gesamtwert={gesamtwert} WHERE id={bestellung_id}")
    except:
        handle_constraint(
            cur, "kreditlimit", kunde_id,
            bestellung_id=bestellung_id, bestellung=bestellung
            )
    cur.execute("END TRANSACTION")
