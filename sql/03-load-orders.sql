USE MedicalPartsAnalytics;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Orders
)
BEGIN
    INSERT INTO dbo.Orders
    (
        OrderID,
        OrderDate,
        CustomerID,
        CustomerName,
        Region,
        ProductID,
        PartName,
        PartCategory,
        Manufacturer,
        Quantity,
        UnitPrice,
        ExpectedShippingDays,
        ShippingDays,
        RushOrder,
        Returned
    )
    SELECT
        OrderID,
        OrderDate,
        CustomerID,
        CustomerName,
        Region,
        ProductID,
        PartName,
        PartCategory,
        Manufacturer,
        Quantity,
        UnitPrice,
        ExpectedShippingDays,
        ShippingDays,
        RushOrder,
        Returned
    FROM dbo.orders_raw;
END;
GO

SELECT COUNT(*) AS TotalOrders
FROM dbo.Orders;
GO