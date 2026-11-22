/*
Testcase 1: Nutzer 1 leiht medium 2 aus und gibt es wieder zurück
*/

-- Nutzer 1 leiht medium 2 aus --> bestand geht von 1 auf 0
INSERT INTO ausleihe(nutzer_id, medium_id)
VALUES(1, 2);

/*OUTPUT: 1|Ausleihe|Medium 2 wurde von Nutzer 1 ausgeliehen|2026-11-22 11:20:15*/

-- Nutzer 1 gibt medium 2 zurück --> bestand geht von 0 auf 1
UPDATE Ausleihe
SET status = 'beendet'
WHERE id = (SELECT MAX(id) FROM ausleihe);
/*OUTPUT: 2|Rueckgabe|Medium 2 wurde von Nutzer 1 zurueckgegeben|2026-11-22 11:25:38*/