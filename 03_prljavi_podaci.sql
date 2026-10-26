USE LogistikaDW;
GO

UPDATE stg_Posiljke
SET Kupac = NULL
WHERE BrojPosiljke IN (SELECT TOP 15 BrojPosiljke FROM stg_Posiljke ORDER BY NEWID());

UPDATE stg_Posiljke
SET Kupac = '  ' + UPPER(Kupac)
WHERE BrojPosiljke IN (SELECT TOP 20 BrojPosiljke FROM stg_Posiljke ORDER BY NEWID());

UPDATE stg_Posiljke
SET DatumPolaska = CONVERT(VARCHAR(10), CAST(DatumPolaska AS DATE), 104)
WHERE BrojPosiljke IN (SELECT TOP 30 BrojPosiljke FROM stg_Posiljke ORDER BY NEWID());

UPDATE stg_Posiljke
SET Prihod = 'N/A'
WHERE BrojPosiljke IN (SELECT TOP 10 BrojPosiljke FROM stg_Posiljke ORDER BY NEWID());

INSERT INTO stg_Posiljke
SELECT TOP 20 * FROM stg_Posiljke ORDER BY NEWID();
GO

SELECT
    COUNT(*)                                          AS UkupnoRedova,
    COUNT(DISTINCT BrojPosiljke)                      AS RazlicitihPosiljki,
    SUM(CASE WHEN Kupac IS NULL THEN 1 ELSE 0 END)    AS BezKupca,
    SUM(CASE WHEN DatumPolaska LIKE '%.%' THEN 1 ELSE 0 END) AS DatumSaTackama,
    SUM(CASE WHEN Prihod = 'N/A' THEN 1 ELSE 0 END)   AS PrihodNA
FROM stg_Posiljke;