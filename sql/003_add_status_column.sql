-- Add a Status column if not already present
IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE Name = 'Status'
      AND Object_ID = Object_ID('SalesLT.SalesOrderHeader')
)
BEGIN
    ALTER TABLE SalesLT.SalesOrderHeader
    ADD Status VARCHAR(20) NULL;

    PRINT 'Status column added';
END
ELSE
BEGIN
    PRINT 'Status column already exists, skipping';
END
