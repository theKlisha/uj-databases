DROP TABLE IF EXISTS planet; 
DROP TABLE IF EXISTS star; 

CREATE TABLE star (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(200),
    rotationPeriodSec REAL,
    massKg REAL,
    insertedDate DATETIME,
    updatedDate DATETIME,
    PRIMARY KEY(id)
);

CREATE TABLE planet (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(200),
    starId INT,
    insertedDate DATETIME,
    updatedDate DATETIME,
    inclinationRad REAL,
    apoapsisKm REAL, 
    periapsisKm REAL, 
    orbitPeriodSec REAL,
    rotationPeriodSec REAL,
    massKg REAL,
    PRIMARY KEY(id),
    FOREIGN KEY(starId) REFERENCES star(id)
);

CREATE TRIGGER setStarInsertDate
    BEFORE INSERT ON star
    FOR EACH ROW
        SET NEW.insertedDate = NOW();

CREATE TRIGGER setPlanetInsertDate
    BEFORE INSERT ON planet
    FOR EACH ROW 
        SET NEW.insertedDate = NOW();

CREATE TRIGGER setStarUpdateDate
    BEFORE UPDATE ON star
    FOR EACH ROW
        SET NEW.updatedDate = NOW();

CREATE TRIGGER setPlanetUpdateDate
    BEFORE UPDATE ON planet
    FOR EACH ROW
        SET NEW.updatedDate = NOW();

CREATE TRIGGER addPlanetOrbitingStar
    AFTER INSERT ON star
    FOR EACH ROW 
        INSERT INTO planet(starId) VALUES(NEW.id);
