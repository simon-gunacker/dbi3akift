

    UPDATE ausleihe
    SET status = 'gemahnt'
    WHERE status = 'aktiv' AND DATE('now') > rueckgabedatum;

    CREATE TRIGGER IF NOT EXISTS mahnung
    AFTER UPDATE ON ausleihe
    BEGIN
        INSERT INTO mahnung(ausleihe_id, betrag) VALUES(NEW.id, (julianday('now') - julianday(NEW.rueckgabedatum)))
    END;
