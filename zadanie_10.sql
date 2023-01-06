DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    firstName VARCHAR(100) NOT NULL,
    lastName VARcHAR(100) NOT NULL,
    salary DECIMAL(11, 2) NOT NULL,
    since DATE NOT NULL,
    id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(id)
);

INSERT
    INTO employee(firstName, lastName, salary, since)
    VALUES ("Jan", "Kowalski", 10000.00, "2010.01.01");

INSERT
    INTO employee(firstName, lastName, salary, since)
    VALUES ("Anna", "Nowak", 10000.00, "2000.01.01");

START TRANSACTION;
SET @now = CURDATE();
UPDATE employee
    SET salary = 
        CASE
            WHEN DATE_ADD(since, INTERVAL 20 YEAR) < @now THEN salary * 1.20
            ELSE salary * 1.10
        END;
COMMIT;
