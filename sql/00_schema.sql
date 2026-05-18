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
-- Los datos semilla viven en 05_seed.sql para que el trigger
-- de Empleado (creado en 02_trigger.sql) tambien aplique a
-- los empleados de demostracion.
-- ---------------------------------------------------------
