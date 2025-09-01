-- 8.Create Stored Procedures to perform Insert/Update/Delete/View.

CREATE OR REPLACE PROCEDURE InsertMeterReading(
    p_MeterId INT,
    p_ReadingDate DATE,
    p_CurrentReading DECIMAL(10,2),
    p_ReadingType VARCHAR(20),
    p_Status BIT,
    p_Remarks VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    prevReadingID INT;
    prevReadingValue DECIMAL(10,2);
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Meter WHERE MeterId = p_MeterId) THEN
        RAISE EXCEPTION 'Meter with ID % does not exist.', p_MeterId;
    END IF;

    SELECT MeterReadingID, CurrentReading
    INTO prevReadingID, prevReadingValue
    FROM MeterReading
    WHERE MeterID = p_MeterId
    ORDER BY ReadingDate DESC
    LIMIT 1;

    INSERT INTO MeterReading(
        MeterID, ReadingDate, PreviousReadingID, CurrentReading, ReadingType, Status, Remarks
    )
    VALUES (
        p_MeterId, 
        p_ReadingDate, 
        prevReadingID,      
        p_CurrentReading, 
        p_ReadingType, 
        p_Status, 
        p_Remarks
    );

    
END;
$$;

CALL InsertMeterReading(1, '2025-07-15',150.0, 'Manual', b'1', 'Reading');

CREATE OR REPLACE PROCEDURE UpdateMeterReading(
	p_newReading DECIMAL(10,2),
	p_MeterReadingId INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE MeterReading
	SET CurrentReading = p_newReading
	WHERE MeterReadingId = p_MeterReadingId;
END;
$$;

CALL UpdateMeterReading(350, 7);


-- Delete Procedure

CREATE OR REPLACE PROCEDURE DeleteMeterReading(
	p_MeterReadingId INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM MeterReading
	WHERE MeterReadingId = p_MeterReadingId;
END;
$$;

CALL DeleteMeterReading(7);


-- View

CREATE VIEW MeterReadingDetails AS
SELECT
	c.CustomerName,
	m.MeterId, 
	mr1.ReadingDate,
	mr1.CurrentReading-COALESCE(mr2.CurrentReading,0) as UnitsConsumed
from Customer c
JOIN Meter m on m.CustomerId = c.CustomerID
JOIN MeterReading mr1 on mr1.MeterId = m.MeterId
LEFT JOIN MeterReading mr2 on mr2.MeterReadingId = mr1.PreviousReadingId;

SELECT * from MeterReadingDetails;