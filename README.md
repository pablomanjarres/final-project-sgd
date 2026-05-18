# Sabor & Tradición · Tercera Entrega

Aplicación CRUD sobre el modelo de la cadena de restaurantes **Sabor & Tradición**, construida como tercera entrega del curso **Sistemas de Gestión de Bases de Datos** de la Universidad EAFIT (2026-1).

La entrega cubre los cuatro requerimientos del enunciado:

1. **CRUD aplicación** sobre tres tablas del modelo: `Restaurante`, `Empleado`, `Plato`.
2. **Un trigger** que audita los cambios de salario en una tabla `Historial_salario`.
3. **Una función** SQL (`fn_nomina_restaurante`) invocada desde la interfaz.
4. **Un procedimiento** SQL (`sp_contratar_empleado`) invocado desde la interfaz, con validaciones y manejo de errores.

## Equipo

| Integrante |
|---|
| Valentina Barbosa Quilindo |
| Pablo Manjarres Negrette | 
| Sofía Marín Bustamante |

Profesora: Bibiana María Rodríguez Castrillón.

## Stack

- **Backend:** Node.js (≥18) + Express 4
- **Vistas:** EJS (server-rendered) + CSS plano
- **Base de datos:** MySQL 8 (`mysql2/promise`)

## Estructura

```
.
├── package.json
├── .env.example
├── README.md
├── sql/
│   ├── 00_schema.sql              # crea la BD `Restaurante` (Segunda Entrega)
│   ├── 01_historial_salario.sql   # tabla de auditoría
│   ├── 02_trigger.sql             # dos triggers sobre Empleado
│   ├── 03_function.sql            # fn_nomina_restaurante
│   ├── 04_procedure.sql           # sp_contratar_empleado
│   └── 05_seed.sql                # datos semilla (corre último para que el trigger los registre)
├── public/css/styles.css
├── tasks/todo.md                  # checklist y notas de desarrollo
└── src/
    ├── server.js                  # bootstrap Express
    ├── db.js                      # pool mysql2/promise
    ├── routes/                    # mapeo URL → controller
    ├── controllers/               # orquestación HTTP
    ├── models/                    # queries SQL por tabla
    └── views/                     # plantillas EJS
        ├── partials/
        ├── restaurantes/
        ├── empleados/
        ├── platos/
        └── reportes/
```

## Modelo de datos

Las cinco entidades fuertes vienen directamente de la Segunda Entrega:

- **Restaurante** (`codigo_restaurante`, nombre, calle, ciudad, país, cap_máxima)
- **Empleado** (`codigo_empleado`, FK `codigo_restaurante`, nombre, apellidos, DNI único, fecha_nacimiento, correo, cargo, fecha_ingreso, salario)
- **Plato** (`codigo_plato`, nombre, descripción, precio_base, categoría ENUM, tiempo_prep)
- **Ingrediente** (`codigo_ingrediente`, nombre, costo_unitario, tipo)
- **Proveedor** (`codigo_proveedor`, nombre, NIT único, dirección, correo)

Más las tablas multivaluadas `Telefonos_*` y las relacionales `Plato_en_Restaurante`, `Ingrediente_en_Plato`, `Ingrediente_por_Proveedor`. La app solo expone formularios para Restaurante, Empleado y Plato. El resto del schema queda intacto para que otras consultas funcionen.

La tabla nueva agregada en esta entrega es **`Historial_salario`** (la dispara el trigger):

```sql
CREATE TABLE Historial_salario (
  id_historial      INT AUTO_INCREMENT PRIMARY KEY,
  codigo_empleado   INT          NOT NULL,
  salario_anterior  DECIMAL(10,2),
  salario_nuevo     DECIMAL(10,2) NOT NULL,
  tipo_evento       ENUM('INSERT','UPDATE') NOT NULL,
  fecha_evento      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (codigo_empleado) REFERENCES Empleado(codigo_empleado)
    ON UPDATE CASCADE ON DELETE CASCADE
);
```

## Detalle de los objetos SQL

### Trigger (dos definiciones)

MySQL no soporta `AFTER INSERT OR UPDATE` en un único `CREATE TRIGGER`, así que se definen dos disparadores que escriben a `Historial_salario`:

- `trg_empleado_after_insert`: al crear un empleado registra `tipo_evento='INSERT'` con `salario_anterior = NULL`.
- `trg_empleado_after_update`: al actualizar, **solo registra si cambia el salario** (`IF OLD.salario <> NEW.salario`). Esto evita ruido cuando se edita otro campo.

### Función: `fn_nomina_restaurante`

```sql
fn_nomina_restaurante(p_codigo_restaurante INT) RETURNS DECIMAL(14,2)
```

Devuelve la suma de salarios de los empleados asignados al restaurante. `COALESCE` retorna 0 cuando no hay empleados. Marcada `DETERMINISTIC READS SQL DATA` para ser compatible con `log_bin_trust_function_creators = 0`.

Invocación desde la app:

```js
const [rows] = await pool.query(
  'SELECT fn_nomina_restaurante(?) AS total', [codigoRestaurante]
);
```

### Procedimiento: `sp_contratar_empleado`

```sql
sp_contratar_empleado(
  IN  p_codigo_restaurante INT,
  IN  p_nombre, p_apellidos, p_DNI, p_correo, p_cargo VARCHAR,
  IN  p_fecha_nacimiento DATE,
  IN  p_salario DECIMAL(10,2),
  OUT p_codigo_empleado INT
)
```

Tres validaciones, cada una lanza `SIGNAL SQLSTATE '45000'`:

1. `salario >= 1.300.000` (salario mínimo legal en Colombia).
2. El restaurante con ese código existe.
3. No hay otro empleado con el mismo DNI.

