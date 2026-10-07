import 'dotenv/config';
import 'dotenv/config';
import express from 'express';
import { crearTicket } from './features/crearTicket.js';
import { obtenerTicket } from './features/obtenerTicket.js';
import { actualizarEstado } from './features/actualizarEstado.js';
import { topCategorias } from './features/topCategorias.js';
import { tiempoPromedioResolucion } from './features/tiempoPromedioResolucion.js';
import { ticketsCliente } from './features/ticketsCliente.js';
import { ticketsAgente } from './features/ticketsAgente.js';
import { frecuenciaCategorias } from './features/frecuenciaCategorias.js';

export const app = express();

app.use(express.json());


// rutas tickets
app.post('/tickets', crearTicket);
app.get('/tickets/:id', obtenerTicket);
app.patch('/tickets/:id/estado', actualizarEstado);

// rutas clientes
app.get('/clientes/:dni/tickets', ticketsCliente);

// rutas agentes
app.get('/agentes/:dni/tickets', ticketsAgente);

// Rutas de reportes
app.get('/reportes/frecuencia-categorias', frecuenciaCategorias);
app.get('/reportes/top-categorias', topCategorias);
app.get('/reportes/tiempo-promedio-resolucion', tiempoPromedioResolucion);


// server

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});

