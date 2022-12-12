DROP TABLE IF EXISTS flightCrew;
DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS flight;
DROP TABLE IF EXISTS aircraft;
DROP TABLE IF EXISTS connection;
DROP TABLE IF EXISTS airport;
DROP TABLE IF EXISTS passanger;
DROP TABLE IF EXISTS employee;

-- --------------------------------------------------------------------------------------------------------------------

CREATE TABLE employee(
    id INT NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE passanger(
    id INT NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE airport(
    id INT NOT NULL AUTO_INCREMENT,
    iataCode VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE connection(
    id INT NOT NULL AUTO_INCREMENT,
    fromId INT NOT NULL,
    toId INT NOT NULL,
    lenght INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(fromId) REFERENCES airport(id),
    FOREIGN KEY(toId) REFERENCES airport(id)
);

CREATE TABLE aircraft(
    id INT NOT NULL AUTO_INCREMENT,
    passangerCapacity INT NOT NULL,
    cargoCapacity INT NOT NULL,
    maxRange INT NOT NULL,
    removed INT NOT NULL DEFAULT 0,
    PRIMARY KEY(id)
);

CREATE TABLE flight(
    id INT NOT NULL AUTO_INCREMENT,
    number VARCHAR(255),
    canceled INT NOT NULL DEFAULT 0,
    takeofDate DATE NOT NULL,
    landingDate DATE NOT NULL,
    connectionId INT NOT NULL,
    removed INT NOT NULL DEFAULT 0,
    aircraftId INT,
    PRIMARY KEY(id),
    FOREIGN KEY(connectionId) REFERENCES connection(id),
    FOREIGN KEY(aircraftId) REFERENCES aircraft(id)
);

CREATE TABLE ticket(
    id INT NOT NULL AUTO_INCREMENT,
    flightId INT NOT NULL,
    passangerId INT NOT NULL,
    purchaseDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    class VARCHAR(255),
    PRIMARY KEY(id),
    FOREIGN KEY(flightId) REFERENCES flight(id),
    FOREIGN KEY(passangerId) REFERENCES passanger(id)
);

create TABLE flightCrew(
    role VARCHAR(255),
    id INT NOT NULL AUTO_INCREMENT,
    flightId INT NOT NULL,
    employeeId INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(flightId) REFERENCES flight(id),
    FOREIGN KEY(employeeId) REFERENCES employee(id)
);

-- --------------------------------------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS passangersForFlight;

-- --------------------------------------------------------------------------------------------------------------------

DELIMITER //
CREATE FUNCTION passangersForFlight(flightId INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
--     SELECT flight.number INTO @var FROM flight WHERE flight.id = flightId;
    SELECT GROUP_CONCAT(CONCAT(firstName, " ", lastName, " (", class, ")") SEPARATOR ', ')
        INTO @returnValue
        FROM ticket
        INNER JOIN passanger ON passanger.id = ticket.passangerId
        INNER JOIN flight ON flight.id = ticket.flightId
        WHERE ticket.flightId = flightId;
        -- GROUP BY ticket.flightId;

    RETURN @returnValue;
END //
DELIMITER ;

-- --------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS insertAircraft;
DROP PROCEDURE IF EXISTS insertPassanger;
DROP PROCEDURE IF EXISTS insertEmployee;
DROP PROCEDURE IF EXISTS insertFlight;
DROP PROCEDURE IF EXISTS assignAircraft;

-- --------------------------------------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE insertAircraft(IN passangerCapacity INT, IN cargoCapacity INT, IN maxRange INT)
BEGIN
    INSERT
        INTO aircraft(passangerCapacity, cargoCapacity, maxRange)
        VALUES (passangerCapacity, cargoCapacity, maxRange);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insertPassanger(IN firstName VARCHAR(255), IN lastName VARCHAR(255))
BEGIN
    INSERT
        INTO passanger(firstName, lastName)
        VALUES (firstName, lastName);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insertEmployee(IN firstName VARCHAR(255), IN lastName VARCHAR(255))
BEGIN
    INSERT
        INTO employee(firstName, lastName)
        VALUES (firstName, lastName);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insertFlight(IN number VARCHAR(255), IN fromAirport VARCHAR(255), IN toAirport VARCHAR(255), IN takeofDate DATE, IN landingDate DATE)
BEGIN
    DECLARE connectionId INT;
    SELECT connection.id
        INTO connectionId
        FROM connection
        INNER JOIN airport
            AS fromAirport
            ON connection.fromId = fromAirport.id
        INNER JOIN airport
            AS toAirport
            ON connection.toId = toAirport.id
        WHERE fromAirport.iataCode = fromAirport AND toAirport.iataCode = toAirport;
    INSERT
        INTO flight(number, takeofDate, landingDate, connectionId)
        VALUES (number, takeofDate, landingDate, connectionId);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE assignAircraft(IN flightNumber VARCHAR(255), IN aircraftId INT)
BEGIN
    DECLARE flightLength INT;
    DECLARE maxRange INT;

    SELECT connection.lenght
        INTO flightLength
        FROM flight
        INNER JOIN connection ON connection.id = flight.connectionId
        WHERE flight.number = flightNumber;

    SELECT aircraft.maxRange
        INTO maxRange
        FROM aircraft
        WHERE aircraft.id = aircraftId;

    IF flightLength < maxRange THEN
        UPDATE flight SET flight.aircraftId = aircraftId
            WHERE flight.number = flightNumber;
    ELSE
        SELECT "ERROR: flight lenght is higher than range of the aircraft";
    END IF;
END //
DELIMITER ;

INSERT INTO airport(iataCode, city, country) VALUES("KRK", "Krakow", "Poland");
INSERT INTO airport(iataCode, city, country) VALUES("LHR", "London", "United Kingdom");
INSERT INTO airport(iataCode, city, country) VALUES("LAX", "Los Angeles", "United States");
INSERT INTO connection(fromId, toId, lenght) VALUES(1, 2, 1450);
INSERT INTO connection(fromId, toId, lenght) VALUES(2, 3, 8750);
INSERT INTO connection(fromId, toId, lenght) VALUES(3, 1, 9850);

CALL insertAircraft(180, 40000, 3000);
CALL insertAircraft(250, 55000, 9000);
CALL insertAircraft(360, 80000, 11000);

CALL insertPassanger("Jessica", "Elliott");
CALL insertPassanger("Glenda", "Thornton");
CALL insertPassanger("Barbara", "Holmes");
CALL insertPassanger("Toby", "Boone");
CALL insertPassanger("Clay", "Matthews");
CALL insertPassanger("Earl", "Cohen");
CALL insertPassanger("Christy", "Horton");
CALL insertPassanger("Jamie", "Williams");
CALL insertPassanger("Emily", "Watkins");
CALL insertPassanger("Melinda", "Flowers");
CALL insertPassanger("Ricardo", "Tucker");
CALL insertPassanger("Laurence", "Hunter");
CALL insertPassanger("Donald", "Coleman");
CALL insertPassanger("Clifford", "Nash");
CALL insertPassanger("Patty", "Walker");

CALL insertEmployee("Frances", "May");
CALL insertEmployee("Katrina", "Olson");
CALL insertEmployee("Jan", "Perry");
CALL insertEmployee("Bertha", "Edwards");
CALL insertEmployee("Lawrence", "Payne");
CALL insertEmployee("Lonnie", "Maxwell");
CALL insertEmployee("Craig", "Salazar");
CALL insertEmployee("Mindy", "Scott");
CALL insertEmployee("Valerie", "Oliver");
CALL insertEmployee("Megan", "Wilson");

CALL insertFlight("OA1030", "KRK", "LHR", "2022-12-20 12:00:00", "2022-12-20 14:00:00");
CALL insertFlight("OA1040", "LHR", "LAX", "2022-12-20 12:00:00", "2022-12-20 21:00:00");
CALL insertFlight("OA1050", "LAX", "KRK", "2022-12-20 12:00:00", "2022-12-20 23:00:00");

CALL assignAircraft("OA1030", 1);
CALL assignAircraft("OA1040", 2);
CALL assignAircraft("OA1050", 3);

INSERT INTO ticket(flightId, passangerId, class) VALUES(1, 1, "business");
INSERT INTO ticket(flightId, passangerId, class) VALUES(1, 2, "economy");
INSERT INTO ticket(flightId, passangerId, class) VALUES(1, 3, "economy");
INSERT INTO ticket(flightId, passangerId, class) VALUES(2, 4, "business");
INSERT INTO ticket(flightId, passangerId, class) VALUES(2, 5, "economy");

SELECT flight.number AS flightNumber, passangersForFlight(flight.id)
    FROM flight 
    INNER JOIN aircraft ON aircraft.id = flight.aircraftId
    WHERE flight.removed = 0 AND aircraft.removed = 0;

UPDATE flight SET removed = 1 WHERE flight.id = 2;
UPDATE aircraft SET removed = 1 WHERE aircraft.id = 3;

SELECT flight.number AS flightNumber, passangersForFlight(flight.id)
    FROM flight 
    INNER JOIN aircraft ON aircraft.id = flight.aircraftId
    WHERE flight.removed = 0 AND aircraft.removed = 0;
