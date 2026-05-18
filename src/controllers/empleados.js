const Empleado = require('../models/empleado');
const Restaurante = require('../models/restaurante');

exports.index = async (req, res, next) => {
  try {
    const empleados = await Empleado.findAll();
    res.render('empleados/index', { empleados });
  } catch (err) { next(err); }
};

exports.newForm = async (req, res, next) => {
  try {
    const restaurantes = await Restaurante.findAll();
    res.render('empleados/form', {
      empleado: null,
      restaurantes,
      action: '/empleados',
      method: 'POST',
    });
  } catch (err) { next(err); }
};

exports.create = async (req, res, next) => {
  try {
    await Empleado.create(req.body);
    res.redirect('/empleados');
  } catch (err) { next(err); }
};

exports.editForm = async (req, res, next) => {
  try {
    const empleado = await Empleado.findById(req.params.id);
    if (!empleado) return res.status(404).render('error', { message: 'Empleado no existe' });
    const restaurantes = await Restaurante.findAll();
    res.render('empleados/form', {
      empleado,
      restaurantes,
      action: `/empleados/${empleado.codigo_empleado}?_method=PUT`,
      method: 'POST',
    });
  } catch (err) { next(err); }
};

exports.update = async (req, res, next) => {
  try {
    await Empleado.update(req.params.id, req.body);
    res.redirect('/empleados');
  } catch (err) { next(err); }
};

exports.remove = async (req, res, next) => {
  try {
    await Empleado.remove(req.params.id);
    res.redirect('/empleados');
  } catch (err) { next(err); }
};

exports.historial = async (req, res, next) => {
  try {
    const empleado = await Empleado.findById(req.params.id);
    if (!empleado) return res.status(404).render('error', { message: 'Empleado no existe' });
    const historial = await Empleado.findHistorial(req.params.id);
    res.render('empleados/historial', { empleado, historial });
  } catch (err) { next(err); }
};
