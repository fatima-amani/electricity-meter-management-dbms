INSERT INTO CUSTOMER (CustomerName) VALUES 
	('FATIMA'),
	('AAMNA'),
	('APEKSHA');

INSERT INTO Meter (CustomerID) VALUES
	('1'),
	('2'),
	('3');


INSERT INTO MeterReading (MeterID, ReadingDate, PreviousReadingID, CurrentReading, ReadingType, Status, Remarks)
VALUES
(1, '2025-07-10', NULL, 100.00, 'Manual',  B'1', 'reading for July'),
(2, '2025-07-11', NULL, 150.50, 'Automatic',  B'1', 'reading for July'),
(3, '2025-07-12', NULL, 200.75, 'Estimated',  B'1', 'reading for July');


INSERT INTO MeterReading (MeterID, ReadingDate, PreviousReadingID, CurrentReading, ReadingType, Status, Remarks)
VALUES
(1, '2025-08-10', 1, 120.00, 'Manual',  B'1', 'reading for August'),
(2, '2025-08-11', 2, 170.25, 'Automatic',  B'1', 'reading for August'),
(3, '2025-08-12', 3, 220.50, 'Estimated',  B'1', 'reading for August');
