--Дані про товари (назва, ціна, кількість замовленго товару, категорія, виробник) у конкретному замовленні
SELECT p.name, p.price, p.quantity, p.category, p.manufacturer
FROM products p
JOIN products_to_orders pto ON p.id = pto.product_id
WHERE pto.order_id = 2;

--Кількість куплених товарів певної категорії у конкретному замовлені
SELECT p.category, count(p.id)
FROM products p
JOIN products_to_orders pto ON p.id = pto.product_id
WHERE pto.order_id = 2
GROUP BY p.category;

--Кількість коментарів певного користувача з рейтингом більше 3. Зробити сортування по рейтингу від більшого до меншого
SELECT u.first_name || u.last_name as full_name, count(rat.rating)
FROM users u
JOIN reviews rev ON u.id = rev.user_id
JOIN ratings rat ON rat.id = rev.rating_id
WHERE u.id = 2 AND rat.rating > 3
GROUP BY full_name;

--Кожне замовлення певного користувача зі статусом 'finished' та його загальна ціна
SELECT o.id order_id, o.status, sum(p.price * pto.quantity) full_price
FROM orders o
JOIN products_to_orders pto ON o.id = pto.order_id
JOIN products p ON p.id = pto.product_id
WHERE o.status SIMILAR TO 'finished' AND o.user_id = 3
GROUP BY o.id

--* Дані про найпопулярніший товар (товар який є в найбільшій кількості унікальних замовлень)
SELECT p.*, count(pto.product_id) buying_quantity
FROM products p
JOIN products_to_orders pto ON p.id = pto.product_id
GROUP BY p.id
ORDER BY buying_quantity DESC
LIMIT 1

--* Всі замовлення, кінцева вартість яких більше за середню вартість замовлення (підзапити)
WITH orders_with_full_price as (
  SELECT o.*, sum(p.price * pto.quantity) full_price
  FROM orders o
  JOIN products_to_orders pto ON o.id = pto.order_id
  JOIN products p ON p.id = pto.product_id
  GROUP BY o.id
),
average_order_price as (
  SELECT avg(full_price) avg_price
  FROM orders_with_full_price
)
SELECT o_fp.*
FROM orders_with_full_price o_fp, average_order_price avg_op
WHERE o_fp.full_price > avg_op.avg_price
ORDER BY o_fp.full_price