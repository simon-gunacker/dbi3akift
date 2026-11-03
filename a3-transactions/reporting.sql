SELECT id, name 
FROM artikel 
WHERE lagerbestand < mindestbestand;

SELECT * 
FROM kunde 
WHERE aktueller_kredit>(kreditlimit*0.90);

SELECT SUM(gesamtwert) 
FROM bestellung 
WHERE DATE(datum)= DATE('now') AND status= 'offen';


SELECT a.id, a.name, a.lagerbestand, SUM(l.menge) 
FROM artikel a 
JOIN lagerbewegung l ON a.id = artikel_id
GROUP BY a.id;