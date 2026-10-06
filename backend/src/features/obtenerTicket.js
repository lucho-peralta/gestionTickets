import { db } from '../configuracion/db.js';

export function obtenerTicket(req, res) {
  try {
    const id = Number(req.params.id);

    if (Number.isNaN(id)) {
      res.status(404).json({ message: 'Ticket no encontrado' });
      return;
    }

    const fila = db
      .prepare(
        `SELECT t.id, t.dni_cliente, t.categoria, t.descripcion, t.estado,
                t.fecha_inicio, t.fecha_finalizacion,
                a.dni AS agente_dni, a.nombre AS agente_nombre
         FROM ticket t
         JOIN agente a ON a.dni = t.dni_agente
         WHERE t.id = ?`
      )
      .get(id);

    if (!fila) {
      res.status(404).json({ message: 'Ticket no encontrado' });
      return;
    }

    res.status(200).json({
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
    });
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}