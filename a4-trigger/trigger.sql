CREATE TRIGGER IF NOT EXISTS trigger_bestandcheck 
BEFORE INSERT ON ausleihe
FOR EACH ROW 
WHEN 
(SELECT bestand
FROM medium
WHERE id =new.medium_id)<=0
BEGIN
SELECT RAISE(ABORT,"bestand =0")
END;

CREATE TRIGGER IF NOT EXISTS trigger_bestand_reduzieren
AFTER INSERT ON ausleihe
FOR EACH ROW 
BEGIN
UPDATE medium
SET bestand = bestand -1
WHERE id =new.medium_id
END;