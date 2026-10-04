
CREATE TABLE kunde(
id integer PRIMARY KEY AUTOINCREMENT
,vorname varchar(255)
,nachname varchar(255)
,email varchar(255)
,geburtsdatum date
,telefon varchar(255)
,adresse varchar(255)
);

CREATE TABLE product(
id integer PRIMARY KEY AUTOINCREMENT
,bezeichnung varchar(255)
,preis decimal not null
,lagerbestand int
);

CREATE TABLE bestellung(
id integer PRIMARY KEY AUTOINCREMENT
,kunde_id integer
,bestelldatum datetime
,status varchar(255)
,FOREIGN KEY ( kunde_id) REFERENCES kunde(id)
);


CREATE TABLE bestellposition(
bestellung_id integer
,produkt_id integer
,menge integer
,PRIMARY KEY (bestellung_id, produkt_id )
,FOREIGN KEY ( produkt_id) REFERENCES product(id)
,FOREIGN KEY ( bestellung_id) REFERENCES bestellung(id)
);


