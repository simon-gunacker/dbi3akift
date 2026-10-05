import sqlite3
import random

random.seed(10)

def checkDuplicate(checksum, db, table , column):
    sqlStatement = f"""
    SELECT {column} FROM {table} WHERE {column} = {checksum}
    """
    cur = db.cursor()
    sqlvalue = cur.execute(sqlStatement)[0]
    if (checksum == sqlValue): return True
    else return False


class Customer:
    def __init(self, database, table):
        self.db = database
        self.cur = self.db.cursor()
        self.table = table
        self.firstNames = [""]
        self.lastNames = [""]
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.mailDomains = [""]
        self.birthdate
        self.telNumber = ""
        self.address = ""

    def setFirstname(self):
        self.firstName = firstNames[random.randrange(0, len(self.firstNames))]

    def setLastname(self):
        self.lastName = lastNames[random.randrange(0, len(self.lastNames))]

    def genEmail(self):
        return self.firstName + str(random.randrange(1, 100)) + self.lastName + "@" + self.mailDomains[random.randrange(0, len(self.mailDomains))]

    def setEmail(self):
        while (checkDuplicate(self.genEmail(), self.db, self.table ,"email")):
            self.genEmail()
        self.email = self.genEmail()

    def genBirthdate(self):
        year = random.randrange(1930, 2008)
        month = random.randrange(1, 13)

        if year % 4 && !(year & 100) || !(year % 400): day = random.randrange(1, 29)
        else  day = random.randrange(1, 30)

        if month % 2 && month != 2: day = random.randrange(1, 31)
        if month != 2: day = random.randrange(1, 32)

        return str(year) + "-" + str(month) + "-" + str(day)

    def setBirthdate(self):
        self.birthdate = self.genBirthdate()

    def genTelNumber(self):
        return "0" + str(random.randrange(660, 670)) + str(random.randrange(100, 10000000))

    def setTelNumber(self):
        while (checkDuplicate(self.genTelNumber(), self.db, self.table, "telefonnummer"))
            self.genTelNumber()
        self.telNumber = self.genTelNumber

    def genAddress(self):

    def setAddress(self):

    def getCustomer(self):
        return [self.firstName, self.lastName, self.email, self.birthdate, self.telNumber, self.address]


firstNames = [""]
lastNames = [""]
mailDomains = ["gmx.net"]
minYear = 1960
maxYear = 2001
addressStreets = [""]

for x in range(0, 10001):
    firstName = firstNames[random.randrange(0, len(firstNames))]
    lastName = lastNames[random.randrange(0, len(lastNames))]
    email = firstName + "@" + lastName + mailDomains[random.randrange(0, len(mailDomains))]
    year = random.randrange(minYear, maxYear)
    month = random.randrange(1, 13)

    if (year % 4) && !(year & 100) || !(year % 400): day = random.randrange(1, 30)
    else  day = random.randrange(1, 30)

    if month % 2 && month != 2: day = random.randrange(1, 31)
    if month != 2: day = random.randrange(1, 32)

    telNumber = "0" + str(random.randrange(660, 700)) + str(random.randrange(100, 10000000))

    executemany("INSERT INTO kunde(vorname, nachname, email, geburtsdatum, telefon, adresse) VALUES(?, ?)", firstName, lastName)

