--Bestandsverwaltung

CREATE TRIGGER IF NOT EXISTS trigger_bestandcheck 
BEFORE INSERT ON ausleihe
FOR EACH ROW 
WHEN 
(SELECT bestand
FROM medium
WHERE id =new.medium_id)<=0
BEGIN
SELECT RAISE(ABORT,'bestand = 0')
END;

CREATE TRIGGER IF NOT EXISTS trigger_bestand_reduzieren
AFTER INSERT ON ausleihe
FOR EACH ROW 
BEGIN
UPDATE medium
SET bestand = bestand -1
WHERE id =new.medium_id
END;


--Überfällige Ausleihen und Mahngebühren

CREATE TRIGGER IF NOT EXISTS mahnung
AFTER UPDATE OF rueckgabedatum ON ausleihe
FOR EACH ROW 
WHEN 
julianday(new.rueckgabedatum) > julianday(new.startdatum) + 14 
BEGIN 
UPDATE ausleihe
SET status = 'gemahnt'
WHERE id=new.id

INSERT INTO mahnung
(ausleihe_id,betrag,datum)
VALUES (ausleihe.id, 5.10,'now')

UPDATE nutzer

SET konto_guthaben =konto_guthaben - 5.10
WHERE id =new.nutzer_id

END;


CREATE TRIGGER IF NOT EXISTS sperrung
AFTER UPDATE OF konto_guthaben ON nutzer
FOR EACH ROW
WHEN new.konto_guthaben < 0
BEGIN
UPDATE ausleihe 
SET status = 'gesperrt'
WHERE nutzer_id =new.id;
END;