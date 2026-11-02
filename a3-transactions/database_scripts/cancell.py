#!usr/bin/env python3

import sqlite3

def cancell_order(order_id, db="warehouse.db"):
    try:
        with sqlite3.connect(db) as conn:
            cursor = conn.cursor()
            cursor.execute("BEGIN TRANSACTION;")

            # Cancel order
            cursor.execute(
                "SELECT kunde_id, status, gesamtwert FROM bestellung WHERE id = ?;", 
                (order_id,)
            )
            order = cursor.fetchone()

            if not order:
                raise ValueError(f"Order ID: {order_id} does not exist.")

            kunde_id, status, gesamtwert = order

            if status == 'storniert':
                raise ValueError(f"Order {order_id} is already cancelled.")

            # Update order status
            cursor.execute(
                "UPDATE bestellung SET status = 'storniert' WHERE id = ?;", 
                (order_id,) 
            )

            # Reset stock and add 'storno'
            cursor.execute(
                "SELECT artikel_id, menge FROM bestellposition WHERE id = ?;", 
                (order_id,)
            )
            items = cursor.fetchall()

            for artikel_id, menge in items:
                cursor.execute(
                    "UPDATE artikel SET lagerbestand = lagerbestand + ?;", 
                    (menge,)
                )
                cursor.execute(
                    "INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?, ?, ?, 'storno');", 
                    (artikel_id, order_id, menge)
                )

                cursor.execute(
                    "UPDATE kunde SET aktueller_kredit = aktueller_kredit  ? WHERE id = ?;",
                    (gesamtwert, kunde_id)
                )

            cursor.commit()
            print(f"Order ID: {order_id} was successfully cancelled.")


    except sqlite3.Error as err:
        cursor.rollback()
        print(f"Transfare failed. Rolled back changes. Error: {err}")
        raise

if __name__ == "__main__":
    cancell_order(1)
