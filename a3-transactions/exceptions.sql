CREATE TRIGGER IF NOT EXISTS rollback_artikel_lagerbestand
BEFORE UPDATE ON artikel
WHEN NEW.lagerbestand < 0
BEGIN 
    SELECT RAISE(ROLLBACK, 'Aufgrund eines zu niedrigen Lagerbestandes ist die Transaktion fehlgeschlagen');
END;

CREATE TRIGGER IF NOT EXISTS rollback_kunde_kredit
BEFORE UPDATE ON kunde
WHEN NEW.aktueller_kredit > NEW.kreditlimit
BEGIN 
    SELECT RAISE(ROLLBACK, 'Aufgrund eines erreichten Kreditlimits ist die Transaktion fehlgeschlagen');
END;

CREATE TRIGGER IF NOT EXISTS rollback_bestellposition_menge
BEFORE INSERT ON bestellposition
WHEN NEW.menge <= 0
BEGIN 
    SELECT RAISE(ROLLBACK, 'Da das Produkt nicht verfügbar ist, ist die Transaktion fehlgeschlagen');
END;

/* 
Bei zu wenigem Lagerbestand wird die Transaktion abgebrochen, die "-journal" Datei entfernt und im Terminal erscheint folgende Nachricht:
Error near line [Nummer]: Aufgrund eines zu niedrigen Lagerbestandes ist die Transaktion fehlgeschlagen

Bei überschrittenem Keditlimit wird ebenfalls die Transaktion abgebrochen, die "-journal" Datei entfernt und im Terminal erscheint folgende Nachricht:
Error near line [Nummer]: Aufgrund eines erreichten Kreditlimits ist die Transaktion fehlgeschlagen
*/


