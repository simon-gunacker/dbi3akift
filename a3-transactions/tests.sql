.read schema_db.sql
.read testdaten.sql
.read transactionen.sql

.headers on
.mode column

SELECT * FROM bestellung;
-- id  kunde_id  datum                status  gesamtwert
-- --  --------  -------------------  ------  ----------
-- 1   1         2026-11-01 20:07:40  offen   287.5  


SELECT * FROM bestellposition;

-- bestellung_id  artikel_id  menge  einzelpreis
-- -------------  ----------  -----  -----------
-- 1              1           5      25         
-- 1              2           2      75         
-- 1              3           50     0.25      


.read stornierung.sql

SELECT * FROM bestellung;
-- id  kunde_id  datum                status     gesamtwert
-- --  --------  -------------------  ---------  ----------
-- 1   1         2026-11-01 20:07:40  storniert  0     



SELECT id, name, lagerbestand, verkaufspreis 
FROM artikel;

-- 1|Arduino Uno|100|25
-- 2|Raspberry Pi 4|50|75
-- 3|LED 5mm rot|1000|0.25
-- 4|Widerstand 220Ω|5000|0.05
-- 5|Breadboard|30|8



SELECT * FROM v_tagesumsatz;
-- DATE(datum)  tagesumsatz
-- -----------  -----------
-- 2026-11-01   287.5      


SELECT * FROM v_lager_konsistenz;
-- id  name             ist_bestand  soll_bestand
-- --  ---------------  -----------  ------------
-- 1   Arduino Uno      95           95          
-- 2   Raspberry Pi 4   48           48          
-- 3   LED 5mm rot      950          950         
-- 4   Widerstand 220Ω  5000         5000        
-- 5   Breadboard       30           30   

--nach storno:
--id  name             ist_bestand  soll_bestand
-- --  ---------------  -----------  ------------
-- 1   Arduino Uno      100          100         
-- 2   Raspberry Pi 4   50           50          
-- 3   LED 5mm rot      1000         1000        
-- 4   Widerstand 220Ω  5000         5000        
-- 5   Breadboard       30           30    
--SELECT * FROM lagerbewegung;



UPDATE artikel SET lagerbestand = 5 WHERE id = 1;
SELECT * FROM v_artikel_nachbestellung;

-- id  name         lagerbestand  mindestbestand  zubestellende_menge
-- --  -----------  ------------  --------------  -------------------
-- 1   Arduino Uno  5             10              5                  


UPDATE kunde SET aktueller_kredit = 4600 WHERE id = 1;
SELECT * FROM v_kunden_kreditlimit;

-- kunde_id  name           kreditlimit  aktueller_kredit  kreditlimit_prozent
-- --------  -------------  -----------  ----------------  -------------------
-- 1         TechShop Wien  5000         4600              92.0               

.read schema_db.sql
.read testdaten.sql
.read validierung.sql


SELECT * FROM lagerbewegung;

-- id  artikel_id  bestellung_id  menge  typ      datum              
-- --  ----------  -------------  -----  -------  -------------------
-- 1   1           1              -5     verkauf  2026-11-01 20:58:16
-- 2   2           1              -2     verkauf  2026-11-01 20:58:16
-- 3   3           1              -50    verkauf  2026-11-01 20:58:16

.read schema_db.sql
.read testdaten.sql
UPDATE artikel SET lagerbestand = 2 WHERE id = 1;
.read validierung.sql

SELECT * FROM lagerbewegung;

-- id  artikel_id  bestellung_id  menge  typ            datum              
-- --  ----------  -------------  -----  -------------  -------------------
-- 1   1           1              3      nachlieferung  2026-11-01 21:08:45
-- 2   1           1              -5     verkauf        2026-11-01 21:08:45
-- 3   2           1              -2     verkauf        2026-11-01 21:08:45
-- 4   3           1              -50    verkauf        2026-11-01 21:08:45

.read schema_db.sql
.read testdaten.sql
UPDATE kunde SET aktueller_kredit = 4800.0 WHERE id = 1;
.read validierung.sql

SELECT id, status, gesamtwert FROM bestellung;

-- sqlite> SELECT id, status, gesamtwert FROM bestellung;
-- id  status  gesamtwert
-- --  ------  ----------
-- 1   offen             
