-- =========================================================
-- Datos semilla. Se carga ULTIMO, despues del trigger,
-- para que los empleados iniciales tambien aparezcan en
-- Historial_salario (tipo_evento='INSERT').
-- =========================================================

USE Restaurante;

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
