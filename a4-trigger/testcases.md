## Testfälle nach Anforderungen

Alle Testfälle verwenden eine Datenbank die nach database.sql aufgesetzt wurden und trigger aus triggers.sql.
Logs werden immer in Table system_log festgehalten.

## Anforderung 1:
**Verwendete sql-Statements:** user_handling.sql, ausleihen.sql

**Ablauf:**
    
1. Nutzer-Id und Medium-Id in var_ids inserted
2. Transaction aus ausleihen.sql ausführen
3. Update dekrementiert Bestand des Mediums
4. Trigger bestandsprüfung_medium prüft vor dem Update des Mediums, ob der Bestand ausreicht, sonst wird ein ROLLBACK ausgeführt.
5. Insert legt eine neue Ausleihe mit den Werten aus var_ids an. Wenn eine Dauer > 0 übergeben wird und der Medien-Typ 'ebook' ist wird das Rückgabedatum auf Dauer-Tage von heute gesetzt
6. Trigger sperrprüfung_ausleihe führt bei einem Insert auf ausleihe automatisch die Event-Reihe aus Anforderung 2 aus.
7. Trigger sperrprüfung_ausleihe prüft, ob der Nutzer gesperrt ist und löst einen ROLLBACK aus wenn ja.
8. Trigger log_ausleihe logt nach dem Insert erfolgreiche Ausleihe.

## Anforderung 2:
**Verwendete sql-Statements:** mahnung.sql

**Ablauf:**
    
1. Update in mahnung.sql wird manuell oder automatisiert ausgeführt, alle überfälligen Ausleihen werden auf gemahnt gesetzt
2. Trigger mahnung wird ausgeführt nach dem Update für alle Ausleihen, die auf 'gemahnt' gesetzt wurden und davor 'aktiv' waren.
3. Trigger mahnung inserted eine mahnung mit dem fixen Betrag von 5€
4. Trigger betrag_insert_mahnung dekrementiert Betrag der Mahnung vom Kontoguthaben des Nutzers oder setzt das Kontoguthaben auf 0, wenn das Kontoguthaben weniger als Betrag der Mahnung beträgt
5. Trigger sperrung_nutzer wird ausgeführt nach dem Update für alle Nutzer ausgeführt wenn das alte Guthaben weniger als der Mahn-Betragen beträgt und das neue Guthaben 0€ beträgt
6. Trigger sperrung_nutzer setzt alle Ausleihen auf gesperrt, wenn bei einem Update des Nutzers eine Mahnung exisiert, die das Kontoguthaben des Nutzers übersteigt und das Kontoguthaben 0 ist.
7. Trigger sperrung_nutzer logt die Sperrung des Nutzers
8. Trigger betrag_insert_mahnung logt den abgezogenen Mahnbetrag
9. Trigger betrag_insert_mahnung logt bewusst Mahnungen bei bereits gesperrten Nutzern
10. Trigger sperrprüfung_ausleihe prüft, ob der Nutzer bereits gesperrt ist und löst einen ROLLBACK in der dazugehörigen Transaktion aus wenn ja.

## Anforderung 3:
**Verwendete sql-Statements:** user_handling.sql, ausleihen.sql

**Ablauf:**

1. var_ids wird als Temp-Table erstellt
2. Ein Insert mit 3 Werten wird auf var_ids ausgeführt
3. Für Wert 1 (nutzer_id) kann entweder die rohe ID oder ein String übergeben werden, der dann per SELECT zur ID des Nutzers aufgelöst wird
4. Für Wert 2 (medium_id) funktioniert das ganze gleich wie bei Wert 1 wobei Namensauflösungen nur auf Medien mit dem typ 'ebook' angewendet werden können.
5. Wert 3 ist optional und stellt die Dauer für das ausleihen von E-Books aus.
6. Selber Ablauf wie in Anforderung 1
        
## Anforderung 4:
**Verwendete sql-Statements:** trigger.sql

**Ablauf:**
    
1. DELETE wird auf einen bestehenden Nutzer ausgeführt
2. Trigger loeschung_nutzer führt ein DELETE für alle Mahnungen des Nutzers aus
3. Trigger loeschung_mahnung logt Löschung der Mahnungen pro Mahnung
4. Trigger loeschung_nutzer führt ein DELETE für alle Ausleihen des Nutzers aus
5. Trigger loeschung_ausleihe logt Löschung der Ausleihen pro Ausleihe
6. Trigger loeschung_nutzer logt Löschung des Nutzers
        
## Anforderung 5:
Anforderungen 1-4  loggen bereits eigenständig ihre Aktionen.

**Verwendete sql-Statements:** user_handling.sql, rueckgabe.sql

**Ablauf:**
    
1. Update in rueckgabe.sql wird mit Werten für Nuter_id und Medium_id aus user_handling.sql ausgeführt
2. Trigger log_rueckgabe wird nach dem Update ausgeführt
3. Trigger log_rueckgabe updated Medium um bestand + 1
4. Trigger log_rueckgabe logt die Rückgabe.
    
## Anforderung 6:
Enthalten in Anforderung 2

**Ablauf:**

1. Insert auf Mahnung wird ausgeführt
2. Trigger betrag_insert_mahnungen prüft, ob der Betrag größer als 0 ist, führt ROLLBACK aus wenn nicht
4. Trigger betrag_insert_mahnungen setzt das Kontoguthaben des Nutzers um den angegebenen Betrag -, oder 0, wenn der Betrag größer als das Kontoguthaben ist
3. Trigger block_update_mahnung blockiert alle Updates für mahnung, da mahnungen nachträglich nicht verändert werden sollen
       
