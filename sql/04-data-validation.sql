USE MedicalPartsAnalytics;
GO

-- Confirm expected row count
SELECT COUNT(*) AS TotalOrders
FROM dbo.Orders;

-- Check for duplicate OrderIDs
SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- Check for missing important values
SELECT *
FROM dbo.Orders
WHERE
    OrderDate IS NULL
    OR CustomerID IS NULL
    OR ProductID IS NULL
    OR Quantity IS NULL
    OR UnitPrice IS NULL;

-- Check for invalid quantities or prices
SELECT *
FROM dbo.Orders
WHERE
    Quantity <= 0
    OR UnitPrice < 0;

-- Check allowed Yes/No fields
SELECT DISTINCT RushOrder
FROM dbo.Orders;

SELECT DISTINCT Returned
FROM dbo.Orders;

-- Compare raw and final counts
SELECT
    (SELECT COUNT(*) FROM dbo.orders_raw) AS RawRows,
    (SELECT COUNT(*) FROM dbo.Orders) AS LoadedRows;