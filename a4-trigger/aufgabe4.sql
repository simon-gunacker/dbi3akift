-- Aufgabe 4
-- Es wird nichts gelöscht! Mann sollte Daten aus einer Datenbank nicht löschen
-- Nutzer wird nur geupdated
-- Nutzer bezogenen Daten werden umgeändert

CREATE TRIGGER loeschen_user
BEFORE DELETE ON nutzer
FOR EACH ROW
BEGIN
    -- Nutzer wir nicht gelöscht sondern nur geupdated, Name wir unkenntlich
    -- Kontoguthaben wir auf 0 gesetzt
    -- Annamhe der Kunde hat schon alles zurück gebraucht nach seinem Austretten

    UPDATE nutzer SET name = 'Gelöschter Nutzer', konto_guthaben = 0 WHERE id = OLD.id;

    -- Eintrag ins systemlog von den Daten
    INSERT INTO system_log (aktion, info)
    VALUES ('NUTZER_AUSGETRETTEN', OLD.name);

    -- Raise IGNORE muss am schluss hin sonst hört der Trigger hier gleich auf
    -- IGNORE überspringt den eigentlichen DELETE aber übernimmt die änderungen darüber
    SELECT RAISE (IGNORE);
END;


-- Test:

-- Wir legen einen Kunden an den wir dann löschen können
-- Er sollte jetzt die ID 3 bekommen
INSERT INTO nutzer (name, konto_guthaben) VALUES ('Nicole Mason', 15.00);

-- Erwartet wird jetzt Nicole Mason mit der id 3 und 15 €
SELECT * FROM nutzer;

-- Jetzt versuchen wir Nicole zu löschen.
-- Erwartet: keine error message, der DELETE läuft "silently"
-- aber Nicole wird nicht gelöscht, sonder sie wird anoymisiert
DELETE FROM nutzer WHERE id = 3;

-- Erwartet wird id 3 exestiert immer noch als 'Gelöschter Nutzer' with 0 €
SELECT * FROM nutzer;

-- Erwartet: neuer sys_log Eintrag ist NUTZER_AUSGETRETTEN mit dem alten Namen 'Nicole Mason'
SELECT * FROM system_log WHERE id = (SELECT MAX(id) FROM system_log);