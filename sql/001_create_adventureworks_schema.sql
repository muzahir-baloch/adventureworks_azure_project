-- Create schema
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'SalesLT')
    EXEC('CREATE SCHEMA SalesLT');
GO

--------------------------------------------------------
-- Address
--------------------------------------------------------
IF OBJECT_ID('SalesLT.Address', 'U') IS NOT NULL
    DROP TABLE SalesLT.Address;
GO

CREATE TABLE SalesLT.Address (
    AddressID       INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    AddressLine1    NVARCHAR(60)      NOT NULL,
    AddressLine2    NVARCHAR(60)      NULL,
    City            NVARCHAR(30)      NOT NULL,
    StateProvince   NVARCHAR(50)      NOT NULL,
    CountryRegion   NVARCHAR(50)      NOT NULL,
    PostalCode      NVARCHAR(15)      NOT NULL,
    ModifiedDate    DATETIME2         NOT NULL CONSTRAINT DF_Address_ModifiedDate DEFAULT (SYSUTCDATETIME())
);
GO

--------------------------------------------------------
-- Customer
--------------------------------------------------------
IF OBJECT_ID('SalesLT.Customer', 'U') IS NOT NULL
    DROP TABLE SalesLT.Customer;
GO

CREATE TABLE SalesLT.Customer (
    CustomerID          INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FirstName           NVARCHAR(50)      NOT NULL,
    LastName            NVARCHAR(50)      NOT NULL,
    EmailAddress        NVARCHAR(100)     NULL,
    Phone               NVARCHAR(25)      NULL,
    BillingAddressID    INT               NULL,
    ShippingAddressID   INT               NULL,
    ModifiedDate        DATETIME2         NOT NULL CONSTRAINT DF_Customer_ModifiedDate DEFAULT (SYSUTCDATETIME())
);
GO

ALTER TABLE SalesLT.Customer
ADD CONSTRAINT FK_Customer_BillingAddress
    FOREIGN KEY (BillingAddressID) REFERENCES SalesLT.Address(AddressID);
GO

ALTER TABLE SalesLT.Customer
ADD CONSTRAINT FK_Customer_ShippingAddress
    FOREIGN KEY (ShippingAddressID) REFERENCES SalesLT.Address(AddressID);
GO

--------------------------------------------------------
-- ProductCategory
--------------------------------------------------------
IF OBJECT_ID('SalesLT.ProductCategory', 'U') IS NOT NULL
    DROP TABLE SalesLT.ProductCategory;
GO

CREATE TABLE SalesLT.ProductCategory (
    ProductCategoryID   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ParentCategoryID    INT               NULL,
    Name                NVARCHAR(50)      NOT NULL,
    ModifiedDate        DATETIME2         NOT NULL CONSTRAINT DF_ProductCategory_ModifiedDate DEFAULT (SYSUTCDATETIME())
);
GO

ALTER TABLE SalesLT.ProductCategory
ADD CONSTRAINT FK_ProductCategory_Parent
    FOREIGN KEY (ParentCategoryID) REFERENCES SalesLT.ProductCategory(ProductCategoryID);
GO

--------------------------------------------------------
-- Product
--------------------------------------------------------
IF OBJECT_ID('SalesLT.Product', 'U') IS NOT NULL
    DROP TABLE SalesLT.Product;
GO

CREATE TABLE SalesLT.Product (
    ProductID           INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductCategoryID   INT               NULL,
    Name                NVARCHAR(100)     NOT NULL,
    ProductNumber       NVARCHAR(25)      NOT NULL,
    Color               NVARCHAR(15)      NULL,
    StandardCost        DECIMAL(19,4)     NULL,
    ListPrice           DECIMAL(19,4)     NULL,
    Size                NVARCHAR(10)      NULL,
    Weight              DECIMAL(10,2)     NULL,
    ModifiedDate        DATETIME2         NOT NULL CONSTRAINT DF_Product_ModifiedDate DEFAULT (SYSUTCDATETIME())
);
GO

ALTER TABLE SalesLT.Product
ADD CONSTRAINT FK_Product_ProductCategory
    FOREIGN KEY (ProductCategoryID) REFERENCES SalesLT.ProductCategory(ProductCategoryID);
GO

--------------------------------------------------------
-- SalesOrderHeader
--------------------------------------------------------
IF OBJECT_ID('SalesLT.SalesOrderHeader', 'U') IS NOT NULL
    DROP TABLE SalesLT.SalesOrderHeader;
GO

CREATE TABLE SalesLT.SalesOrderHeader (
    SalesOrderID        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrderDate           DATETIME2         NOT NULL CONSTRAINT DF_SOH_OrderDate DEFAULT (SYSUTCDATETIME()),
    CustomerID          INT               NOT NULL,
    ShipToAddressID     INT               NULL,
    BillToAddressID     INT               NULL,
    SubTotal            DECIMAL(19,4)     NOT NULL CONSTRAINT DF_SOH_SubTotal DEFAULT (0),
    TaxAmt              DECIMAL(19,4)     NOT NULL CONSTRAINT DF_SOH_TaxAmt DEFAULT (0),
    Freight             DECIMAL(19,4)     NOT NULL CONSTRAINT DF_SOH_Freight DEFAULT (0),
    TotalDue            AS (SubTotal + TaxAmt + Freight),
    ModifiedDate        DATETIME2         NOT NULL CONSTRAINT DF_SOH_ModifiedDate DEFAULT (SYSUTCDATETIME())
);
GO

ALTER TABLE SalesLT.SalesOrderHeader
ADD CONSTRAINT FK_SOH_Customer
    FOREIGN KEY (CustomerID) REFERENCES SalesLT.Customer(CustomerID);
GO

ALTER TABLE SalesLT.SalesOrderHeader
ADD CONSTRAINT FK_SOH_ShipToAddress
    FOREIGN KEY (ShipToAddressID) REFERENCES SalesLT.Address(AddressID);
GO

ALTER TABLE SalesLT.SalesOrderHeader
ADD CONSTRAINT FK_SOH_BillToAddress
    FOREIGN KEY (BillToAddressID) REFERENCES SalesLT.Address(AddressID);
GO

--------------------------------------------------------
-- SalesOrderDetail
--------------------------------------------------------
IF OBJECT_ID('SalesLT.SalesOrderDetail', 'U') IS NOT NULL
    DROP TABLE SalesLT.SalesOrderDetail;
GO

CREATE TABLE SalesLT.SalesOrderDetail (
    SalesOrderDetailID  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SalesOrderID        INT               NOT NULL,
    ProductID           INT               NOT NULL,
    OrderQty            SMALLINT          NOT NULL,
    UnitPrice           DECIMAL(19,4)     NOT NULL,
    UnitPriceDiscount   DECIMAL(19,4)     NOT NULL CONSTRAINT DF_SOD_Discount DEFAULT (0),
    LineTotal           AS ((UnitPrice - UnitPriceDiscount) * OrderQty),
    ModifiedDate        DATETIME2         NOT NULL CONSTRAINT DF_SOD_ModifiedDate DEFAULT (SYSUTCDATETIME())
);
GO

ALTER TABLE SalesLT.SalesOrderDetail
ADD CONSTRAINT FK_SOD_SOH
    FOREIGN KEY (SalesOrderID) REFERENCES SalesLT.SalesOrderHeader(SalesOrderID);
GO

ALTER TABLE SalesLT.SalesOrderDetail
ADD CONSTRAINT FK_SOD_Product
    FOREIGN KEY (ProductID) REFERENCES SalesLT.Product(ProductID);
GO
