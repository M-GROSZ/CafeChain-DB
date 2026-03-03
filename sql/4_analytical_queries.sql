-- ######### Analytical Queries for Cafe Database #########


-- 1. Employees with more orders than the average
SELECT e.ID, e.First_Name || ' ' || e.Last_Name AS Employee_Name, COUNT(co.ID) AS Order_Count 
FROM Employee e
JOIN Customer_Order co ON co.Employee_ID = e.ID
GROUP BY e.ID, e.First_Name, e.Last_Name
HAVING COUNT(co.ID) > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt
        FROM Customer_Order
        GROUP BY Employee_ID
    )
);

-- 2. Top 3 customers with the highest spending
SELECT c.ID, c.First_Name, c.Last_Name, SUM(p.Amount) AS Total_Spent 
FROM Customer c
JOIN Customer_Order co ON co.Customer_ID = c.ID
JOIN Payment p ON p.Customer_Order_ID = co.ID
GROUP BY c.ID, c.First_Name, c.Last_Name
ORDER BY Total_Spent DESC
FETCH FIRST 3 ROWS ONLY;

-- 3. Average order value per cafe
SELECT cf.ID, cf.Name, AVG(p.Amount) AS Avg_Order_Value 
FROM Cafe cf
JOIN Employee e ON e.Cafe_ID = cf.ID
JOIN Customer_Order co ON co.Employee_ID = e.ID
JOIN Payment p ON p.Customer_Order_ID = co.ID
GROUP BY cf.ID, cf.Name;

-- 4. Categories more expensive than the global product average
SELECT c.Name, AVG(p.Price) AS Avg_Category_Price 
FROM Category c
JOIN Product p ON p.Category_ID = c.ID
GROUP BY c.Name
HAVING AVG(p.Price) > (SELECT AVG(Price) FROM Product);

-- 5. Customers who bought at least 2 different promotional products
SELECT c.ID, c.First_Name, c.Last_Name 
FROM Customer c
JOIN Customer_Order co ON co.Customer_ID = c.ID
JOIN Order_Item oi ON co.ID = oi.Customer_Order_ID
JOIN Product_Promotion pp ON oi.Product_ID = pp.Product_ID
GROUP BY c.ID, c.First_Name, c.Last_Name
HAVING COUNT(DISTINCT pp.Product_ID) >= 2;

-- 6. Products bought only once, and by a single customer
SELECT p.ID, p.Name 
FROM Product p
JOIN Order_Item oi ON p.ID = oi.Product_ID
JOIN Customer_Order co ON co.ID = oi.Customer_Order_ID
GROUP BY p.ID, p.Name
HAVING COUNT(*) = 1 AND COUNT(DISTINCT co.Customer_ID) = 1;

-- 7. Customers who bought 'Dubai Chocolate' (Correlated Subquery)
SELECT c.ID, c.First_Name, c.Last_Name 
FROM Customer c
WHERE EXISTS (
    SELECT 1
    FROM Customer_Order co
    JOIN Order_Item oi ON co.ID = oi.Customer_Order_ID
    JOIN Product p ON p.ID = oi.Product_ID
    WHERE co.Customer_ID = c.ID AND p.Name = 'Dubajska Czekolada'
);