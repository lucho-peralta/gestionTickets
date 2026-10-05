# language: es
Característica: Reporte de top de categorías

  Escenario: Obtener las categorías con más tickets

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con categoría "conexion"
    Entonces la creación debe ser exitosa

    Cuando se solicita el top de categorías sin indicar cantidad
    Entonces la solicitud debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta
    Y el reporte debe contener 3 categorías
    Y cada categoría debe tener nombre y cantidad

    Cuando se solicita el top de 2 categorías
    Entonces la solicitud debe ser exitosa
    Y el reporte debe contener 2 categorías
