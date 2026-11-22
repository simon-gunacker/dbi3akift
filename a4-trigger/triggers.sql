---------------------------
-- 1. Bestandsverwaltung --
---------------------------

-- Ist Medium verfügbar? Wenn nicht RAISE ABORT
CREATE TRIGGER trigger_ausleihe_bestand_pruefen
BEFORE INSERT ON ausleihe
WHEN COALESCE ((SELECT bestand FROM medium WHERE id = NEW.medium_id), 0) <= 0
BEGIN
    SELECT RAISE(ABORT, 'Ausleihen nicht möglich: Medium nicht verfügbar (Bestand 0)');
END;

-- Nach ausleihen: Bestand -1
CREATE TRIGGER trigger_ausleihe_bestand_minus
AFTER INSERT ON ausleihe
BEGIN
    UPDATE medium SET bestand = bestand - 1 WHERE id = NEW.medium_id;
END;

-- Rückgabe: Status beendet & Bestand +1
CREATE TRIGGER trigger_rueckgabe_bestand_plus
AFTER UPDATE OF status ON ausleihe
WHEN NEW.status = 'beendet' AND OLD.status != 'beendet'
BEGIN
    UPDATE medium SET bestand = bestand + 1 WHERE id = NEW.medium_id;
END;