USE MedicalPartsAnalytics;
GO

DROP TABLE IF EXISTS dbo.OrdersNormalized;
DROP TABLE IF EXISTS dbo.Products;
DROP TABLE IF EXISTS dbo.Customers;
GO

/*
    07-normalized-schema.sql

    Purpose:
    Normalize the original dbo.Orders dataset by separating
    customer and product information from transactional order data.

    Original:
        dbo.Orders

    Normalized:
        dbo.Customers
        dbo.Products
        dbo.OrdersNormalized
*/


------------------------------------------------------------
-- 1. Create Customers table
------------------------------------------------------------

CREATE TABLE dbo.Customers
(
    CustomerID VARCHAR(10) NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Region VARCHAR(50) NOT NULL,

    CONSTRAINT PK_Customers
        PRIMARY KEY (CustomerID)
);
GO


------------------------------------------------------------
-- 2. Create Products table
------------------------------------------------------------

CREATE TABLE dbo.Products
(
    ProductID VARCHAR(10) NOT NULL,
    PartName VARCHAR(100) NOT NULL,
    PartCategory VARCHAR(50) NOT NULL,
    Manufacturer VARCHAR(100) NOT NULL,

    CONSTRAINT PK_Products
        PRIMARY KEY (ProductID)
);
GO


------------------------------------------------------------
-- 3. Create normalized Orders table
------------------------------------------------------------

CREATE TABLE dbo.OrdersNormalized
(
    OrderID INT NOT NULL,
    OrderDate DATE NOT NULL,
    CustomerID VARCHAR(10) NOT NULL,
    ProductID VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    ExpectedShippingDays INT NOT NULL,
    ShippingDays INT NOT NULL,
    RushOrder VARCHAR(3) NOT NULL,
    Returned VARCHAR(3) NOT NULL,

    CONSTRAINT PK_OrdersNormalized
        PRIMARY KEY (OrderID),

    CONSTRAINT FK_OrdersNormalized_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID),

    CONSTRAINT FK_OrdersNormalized_Products
        FOREIGN KEY (ProductID)
        REFERENCES dbo.Products(ProductID),

    CONSTRAINT CK_OrdersNormalized_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_OrdersNormalized_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT CK_OrdersNormalized_RushOrder
        CHECK (RushOrder IN ('Yes', 'No')),

    CONSTRAINT CK_OrdersNormalized_Returned
        CHECK (Returned IN ('Yes', 'No'))
);
GO


------------------------------------------------------------
-- 4. Load unique customers
------------------------------------------------------------

INSERT INTO dbo.Customers
(
    CustomerID,
    CustomerName,
    Region
)
SELECT DISTINCT
    CustomerID,
    CustomerName,
    Region
FROM dbo.Orders;
GO


------------------------------------------------------------
-- 5. Load unique products
------------------------------------------------------------

INSERT INTO dbo.Products
(
    ProductID,
    PartName,
    PartCategory,
    Manufacturer
)
SELECT DISTINCT
    ProductID,
    PartName,
    PartCategory,
    Manufacturer
FROM dbo.Orders;
GO


------------------------------------------------------------
-- 6. Load normalized order data
------------------------------------------------------------

INSERT INTO dbo.OrdersNormalized
(
    OrderID,
    OrderDate,
    CustomerID,
    ProductID,
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
    ProductID,
    Quantity,
    UnitPrice,
    ExpectedShippingDays,
    ShippingDays,
    RushOrder,
    Returned
FROM dbo.Orders;
GO


------------------------------------------------------------
-- 7. Validate normalized data
------------------------------------------------------------

SELECT COUNT(*) AS CustomerCount
FROM dbo.Customers;

SELECT COUNT(*) AS ProductCount
FROM dbo.Products;

SELECT COUNT(*) AS NormalizedOrderCount
FROM dbo.OrdersNormalized;

SELECT COUNT(*) AS OriginalOrderCount
FROM dbo.Orders;
GO


------------------------------------------------------------
-- 8. Example JOIN using normalized tables
------------------------------------------------------------

SELECT TOP 20
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    c.Region,
    p.PartName,
    p.PartCategory,
    p.Manufacturer,
    o.Quantity,
    o.UnitPrice,
    o.Quantity * o.UnitPrice AS Revenue
FROM dbo.OrdersNormalized AS o
INNER JOIN dbo.Customers AS c
    ON o.CustomerID = c.CustomerID
INNER JOIN dbo.Products AS p
    ON o.ProductID = p.ProductID
ORDER BY o.OrderDate;
GO