--Vor dem Ausleihe muss der Bestand geprüft werden
CREATE TRIGGER check_inventory
BEFORE INSERT ON ausleihe
BEGIN
    SELECT CASE
        WHEN (
            SELECT bestand
            FROM medium
            WHERE id = NEW.medium_id
        ) <=0
        THEN RAISE(ABORT, 'Bestand zu gering!')
    END;
END;

--Nach dem Ausleihen muss der Bestand angepasst werden (Annahme: Kunden leihen nur 1 Exemplar auf einmal aus)
CREATE TRIGGER adjust_inventory
AFTER INSERT ON ausleihe
BEGIN
    UPDATE medium
    SET bestand = bestand - 1
    WHERE id = NEW.medium_id
    AND typ = 'buch';
END;

--Nach der Bestandsanpassung muss gelogged werden
CREATE TRIGGER log_inventory_changes
AFTER INSERT ON ausleihe
BEGIN
    INSERT INTO system_log(aktion, info)
    VALUES (
        'Ausleihe', 'Medium ' || NEW.medium_id || ' wurde von Nutzer ' || NEW.nutzer_id || ' ausgeliehen'
    );
END;