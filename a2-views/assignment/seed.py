from sqlite3 import connect
import random


def insertProdukt(conn):
    productsDict = {"Mouse":(10,80),  "Keyboard":(20,150), "Monitor":(120, 600), "Headset":(25,200), "Webcam":(30,150), "Speaker":(20,250), "Microphone":(30,200), "USB Stick":(5,40), "Hard Drive":(50,200), "SSD":(40,300), "Charger":(15,60), "Cable":(5,25)}

    brandsList = ["Logitech", "Dell", "Lenovo", "Samsung", "HP", "Asus", "Acer", "Sony", "Philips", "Corsair"]

    colorsList = ["Black", "White", "Grey", "Silver", "Blue", "Red"]

    listContainer = [productsDict, brandsList, colorsList]
    product = ""
    preis = ""

    n = 10000

    for it in range(n):
        for item in listContainer:
            productNom = random.choice(list(item))
            product = product + productNom + " "
            if productNom in productsDict:
                preis = random.uniform(productsDict[productNom][0],productsDict[productNom][1])
        lager = random.randint(0,500)
        conn.execute("INSERT INTO produkt(bezeichnung, preis, lagerbestand) VALUES (?,?,?)",
                             (product.strip(), round(preis,2), lager))
        product = ""


def insertKunde(conn):
    nameList = ["Anna", "Lukas", "Sophie", "Maximiliam", "Laura", "David", "Lena", "Tobias", "Julia", "Jakop", "Sarah", "Felix", "Hannah", "Elias", "Katharina", "Paul", "Marie", "Simon", "Lisa", "Florian", "Emma", "Stefan", "Nina", "Michael", "Clara", "Thomas", "Theresa"]
    nachnameList = ["Gruber", "Huber", "Bauer", "Wagner", "Lang", "Pichler", "Steiner", "Moser", "Mayer", "Hofer", "Leitner", "Berger", "Fuchs", "Eder", "Fischer", "Schmid", "Winkler", "Weber", "Schwarz", "Maier", "Schneider", "Reiter", "Mayr", "Schmidt", "Winmer", "Egger", "Brunner"]
    emailList = ["gmail.com", "gmx.at", "outlook.com", "aon.at", "yahoo.com", "icloud.com"]
    prefixList = ["664", "660", "676", "650", "699", "681"]

    streetList = ["Hauptstraße", "Bahnhofstraße", "Schulgasse", "Kirchengasse", "Gartengasse",
              "Lindenweg", "Bergstraße", "Feldgasse", "Mühlweg", "Parkstraße"]

    cityList = ["1010 Wien", "8010 Graz", "4020 Linz", "5020 Salzburg", "6020 Innsbruck",
            "9020 Klagenfurt", "3100 St. Pölten", "7000 Eisenstadt", "6900 Bregenz",
            "8111 Judendorf-Straßengel"]
    n= 10000

    for item in range(1,(n+1)):
        name = random.choice(nameList)
        nachname = random.choice(nachnameList)
        email = name +"."+nachname +str(item)+"@"+random.choice(emailList)
        year = random.randint(1946, 2008)
        month = random.randint(1,12)
        day = random.randint(1,28)
        datum = f"{year}-{month:02}-{day:02}"
        phone = "+43 "+random.choice(prefixList) +" "+str(random.randint(1000000,9999999))
        street = str(random.choice(streetList))+" "+str(random.randint(1,150)) +", " +random.choice(cityList)
        conn.execute("INSERT INTO kunde(vorname, nachname, email, geburtsdatum, telefon, adresse) VALUES (?,?,?,?,?,?)",
                     (name, nachname, email, datum, phone, street))


def insertBestellung(conn):
    statusList = ["offen", "bezahlt", "versendet", "geliefert", "storniert"]
    n= 100000

    for item in range(n):
        clientId= random.randint(1,10000)
        year = random.randint(2021,2026)
        month = random.randint(1,12)
        if year == 2026:
            month = random.randint(1,9)
        day = random.randint(1,28)
        hour = random.randint(0,23)
        minute = random.randint(0,59)
        second = random.randint(0,59)
        orderDate = f"{year}-{month:02}-{day:02} {hour:02}:{minute:02}:{second:02}"
        status = random.choice(statusList)
        conn.execute("INSERT INTO bestellung(kunde_id, bestelldatum, status) VALUES(?,?,?)",
                     (clientId, orderDate, status))



def insertBestellposition(conn):
    n= 100000
    for bestellung_id in range(1,n+1):
        products = random.sample(range(1,10001), 5)
        for produkt_id in products:
            menge = random.randint(1,5)
            conn.execute("INSERT INTO bestellposition(bestellung_id, produkt_id, menge)VALUES (?,?,?)", (
                bestellung_id, produkt_id, menge))


##--------------------main----------------------

def main():
    random.seed(42)

    with connect("model.db") as conn:
        insertProdukt(conn)
        insertKunde(conn)
        insertBestellung(conn)
        insertBestellposition(conn)

    conn.close()

if __name__=="__main__":
    main()





