const pool = require('../db');
const Restaurante = require('../models/restaurante');

exports.nominaForm = async (req, res, next) => {
  try {
    const restaurantes = await Restaurante.findAll();
    let resultado = null;
    let restauranteSeleccionado = null;

    if (req.query.codigo_restaurante) {
      const cod = Number(req.query.codigo_restaurante);
      const [rows] = await pool.query(
        'SELECT fn_nomina_restaurante(?) AS total',
        [cod]
      );
      resultado = rows[0].total;
      restauranteSeleccionado = restaurantes.find(r => r.codigo_restaurante === cod) || null;
    }

    res.render('reportes/nomina', {
      restaurantes,
      resultado,
      restauranteSeleccionado,
    });
  } catch (err) { next(err); }
};

exports.contratarForm = async (req, res, next) => {
  try {
    const restaurantes = await Restaurante.findAll();
    res.render('reportes/contratar', {
      restaurantes,
      error: null,
      datos: {},
      creado: null,
    });
  } catch (err) { next(err); }
};

exports.contratar = async (req, res, next) => {
  const restaurantes = await Restaurante.findAll().catch(() => []);
  try {
    const {
      codigo_restaurante, nombre, apellidos, DNI,
      fecha_nacimiento, correo, cargo, salario,
    } = req.body;

    const [result] = await pool.query(
      'CALL sp_contratar_empleado(?, ?, ?, ?, ?, ?, ?, ?, @nuevo_id)',
      [
        Number(codigo_restaurante), nombre, apellidos, DNI,
        fecha_nacimiento, correo || null, cargo, Number(salario),
      ]
    );

    const [out] = await pool.query('SELECT @nuevo_id AS id');
    const nuevoId = out[0].id;

    res.render('reportes/contratar', {
      restaurantes,
      error: null,
      datos: {},
      creado: { id: nuevoId, nombre, apellidos },
    });
  } catch (err) {
    res.render('reportes/contratar', {
      restaurantes,
      error: err.sqlMessage || err.message,
      datos: req.body,
      creado: null,
    });
  }
};
