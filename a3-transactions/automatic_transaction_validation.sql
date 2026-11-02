CREATE TRIGGER bestandsprüfung
BEFORE INSERT ON bestellposition
BEGIN
    SELECT CASE
        WHEN NEW.menge > (
            SELECT lagerbestand
            FROM artikel
            WHERE id = NEW.artikel_id
        )
        THEN RAISE(ROLLBACK, 'Nicht genügend Lagerbestand!')
    END;
END;

CREATE TRIGGER kreditprüfung
BEFORE UPDATE OF aktueller_kredit ON kunde
BEGIN
    SELECT CASE
        WHEN NEW.aktueller_kredit > NEW.kreditlimit
        THEN RAISE(ROLLBACK, 'Kreditlimit überschritten!')
    END;
END;