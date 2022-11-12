DROP TABLE product_purchase;
DROP TABLE purchase;
DROP TABLE receipt;
DROP TABLE invoice;
DROP TABLE product;
DROP TABLE employee;

CREATE TABLE employee(
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    phone VARCHAR(50),
    job_title VARCHAR(50) NOT NULL,
    pesel CHAR(11) NOT NULL,
    address VARCHAR(100),
    id INT NOT NULL AUTO_INCREMENT AUTO_INCREMENT,
    PRIMARY KEY(id)
);

CREATE TABLE product(
    name VARCHAR(50) NOT NULL,
    value DECIMAL(11,2),
    id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id)
);

CREATE TABLE receipt(
    id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id)
);

CREATE TABLE invoice(
    number VARCHAR(50) NOT NULL,
    seller VARCHAR(50) NOT NULL,
    buyer VARCHAR(50) NOT NULL,
    id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id)
);

CREATE TABLE purchase(
    value DECIMAL(11,2),
    invoice_id INT,
    receipt_id INT,
    employee_id INT NOT NULL,
    id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id),
    FOREIGN KEY(receipt_id) REFERENCES receipt(id),
    FOREIGN KEY(invoice_id) REFERENCES invoice(id),
    FOREIGN KEY(employee_id) REFERENCES employee(id)
);

CREATE TABLE product_purchase(
    purchase_id INT NOT NULL,
    product_id INT NOT NULL,
    id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id),
    FOREIGN KEY(purchase_id) REFERENCES purchase(id),
    FOREIGN KEY(product_id) REFERENCES product(id)
);

INSERT INTO employee(first_name, last_name, email, phone, job_title, pesel, address)
    VALUES ('Adam', 'Kowalski', 'adam.kowalski@foo.bar', '+48 112 358 132', 'Sprzedawca', '92758162853', 'Szeroka 2/10, 21-370 Wielka Sicz');

-- -------------------------------------------------------------------------------------------------------------------------------
-- Modyfikacja tabel

DROP TABLE party;

CREATE TABLE party(
    name VARCHAR(255),
    address VARCHAR(255),
    nip CHAR(10) NOT NULL,
    id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id)
);


ALTER TABLE product_purchase ADD COLUMN value DECIMAL(11,2) NOT NULL;
ALTER TABLE product_purchase ADD COLUMN count INT NOT NULL;

ALTER TABLE invoice ADD COLUMN seller_id INT NOT NULL;
ALTER TABLE invoice ADD COLUMN buyer_id INT NOT NULL;
ALTER TABLE invoice ADD CONSTRAINT seller_id FOREIGN KEY(seller_id) REFERENCES party(id);
ALTER TABLE invoice ADD CONSTRAINT buyer_id  FOREIGN KEY(buyer_id) REFERENCES party(id);
ALTER TABLE invoice DROP COLUMN seller;
ALTER TABLE invoice DROP COLUMN buyer;

ALTER TABLE product ADD COLUMN availability INT NOT NULL;
ALTER TABLE product ADD COLUMN unit varchar(50) NOT NULL;

-- -------------------------------------------------------------------------------------------------------------------------------
-- Dodanie towarów oraz sprzedawców

INSERT INTO party(name, address, nip)
    VALUES('Sklep papierniczy', 'Krakow ul. Starowislna 42', '0000000000');
INSERT INTO party(name, address, nip)
    VALUES('"Alfabet" Piotr Nowak', 'Krakow ul. Inna 37', '3333333333');
INSERT INTO party(name, address, nip)
    VALUES('"Abc" Jan Kowalski', 'Grudziadz ul. Jakas 23', '2343423434');

INSERT INTO product(name, value, unit, availability)
    VALUES('pioro wieczne "pisz"', 100, 'szt.', 0);
INSERT INTO product(name, value, unit, availability)
    VALUES('zeszyt 60 kartek', 200, 'szt.', 0);
INSERT INTO product(name, value, unit, availability)
    VALUES('oluwek cmp 23', 10, 'szt.', 0);
INSERT INTO product(name, value, unit, availability)
    VALUES('dlugopis wl 67', 20, 'szt.', 0);

-- -------------------------------------------------------------------------------------------------------------------------------
-- Faktura zakupu numer 3

INSERT INTO invoice(number, seller_id, buyer_id)
    VALUES('3', 2, 1);
INSERT INTO purchase(value, invoice_id, employee_id)
    VALUES(5000, 1, 1);
INSERT INTO product_purchase(purchase_id, product_id, value, count)
    VALUES(1, 1, 100, 30);
INSERT INTO product_purchase(purchase_id, product_id, value, count)
    VALUES(1, 2, 200, 10);
UPDATE product
    SET availability=30
    WHERE id=1;
UPDATE product
    SET availability=10
    WHERE id=2;

-- -------------------------------------------------------------------------------------------------------------------------------
-- Faktura zakupu numer 23434

INSERT INTO invoice(number, seller_id, buyer_id)
    VALUES('23434', 3, 1);
INSERT INTO purchase(value, invoice_id, employee_id)
    VALUES(500, 2, 1);
INSERT INTO product_purchase(purchase_id, product_id, value, count)
    VALUES(2, 3, 10, 40);
INSERT INTO product_purchase(purchase_id, product_id, value, count)
    VALUES(2, 4, 20, 5);
UPDATE product
    SET availability=40
    WHERE id=3;
UPDATE product
    SET availability=5
    WHERE id=4;

-- -------------------------------------------------------------------------------------------------------------------------------
\! echo '1. Wszystkie dane ze wszystkich tabel';
SELECT * FROM employee;
SELECT * FROM party;
SELECT * FROM product;
SELECT * FROM invoice;
SELECT * FROM receipt;
SELECT * FROM purchase;
SELECT * FROM product_purchase;

\! echo '2. Wszystkie firmy, których nazwa to: "Abc"';
SELECT * FROM party
    WHERE party.name LIKE '%Abc%';

\! echo '3. Nazwy wszystkich firm w kolejności alfabetycznej';
SELECT * FROM party
    ORDER BY party.name ASC;

\! echo '4. Trzy produkty, których liczba w magazynie przekracza 30';
SELECT * FROM product
    WHERE product.availability>30
    ORDER BY product.availability DESC
    LIMIT 3;

\! echo '5. Fakturę zakupu na najwyższą kwotę';
SELECT * FROM purchase
    JOIN invoice ON purchase.invoice_id=invoice.id
    JOIN party seller ON invoice.seller_id=seller.id
    WHERE purchase.invoice_id IS NOT NULL AND invoice.buyer_id=1
    ORDER BY purchase.value DESC
    LIMIT 1;

\! echo '6. Wszystkie zakupione produkty bez dwóch najdroższych';
SELECT * FROM product_purchase
    ORDER BY product_purchase.value DESC
    LIMIT 18446744073709551615 OFFSET 2;

\! echo '7. Nazwę produktu, liczbę sztuk, cenę oraz numer faktury, na której się znajduje';
SELECT product.name, product_purchase.count, product.value, invoice.number FROM product_purchase
    JOIN product ON product_purchase.product_id=product.id
    JOIN purchase ON product_purchase.purchase_id=purchase.id
    JOIN invoice ON purchase.invoice_id=invoice.id;
