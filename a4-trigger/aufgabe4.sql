-- Augabenstellung

/*
Wenn ein Nutzer gelöscht wird, sollen gleichzeitig alle zugehörigen offenen 
Ausleihen, Mahnungen oder Gebühren entfernt werden. 
Im System soll dabei eine nachvollziehbare Notiz oder ein Eintrag entstehen, 
der zeigt, dass dieser Löschvorgang stattgefunden hat.
*/

--triggers
CREATE TRIGGER IF NOT EXISTS geloeschter_nutzer_daten_loeschen
AFTER DELETE ON nutzer
FOR EACH ROW
BEGIN

DELETE FROM mahnung 
WHERE ausleihe_id IN (
    SELECT id FROM ausleihe
    WHERE nutzer_id = OLD.id AND status != 'beendet'
    );

DELETE FROM ausleihe 
WHERE nutzer_id = OLD.id AND status != 'beendet';

INSERT INTO system_log (aktion, info) 
VALUES ('entfernung von benutzer', 'loeschung des Benutzers ' || OLD.name);

END;

--test

INSERT INTO nutzer (id, name, konto_guthaben) VALUES 
(42, 'John Doe', 10.00);

INSERT INTO ausleihe (id, nutzer_id, medium_id, status) VALUES (52, 42, 3, 'aktiv');
INSERT INTO ausleihe (id, nutzer_id, medium_id, status) VALUES (54, 42, 2, 'beendet');
INSERT INTO ausleihe (id, nutzer_id, medium_id, status) VALUES (53, 42, 2, 'gemahnt');
INSERT INTO ausleihe (id, nutzer_id, medium_id, status) VALUES (55, 42, 3, 'beendet');

SELECT id, nutzer_id, medium_id, status FROM ausleihe WHERE nutzer_id = 42;

/*
id | nutzer_id | medium_id| status
52 | 42 | 3 | aktiv
53 | 42 | 2 | gemacht
54 | 42 | 2 | beendet
55 | 42 | 3 | beendet
*/

INSERT INTO mahnung (ausleihe_id, betrag) VALUES (53, 4.24);
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (55, 4.24);


SELECT a.nutzer_id, m.ausleihe_id, a.status FROM mahnung m
LEFT JOIN ausleihe a ON m.ausleihe_id = a.id
WHERE a.nutzer_id = 42;

/*
nutzer_id | ausleihe | status
42 | 53 | gemahnt
42 | 55 | beendet
*/

DELETE FROM nutzer WHERE id = 42;

SELECT id, nutzer_id, medium_id, status FROM ausleihe WHERE nutzer_id = 42;

/*
id | nutzer_id | medium_id| status
54 | 42 | 2 | beendet
55 | 42 | 3 | beendet
*/

SELECT m.ausleihe_id, a.status FROM mahnung m
LEFT JOIN ausleihe a ON m.ausleihe_id = a.id
WHERE a.nutzer_id = 42;

/*
nutzer_id | ausleihe | status
42 | 55 | beendet
*/
