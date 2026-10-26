USE LogistikaDW;
GO

CREATE OR ALTER PROCEDURE usp_Pokreni_ETL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            EXEC usp_Ucitaj_Dimenzije;
            EXEC usp_Ucitaj_Cinjenice;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

EXEC usp_Pokreni_ETL;
SELECT COUNT(*) AS PosiljkiPosleDrugogPokretanja FROM fact_Posiljke;

DELETE FROM fact_Posiljke;
EXEC usp_Pokreni_ETL;
SELECT COUNT(*) AS PosiljkiPosleUcitavanjaOdNule FROM fact_Posiljke;