import sqlite3
import random 
from decimal import Decimal#für preis
from datetime import date,datetime

PRODUCT_SIZE = 10000
BESTELLPOSITION_SIZE = 500000
BESTELLUNG_SIZE = 100000
KUNDE_SIZE = 10000

SEED= 42

START_DATE = date(1945, 1, 1)
END_DATE= date(2008, 12, 31)

MIN_BETRAG= 100 #euro in cent
MAX_BETRAG= 1000000
LAGER_BESTAND_MAX=1000

START_TIMESTAMP = datetime(2020, 1, 1, 0, 0, 0).timestamp()# zeit in sek
END_TIMESTAMP = datetime(2026, 10, 3, 23, 59, 59).timestamp()

MAX_MENGE= 1000

BEZEICHNUG_LIST = ['Apfel','Birne', 'Kirsche', 'Banane','Mango',
                   'Erdbeere',' Pfirsich','Himbeere','Orange','Ananas']

VORNAME_LIST = ['Simon', 'Andreas', 'Jakobus', 'Johannes', 'Philippus', 
              'Bartholomaeus', 'Thomas', 'Matthaeus', 'Petrus', 'Thaddaeus']
NACHNAME_LIST = ['Mueller', 'Schmidt', 'Schneider', 'Fischer', 
               'Weber', 'Meyer', 'Wagner', 'Becker', 'Schulz', 'Hoffmann']
EMAIL_LIST = ['@gmail.com', '@yahoo.com', '@outlook.com', '@hotmail.com', 
              '@gmx.de', '@web.de', '@icloud.com', '@proton.me', '@mail.com', 
              '@zoho.com']
ADRESSE_LIST = ['Schloßstraße 14, 10115 Berlin', 'Herrengasse 3, 8010 Graz', 
                'Marienplatz 8, 80331 München', 'Stephansplatz 1, 1010 Wien',
                  'Königsallee 42, 40212 Düsseldorf', 'Mozartplatz 5, 5020 Salzburg',
                    'Hauptstraße 100, 60311 Frankfurt', 'Landstraße 12, 4020 Linz', 
                    'Reeperbahn 1, 20359 Hamburg', 'Innrain 52, 6020 Innsbruck']
TELEFONNUMMER_PREFIX_LIST=['0650', '0660', '0664', '0676', '0677', '0678', '0680',
                    '0681', '0688', '0699']

STATUS_LIST=['Eingegangen / Zahlung eingegangen', 'In Bearbeitung / Warten auf Details', 'Freigegeben / Kommissionierung', 'Versandt / An Paketdienst übergeben', 'In Zustellung', 'Zugestellt / Abgeholt', 
             'Verzögert', 'Aktion erforderlich', 'Storniert', 'Retoure / Rücksendung']

#random +seed ergibt reproduzuirbare werte
random.seed(SEED)


#DB
db_name = 'onlineshop.db'
conn = sqlite3.connect(db_name)
cursor = conn.cursor()

#kunde befüllen
SQL_STRING_KUNDE=  'INSERT INTO kunde (vorname, nachname,email,geburtsdatum,telefon,adresse) VALUES (?,?,?,?,?,?)'
data_kunde=[]
for i in range(0,KUNDE_SIZE):
  
    vorname=random.choice(VORNAME_LIST)
    nachname=random.choice(NACHNAME_LIST)
    email=vorname+nachname+random.choice(EMAIL_LIST)
    geburtsdatum=datetime.fromordinal(random.randint(START_DATE.toordinal(),END_DATE.toordinal())).isoformat()
    #ordinal nummeriert datum fortlaufen
    telefon=(random.choice(TELEFONNUMMER_PREFIX_LIST))+str(random.randint(1000000, 9999999))
    adresse=random.choice(ADRESSE_LIST)
    data_kunde.append((vorname,nachname,email,geburtsdatum,telefon,adresse))

cursor.executemany(SQL_STRING_KUNDE, data_kunde)
conn.commit()

#produkt befüllen
SQL_STRING_PRODUCT=  'INSERT INTO product (bezeichnung, preis,lagerbestand) VALUES (?, ?,?)'
data_produkt=[]
for j in range(0,PRODUCT_SIZE):
  
  bezeichnung=random.choice(BEZEICHNUG_LIST)
  preis=Decimal(random.randint(MIN_BETRAG,MAX_BETRAG))/Decimal(100)#Kommazahlen / Dezimalbrüche immer als String in Anführungszeichen:
  lagerbestand=random.randint(0, LAGER_BESTAND_MAX)
  data_produkt.append((bezeichnung, float(preis),lagerbestand))

cursor.executemany(SQL_STRING_PRODUCT, data_produkt)
conn.commit()

#bestellung befüllen
SQL_STRING_BESTELLUNG='INSERT INTO bestellung(kunde_id, bestelldatum,status) VALUES (?,?,?)'

BATCH_SIZE=10000
for k in range(0,BESTELLUNG_SIZE,BATCH_SIZE):
  data_bestellung_batch=[]
  for l in range(0, BATCH_SIZE):
    kunde_id=random.randint(1,KUNDE_SIZE)
    bestelldatum = datetime.fromtimestamp(random.uniform(START_TIMESTAMP, END_TIMESTAMP)).strftime('%Y-%m-%d %H:%M:%S')
    #randuniform is für float
    status=random.choice(STATUS_LIST)
    data_bestellung_batch.append((kunde_id, bestelldatum, status))
  cursor.executemany(SQL_STRING_BESTELLUNG, data_bestellung_batch)
  conn.commit()

#bestellposition befüllen
SQL_STRING_BESTELLPOSITION='INSERT INTO bestellposition(bestellung_id, produkt_id, menge) VALUES (?,?,?)'
created_couples= set()

for m in range(0,BESTELLPOSITION_SIZE,BATCH_SIZE):
  data_bestellposition_batch=[]
  for n in range(0, BATCH_SIZE):
    bestellung_id=random.randint(1,BESTELLUNG_SIZE)
    produkt_id=random.randint(1,PRODUCT_SIZE)
    menge=random.randint(1,MAX_MENGE)
    couple=(bestellung_id, produkt_id)

    if couple  not in created_couples:
      created_couples.add(couple)
      data_bestellposition_batch.append((bestellung_id, produkt_id, menge))
    else:
      n-=1
    
  cursor.executemany(SQL_STRING_BESTELLPOSITION, data_bestellposition_batch)
  conn.commit()

conn.close()    