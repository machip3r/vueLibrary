CREATE DATABASE IF NOT EXISTS biblioteca_db;

USE biblioteca_db;

CREATE TABLE IF NOT EXISTS user(
    id_user INT NOT NULL AUTO_INCREMENT,
    u_name VARCHAR(60) NOT NULL,
    u_last_name VARCHAR(60) NOT NULL,
    u_m_last_name VARCHAR(60) NOT NULL,
    u_email VARCHAR(100) NOT NULL,
    u_status char(1) NOT NULL DEFAULT 'a',
    PRIMARY KEY (id_user),
    /* INDEX(u_name, u_last_name, u_m_last_name) */
    INDEX(u_name),
    INDEX(u_last_name),
    INDEX(u_m_last_name),
    UNIQUE(u_email)
);

CREATE TABLE IF NOT EXISTS book(
    id_book INT NOT NULL AUTO_INCREMENT,
    b_title VARCHAR(60) NOT NULL,
    b_author VARCHAR(80) NOT NULL,
    b_editorial VARCHAR(100) NOT NULL,
    b_edition SMALLINT,
    PRIMARY KEY (id_book)
);

CREATE TABLE IF NOT EXISTS loan(
    id_loan INT NOT NULL AUTO_INCREMENT,
    id_user INT NOT NULL,
    l_date DATETIME NOT NULL,
    l_return_date DATETIME NOT NULL,
    l_real_return_date DATETIME,
    PRIMARY KEY (id_loan),
    CONSTRAINT FKUser FOREIGN KEY (id_user) REFERENCES user(id_user) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS loanDetails(
	id_loan_details INT NOT NULL AUTO_INCREMENT,
    id_loan INT NOT NULL,
    id_book INT NOT NULL,
    ld_penalty DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (id_loan_details),
    CONSTRAINT FKLoan FOREIGN KEY (id_loan) REFERENCES loan(id_loan) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FKBook FOREIGN KEY (id_book) REFERENCES book(id_book) ON DELETE CASCADE ON UPDATE CASCADE
);

# INSERTAR DATOS

USE biblioteca_db;

INSERT INTO user(u_name, u_last_name, u_m_last_name, u_email, u_status)
    VALUES("Aldo Isaac", "Hernández", "Antonio", "ai.hernandezantonio@ugto.mx", "a"),
            ("Christian Arturo", "Campos", "Vega", "ca.camposvega@ugto.mx", "a"),
            ("María Fernanda", "Esparza", "Medina", "mf.esparzamedina@ugto.mx", "i"),
            ("Juan Julián", "García", "Zárate", "jj.garciazarate@ugto.mx", "a"),
            ("Julián Moisés", "Pérez", "Godstudillo", "jm.perezgodstudillo@ugto.mx", "a"),
            ("María Fernanda", "Moreno", "Razo", "mf.morenorazo@ugto.mx", "i"),
            ("Ana Carolina", "Razo", "Armenta", "ac.razoarmenta@ugto.mx", "a"),
            ("Nayeli", "Bravo", "Regalado", "n.bravoregalado@ugto.mx", "i"),
            ("Braulio José", "Baca", "Barbosa", "bj.bacabarbosa@ugto.mx", "a"),
            ("Esteban", "González", "Cisneros", "e.gonzalezcisneros@ugto.mx", "i");

INSERT INTO book(b_title, b_author, b_editorial, b_edition)
	VALUES("C++ HOW TO PROGRAM", "Deitel", "Prentince Hall", 3),
		  ("Calculus", "Michael Spivak", "Reverté", 3),
		  ("Fundamentos de Bases de Datos", "Abraham Silberschatz", "Mcgraw-Hill", 2),
		  ("Modern Operating Systems", "Andrew S. Tanenbaum", "Prentince Hall", 3);

INSERT INTO loan(id_user, l_date, l_return_date, l_real_return_date)
    VALUES(1,  "2021-03-15", "2021-03-29", '2021-03-28'),
            (2,  "2021-03-16", "2021-03-30", '2021-03-22'),
            (4,  "2021-03-15", "2021-03-29", '2021-03-20'),
            (10, "2021-03-18", "2021-03-01", '2021-03-19'),
            (5,  "2021-03-16", "2021-03-30", '2021-03-24');

INSERT INTO loanDetails(id_loan, id_book, ld_penalty)
    VALUES(1, 1, 0),
            (2, 4, 0),
            (3, 2, 0),
            (4, 2, 0),
            (5, 4, 0);

# OBTENER DATOS

USE biblioteca_db;

    # Devolver toda la información excepto el id de los libros que tengan en su título la palabra 'cálculo'
SELECT b_title, b_author, b_editorial, b_edition
FROM book
WHERE b_title LIKE "%cálculo%";

    # Devolver toda la información excepto el id de los libros de los autores cuyo nombre empiece con 'a'
SELECT b_title, b_author, b_editorial, b_edition
FROM book
WHERE b_author LIKE "A%";

    # Devolver toda la información excepto el id de los libros que tengan en su título la palabra 'cálculo' y que sean de la edición 1
SELECT b_title, b_author, b_editorial, b_edition
FROM book
WHERE b_title LIKE "%cálculo%"
AND b_edition = 1;

    # Devolver toda la información excepto el id de los usuarios con apellido paterno 'lópez' y estado activo
SELECT u_name, u_last_name, u_m_last_name, u_email, u_status
FROM user
WHERE u_last_name = "López"
AND u_status = "a";

    # Devolver toda la información excepto el id de los usuarios con apellido materno 'lara', estado inactivo y cuyo correo electrónico termine en 'ugto.mx'
SELECT u_name, u_last_name, u_m_last_name, u_email, u_status
FROM user
WHERE u_m_last_name = "Lara"
AND u_status = "i"
AND u_email LIKE "%ugto.mx";

    # Devolver toda la información excepto el id de los préstamos con fecha de préstamo de marzo o abril de 2021
SELECT id_user, l_date, l_return_date
FROM loan
WHERE l_date BETWEEN "2021-03-01" AND "2021-04-30";

    # Devolver toda la información excepto el id de los préstamos con fecha de entrega real de frebrero o marzo de 2021
SELECT id_user, l_date, l_return_date, l_real_return_date
FROM loan
WHERE l_real_return_date BETWEEN "2021-02-01" AND "2021-03-31";

    # Devolver toda la información excepto el id de los préstamos de un usuario con id específico
SELECT id_user, l_date, l_return_date, l_real_return_date
FROM loan
WHERE id_user = 1;

    # Devolver toda la información excepto el id de los préstamos con fecha de préstamo de marzo de 2021 de un usuario con id específico
SELECT id_user, l_date, l_return_date, l_real_return_date
FROM loan
WHERE l_date BETWEEN "2021-03-01" AND "2021-03-31"
AND id_user = 2;

    # Devolver el nombre y el correo de cada usuario, junto con toda la información de los préstamos que tiene cada uno
SELECT user.u_name, user.u_email, loan.*
FROM user, loan
WHERE user.id_user = loan.id_user;

    # Devolver el nombre y el correo de cada usuario, junto con toda la información de los préstamos que tiene cada uno, pero solo para los préstamos con fecha de préstamo de febrero de 2021 y fecha de entrega real de marzo de 2021
SELECT user.u_name, user.u_email, loan.*
FROM user, loan
WHERE user.id_user = loan.id_user
AND loan.l_date BETWEEN "2021-02-01" AND "2021-02-28"
AND loan.l_real_return_date BETWEEN "2021-03-01" AND "2021-03-31";

    # Devolver toda la información de los detalles de préstamo para un préstamo con id específico
SELECT *
FROM loanDetails
WHERE id_loan = 1;

    # Devolver toda la información de los detalles de préstamo para aquellos registros que tengan multa > 0
SELECT *
FROM loanDetails
WHERE ld_penalty > 0;

    # Devolver toda la información de los préstamos, junto con toda la información de los detalles de préstamo para cada préstamo
SELECT loan.*, loanDetails.*
FROM loan, loanDetails
WHERE loan.id_loan = loanDetails.id_loan;

    # Devolver toda la información de los préstamos, junto con toda la información de los detalles de préstamo para cada préstamo, pero solo los préstamos de un usuario con id específico
SELECT loan.*, loanDetails.*
FROM loan, loanDetails
WHERE loan.id_loan = loanDetails.id_loan
AND loan.id_user = 1;

    # Devolver toda la información de los préstamos, junto con toda la información de los detalles de préstamo para cada préstamo, pero solo los préstamos de un usuario con id específico con fecha de préstamo de febrero o marzo de 2021
SELECT loan.*, loanDetails.*
FROM loan, loanDetails
WHERE loan.id_loan = loanDetails.id_loan
AND loan.id_user = 2
AND loan.l_date BETWEEN "2021-02-01" AND "2021-03-31";

    # Devolver toda la información de los préstamos, junto con toda la información de los detalles de préstamo para cada préstamo, pero solo para los detalles que tienen multa > 100
SELECT loan.*, loanDetails.*
FROM loan, loanDetails
WHERE loan.id_loan = loanDetails.id_loan
AND loanDetails.ld_penalty > 100;

    # Devolver toda la información de los préstamos, junto con toda la información de los detalles de préstamo para cada préstamo, pero solo para los detalles que tienen multa > 100 para un usuario con id específico
SELECT loan.*, loanDetails.*
FROM loan, loanDetails
WHERE loan.id_loan = loanDetails.id_loan
AND loanDetails.ld_penalty > 100
AND loan.id_user = 3;
