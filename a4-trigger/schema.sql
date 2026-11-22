PRAGMA foreign_keys = ON;

CREATE TABLE nutzer(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL, 
    konto_guthaben DECIMAL(10,2) DEFAULT 0 
);

CREATE TABLE medium (
id INTEGER PRIMARY KEY AUTOINCREMENT, 
titel TEXT NOT NULL,
typ TEXT CHECK (typ IN ('buch', 'ebook')),
bestand INTEGER DEFAULT 0 CHECK(bestand>=0)
);

CREATE TABLE ausleihe(
id INTEGER PRIMARY KEY AUTOINCREMENT,
nutzer_id INTEGER,
medium_id INTEGER,
startdatum DATE DEFAULT (DATE('now')),
rueckgabedatum DATE DEFAULT (DATE ('now','+14 day')),
status TEXT DEFAULT 'aktiv', --aktiv, beendet, gemahnt, gesperrt
FOREIGN KEY (nutzer_id) REFERENCES nutzer(id),
FOREIGN KEY (medium_id) REFERENCES medium(id)
);

CREATE TABLE mahnung (
id INTEGER PRIMARY KEY AUTOINCREMENT,
ausleihe_id INTEGER,
betrag DECIMAL (10,2) CHECK (betrag > 0),
datum DATE DEFAULT (DATE('now')),
FOREIGN KEY (ausleihe_id) REFERENCES ausleihe(id)
);

CREATE TABLE system_log (
id INTEGER PRIMARY KEY AUTOINCREMENT,
aktion TEXT,
info TEXT,
datum DATETIME DEFAULT CURRENT_TIMESTAMP
);

---Testdaten 
INSERT INTO nutzer (name, konto_guthaben) VALUES 
('Anna Muster', 10.00),
('Ben Beispiel', 5.00);

INSERT INTO medium (titel, typ, bestand) VALUES
('Der Zauberberg', 'buch', 3),
('Programmieren lernen mit Python', 'buch', 1),
('Digitale Welten', 'ebook', 9999);


-----Triggers
--1.- Bestandsverwaltung (Gestión de inventarios)
CREATE TRIGGER tmedium_ausleiht 
BEFORE INSERT ON ausleihe
BEGIN
    SELECT RAISE(ABORT, 'Kein Bestand')
    WHERE (SELECT bestand FROM medium WHERE id = NEW.medium_id)<=0;
    
    SELECT RAISE(ABORT, 'Keine Guthaben')
    WHERE (SELECT konto_guthaben FROM nutzer WHERE id=NEW.nutzer_id)<0;

    UPDATE medium 
    SET bestand = bestand -1
    WHERE id = NEW.medium_id;
END;

--2.- Überfällige Ausleihen und Mahngebühren (Préstamos vencidos y tasas de recargo / multas)

CREATE TRIGGER tausleihen_mahngebuehren
AFTER UPDATE OF status ON ausleihe
WHEN NEW.status = 'gemahnt' AND  OLD.status != 'gemahnt'  
BEGIN 
INSERT INTO mahnung(ausleihe_id, betrag) VALUES
(NEW.id, 7.00);

UPDATE nutzer
SET konto_guthaben = konto_guthaben - (SELECT betrag FROM mahnung WHERE ausleihe_id = NEW.id) 
WHERE id = NEW.nutzer_id; 
END;

--3.- Vereinfachte Ausleihe von E-Book (Prestamo simplificado)

CREATE VIEW v_ausleihe AS 
SELECT n.name, m.titel, a.rueckgabedatum
FROM nutzer n
JOIN ausleihe a ON a.nutzer_id= n.id
JOIN medium m ON a.medium_id=m.id 
WHERE m.typ = 'ebook';

CREATE TRIGGER t_AusleiheEbook 
INSTEAD OF INSERT ON v_ausleihe
BEGIN
SELECT RAISE(ABORT, 'Nur E-Books erlaubt')
WHERE (SELECT typ FROM medium WHERE titel=NEW.titel)!='ebook';

INSERT INTO ausleihe(nutzer_id, medium_id, rueckgabedatum, status) VALUES (
(SELECT id FROM nutzer WHERE name = NEW.name),
(SELECT id FROM medium WHERE titel = NEW.titel),
DATE('now', '+'||NEW.rueckgabedatum||' day'),
'aktiv'
);
END;

--4.- Automatische Aufräumarbeit (Trabajo de limpieza)

CREATE TRIGGER t_autoAufreumarb 
BEFORE DELETE ON nutzer
BEGIN

DELETE FROM mahnung 
WHERE ausleihe_id IN (SELECT id FROM ausleihe WHERE nutzer_id = OLD.id);

DELETE FROM ausleihe 
WHERE OLD.id =nutzer_id;

INSERT INTO system_log(aktion, info) VALUES
('delete', 'Nutzer gelöscht: ' || OLD.name);

END;

--5.- Nachvollziehbarkeit von Änderungen (Trazabilidad de los cambios, seguimiento/ auditabilidad de modificaciones)

--Ausleihen 
CREATE TRIGGER t_ausleihen
AFTER INSERT ON ausleihe
BEGIN
INSERT INTO system_log(aktion, info) VALUES 
('ausleihe', 'Nutzer: '||(SELECT name FROM  nutzer WHERE id = NEW.nutzer_id)||
', Medium: '||(SELECT titel FROM medium WHERE id = NEW.medium_id));


END; 

--Rückgaben

CREATE TRIGGER t_rueckgaben 
AFTER UPDATE OF status ON ausleihe
WHEN OLD.status!='beendet' AND NEW.status ='beendet'
BEGIN
INSERT INTO system_log(aktion, info) VALUES
('Rückgabe', 'Nutzer: '||(SELECT name FROM nutzer WHERE id = NEW.nutzer_id)|| 'Medium: '||(SELECT titel FROM medium WHERE id = NEW.medium_id));
END; 

--Magnungen

CREATE TRIGGER t_mahnung
AFTER INSERT ON mahnung
BEGIN
INSERT INTO system_log(aktion, info) VALUES
('Mahnung', 'Nutzer: '||(SELECT name FROM nutzer WHERE id =(SELECT nutzer_id FROM ausleihe WHERE id = NEW.ausleihe_id)));
END;

--Löschen von Medien

CREATE TRIGGER t_medien 
BEFORE DELETE ON medium
BEGIN
DELETE FROM mahnung
WHERE ausleihe_id IN (SELECT id FROM ausleihe WHERE medium_id = OLD.id);

DELETE FROM ausleihe 
WHERE OLD.id = medium_id;

INSERT INTO system_log(aktion, info) VALUES
('delete', 'Delete: '||OLD.titel);

END;


---6.- Plausibilitätsprüfung

CREATE TRIGGER t_plausibiliteatsP
BEFORE INSERT ON mahnung
WHEN NEW.betrag <=0
BEGIN
SELECT RAISE(ABORT, 'Mahngebühr muss größer als 0 sein');
END;