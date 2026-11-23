-- NOTE: Manche test-statements sind auskommentiert, da
-- sie (gewollt) Fehler verursachen

-- NOTE: run.py erstellt datenbank (im Projektordner),
-- tabellen, daten und führt triggers.sql aus



-- 1. Bestandsverwaltung
CREATE TRIGGER check_bestand
BEFORE INSERT ON ausleihe
    -- 0 = false, 1 = true
    WHEN (
        SELECT bestand FROM medium
        WHERE id = NEW.medium_id
        AND bestand == 0
    )
    BEGIN
        SELECT RAISE(ABORT, 'Bestand des Buches ist 0');
    END;

CREATE TRIGGER decrement_bestand
AFTER INSERT ON ausleihe
    WHEN (
        SELECT COUNT(*) FROM medium
            WHERE id = NEW.medium_id
            AND typ = 'buch'
    )
    BEGIN
        UPDATE medium SET bestand = bestand - 1
        WHERE id = NEW.medium_id;
    END;

-- TEST: should trigger, check_bestand as book nr. 2 is
-- only stocked once, and also show that e-books are not
-- changed in bestand

INSERT INTO ausleihe (nutzer_id, medium_id)
VALUES (2, 2);
-- INSERT INTO ausleihe (nutzer_id, medium_id)
-- VALUES (2, 2);
INSERT INTO ausleihe (nutzer_id, medium_id)
VALUES (2, 3);
-- TEST END




-- 2. Überfällige Ausleihen und Mahngebühren

CREATE TRIGGER create_mahnung
AFTER INSERT ON ausleihe
FOR EACH ROW
WHEN (
    SELECT rueckgabedatum FROM ausleihe
    WHERE nutzer_id = NEW.nutzer_id
    AND rueckgabedatum < DATE('now')
) BEGIN
    INSERT INTO mahnung (ausleihe_id, betrag)
    VALUES (NEW.id, 5);
END;

CREATE TRIGGER decrement_guthaben
AFTER INSERT ON mahnung
WHEN (
    SELECT n.konto_guthaben FROM nutzer n
        JOIN ausleihe a
        ON n.id = a.nutzer_id
            JOIN mahnung m
            ON a.id = m.ausleihe_id
    WHERE n.konto_guthaben - NEW.betrag > 0
    AND a.id = NEW.ausleihe_id
    )
BEGIN
    UPDATE nutzer
        SET konto_guthaben = konto_guthaben - NEW.betrag
        WHERE id = (
            SELECT nutzer_id FROM ausleihe
            WHERE id = NEW.ausleihe_id
        );
    UPDATE ausleihe
        SET status = 'gemahnt'
        WHERE id = NEW.ausleihe_id;
END;

CREATE TRIGGER sperr_nutzer
AFTER INSERT ON mahnung
WHEN (
        SELECT n.konto_guthaben FROM nutzer n
        JOIN ausleihe a
        ON n.id = a.nutzer_id
            JOIN mahnung m
            ON a.id = m.ausleihe_id
    WHERE n.konto_guthaben - NEW.betrag <= 0
    AND a.id = NEW.ausleihe_id
)
BEGIN
    UPDATE ausleihe
        SET status='gesperrt'
        WHERE id = NEW.ausleihe_id;
END;

CREATE TRIGGER check_gesperrt
BEFORE INSERT ON ausleihe
WHEN (
    -- string > 0 = false
    SELECT COUNT(status) FROM ausleihe
        WHERE nutzer_id = NEW.nutzer_id
        AND status = 'gesperrt'
)
BEGIN
    SELECT RAISE(
        ABORT
        , 'Keine Ausleihe möglich - Nutzer ist gesperrt'
    );
END;

-- TEST:
-- Trigger create_mahnung and decrement_guthaben
INSERT INTO ausleihe(nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES(1, 3, '2025-01-01', '2025-01-15');

-- Trigger create_mahnung and sperr_nutzer
INSERT INTO ausleihe(nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES(1, 3, '2025-01-01', '2025-01-15');

-- Trigger check_gesperrt
-- INSERT INTO ausleihe(nutzer_id, medium_id)
-- VALUES(1, 3);

-- TEST END




-- 3. Vereinfachte Ausleihe von E-Books

CREATE VIEW ebook_v AS
SELECT n.name, m.titel, 0 AS dauer FROM nutzer n
JOIN medium m WHERE typ='ebook';


CREATE TRIGGER ebook_v
INSTEAD OF INSERT ON ebook_v
BEGIN
    INSERT INTO ausleihe(
        nutzer_id, medium_id, rueckgabedatum
        ) VALUES (
            (SELECT id FROM nutzer
                WHERE name=NEW.name)
            , (SELECT id FROM medium
                WHERE titel=NEW.titel)
            , (DATE('now', CONCAT(NEW.dauer, ' days')))
        );
END;

--TEST:
-- INSERT INTO ebook_v VALUES('Ben Beispiel', 'Digitale Welten', 30);
-- TEST END




-- 4. Automatische Aufräumarbeiten

CREATE TRIGGER loeschen
BEFORE DELETE ON nutzer
BEGIN
    DELETE FROM mahnung
        WHERE ausleihe_id IN
        (SELECT id FROM ausleihe
        WHERE nutzer_id = OLD.id);
    DELETE FROM ausleihe
        WHERE nutzer_id = OLD.id;
    INSERT INTO system_log (aktion, info)
        VALUES('Nutzer geloescht', CONCAT('Name: ', OLD.name));
END;

-- TEST:
DELETE FROM nutzer
    WHERE id=1;
-- TEST END




-- 5. Nachvollziehbarkeit von Änderungen

CREATE TRIGGER ausleihe_log
AFTER INSERT ON ausleihe
WHEN
    NEW.status='aktiv'
BEGIN
    INSERT INTO system_log (aktion, info)
    VALUES ('Ausleihe', 'ausleih_id ' || NEW.id);
END;

CREATE TRIGGER rueckgabe_log
AFTER INSERT ON ausleihe
WHEN
    NEW.status='beendet'
BEGIN
    INSERT INTO system_log (aktion, info)
    VALUES ('Rueckgabe', 'ausleih_id ' || NEW.id);
END;

CREATE TRIGGER mahnung_log
AFTER INSERT ON mahnung
BEGIN
    INSERT INTO system_log (aktion, info)
    VALUES ('Mahnung', 'mahnung_id ' || NEW.id);
END;

CREATE TRIGGER medium_geloescht_log
BEFORE DELETE ON medium
BEGIN
    INSERT INTO system_log (aktion, info)
    VALUES ('Medium geloescht', 'medium_id ' || OLD.id);
END;

-- TEST:
INSERT INTO ausleihe(nutzer_id, medium_id) VALUES (2, 1);
INSERT INTO ausleihe(nutzer_id, medium_id, status)
    VALUES (2, 1, 'beendet');

-- triggers mahnung
INSERT INTO ausleihe(
    nutzer_id, medium_id, rueckgabedatum
    )
    VALUES (2, 1, '2000-01-01');

DELETE FROM medium
WHERE id=3;
-- TEST END




-- 6. Plausibilitätsprüfung


--LÖSUNG: CHECK CONSTRAINT bei table mahnung spalte
-- betrag hinzugefügt

-- TEST:
-- INSERT INTO mahnung (betrag) VALUES (0);
-- INSERT INTO mahnung (betrag) VALUES (-10);

