CREATE VIEW IF NOT EXISTS nam
AS
    SELECT
        n.id AS n_id, n.name, n.konto_guthaben, a.id AS a_id, a.nutzer_id, a.medium_id, a.startdatum,  a.rueckgabedatum, a.status, m.id AS m_id, m.ausleihe_id, m.betrag, m.datum
    FROM nutzer n
    FULL JOIN ausleihe a ON n.id=a.nutzer_id
    FULL JOIN mahnung m ON a.id=m.ausleihe_id;
