-- 1.Find customers who consumed more than 50 units in August 2025
SELECT c.CustomerName, mr1.CurrentReading-COALESCE(mr2.CurrentReading,0) as UnitsConsumed
from Customer c
JOIN Meter m on m.CustomerId = c.CustomerID
JOIN MeterReading mr1 on mr1.MeterId = m.MeterId
LEFT JOIN MeterReading mr2 on mr2.MeterReadingId = mr1.PreviousReadingId
WHERE (mr1.CurrentReading - COALESCE(mr2.CurrentReading, 0)) > 50
  AND mr1.ReadingDate BETWEEN '2025-08-01' AND '2025-08-31';

-- 2.Get average units consumed by ReadingType
SELECT 
	mr1.ReadingType, 
	AVG(mr1.CurrentReading- COALESCE(mr2.CurrentReading,0)) as AvgUnitsConsumed
FROM MeterReading mr1 
LEFT JOIN MeterReading mr2 on  mr1.PreviousReadingId = mr2.MeterReadingId 
GROUP BY mr1.ReadingType;

-- 3.Show the highest consumption reading per customer
SELECT c.CustomerName, MAX(mr1.CurrentReading-COALESCE(mr2.CurrentReading,0) )as MaxUnitConsumed
from Customer c
JOIN Meter m on m.CustomerId = c.CustomerID
JOIN MeterReading mr1 on mr1.MeterId = m.MeterId
LEFT JOIN MeterReading mr2 on mr2.MeterReadingId = mr1.PreviousReadingId
GROUP BY c.CustomerId;


-- 4.Identify suspicious readings where the current reading is less than the previous
SELECT 
	c.CustomerName, 
	mr1.CurrentReading as CurrentMonthReading,
	COALESCE(mr2.CurrentReading,0) as PreviousMonthReading
from Customer c
JOIN Meter m on m.CustomerId = c.CustomerID
JOIN MeterReading mr1 on mr1.MeterId = m.MeterId
LEFT JOIN MeterReading mr2 on mr2.MeterReadingId = mr1.PreviousReadingId
WHERE mr1.CurrentReading < mr2.CurrentReading;

-- 5.Find total units consumed per customer in July and August 2025
SELECT 
	c.CustomerName,
	SUM(mr1.CurrentReading-COALESCE(mr2.CurrentReading,0)) as UnitsConsumed
from Customer c
JOIN Meter m on m.CustomerId = c.CustomerID
JOIN MeterReading mr1 on mr1.MeterId = m.MeterId
LEFT JOIN MeterReading mr2 on mr2.MeterReadingId = mr1.PreviousReadingId
WHERE mr1.ReadingDate BETWEEN '2025-07-01' AND '2025-08-31'
GROUP BY c.CustomerId;

-- 6.Rank the customers based on total consumption in July and August 2025
SELECT 
	c.CustomerName,
	SUM(mr1.CurrentReading-COALESCE(mr2.CurrentReading,0)) as UnitsConsumed
from Customer c
JOIN Meter m on m.CustomerId = c.CustomerID
JOIN MeterReading mr1 on mr1.MeterId = m.MeterId
LEFT JOIN MeterReading mr2 on mr2.MeterReadingId = mr1.PreviousReadingId
WHERE mr1.ReadingDate BETWEEN '2025-07-01' AND '2025-08-31'
GROUP BY c.CustomerId
ORDER BY 2 DESC;

-- 7.Show last reading for each customer (most recent date)
SELECT DISTINCT ON (c.CustomerId)
	c.CustomerName, 
	mr1.ReadingDate,
	mr1.CurrentReading-COALESCE(mr2.CurrentReading,0) as UnitConsumed
from Customer c
JOIN Meter m on m.CustomerId = c.CustomerID
JOIN MeterReading mr1 on mr1.MeterId = m.MeterId
LEFT JOIN MeterReading mr2 on mr2.MeterReadingId = mr1.PreviousReadingId
ORDER by c.CustomerId, mr1.ReadingDate DESC;