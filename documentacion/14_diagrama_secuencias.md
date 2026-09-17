### 2. Crear Ticket (Duplicado provisto)

```mermaid
sequenceDiagram
actor Cliente
participant Sistema as Sistema (API)
participant BD as Base de Datos
Cliente->>Sistema: Completa asunto, descripción, categoría
Sistema->>Sistema: Valida campos obligatorios
Sistema->>BD: Crea el ticket
BD-->>Sistema: ID único, estado inicial "Abierto"
Sistema-->>Cliente: Confirmación + número de ticket
```

---

### 3. Actualizar Estado

```mermaid
sequenceDiagram
actor Agente
participant Sistema as Sistema (API)
actor Cliente
Agente->>Sistema: Cambia el estado del ticket
Sistema->>Sistema: Actualiza estado (menos de 2 segundos)
Sistema-->>Agente: Confirmación
Cliente->>Sistema: Consulta el ticket
Sistema-->>Cliente: Muestra el nuevo estado
```

---

### 4. Agregar Comentario

```mermaid
sequenceDiagram
actor Usuario as Cliente / Agente
participant Sistema as Sistema (API)
participant BD as Base de Datos
Usuario->>Sistema: Escribe comentario y confirma
Sistema->>BD: Guarda comentario con autor y fecha
BD-->>Sistema: Confirmación
Sistema-->>Usuario: Comentario visible en el historial

