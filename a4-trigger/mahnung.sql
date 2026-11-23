-- idea, is executed automatically over a script every day
BEGIN TRANSACTION;
    UPDATE ausleihe
    SET status = 'gemahnt'
    WHERE status = 'aktiv' AND DATE('now') > rueckgabedatum;
COMMIT;



