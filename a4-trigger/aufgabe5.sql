-- Aufgabe 5
-- Ausleihen wurde in Aufgabe 1 geregelt siehe dort Kommentar
-- Mahnung wurde in Aufgabe 2 geregelt sie dort Kommentar
-- Löschung wurde n Aufgabe 4 erledigt siehet bestehendes Insert in system_log

-- Rückgabe
CREATE TRIGGER rueckgabe_mediene
AFTER UPDATE OF status ON ausleihe
FOR EACH ROW
WHEN NEW.status = 'beendet'
BEGIN
    UPDATE medium SET bestand = bestand + 1 WHERE id = NEW.medium_id;

    INSERT INTO system_log (aktion, info) 
    VALUES ('RÜCKGABE', (SELECT titel
                        FROM medium
                        WHERE id = NEW.medium_id));
END;

-- Test:
-- Wir fügen einen ausleihe hinzu die wir dann Updaten
-- weil sie Zurückgebracht wurde
-- Bestand vor dem instert:
-- SELECT * FROM medium;
-- id  titel                            typ    bestand
-- --  -------------------------------  -----  -------
-- 1   Der Zauberberg                   buch   2      
-- 2   Programmieren lernen mit Python  buch   0      
-- 3   Digitale Welten                  ebook  9997 

INSERT INTO ausleihe (nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES (1, 3, '2026-10-05', '2026-10-16');

-- Hier sollte man sehen in medium das der Bestand runtergehen wegen Aufagbe 1
-- SELECT * FROM medium;
-- id  titel                            typ    bestand
-- --  -------------------------------  -----  -------
-- 1   Der Zauberberg                   buch   2      
-- 2   Programmieren lernen mit Python  buch   0      
-- 3   Digitale Welten                  ebook  9996 

-- sieht mann dan auch im system_log
--SELECT * FROM system_log WHERE id = (SELECT MAX(id) FROM system_log);

-- id  aktion    info                         datum              
-- --  --------  ---------------------------  -------------------
-- 8   AUSLEIHE  Anna Muster-Digitale Welten  2026-11-22 13:44:35

UPDATE ausleihe SET status = 'beendet'
WHERE id = (SELECT MAX(id) FROM ausleihe);

-- Jetzt sollten man sehen das der Bestand sich wieder erhöht
--SELECT * FROM medium;
-- id  titel                            typ    bestand
-- --  -------------------------------  -----  -------
-- 1   Der Zauberberg                   buch   2      
-- 2   Programmieren lernen mit Python  buch   0      
-- 3   Digitale Welten                  ebook  9998   

-- Medium löschen
CREATE TRIGGER loeschen_medienen
AFTER DELETE ON medium
FOR EACH ROW
BEGIN
    INSERT INTO system_log (aktion, info)
    VALUES ('MEDIUM_GELÖSCHT', OLD.titel);
END;

-- Test:
-- Wir fügen eine neues Medium ein und löschen dann das wieder

INSERT INTO medium (titel, typ, bestand)
VALUES ('ACOTAR', 'buch', 1);

-- Jetzt soltte mann es mit SELECT * FROM medium sehen;
-- id  titel                            typ    bestand
-- --  -------------------------------  -----  -------
-- 1   Der Zauberberg                   buch   2      
-- 2   Programmieren lernen mit Python  buch   0      
-- 3   Digitale Welten                  ebook  9998   
-- 4   ACOTAR                           buch   1 

--Jetzt löschen wir es
DELETE FROM medium WHERE id = 4;
-- id  titel                            typ    bestand
-- --  -------------------------------  -----  -------
-- 1   Der Zauberberg                   buch   2      
-- 2   Programmieren lernen mit Python  buch   0      
-- 3   Digitale Welten                  ebook  9998  

-- und im system_log sollte ein neue eintrag sein 
-- mit MAX(id) bekomm ich den neuersten eintrag
-- SELECT * FROM system_log WHERE id = (SELECT MAX(id) FROM system_log);

-- id  aktion           info    datum              
-- --  ---------------  ------  -------------------
-- 11  MEDIUM_GELÖSCHT  ACOTAR  2026-11-22 13:54:57
