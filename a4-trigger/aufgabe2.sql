-- Aufgabe 2
-- Lass vorher Aufgabe 1 laufen!
-- Dafür habe ich im Tabellen Schema den CHECK beim konto_guthaben entfernt
-- das Guthaben könnte sonst nie negativ werden
-- Annahme ein externen Skript checkt die Rückgabendaten und gändert den Status der Ausleihe um 
CREATE TRIGGER mahnung_verfassen
AFTER UPDATE OF status ON ausleihe
FOR EACH ROW
WHEN NEW.status = 'gemahnt'
BEGIN
    -- abziehen der Mahngebühren des Guthabens des Nutzers
    UPDATE nutzer
    SET konto_guthaben = konto_guthaben - 10
    WHERE id = NEW.nutzer_id;

    -- aufzeichnung der Mahnung
    INSERT INTO mahnung (ausleihe_id, betrag)
    VALUES (NEW.id, 10);

    -- Aufgabe 5 
    INSERT INTO system_log (aktion, info)
    VALUES ('MAHNUNG', (SELECT name 
                            FROM nutzer 
                            WHERE id = NEW.nutzer_id) || ' - Ausleihe ' || NEW.id);
END;

-- wenn das Guthaben neagtiv wird soll dieser Trigger beim vesuch etwas erneut zum ausleihen
CREATE TRIGGER sperre_negatives_guthaben
BEFORE INSERT ON ausleihe
FOR EACH ROW
WHEN (SELECT konto_guthaben FROM nutzer
    WHERE id = NEW.nutzer_id) < 0
BEGIN
    SELECT RAISE (ABORT, 'Guthaben negativ! Keine neuen Ausleihen möglich');
END;

-- Test zu Aufgabe 2
-- von Aufgabe 1 haben ich noch in der Ausleihe einen Eintrag 
-- Annahme heute ist der 6.12 also das Rückgabedatum ist hüberschritten 
-- somit update ich die ausleihe auf gemahnt um

-- Erwartet: Anna hat 10 €, Ben hat 5 €
SELECT * FROM nutzer;

UPDATE ausleihe SET status = 'gemahnt' WHERE id = 1;

-- jetzt soll sich das guthaben von der person die bei der Ausleihe das Datum überschritten hat 
-- ändern, es soll sich um die Mahngebür von 10€ veringern
-- Erwartet: Ben hat jetzt -5 €, Anna bleibt bei 10 €
SELECT * FROM nutzer;

-- zusätzlich soll ein neuer Eintrag in bei den Mahnung entstehen die sich auf diese Ausleihe bezieht
-- Erwartet: eine Mahnung mit ausleihe_id 1 und betrag 10
SELECT * FROM mahnung;

-- Ben sollte auch nichts mehr Ausleihen dürfen
-- Erwartet: Fehler "Guthaben negativ! Keine neuen Ausleihen möglich"
INSERT INTO ausleihe (nutzer_id, medium_id) VALUES (2, 3);

-- Erwartet: keine neue Ausleihe von Ben
SELECT * FROM ausleihe;