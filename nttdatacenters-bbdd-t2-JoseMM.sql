/*Este procedimiento devuelve los alumnos de la empresa 1 (emp1) en el que su edad este por encima del
alumno con mas edad de la empresa 2 (emp2)*/

DELIMITER $$
DROP PROCEDURE IF EXISTS s_dual$$
CREATE PROCEDURE s_dual(emp1 VARCHAR(30), emp2 VARCHAR(30))
	BEGIN
		-- Declaramos variables
		DECLARE fin bool;
		DECLARE s_name, s_surnames, s_dni VARCHAR(30);
		DECLARE s_years, r_years int(2);

		-- Declaramos el cursor y almacenamos las consultas en el
		DECLARE c_student CURSOR FOR SELECT
			round(datediff(curdate(),birth_date)/365), s.name, surnames, dni
			from student s join company c 
			on s.cod_company = c.cod_company 
			where c.name like emp1;
			
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;
			select round(datediff(curdate(),min(birth_date))/365) INTO r_years
			from student s join company c 
			on s.cod_company = c.cod_company 
			where c.name like emp2;
			
		-- Abrimos el cursor, vertimos la informacion en las variables y declaramos un bucle
		OPEN c_student;
		l_student: LOOP
		FETCH c_student INTO s_years, s_name, s_surnames, s_dni;

		-- Si el cursor esta vacio el handler protege de NOT FOUND
		IF fin=1 THEN
				LEAVE l_student;
			ELSE
				IF s_years>r_years THEN
				SELECT CONCAT(s_name, ' ', s_surnames, ' ---> dni: ', s_dni, ', edad: ', s_years) as 'Alumno';
				END IF;
			END IF;
	
		END LOOP l_student;
		CLOSE c_student;

END
$$

-- Ejemplo: saldran todos los alumnos de NTTDATA excepto julia, que tiene 21 anyos, al igual que Lucia (Ricoh)


call s_dual('NTT DATA','Ricoh');