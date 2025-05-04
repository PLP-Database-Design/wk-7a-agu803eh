- You are given the following table **ProductDetail**:

| OrderID | CustomerName  | Products                        |
|---------|---------------|---------------------------------|
| 101     | John Doe      | Laptop, Mouse                   |
| 102     | Jane Smith    | Tablet, Keyboard, Mouse         |
| 103     | Emily Clark   | Phone                           |


- In the table above, the **Products column** contains multiple values, which violates **1NF**.
- **Write an SQL query** to transform this table into **1NF**, ensuring that each row represents a single product for an order
Answer:
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product
FROM ProductDetail
CROSS JOIN (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) numbers
WHERE CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1
ORDER BY OrderID, Product;
```



### Question 2 Achieving 2NF (Second Normal Form) 🧩

- You are given the following table **OrderDetails**, which is already in **1NF** but still contains partial dependencies:

| OrderID | CustomerName  | Product      | Quantity |
|---------|---------------|--------------|----------|
| 101     | John Doe      | Laptop       | 2        |
| 101     | John Doe      | Mouse        | 1        |
| 102     | Jane Smith    | Tablet       | 3        |
| 102     | Jane Smith    | Keyboard     | 1        |
| 102     | Jane Smith    | Mouse        | 2        |
| 103     | Emily Clark   | Phone        | 1        |

- In the table above, the **CustomerName** column depends on **OrderID** (a partial dependency), which violates **2NF**. 

- Write an SQL query to transform this table into **2NF** by removing partial dependencies. Ensure that each non-key column fully depends on the entire primary key.
Answer:

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

CREATE TABLE OrderProducts (
  OrderID INT,
  Product VARCHAR(100),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
