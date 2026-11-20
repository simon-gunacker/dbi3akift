

    UPDATE ausleihe
    SET status = 'gemahnt'
    WHERE status = 'aktiv' AND DATE('now') > rueckgabedatum;



