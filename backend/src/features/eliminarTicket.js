import { db } from '../configuracion/db.js';

export function eliminarTicket(req, res) {
  try {
    const id = Number(req.params.id);

    if (!Number.isInteger(id)) {
      res.status(404).json({ message: 'Ticket no encontrado' });
      return;
    }

    const resultado = db.prepare('DELETE FROM ticket WHERE id = ?').run(id);

    if (resultado.changes === 0) {
      res.status(404).json({ message: 'Ticket no encontrado' });
      return;
    }

    res.status(204).end();
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}
