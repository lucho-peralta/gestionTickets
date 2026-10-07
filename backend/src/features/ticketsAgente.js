import { db } from '../configuracion/db.js';
import { ESTADOS_VALIDOS, PATRON_DNI } from '../utils/constantes.js';

function mapearTicket(fila) {
  return {
    id: fila.id,
    dni_cliente: fila.dni_cliente,
    categoria: fila.categoria,
    descripcion: fila.descripcion,
    estado: fila.estado,
    fecha_inicio: fila.fecha_inicio,
    fecha_finalizacion: fila.fecha_finalizacion,
    agente: {
      dni: fila.agente_dni,
      nombre: fila.agente_nombre
    }
  };
}

export function ticketsAgente(req, res) {
  try {
    const { dni } = req.params;
    const estado = req.query.estado;

    // Validación 1: El DNI debe tener 7 u 8 dígitos
    if (!PATRON_DNI.test(dni)) {
      res.status(400).json({ message: 'DNI inválido' });
      return;
    }

    // Validación 2: Si viene el filtro, el estado debe estar dentro de la lista permitida
    if (estado !== undefined && !ESTADOS_VALIDOS.includes(estado)) {
      res.status(400).json({ message: 'Estado inválido' });
      return;
    }

    // Validación 3: El agente debe existir
    const agente = db.prepare('SELECT dni FROM agente WHERE dni = ?').get(dni);

    if (!agente) {
      res.status(404).json({ message: 'Agente no encontrado' });
      return;
    }

    // Bandeja de trabajo del agente, del ticket más antiguo al más reciente
    let consulta = `
      SELECT t.id, t.dni_cliente, t.categoria, t.descripcion, t.estado,
             t.fecha_inicio, t.fecha_finalizacion,
             a.dni AS agente_dni, a.nombre AS agente_nombre
      FROM ticket t
      JOIN agente a ON a.dni = t.dni_agente
      WHERE t.dni_agente = ?
    `;
    const parametros = [dni];

    if (estado) {
      consulta += ` AND t.estado = ?`;
      parametros.push(estado);
    }

    consulta += ` ORDER BY t.fecha_inicio ASC, t.id ASC`;

    const filas = db.prepare(consulta).all(...parametros);

    res.status(200).json(filas.map(mapearTicket));
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}
