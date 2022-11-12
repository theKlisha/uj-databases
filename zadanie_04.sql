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
    VALUES ("Adam", "Kowalski", "adam.kowalski@foo.bar", "+48 112 358 132", "Sprzedawca", "92758162853", "Szeroka 2/10, 21-370 Wielka Sicz");

INSERT INTO product(name, value)
    VALUES("blok techniczny", 6.90);
INSERT INTO product(name, value)
    VALUES("klej do papieru", 6.16);
INSERT INTO product(name, value)
    VALUES("zeszyt", 3.73);
INSERT INTO product(name, value)
    VALUES("zeszyt", 5.22);
INSERT INTO product(name, value)
    VALUES("tasma klejaca przezroczysta", 3.20);
INSERT INTO product(name, value)
    VALUES("tasma klejaca dwustronna", 8.38);

INSERT INTO invoice(buyer, seller, number)
    VALUES("Sklep Papierniczy", "Abc","G481C/09/2022");
INSERT INTO purchase(value, invoice_id, employee_id)
    VALUES(2412.45, 1, 1);

INSERT INTO invoice(buyer, seller, number)
    VALUES("Sklep Papierniczy", "Abc", "G9AB0/09/2022");
INSERT INTO purchase(value, invoice_id, employee_id)
    VALUES(670.21, 2, 1);

INSERT INTO invoice(buyer, seller, number)
    VALUES("Baz", "Sklep Papierniczy", "10A30/10/2022");
INSERT INTO purchase(value, invoice_id, employee_id)
    VALUES(1050.00, 3, 1);

INSERT INTO receipt() VALUES();
INSERT INTO purchase(value, receipt_id, employee_id)
    VALUES(10.50, 1, 1);

INSERT INTO receipt() VALUES();
INSERT INTO purchase(value, receipt_id, employee_id)
    VALUES(60.21, 2, 1);

-- 1. Wszystkie produkty, których nazwa to 'zeszyt'
SELECT * FROM product WHERE product.name="zeszyt";

-- 2. Wszystkie faktury (dokumenty sprzedaży/zakupu), których wartość jest nie mniejsza niż 1000 PLN,
SELECT * FROM purchase WHERE purchase.invoice_id IS NOT NULL AND purchase.value > 1000.00;

-- 3. 10 najdroższych zakupów.
SELECT * FROM purchase ORDER BY purchase.value DESC LIMIT 10;

-- 4. Wszystkie faktury od dostawcy o nazwie Abc.
SELECT * FROM invoice WHERE invoice.seller = "Abc";

