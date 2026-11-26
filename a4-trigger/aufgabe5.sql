-- Aufgabe 5
-- Ausleihen wurde in Aufgabe 1 geregelt siehe dort Kommentar
-- Mahnung wurde in Aufgabe 2 geregelt sie dort Kommentar
-- Löschung wurde n Aufgabe 4 erledigt siehet bestehendes Insert in system_log

-- Rückgabe
CREATE TRIGGER rueckgabe_mediene
AFTER UPDATE OF status ON ausleihe
FOR EACH ROW
WHEN NEW.status = 'beendet'
BEGIN
    UPDATE medium SET bestand = bestand + 1 WHERE id = NEW.medium_id;

    INSERT INTO system_log (aktion, info) 
    VALUES ('RÜCKGABE', (SELECT titel
                        FROM medium
                        WHERE id = NEW.medium_id));
END;

-- Test:
-- Wir fügen einen ausleihe hinzu die wir dann Updaten
-- weil sie Zurückgebracht wurde

-- Bestand vor dem insert
SELECT * FROM medium;

INSERT INTO ausleihe (nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES (1, 3, '2026-10-05', '2026-10-16');

-- Erwartet: Bestand von Digitale Welten ist um 1 kleiner (wegen Aufgabe 1)
SELECT * FROM medium;

-- Erwartet: neuester Log-Eintrag ist AUSLEIHE
SELECT * FROM system_log WHERE id = (SELECT MAX(id) FROM system_log);

UPDATE ausleihe SET status = 'beendet'
WHERE id = (SELECT MAX(id) FROM ausleihe);

-- Erwartet: Bestand von Digitale Welten ist wieder um 1 größer
SELECT * FROM medium;

-- Erwartet: neuester Log-Eintrag ist RÜCKGABE
SELECT * FROM system_log WHERE id = (SELECT MAX(id) FROM system_log);

-- Medium löschen
CREATE TRIGGER loeschen_medienen
AFTER DELETE ON medium
FOR EACH ROW
BEGIN
    INSERT INTO system_log (aktion, info)
    VALUES ('MEDIUM_GELÖSCHT', OLD.titel);
END;

-- Test:
-- Wir fügen eine neues Medium ein und löschen dann das wieder
INSERT INTO medium (titel, typ, bestand)
VALUES ('ACOTAR', 'buch', 1);

-- Erwartet: ACOTAR ist als neues Medium da
SELECT * FROM medium;

--Jetzt löschen wir es
DELETE FROM medium WHERE id = (SELECT id FROM medium WHERE titel = 'ACOTAR');

-- Erwartet: ACOTAR ist wieder weg
SELECT * FROM medium;

-- Erwartet: neuester Log-Eintrag ist MEDIUM_GELÖSCHT mit ACOTAR
SELECT * FROM system_log WHERE id = (SELECT MAX(id) FROM system_log);

-- Gesamtübersicht für die Auswertung: alle Einträge im Log
SELECT * FROM system_log;
SELECT aktion, COUNT(*) AS anzahl FROM system_log GROUP BY aktion;