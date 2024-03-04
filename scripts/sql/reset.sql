DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS products_to_orders CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;

CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(80) NOT NULL CHECK(first_name != ''),
  last_name VARCHAR(80) NOT NULL CHECK(last_name != ''),
  email VARCHAR(160) NOT NULL UNIQUE CHECK(email != ''),
  balance NUMERIC(13,2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0),
  height NUMERIC(3,2) CHECK (height > 0.3 AND height < 3),
  "weight" NUMERIC(5,2) CHECK ("weight" BETWEEN 0 AND 600),
  is_male BOOLEAN,
  comments SMALLINT NOT NULL DEFAULT 0 CHECK (comments >= 0),
  birthday DATE NOT NULL CHECK (birthday > '1930-01-01' AND birthday <= current_date ),
  created_at TIMESTAMP DEFAULT current_timestamp,
  updated_at TIMESTAMP DEFAULT current_timestamp
);
--
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users,
  status TEXT DEFAULT 'processing',
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);
--
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(300) NOT NULL,
  category VARCHAR(100),
  description TEXT,
  manufacturer TEXT,
  price NUMERIC(13,2) NOT NULL CHECK (price > 0),
  quantity INT NOT NULL CHECK (quantity >= 0),
  created_at TIMESTAMP DEFAULT current_timestamp,
  updated_at TIMESTAMP DEFAULT current_timestamp
);
--
CREATE TABLE products_to_orders (
  product_id INT NOT NULL REFERENCES products (id),
  order_id INT NOT NULL REFERENCES orders (id),
  quantity INT NOT NULL,
  PRIMARY KEY (product_id, order_id)
);
--
CREATE TABLE IF NOT EXISTS reviews (
  id SERIAL PRIMARY KEY,
  product_id int NOT NULL REFERENCES products,
  user_id int NOT NULL REFERENCES users,
  body text
);
--
CREATE TABLE IF NOT EXISTS ratings (
  id SERIAL PRIMARY KEY,
  review_id int NOT NULL UNIQUE 
  REFERENCES reviews ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED,
  rating numeric (2,1)
);
--
ALTER TABLE reviews
ADD COLUMN rating_id int NOT NULL UNIQUE 
REFERENCES ratings ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

