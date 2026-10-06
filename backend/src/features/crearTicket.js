import { db } from '../configuracion/db.js';
import { CATEGORIAS_VALIDAS, PATRON_DNI } from '../utils/constantes.js';

function validarTicketNuevo(body) {
  const { dni_cliente, categoria, descripcion } = body;

  if (!dni_cliente || !categoria || !descripcion) {
    return 'Complete todos los campos';
  }

  if (!PATRON_DNI.test(dni_cliente)) {
    return 'DNI inválido';
  }

  if (!CATEGORIAS_VALIDAS.includes(categoria)) {
    return 'Categoría inválida';
  }

  return null;
}

function elegirAgenteAlAzar() {
  return db.prepare('SELECT dni, nombre FROM agente ORDER BY RANDOM() LIMIT 1').get();
}

function mapearTicket(fila, agente) {
  return {
    id: fila.id,
    dni_cliente: fila.dni_cliente,
    categoria: fila.categoria,
    descripcion: fila.descripcion,
    estado: fila.estado,
    fecha_inicio: fila.fecha_inicio,
    fecha_finalizacion: fila.fecha_finalizacion,
    agente: {
      dni: agente.dni,
      nombre: agente.nombre
    }
  };
}

export function crearTicket(req, res) {
  try {
    const error = validarTicketNuevo(req.body);

    if (error) {
      res.status(400).json({ message: error });
      return;
    }

    const agente = elegirAgenteAlAzar();

    if (!agente) {
      res.status(409).json({ message: 'No hay agentes disponibles' });
      return;
    }

    const { dni_cliente, categoria, descripcion } = req.body;
    const fechaInicio = new Date().toISOString();

    const resultado = db
      .prepare(
        `INSERT INTO ticket (dni_agente, dni_cliente, categoria, descripcion, fecha_inicio)
         VALUES (?, ?, ?, ?, ?)`
      )
      .run(agente.dni, dni_cliente, categoria, descripcion, fechaInicio);

    const fila = db
      .prepare(
        `SELECT id, dni_cliente, categoria, descripcion, estado, fecha_inicio, fecha_finalizacion
         FROM ticket WHERE id = ?`
      )
      .get(resultado.lastInsertRowid);

    res.status(201).json(mapearTicket(fila, agente));
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}