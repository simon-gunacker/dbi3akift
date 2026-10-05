import sqlite3
import random

random.seed(10)

def checkDuplicate(checksum, cur, table , column):
    sqlValue = cur.execute(f"SELECT {column} FROM {table} WHERE {column} = '{checksum}'")
    if (sqlValue.fetchone() != None and checksum == sqlValue.fetchone()[0]): return True
    else: return False


class Customer:
    def __init__(self, database, table):
        self.db = sqlite3.connect(database)
        self.cur = self.db.cursor()
        self.table = table
        self.firstNames = ["Hans", "Peter"]
        self.lastNames = ["Meier", "Huber"]
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
        while (checkDuplicate(self.genEmail(), self.db, self.table ,"'email'")):
            self.genEmail()
        self.email = self.genEmail()

    def genBirthdate(self):
        year = random.randrange(1930, 2008)
        month = random.randrange(1, 13)

        if year % 4 & year and 100 == 0 or year % 400 == 0: day = random.randrange(1, 29)
        else:  day = random.randrange(1, 30)

        if month % 2 and month != 2: day = random.randrange(1, 31)
        if month != 2: day = random.randrange(1, 32)

        return str(year) + "-" + str(month) + "-" + str(day)

    def setBirthdate(self):
        self.birthdate = self.genBirthdate()

    def genTelNumber(self):
        return "0" + str(random.randrange(660, 670)) + str(random.randrange(100, 10000000))

    def setTelNumber(self):
        while (checkDuplicate(self.genTelNumber(), self.cur, self.table, "telefon")):
            self.genTelNumber()
        self.telNumber = self.genTelNumber()

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

Kunde = Customer("mydb.db", "kunde")
print(Kunde.getCustomer())

