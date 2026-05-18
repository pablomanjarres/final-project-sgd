const pool = require('../db');

async function findAll() {
  const [rows] = await pool.query(
    'SELECT codigo_restaurante, nombre, calle, ciudad, pais, cap_maxima ' +
    'FROM Restaurante ORDER BY codigo_restaurante'
  );
  return rows;
}

async function findById(id) {
  const [rows] = await pool.query(
    'SELECT codigo_restaurante, nombre, calle, ciudad, pais, cap_maxima ' +
    'FROM Restaurante WHERE codigo_restaurante = ?',
    [id]
  );
  return rows[0] || null;
}

async function create({ nombre, calle, ciudad, pais, cap_maxima }) {
  const [result] = await pool.query(
    'INSERT INTO Restaurante (nombre, calle, ciudad, pais, cap_maxima) VALUES (?, ?, ?, ?, ?)',
    [nombre, calle, ciudad, pais, Number(cap_maxima)]
  );
  return result.insertId;
}

async function update(id, { nombre, calle, ciudad, pais, cap_maxima }) {
  await pool.query(
    'UPDATE Restaurante SET nombre = ?, calle = ?, ciudad = ?, pais = ?, cap_maxima = ? ' +
    'WHERE codigo_restaurante = ?',
    [nombre, calle, ciudad, pais, Number(cap_maxima), id]
  );
}

async function remove(id) {
  await pool.query('DELETE FROM Restaurante WHERE codigo_restaurante = ?', [id]);
}

module.exports = { findAll, findById, create, update, remove };
