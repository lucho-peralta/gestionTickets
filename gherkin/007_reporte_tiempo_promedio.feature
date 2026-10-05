# language: es
Característica: Reporte de tiempo promedio de resolución

  Escenario: Obtener el tiempo promedio de los tickets cerrados

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con categoría "conexion"
    Entonces la creación debe ser exitosa
    Y el ID del ticket se guarda como "id"

    Cuando el cliente cambia el estado del ticket "id" a "cerrado"
    Entonces la solicitud debe ser exitosa
    Y el estado debe ser "cerrado"

    Cuando se solicita el reporte de tiempo promedio de resolución
    Entonces la solicitud debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta
    Y la categoría del reporte debe estar vacía
    Y la cantidad de tickets cerrados debe ser mayor o igual a 1
    Y el promedio en horas debe ser un número mayor o igual a 0

    Cuando se solicita el reporte de tiempo promedio para la categoría "conexion"
    Entonces la solicitud debe ser exitosa
    Y la cantidad de tickets cerrados debe ser un entero
