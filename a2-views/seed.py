import sqlite3
import random
import datetime

random.seed(10)

def checkDuplicate(checksum, cur, table , column):
    sqlValue = cur.execute(f"SELECT {column} FROM {table} WHERE {column} = '{checksum}'")
    if (sqlValue.fetchone() != None): return True
    else: return False

def genDate(startyear = 1930, endyear = 2007, endmonth = 13, endday = 31):
    year = random.randrange(startyear, endyear)
    month = random.randrange(1, endmonth)

    if year % 4 == 0 and year % 100 == 0 or year % 400 == 0: day = random.randrange(1, 29)
    else: day = random.randrange(1, 30)

    if month % 2 and month != 2: day = random.randrange(1, 31)
    if month != 2: day = random.randrange(1, 32)

    if endday <= 27: day = random.randrange(1, endday + 1)

    return str(year) + "-" + str(month) + "-" + str(day)



class Customer:
    def __init__(self, database, table):
        self.db = database
        self.cur = self.db.cursor()
        self.table = table
        self.firstNames = ["Hans", "Peter","Gerald","Max","Thorsten","Günther","Marie","Lisa","Laura","Sarah"]
        self.lastNames = ["Meier", "Huber","Mayer", "Maier", "Habsburg", "Laundl", "Weiß", "Schwarz", "Puntigam", "Hauer", "Eisen", "Winkler", "Stolz"]
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.mailDomains = ["gmail.com", "gmx.at","proton.me"]
        self.birthdate = ""
        self.telNumber = ""
        self.addressStreetsPrefix = ["Weiden", "Hof"]
        self.addressStreetsSuffix = ["straße", "weg", "gasse"]
        self.address = ""

    def setFirstname(self):
        self.firstName = self.firstNames[random.randrange(0, len(self.firstNames))]

    def setLastname(self):
        self.lastName = self.lastNames[random.randrange(0, len(self.lastNames))]

    def genEmail(self):
        return self.firstName + str(random.randrange(1, 100)) + self.lastName + "@" + self.mailDomains[random.randrange(0, len(self.mailDomains))]

    def setEmail(self):
        self.email = self.genEmail()
        if (checkDuplicate(self.email, self.db, self.table ,"email")): self.setEmail()

    def genBirthdate(self):
        return genDate()

    def setBirthdate(self):
        self.birthdate = self.genBirthdate()

    def genTelNumber(self):
        return "0" + str(random.randrange(660, 670)) + str(random.randrange(100, 10000000))

    def setTelNumber(self):
        self.telNumber = self.genTelNumber()
        if checkDuplicate(self.telNumber, self.cur, self.table, "telefon"): self.setTelNumber()

    def genAddress(self):
        return self.addressStreetsPrefix[random.randrange(0, len(self.addressStreetsPrefix))] + self.addressStreetsSuffix[random.randrange(0, len(self.addressStreetsSuffix))] + " " + str(random.randrange(1, 100))

    def setAddress(self):
        self.address = self.genAddress()

    def getCustomer(self):
        self.setFirstname()
        self.setLastname()
        self.setEmail()
        self.setBirthdate()
        self.setTelNumber()
        self.setAddress()
        return [self.firstName, self.lastName, self.email, self.birthdate, self.telNumber, self.address]


class Order:
    def __init__(self, database, table):
        self.db = database
        self.cur = self.db.cursor()
        self.table = table
        self.customers = [(row[0], int(row[1].split("-")[0])) for row in self.cur.execute("SELECT id, geburtsdatum FROM kunde").fetchall()]
        self.customerIndex = 0
        self.orderDate = ""
        self.currentDate = datetime.datetime.now().date()
        self.orderState = ""

    def selectCustomerIndex(self):
        self.customerIndex = random.randrange(0, len(self.customers))

    def setCustomerId(self):
        self.customerId = self.customers[self.customerIndex][0]

    def setOrderDate(self):
        self.orderDate = genDate(self.customers[self.customerIndex][1] + 19, self.currentDate.year , self.currentDate.month, self.currentDate.day)

    def setOrderState(self):
        stateOrderDate = self.orderDate.split("-")
        if self.currentDate.year == stateOrderDate[0] and self.currentDate.month == stateOrderdate[1] and self.currentDate.day - stateOrderDate[2] >= 3:
            self.orderState = "in delivery"
        else:
            self.orderState = "fullfilled"

    def getOrder(self):
        self.selectCustomerIndex()
        self.setCustomerId()
        self.setOrderDate()
        self.setOrderState()
        return [self.customerId, self.orderDate, self.orderState]


