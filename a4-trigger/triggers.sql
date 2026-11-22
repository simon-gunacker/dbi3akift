-- 1. Bestandsverwaltung
-- Wenn jemand ein Medium ausleiht, soll der verfügbare Bestand dieses Mediums automatisch angepasst werden. Es darf nicht vorkommen, dass mehr Exemplare ausgeliehen werden, als tatsächlich vorhanden sind.
--

CREATE TRIGGER check_bestand
BEFORE INSERT ON ausleihe
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
    BEGIN
        UPDATE medium SET bestand = bestand - 1
        WHERE id = NEW.medium_id;
    END;

-- TEST: should trigger, check_bestand as book nr. 2 is
-- only stocked once
INSERT INTO ausleihe (nutzer_id, medium_id)
VALUES (1, 2);
INSERT INTO ausleihe (nutzer_id, medium_id)
VALUES (2, 2);

-- 2. Überfällige Ausleihen und Mahngebühren
-- Wird eine Ausleihe überfällig, soll automatisch eine Mahnung im System erfasst werden. Gleichzeitig soll dem betroffenen Nutzer der entsprechende Betrag sofort vom Guthaben abgezogen werden. Wird das Guthaben dadurch negativ, darf der Nutzer vorerst keine neuen Ausleihen mehr tätigen.
--
-- 3. Vereinfachte Ausleihe von E-Books
-- Für digitale Medien (E-Books) soll die Ausleihe besonders bequem funktionieren: Wenn ein Eintrag mit Nutzername, Titel und gewünschter Dauer gemacht wird, soll das System automatisch alle weiteren notwendigen Informationen ergänzen, sodass der Ausleihvorgang vollständig ist.
--
-- 4. Automatische Aufräumarbeiten
-- Wenn ein Nutzer gelöscht wird, sollen gleichzeitig alle zugehörigen offenen Ausleihen, Mahnungen oder Gebühren entfernt werden. Im System soll dabei eine nachvollziehbare Notiz oder ein Eintrag entstehen, der zeigt, dass dieser Löschvorgang stattgefunden hat.
--
-- 5. Nachvollziehbarkeit von Änderungen
-- Das System soll jede wichtige Änderung automatisch dokumentieren, etwa:
--
-- Ausleihen oder Rückgaben,
-- Mahnungen,
-- das Löschen von Medien oder Nutzern.
-- Diese Informationen sollen später auswertbar sein, um Abläufe nachvollziehen zu können.
--
-- 6. Plausibilitätsprüfung
-- Es darf nicht möglich sein, Mahngebühren mit 0 € oder negativen Beträgen zu erfassen.



