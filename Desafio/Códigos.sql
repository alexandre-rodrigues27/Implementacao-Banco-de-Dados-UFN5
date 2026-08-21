-- 1)

SELECT p.ProductName AS Produto, s.CompanyName AS Fornecedor, c.CategoryName AS Categoria, p.UnitPrice AS PrecoUnitario, p.UnitsInStock AS QuantidadeEstoque
FROM dbo.Products p
INNER JOIN dbo.Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN dbo.Categories c ON p.CategoryID = c.CategoryID;


-- 2) 

SELECT p.ProductName AS Produto, s.CompanyName AS Fornecedor, c.CategoryName AS Categoria, p.UnitPrice AS PrecoUnitario, p.UnitsInStock AS QuantidadeEstoque
FROM dbo.Products p
INNER JOIN dbo.Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN dbo.Categories c ON p.CategoryID = c.CategoryID
WHERE p.UnitsInStock > 0 AND p.Discontinued = 0;


-- 3)

SELECT e.FirstName + ' ' + e.LastName AS Nome, 
	(SELECT COUNT(o.OrderID) FROM dbo.Orders o WHERE o.EmployeeID = e.EmployeeID) AS TotalVendas
FROM dbo.Employees e;


-- 4)

SELECT e.FirstName + ' ' + e.LastName AS Nome, 
    (SELECT COUNT(o.OrderID) FROM dbo.Orders o WHERE o.EmployeeID = e.EmployeeID) AS TotalVendas
FROM dbo.Employees e
WHERE (SELECT COUNT(o.OrderID) FROM dbo.Orders o WHERE o.EmployeeID = e.EmployeeID) >= 100;

-- 5)

SELECT e.FirstName + ' ' + e.LastName AS Nome,
    (SELECT COUNT(et.TerritoryID) FROM dbo.EmployeeTerritories et WHERE et.EmployeeID = e.EmployeeID) AS Territorios
FROM dbo.Employees e;

-- 6)

SELECT o.OrderID AS Pedido,
    (SELECT SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))FROM dbo.[Order Details] od WHERE od.OrderID = o.OrderID) AS ValorTotal
FROM dbo.Orders o
ORDER BY ValorTotal DESC;

-- 7)

SELECT od.OrderID AS IDPedido, p.ProductName AS NomeProduto, p.UnitPrice AS PrecoLista, od.UnitPrice AS PrecoEfetivado
FROM dbo.[Order Details] od
INNER JOIN dbo.Products p ON od.ProductID = p.ProductID
WHERE od.UnitPrice < p.UnitPrice;
