CREATE TABLE Customer (
	CustomerID SERIAL PRIMARY KEY,
	CustomerName VARCHAR(20) NOT NULL 
);

CREATE TABLE Meter (
	MeterID SERIAL PRIMARY KEY,
	CustomerID INT NOT NULL REFERENCES Customer(CustomerID)
);


CREATE TABLE MeterReading (
    MeterReadingID SERIAL PRIMARY KEY,
    MeterID INT NOT NULL REFERENCES Meter(MeterID),
    ReadingDate DATE NOT NULL,
    PreviousReadingID INT REFERENCES MeterReading(MeterReadingID),
    CurrentReading DECIMAL(10,2) NOT NULL,
    ReadingType VARCHAR(20),
    Status BIT,
    Remarks VARCHAR(255) NULL
);