const pool = require('../db');

const CATEGORIAS = ['entrada', 'plato fuerte', 'postre', 'bebida'];

async function findAll() {
  const [rows] = await pool.query(
    'SELECT codigo_plato, nombre, descripcion, precio_base, categoria, tiempo_prep ' +
    'FROM Plato ORDER BY codigo_plato'
  );
  return rows;
}

async function findById(id) {
  const [rows] = await pool.query(
    'SELECT codigo_plato, nombre, descripcion, precio_base, categoria, tiempo_prep ' +
    'FROM Plato WHERE codigo_plato = ?',
    [id]
  );
  return rows[0] || null;
}

async function create({ nombre, descripcion, precio_base, categoria, tiempo_prep }) {
  const [result] = await pool.query(
    'INSERT INTO Plato (nombre, descripcion, precio_base, categoria, tiempo_prep) ' +
    'VALUES (?, ?, ?, ?, ?)',
    [nombre, descripcion || null, Number(precio_base), categoria, Number(tiempo_prep)]
  );
  return result.insertId;
}

async function update(id, { nombre, descripcion, precio_base, categoria, tiempo_prep }) {
  await pool.query(
    'UPDATE Plato SET nombre = ?, descripcion = ?, precio_base = ?, ' +
    'categoria = ?, tiempo_prep = ? WHERE codigo_plato = ?',
    [nombre, descripcion || null, Number(precio_base), categoria, Number(tiempo_prep), id]
  );
}

async function remove(id) {
  await pool.query('DELETE FROM Plato WHERE codigo_plato = ?', [id]);
}

module.exports = { findAll, findById, create, update, remove, CATEGORIAS };
