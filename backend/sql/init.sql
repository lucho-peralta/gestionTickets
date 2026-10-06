CREATE TABLE agente (
    dni     TEXT PRIMARY KEY,
    nombre  TEXT NOT NULL
);

CREATE TABLE ticket (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    dni_agente          TEXT NOT NULL REFERENCES agente (dni),
    dni_cliente         TEXT NOT NULL,
    categoria           TEXT NOT NULL
                        CHECK (categoria IN ('conexion', 'facturacion', 'consulta_general', 'otro')),
    descripcion         TEXT NOT NULL CHECK (length(trim(descripcion)) > 0),
    fecha_inicio        TEXT NOT NULL,
    fecha_finalizacion  TEXT,
    estado              TEXT NOT NULL DEFAULT 'asignado'
                        CHECK (estado IN ('asignado', 'en_proceso', 'en_revision', 'cerrado'))
);

CREATE INDEX idx_ticket_dni_cliente ON ticket (dni_cliente);
CREATE INDEX idx_ticket_dni_agente  ON ticket (dni_agente);

INSERT INTO agente (dni, nombre) VALUES
    ('25987654', 'María Gómez'),
    ('28555111', 'Carlos Pérez'),
    ('31444222', 'Lucía Fernández');