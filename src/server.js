const path = require('path');
const express = require('express');
const methodOverride = require('method-override');
require('dotenv').config();

const restaurantesRouter = require('./routes/restaurantes');
const empleadosRouter = require('./routes/empleados');
const platosRouter = require('./routes/platos');
const reportesRouter = require('./routes/reportes');

const app = express();

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(express.urlencoded({ extended: true }));
app.use(methodOverride('_method'));
app.use(express.static(path.join(__dirname, '..', 'public')));

app.use((req, res, next) => {
  res.locals.flash = null;
  next();
});

app.get('/', (req, res) => {
  res.render('index');
});

app.use('/restaurantes', restaurantesRouter);
app.use('/empleados', empleadosRouter);
app.use('/platos', platosRouter);
app.use('/reportes', reportesRouter);

app.use((req, res) => {
  res.status(404).render('error', { message: 'Pagina no encontrada' });
});

app.use((err, req, res, next) => {
  console.error(err);
  const message = err.sqlMessage || err.message || 'Error interno';
  res.status(500).render('error', { message });
});

const port = Number(process.env.PORT) || 3000;
app.listen(port, () => {
  console.log(`Sabor & Tradicion corriendo en http://localhost:${port}`);
});
