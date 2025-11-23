-- Check if SalesLT.Customer exists
IF EXISTS (
    SELECT * FROM sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE t.name = 'Customer' AND s.name = 'SalesLT'
)
BEGIN
    PRINT 'EXISTS';
END
ELSE
BEGIN
    PRINT 'NOT_EXISTS';
END
