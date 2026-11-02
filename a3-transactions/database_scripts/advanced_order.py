#!usr/bin/env python3

import sqlite3

def execute_advanced_order(kunde_id, items, db="warehouse.db"):
    try:
        with sqlite3.connect(db) as conn:
            cursor = conn.cursor()
            cursor.execute("BEGIN TRANSACTION;")

            # Customer credit limit validation
            cursor.execute(
                "SELECT kreditlimit, aktueller_kredit, name FROM kunde WHERE id = ?;", 
                (kunde_id,)
            )
            customer = cursor.fetchone()

            if not customer:
                raise ValueError(f"Customer ID: {kunde_id} does not exist.")

            kreditlimit, aktueller_kredit, customer_name = customer
            total_order_value = sum(menge * preis for _, menge, preis in items)

            if aktueller_kredit + total_order_value > kreditlimit:
                raise ValueError(
                    f"Credit limit exceeded for {kunde_id}!"
                    f"Credit limit: {kreditlimit}, Current Credit: {aktueller_kredit}"
                    f"Total value: {total_order_value}"
                )

            # Stock availability validation
            for artikerl_id, menge, _ in items:
                cursor.execute(
                    "SELECT lagerbestand, name FROM artikel WHERE id = ?", 
                    (artikerl_id,)
                )
            article = cursor.fetchone()

            if not article:
                raise ValueError(f"Article ID {artikerl_id} does not exist.")

            stock, article_name = article
            if stock < menge:
                raise ValueError(
                    f"Insifficient stock for {article_name} (ID: {artikerl_id})."
                    f"Current order: {menge}, Available: {stock}"
                )


            # Actual order
            cursor.execute(
                "INSERT INTO bestellung (kunde_id) VALUES (?);", (kunde_id,)
            )

            # Get last order
            bestellung_id = cursor.lastrowid

            for artikel_id, menge, preis in items:
                cursor.execute(
                    "INSERT INTO bestellposition (bestellung_id, artikel_id, menge, einzelpreis) VALUES (?, ?, ?, ?);", 
                    (bestellung_id, artikel_id, menge, preis)
                )

                cursor.execute(
                    "UPDATE artikel SET lagerbestand = lagerbestand - ? WHERE id = ?;", 
                    (menge, artikel_id)
                )

                cursor.execute(
                    "INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ) VALUES (?, ?, ?, 'verkauf');", 
                    (artikel_id, bestellung_id, -menge)
                )

            # Update total value
            cursor.execute(
                "UPDATE bestellung SET gesamtwert = ? WHERE id = ?;", 
                (total_order_value, bestellung_id)
            )

            # Increase Customer Credit
            cursor.execute(
                "UPDATE kunde SET aktueller_kredit = aktueller_kredit + ? WHERE id = ?;", 
                (total_order_value, kunde_id)
            )

            cursor.commit()
            print(f"Order executed successfully! Order value: {total_order_value:.2f}")


    except sqlite3.Error as err:
        cursor.rollback()
        print(f"Transfare failed. Rolled back changes. Error: {err}")
        raise

if __name__ == "__main__":
    print("--- Test Oreder 1: Valid Order ---")
    execute_advanced_order(2, [(4, 50, 0.05)])

    print("\n--- Test Oreder 2: Invalid Stock ---")
    execute_advanced_order(2, [(2, 500, 75.00)])

    print("\n--- Test Oreder 3: Invalid Credit ---")
    execute_advanced_order(1, [(2, 100, 75.00)])
