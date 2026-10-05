# Hurl — Tests Happy Path

Batería de tests de la REST API escrita con [Hurl](https://hurl.dev). Cada archivo `.hurl` implementa el `.feature` del mismo nombre de la carpeta `gherkin/`; el escenario está copiado como comentario encima de cada pedido.

Los tests corren primero contra el **mock de Prism** (generado desde `documentacion/openapi/`) y después, sin cambios, contra el **back-end real**.

## Cómo funciona

```
documentacion/openapi/   ──(1) Redocly bundle──▶   bundle.yaml
                                                       │
                                               (2) Prism lo lee y queda
                                                   escuchando en :4010
                                                       │
hurl/*.hurl + env.mock   ──(3) Hurl manda pedidos──▶  Prism
```

1. **Redocly** junta los yaml de `documentacion/openapi/` en un solo archivo (`bundle.yaml`). Se corre una vez y termina; solo hay que repetirlo si se cambia el OpenAPI.
2. **Prism** lee `bundle.yaml` y queda corriendo como una API falsa en `http://localhost:4010`. Esa terminal queda ocupada.
3. **Hurl**, en otra terminal, manda los pedidos a la dirección que dice `env.mock` (Prism) o `env.dev` (back-end real).

## Requisitos

- [Node.js](https://nodejs.org) 18 o superior (para `npx`, Redocly y Prism).
- Hurl (ver instalación abajo).

## Instalación de Hurl

### Windows

```powershell
npm i -g @orangeopensource/hurl
```

o bien `winget install hurl`.

### Linux (Debian / Ubuntu)

```bash
VERSION=8.0.1
curl -LO "https://github.com/Orange-OpenSource/hurl/releases/download/${VERSION}/hurl_${VERSION}_amd64.deb"
sudo apt update && sudo apt install -y "./hurl_${VERSION}_amd64.deb"
rm "hurl_${VERSION}_amd64.deb"
```

Si la VM no es Debian/Ubuntu, o no tiene permisos de `sudo`, también funciona con npm: `npm i -g @orangeopensource/hurl`.

Para verificar: `hurl --version`.

## Ejecución contra el mock (Prism)

Los comandos son iguales en Windows y en Linux.

**Terminal 1** — desde la raíz del repo:

```bash
npx @redocly/cli bundle documentacion/openapi/main.yaml -o documentacion/openapi/bundle.yaml
npx @stoplight/prism-cli mock documentacion/openapi/bundle.yaml
```

Esperar a que Prism muestre `Prism is listening on http://127.0.0.1:4010` y dejar esa terminal abierta.

**Terminal 2** — dentro de `hurl/`:

```bash
hurl --jobs 1 --test --variables-file env.mock --glob "*.hurl"
```

Para cortar Prism: `Ctrl+C` en la terminal 1.

## Ejecución contra el back-end real

Con el back-end en `http://localhost:3000` y los agentes precargados, dentro de `hurl/`:

```bash
hurl --jobs 1 --test --variables-file env.dev --glob "*.hurl"
```

Acá no hacen falta ni Redocly ni Prism.

## Happy Path

```
001 - Crear                                     > ticket asignado
002 - Crear   | Obtener                         > asignado
003 - Crear   | Estado*3                        > en_proceso, en_revision, cerrado
004 - Crear   | Tickets cliente                 > [ticket creado primero]
005 - Crear   | Tickets agente  | Filtro estado > [asignado]
006 - Crear   | Frecuencia                      > 4 categorías
007 - Crear   | Cerrar          | Promedio*2    > tickets_cerrados >= 1
008 - Crear   | Top             | Top limite=2  > [3], [2]
```

## Problemas comunes

| Síntoma | Causa | Solución |
|---|---|---|
| `HTTP connection` en todos los tests | Prism (o el back-end) no está corriendo | Levantarlo en otra terminal antes de correr Hurl |
| `address already in use 127.0.0.1:4010` al levantar Prism | Ya hay otro Prism abierto | Cerrar la otra terminal (`Ctrl+C`) o usar otro puerto con `-p 4011` y cambiar `env.mock` |
| Un test falla después de cambiar el OpenAPI | Prism sigue usando el `bundle.yaml` viejo | Volver a correr el `bundle` y reiniciar Prism |
| `Cannot access '*.hurl'` | Se corrió Hurl fuera de la carpeta `hurl/` | Hacer `cd hurl` primero |

## Notas

- `header "sl-violations" not exists`: Prism agrega ese header cuando el pedido o la respuesta no cumplen el OpenAPI. Contra el back-end real el header no existe, así que el chequeo pasa.
- `Prefer: example=...`: le indica a Prism cuál de los ejemplos del OpenAPI devolver (si no, devuelve siempre el primero). El back-end real lo ignora.
- Cada archivo crea sus propios datos, así que no depende de los demás.
- `bundle.yaml` es un archivo generado: no hace falta subirlo al repo.
