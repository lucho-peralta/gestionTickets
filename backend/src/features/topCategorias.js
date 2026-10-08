import { db } from '../configuracion/db.js';

export function topCategorias(req, res) {
  try {
    const limiteStr = req.query.limite;
    let limite = 3;

    if (limiteStr !== undefined) {
      const limiteParseado = Number(limiteStr);
      if (!Number.isInteger(limiteParseado) || limiteParseado < 1 || limiteParseado > 4) {
        res.status(400).json({ message: 'Límite inválido' });
        return;
      }
      limite = limiteParseado;
    }

    const filas = db
      .prepare(
        `SELECT categoria, COUNT(*) AS cantidad 
         FROM ticket 
         GROUP BY categoria 
         ORDER BY cantidad DESC 
         LIMIT ?`
      )
      .all(limite); 

    res.status(200).json(filas);
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}
