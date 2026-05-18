-- =========================================================
-- Sabor & Tradicion — Schema base (Segunda Entrega)
-- Modelo relacional pagina 8 del PDF de la Segunda Entrega.
-- Ejecutar este archivo PRIMERO, luego 01..04.
-- =========================================================

DROP DATABASE IF EXISTS Restaurante;
CREATE DATABASE Restaurante CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE Restaurante;

-- ---------------------------------------------------------
-- Restaurante (entidad fuerte)
-- ---------------------------------------------------------
CREATE TABLE Restaurante (
  codigo_restaurante INT AUTO_INCREMENT PRIMARY KEY,
  nombre             VARCHAR(45) NOT NULL,
  calle              VARCHAR(45) NOT NULL,
  ciudad             VARCHAR(45) NOT NULL,
  pais               VARCHAR(45) NOT NULL,
  cap_maxima         INT         NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Telefonos_restaurante (
  telefono           VARCHAR(30) NOT NULL,
  codigo_restaurante INT         NOT NULL,
  PRIMARY KEY (telefono, codigo_restaurante),
  CONSTRAINT fk_telrest_rest FOREIGN KEY (codigo_restaurante)
    REFERENCES Restaurante(codigo_restaurante)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Empleado (entidad fuerte, Trabaja en Restaurante N:1)
-- ---------------------------------------------------------
CREATE TABLE Empleado (
  codigo_empleado     INT AUTO_INCREMENT PRIMARY KEY,
  codigo_restaurante  INT          NOT NULL,
  nombre              VARCHAR(45)  NOT NULL,
  apellidos           VARCHAR(45)  NOT NULL,
  DNI                 VARCHAR(30)  NOT NULL,
  fecha_nacimiento    DATE         NOT NULL,
  correo              VARCHAR(45)  NULL,
  cargo               VARCHAR(45)  NOT NULL,
  fecha_ingreso       DATE         NOT NULL,
  salario             DECIMAL(10,2) NOT NULL,
  UNIQUE KEY uq_emp_dni (DNI),
  KEY ix_emp_restaurante (codigo_restaurante),
  CONSTRAINT fk_emp_restaurante FOREIGN KEY (codigo_restaurante)
    REFERENCES Restaurante(codigo_restaurante)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE Telefonos_empleado (
  telefono        VARCHAR(30) NOT NULL,
  codigo_empleado INT         NOT NULL,
  PRIMARY KEY (telefono, codigo_empleado),
  CONSTRAINT fk_telemp_emp FOREIGN KEY (codigo_empleado)
    REFERENCES Empleado(codigo_empleado)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Plato (entidad fuerte)
-- ---------------------------------------------------------
CREATE TABLE Plato (
  codigo_plato INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(45) NOT NULL,
  descripcion  VARCHAR(60) NULL,
  precio_base  DECIMAL(10,2) NOT NULL,
  categoria    ENUM('entrada','plato fuerte','postre','bebida') NOT NULL,
  tiempo_prep  SMALLINT NOT NULL
) ENGINE=InnoDB;

-- Relacion Ofrece (Restaurante N:N Plato)
CREATE TABLE Plato_en_Restaurante (
  codigo_restaurante INT          NOT NULL,
  codigo_plato       INT          NOT NULL,
  precio_local       DECIMAL(10,2) NOT NULL,
  disponible         TINYINT      NOT NULL DEFAULT 1,
  PRIMARY KEY (codigo_restaurante, codigo_plato),
  KEY ix_per_restaurante (codigo_restaurante),
  KEY ix_per_plato (codigo_plato),
  CONSTRAINT fk_per_restaurante FOREIGN KEY (codigo_restaurante)
    REFERENCES Restaurante(codigo_restaurante)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_per_plato FOREIGN KEY (codigo_plato)
    REFERENCES Plato(codigo_plato)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Ingrediente (entidad fuerte)
-- ---------------------------------------------------------
CREATE TABLE Ingrediente (
  codigo_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
  nombre             VARCHAR(45)  NOT NULL,
  costo_unitario     DECIMAL(10,2) NOT NULL,
  tipo               VARCHAR(45)  NOT NULL
) ENGINE=InnoDB;

-- Relacion Compone (Plato N:N Ingrediente)
CREATE TABLE Ingrediente_en_Plato (
  codigo_ingrediente INT   NOT NULL,
  codigo_plato       INT   NOT NULL,
  cantidad           FLOAT NOT NULL,
  PRIMARY KEY (codigo_ingrediente, codigo_plato),
  KEY ix_iep_plato (codigo_plato),
  KEY ix_iep_ingrediente (codigo_ingrediente),
  CONSTRAINT fk_iep_ingrediente FOREIGN KEY (codigo_ingrediente)
    REFERENCES Ingrediente(codigo_ingrediente)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_iep_plato FOREIGN KEY (codigo_plato)
    REFERENCES Plato(codigo_plato)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Proveedor (entidad fuerte)
-- ---------------------------------------------------------
CREATE TABLE Proveedor (
  codigo_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre           VARCHAR(45) NOT NULL,
  NIT              VARCHAR(20) NOT NULL,
  calle            VARCHAR(45) NOT NULL,
  ciudad           VARCHAR(45) NOT NULL,
  pais             VARCHAR(45) NOT NULL,
  correo           VARCHAR(45) NULL,
  UNIQUE KEY uq_prov_nit (NIT)
) ENGINE=InnoDB;

CREATE TABLE Telefonos_proveedor (
  telefono         VARCHAR(45) NOT NULL,
  codigo_proveedor INT         NOT NULL,
  PRIMARY KEY (telefono, codigo_proveedor),
  CONSTRAINT fk_telprov_prov FOREIGN KEY (codigo_proveedor)
    REFERENCES Proveedor(codigo_proveedor)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Relacion Suministra (Proveedor N:N Ingrediente)
CREATE TABLE Ingrediente_por_Proveedor (
  codigo_ingrediente INT          NOT NULL,
  codigo_proveedor   INT          NOT NULL,
  precio_compra      DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (codigo_ingrediente, codigo_proveedor),
  CONSTRAINT fk_ipp_ingrediente FOREIGN KEY (codigo_ingrediente)
    REFERENCES Ingrediente(codigo_ingrediente)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ipp_proveedor FOREIGN KEY (codigo_proveedor)
    REFERENCES Proveedor(codigo_proveedor)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Datos semilla (minimos, para demostrar el CRUD)
-- ---------------------------------------------------------
INSERT INTO Restaurante (nombre, calle, ciudad, pais, cap_maxima) VALUES
  ('Sabor & Tradicion - El Poblado', 'Cra 43A #15-30', 'Medellin', 'Colombia', 80),
  ('Sabor & Tradicion - Chapinero',  'Calle 60 #10-25', 'Bogota',   'Colombia', 60),
  ('Sabor & Tradicion - Granada',    'Av 9 Norte #14-50', 'Cali',   'Colombia', 50);

INSERT INTO Empleado
  (codigo_restaurante, nombre, apellidos, DNI, fecha_nacimiento, correo, cargo, fecha_ingreso, salario)
VALUES
  (1, 'Camila', 'Rojas',   '1037650001', '1995-03-12', 'camila@sabor.co',  'chef',          '2023-06-01', 3200000.00),
  (1, 'Andres', 'Patino',  '1037650002', '1998-07-21', NULL,               'mesero',        '2024-02-15', 1500000.00),
  (2, 'Luisa',  'Ortega',  '1037650003', '1990-11-04', 'luisa@sabor.co',   'administrador', '2022-09-10', 4500000.00),
  (3, 'Mateo',  'Vargas',  '1037650004', '1996-05-30', NULL,               'mesero',        '2024-08-20', 1400000.00);

INSERT INTO Plato (nombre, descripcion, precio_base, categoria, tiempo_prep) VALUES
  ('Bandeja Paisa',     'Frijoles, arroz, carne, chicharron, huevo, platano', 38000.00, 'plato fuerte', 25),
  ('Arepa de Huevo',    'Arepa frita con huevo adentro',                       8000.00, 'entrada',      10),
  ('Tres Leches',       'Postre frio bañado en leche',                        15000.00, 'postre',       15),
  ('Limonada de Coco',  NULL,                                                  9000.00, 'bebida',        5);
