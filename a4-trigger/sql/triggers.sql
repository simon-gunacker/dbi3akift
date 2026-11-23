-- Check if theres enough stock & user has enough balance
CREATE TRIGGER trg_borrow_before_insert
BEFORE INSERT ON ausleihe
FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, 'Stock is insufficient')
    WHERE (SELECT bestand FROM medium WHERE id = NEW.medium_id) <= 0;

    SELECT RAISE(ROLLBACK, 'User balance is too low')
    WHERE (SELECT konto_guthaben FROM nutzer WHERE id = NEW.nutzer_id) < 0;
END;

-- Adjust available stock
CREATE TRIGGER trg_borrow_after_insert
AFTER INSERT ON ausleihe
FOR EACH ROW
BEGIN
    UPDATE medium SET bestand = bestand - 1 WHERE id = NEW.medium_id;

    INSERT INTO system_log (aktion, info) 
    VALUES (
        'borrow_start',
        'A borrow: ' || NEW.id || 'started for user: ' || NEW.nutzer_id ||
        'borrowed: ' || NEW.medium_id || ', on: ' || NEW.startdatum
    );
END;


-- Reminder & fee reduction if borrowed item is overdue
CREATE TRIGGER trg_reminder_after_insert
AFTER INSERT ON mahnung
FOR EACH ROW
BEGIN
    SELECT RAISE(ROLLBACK, 'Late fee cannot be 0 or negative value.')
    WHERE (SELECT betrag FROM mahnung WHERE id = ausleihe_id) <= 0;

    UPDATE nutzer SET konto_guthaben = konto_guthaben - NEW.betrag
    WHERE id = (SELECT nutzer_id FROM ausleihe WHERE id = NEW.ausleihe_id);

    UPDATE ausleihe SET status = 'gemahnt' 
    WHERE id = NEW.ausleihe_id 
    AND status != 'beendet';

    INSERT INTO system_log (aktion, info) 
    VALUES (
        'reminder',
        'A reminder: ' || NEW.id || 'set for borrow-ID: ' || NEW.ausleihe_id ||
        'in value of: ' || NEW.betrag || ', on: ' || NEW.datum
    );
End;


-- E-book borrowing required fileds by "user":
-- * username
-- * title (book)
-- * duration

-- Nedded elements for automated borrow process:
-- * id (ausleihe)
-- * username (nutzer)
-- * title (medium)
-- * duration ()
-- * status (ausleihe) -- set to active
-- * konto_guthaben (nutzer)
-- * bestand (medium) ? -- It's an ebook

-- View to have needed date without the need to join tables 
--or create permanent table
CREATE VIEW v_ebook_borrow AS
SELECT 
    a.id, 
    n.name AS username, 
    m.titel AS title, 
    duration AS duration, -- Needs calculated duration
    a.status, 
    n.konto_guthaben, 
    m.bestand
FROM ausleihe a
LEFT JOIN nutzer n ON a.nutzer_id = n.id
LEFT JOIN medium m ON a.medium_id = m.id
WHERE m.typ = 'ebook';

-- E-book automation trigger
CREATE TRIGGER trg_ebook_borrow_auto_process
AFTER INSERT ON ausleihe
FOR EACH ROW
BEGIN
    INSERT INTO ausleihe (nutzer_id, medium_id, status) 
    VALUES (
        (SELECT id FROM nutzer WHERE name = NEW.username),
        (SELECT id FROM medium WHERE titel = NEW.title),
        'aktive'
    );

    UPDATE medium SET bestand = beendet - 1 WHERE id = NEW.medium_id;

    Update nutzer SET konto_guthaben = konto_guthaben - 1;

    INSERT INTO system_log (aktion, info) 
    VALUES (
        'borrow_start',
        'A borrow: ' || NEW.id || 'started for user: ' || NEW.nutzer_id ||
        'borrowed: ' || NEW.medium_id || ', on: ' || NEW.startdatum
    );
END;


-- Deleting a user

-- Need to also delete:
-- * open loans
-- * reminders
-- * fees

-- Log user info & date of deletion
CREATE TRIGGER trg_auto_delete_log_user_delete
BEFORE DELETE ON nutzer
FOR EACH ROW
BEGIN
    INSERT INTO system_log (aktion, info) 
    VALUES (
        'delete user',
        'User ID: ' || OLD.id || 'Name: ' || OLD.name ||
        'was deleted on: ' || DATE('now') ||
        'with a balance of: ' || OLD.konto_guthaben
    );

    DELETE FROM mahnung
    WHERE ausleihe_id = (SELECT id FROM ausleihe WHERE nutzer_id = OLD.id);

    DELETE FROM ausleihe
    WHERE nutzer_id = OLD.id;
END;
