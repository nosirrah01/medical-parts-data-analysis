-- Business Questions
-- Question 1: How many orders do we have
SELECT COUNT(*) AS TotalOrders
FROM dbo.Orders;

-- Question 2: What is total revenue?
SELECT
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM dbo.Orders;

-- Question 3: What's the average order value?
SELECT
    AVG(Quantity * UnitPrice) AS AverageOrderValue
FROM dbo.Orders;

-- Question 4: Which categories generate the most revenue?
SELECT
    PartCategory,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM dbo.Orders
GROUP BY PartCategory
ORDER BY TotalRevenue DESC;

-- Question 5: Which regions generate the most revenue?
SELECT
    Region,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM dbo.Orders
GROUP BY Region
ORDER BY TotalRevenue DESC;

-- Question 6: Which customers generate the most revenue?
SELECT TOP 5
    CustomerName,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM dbo.Orders
GROUP BY CustomerName
ORDER BY TotalRevenue DESC;

-- Shipping Performance
-- List all late orders
SELECT
    OrderID,
    CustomerName,
    PartCategory,
    ExpectedShippingDays,
    ShippingDays
FROM dbo.Orders
WHERE ShippingDays > ExpectedShippingDays;

-- How many of our orders are late?
SELECT
    COUNT(*) AS LateOrders
FROM dbo.Orders
WHERE ShippingDays > ExpectedShippingDays;

-- What percentage of our orders are late?
SELECT
    CAST(
        100.0 * SUM(
            CASE
                WHEN ShippingDays > ExpectedShippingDays THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS LateOrderPercentage
FROM dbo.Orders;

-- What categories have the highest late-order rate
SELECT
    PartCategory,
    COUNT(*) AS TotalOrders,
    SUM(
        CASE
            WHEN ShippingDays > ExpectedShippingDays THEN 1
            ELSE 0
        END
    ) AS LateOrders,
    CAST(
        100.0 * SUM(
            CASE
                WHEN ShippingDays > ExpectedShippingDays THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS LateOrderPercentage
FROM dbo.Orders
GROUP BY PartCategory
ORDER BY LateOrderPercentage DESC;

-- Which manufacture has the highest average shipping days?
SELECT
    Manufacturer,
    COUNT(*) AS TotalOrders,
    AVG(CAST(ShippingDays AS DECIMAL(10,2))) AS AvgShippingDays
FROM dbo.Orders
GROUP BY Manufacturer
ORDER BY AvgShippingDays DESC;

-- Which customer has the highest average shipping days?
SELECT
    CustomerName,
    COUNT(*) AS TotalOrders,
    AVG(CAST(ShippingDays AS DECIMAL(10,2))) AS AvgShippingDays
FROM dbo.Orders
GROUP BY CustomerName
ORDER BY AvgShippingDays DESC;

-- Do rush orders or non rush orders have higher or lower average shipping days.
SELECT
    RushOrder,
    COUNT(*) AS TotalOrders,
    AVG(CAST(ShippingDays AS DECIMAL(10,2))) AS AvgShippingDays
FROM dbo.Orders
GROUP BY RushOrder
ORDER BY AvgShippingDays DESC;