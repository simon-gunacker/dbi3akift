import sqlite3
import random

random.seed(10)

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

