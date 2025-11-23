--------------------------------------------------------
-- Seed lookup and master data
--------------------------------------------------------

-- Address
INSERT INTO SalesLT.Address (AddressLine1, City, StateProvince, CountryRegion, PostalCode)
VALUES
('123 Main St',      'Dallas',    'TX', 'USA', '75001'),
('456 Market Ave',   'Plano',     'TX', 'USA', '75024'),
('789 Sunset Blvd',  'Irving',    'TX', 'USA', '75039');

-- Product categories
INSERT INTO SalesLT.ProductCategory (ParentCategoryID, Name)
VALUES
(NULL, 'Bikes'),
(NULL, 'Accessories'),
(NULL, 'Clothing');

-- Products
INSERT INTO SalesLT.Product
    (ProductCategoryID, Name, ProductNumber, Color, StandardCost, ListPrice, Size, Weight)
VALUES
(1, 'Road Bike 100',   'RB-100', 'Red',   500.00, 900.00, 'M', 9.5),
(1, 'Mountain Bike X', 'MB-X',   'Blue',  650.00, 1200.00, 'L', 11.0),
(2, 'Bike Helmet',     'BH-10',  'Black',  15.00,  40.00,  NULL, NULL),
(3, 'Cycling Jersey',  'CJ-01',  'Green',  10.00,  35.00,  'L', NULL);

-- Customers
INSERT INTO SalesLT.Customer
    (FirstName, LastName, EmailAddress, Phone, BillingAddressID, ShippingAddressID)
VALUES
('Ali',   'Khan',     'ali.khan@example.com',     '555-1000', 1, 1),
('Sara',  'Ahmed',    'sara.ahmed@example.com',   '555-2000', 2, 2),
('John',  'Doe',      'john.doe@example.com',     '555-3000', 3, 3);

--------------------------------------------------------
-- Seed order data
--------------------------------------------------------

-- SalesOrderHeader
INSERT INTO SalesLT.SalesOrderHeader
    (CustomerID, ShipToAddressID, BillToAddressID, SubTotal, TaxAmt, Freight)
VALUES
(1, 1, 1, 1300.00, 100.00, 50.00),
(2, 2, 2,  75.00,   6.00,  5.00),
(3, 3, 3,  35.00,   3.00,  4.00);

-- SalesOrderDetail
INSERT INTO SalesLT.SalesOrderDetail
    (SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount)
VALUES
(1, 1, 1, 900.00, 0),
(1, 2, 1, 1200.00, 800.00),  -- effectively 400 for package deal
(2, 3, 1, 40.00,  5.00),
(3, 4, 1, 35.00,  0.00);
