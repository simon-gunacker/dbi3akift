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