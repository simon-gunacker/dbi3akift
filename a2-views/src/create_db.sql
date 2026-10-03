
CREATE TABLE kunde(
id int PRIMARY KEY
,vorname varchar(255)
,nachname varchar(255)
,email varchar(255)
,geburtsdatum date
,telefon varchar(255)
,adresse varchar(255)
);

CREATE TABLE product(
id int PRIMARY KEY
,bezeichnung varchar(255)
,preis decimal not null
,lagerbestand int
);

CREATE TABLE bestellung(
id int PRIMARY KEY
,kunde_id int
,bestelldatum datetime
,status varchar(255)
,FOREIGN KEY ( kunde_id) REFERENCES kunde(id)
);


CREATE TABLE bestellposition(
bestellung_id int
,product_id int
,menge int
,PRIMARY KEY (bestellung_id, product_id )
,FOREIGN KEY ( produkt_id) REFERENCES product(id)
,FOREIGN KEY ( bestellung_id) REFERENCES bestellung(id)
);


