import { db } from '../configuracion/db.js';
import { PATRON_DNI } from '../utils/constantes.js';

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

export function ticketsCliente(req, res) {
  try {
    const { dni } = req.params;

    if (!PATRON_DNI.test(dni)) {
      res.status(400).json({ message: 'DNI inválido' });
      return;
    }

  
    const filas = db
      .prepare(
        `SELECT t.id, t.dni_cliente, t.categoria, t.descripcion, t.estado,
                t.fecha_inicio, t.fecha_finalizacion,
                a.dni AS agente_dni, a.nombre AS agente_nombre
         FROM ticket t
         JOIN agente a ON a.dni = t.dni_agente
         WHERE t.dni_cliente = ?
         ORDER BY t.fecha_inicio DESC, t.id DESC`
      )
      .all(dni);

    res.status(200).json(filas.map(mapearTicket));
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}
