/*
Angabe: Es darf nicht möglich sein, Mahngebühren mit 0 € oder negativen Beträgen zu erfassen.
*/

CREATE TRIGGER fee_plausibility
BEFORE INSERT ON mahnung
BEGIN
    SELECT CASE
        WHEN NEW.betrag <= 0
        THEN RAISE(ABORT, 'Mahngebühr zu klein, bitte einen gültigen Betrag eingeben!')
    END;
END;