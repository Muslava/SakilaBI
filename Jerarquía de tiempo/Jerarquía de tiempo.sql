USE sakila_DW;
DROP TABLE IF EXISTS dim_date, dim_semester, dim_quarter, dim_bimester, dim_month;

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
