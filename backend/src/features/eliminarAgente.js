import { db } from '../configuracion/db.js';
import { PATRON_DNI } from '../utils/constantes.js';

export function eliminarAgente(req, res) {
  try {
    const { dni } = req.params;

    if (!PATRON_DNI.test(dni)) {
      res.status(400).json({ message: 'DNI inválido' });
      return;
    }

    const agente = db.prepare('SELECT dni FROM agente WHERE dni = ?').get(dni);

    if (!agente) {
      res.status(404).json({ message: 'Agente no encontrado' });
      return;
    }

    const { cantidad } = db
      .prepare('SELECT COUNT(*) AS cantidad FROM ticket WHERE dni_agente = ?')
      .get(dni);

    if (cantidad > 0) {
      res.status(409).json({ message: 'El agente tiene tickets asignados' });
      return;
    }

    db.prepare('DELETE FROM agente WHERE dni = ?').run(dni);

    res.status(204).end();
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}
