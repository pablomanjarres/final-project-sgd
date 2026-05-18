const express = require('express');
const ctrl = require('../controllers/restaurantes');

const router = express.Router();

router.get('/', ctrl.index);
router.get('/new', ctrl.newForm);
router.post('/', ctrl.create);
router.get('/:id/edit', ctrl.editForm);
router.put('/:id', ctrl.update);
router.delete('/:id', ctrl.remove);

module.exports = router;
