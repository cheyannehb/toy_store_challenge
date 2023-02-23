--- Total Units By Store

SELECT store_id, SUM(units) AS total_units
FROM toys.sales
INNER JOIN toys.products
USING (product_id)
GROUP BY store_id
ORDER BY total_units DESC;

--- Most Units Sold By Category 

SELECT product_category, COUNT(units)
FROM toys.sales
INNER JOIN toys.products
USING (product_id)
GROUP BY product_category
ORDER BY COUNT(units) DESC;

--- Most Sold Toys Per Store By Category

SELECT store_id, COUNT(units) AS total_count_per_category, product_category
FROM toys.sales
INNER JOIN toys.products
USING (product_id)
GROUP BY store_id,product_category
ORDER BY product_category, total_count_per_category DESC;

--- Total Toys Sold Per Month

SELECT month(date), SUM(units) as total_units
FROM toys.sales
GROUP BY month(date);

--- Comparison of Profit Margins Between Toys

SELECT product_name, product_category, product_cost, 
product_price, product_price-product_cost AS profit_margin
FROM toys.products;

--- Most Profitable Toys

SELECT product_name, product_category, product_cost, 
product_price, ROUND((product_price-product_cost)/product_cost*100) AS profit_margin_percent
FROM toys.products
HAVING profit_margin_percent>100;

--- Lowest Profit Toys

SELECT product_name, product_category, product_cost, 
product_price, ROUND((product_price-product_cost)/product_cost*100) AS profit_margin_percent
FROM toys.products
HAVING profit_margin_percent<60;

--- Highest Profit Toys

SELECT product_name, product_category, product_cost, 
product_price, ROUND((product_price-product_cost)/product_cost*100) AS profit_margin_percent
FROM toys.products
HAVING profit_margin_percent>60;

--- Total Sales

SELECT SUM(units*product_price)
FROM toys.sales
INNER JOIN toys.products
ON products.product_id=sales.product_id;

--- Monthly Toy Sales Overall

SELECT month(date), SUM(units) as total_units_sold, SUM(units*product_price) AS total_sales
FROM toys.sales
INNER JOIN toys.products
ON products.product_id=sales.product_id
GROUP BY month(date);

--- Monthly Toy Sales By Category

SELECT month(date), product_category, 
SUM(units) as total_units_sold, SUM(units*product_price) AS total_sales
FROM toys.sales
INNER JOIN toys.products
ON products.product_id=sales.product_id
GROUP BY month(date), product_category;

--- Top Sales by Store And Category

SELECT store_name, product_category, SUM(units*product_price) AS total_sales
FROM toys.sales
INNER JOIN toys.products
ON products.product_id=sales.product_id
INNER JOIN toys.stores
ON sales.store_id=stores.store_id
GROUP BY store_name, product_category
ORDER BY total_sales DESC;

--- Comparison of In Stock Items vs Units Sold By Store

SELECT inventory.store_id, inventory.product_id, stock_on_hand, units
FROM toys.inventory
INNER JOIN toys.sales
ON inventory.store_id=sales.store_id
WHERE stock_on_hand > 15;

--- Total Products Out Of Stock

SELECT COUNT(stock_on_hand) AS total_out_of_stock
FROM toys.inventory
WHERE stock_on_hand = 0;

--- Total Products Out Of Stock By Store ID

SELECT product_id, COUNT(stock_on_hand) AS total_out_of_stock
FROM toys.inventory
WHERE stock_on_hand = 0
GROUP BY product_id 
ORDER BY product_id ASC;

--- Breakdown of Units of Each Toys Sold

SELECT product_id, SUM(units)
FROM toys.sales
GROUP BY product_id
ORDER BY product_id;

--- Quantity of Each Toy On Hand

SELECT product_id, SUM(stock_on_hand)
FROM toys.inventory
GROUP BY product_id;

--- Total Value of Each Product In Stock

SELECT sub.product_id, product_price*sub.total_stock AS product_value
FROM toys.products,
(SELECT product_id, SUM(stock_on_hand) AS total_stock
FROM toys.inventory
GROUP BY product_id) AS sub
WHERE products.product_id=sub.product_id;

--- Total Inventory Value

SELECT SUM(product_price*sub.total_stock) AS total_inventory_value
FROM toys.products,
(SELECT product_id, SUM(stock_on_hand) AS total_stock
FROM toys.inventory
GROUP BY product_id) AS sub
WHERE products.product_id=sub.product_id;