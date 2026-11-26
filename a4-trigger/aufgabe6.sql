-- Aufgabe 6
-- Hier zu hab ich im shema.sql einen CHECK in der mahnung tabelle auf betrag gemacht
-- betrag DECIMAL(10,2) CHECK (betrag > 0) aber wir machen das mit einen Trigger
-- -> CHECK und NOT NULL wieder aus shema.sql entfernt, sonst würden sie vor dem Trigger greifen

CREATE TRIGGER pruefe_mahnbetrag
BEFORE INSERT ON mahnung
FOR EACH ROW
-- 0 €, negative Beträge und fehlende Beträge (NULL) werden blockiert
WHEN NEW.betrag <= 0 OR NEW.betrag IS NULL
BEGIN
    SELECT RAISE (ABORT, 'Bitte gib ein Mahnngsbetrag ein das über 0€ ist');
END;


-- Test:

-- Erwartet: die aktuellen Mahnungen vor den Tests
SELECT * FROM mahnung;

-- 1) 0 € -> Erwartet: Fehler 'Bitte gib ein Mahnngsbetrag ein das über 0€ ist'
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (1, 0);

-- 2) negativer Betrag -> Erwartet: gleicher Fehler
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (1, -5);

-- 3) kein Betrag (NULL) -> Erwartet: gleicher Fehler
INSERT INTO mahnung (ausleihe_id) VALUES (1);

-- 4) gültiger Betrag -> Erwartet: wird ohne Fehler eingefügt
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (1, 5);

-- Erwartet: nur die 5 € Mahnung ist neu, keine der ungültigen
SELECT * FROM mahnung;