-- =========================================================
-- Tercera Entrega — Procedimiento: contratar empleado
-- Inserta un empleado con tres validaciones:
--   1) salario >= salario minimo legal
--   2) el restaurante existe
--   3) el DNI no esta duplicado
-- Devuelve el codigo_empleado generado por OUT param.
-- =========================================================

USE Restaurante;

DROP PROCEDURE IF EXISTS sp_contratar_empleado;

DELIMITER $$

CREATE PROCEDURE sp_contratar_empleado(
  IN  p_codigo_restaurante INT,
  IN  p_nombre             VARCHAR(45),
  IN  p_apellidos          VARCHAR(45),
  IN  p_DNI                VARCHAR(30),
  IN  p_fecha_nacimiento   DATE,
  IN  p_correo             VARCHAR(45),
  IN  p_cargo              VARCHAR(45),
  IN  p_salario            DECIMAL(10,2),
  OUT p_codigo_empleado    INT
)
BEGIN
  DECLARE v_rest_existe   INT;
  DECLARE v_dni_duplicado INT;
  DECLARE SALARIO_MINIMO  DECIMAL(10,2) DEFAULT 1300000.00;

  IF p_salario < SALARIO_MINIMO THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Salario por debajo del minimo legal (1.300.000)';
  END IF;

  SELECT COUNT(*) INTO v_rest_existe
    FROM Restaurante
   WHERE codigo_restaurante = p_codigo_restaurante;

  IF v_rest_existe = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante indicado no existe';
  END IF;

  SELECT COUNT(*) INTO v_dni_duplicado
    FROM Empleado
   WHERE DNI = p_DNI;

  IF v_dni_duplicado > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Ya existe un empleado con ese DNI';
  END IF;

  INSERT INTO Empleado (
    codigo_restaurante, nombre, apellidos, DNI,
    fecha_nacimiento, correo, cargo, fecha_ingreso, salario
  ) VALUES (
    p_codigo_restaurante, p_nombre, p_apellidos, p_DNI,
    p_fecha_nacimiento, p_correo, p_cargo, CURDATE(), p_salario
  );

  SET p_codigo_empleado = LAST_INSERT_ID();
END$$

DELIMITER ;
