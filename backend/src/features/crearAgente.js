import { db } from '../configuracion/db.js';
import { PATRON_DNI } from '../utils/constantes.js';

function validarAgenteNuevo(body) {
  const { dni, nombre } = body;

  if (!dni || !nombre || !String(nombre).trim()) {
    return 'Complete todos los campos';
  }

  if (!PATRON_DNI.test(dni)) {
    return 'DNI inválido';
  }

  return null;
}

export function crearAgente(req, res) {
  try {
    const error = validarAgenteNuevo(req.body ?? {});

    if (error) {
      res.status(400).json({ message: error });
      return;
    }

    const dni = req.body.dni;
    const nombre = req.body.nombre.trim();

    const existente = db.prepare('SELECT dni FROM agente WHERE dni = ?').get(dni);

    if (existente) {
      res.status(409).json({ message: 'El agente ya existe' });
      return;
    }

    db.prepare('INSERT INTO agente (dni, nombre) VALUES (?, ?)').run(dni, nombre);

    res.status(201).json({ dni, nombre });
  } catch (excepcion) {
    res.status(500).json({ message: 'Error interno' });
  }
}
