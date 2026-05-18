-- =========================================================
-- Tercera Entrega — Triggers de auditoria de salario
-- Dos triggers porque MySQL define cada trigger por (timing, event).
-- =========================================================

USE Restaurante;

DROP TRIGGER IF EXISTS trg_empleado_after_insert;
DROP TRIGGER IF EXISTS trg_empleado_after_update;

DELIMITER $$

CREATE TRIGGER trg_empleado_after_insert
AFTER INSERT ON Empleado
FOR EACH ROW
BEGIN
  INSERT INTO Historial_salario
    (codigo_empleado, salario_anterior, salario_nuevo, tipo_evento)
  VALUES
    (NEW.codigo_empleado, NULL, NEW.salario, 'INSERT');
END$$

CREATE TRIGGER trg_empleado_after_update
AFTER UPDATE ON Empleado
FOR EACH ROW
BEGIN
  IF OLD.salario <> NEW.salario THEN
    INSERT INTO Historial_salario
      (codigo_empleado, salario_anterior, salario_nuevo, tipo_evento)
    VALUES
      (NEW.codigo_empleado, OLD.salario, NEW.salario, 'UPDATE');
  END IF;
END$$

DELIMITER ;
