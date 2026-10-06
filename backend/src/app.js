import 'dotenv/config';
import 'dotenv/config';
import express from 'express';
import { crearTicket } from './features/crearTicket.js';
import { obtenerTicket } from './features/obtenerTicket.js';

import { topCategorias } from './features/topCategorias.js';
import { tiempoPromedioResolucion } from './features/tiempoPromedioResolucion.js';

export const app = express();

app.use(express.json());


// rutas tickets
app.post('/tickets', crearTicket);
app.get('/tickets/:id', obtenerTicket);

// Rutas de reportes
app.get('/reportes/top-categorias', topCategorias);
app.get('/reportes/tiempo-promedio-resolucion', tiempoPromedioResolucion);


// server

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});

