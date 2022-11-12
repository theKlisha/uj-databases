DROP TABLE pet_owner;
DROP TABLE acceptance;
DROP TABLE adoption;
DROP TABLE vaccination;
DROP TABLE pet;
DROP TABLE worker;
DROP TABLE owner;

CREATE TABLE pet (
    name VARCHAR(30),
    species VARCHAR(30),
    sex CHAR(1),
    birth DATE,
    death DATE,
    id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE worker (
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(30),
    phone VARCHAR(30),
    job_title VARCHAR(30) NOT NULL,
    id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE owner (
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(30),
    phone VARCHAR(30),
    id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE pet_owner (
    from_date DATE,
    to_date DATE,
    pet_id INT NOT NULL,
    owner_id INT NOT NULL,
    id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (owner_id) REFERENCES owner(id),
    FOREIGN KEY (pet_id) REFERENCES pet(id)
);

CREATE TABLE acceptance (
    date DATE NOT NULL,
    pet_id INT NOT NULL,
    worker_id INT NOT NULL,
    owner_id INT,
    notes VARCHAR(300),
    id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (pet_id) REFERENCES pet(id),
    FOREIGN KEY (owner_id) REFERENCES owner(id),
    FOREIGN KEY (worker_id) REFERENCES worker(id)
);

CREATE TABLE adoption (
    date DATE NOT NULL,
    pet_id INT NOT NULL,
    worker_id INT NOT NULL,
    owner_id INT NOT NULL,
    id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (pet_id) REFERENCES pet(id),
    FOREIGN KEY (owner_id) REFERENCES owner(id),
    FOREIGN KEY (worker_id) REFERENCES worker(id)
);

CREATE TABLE vaccination (
    application_date DATE NOT NULL,
    expiration_date DATE NOT NULL,
    dose INT NOT NULL,
    lot VARCHAR(100) NOT NULL,
    name VARCHAR(100),
    pet_id INT NOT NULL,
    id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (pet_id) REFERENCES pet(id)
);