Si todo pasa, hace el `INSERT` y devuelve el `codigo_empleado` generado por `LAST_INSERT_ID()`. La `fecha_ingreso` se asigna automáticamente con `CURDATE()`.

Invocación desde la app (los errores se propagan a Node y se muestran en la UI):

```js
await pool.query(
  'CALL sp_contratar_empleado(?,?,?,?,?,?,?,?,@id)', [...]
);
const [[{ id }]] = await pool.query('SELECT @id AS id');
```

## Setup local

### 1. Requisitos

- Node.js 18+
- MySQL 8+ corriendo en `localhost:3306`
- npm

### 2. Cargar la base de datos

Desde la raíz del proyecto:

```bash
mysql -u root < sql/00_schema.sql               # crea BD Restaurante
mysql -u root Restaurante < sql/01_historial_salario.sql
mysql -u root Restaurante < sql/02_trigger.sql
mysql -u root Restaurante < sql/03_function.sql
mysql -u root Restaurante < sql/04_procedure.sql
mysql -u root Restaurante < sql/05_seed.sql     # carga datos despues del trigger
```

El orden importa: los seeds van al final para que el trigger registre cada `INSERT` inicial en `Historial_salario`. Si tu MySQL tiene password, agregá `-p` en cada comando.

### 3. Configurar y arrancar la app

```bash
cp .env.example .env       # ajustá DB_USER y DB_PASS si hace falta
npm install
npm start
```

Abrir [http://localhost:3000](http://localhost:3000).

### 4. Setup en Windows

Los pasos anteriores asumen un shell tipo bash (macOS o Linux). En Windows hay tres ajustes:

**a) Asegurate de que `mysql` esté en el PATH.** El instalador de MySQL no siempre lo agrega. Verificá con:

```
where mysql
```

Si no aparece nada, agregá `C:\Program Files\MySQL\MySQL Server 8.0\bin` al PATH del sistema (Configuración → Sistema → Acerca de → Configuración avanzada del sistema → Variables de entorno) y abrí una nueva ventana de terminal.

**b) Cargar la base de datos** (`cmd.exe` o PowerShell):

```
mysql -u root < sql\00_schema.sql
mysql -u root Restaurante < sql\01_historial_salario.sql
mysql -u root Restaurante < sql\02_trigger.sql
mysql -u root Restaurante < sql\03_function.sql
mysql -u root Restaurante < sql\04_procedure.sql
mysql -u root Restaurante < sql\05_seed.sql
```

**c) Copiar el archivo de configuración y arrancar:**

En `cmd.exe`:
```
copy .env.example .env
notepad .env
npm install
npm start
```

En PowerShell:
```
Copy-Item .env.example .env
notepad .env
npm install
npm start
```

El resto es idéntico: abrir [http://localhost:3000](http://localhost:3000).

## Mapa de rutas

| Ruta | Método | Función |
|---|---|---|
| `/` | GET | Landing con accesos directos |
| `/restaurantes` | GET | Lista |
| `/restaurantes/new` | GET / POST | Crear |
| `/restaurantes/:id/edit` | GET / PUT | Editar |
| `/restaurantes/:id` | DELETE | Eliminar |
| `/empleados` | GET | Lista (con JOIN al restaurante) |
| `/empleados/new` | GET / POST | Crear (dispara trigger INSERT) |
| `/empleados/:id/edit` | GET / PUT | Editar (dispara trigger UPDATE si cambia salario) |
| `/empleados/:id` | DELETE | Eliminar |
| `/empleados/:id/historial` | GET | Historial de un empleado puntual |
| `/reportes/historial` | GET | **Visor global del trigger** (todas las filas de `Historial_salario`) |
| `/platos` | GET | Lista |
| `/platos/new` | GET / POST | Crear |
| `/platos/:id/edit` | GET / PUT | Editar |
| `/platos/:id` | DELETE | Eliminar |
| `/reportes/nomina` | GET | **Invoca la función** |
| `/reportes/contratar` | GET / POST | **Invoca el procedimiento** |

## Verificación previa

El proyecto se probó end-to-end antes de subir:

- `npm install` instala 91 paquetes.
- `node --check` pasa para los 13 archivos JS.
- `ejs.compile` pasa para las 13 plantillas.
- Las 4 sentencias SQL cargan limpio sobre el schema `Restaurante`.
- Las 3 validaciones del procedimiento devuelven `ERROR 1644 (45000)`.
- El trigger registra correctamente INSERT y UPDATE, y se abstiene cuando el salario no cambia.
- Las 8 rutas HTTP responden 200.
- `fn_nomina_restaurante(1)` devuelve `$4.700.000` con el seed inicial (coincide con `SUM(salario)`).

## Notas y decisiones de diseño

- **Por qué dos triggers en vez de uno:** MySQL define cada trigger por la dupla (timing, event). No existe `AFTER INSERT OR UPDATE`.
- **Por qué `IF OLD.salario <> NEW.salario`:** Para no contaminar el historial cuando solo se edita cargo, correo, etc.
- **Por qué el procedimiento tiene su propia página separada del CRUD normal:** El CRUD usa `INSERT` directo (más simple). El procedimiento se invoca aparte para que la sustentación pueda mostrarlo aislado y exhibir sus validaciones.
- **Por qué `fecha_ingreso = CURDATE()` dentro del procedimiento:** El procedimiento simula una contratación oficial, así que la fecha no es parámetro. En el CRUD normal sí se pide.
- **Por qué `dateStrings: true` en el pool:** Para que `mysql2` devuelva las fechas como `'YYYY-MM-DD'` strings y se puedan repintar directamente en los `<input type="date">` sin conversión.

## Licencia

Proyecto académico. Universidad EAFIT, curso ST0247 / SI4002, Sistemas de Gestión de Bases de Datos, semestre 2026-1.
