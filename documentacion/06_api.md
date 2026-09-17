## Documentación de API REST (versión simplificada)

Diseño de la API REST del sistema, alineado al modelo simplificado de identificación por DNI y sin login tradicional.

### Base URL

```
https://api.ticketsystem.com
```

### Endpoints

| Recurso | Endpoint | Verbo | Descripción |
|---|---|---|---|
| Usuarios | `/usuarios` | POST | Crea un nuevo usuario (Cliente o Agente). Body: `nombre`, `dni`, `email`, `rol`. |
| Usuarios | `/usuarios/{dni}` | GET | Obtiene los datos de un usuario por DNI. |
| Tickets | `/tickets` | POST | Crea un ticket nuevo. Body: `dni_cliente`, `asunto`, `descripcion`, `categoria_id`, `adjuntos[]`. |
| Tickets | `/tickets` | GET | Lista tickets. Query params: `estado`, `categoria`, `orderBy=fecha`. |
| Tickets | `/tickets/{id}` | GET | Obtiene el detalle completo de un ticket, incluyendo historial. |
| Tickets | `/tickets/buscar?dni={dni}` | GET | Busca tickets asociados a un DNI, como Cliente o como Agente. |
| Tickets | `/tickets/{id}/estado` | PATCH | Actualiza el estado de un ticket. Body: `estado`. |
| Tickets | `/tickets/{id}/asignar` | PATCH | Asigna el ticket a un agente. Body: `dni_agente`. |
| Comentarios | `/tickets/{id}/comentarios` | GET | Lista los comentarios/interacciones de un ticket. |
| Comentarios | `/tickets/{id}/comentarios` | POST | Agrega un comentario al ticket. Body: `dni_autor`, `contenido`. |
| Categorías | `/categorias` | GET | Lista las categorías disponibles para clasificar tickets. |
| Reportes | `/reportes/resumen` | GET | Devuelve total de tickets, tickets por estado y categorías más frecuentes. |

### Detalle de operaciones

#### 1. Crear usuario

**POST** `/usuarios`

Body:
```json
{
  "nombre": "Nombre completo",
  "dni": "30111222",
  "email": "usuario@example.com",
  "rol": "Cliente"
}
```

Permite registrar usuarios con rol **Cliente** o **Agente**. El DNI debe ser único y no se requiere contraseña.

#### 2. Obtener usuario por DNI

**GET** `/usuarios/{dni}`

Permite obtener los datos del usuario identificado mediante DNI.

#### 3. Crear ticket

**POST** `/tickets`

Body:
```json
{
  "dni_cliente": "30111222",
  "asunto": "Problema con el servicio",
  "descripcion": "Descripción del problema",
  "categoria_id": 1,
  "adjuntos": []
}
```

El sistema genera un identificador único y asigna el estado inicial **Abierto**.

#### 4. Listar tickets

**GET** `/tickets`

Query params disponibles:
- `estado`
- `categoria`
- `orderBy=fecha`

Ejemplo:
```
/tickets?estado=En%20Progreso&orderBy=fecha
```

#### 5. Obtener detalle de un ticket

**GET** `/tickets/{id}`

Devuelve el detalle completo del ticket, incluyendo su historial.

#### 6. Buscar tickets por DNI

**GET** `/tickets/buscar?dni={dni}`

Busca los tickets asociados al DNI ingresado.
- Para un Cliente: devuelve los tickets creados por ese DNI.
- Para un Agente: devuelve los tickets asignados a ese DNI.

#### 7. Actualizar estado

**PATCH** `/tickets/{id}/estado`

Body:
```json
{
  "estado": "En Progreso"
}
```

Estados disponibles:
- Abierto
- En Progreso
- Esperando al Cliente
- Resuelto
- Cerrado

#### 8. Asignar ticket

**PATCH** `/tickets/{id}/asignar`

Body:
```json
{
  "dni_agente": "30999888"
}
```

El sistema registra quién asignó el ticket, a qué agente y la fecha/hora.

#### 9. Listar comentarios

**GET** `/tickets/{id}/comentarios`

Devuelve las interacciones o comentarios asociados al ticket.

#### 10. Agregar comentario

**POST** `/tickets/{id}/comentarios`

Body:
```json
{
  "dni_autor": "30111222",
  "contenido": "El problema continúa."
}
```

Registra autor, timestamp y contenido.

#### 11. Listar categorías

**GET** `/categorias`

Devuelve las categorías disponibles para clasificar tickets.

#### 12. Obtener reportes

**GET** `/reportes/resumen`

Devuelve:
- Cantidad total de tickets.
- Cantidad de tickets agrupados por estado.
- Categorías con mayor cantidad de tickets.

### Notas de Diseño

- Los recursos siguen la convención REST: sustantivos en plural y verbos HTTP para representar las acciones.
- `POST` se utiliza para crear recursos.
- `GET` se utiliza para leer recursos.
- `PATCH` se utiliza para actualizar parcialmente recursos.
- Se utiliza `PATCH` en lugar de `PUT` para las operaciones de actualización de estado y asignación porque no reemplazan el ticket completo.
- El diseño actual utiliza identificación por DNI y no incorpora autenticación tradicional.
- Se eliminó el prefijo `/api/v1/` de todos los endpoints: para un proyecto de este alcance no aporta valor y solo agrega ruido a las rutas. Si en el futuro conviven varias versiones de la API, se puede reincorporar como `/v1/`, `/v2/`, etc.
- Si el proyecto incorpora roles y autenticación en una etapa posterior, se podrían sumar los endpoints `/auth/login` y `/auth/logout`. En ese escenario, cada request podría llevar un token en el header `Authorization`.
