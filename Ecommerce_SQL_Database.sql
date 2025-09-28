-- Select customers from GErmany, sorted by name
SELECT CustomerID, Name, Email
FROM Customers
WHERE Country = 'Germany'
ORDER BY Name ASC;

-- Total sales grouped by country
SELECT c.Country, SUM(o.TotalAmount) AS TotalSales
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Country
ORDER BY TotalSales DESC;

-- INNER JOIN: customers with their orders
SELECT c.Name, o.OrderID, o.TotalAmount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- LEFT JOIN: all customers (even if no orders)
SELECT c.Name, o.OrderID, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- RIGHT JOIN: all orders, show customer info if available
SELECT o.OrderID, c.Name, o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;
-- Customers who spent more than $1000 total
SELECT Name, CustomerID
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING SUM(TotalAmount) > 1000
);

-- Most expensive product purchased
SELECT ProductName, Price
FROM Products
WHERE Price = (SELECT MAX(Price) FROM Products);
-- Total revenue
SELECT SUM(TotalAmount) AS TotalRevenue
FROM Orders;

-- Average order value
SELECT AVG(TotalAmount) AS AvgOrderValue
FROM Orders;

-- Best-selling products
SELECT p.ProductName, SUM(od.Quantity) AS TotalSold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSold DESC;

-- Customer summary view
SELECT *
FROM (
    SELECT c.CustomerID, c.Name,
           COUNT(o.OrderID) AS TotalOrders,
           COALESCE(SUM(o.TotalAmount), 0) AS TotalSpent
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.Name
) AS summary
WHERE TotalSpent > 2000;
-- Index on frequently filtered/search columns
CREATE INDEX idx_customers_country ON Customers(Country);
CREATE INDEX idx_orders_customer ON Orders(CustomerID);
CREATE INDEX idx_orderdetails_product ON OrderDetails(ProductID);

-- Query now runs faster with index
SELECT Name, Email
FROM Customers
WHERE Country = 'Germany';

