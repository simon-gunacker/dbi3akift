import sqlite3
import csv

conn = sqlite3.connect("datenbank.db")
cursor = conn.cursor()

def report_erstellen(sql, params, dateiname):
    cursor.execute(sql, params)
    rows = cursor.fetchall()
    header = [description[0] for description in cursor.description]

    with open(dateiname, "w", newline="", encoding="utf-8") as csv_file:
        writer = csv.writer(csv_file, delimiter=";")
        writer.writerow(header)
        writer.writerows(rows)

report_erstellen(
    """ SELECT id, name, lagerbestand, mindestbestand-lagerbestand AS fehlmenge
        FROM artikel
        WHERE lagerbestand < mindestbestand;""",
        (),
        "report_mindestbestand.csv"
    )

report_erstellen(
    """ SELECT id, name, aktueller_kredit, 
                ROUND(aktueller_kredit * 100.0 / kreditlimit, 1) AS auslastung_prozent,
                kreditlimit
        FROM kunde
        WHERE aktueller_kredit > (kreditlimit * 0.9);""",
        (),
        "report_kreditlimit_ausgeschoepft.csv"
)

report_erstellen(
    """ SELECT DATE('now') AS datum, SUM(gesamtwert) AS umsatz
        FROM bestellung
        WHERE status != 'storniert'
        AND DATE(datum) = DATE('now')
    """,
    (),
    "report_umsatz_aktuell.csv"
)

conn.close()