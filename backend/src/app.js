import 'dotenv/config';
import 'dotenv/config';
import express from 'express';
import { crearTicket } from './features/crearTicket.js';
import { obtenerTicket } from './features/obtenerTicket.js';

export const app = express();

app.use(express.json());

app.post('/tickets', crearTicket);
app.get('/tickets/:id', obtenerTicket);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}`);
});

