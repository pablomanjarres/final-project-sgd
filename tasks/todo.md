# Tercera Entrega — Sabor & Tradición

## Stack
- Node.js + Express + EJS + mysql2/promise + method-override + dotenv
- MySQL schema `Restaurante` (ya existe, viene de la Segunda Entrega)

## Tablas con CRUD
- [x] Restaurante (codigo_restaurante, nombre, calle, ciudad, pais, cap_maxima)
- [x] Empleado (codigo_empleado, codigo_restaurante FK, nombre, apellidos, DNI, fecha_nacimiento, correo, cargo, fecha_ingreso, salario)
- [x] Plato (codigo_plato, nombre, descripcion, precio_base, categoria, tiempo_prep)

## Objetos SQL nuevos
- [x] Tabla `Historial_salario` (auditoría)
- [x] Trigger `trg_empleado_after_insert` (log inicial)
- [x] Trigger `trg_empleado_after_update` (log si cambia salario)
- [x] Función `fn_nomina_restaurante(cod) → DECIMAL`
- [x] Procedimiento `sp_contratar_empleado(...)` con tres validaciones

## App
- [x] package.json + dependencias
- [x] db.js (pool mysql2)
- [x] server.js (Express + views + method-override)
- [x] models/{restaurante,empleado,plato}.js
- [x] controllers/{restaurantes,empleados,platos,reportes}.js
- [x] routes/{restaurantes,empleados,platos,reportes}.js
- [x] views/layout + index + CRUD por tabla + reportes
- [x] CSS mínimo

## Entregables
- [x] sql/01_historial_salario.sql
- [x] sql/02_trigger.sql
- [x] sql/03_function.sql
- [x] sql/04_procedure.sql
- [x] README con instrucciones de instalación y demo

## Review

**Estado:** completo.

**Qué se verificó:**
- `npm install` instaló 91 paquetes sin errores.
- `node --check` pasa para todos los archivos JS (13).
- `ejs.compile` pasa para todas las plantillas (13).
- El servidor levanta con credenciales falsas y `GET /` responde HTTP 200 (la ruta raíz no toca la DB, por lo que la falla de conexión solo se manifiesta al usar el CRUD).
- Las consultas SQL no se ejecutaron contra MySQL real porque el schema vive en tu Workbench local. Hay que correr los cuatro archivos de `sql/` en orden antes de hacer el demo.

**Decisiones de diseño relevantes:**
- Dos triggers (AFTER INSERT y AFTER UPDATE) en vez de uno — MySQL no soporta combinarlos.
- El `UPDATE` solo registra historial si `OLD.salario <> NEW.salario`, evita ruido.
- `sp_contratar_empleado` valida 3 condiciones con `SIGNAL SQLSTATE '45000'`; los errores se propagan a Node y se muestran en la UI (`/reportes/contratar`).
- `fn_nomina_restaurante` retorna 0 (no NULL) cuando el restaurante no tiene empleados — `COALESCE` adentro.
- El CRUD normal de Empleado usa INSERT directo. El procedimiento se invoca desde `/reportes/contratar` aparte, para que el demo de cada cosa sea aislado.

**Siguiente paso para la entrega:**
1. Ejecutar los 4 archivos SQL de `final-project/sql/` contra el schema `Restaurante`.
2. `cp .env.example .env` y ajustar `DB_USER`/`DB_PASS`.
3. `npm start` y seguir el guion de sustentación del README sección 4.
