-- =========================================================
-- Tercera Entrega — Funcion: nomina total por restaurante
-- Suma el salario de todos los empleados de un restaurante.
-- Se invoca desde la app con: SELECT fn_nomina_restaurante(?) AS total
-- =========================================================

USE Restaurante;

DROP FUNCTION IF EXISTS fn_nomina_restaurante;

DELIMITER $$

CREATE FUNCTION fn_nomina_restaurante(p_codigo_restaurante INT)
RETURNS DECIMAL(14,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total DECIMAL(14,2);

  SELECT COALESCE(SUM(salario), 0)
    INTO v_total
    FROM Empleado
   WHERE codigo_restaurante = p_codigo_restaurante;

  RETURN v_total;
END$$

DELIMITER ;
