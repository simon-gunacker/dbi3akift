import sqlite3

conn = sqlite3.connect("transactions.db")
cursor = conn.cursor()

# Artikel die unter Mindestbestand gefallen sind
artikel = cursor.execute("""
    SELECT name, kategorie
    FROM artikel
    WHERE lagerbestand < mindestbestand;
""").fetchall()

for name, kategorie in artikel:
    print(f"Folgender Artikel ({name}) der Kategorie {kategorie} muss nachbestellt werden, da er den Mindestbestand unterschritten hat.")

# Kunden die ihr Kreditlimit fast ausgeschöpft haben 
kreditlimit = cursor.execute(""" 
    SELECT name 
    FROM kunde 
    WHERE aktueller_kredit > 0.9 * kreditlimit;
""").fetchall()

for (name,) in kreditlimit:
    print(f"Kunde {name} hat sein Kreditlimit fast ausgeschöpft")

# Umsatz des heutigen Tages
umsatz = cursor.execute("""
    SELECT SUM(gesamtwert)
    FROM bestellung
    WHERE date(datum) = date('now') AND status != 'storniert';
""").fetchone()[0]

if umsatz is None:
    print("heutige umsatz beträgt (0.00 €)")
else:
    print(f"heutige umsatz beträgt ({umsatz:.2f} €)")

# Konsistenzprüfung

kontrolle = cursor.execute("""
    SELECT a.name, a.lagerbestand, SUM(l.menge)
    FROM artikel a
    JOIN lagerbewegung l ON l.artikel_id = a.id
    GROUP BY a.id
    HAVING a.lagerbestand != SUM(l.menge);
""").fetchall()

if kontrolle:
    for name, lagerbestand, summe in kontrolle:
        print("Lagerbewegungen stimmen mit aktuellem Bestand nicht überein\n")
else:
    print("Es gibt keine abweichungen")

conn.commit()
conn.close()