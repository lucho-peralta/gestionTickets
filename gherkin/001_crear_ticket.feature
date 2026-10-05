# language: es
Característica: Crear ticket

  Escenario: El cliente crea un ticket y el sistema le asigna un agente

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con DNI "30123456", categoría "conexion" y descripción "No tengo internet desde ayer a la noche."
    Entonces la creación debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta
    Y el ID del ticket debe ser un entero
    Y el ID del ticket se guarda como "id"
    Y el DNI del cliente debe ser "30123456"
    Y la categoría debe ser "conexion"
    Y el estado debe ser "asignado"
    Y la fecha de inicio debe ser una fecha válida
    Y la fecha de finalización debe estar vacía
    Y el ticket debe tener un agente con DNI de 7 u 8 dígitos y nombre
