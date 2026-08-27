CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID VARCHAR(10) NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    ProductID VARCHAR(10) NOT NULL,
    PartName VARCHAR(100) NOT NULL,
    PartCategory VARCHAR(50) NOT NULL,
    Manufacturer VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    ExpectedShippingDays INT NOT NULL,
    ShippingDays INT NOT NULL,
    RushOrder VARCHAR(3) NOT NULL,
    Returned VARCHAR(3) NOT NULL
);
GO