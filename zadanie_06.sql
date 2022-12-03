DROP TABLE flightCrew;
DROP TABLE ticket;
DROP TABLE flight;
DROP TABLE connection;
DROP TABLE airport;
DROP TABLE employee;

CREATE TABLE employee(
    id INT NOT NULL AUTO_INCREMENT,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE airport(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE connection(
    id INT NOT NULL AUTO_INCREMENT,
    fromId INT NOT NULL,
    toId INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(fromId) REFERENCES airport(id),
    FOREIGN KEY(toId) REFERENCES airport(id)
);

CREATE TABLE flight(
    id INT NOT NULL AUTO_INCREMENT,
    number VARCHAR(255),
    canceled INT NOT NULL DEFAULT 0,
    takeofDate DATE NOT NULL,
    landingDate DATE NOT NULL,
    connectionId INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(connectionId) REFERENCES connection(id)
);

CREATE TABLE ticket(
    id INT NOT NULL AUTO_INCREMENT,
    flightId INT NOT NULL,
    ownerFirstName VARCHAR(255) NOT NULL,
    ownerLastName VARCHAR(255) NOT NULL,
    purchaseDate DATE NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(flightId) REFERENCES flight(id)
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

INSERT INTO airport(name, city, country)
    VALUES("Krakow-Balice", "Krakow", "Poland");

INSERT INTO airport(name, city, country)
    VALUES("Port Lotniczy Gdansk", "Gdansk", "Poland");

INSERT INTO connection(fromId, toId)
    VALUES(1, 2);

INSERT flight(number, takeofDate, landingDate, connectionId)
    VALUES("1060-DAB", "2022-10-10 10:40:00", "2022-10-10 12:31:00", 1);

INSERT INTO ticket(flightId, ownerFirstName, ownerLastName, purchaseDate)
    VALUES(1, "Jan", "Kowalski", "2022-10-10 14:30:21");

INSERT INTO ticket(flightId, ownerFirstName, ownerLastName, purchaseDate)
    VALUES(1, "Adam", "Nowak", "2022-11-3 12:11:03");

DROP PROCEDURE selectPassangersByFlight;
DROP PROCEDURE selectFlightsArrvingToAirport;
DROP PROCEDURE selectFlightDepartingFromAirport;

DELIMITER //
CREATE PROCEDURE selectPassangersByFlight(IN flightNumber VARCHAR(255))
BEGIN
    SELECT
        ticket.id AS ticketId,
        ticket.ownerFirstName AS firstName,
        ticket.ownerFirstName AS lastName
        FROM ticket
            JOIN flight ON ticket.flightId = flight.id
            WHERE flight.number = flightNumber;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE selectFlightsArrvingToAirport(IN airportId INT)
BEGIN
    SELECT
        flight.id AS flightId,
        flight.number AS flightNumber,
        airport.name AS fromAirport,
        airport.city AS fromCity,
        airport.country AS fromCountry,
        flight.takeofDate AS takeofDate,
        flight.landingDate AS landingDate
        FROM flight
            JOIN connection ON connection.id = flight.connectionId
            JOIN airport ON airport.id = connection.fromId
            WHERE connection.toId = airportId;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE selectFlightDepartingFromAirport(IN airportId INT)
BEGIN
    SELECT
        flight.id AS flightId,
        flight.number AS flightNumber,
        airport.name AS toAirport,
        airport.city AS toCity,
        airport.country AS toCountry,
        flight.takeofDate AS takeofDate,
        flight.landingDate AS landingDate
        FROM flight
            JOIN connection ON connection.id = flight.connectionId
            JOIN airport ON airport.id = connection.toId
            WHERE connection.fromId = airportId;
END //
DELIMITER ;

CALL selectPassangersByFlight("1060-DAB");
CALL selectFlightsArrvingToAirport(2);
CALL selectFlightDepartingFromAirport(1);
