-- 1. Bestandsverwaltung
CREATE TRIGGER IF NOT EXISTS ausleihe_before_insert
BEFORE INSERT ON ausleihe
BEGIN 
    -- Prüfung 1: Bestand > 0?
    SELECT CASE
        WHEN (SELECT bestand FROM medium WHERE id = NEW.medium_id) <= 0
            THEN RAISE(ABORT, 'Ausleihe: Bestand nicht ausreichend!') -- ABROT gibt fehler aus, unterbricht alles und führt nichts aus 
        END;

  -- Prüfung 2: Guthaben >= 0?
    SELECT CASE
        WHEN (SELECT konto_guthaben FROM nutzer WHERE id = NEW.nutzer_id) < 0
          THEN RAISE(ABORT, 'Ausleihe: Guthaben negativ!')
        END;
END;

-- Bestand Reduzieren
CREATE TRIGGER ausleihe_after_insert
AFTER INSERT ON ausleihe
BEGIN
    UPDATE medium
    SET bestand = bestand - 1
    WHERE id = NEW.medium_id;
END;


-- 2. Überfällige Ausleihen und Mahngebühren
CREATE TRIGGER IF NOT EXISTS mahnung_before_insert
BEFORE INSERT ON mahnung
BEGIN
  -- Prüfung: Betrag muss > 0 sein
    SELECT CASE
        WHEN NEW.betrag <= 0
          THEN RAISE(ABORT, 'Mahnung: Betrag muss größer als 0 sein!')
        END;

    -- Guthaben Reduzieren    
    UPDATE nutzer
    SET konto_guthaben = konto_guthaben - NEW.betrag
    WHERE id = (SELECT nutzer_id FROM ausleihe WHERE id = NEW.ausleihe_id);

    -- Ausleihe Status auf 'gemahnt' setzen
    UPDATE ausleihe
    SET status = 'gemahnt'
    WHERE id = NEW.ausleihe_id;
END;

-- 3. Vereinfachte Ausleihe von E-Books
CREATE VIEW IF NOT EXISTS ebook_ausleihe_eingabe AS
SELECT NULL AS nutzer_name, NULL AS titel, NULL AS dauer_tage;

CREATE TRIGGER IF NOT EXISTS ebook_ausleihe_insert
INSTEAD OF INSERT ON ebook_ausleihe_eingabe -- INSTEAD OF INSERT heißt statt view zu füllen, führt trigger etwas anderes aus. 
BEGIN
    -- gibts dieses nutzer?
    SELECT CASE
        WHEN NOT EXISTS (SELECT 1 FROM nutzer WHERE name = NEW.nutzer_name)
        THEN RAISE(ABORT, 'Ausleihe: Nutzer nicht gefunden!')
    END;
    -- gibts dieses e-book
    SELECT CASE
        WHEN NOT EXISTS (SELECT 1 FROM medium WHERE titel = NEW.titel AND typ = 'ebook')
        THEN RAISE(ABORT, 'Ausleihe: E-Book nicht gefunden!')
    END;

    -- Rückgabedatum wird berechnet aus der dauer
    INSERT INTO ausleihe (nutzer_id, medium_id, startdatum, rueckgabedatum)
    VALUES (
        (SELECT id FROM nutzer WHERE name = NEW.nutzer_name),
        (SELECT id FROM medium WHERE titel = NEW.titel AND typ = 'ebook'),
        DATE('now'),
        DATE('now', '+' || NEW.dauer_tage || ' day')
    );
END;

