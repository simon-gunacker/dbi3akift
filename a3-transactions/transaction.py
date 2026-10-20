from sqlite3 import connect

# Einfache Bestellung
# Implementiere eine Transaktion für folgende Bestellung:
#
# Kunde: TechShop Wien (ID=1)
# Artikel: 5x Arduino Uno, 2x Raspberry Pi 4, 50x LED rot
# Die Transaktion muss:
#
# 1. Neue Bestellung anlegen
# 2. Bestellpositionen einfügen
# 3. Lagerbestand reduzieren
# 4. Gesamtwert berechnen und eintragen
# 5. Kundenkredit erhöhen
# 6. Lagerbewegungen protokollieren

def update_table(
    cur: object, table_name: str, cols: tuple, vals: list
    ) -> list:
    sql = f"INSERT INTO {table_name}{cols} VALUES({('?, '*len(vals))[:-2]}) RETURNING id"

    res = cur.execute(sql, vals)

    return res.fetchall()





# def create_order(cur: object, values: list):
#     sql = """
#         INSERT INTO bestellung (kunde_id, gesamtwert)
#         VALUES (?, ?)
#     """
#
#     cmd = cur.execute(sql, values)
#     print(cur.fetchone(cmd))
#
# def update_bestellpos(cur: object, values: list):
#     sql = """
#         INSERT INTO bestellposition (
#             bestellung_id, artikel_id, menge, einzelpreis
#         ) VALUES (?, ?, ?, ?)
#     """
#
#     cmd = cur.execute(sql, values)
#     print(cur.fetchone(cmd))
#
# def update_lagerbewegung(cur: object, values: list):
#     sql = """
#         INSERT INTO lagerbewegung (
#             artikel_id, bestellung_id, menge, typ
#         ) VALUES (?, ?, ?, ?)
#     """
#
#     cmd = cur.execute(sql, values)
#     print(cur.fetchone(cmd))
