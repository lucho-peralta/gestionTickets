import { db } from '../configuracion/db.js';
import { ESTADOS_VALIDOS } from '../utils/constantes.js';

export function actualizarEstado(req, res) {
  try {
    const id = Number(req.params.id);
    const { estado } = req.body;

    if (Number.isNaN(id)) {
      res.status(404).json({ message: 'Ticket no encontrado' });
      return;
    }

    if (!ESTADOS_VALIDOS.includes(estado)) {
      res.status(400).json({ message: 'Estado inválido' });
      return;
    }

  
    let fechaFinalizacion = null;
    let query = `UPDATE ticket SET estado = ? WHERE id = ?`;
    let parametros = [estado, id];

    if (estado === 'cerrado') {
      fechaFinalizacion = new Date().toISOString();
      query = `UPDATE ticket SET estado = ?, fecha_finalizacion = ? WHERE id = ?`;
      parametros = [estado, fechaFinalizacion, id];
    }

    const resultado = db.prepare(query).run(...parametros);


    if (resultado.changes === 0) {
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
