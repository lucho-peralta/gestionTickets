# language: es
Característica: Reporte de frecuencia por categoría

  Escenario: Obtener la cantidad de tickets de cada categoría

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con categoría "conexion"
    Entonces la creación debe ser exitosa

    Cuando se solicita el reporte de frecuencia por categoría
    Entonces la solicitud debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta
    Y el reporte debe contener las 4 categorías: "conexion", "facturacion", "consulta_general" y "otro"
    Y la cantidad de cada categoría debe ser un entero
