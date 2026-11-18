SELECT '--- Ausleihen und Mahngebühren ---' AS 'Trigger erstellen';

CREATE TRIGGER trg_mahnung_erstellen
AFTER UPDATE OF status ON ausleihe
WHEN NEW.status = 'gemahnt' AND OLD.status != 'gemahnt'
BEGIN
    INSERT INTO mahnung (ausleihe_id, betrag) VALUES (NEW.id, 2.50);

    UPDATE nutzer SET konto_guthaben = konto_guthaben - 2.50
    WHERE id = NEW.nutzer_id;

    INSERT INTO system_log (aktion, info)
        VALUES (
            'Mahnung', NEW.id || ' Von Nutzer ' || NEW.nutzer_id
        );
END;

CREATE TRIGGER trg_guthaben_pruefen
BEFORE INSERT ON ausleihe
BEGIN
    SELECT RAISE(ABORT, 'Guthaben zu niedrig – keine neue Ausleihe möglich!')
    WHERE (SELECT konto_guthaben FROM nutzer WHERE id = NEW.nutzer_id) < 0;
END;


