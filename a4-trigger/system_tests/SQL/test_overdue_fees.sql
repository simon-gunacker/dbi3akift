/*
Testcase 1: Nutzer 1 leiht medium 2 aus und behält es für 15 Tage
*/

-- Nutzer 1 hat medium 2 vor 15 Tagen ausgeliehen.
INSERT INTO ausleihe(nutzer_id, medium_id, startdatum, rueckgabedatum)
VALUES(1, 2, (DATE('now', '-15 day')), (DATE('now', '-1 day')));

/*
OUTPUT in mahnung: 1|4|10|2026-11-22
OUTPUT in nutzer: 1|Anna Muster|0
*/

-- Nutzer 1 möchte jetzt noch ein Buch ausleihen
INSERT INTO ausleihe(nutzer_id, medium_id)
VALUES(1, 3);

/*
OUTPUT: Runtime error: Guthaben zu gering, bitte einzahlen! (19)
*/
