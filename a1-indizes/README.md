# Indizes

| Messgröße | gleich.db ohne Index | gleich.db mit Index | bias.db ohne Index | bias.db mit Index |
|---|---|---|---|---|
| Dateigröße | 11 571 200 B | 19 075 072 B | 11 571 200 B | 19 079 168 B |
| Zuwachs durch Index | – | +7 503 872 B (+64,8 %) | – | +7 507 968 B (+64,9 %) |

| Nr. | DB | Index | real | user | sys |
|---|---|---|---|---|---|
| 1 | bias.db | ohne | 0,542 s | 0,519341 s | 0,021494 s |
| 2 | bias.db | mit | 0,108 s | 0,095624 s | 0,011918 s |
| 3 | gleich.db | ohne | 0,267 s | 0,255826 s | 0,010736 s |
| 4 | gleich.db | mit | 0,040 s | 0,039906 s | 0,000000 s |

Abfrage:
WITH base AS (
    SELECT vorname, COUNT(*) AS anzahl
    FROM personen
    GROUP BY vorname
)
SELECT vorname,anzahl * 100.0 / (SELECT COUNT(*) FROM personen)
FROM base
ORDER BY 2 desc
;

