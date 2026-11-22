-- 1. Bestandsverwaltung
CREATE TRIGGER IF NOT EXISTS ausleihe_before_insert
BEFORE INSERT ON ausleihe
BEGIN 
    -- Prüfung 1: Bestand > 0?
  SELECT CASE
    WHEN (SELECT bestand FROM medium WHERE id = NEW.medium_id) <= 0
      THEN RAISE(ABORT, 'Nicht genug Bestand!') -- ABROT gibt fehler aus, unterbricht alles und führt nichts aus 
  END;

  -- Prüfung 2: Guthaben >= 0?
  SELECT CASE
    WHEN (SELECT konto_guthaben FROM nutzer WHERE id = NEW.nutzer_id) < 0
      THEN RAISE(ABORT, 'Guthaben negativ!')
  END;
END;

-- Bestand reduzieren
CREATE TRIGGER ausleihe_after_insert
AFTER INSERT ON ausleihe
BEGIN
  UPDATE medium
  SET bestand = bestand - 1
  WHERE id = NEW.medium_id;
END;