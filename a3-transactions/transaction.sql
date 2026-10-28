BEGIN TRANSACTION;


CREATE TEMP TABLE transaction_article(id INTEGER, amount INTEGER);
CREATE TEMP TABLE transaction_id (id INTEGER);

INSERT INTO temp.transaction_id (id)
SELECT id
FROM (
    INSERT INTO bestellung (kunde_id)
    VALUES (1)
    RETURNING id
    );

INSERT INTO temp.transaction_article (id, amount)
VALUES (1, 5);

    -- Using a per-Article logic as to enable savepoints later on
UPDATE artikel
SET lagerbestand = lagerbestand - (SELECT amount FROM temp.transaction_article)
WHERE id = (SELECT id FROM temp.transaction_article);

INSERT INTO bestellposition (bestellung_id, artikel_id, menge)
VALUES  ((SELECT id FROM temp.transaction_id), (SELECT id FROM temp.transaction_article), (SELECT amount FROM temp.transaction_article));

WITH total_amount AS (
    SELECT (
    (SELECT menge FROM bestellposition WHERE id = last_insert_rowid()) *
    (SELECT verkaufspreis FROM artikel WHERE id = (SELECT id FROM temp.transaction_article))) as amount
)
UPDATE bestellung
SET gesamtwert = gesamtwert + (SELECT amount FROM total_amount)
WHERE id = (SELECT id FROM temp.transaction_id);

WITH total_amount AS (
    SELECT (
    (SELECT menge FROM bestellposition WHERE id = last_insert_rowid()) *
    (SELECT verkaufspreis FROM artikel WHERE id = (SELECT id FROM temp.transaction_article))) as amount
)
UPDATE kunde
SET aktueller_kredit = aktueller_kredit + (SELECT amount FROM total_amount))
WHERE id = (SELECT kunde_id FROM bestellung WHERE id = temp.transaction_id);

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES  ((SELECT id FROM temp.transaction_article), (SELECT id FROM temp.transaction_id), -(SELECT amount FROM temp.transaction_article), "verkauf");

DELETE FROM temp.transaction_article;


INSERT INTO temp.transaction_article (id, amount)
VALUES (2, 2);

    -- Using a per-Article logic as to enable savepoints later on
UPDATE artikel
SET lagerbestand = lagerbestand - (SELECT amount FROM temp.transaction_article)
WHERE id = (SELECT id FROM temp.transaction_article);

INSERT INTO bestellposition (bestellung_id, artikel_id, menge)
VALUES  ((SELECT id FROM temp.transaction_id), (SELECT id FROM temp.transaction_article), (SELECT amount FROM temp.transaction_article));

WITH total_amount AS (
    SELECT (
    (SELECT menge FROM bestellposition WHERE id = last_insert_rowid()) *
    (SELECT verkaufspreis FROM artikel WHERE id = (SELECT id FROM temp.transaction_article))) as amount
)
UPDATE bestellung
SET gesamtwert = gesamtwert + (SELECT amount FROM total_amount)
WHERE id = (SELECT id FROM temp.transaction_id);

WITH total_amount AS (
    SELECT (
    (SELECT menge FROM bestellposition WHERE id = last_insert_rowid()) *
    (SELECT verkaufspreis FROM artikel WHERE id = (SELECT id FROM temp.transaction_article))) as amount
)
UPDATE kunde
SET aktueller_kredit = aktueller_kredit + (SELECT amount FROM total_amount))
WHERE id = (SELECT kunde_id FROM bestellung WHERE id = temp.transaction_id);

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES  ((SELECT id FROM temp.transaction_article), (SELECT id FROM temp.transaction_id), -(SELECT amount FROM temp.transaction_article), "verkauf");

DELETE FROM temp.transaction_article;


INSERT INTO temp.transaction_article (id, amount)
VALUES (3, 50);

    -- Using a per-Article logic as to enable savepoints later on
UPDATE artikel
SET lagerbestand = lagerbestand - (SELECT amount FROM temp.transaction_article)
WHERE id = (SELECT id FROM temp.transaction_article);

INSERT INTO bestellposition (bestellung_id, artikel_id, menge)
VALUES  ((SELECT id FROM temp.transaction_id), (SELECT id FROM temp.transaction_article), (SELECT amount FROM temp.transaction_article));

WITH total_amount AS (
    SELECT (
    (SELECT menge FROM bestellposition WHERE id = last_insert_rowid()) *
    (SELECT verkaufspreis FROM artikel WHERE id = (SELECT id FROM temp.transaction_article))) as amount
)
UPDATE bestellung
SET gesamtwert = gesamtwert + (SELECT amount FROM total_amount)
WHERE id = (SELECT id FROM temp.transaction_id);

WITH total_amount AS (
    SELECT (
    (SELECT menge FROM bestellposition WHERE id = last_insert_rowid()) *
    (SELECT verkaufspreis FROM artikel WHERE id = (SELECT id FROM temp.transaction_article))) as amount
)
UPDATE kunde
SET aktueller_kredit = aktueller_kredit + (SELECT amount FROM total_amount))
WHERE id = (SELECT kunde_id FROM bestellung WHERE id = temp.transaction_id);

INSERT INTO lagerbewegung (artikel_id, bestellung_id, menge, typ)
VALUES  ((SELECT id FROM temp.transaction_article), (SELECT id FROM temp.transaction_id), -(SELECT amount FROM temp.transaction_article), "verkauf");

DELETE FROM temp.transaction_article;


COMMIT;
