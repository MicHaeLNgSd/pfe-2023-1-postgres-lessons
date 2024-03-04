CREATE TABLE a (
  txt TEXT,
  num INT
);
--
CREATE TABLE B (
  txt TEXT
);
--
INSERT INTO a
(txt, num)
VALUES
('AAA', 5),
('AAB', 52),
('AAC', 10),
('ABC', 12323423),
('BAA', 214334),
('BBB', 1),
('BBC', 3),
('CBB', 2),
('CCC', 4);
--
INSERT INTO b
(txt)
VALUES
('AAA'),
('ABB'),
('AAC'),
('CAC'),
('CCC');
--
SELECT * FROM a;
SELECT * FROM b;
-- Декартовий добуток - всі рядки з а множатся на всі рядки з b
SELECT * FROM a, b;
-- UNION - об'єднання двух запитів (всі унацільні значення)
-- кількість і типи даних стовпчиків у запитах мають збігатися
SELECT txt FROM a
UNION
SELECT txt FROM b;
-- INTERSECT - перетин (значеня які є у обох запитах)
SELECT txt FROM a
INTERSECT
SELECT txt FROM b;
-- EXCEPT - віднімання (значення з першого запиту яких немає у другому запиті)
SELECT txt FROM a
EXCEPT
SELECT txt FROM b;
--
SELECT txt FROM b
EXCEPT
SELECT txt FROM a;
-- дізнатися id всіх користувачів, які робили замовлення
SELECT id FROM users
INTERSECT
SELECT user_id FROM orders;
-- дізнатися id всіх користувачів, які НЕ робили замовлення
SELECT id FROM users
EXCEPT
SELECT user_id FROM orders;
--
SELECT *
FROM a, b
WHERE a.txt = b.txt;

-- дізнатися email всіх користувачів, які робили замовлення
SELECT email
FROM users, orders
WHERE users.id = orders.user_id
GROUP BY email;
-- JOIN - з'єдання таблиць
SELECT email
FROM users
JOIN orders ON users.id = orders.user_id
GROUP BY email;
-- зв'язок декількох таблиць
SELECT u.id, p.*
FROM orders o
JOIN products_to_orders pto ON pto.order_id = o.id
JOIN products p ON pto.product_id = p.id
JOIN users u ON o.user_id = u.id
WHERE u.id = 1;
-- Типи джойнів
-- CROSS JOIN - декартовий добуток
SELECT *
FROM users
CROSS JOIN orders;
--
SELECT * FROM users, orders;
-- INNER JOIN = JOIN - шукає дані які є обох таблицях одночасно
SELECT email
FROM users
INNER JOIN orders ON users.id = orders.user_id
GROUP BY email;
-- OUTER JOINS - має декілька варіацій
-- діляться на ліві, праві та повні джойни
-- LEFT JOIN - лівий джойн, бере всі записи які дає INNER JOIN 
-- а потім всі дані з лівої таблиці
SELECT *
FROM 
users -- ліва таблиця
LEFT JOIN 
orders -- права таблиця
ON users.id = orders.user_id;
-- RIGHT JOIN - бере всі записи які дає INNER JOIN 
-- а потім всі дані з правої таблиці
SELECT users.*, orders.*
FROM 
orders -- ліва таблиця
RIGHT JOIN 
users -- права таблиця
ON users.id = orders.user_id;
-- FULL JOIN - бере всі записи які дає INNER JOIN 
-- а потім всі дані з лівої таблиці
-- а потім всі дані з правої таблиці
SELECT users.*, orders.*
FROM 
orders -- ліва таблиця
FULL JOIN 
users -- права таблиця
ON users.id = orders.user_id;
-- Інклюзивні та ексклюзивні джойни
-- за замовчанням джойни інклюзивні
-- продукти які відсутні у будь-яком замовленні
SELECT p.*
FROM products p
LEFT JOIN products_to_orders pto ON pto.product_id = p.id
-- умова ексклюзивності
WHERE pto.product_id IS NULL;
-- користувачі які не робили замовлень
SELECT u.*
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE o.user_id IS NULL;
-- всі продукти у яких є відгуки
SELECT p.*
FROM products p
JOIN reviews r ON r.product_id = p.id
GROUP BY p.id;
-- всі продукти у яких немає відгуків
SELECT p.* , r.body
FROM reviews r
RIGHT JOIN products p ON r.product_id = p.id
WHERE r.product_id IS NULL;
-- вартість п'ятого замовлення
SELECT sum( price * pto.quantity )
FROM products_to_orders pto
JOIN products p ON p.id = pto.product_id
WHERE order_id = 5;
/*
  5 * 100 + 2 * 35 + 3 * 3 = 579
*/
-- вартість кожного замовлення
SELECT order_id, sum( price * pto.quantity )
FROM products_to_orders pto
JOIN products p ON p.id = pto.product_id
GROUP BY order_id;
-- скалярний підзапит
SELECT 4 * 3;
--
SELECT *
FROM users
WHERE id = (SELECT 4 * 3);