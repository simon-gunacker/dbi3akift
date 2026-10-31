import sqlite3
import csv

conn = sqlite3.connect("datenbank.db")
cursor = conn.cursor()

def report_erstellen(sql, params, dateiname):
    SCHWELLE_FUER_KREDITLIMIT = 0.9

    cursor.execute(sql, params)
    rows = cursor.fetchall()
    header = [description[0] for description in cursor.description]

    with open(dateiname, "w", newline="", encoding="utf-8") as csv_file:
        writer = csv.writer(csv_file, delimiter=";")
        writer.writerow(header)
        writer.writerows(rows)



report_erstellen(
    """SELECT id, name, lagerbestand, mindestbestand-lagerbestand AS fehlmenge
        FROM artikel
        WHERE lagerbestand < mindestbestand;""",
        (),
        "report_mindestbestand.csv"
        )

conn.close()