DROP DATABASE IF EXISTS sakila_DW;
CREATE DATABASE sakila_DW;
USE sakila_DW;
DROP TABLE IF EXISTS dim_film, dim_date, dim_semester, dim_quarter, dim_bimester, dim_month, dim_staff, dim_address, dim_store, dim_customer, fact_rentals;

CREATE TABLE dim_semester(
    dim_semester int,
    desc_dim_semester varchar(45),
    PRIMARY KEY(dim_semester)
);
    
CREATE TABLE dim_quarter(
    dim_quarter int,
    desc_dim_quarter varchar(45),
    PRIMARY KEY(dim_quarter)
);
    
CREATE TABLE dim_bimester(
    dim_bimester int,
    desc_dim_bimester varchar(45),
    PRIMARY KEY(dim_bimester)
);
    
CREATE TABLE dim_month(    
    dim_month int,
    desc_dim_month varchar(45),
    PRIMARY KEY(dim_month)
);

CREATE TABLE dim_date (date_id int NOT NULL,
	dim_date datetime,
    dim_semester int,
    dim_quarter int,
    dim_bimester int,
    dim_month int,
    year_n int,
    month_day varchar(2),
    weekday_n varchar(50),
    PRIMARY KEY(date_id),
    FOREIGN KEY(dim_semester) REFERENCES dim_semester(dim_semester),
    FOREIGN KEY(dim_quarter) REFERENCES dim_quarter(dim_quarter),
    FOREIGN KEY(dim_bimester) REFERENCES dim_bimester(dim_bimester),
    FOREIGN KEY(dim_month) REFERENCES dim_month(dim_month)
);

CREATE TABLE dim_film(film_id int NOT NULL,
	title varchar(128),
    category varchar(25),
    `language` varchar(20),
    rating enum('G','PG','PG-13','R','NC-17'),
    PRIMARY KEY(film_id)
);

CREATE TABLE dim_address(address_id int NOT NULL,
	address varchar(50),
    city varchar(50),
    country varchar(50),
    location geometry,
	PRIMARY KEY(address_id)
);

CREATE TABLE dim_store(store_id int NOT NULL,
    address_id int,
	store varchar(101),
    PRIMARY KEY(store_id),
    FOREIGN KEY (address_id) REFERENCES dim_address(address_id)
);

CREATE TABLE dim_customer(customer_id int NOT NULL,
	address_id int,
    name varchar(91),
    active enum('activo','inactivo'),
    PRIMARY KEY(customer_id),
    FOREIGN KEY (address_id) REFERENCES dim_address(address_id)
);

CREATE TABLE fact_rentals(rental_id CHAR(8) NOT NULL,
	film_id int,
    store_id int,
    customer_id int,
    date_id int,
    staff_name varchar(91),
    `transaction` varchar(50),
    amount decimal(5,2),
    PRIMARY KEY (rental_id),
    FOREIGN KEY (film_id) REFERENCES dim_film(film_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id)
);