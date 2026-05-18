-- =========================================================
-- Tercera Entrega — Tabla de auditoria del salario
-- Ejecutar primero. El trigger del archivo 02 depende de ella.
-- =========================================================

USE Restaurante;

DROP TABLE IF EXISTS Historial_salario;

CREATE TABLE Historial_salario (
  id_historial      INT AUTO_INCREMENT PRIMARY KEY,
  codigo_empleado   INT          NOT NULL,
  salario_anterior  DECIMAL(10,2),
  salario_nuevo     DECIMAL(10,2) NOT NULL,
  tipo_evento       ENUM('INSERT','UPDATE') NOT NULL,
  fecha_evento      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_hist_empleado
    FOREIGN KEY (codigo_empleado) REFERENCES Empleado(codigo_empleado)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;
