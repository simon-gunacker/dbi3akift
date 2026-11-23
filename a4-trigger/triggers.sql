PRAGMA foreign_keys = ON;

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

---------------------------------------------------
-- 2. Überfällige Ausleihen und Mahngebühren     --
--    Mahngebühr 0.30€/Tag wie bei Stadtbib Graz --
--    bzw. Mahngebühr fix 10.00 Euro             --
---------------------------------------------------

-- Ausleihe überfällig, dann Mahnung

CREATE TRIGGER trigger_ausleihe_mahnung
AFTER UPDATE OF status ON ausleihe
WHEN NEW.status = 'gemahnt' AND OLD.status != 'gemahnt'
BEGIN
    INSERT INTO mahnung (ausleihe_id, betrag) 
    VALUES (NEW.id, 10.00);

    UPDATE nutzer 
    SET konto_guthaben = konto_guthaben - 10.00
    WHERE id = NEW.nutzer_id;
End;

/* Mit flexibler Gebühr würds auch gehen, aber dafür müsste regelmäßig von außen ein Update angestoßen werden.
So würds also nur sobald die Mahnung geschrieben wird, zB 10 Tage nach Rückgabefrist individuell berechnen:

CREATE TRIGGER trigger_ausleihe_mahnung
AFTER UPDATE OF status ON ausleihe
WHEN NEW.status = 'gemahnt' AND OLD.status != 'gemahnt'
BEGIN
    INSERT INTO mahnung (ausleihe_id, betrag) 
    VALUES (NEW.id, ROUND(CAST((julianday('now') - julianday(NEW.rueckgabedatum))AS INTEGER) * 0.30, 2));

    UPDATE nutzer 
    SET konto_guthaben = konto_guthaben - ROUND((CAST((julianday('now') - julianday(NEW.rueckgabedatum))AS INTEGER) * 0.30), 2)
    WHERE id = NEW.nutzer_id;
End;

Statt Datum doppelt holen würds auch so gehen:

CREATE TRIGGER trigger_ausleihe_mahnung
AFTER UPDATE OF status ON ausleihe
WHEN NEW.status = 'gemahnt' AND OLD.status != 'gemahnt'
BEGIN
    INSERT INTO mahnung (ausleihe_id, betrag)
    VALUES (NEW.id, ROUND(CAST(julianday('now') - julianday(NEW.rueckgabedatum) AS INTEGER) * 0.30), 2));

    UPDATE nutzer
    SET konto_guthaben = konto_guthaben - (SELECT betrag
                                           FROM mahnung
                                           WHERE id = last_insert_rowid())
    WHERE id = NEW.nutzer_id;

*/