-- Aufgabe 4

CREATE TRIGGER IF NOT EXISTS loeschen_user
AFTER DELETE ON nutzer
FOR EACH ROW
BEGIN
    -- alle einträge von dem Nutzer löschen 
    -- Zuerst Mahnungen weil wir die id von den Ausleihen brauchen
    -- und dannach dan die ausleihen
    -- Guthaben löschen wir ja eh schon mit dem Nutzer mit
    -- Annamhe der Kunde hat schon alles zurück gebraucht nach seinem Austretten 
    DELETE FROM mahnung 
    WHERE ausleihe_id IN (SELECT id 
                        FROM ausleihe 
                        WHERE nutzer_id = OLD.id);
    DELETE FROM ausleihe WHERE nutzer_id = OLD.id;

    -- Eintrag ins systemlog von den daten 
    INSERT INTO system_log (aktion, info) 
    VALUES ('nutzer gelöscht', OLD.name);
END;

--Test:

-- Wir legen einen Kunden an den wir dann löschen können
-- Er sollte jetzt die ID 3 bekommen
INSERT INTO nutzer (name, konto_guthaben) VALUES ('Nicole Mason', 15.00);

--SELECT * FROM nutzer; 
-- id  name          konto_guthaben
-- --  ------------  --------------
-- 1   Anna Muster   10            
-- 2   Ben Beispiel  -5            
-- 3   Nicole Mason  15  

-- Danach legen wir noch 2 ausleihen an und eine mahnung auf eine ausleihe

INSERT INTO ausleihe (nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES (3, 3, '2026-10-05', '2026-10-19');

INSERT INTO ausleihe (nutzer_id, medium_id)
VALUES (3, 1);

-- SELECT * FROM ausleihe;
-- id  nutzer_id  medium_id  startdatum  rueckgabedatum  status 
-- --  ---------  ---------  ----------  --------------  -------
-- 1   2          2          2026-11-21  2026-12-05      gemahnt
-- 2   1          3          2026-11-21  2026-11-26      aktiv  
-- 5   3          3          2026-10-05  2026-10-19      gemahnt
-- 6   3          1          2026-11-22  2026-12-06      aktiv 

UPDATE ausleihe SET status = 'gemahnt' 
WHERE nutzer_id = 3
AND rueckgabedatum < DATE('now'); 

--SELECT * FROM mahnung;
-- id  ausleihe_id  betrag  datum     
-- --  -----------  ------  ----------
-- 1   1            10      2026-11-21
-- 3   5            10      2026-11-22

-- Wenn ich jetzt Nicole (id = 3) lösche sollten ihre gesamten
-- Einträge weg sein und im system_log soll dann ein Eintrag stehen
-- mit "Nutzer gelöscht, Nicole Mason"

DELETE FROM nutzer WHERE id = 3;

-- Tatsächliches Ergebnis:
-- SELECT * FROM ausleihe;
-- id  nutzer_id  medium_id  startdatum  rueckgabedatum  status 
-- --  ---------  ---------  ----------  --------------  -------
-- 1   2          2          2026-11-22  2026-12-06      gemahnt
-- 2   1          3          2026-11-22  2026-11-27      aktiv  

-- SELECT * FROM mahnung;
-- id  ausleihe_id  betrag  datum     
-- --  -----------  ------  ----------
-- 1   1            10      2026-11-22

-- SELECT * FROM system_log;
-- id  aktion           info          datum              
-- --  ---------------  ------------  -------------------
-- 1   nutzer gelöscht  Nicole Mason  2026-11-22 12:13:48