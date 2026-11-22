/*
Angabe: 'Wenn ein Nutzer gelöscht wird, sollen gleichzeitig alle zugehörigen offenen Ausleihen, Mahnungen oder Gebühren entfernt werden.'
Ich finde es nicht sinnvoll offene Ausleihen zu löschen, da der Nutzer das Buch ja noch hat.
Es gibt kein Szenarion, in dem wir ein physisches Buch einfach vergessen sollten, der Bestand würde nicht mehr stimmen und keiner kennt sich aus. Deshalb lösche ich die Ausleihe nur, wenn es ein E-Book ist.
Die Ausleihe soll dann bei der nächsten Inventur korrigiert werden.
*/

-- Löschung der aktiven Mahnungen und aktiven Ausleihen von E-Books
CREATE TRIGGER delete_user
BEFORE DELETE ON nutzer
BEGIN
    DELETE FROM mahnung
    WHERE ausleihe_id IN(
        SELECT id
        FROM ausleihe
        WHERE nutzer_id = OLD.id
        AND status = 'aktiv'
    );
    DELETE FROM ausleihe
    WHERE nutzer_id = OLD.id
    AND status = 'aktiv'
    AND medium_id IN (
        SELECT id
        FROM medium
        WHERE typ = 'ebook'
    );
END;

-- Logging des Nutzerlöschungsprozesses
CREATE TRIGGER log_user_deletion
AFTER DELETE ON nutzer
FOR EACH ROW
BEGIN

    INSERT INTO system_log
    (
        aktion,
        info
    )
    VALUES
    (
        'Nutzerlöschung',
        'Nutzer ' || OLD.name || ' mit der ID ' || OLD.id || ' wurde gelöscht.'
    );

END;