import sqlite3
import random 

PRODUCT_SIZE = 10000
BESTELLPOSITION_SIZE = 500000
BESTELLUNG_SIZE = 100000
KUNDE_SIZE = 10000

SEED= 42

BEZEICHNUG_LIST = ['Apfel','Birne', 'Kirsche', 'Banane','Mango',
                   'Erdbeere',' Pfirsich','Himbeere','Orange','Ananas']

VORNAME_LIST = ['Simon ', 'Andreas', 'Jakobus', 'Johannes', 'Philippus', 
              'Bartholomäus', 'Thomas', 'Matthaeus', 'Petrus', 'Thaddaeus']
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

random.seed(SEED)
