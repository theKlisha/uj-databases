DROP TABLE IF EXISTS deposit;
DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS client;

CREATE TABLE client(
    id INT NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE account(
    id INT NOT NULL AUTO_INCREMENT,
    number VARCHAR(26) NOT NULL,
    clientId INT NOT NULL,
    balance DECIMAL(14, 2) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(clientId) REFERENCES client(id)
);

CREATE TABLE transaction(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(14, 2) NOT NULL,
    fromAccountId INT NOT NULL,
    toAccountId INT NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE deposit(
    id INT NOT NULL AUTO_INCREMENT,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(14, 2) NOT NULL,
    accountId INT NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO client(firstName, lastName) VALUES("Jan", "Kowalski");
INSERT INTO account(clientId, number, balance) VALUES(1, "00000000000000000000000A", 100.00);
INSERT INTO account(clientId, number, balance) VALUES(1, "00000000000000000000000B", 0.00);

START TRANSACTION;
UPDATE account SET balance = balance - 3.14 WHERE account.id = 1;
UPDATE account SET balance = balance + 3.14 WHERE account.id = 2;
INSERT INTO transaction(amount, fromAccountId, toAccountId) VALUES (3.14, 1, 2);
COMMIT;
