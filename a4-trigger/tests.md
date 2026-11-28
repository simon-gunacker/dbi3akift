# Testfälle – Assignment 4: Trigger

## Ausführen

```bash
rm -f test.db && sqlite3 test.db < tests.sql
```

`tests.sql` legt bei jedem Durchlauf Schema, Testdaten und Trigger neu an. Die Tests bauen aufeinander auf und müssen in der angegebenen Reihenfolge laufen.

## Annahmen

- Eine Ausleihe gilt als **überfällig**, sobald ihr Status auf `gemahnt` gesetzt wird.
- Eine **Rückgabe** ist ein Statuswechsel auf `beendet`.
- Die **Mahngebühr** beträgt pauschal **10,00 €** (Variante mit 0,30 €/Tag ist in `triggers.sql` auskommentiert).
- Der `CHECK (konto_guthaben >= 0)` wurde aus dem Schema entfernt, da Anforderung 2 ein negatives Guthaben vorsieht.
- Gesperrt ist ein Nutzer erst bei Guthaben **< 0 €**; bei genau 0 € darf er noch ausleihen.

## 1. Bestandsverwaltung

| Test | Aktion | Erwartet | Ergebnis |
|---|---|---|---|
| T1.1 | Anna leiht „Der Zauberberg“ (Bestand 3) | Bestand → 2 | Bestand 2 |
| T1.2 | Anna leiht „Programmieren lernen mit Python“ (Bestand 1) | Bestand → 0 |  Bestand 0 |
| T1.3 | Ben will „Python“ bei Bestand 0 ausleihen | Fehler, keine neue Ausleihe |  Fehler „Medium nicht verfügbar (Bestand 0)“, weiterhin 2 Ausleihen |
| T1.4 | Rückgabe „Python“ (Status → beendet) | Bestand → 1 |  Bestand 1 |

## 2. Überfällige Ausleihen und Mahngebühren

| Test | Aktion | Erwartet | Ergebnis |
|---|---|---|---|
| T2.1 | Annas Ausleihe (ID 1) → gemahnt | Mahnung 10 €, Anna 10 € → 0 € | 1 Mahnung, Anna 0 € |
| T2.2 | Dieselbe Ausleihe nochmal → gemahnt | keine 2. Mahnung, Anna bleibt 0 € | weiterhin 1 Mahnung, Anna 0 € |
| T2.3 | Ben leiht „Digitale Welten“ und gibt es zurück | keine Mahnung, Ben bleibt 5 € | weiterhin 1 Mahnung, Ben 5 € |
| T2.4 | Ben leiht „Der Zauberberg“ mit abgelaufener Frist (ID 4) → gemahnt | Mahnung 10 €, Ben 5 € → −5 € | 2 Mahnungen, Ben −5 € |
| T2.5 | Ben (−5 €) will „Digitale Welten“ ausleihen | Fehler, keine neue Ausleihe | Fehler „Guthaben negativ, Konto gesperrt“, weiterhin 4 Ausleihen |
| T2.6 | Anna (0 €) leiht „Digitale Welten“ | Ausleihe erlaubt | kein Fehler, 5 Ausleihen |