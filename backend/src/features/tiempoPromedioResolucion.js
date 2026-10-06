import { db } from '../configuracion/db.js';

export function tiempoPromedioResolucion(req, res) {
  try {
    const categoria = req.query.categoria || null;

    let consulta = `
      SELECT 
        COUNT(id) AS tickets_cerrados,
        IFNULL(AVG((julianday(fecha_finalizacion) - julianday(fecha_inicio)) * 24), 0) AS promedio_horas
      FROM ticket
      WHERE estado = 'cerrado'
    `;

    let fila;

    if (categoria) {
      consulta += ` AND categoria = ?`;
      fila = db.prepare(consulta).get(categoria); // .get() para una sola fila de resultados[cite: 3, 4]
    } else {
      fila = db.prepare(consulta).get();
    }

    res.status(200).json({
      categoria: categoria,
      tickets_cerrados: fila.tickets_cerrados,
      promedio_horas: fila.promedio_horas
    });
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}
