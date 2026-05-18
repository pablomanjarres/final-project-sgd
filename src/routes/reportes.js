const express = require('express');
const ctrl = require('../controllers/reportes');

const router = express.Router();

router.get('/nomina', ctrl.nominaForm);
router.get('/contratar', ctrl.contratarForm);
router.post('/contratar', ctrl.contratar);

module.exports = router;
