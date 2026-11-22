-- Aufgabe 6
-- Hier zu hab ich im shema.sql einen CHECK in der mahnung tabelle auf betrag gemacht 
-- betrag DECIMAL(10,2) CHECK (betrag > 0)

-- Somit kann beim anlegen nichts passieren und mann muss eine wert über 0 nehmen

-- TEST:
-- Wir versuchen mal einen neue Mahnung selbst anzulegen, da wir aber im Trigger 
-- der in Aufgabe 2 ist schon einen fixen Betrag anlegt sobald wir eine Ausleihe updaten
-- wäre der Check im enteffekt nicht nötig
-- Aber damit wir das hier auch abdecken legen wir einfach eine selbst an

INSERT INTO mahnung (ausleihe_id, betrag) VALUES(2, 0);

-- sqlite3.IntegrityError: CHECK constraint failed: betrag > 0
-- dieser fehler kommt sofort und fügt nichts in mahnung ein 

-- Was passiert wenn wir dashier machen 
INSERT INTO mahnung (ausleihe_id) VALUES (2);

-- Jetzt fügt er es ein mit NULL
-- id  ausleihe_id  betrag  datum     
-- --  -----------  ------  ----------
-- 1   1            10      2026-11-22
-- 3   2                    2026-11-22

-- Wir ändern das nochmal im shema.sql ab 
-- zu betrag DECIMAL(10,2) NOT NULL CHECK (betrag > 0),
-- Wir bekommen jetzt:
--Runtime error: NOT NULL constraint failed: mahnung.betrag (19)