class Product:
    def __init__(self, database, table):
        self.db = database
        self.cur = self.db.cursor()
        self.table = table
        self.name = ""
        self.price = ""
        self.storageAmount = 0

    def setName(self):
        self.name ="Produkt " + str(random.randrange(1, 10001))

    def setPrice(self):
        self.price = str(random.randrange(10, 1001, 10) - 0.1) + "€"

    def setStorageAmount(self):
        self.storageAmount = random.randrange(100, 1000001)

    def getProduct(self):
        self.setName()
        self.setPrice()
        self.setStorageAmount()
        return [self.name, self.price, self.storageAmount]


class Orderposition:
    def __init__(self, database, table):
        self.db = database
        self.cur = self.db.cursor()
        self.table = table
        self.orderId = 0
        self.ordersRange = self.cur.execute("SELECT count(id) FROM bestellung").fetchone()[0]
        self.orderIdPool = random.sample(range(1, self.ordersRange + 1), self.ordersRange)
        self.orderChoiceIndex = len(self.orderIdPool)
        self.productsIdPool = []
        self.productsRange = self.cur.execute("SELECT count(id) FROM produkt").fetchone()[0]
        self.amountOrderedPool = []
        self.choiceIndex = 5

    def setOrderId(self):
        self.orderChoiceIndex -= 1
        self.orderId = self.orderIdPool[self.orderChoiceIndex]

    def setProductsIdPool(self):
        self.productsIdPool = random.sample(range(1, self.productsRange + 1), 5)

    def setAmountOrderedPool(self):
        self.amountOrderedPool = random.sample(range(1, 20), 5)

    def getOrderposition(self):
        if self.choiceIndex == 5:
            self.choiceIndex = 0
            self.setOrderId()
            self.setProductsIdPool()
            self.setAmountOrderedPool()
        returnList = [self.orderId, self.productsIdPool[self.choiceIndex], self.amountOrderedPool[self.choiceIndex]]
        self.choiceIndex += 1
        return returnList




if __name__ == "__main__":
    dbmain =  sqlite3.connect("mydb.db")
    curmain = dbmain.cursor()

    reset = True

    if reset:
        curmain.execute("DROP TABLE IF EXISTS kunde")
        curmain.execute("DROP TABLE IF EXISTS bestellung")
        curmain.execute("DROP TABLE IF EXISTS produkt")
        curmain.execute("DROP TABLE IF EXISTS bestellposition")

    filldoc = open("fill.sql", "r")
    for y in filldoc.read().split(";"):
        curmain.execute(y)
    dbmain.commit()

    kunde = Customer(dbmain, "kunde")
    for x in range(0, 10000):
        # executemany would violate UNIQUE constraint, due to only checking sql-database for duplicates and not the generated list, possibly solveable by using sets
        curmain.execute("INSERT INTO kunde(vorname, nachname, email, geburtsdatum, telefon, adresse) VALUES(?, ?, ? ,? ,? ,?)", kunde.getCustomer())
    dbmain.commit()
    print(curmain.execute("SELECT COUNT(id) FROM kunde").fetchone()[0])

    bestellung = Order(dbmain, "bestellung")
    bestellungsliste = []
    for x in range(0, 100000):
        bestellungsliste.append(bestellung.getOrder())
        #curmain.execute("INSERT INTO bestellung(kunde_id, bestelldatum, status) VALUES(?, ?, ?)", produkt.getOrder())

    curmain.executemany("INSERT INTO bestellung(kunde_id, bestelldatum, status) VALUES(?, ?, ?)", bestellungsliste)
    print(curmain.execute("SELECT COUNT(id) FROM bestellung").fetchone()[0])
    dbmain.commit()

    produkt = Product(dbmain, "produkt")
    produktliste = []
    for x in range(0, 10000):
        produktliste.append(produkt.getProduct())

    curmain.executemany("INSERT INTO produkt(bezeichnung, preis, lagerbestand) VALUES(?, ?, ?)", produktliste)
    print(curmain.execute("SELECT COUNT(id) FROM produkt").fetchone()[0])
    dbmain.commit()

    bestellposition = Orderposition(dbmain, "bestellposition")
    bestellpositionsliste = []
    for x in range(0, 500000):
        bestellpositionsliste.append(bestellposition.getOrderposition())
        #curmain.execute("INSERT INTO bestellposition(bestellung_id, produkt_id, menge) VALUES(?, ?, ?)", bestellposition.getOrderposition())

    #curmain.executemany("INSERT INTO bestellposition(bestellung_id, produkt_id, menge) VALUES(?, ?, ?)", bestellpositionsliste)
    print(curmain.execute("SELECT COUNT(bestellung_id) FROM bestellposition").fetchone()[0])
    dbmain.commit()

    #print(curmain.execute("SELECT COUNT(id), COUNT(DISTINCT(email)) FROM kunde").fetchone())
    print(curmain.execute(f"SELECT * FROM kunde WHERE email = '{curmain.execute("SELECT DISTINCT(email) FROM kunde").fetchone()[0]}'").fetchall())

