-- idea, is executed automatically over a script every day
    UPDATE ausleihe
    SET status = 'gemahnt'
    WHERE status = 'aktiv' AND DATE('now') > rueckgabedatum;



