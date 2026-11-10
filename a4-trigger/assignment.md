# Projektbeschreibung: Automatische Abläufe in einem Bibliothekssystem

In einer Bibliothek sollen verschiedene Abläufe ohne manuelles Eingreifen funktionieren. Das System soll sich also selbst „um Dinge kümmern“, wenn bestimmte Ereignisse in den Daten auftreten.

## Datenbankschema

```sql
CREATE TABLE nutzer (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    konto_guthaben DECIMAL(10,2) DEFAULT 0 CHECK (konto_guthaben >= 0)
);

CREATE TABLE medium (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titel TEXT NOT NULL,
    typ TEXT CHECK (typ IN ('buch', 'ebook')),
    bestand INTEGER DEFAULT 0 CHECK (bestand >= 0)
);

CREATE TABLE ausleihe (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nutzer_id INTEGER,
    medium_id INTEGER,
    startdatum DATE DEFAULT DATE('now'),
    rueckgabedatum DATE DEFAULT DATE('now', '+14 day'),
    status TEXT DEFAULT 'aktiv',  -- aktiv, beendet, gemahnt, gesperrt
    FOREIGN KEY (nutzer_id) REFERENCES nutzer(id),
    FOREIGN KEY (medium_id) REFERENCES medium(id)
);

CREATE TABLE mahnung (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ausleihe_id INTEGER,
    betrag DECIMAL(10,2),
    datum DATE DEFAULT DATE('now'),
    FOREIGN KEY (ausleihe_id) REFERENCES ausleihe(id)
);

CREATE TABLE system_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    aktion TEXT,
    info TEXT,
    datum DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## Testdaten

```sql
INSERT INTO nutzer (name, konto_guthaben) VALUES 
('Anna Muster', 10.00),
('Ben Beispiel', 5.00);

INSERT INTO medium (titel, typ, bestand) VALUES
('Der Zauberberg', 'buch', 3),
('Programmieren lernen mit Python', 'buch', 1),
('Digitale Welten', 'ebook', 9999);
```

## Anforderungen

### 1. Bestandsverwaltung

Wenn jemand ein Medium ausleiht, soll der verfügbare Bestand dieses Mediums automatisch angepasst werden. Es darf nicht vorkommen, dass mehr Exemplare ausgeliehen werden, als tatsächlich vorhanden sind.

### 2. Überfällige Ausleihen und Mahngebühren

Wird eine Ausleihe überfällig, soll automatisch eine Mahnung im System erfasst werden.
Gleichzeitig soll dem betroffenen Nutzer der entsprechende Betrag sofort vom Guthaben abgezogen werden.
Wird das Guthaben dadurch negativ, darf der Nutzer vorerst keine neuen Ausleihen mehr tätigen.

### 3. Vereinfachte Ausleihe von E-Books

Für digitale Medien (E-Books) soll die Ausleihe besonders bequem funktionieren: Wenn ein Eintrag mit Nutzername, Titel und gewünschter Dauer gemacht wird, soll das System automatisch alle weiteren notwendigen Informationen ergänzen, sodass der Ausleihvorgang vollständig ist.

### 4. Automatische Aufräumarbeiten

Wenn ein Nutzer gelöscht wird, sollen gleichzeitig alle zugehörigen offenen Ausleihen, Mahnungen oder Gebühren entfernt werden.
Im System soll dabei eine nachvollziehbare Notiz oder ein Eintrag entstehen, der zeigt, dass dieser Löschvorgang stattgefunden hat.

### 5. Nachvollziehbarkeit von Änderungen

Das System soll jede wichtige Änderung automatisch dokumentieren, etwa:

- Ausleihen oder Rückgaben,
- Mahnungen,
- das Löschen von Medien oder Nutzern.

Diese Informationen sollen später auswertbar sein, um Abläufe nachvollziehen zu können.

### 6. Plausibilitätsprüfung

Es darf nicht möglich sein, Mahngebühren mit 0 € oder negativen Beträgen zu erfassen.

## Abgabe 

Abzugeben ist ein System, dass die obenstehenden Anforderungen erfüllt. Dazu sollen keine Programmiersprachen genutzt werden, die Lösung soll in SQL umgesetzt werden. 
Gleichzeitig sind dokumentierte Testfälle abzugeben; es soll schriftlich festgehalten werden, wie das System sich bei den Testfällen verhält.
