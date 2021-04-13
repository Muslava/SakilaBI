USE sakila_DW;

DELIMITER //
DROP PROCEDURE IF EXISTS p_insert_date //
CREATE PROCEDURE p_insert_date (IN CurrentDate datetime)
BEGIN
	DECLARE semester_id int;
	DECLARE quarter_id int;
	DECLARE bimester_id int;
	DECLARE month_id int;
    
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
		-- SELECT CONCAT('Duplicate key (',inSupplierId,',',inProductId,') occurred') AS message;
    END;
    
    SET semester_id = (YEAR(CurrentDate)*100) + CASE WHEN QUARTER(CurrentDate) >= 3 THEN 2 ELSE 1 END;
	SET quarter_id = (YEAR(CurrentDate)*100) + QUARTER(CurrentDate);
	SET bimester_id = (YEAR(CurrentDate)*100) + CASE
		WHEN MONTH(CurrentDate) BETWEEN 1 AND 2 THEN '01' 
		WHEN MONTH(CurrentDate) BETWEEN 3 AND 4 THEN '02'
		WHEN MONTH(CurrentDate) BETWEEN 5 AND 6 THEN '03'
		WHEN MONTH(CurrentDate) BETWEEN 7 AND 8 THEN '04' 
		WHEN MONTH(CurrentDate) BETWEEN 9 AND 10 THEN '05'
		WHEN MONTH(CurrentDate) BETWEEN 11 AND 12 THEN '06'
	END;
	SET month_id = (YEAR(CurrentDate)*100) + MONTH(CurrentDate);
    
	INSERT INTO dim_semester(dim_semester, desc_dim_semester) VALUES (
		semester_id,
		CONCAT("Semestre ", CASE WHEN QUARTER(CurrentDate) >= 3 THEN 2 ELSE 1 END, " de ", YEAR(CurrentDate))
	);
	INSERT INTO dim_quarter(dim_quarter, desc_dim_quarter) VALUES (
		quarter_id,
		CONCAT("Trimestre ", QUARTER(CurrentDate), " de ", YEAR(CurrentDate))
	);
	INSERT INTO dim_bimester(dim_bimester, desc_dim_bimester) VALUES (
		bimester_id,
		CONCAT("Bimestre ", CASE
			WHEN MONTH(CurrentDate) BETWEEN 1 AND 2 THEN '1' 
			WHEN MONTH(CurrentDate) BETWEEN 3 AND 4 THEN '2'
			WHEN MONTH(CurrentDate) BETWEEN 5 AND 6 THEN '3'
			WHEN MONTH(CurrentDate) BETWEEN 7 AND 8 THEN '4' 
			WHEN MONTH(CurrentDate) BETWEEN 9 AND 10 THEN '5'
			WHEN MONTH(CurrentDate) BETWEEN 11 AND 12 THEN '6'
		END, " de ", YEAR(CurrentDate))
	);
	INSERT INTO dim_month(dim_month, desc_dim_month) VALUES (
		month_id,
		CONCAT(CASE
			WHEN MONTH(CurrentDate) = 1 THEN 'Enero'
			WHEN MONTH(CurrentDate) = 2 THEN 'Febrero'
			WHEN MONTH(CurrentDate) = 3 THEN 'Marzo'
			WHEN MONTH(CurrentDate) = 4 THEN 'Abril'
			WHEN MONTH(CurrentDate) = 5 THEN 'Mayo'
			WHEN MONTH(CurrentDate) = 6 THEN 'Junio'
			WHEN MONTH(CurrentDate) = 7 THEN 'Julio'
			WHEN MONTH(CurrentDate) = 8 THEN 'Agosto'
			WHEN MONTH(CurrentDate) = 9 THEN 'Septiembre'
			WHEN MONTH(CurrentDate) = 10 THEN 'Octubre'
			WHEN MONTH(CurrentDate) = 11 THEN 'Noviembre'
			WHEN MONTH(CurrentDate) = 12 THEN 'Diciembre'
		END, " de ", YEAR(CurrentDate))
	);
	INSERT INTO dim_date(date_id, dim_date, dim_semester, dim_quarter, dim_bimester, dim_month, year_n, month_day, weekday_n)
	VALUES (
		(YEAR(CurrentDate)*10000) + (MONTH(CurrentDate)*100) + DAY(CurrentDate)
		, CurrentDate
		, semester_id
		, quarter_id
		, bimester_id
		, month_id
		, YEAR(CurrentDate)
		, DAY(CurrentDate)
		, (CASE
			WHEN DAYOFWEEK(CurrentDate) = 1 THEN 'Domingo'
			WHEN DAYOFWEEK(CurrentDate) = 2 THEN 'Lunes'
			WHEN DAYOFWEEK(CurrentDate) = 3 THEN 'Martes'
			WHEN DAYOFWEEK(CurrentDate) = 4 THEN 'Miércoles'
			WHEN DAYOFWEEK(CurrentDate) = 5 THEN 'Jueves'
			WHEN DAYOFWEEK(CurrentDate) = 6 THEN 'Viernes'
			WHEN DAYOFWEEK(CurrentDate) = 7 THEN 'Sábado'
		END)
	);
END//

DELIMITER //
DROP PROCEDURE IF EXISTS `insert_date_cursor`//
-- CREATE PROCEDURE `insert_date_cursor`(campo varchar(50), tablaBD varchar(50))
CREATE PROCEDURE `insert_date_cursor`()
BEGIN

/* DECLARACIÓN DE VARIABLES */
DECLARE dim_date TIMESTAMP;
-- 1. Declaración del cursor:
DECLARE my_cursor CURSOR FOR
	-- SELECT cust_camp := @campo FROM cust_table := @tablaBD;
    SELECT last_update FROM sakila.store;
-- * Declaración de un manejador de error tipo NOT FOUND:
DECLARE CONTINUE HANDLER FOR NOT FOUND SET @hecho = TRUE;

-- 2. Apertura del cursor:
OPEN my_cursor;
-- 2.a. Comenzar bucle de lectura:
loop1: LOOP
-- 3. Lectura de los resultados con fetch:
FETCH my_cursor INTO dim_date;
	/* Si el cursor se quedó sin elementos,
	entonces nos salimos del bucle */
	IF @hecho THEN
    LEAVE loop1;
    END IF;
    -- 3.a. Acción a realizar:
    CALL p_insert_date(dim_date);
-- 3.b. Fin del bucle de lectura:
END LOOP loop1;
-- 4. Cierre del cursor:
CLOSE my_cursor;

-- Mostramos el resultado:
SELECT * FROM dim_date;
END //