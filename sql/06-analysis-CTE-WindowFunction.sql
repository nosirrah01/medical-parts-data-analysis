-- Which customers generated more than $10,000 in revenue? (CTE)
WITH CustomerRevenue AS
(
    SELECT
        CustomerID,
        CustomerName,
        SUM(Quantity * UnitPrice) AS TotalRevenue
    FROM dbo.Orders
    GROUP BY
        CustomerID,
        CustomerName
)
SELECT *
FROM CustomerRevenue
WHERE TotalRevenue > 10000
ORDER BY TotalRevenue DESC;

-- Rank customers by revenue (window function)
WITH CustomerRevenue AS
(
    SELECT
        CustomerName,
        SUM(Quantity * UnitPrice) AS TotalRevenue
    FROM dbo.Orders
    GROUP BY CustomerName
)
SELECT
    CustomerName,
    TotalRevenue,
    RANK() OVER (
        ORDER BY TotalRevenue DESC
    ) AS RevenueRank
FROM CustomerRevenue;