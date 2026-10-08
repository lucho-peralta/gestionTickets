import { db } from '../configuracion/db.js';
import { CATEGORIAS_VALIDAS } from '../utils/constantes.js';

export function frecuenciaCategorias(req, res) {
  try {
    const filas = db
      .prepare(
        `SELECT categoria, COUNT(*) AS cantidad
         FROM ticket
         GROUP BY categoria`
      )
      .all();


    const reporte = CATEGORIAS_VALIDAS.map((categoria) => {
      const fila = filas.find((f) => f.categoria === categoria);
      return {
        categoria: categoria,
        cantidad: fila ? fila.cantidad : 0
      };
    });

    res.status(200).json(reporte);
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}
