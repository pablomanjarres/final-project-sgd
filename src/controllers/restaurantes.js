const Restaurante = require('../models/restaurante');

exports.index = async (req, res, next) => {
  try {
    const restaurantes = await Restaurante.findAll();
    res.render('restaurantes/index', { restaurantes });
  } catch (err) { next(err); }
};

exports.newForm = (req, res) => {
  res.render('restaurantes/form', { restaurante: null, action: '/restaurantes', method: 'POST' });
};

exports.create = async (req, res, next) => {
  try {
    await Restaurante.create(req.body);
    res.redirect('/restaurantes');
  } catch (err) { next(err); }
};

exports.editForm = async (req, res, next) => {
  try {
    const restaurante = await Restaurante.findById(req.params.id);
    if (!restaurante) return res.status(404).render('error', { message: 'Restaurante no existe' });
    res.render('restaurantes/form', {
      restaurante,
      action: `/restaurantes/${restaurante.codigo_restaurante}?_method=PUT`,
      method: 'POST',
    });
  } catch (err) { next(err); }
};

exports.update = async (req, res, next) => {
  try {
    await Restaurante.update(req.params.id, req.body);
    res.redirect('/restaurantes');
  } catch (err) { next(err); }
};

exports.remove = async (req, res, next) => {
  try {
    await Restaurante.remove(req.params.id);
    res.redirect('/restaurantes');
  } catch (err) { next(err); }
};
