/*
Angabe: 'Das System soll jede wichtige Änderung automatisch dokumentieren, etwa:

- Ausleihen oder Rückgaben,
- Mahnungen,
- das Löschen von Medien oder Nutzern.

Diese Informationen sollen später auswertbar sein, um Abläufe nachvollziehen zu können.'

Ich finde, dass auch das Hinzufügen eines neuen Mediums gelogged werden muss, deshalb schreibe ich auch einen Trigger für das Hinzufügen.
Ausleihen, Rückgaben, Mahnungen und das Löschen von Nutzern werden aus den vorherigen Übungen bereits korrekt protokolliert, alos fehlen nur mehr die Medienlöschungen.
*/

-- Logging der Mahnungen
CREATE TRIGGER log_overdue
AFTER INSERT ON mahnung
FOR EACH ROW
BEGIN

    INSERT INTO system_log
    (
        aktion,
        info
    )
    VALUES
    (
        'Mahnung',
        'Die Ausleihung mit der ID ' || NEW.ausleihe_id || ' wurde nicht rechtzeitig zurückgebracht.'
    );

END;


-- Logging des Hinzufügen eines Mediums
CREATE TRIGGER log_medium_addition
AFTER INSERT ON medium
FOR EACH ROW
BEGIN

    INSERT INTO system_log
    (
        aktion,
        info
    )
    VALUES
    (
        'Medienergänzung',
        'Medium ' || NEW.titel || ' mit der ID ' || NEW.id || ' wurde mit dem Bestand ' || NEW.bestand || ' hinzugefügt.'
    );

END;


-- Logging des Medienlöschungsprozesses
CREATE TRIGGER log_medium_deletion
AFTER DELETE ON medium
FOR EACH ROW
BEGIN

    INSERT INTO system_log
    (
        aktion,
        info
    )
    VALUES
    (
        'Medienlöschung',
        'Medium ' || OLD.titel || ' mit der ID ' || OLD.id || ' wurde gelöscht.'
    );

END;