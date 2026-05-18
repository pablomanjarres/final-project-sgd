const Plato = require('../models/plato');

exports.index = async (req, res, next) => {
  try {
    const platos = await Plato.findAll();
    res.render('platos/index', { platos });
  } catch (err) { next(err); }
};

exports.newForm = (req, res) => {
  res.render('platos/form', {
    plato: null,
    categorias: Plato.CATEGORIAS,
    action: '/platos',
    method: 'POST',
  });
};

exports.create = async (req, res, next) => {
  try {
    await Plato.create(req.body);
    res.redirect('/platos');
  } catch (err) { next(err); }
};

exports.editForm = async (req, res, next) => {
  try {
    const plato = await Plato.findById(req.params.id);
    if (!plato) return res.status(404).render('error', { message: 'Plato no existe' });
    res.render('platos/form', {
      plato,
      categorias: Plato.CATEGORIAS,
      action: `/platos/${plato.codigo_plato}?_method=PUT`,
      method: 'POST',
    });
  } catch (err) { next(err); }
};

exports.update = async (req, res, next) => {
  try {
    await Plato.update(req.params.id, req.body);
    res.redirect('/platos');
  } catch (err) { next(err); }
};

exports.remove = async (req, res, next) => {
  try {
    await Plato.remove(req.params.id);
    res.redirect('/platos');
  } catch (err) { next(err); }
};
