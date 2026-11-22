/*
Mein Ansatz: Bei jedem INSERT der 'Ausleihe' Tabelle wird jedes Medium, mit dem status 'aktiv', geprüft, ob das Rückgabedatum in der Vergangenheit liegt.
Zeitlich kann ich das in SQLite nicht umsetzen, das wird die Datenbank wohl ein wenig langsamer für jedes Update auf 'Ausleihe' machen.
*/

-- Liegt das Rückgabedatum in der Vergangenheit, wird eine Mahnung mit 10€ Mahngebühr ausgestellt.
CREATE TRIGGER overdue
AFTER INSERT ON ausleihe
FOR EACH ROW
WHEN NEW.rueckgabedatum < (DATE('now'))
AND NEW.status = 'aktiv'
BEGIN
    INSERT INTO mahnung(ausleihe_id, betrag)
    VALUES(
        NEW.id, 10.00
    );
END;


-- Wird eine Mahnung angelegt, wird die Mahngebühr sofort vom Guthaben abgezogen.
CREATE TRIGGER charge_fee
AFTER INSERT ON mahnung
FOR EACH ROW
BEGIN
    UPDATE nutzer
    SET konto_guthaben = konto_guthaben - NEW.betrag
    WHERE id = (
        SELECT nutzer_id
        FROM ausleihe
        WHERE id = NEW.ausleihe_id
    );
END;

-- Ist das Guthaben negativ, kann der Nutzer keine Bücher mehr ausleihen.
CREATE TRIGGER check_balance
BEFORE INSERT ON ausleihe
BEGIN
    SELECT CASE
        WHEN (
            SELECT konto_guthaben
            FROM nutzer
            WHERE id = NEW.nutzer_id
        ) <= 0
        THEN RAISE(ABORT, 'Guthaben zu gering, bitte einzahlen!')
    END;
END;