-- 1. Bestandsverwaltung
-- Wenn jemand ein Medium ausleiht, soll der verfügbare Bestand dieses Mediums automatisch angepasst werden. Es darf nicht vorkommen, dass mehr Exemplare ausgeliehen werden, als tatsächlich vorhanden sind.
--

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

-- 2. Überfällige Ausleihen und Mahngebühren
-- Wird eine Ausleihe überfällig, soll automatisch eine Mahnung im System erfasst werden. Gleichzeitig soll dem betroffenen Nutzer der entsprechende Betrag sofort vom Guthaben abgezogen werden. Wird das Guthaben dadurch negativ, darf der Nutzer vorerst keine neuen Ausleihen mehr tätigen.
--

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





-- 3. Vereinfachte Ausleihe von E-Books
-- Für digitale Medien (E-Books) soll die Ausleihe besonders bequem funktionieren: Wenn ein Eintrag mit Nutzername, Titel und gewünschter Dauer gemacht wird, soll das System automatisch alle weiteren notwendigen Informationen ergänzen, sodass der Ausleihvorgang vollständig ist.
--

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


-- 4. Automatische Aufräumarbeiten
-- Wenn ein Nutzer gelöscht wird, sollen gleichzeitig alle zugehörigen offenen Ausleihen, Mahnungen oder Gebühren entfernt werden. Im System soll dabei eine nachvollziehbare Notiz oder ein Eintrag entstehen, der zeigt, dass dieser Löschvorgang stattgefunden hat.

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

-- 5. Nachvollziehbarkeit von Änderungen
-- Das System soll jede wichtige Änderung automatisch dokumentieren, etwa:
--
-- Ausleihen oder Rückgaben,
-- Mahnungen,
-- das Löschen von Medien oder Nutzern.
-- Diese Informationen sollen später auswertbar sein, um Abläufe nachvollziehen zu können.
--

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


-- TEST:
INSERT INTO ausleihe(nutzer_id, medium_id) VALUES (2, 1);
INSERT INTO ausleihe(nutzer_id, medium_id, status)
    VALUES (2, 1, 'beendet');

-- triggers mahnung
INSERT INTO ausleihe(
    nutzer_id, medium_id, rueckgabedatum
    )
    VALUES (2, 1, '2000-01-01');




-- 6. Plausibilitätsprüfung
-- Es darf nicht möglich sein, Mahngebühren mit 0 € oder negativen Beträgen zu erfassen.

--LÖSUNG: CHECK CONSTRAINT bei table mahnung spalte
-- betrag

-- TEST:
-- INSERT INTO mahnung (betrag) VALUES (0);
-- INSERT INTO mahnung (betrag) VALUES (-10);

