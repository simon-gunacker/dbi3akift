## 1.- Bestandverwaltung (existencias)
~~~sql
INSERT INTO ausleihe(nutzer_id, medium_id) VALUES(1,2);
~~~
~~~sql
SELECT * FROM ausleihe;
~~~

| id | nutzer_id | medium_id | startdatum | rueckgabedatum | status |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | 2 | 2026-11-22 | 2026-12-06 | aktiv |

~~~sql
SELECT * FROM medium;
~~~

| id | titel | typ | bestand |
| --- | --- | --- | --- |
| 1 | Der Zauberberg | buch | 3 |
| 2 | Programmieren lernen mit Python | buch | <mark>0</mark> |
| 3 | Digitale Welten | ebook | 9999 |


~~~sql
INSERT INTO ausleihe(nutzer_id, medium_id) VALUES(2,2);
Runtime error: Kein Bestand (19)
~~~

## 2.- Überfällige Ausleihen und Mahngebühren (prestamos vencidos y tasas de recargo)
~~~sql
INSERT INTO ausleihe(nutzer_id, medium_id) VALUES(2,1);
SELECT * FROM ausleihe;
~~~


| id | nutzer_id | medium_id | startdatum | rueckgabedatum | status |
| --- | --- | --- | --- | --- | --- |
| 1  | 1         | 2         | 2026-11-22 | 2026-12-06     | aktiv  |
| <mark>2</mark>  | <mark>2</mark>  | <mark>1</mark>  |<mark> 2026-11-22 </mark> | <mark>2026-12-06</mark>     | <mark>aktiv </mark> |

~~~sql
UPDATE ausleihe 
SET startdatum = DATE('now', '-15 day'), 
    rueckgabedatum = DATE('now', '-1 day'), 
    status = 'gemahnt' 
WHERE id = 2;
~~~

~~~sql
SELECT * FROM mahnung;
~~~

| id | ausleihe_id | betrag |   datum    |
| --- | --- | --- | --- |
| 1  | 2           | 7      | 2026-11-22 |

~~~sql
SELECT * FROM medium;
~~~

| id |              titel              |  typ  | bestand |
| --- | --- | --- | --- |
| 1  | Der Zauberberg                  | buch  | <mark>**2**</mark>      |
| 2  | Programmieren lernen mit Python | buch  | 0       |
| 3  | Digitale Welten                 | ebook | 9999    |

~~~sql
SELECT * FROM nutzer; 
~~~

| id |     name     | konto_guthaben |
| --- | --- | --- | 
| 1  | Anna Muster  | 10             |
| 2  | Ben Beispiel |<mark> -2</mark>|

Hier beginnt die Sperre

~~~sql 
INSERT INTO ausleihe(nutzer_id, medium_id) VALUES(2,1);
SELECT * FROM ausleihe;

Runtime error: Keine Guthaben (19)
~~~

## 3. Vereinfachte Ausleihe von E-Books (Prestamo simplificado de libros electronicos)

~~~sql
INSERT INTO v_ausleihe (name, titel, rueckgabedatum) 
VALUES ('Anna Muster', 'Digitale Welten', 10);
SELECT * FROM  ausleihe;
~~~


| id | nutzer_id | medium_id | startdatum | rueckgabedatum | status  |
| --- | --- | --- | --- | --- | --- |
| 1  | 1         | 2         | 2026-11-22 | 2026-12-06     | aktiv   |
| 2  | 2         | 1         | 2026-11-07 | 2026-11-21     | gemahnt |
|<mark> 3 </mark> | <mark>1</mark>| <mark>3</mark>| <mark>2026-11-22</mark> | <mark>2026-12-02 </mark>| <mark>aktiv</mark>|

Wenn ich ein physisches Buch über die View eintragen möchte, bekomme ich eine Fehlermeldung.

~~~sql
INSERT INTO v_ausleihe (name, titel, rueckgabedatum) 
VALUES ('Anna Muster', 'Der Zauberberg', 10);

Runtime error: Nur E-Books erlaubt (19)
~~~ 

## 4. Automatische Aufräumarbeiten (Limpieza automatica de datos)

~~~sql
DELETE FROM nutzer WHERE id = 2;
~~~

~~~sql
SELECT * FROM nutzer;
~~~

| id |    name     | konto_guthaben |
| --- | --- | --- | 
| 1  | Anna Muster | 10             |

~~~sql
SELECT * FROM ausleihe;
~~~

| id | nutzer_id | medium_id | startdatum | rueckgabedatum | status |
| --- | --- | --- | --- | --- | --- |
| 1  | 1         | 2         | 2026-11-22 | 2026-12-06     | aktiv  |
| 3  | 1         | 3         | 2026-11-22 | 2026-12-02     | aktiv  |

~~~sql
SELECT * FROM mahnung;
~~~

~~~sql 
SELECT * FROM system_log; 
~~~

| id |  aktion  | info   |    datum        |
| --- | --- | --- | --- |
| 1  | ausleihe | Nutzer: Anna Muster, Medium: Programmieren lernen mit Python | 2026-11-22 10:37:56 |
| 2  | ausleihe | Nutzer: Ben Beispiel, Medium: Der Zauberberg                 | 2026-11-22 10:37:56 |
| 3  | Mahnung  | Nutzer: Ben Beispiel                                         | 2026-11-22 10:37:56 |
| 5  | ausleihe | Nutzer: Anna Muster, Medium: Digitale Welten                 | 2026-11-22 11:16:14 |
|<mark> 6 <mark> | <mark>delete</mark>   | <mark>Nutzer gelöscht: Ben Beispiel </mark>|<mark> 2026-11-22 11:25:12 </mark> |


## 5. Nachvollziehbarkeit von Änderungen (Registro y seguimiento de modificaciones)

Rückgaben
~~~sql
UPDATE ausleihe SET status = 'beendet' WHERE id = 1;
~~~

Löschen
~~~sql
DELETE FROM medium WHERE id = 2;
~~~
~~~sql
SELECT * FROM system_log;
~~~
| id |  aktion  | info | datum |
| --- | --- | --- | --- | 
| 1  | ausleihe | Nutzer: Anna Muster, Medium: Programmieren lernen mit Python | 2026-11-22 10:37:56 |
| 2  | ausleihe | Nutzer: Ben Beispiel, Medium: Der Zauberberg                 | 2026-11-22 10:37:56 |
| 3  | Mahnung  | Nutzer: Ben Beispiel                                         | 2026-11-22 10:37:56 |
| 5  | ausleihe | Nutzer: Anna Muster, Medium: Digitale Welten                 | 2026-11-22 11:16:14 |
| 6  | delete   | Nutzer gelöscht: Ben Beispiel                                | 2026-11-22 11:25:12 |
|<mark> 7 </mark>  |<mark> Rückgabe </mark>| Nutzer: Anna MusterMedium: Programmieren lernen mit Python   | 2026-11-22 11:40:47 |
|<mark>8 </mark>|<mark>delete</mark>| Delete: Programmieren lernen mit Python                      | 2026-11-22 11:41:07 |

## 6. Plausibilitätsprüfung (validacion de coherencias)

~~~sql
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (3, 0);

Runtime error: Mahngebühr muss größer als 0 sein (19)
~~~
~~~sql
INSERT INTO mahnung (ausleihe_id, betrag) VALUES (3, -5.00);
Runtime error: Mahngebühr muss größer als 0 sein (19)
~~~ 