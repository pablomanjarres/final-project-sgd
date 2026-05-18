const pool = require('../db');

const SELECT_FIELDS =
  'e.codigo_empleado, e.codigo_restaurante, e.nombre, e.apellidos, e.DNI, ' +
  'e.fecha_nacimiento, e.correo, e.cargo, e.fecha_ingreso, e.salario, ' +
  'r.nombre AS restaurante_nombre';

async function findAll() {
  const [rows] = await pool.query(
    `SELECT ${SELECT_FIELDS}
       FROM Empleado e
       JOIN Restaurante r ON r.codigo_restaurante = e.codigo_restaurante
      ORDER BY e.codigo_empleado`
  );
  return rows;
}

async function findById(id) {
  const [rows] = await pool.query(
    `SELECT ${SELECT_FIELDS}
       FROM Empleado e
       JOIN Restaurante r ON r.codigo_restaurante = e.codigo_restaurante
      WHERE e.codigo_empleado = ?`,
    [id]
  );
  return rows[0] || null;
}

async function create(data) {
  const {
    codigo_restaurante, nombre, apellidos, DNI,
    fecha_nacimiento, correo, cargo, fecha_ingreso, salario,
  } = data;
  const [result] = await pool.query(
    `INSERT INTO Empleado
       (codigo_restaurante, nombre, apellidos, DNI,
        fecha_nacimiento, correo, cargo, fecha_ingreso, salario)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      Number(codigo_restaurante), nombre, apellidos, DNI,
      fecha_nacimiento, correo || null, cargo, fecha_ingreso, Number(salario),
    ]
  );
  return result.insertId;
}

async function update(id, data) {
  const {
    codigo_restaurante, nombre, apellidos, DNI,
    fecha_nacimiento, correo, cargo, fecha_ingreso, salario,
  } = data;
  await pool.query(
    `UPDATE Empleado
        SET codigo_restaurante = ?, nombre = ?, apellidos = ?, DNI = ?,
            fecha_nacimiento = ?, correo = ?, cargo = ?,
            fecha_ingreso = ?, salario = ?
      WHERE codigo_empleado = ?`,
    [
      Number(codigo_restaurante), nombre, apellidos, DNI,
      fecha_nacimiento, correo || null, cargo, fecha_ingreso, Number(salario),
      id,
    ]
  );
}

async function remove(id) {
  await pool.query('DELETE FROM Empleado WHERE codigo_empleado = ?', [id]);
}

async function findHistorial(id) {
  const [rows] = await pool.query(
    `SELECT id_historial, salario_anterior, salario_nuevo, tipo_evento, fecha_evento
       FROM Historial_salario
      WHERE codigo_empleado = ?
      ORDER BY fecha_evento DESC, id_historial DESC`,
    [id]
  );
  return rows;
}

module.exports = { findAll, findById, create, update, remove, findHistorial };
