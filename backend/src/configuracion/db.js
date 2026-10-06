import Database from 'better-sqlite3';
import { existsSync, mkdirSync, readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const carpetaDatos = join(__dirname, '..', '..', 'data');
const archivoBaseDeDatos = join(carpetaDatos, 'tickets.db');
const archivoEsquema = join(__dirname, '..', '..', 'sql', 'init.sql');

function crearCarpetaDatosSiNoExiste() {
  if (!existsSync(carpetaDatos)) {
    mkdirSync(carpetaDatos);
  }
}

function inicializarEsquemaSiHaceFalta(baseDeDatos) {
  const tablaTicketExiste = baseDeDatos
    .prepare("SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'ticket'")
    .get();

  if (!tablaTicketExiste) {
    const esquema = readFileSync(archivoEsquema, 'utf-8');
    baseDeDatos.exec(esquema);
  }
}

crearCarpetaDatosSiNoExiste();

export const db = new Database(archivoBaseDeDatos);

db.pragma('foreign_keys = ON');

inicializarEsquemaSiHaceFalta(db);